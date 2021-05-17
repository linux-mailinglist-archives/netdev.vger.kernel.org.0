Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92D723827A6
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 10:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235812AbhEQJAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 05:00:07 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:35628 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235510AbhEQJAG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 05:00:06 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14H8l004030473;
        Mon, 17 May 2021 08:58:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type : in-reply-to;
 s=corp-2020-01-29; bh=BmkRI2QJIX544Vr/gqGTFLcETOY1snYLn3dIrLvTSXs=;
 b=MUhrRwxhMqFc+7h3pfGd5i5bhKX00OPvJ9YcO42wu2aLRPdgUetRvxPxPMjQJsJa0J8M
 dX/2sNNtkN0vAgg1RSj4WMHY049S3CxRsWFX1xXp8MmN86nKKRt/NZhPOaY96YMc88K7
 JHilgVeUGjMtvvi1UWM4uS5t53sEDs/o2JUAnTQHBLbeStT/OV8hejDkzVr9CKOLhJ/O
 Di2HIBuNzdGrlOwNve1pp4eLS0TcnSSj3n/Jt2AHX8pSs34h2KeRxZviKICoVxYJ0lJ/
 ZGibK/po/q/QNiT4rtbEIDNxT/6pWmhLqixcdlOQ0XYE9qOINNPSiNQW5Os+w5Q51n7x Qg== 
Received: from oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 38j6usgmwa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 May 2021 08:58:46 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 14H8pwH0066457;
        Mon, 17 May 2021 08:58:45 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 38j4baytvb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 May 2021 08:58:45 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 14H8suq9070534;
        Mon, 17 May 2021 08:58:45 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 38j4baytv8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 May 2021 08:58:45 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 14H8wi7B009528;
        Mon, 17 May 2021 08:58:44 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 17 May 2021 08:58:44 +0000
Date:   Mon, 17 May 2021 11:58:37 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Chris Snook <chris.snook@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 2/2 net-next] alx: unlock on error in alx_set_pauseparam()
Message-ID: <YKIwPe2/k1R+PTWU@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YKIwFAmmm2W2XocO@mwanda>
X-Mailer: git-send-email haha only kidding
X-Proofpoint-GUID: _hlPJYDV7W9bnr2QOeY3AUvyoDj_picS
X-Proofpoint-ORIG-GUID: _hlPJYDV7W9bnr2QOeY3AUvyoDj_picS
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to drop the lock before returning on this error path.

Fixes: 4a5fe57e7751 ("alx: use fine-grained locking instead of RTNL")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/atheros/alx/ethtool.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/atheros/alx/ethtool.c b/drivers/net/ethernet/atheros/alx/ethtool.c
index f3627157a38a..b716adacd815 100644
--- a/drivers/net/ethernet/atheros/alx/ethtool.c
+++ b/drivers/net/ethernet/atheros/alx/ethtool.c
@@ -253,8 +253,10 @@ static int alx_set_pauseparam(struct net_device *netdev,
 
 	if (reconfig_phy) {
 		err = alx_setup_speed_duplex(hw, hw->adv_cfg, fc);
-		if (err)
+		if (err) {
+			mutex_unlock(&alx->mtx);
 			return err;
+		}
 	}
 
 	/* flow control on mac */
-- 
2.30.2

