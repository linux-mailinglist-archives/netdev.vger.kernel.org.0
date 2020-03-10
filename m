Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7938C1803FE
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 17:53:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbgCJQxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 12:53:50 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:13772 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726307AbgCJQxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 12:53:50 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02AGr8Zx018160
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 12:53:45 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ym8k914sv-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 12:53:43 -0400
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Tue, 10 Mar 2020 16:53:41 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 10 Mar 2020 16:53:37 -0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02AGrapC40894824
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Mar 2020 16:53:36 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7655042041;
        Tue, 10 Mar 2020 16:53:36 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1885042047;
        Tue, 10 Mar 2020 16:53:36 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 10 Mar 2020 16:53:36 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [PATCH net-next] net: sched: make newly activated qdiscs visible
Date:   Tue, 10 Mar 2020 17:53:35 +0100
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
x-cbid: 20031016-0016-0000-0000-000002EF14A7
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20031016-0017-0000-0000-0000335279BD
Message-Id: <20200310165335.88715-1-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-10_11:2020-03-10,2020-03-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 impostorscore=0
 bulkscore=0 priorityscore=1501 adultscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003100103
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In their .attach callback, mq[prio] only add the qdiscs of the currently
active TX queues to the device's qdisc hash list.
If a user later increases the number of active TX queues, their qdiscs
are not visible via eg. 'tc qdisc show'.

Add a hook to netif_set_real_num_tx_queues() that walks all active
TX queues and adds those which are missing to the hash list.

CC: Eric Dumazet <edumazet@google.com>
CC: Jamal Hadi Salim <jhs@mojatatu.com>
CC: Cong Wang <xiyou.wangcong@gmail.com>
CC: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 include/net/sch_generic.h |  6 ++++++
 net/core/dev.c            |  1 +
 net/sched/sch_generic.c   | 21 +++++++++++++++++++++
 3 files changed, 28 insertions(+)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 151208704ed2..7bfc45c5b602 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -153,6 +153,11 @@ static inline bool qdisc_is_empty(const struct Qdisc *qdisc)
 	return !READ_ONCE(qdisc->q.qlen);
 }
 
+static inline bool qdisc_hashed(struct Qdisc *qdisc)
+{
+	return hash_hashed(&qdisc->hash);
+}
+
 static inline bool qdisc_run_begin(struct Qdisc *qdisc)
 {
 	if (qdisc->flags & TCQ_F_NOLOCK) {
@@ -629,6 +634,7 @@ void qdisc_class_hash_grow(struct Qdisc *, struct Qdisc_class_hash *);
 void qdisc_class_hash_destroy(struct Qdisc_class_hash *);
 
 int dev_qdisc_change_tx_queue_len(struct net_device *dev);
+void dev_qdisc_set_real_num_tx_queues(struct net_device *dev);
 void dev_init_scheduler(struct net_device *dev);
 void dev_shutdown(struct net_device *dev);
 void dev_activate(struct net_device *dev);
diff --git a/net/core/dev.c b/net/core/dev.c
index 25dab1598803..ccc03abeee52 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2875,6 +2875,7 @@ int netif_set_real_num_tx_queues(struct net_device *dev, unsigned int txq)
 			netif_setup_tc(dev, txq);
 
 		dev->real_num_tx_queues = txq;
+		dev_qdisc_set_real_num_tx_queues(dev);
 
 		if (disabling) {
 			synchronize_net();
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 6c9595f1048a..36a40ebcf0ee 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1268,6 +1268,27 @@ int dev_qdisc_change_tx_queue_len(struct net_device *dev)
 	return ret;
 }
 
+void dev_qdisc_set_real_num_tx_queues(struct net_device *dev)
+{
+#ifdef CONFIG_NET_SCHED
+	struct Qdisc *sch = dev->qdisc;
+	unsigned int ntx;
+
+	if (!sch)
+		return;
+
+	ASSERT_RTNL();
+
+	for (ntx = 0; ntx < dev->real_num_tx_queues; ntx++) {
+		struct netdev_queue *dev_queue = netdev_get_tx_queue(dev, ntx);
+		struct Qdisc *qdisc = dev_queue->qdisc;
+
+		if (qdisc && !qdisc_hashed(qdisc))
+			qdisc_hash_add(qdisc, false);
+	}
+#endif
+}
+
 static void dev_init_scheduler_queue(struct net_device *dev,
 				     struct netdev_queue *dev_queue,
 				     void *_qdisc)
-- 
2.17.1

