Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 418FC183821
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 19:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgCLSCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 14:02:21 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:15748 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726362AbgCLSCV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 14:02:21 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02CHvFaA082100
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 14:02:20 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2yqsk70pra-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 14:02:20 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Thu, 12 Mar 2020 17:58:03 -0000
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 12 Mar 2020 17:58:00 -0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02CHvxle15073386
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 12 Mar 2020 17:57:59 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D9593A4051;
        Thu, 12 Mar 2020 17:57:59 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 980F1A4040;
        Thu, 12 Mar 2020 17:57:59 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 12 Mar 2020 17:57:59 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [PATCH net-next] Revert "net: sched: make newly activated qdiscs visible"
Date:   Thu, 12 Mar 2020 18:57:54 +0100
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
x-cbid: 20031217-0016-0000-0000-000002F00F36
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20031217-0017-0000-0000-000033537EB4
Message-Id: <20200312175754.41339-1-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-12_12:2020-03-11,2020-03-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 adultscore=0 bulkscore=0 impostorscore=0 clxscore=1015 lowpriorityscore=0
 mlxscore=0 mlxlogscore=999 spamscore=0 suspectscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003120092
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 4cda75275f9f89f9485b0ca4d6950c95258a9bce
from net-next.

Brown bag time.

Michal noticed that this change doesn't work at all when
netif_set_real_num_tx_queues() gets called prior to an initial
dev_activate(), as for instance igb does.

Doing so dies with:

[   40.579142] BUG: kernel NULL pointer dereference, address: 0000000000000400
[   40.586922] #PF: supervisor read access in kernel mode
[   40.592668] #PF: error_code(0x0000) - not-present page
[   40.598405] PGD 0 P4D 0
[   40.601234] Oops: 0000 [#1] PREEMPT SMP PTI
[   40.605909] CPU: 18 PID: 1681 Comm: wickedd Tainted: G            E     5.6.0-rc3-ethnl.50-default #1
[   40.616205] Hardware name: Intel Corporation S2600CP/S2600CP, BIOS RMLSDP.86I.R3.27.D685.1305151734 05/15/2013
[   40.627377] RIP: 0010:qdisc_hash_add.part.22+0x2e/0x90
[   40.633115] Code: 00 55 53 89 f5 48 89 fb e8 2f 9b fb ff 85 c0 74 44 48 8b 43 40 48 8b 08 69 43 38 47 86 c8 61 c1 e8 1c 48 83 e8 80 48 8d 14 c1 <48> 8b 04 c1 48 8d 4b 28 48 89 53 30 48 89 43 28 48 85 c0 48 89 0a
[   40.654080] RSP: 0018:ffffb879864934d8 EFLAGS: 00010203
[   40.659914] RAX: 0000000000000080 RBX: ffffffffb8328d80 RCX: 0000000000000000
[   40.667882] RDX: 0000000000000400 RSI: 0000000000000000 RDI: ffffffffb831faa0
[   40.675849] RBP: 0000000000000000 R08: ffffa0752c8b9088 R09: ffffa0752c8b9208
[   40.683816] R10: 0000000000000006 R11: 0000000000000000 R12: ffffa0752d734000
[   40.691783] R13: 0000000000000008 R14: 0000000000000000 R15: ffffa07113c18000
[   40.699750] FS:  00007f94548e5880(0000) GS:ffffa0752e980000(0000) knlGS:0000000000000000
[   40.708782] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   40.715189] CR2: 0000000000000400 CR3: 000000082b6ae006 CR4: 00000000001606e0
[   40.723156] Call Trace:
[   40.725888]  dev_qdisc_set_real_num_tx_queues+0x61/0x90
[   40.731725]  netif_set_real_num_tx_queues+0x94/0x1d0
[   40.737286]  __igb_open+0x19a/0x5d0 [igb]
[   40.741767]  __dev_open+0xbb/0x150
[   40.745567]  __dev_change_flags+0x157/0x1a0
[   40.750240]  dev_change_flags+0x23/0x60

[...]

Fixes: 4cda75275f9f ("net: sched: make newly activated qdiscs visible")
Reported-by: Michal Kubecek <mkubecek@suse.cz>
CC: Michal Kubecek <mkubecek@suse.cz>
CC: Eric Dumazet <edumazet@google.com>
CC: Jamal Hadi Salim <jhs@mojatatu.com>
CC: Cong Wang <xiyou.wangcong@gmail.com>
CC: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 include/net/sch_generic.h |  6 ------
 net/core/dev.c            |  1 -
 net/sched/sch_generic.c   | 21 ---------------------
 3 files changed, 28 deletions(-)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 7bfc45c5b602..151208704ed2 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -153,11 +153,6 @@ static inline bool qdisc_is_empty(const struct Qdisc *qdisc)
 	return !READ_ONCE(qdisc->q.qlen);
 }
 
-static inline bool qdisc_hashed(struct Qdisc *qdisc)
-{
-	return hash_hashed(&qdisc->hash);
-}
-
 static inline bool qdisc_run_begin(struct Qdisc *qdisc)
 {
 	if (qdisc->flags & TCQ_F_NOLOCK) {
@@ -634,7 +629,6 @@ void qdisc_class_hash_grow(struct Qdisc *, struct Qdisc_class_hash *);
 void qdisc_class_hash_destroy(struct Qdisc_class_hash *);
 
 int dev_qdisc_change_tx_queue_len(struct net_device *dev);
-void dev_qdisc_set_real_num_tx_queues(struct net_device *dev);
 void dev_init_scheduler(struct net_device *dev);
 void dev_shutdown(struct net_device *dev);
 void dev_activate(struct net_device *dev);
diff --git a/net/core/dev.c b/net/core/dev.c
index ccc03abeee52..25dab1598803 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2875,7 +2875,6 @@ int netif_set_real_num_tx_queues(struct net_device *dev, unsigned int txq)
 			netif_setup_tc(dev, txq);
 
 		dev->real_num_tx_queues = txq;
-		dev_qdisc_set_real_num_tx_queues(dev);
 
 		if (disabling) {
 			synchronize_net();
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 36a40ebcf0ee..6c9595f1048a 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1268,27 +1268,6 @@ int dev_qdisc_change_tx_queue_len(struct net_device *dev)
 	return ret;
 }
 
-void dev_qdisc_set_real_num_tx_queues(struct net_device *dev)
-{
-#ifdef CONFIG_NET_SCHED
-	struct Qdisc *sch = dev->qdisc;
-	unsigned int ntx;
-
-	if (!sch)
-		return;
-
-	ASSERT_RTNL();
-
-	for (ntx = 0; ntx < dev->real_num_tx_queues; ntx++) {
-		struct netdev_queue *dev_queue = netdev_get_tx_queue(dev, ntx);
-		struct Qdisc *qdisc = dev_queue->qdisc;
-
-		if (qdisc && !qdisc_hashed(qdisc))
-			qdisc_hash_add(qdisc, false);
-	}
-#endif
-}
-
 static void dev_init_scheduler_queue(struct net_device *dev,
 				     struct netdev_queue *dev_queue,
 				     void *_qdisc)
-- 
2.17.1

