Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E60926B876
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 02:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbgIPAoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 20:44:20 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:35888 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727080AbgIPAoN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 20:44:13 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08G0YQUk007357
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 17:44:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=YaJehtjt1XtzP2p0Y/w9m8My84sde/Cy8rxIRmWKGGM=;
 b=i9jfIw8e7L67ffFq/z6vxpgcd2ognf3PUNo/wzAYQDHQU3X008znrlqtQFZmFiI16LAV
 rAkuzyNKgcIVmdB8sWmIFL7hmT0UuOxduRE9w+BC0a+EUzeC3sXlFE6c6L3P929Ynbh0
 v9sFXw8zVR2ZoLz0v/7eDugIx/ynuY9Eq2Y= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33k5nbgsak-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 17:44:11 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 15 Sep 2020 17:44:10 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id BD6B33705B60; Tue, 15 Sep 2020 17:44:01 -0700 (PDT)
From:   Yonghong Song <yhs@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH bpf] bpf: fix a rcu warning for bpffs map pretty-print
Date:   Tue, 15 Sep 2020 17:44:01 -0700
Message-ID: <20200916004401.146277-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-15_14:2020-09-15,2020-09-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 priorityscore=1501 adultscore=0 malwarescore=0 impostorscore=0
 clxscore=1015 mlxlogscore=845 lowpriorityscore=0 phishscore=0 spamscore=0
 mlxscore=0 suspectscore=8 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009160001
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Running selftest
  ./btf_btf -p
the kernel had the following warning:
  [   51.528185] WARNING: CPU: 3 PID: 1756 at kernel/bpf/hashtab.c:717 ht=
ab_map_get_next_key+0x2eb/0x300
  [   51.529217] Modules linked in:
  [   51.529583] CPU: 3 PID: 1756 Comm: test_btf Not tainted 5.9.0-rc1+ #=
878
  [   51.530346] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), B=
IOS 1.9.3-1.el7.centos 04/01/2014
  [   51.531410] RIP: 0010:htab_map_get_next_key+0x2eb/0x300
  ...
  [   51.542826] Call Trace:
  [   51.543119]  map_seq_next+0x53/0x80
  [   51.543528]  seq_read+0x263/0x400
  [   51.543932]  vfs_read+0xad/0x1c0
  [   51.544311]  ksys_read+0x5f/0xe0
  [   51.544689]  do_syscall_64+0x33/0x40
  [   51.545116]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

The related source code in kernel/bpf/hashtab.c:
  709 static int htab_map_get_next_key(struct bpf_map *map, void *key, vo=
id *next_key)
  710 {
  711         struct bpf_htab *htab =3D container_of(map, struct bpf_htab=
, map);
  712         struct hlist_nulls_head *head;
  713         struct htab_elem *l, *next_l;
  714         u32 hash, key_size;
  715         int i =3D 0;
  716
  717         WARN_ON_ONCE(!rcu_read_lock_held());

In kernel/bpf/inode.c, bpffs map pretty print calls map->ops->map_get_nex=
t_key()
without holding a rcu_read_lock(), hence causing the above warning.
To fix the issue, just surrounding map->ops->map_get_next_key() with rcu =
read lock.

Reported-by: Alexei Starovoitov <ast@kernel.org>
Cc: Andrii Nakryiko <andriin@fb.com>
Cc: Martin KaFai Lau <kafai@fb.com>
Fixes: a26ca7c982cb ("bpf: btf: Add pretty print support to the basic arr=
aymap")
Signed-off-by: Yonghong Song <yhs@fb.com>
---
 kernel/bpf/inode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
index fb878ba3f22f..18f4969552ac 100644
--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -226,10 +226,12 @@ static void *map_seq_next(struct seq_file *m, void =
*v, loff_t *pos)
 	else
 		prev_key =3D key;
=20
+	rcu_read_lock();
 	if (map->ops->map_get_next_key(map, prev_key, key)) {
 		map_iter(m)->done =3D true;
-		return NULL;
+		key =3D NULL;
 	}
+	rcu_read_unlock();
 	return key;
 }
=20
--=20
2.24.1

