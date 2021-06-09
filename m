Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C10E13A109D
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 12:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238435AbhFIJyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 05:54:31 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:36312 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234390AbhFIJy3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 05:54:29 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1599peam012994;
        Wed, 9 Jun 2021 09:52:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=L0iHNQ1Q5+MsI4CS1WUU69bxPrhaX+CRoYUVxNmpXCY=;
 b=IwNv9YBIcEKdQI9dJk5LeoSRatPi5FmXdIxuxttIZAZzaVCQusN6EGXgwEgPnvoReA6U
 UOYm/bEvGQ9q5LzBe7PMO0PlANibDVIzv5QjVKrP6kvQHWJ9g+JTLQcqF7xu8IQZqmIu
 +twjLNX6aWSEmV1S1zVG8w2M84AmvENYfx/C+pkN58AB0ppG4aBStE/QRCZKr4Ctl36g
 9UFX25FpQUUFaWHfuZpHKS3cpIWZkc8/BGLPS2JbGk/DoMS0Tmry23rUHkJsy+PPTsAe
 5nZ64AerfP9pK2X4UQsQUTL3qibBhGorpFpuyRtdztjrUlrzSg53wNQoqKGVOx/JIG6o kA== 
Received: from oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 392ptc83rn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Jun 2021 09:52:25 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 1599pnFp007005;
        Wed, 9 Jun 2021 09:52:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 3922wug2mh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Jun 2021 09:52:25 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 1599qO8X010928;
        Wed, 9 Jun 2021 09:52:24 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 3922wug2kk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Jun 2021 09:52:24 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 1599qKTs023002;
        Wed, 9 Jun 2021 09:52:20 GMT
Received: from mwanda (/41.212.42.34)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Jun 2021 02:52:19 -0700
Date:   Wed, 9 Jun 2021 12:52:12 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Yang Yingliang <yangyingliang@huawei.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH 1/2 net-next] net: dsa: qca8k: fix an endian bug in
 qca8k_get_ethtool_stats()
Message-ID: <YMCPTLkZumD3Vv/X@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-ORIG-GUID: GSl0_WKBTC5_G0XbDKkODo5dcjw1Yl7V
X-Proofpoint-GUID: GSl0_WKBTC5_G0XbDKkODo5dcjw1Yl7V
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "hi" variable is a u64 but the qca8k_read() writes to the top 32
bits of it.  That will work on little endian systems but it's a bit
subtle.  It's cleaner to make declare "hi" as a u32.  We will still need
to cast it when we shift it later on in the function but that's fine.

Fixes: 7c9896e37807 ("net: dsa: qca8k: check return value of read functions correctly")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/dsa/qca8k.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 6fe963ba23e8..9df3514d1ff2 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1412,7 +1412,7 @@ qca8k_get_ethtool_stats(struct dsa_switch *ds, int port,
 	struct qca8k_priv *priv = (struct qca8k_priv *)ds->priv;
 	const struct qca8k_mib_desc *mib;
 	u32 reg, i, val;
-	u64 hi = 0;
+	u32 hi = 0;
 	int ret;
 
 	for (i = 0; i < ARRAY_SIZE(ar8327_mib); i++) {
@@ -1424,14 +1424,14 @@ qca8k_get_ethtool_stats(struct dsa_switch *ds, int port,
 			continue;
 
 		if (mib->size == 2) {
-			ret = qca8k_read(priv, reg + 4, (u32 *)&hi);
+			ret = qca8k_read(priv, reg + 4, &hi);
 			if (ret < 0)
 				continue;
 		}
 
 		data[i] = val;
 		if (mib->size == 2)
-			data[i] |= hi << 32;
+			data[i] |= (u64)hi << 32;
 	}
 }
 
-- 
2.30.2

