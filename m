Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC7212BB77
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 22:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbfL0Vuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 16:50:39 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:7132 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726075AbfL0Vuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Dec 2019 16:50:39 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xBRLbiBd028102
        for <netdev@vger.kernel.org>; Fri, 27 Dec 2019 13:50:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=42U/AWcx45BmaG71YI4P36p9E78t6ZZ7/xr+HfVBe0Q=;
 b=MghpoCg0hBnbF9SXafhhnPBCxXrw7y8dWWN5y0z7f84c8OQyoO/g/qCMixTkzBQCFSzh
 IsuCxdT/vnnCKxR3h1GXJ4S1XZL0gwbrmle2S2pkG64dWTplWxf0JdHOZ9Sbvbz17DRd
 cePC6rkK68iAnrzOUhR5XztZRtUwXTg2VCU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2x5rkq0acg-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 27 Dec 2019 13:50:37 -0800
Received: from intmgw003.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 27 Dec 2019 13:50:37 -0800
Received: by devvm2643.prn2.facebook.com (Postfix, from userid 111017)
        id 3D9041CB1BED8; Fri, 27 Dec 2019 13:50:35 -0800 (PST)
Smtp-Origin-Hostprefix: devvm
From:   Roman Gushchin <guro@fb.com>
Smtp-Origin-Hostname: devvm2643.prn2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        <linux-kernel@vger.kernel.org>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>, Roman Gushchin <guro@fb.com>,
        <stable@vger.kernel.org>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf] bpf: cgroup: prevent out-of-order release of cgroup bpf
Date:   Fri, 27 Dec 2019 13:50:34 -0800
Message-ID: <20191227215034.3169624-1-guro@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-27_07:2019-12-24,2019-12-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 clxscore=1015
 malwarescore=0 suspectscore=38 spamscore=0 mlxscore=0 mlxlogscore=381
 adultscore=0 impostorscore=0 lowpriorityscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912270175
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before commit 4bfc0bb2c60e ("bpf: decouple the lifetime of cgroup_bpf
from cgroup itself") cgroup bpf structures were released with
corresponding cgroup structures. It guaranteed the hierarchical order
of destruction: children were always first. It preserved attached
programs from being released before their propagated copies.

But with cgroup auto-detachment there are no such guarantees anymore:
cgroup bpf is released as soon as the cgroup is offline and there are
no live associated sockets. It means that an attached program can be
detached and released, while its propagated copy is still living
in the cgroup subtree. This will obviously lead to an use-after-free
bug.

To reproduce the issue the following script can be used:

  #!/bin/bash

  CGROOT=/sys/fs/cgroup

  mkdir -p ${CGROOT}/A ${CGROOT}/B ${CGROOT}/A/C
  sleep 1

  ./test_cgrp2_attach ${CGROOT}/A egress &
  A_PID=$!
  ./test_cgrp2_attach ${CGROOT}/B egress &
  B_PID=$!

  echo $$ > ${CGROOT}/A/C/cgroup.procs
  iperf -s &
  S_PID=$!
  iperf -c localhost -t 100 &
  C_PID=$!

  sleep 1

  echo $$ > ${CGROOT}/B/cgroup.procs
  echo ${S_PID} > ${CGROOT}/B/cgroup.procs
  echo ${C_PID} > ${CGROOT}/B/cgroup.procs

  sleep 1

  rmdir ${CGROOT}/A/C
  rmdir ${CGROOT}/A

  sleep 1

  kill -9 ${S_PID} ${C_PID} ${A_PID} ${B_PID}

test_cgrp2_attach is an example from samples/bpf with the following
patch applied (required to close cgroup and bpf program file
descriptors after attachment):

diff --git a/samples/bpf/test_cgrp2_attach.c b/samples/bpf/test_cgrp2_attach.c
index 20fbd1241db3..7c7d0e91204d 100644
--- a/samples/bpf/test_cgrp2_attach.c
+++ b/samples/bpf/test_cgrp2_attach.c
@@ -111,6 +111,8 @@ static int attach_filter(int cg_fd, int type, int verdict)
                       strerror(errno));
                return EXIT_FAILURE;
        }
