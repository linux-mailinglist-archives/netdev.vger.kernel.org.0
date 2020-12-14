Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4912DA282
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 22:22:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503574AbgLNVUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 16:20:38 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:21106 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388027AbgLNVUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 16:20:16 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BEL0jgh127933;
        Mon, 14 Dec 2020 16:19:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=bS3VsFV+7RuJhvo6TiDT+URTbhFxHi00DyDxf7ajcr8=;
 b=YQaVwQdu/ZEjw5yHAjR0QZwHb9y1W4yVH2X9jfN5uB1eeyRw0hqgffBtGsLJTLkqR1Mq
 gU6eJCeV1BZXKLhlVwF9NxYqpWzwN2j4lyGZApSDePwfUuHP7iNBykVTzh0oQOSukAgC
 CxPbNIRYyPVyks7BvnTwosV9lPZmmjnAUMWHk640IruegniCbGusfSCoVZtOhR/g6sZp
 xJWX7PDw+QiWBvv2lPd2wNDYvY1sNDdG/bfZ1B/+rJwraOFfjPez8jrvkZTQSbSStcFp
 0Ce3ByEcvMXpgsyGud5cVwS+B1gExevkJPaoeFT7v5IkA7XqwokdthW4vzP+lhyh6W0Z lg== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35edr3unan-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Dec 2020 16:19:34 -0500
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BELGmeC019495;
        Mon, 14 Dec 2020 21:19:33 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma02dal.us.ibm.com with ESMTP id 35d525hqy5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Dec 2020 21:19:33 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BELJWI427591150
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Dec 2020 21:19:32 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6D7172805C;
        Mon, 14 Dec 2020 21:19:32 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 167DE28058;
        Mon, 14 Dec 2020 21:19:32 +0000 (GMT)
Received: from pompom.ibm.com (unknown [9.80.237.30])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 14 Dec 2020 21:19:32 +0000 (GMT)
From:   Lijun Pan <ljp@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     Lijun Pan <ljp@linux.ibm.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH net-next v2 3/3] use __netdev_notify_peers in hyperv
Date:   Mon, 14 Dec 2020 15:19:30 -0600
Message-Id: <20201214211930.80778-4-ljp@linux.ibm.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20201214211930.80778-1-ljp@linux.ibm.com>
References: <20201214211930.80778-1-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-14_11:2020-12-11,2020-12-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 impostorscore=0 mlxscore=0
 malwarescore=0 clxscore=1015 suspectscore=0 priorityscore=1501 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012140137
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Start to use the lockless version of netdev_notify_peers.
Call the helper where notify variable used to be set true.
Remove the notify bool variable and sort the variables
in reverse Christmas tree order.

Cc: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
---
v2: call the helper where notify variable used to be set true
    according to Jakub's review suggestion.

 drivers/net/hyperv/netvsc_drv.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index d17bbc75f5e7..f32f28311d57 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -2050,11 +2050,11 @@ static void netvsc_link_change(struct work_struct *w)
 		container_of(w, struct net_device_context, dwork.work);
 	struct hv_device *device_obj = ndev_ctx->device_ctx;
 	struct net_device *net = hv_get_drvdata(device_obj);
+	unsigned long flags, next_reconfig, delay;
+	struct netvsc_reconfig *event = NULL;
 	struct netvsc_device *net_device;
 	struct rndis_device *rdev;
-	struct netvsc_reconfig *event = NULL;
-	bool notify = false, reschedule = false;
-	unsigned long flags, next_reconfig, delay;
+	bool reschedule = false;
 
 	/* if changes are happening, comeback later */
 	if (!rtnl_trylock()) {
@@ -2103,7 +2103,7 @@ static void netvsc_link_change(struct work_struct *w)
 			netif_carrier_on(net);
 			netvsc_tx_enable(net_device, net);
 		} else {
-			notify = true;
+			__netdev_notify_peers(net);
 		}
 		kfree(event);
 		break;
@@ -2132,9 +2132,6 @@ static void netvsc_link_change(struct work_struct *w)
 
 	rtnl_unlock();
 
-	if (notify)
-		netdev_notify_peers(net);
-
 	/* link_watch only sends one notification with current state per
 	 * second, handle next reconfig event in 2 seconds.
 	 */
-- 
2.23.0

