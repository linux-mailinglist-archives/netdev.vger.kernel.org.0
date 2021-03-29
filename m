Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBED234D3AB
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 17:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbhC2PVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 11:21:21 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32350 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229628AbhC2PUy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 11:20:54 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12TF3aVY047260;
        Mon, 29 Mar 2021 11:20:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=TtToMWPYlyyGKFmt9lcXEYBKQ3nvsnYebkyKrx3OjBw=;
 b=COXX9l6kGqWVDKKIcAYiVUUzju7eeBG33nEQ/I5nAtW838OwWWNjixQ2xF5YCXgrA/iw
 oG460QTK9au0MTBODefBSZy2YV3rtFompJlsovTkFH4gSu5AF2Kgf2LfzJMVR5cYvlui
 GjjNbWYgJTZOMFridW7ksnykrgmLWcz0zLhbeVj2GweKcxxl0sDYesWdH3xCe2VtRciC
 7dag2yGyQt1aiMeko/E/PrDtfmsSAaVEPibqh1gRzjPOxE0WGLirDAJcOE9qdGNkTy85
 IPDg1vOCPc95UBFO69CrV2GJtwhvrl2NZsAPNMsFp4b71DC05VfqoOGfEH+KAvd2Ip8z pQ== 
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37jhsrurtb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Mar 2021 11:20:49 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12TFBgTc029969;
        Mon, 29 Mar 2021 15:20:48 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma03wdc.us.ibm.com with ESMTP id 37jqmmyawp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Mar 2021 15:20:48 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12TFKmqB8651454
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 29 Mar 2021 15:20:48 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DCE98124053;
        Mon, 29 Mar 2021 15:20:47 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE869124054;
        Mon, 29 Mar 2021 15:20:46 +0000 (GMT)
Received: from v0005c16.aus.stglabs.ibm.com (unknown [9.163.3.96])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 29 Mar 2021 15:20:46 +0000 (GMT)
From:   Eddie James <eajames@linux.ibm.com>
To:     sam@mendozajonas.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Milton Miller <miltonm@us.ibm.com>,
        Eddie James <eajames@linux.ibm.com>
Subject: [PATCH] net/ncsi: Avoid channel_monitor hrtimer deadlock
Date:   Mon, 29 Mar 2021 10:20:39 -0500
Message-Id: <20210329152039.15189-1-eajames@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: EhYCi-mAd2mOfMYoZv6WjQEfnxileLQa
X-Proofpoint-ORIG-GUID: EhYCi-mAd2mOfMYoZv6WjQEfnxileLQa
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-29_10:2021-03-26,2021-03-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 phishscore=0 impostorscore=0 bulkscore=0 suspectscore=0 clxscore=1011
 priorityscore=1501 mlxscore=0 mlxlogscore=999 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103290114
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Milton Miller <miltonm@us.ibm.com>

Calling ncsi_stop_channel_monitor from channel_monitor is a guaranteed
deadlock on SMP because stop calls del_timer_sync on the timer that
inoked channel_monitor as its timer function.

Recognise the inherent race of marking the monitor disabled before
deleting the timer by just returning if enable was cleared.  After
a timeout (the default case -- reset to START when response received)
just mark the monitor.enabled false.

If the channel has an entrie on the channel_queue list, or if the
state is not ACTIVE or INACTIVE, then warn and mark the timer stopped
and don't restart, as the locking is broken somehow.

Fixes: 0795fb2021f0 ("net/ncsi: Stop monitor if channel times out or is inactive")
Signed-off-by: Milton Miller <miltonm@us.ibm.com>
Signed-off-by: Eddie James <eajames@linux.ibm.com>
---
 net/ncsi/ncsi-manage.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/net/ncsi/ncsi-manage.c b/net/ncsi/ncsi-manage.c
index a9cb355324d1..ffff8da707b8 100644
--- a/net/ncsi/ncsi-manage.c
+++ b/net/ncsi/ncsi-manage.c
@@ -105,13 +105,20 @@ static void ncsi_channel_monitor(struct timer_list *t)
 	monitor_state = nc->monitor.state;
 	spin_unlock_irqrestore(&nc->lock, flags);
 
-	if (!enabled || chained) {
-		ncsi_stop_channel_monitor(nc);
-		return;
-	}
+	if (!enabled)
+		return;		/* expected race disabling timer */
+	if (WARN_ON_ONCE(chained))
+		goto bad_state;
+
 	if (state != NCSI_CHANNEL_INACTIVE &&
 	    state != NCSI_CHANNEL_ACTIVE) {
-		ncsi_stop_channel_monitor(nc);
+bad_state:
+		netdev_warn(ndp->ndev.dev,
+			    "Bad NCSI monitor state channel %d 0x%x %s queue\n",
+			    nc->id, state, chained ? "on" : "off");
+		spin_lock_irqsave(&nc->lock, flags);
+		nc->monitor.enabled = false;
+		spin_unlock_irqrestore(&nc->lock, flags);
 		return;
 	}
 
@@ -136,10 +143,9 @@ static void ncsi_channel_monitor(struct timer_list *t)
 		ncsi_report_link(ndp, true);
 		ndp->flags |= NCSI_DEV_RESHUFFLE;
 
-		ncsi_stop_channel_monitor(nc);
-
 		ncm = &nc->modes[NCSI_MODE_LINK];
 		spin_lock_irqsave(&nc->lock, flags);
+		nc->monitor.enabled = false;
 		nc->state = NCSI_CHANNEL_INVISIBLE;
 		ncm->data[2] &= ~0x1;
 		spin_unlock_irqrestore(&nc->lock, flags);
-- 
2.27.0