+       close(cg_fd);
+       close(prog_fd);
        while (1) {
                key = MAP_KEY_PACKETS;
                assert(bpf_map_lookup_elem(map_fd, &key, &pkt_cnt) == 0);

On the unpatched kernel the following stacktrace can be obtained:

[   33.619799] BUG: unable to handle page fault for address: ffffbdb4801ab002
[   33.620677] #PF: supervisor read access in kernel mode
[   33.621293] #PF: error_code(0x0000) - not-present page
[   33.621918] PGD 236d59067 P4D 236d59067 PUD 236d5c067 PMD 236d5d067 PTE 0
[   33.622754] Oops: 0000 [#1] SMP NOPTI
[   33.623202] CPU: 0 PID: 601 Comm: iperf Not tainted 5.5.0-rc2+ #23
[   33.623943] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20190727_073836-buildvm-ppc64le-16.ppc.f4
[   33.625545] RIP: 0010:__cgroup_bpf_run_filter_skb+0x29f/0x3d0
[   33.626231] Code: f6 0f 84 3a 01 00 00 49 8d 47 30 31 db 48 89 44 24 30 48 8b 45 08 65 48 89 05 4d 9d e0 64 48 8b d
[   33.628431] RSP: 0018:ffffbdb4802ffa90 EFLAGS: 00010246
[   33.629051] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000034
[   33.629906] RDX: 0000000000000000 RSI: ffff9ddf9d7a0000 RDI: ffff9ddf9b97f1c0
[   33.630761] RBP: ffff9ddf9d4899d0 R08: ffff9ddfb67ddd80 R09: 0000000000010000
[   33.631616] R10: 0000000000000070 R11: ffffbdb4802ffde8 R12: ffff9ddf9ba858e0
[   33.632463] R13: 0000000000000001 R14: ffffbdb4801ab000 R15: ffff9ddf9ba858e0
[   33.633306] FS:  00007f9d15ed9700(0000) GS:ffff9ddfb7c00000(0000) knlGS:0000000000000000
[   33.634262] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   33.634945] CR2: ffffbdb4801ab002 CR3: 000000021b94e000 CR4: 00000000003406f0
[   33.635809] Call Trace:
[   33.636118]  ? __cgroup_bpf_run_filter_skb+0x2bf/0x3d0
[   33.636728]  ? __switch_to_asm+0x40/0x70
[   33.637196]  ip_finish_output+0x68/0xa0
[   33.637654]  ip_output+0x76/0xf0
[   33.638046]  ? __ip_finish_output+0x1c0/0x1c0
[   33.638576]  __ip_queue_xmit+0x157/0x410
[   33.639049]  __tcp_transmit_skb+0x535/0xaf0
[   33.639557]  tcp_write_xmit+0x378/0x1190
[   33.640049]  ? _copy_from_iter_full+0x8d/0x260
[   33.640592]  tcp_sendmsg_locked+0x2a2/0xdc0
[   33.641098]  ? sock_has_perm+0x10/0xa0
[   33.641574]  tcp_sendmsg+0x28/0x40
[   33.641985]  sock_sendmsg+0x57/0x60
[   33.642411]  sock_write_iter+0x97/0x100
[   33.642876]  new_sync_write+0x1b6/0x1d0
[   33.643339]  vfs_write+0xb6/0x1a0
[   33.643752]  ksys_write+0xa7/0xe0
[   33.644156]  do_syscall_64+0x5b/0x1b0
[   33.644605]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fix this by grabbing a reference to the bpf structure of each ancestor
on the initialization of the cgroup bpf structure, and dropping the
reference at the end of releasing the cgroup bpf structure.

This will restore the hierarchical order of cgroup bpf releasing,
without adding any operations on hot paths.

Thanks to Josef Bacik for the debugging and the initial analysis of
the problem.

Fixes: 4bfc0bb2c60e ("bpf: decouple the lifetime of cgroup_bpf from cgroup itself")
Reported-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: stable@vger.kernel.org
---
 kernel/bpf/cgroup.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 4fb20ab179fe..9e43b72eb619 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -35,8 +35,8 @@ void cgroup_bpf_offline(struct cgroup *cgrp)
  */
 static void cgroup_bpf_release(struct work_struct *work)
 {
-	struct cgroup *cgrp = container_of(work, struct cgroup,
-					   bpf.release_work);
+	struct cgroup *p, *cgrp = container_of(work, struct cgroup,
+					       bpf.release_work);
 	enum bpf_cgroup_storage_type stype;
 	struct bpf_prog_array *old_array;
 	unsigned int type;
@@ -65,6 +65,9 @@ static void cgroup_bpf_release(struct work_struct *work)
 
 	mutex_unlock(&cgroup_mutex);
 
+	for (p = cgroup_parent(cgrp); p; p = cgroup_parent(p))
+		cgroup_bpf_put(p);
+
 	percpu_ref_exit(&cgrp->bpf.refcnt);
 	cgroup_put(cgrp);
 }
@@ -199,6 +202,7 @@ int cgroup_bpf_inherit(struct cgroup *cgrp)
  */
 #define	NR ARRAY_SIZE(cgrp->bpf.effective)
 	struct bpf_prog_array *arrays[NR] = {};
+	struct cgroup *p;
 	int ret, i;
 
 	ret = percpu_ref_init(&cgrp->bpf.refcnt, cgroup_bpf_release_fn, 0,
@@ -206,6 +210,9 @@ int cgroup_bpf_inherit(struct cgroup *cgrp)
 	if (ret)
 		return ret;
 
+	for (p = cgroup_parent(cgrp); p; p = cgroup_parent(p))
+		cgroup_bpf_get(p);
+
 	for (i = 0; i < NR; i++)
 		INIT_LIST_HEAD(&cgrp->bpf.progs[i]);
 
-- 
2.17.1

