Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2A683AF0E
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 08:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387803AbfFJGiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 02:38:50 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:51654 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387718AbfFJGir (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 02:38:47 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5A6cWcZ123745;
        Mon, 10 Jun 2019 06:38:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2018-07-02;
 bh=+dBz/3MNw5n0r9FD7awwMEqDZH96bQi0PjZ/mMWOBTA=;
 b=UMpimt6goJd1M1IRW2emxmRbSyJRtPyJWIc/eWW0kWfO24KBkQFWnwn6KeMpBi/jhxbM
 5c82qiqtuEm/9/Iw5ajIWfep/dLLZGay+GWONKOYhrAphHcS+/5KnGxhQ3XquYJi2z9R
 ArGqdvw1UxcwO900kH2uEgKkH0qauquQOd04IdDuCXpxdhPVk2EOuew4MJ1KaV46n4nB
 OU6sqp9PxGrRXN9XbYAMjWLjRw977QZ9hByiknUuY4g+HDyRHvSgHZl/5rJS5bBsOEIq
 WaBBAkOqGXPmFVkLGdxLmQ2MKr2EOPqnmt6C151I5eO2N6J+LCJRPC2oiIfDPSbBSxyf 3w== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 2t02hed743-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jun 2019 06:38:44 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5A6cipH123212;
        Mon, 10 Jun 2019 06:38:44 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2t04bm4spd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jun 2019 06:38:43 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5A6cg1W004331;
        Mon, 10 Jun 2019 06:38:42 GMT
Received: from jw-M900.cn.oracle.com (/10.182.69.163)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 09 Jun 2019 23:38:42 -0700
From:   Jacob Wen <jian.w.wen@oracle.com>
To:     netdev@vger.kernel.org
Cc:     john.r.fastabend@intel.com
Subject: [PATCH net] net_sched: sch_mqprio: handle return value of mqprio_queue_get
Date:   Mon, 10 Jun 2019 14:38:21 +0800
Message-Id: <20190610063821.27007-1-jian.w.wen@oracle.com>
X-Mailer: git-send-email 2.17.1
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9283 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906100046
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9283 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906100046
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It may return NULL thus we can't ignore it.
---
 net/sched/sch_mqprio.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_mqprio.c b/net/sched/sch_mqprio.c
index d05086dc3866..d926056f72ac 100644
--- a/net/sched/sch_mqprio.c
+++ b/net/sched/sch_mqprio.c
@@ -491,9 +491,12 @@ static int mqprio_dump_class(struct Qdisc *sch, unsigned long cl,
 			 struct sk_buff *skb, struct tcmsg *tcm)
 {
 	if (cl < TC_H_MIN_PRIORITY) {
-		struct netdev_queue *dev_queue = mqprio_queue_get(sch, cl);
 		struct net_device *dev = qdisc_dev(sch);
 		int tc = netdev_txq_to_tc(dev, cl - 1);
+		struct netdev_queue *dev_queue = mqprio_queue_get(sch, cl);
+
+		if (!dev_queue)
+			return -EINVAL;
 
 		tcm->tcm_parent = (tc < 0) ? 0 :
 			TC_H_MAKE(TC_H_MAJ(sch->handle),
@@ -558,6 +561,8 @@ static int mqprio_dump_class_stats(struct Qdisc *sch, unsigned long cl,
 			return -1;
 	} else {
 		struct netdev_queue *dev_queue = mqprio_queue_get(sch, cl);
+		if (!dev_queue)
+			return -1;
 
 		sch = dev_queue->qdisc_sleeping;
 		if (gnet_stats_copy_basic(qdisc_root_sleeping_running(sch),
-- 
2.17.1

