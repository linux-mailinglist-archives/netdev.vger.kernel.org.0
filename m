Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BFC82D29E
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 02:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbfE1X7v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 19:59:51 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45990 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726512AbfE1X7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 19:59:51 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4SNq4da018941
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 16:59:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=gOGg4avE0RB45Mv56jyQAJlkZ+cfc3yOdHEdLJfOJq4=;
 b=rNFH2+Z4RjNKa8sHX5R7aWxKOkYHVo3T2oaY6SgnhY08MLrLwbY64H/ihfvLWHQwut0i
 6phjILsrMGpikozUENeKom/bvxgeB+GTRziv1mAkkYH6gUCggclHrbrB1I38+8lU12+J
 +yeqQ5WiBFUbrFsYRimJCuXmeYUJykAvtUU= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0b-00082601.pphosted.com with ESMTP id 2ssckegg5y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 16:59:49 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Tue, 28 May 2019 16:59:47 -0700
Received: by devbig009.ftw2.facebook.com (Postfix, from userid 10340)
        id E9A4A5AE2482; Tue, 28 May 2019 16:59:44 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   brakmo <brakmo@fb.com>
Smtp-Origin-Hostname: devbig009.ftw2.facebook.com
To:     netdev <netdev@vger.kernel.org>
CC:     Martin Lau <kafai@fb.com>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v4 bpf-next 0/6] bpf: Propagate cn to TCP
Date:   Tue, 28 May 2019 16:59:34 -0700
Message-ID: <20190528235940.1452963-1-brakmo@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-28_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=339 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905280151
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adds support for propagating congestion notifications (cn)
to TCP from cgroup inet skb egress BPF programs.

Current cgroup skb BPF programs cannot trigger TCP congestion window
reductions, even when they drop a packet. This patch-set adds support
for cgroup skb BPF programs to send congestion notifications in the
return value when the packets are TCP packets. Rather than the
current 1 for keeping the packet and 0 for dropping it, they can
now return:
    NET_XMIT_SUCCESS    (0)    - continue with packet output
    NET_XMIT_DROP       (1)    - drop packet and do cn
    NET_XMIT_CN         (2)    - continue with packet output and do cn
    -EPERM                     - drop packet

Finally, HBM programs are modified to collect and return more
statistics.

There has been some discussion regarding the best place to manage
bandwidths. Some believe this should be done in the qdisc where it can
also be managed with a BPF program. We believe there are advantages
for doing it with a BPF program in the cgroup/skb callback. For example,
it reduces overheads in the cases where there is on primary workload and
one or more secondary workloads, where each workload is running on its
own cgroupv2. In this scenario, we only need to throttle the secondary
workloads and there is no overhead for the primary workload since there
will be no BPF program attached to its cgroup.

Regardless, we agree that this mechanism should not penalize those that
are not using it. We tested this by doing 1 byte req/reply RPCs over
loopback. Each test consists of 30 sec of back-to-back 1 byte RPCs.
Each test was repeated 50 times with a 1 minute delay between each set
of 10. We then calculated the average RPCs/sec over the 50 tests. We
compare upstream with upstream + patchset and no BPF program as well
as upstream + patchset and a BPF program that just returns ALLOW_PKT.
Here are the results:

upstream                           80937 RPCs/sec
upstream + patches, no BPF program 80894 RPCs/sec
upstream + patches, BPF program    80634 RPCs/sec

These numbers indicate that there is no penalty for these patches

The use of congestion notifications improves the performance of HBM when
using Cubic. Without congestion notifications, Cubic will not decrease its
cwnd and HBM will need to drop a large percentage of the packets.

The following results are obtained for rate limits of 1Gbps,
between two servers using netperf, and only one flow. We also show how
reducing the max delayed ACK timer can improve the performance when
using Cubic.

Command used was:
  ./do_hbm_test.sh -l -D --stats -N -r=<rate> [--no_cn] [dctcp] \
                   -s=<server running netserver>
  where:
     <rate>   is 1000
     --no_cn  specifies no cwr notifications
     dctcp    uses dctcp

                       Cubic                    DCTCP
Lim, DA      Mbps cwnd cred drops  Mbps cwnd cred drops
--------     ---- ---- ---- -----  ---- ---- ---- -----
  1G, 40       35  462 -320 67%     995    1 -212  0.05%
  1G, 40,cn   736    9  -78  0.07   995    1 -212  0.05
  1G,  5,cn   941    2 -189  0.13   995    1 -212  0.05

Notes:
  --no_cn has no effect with DCTCP
  Lim = rate limit
  DA = maximum delay ack timer
  cred = credit in packets
  drops = % packets dropped

v1->v2: Insures that only BPF_CGROUP_INET_EGRESS can return values 2 and 3
        New egress values apply to all protocols, not just TCP
        Cleaned up patch 4, Update BPF_CGROUP_RUN_PROG_INET_EGRESS callers
        Removed changes to __tcp_transmit_skb (patch 5), no longer needed
        Removed sample use of EDT
v2->v3: Removed the probe timer related changes
v3->v4: Replaced preempt_enable_no_resched() by preempt_enable()
        in BPF_PROG_CGROUP_INET_EGRESS_RUN_ARRAY() macro

brakmo (6):
  bpf: Create BPF_PROG_CGROUP_INET_EGRESS_RUN_ARRAY
  bpf: cgroup inet skb programs can return 0 to 3
  bpf: Update __cgroup_bpf_run_filter_skb with cn
  bpf: Update BPF_CGROUP_RUN_PROG_INET_EGRESS calls
  bpf: Add cn support to hbm_out_kern.c
  bpf: Add more stats to HBM

 include/linux/bpf.h        | 50 +++++++++++++++++++++++++++++
 include/linux/filter.h     |  3 +-
 kernel/bpf/cgroup.c        | 25 ++++++++++++---
 kernel/bpf/syscall.c       | 12 +++++++
 kernel/bpf/verifier.c      | 16 +++++++--
 net/ipv4/ip_output.c       | 34 +++++++++++++-------
 net/ipv6/ip6_output.c      | 26 +++++++++------
 samples/bpf/do_hbm_test.sh | 10 ++++--
 samples/bpf/hbm.c          | 51 +++++++++++++++++++++++++++--
 samples/bpf/hbm.h          |  9 +++++-
 samples/bpf/hbm_kern.h     | 66 ++++++++++++++++++++++++++++++++++++--
 samples/bpf/hbm_out_kern.c | 48 +++++++++++++++++++--------
 12 files changed, 299 insertions(+), 51 deletions(-)

-- 
2.17.1

