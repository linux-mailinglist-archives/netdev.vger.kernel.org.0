Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C20332FBE1A
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 18:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbhASPKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 10:10:32 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:32896 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390743AbhASPIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 10:08:20 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10JF5TwT156765;
        Tue, 19 Jan 2021 15:07:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=SW8RyFTl7bFQwFjQ7nQdX49WyrQr5v1lUUM68Sz/uz0=;
 b=AtTS33arZePZELPI4yQY+GAJY9/1qk29HkYMpXy2CMFZZ6BfuNg4AeLmAnkf9nlahCB+
 So2jnkpBHNJQuZ5Hk3QOExTar/Qv2PmqnMPV7zrR4vRkt22CW5CXWuiaNwNTSUrlvjj6
 H3OEgcLCIyTlkY6UcuzhyGyu+JfkkgRhAveYnKDNQyOM1BdSuS3Nr11JzLOz+cRtq26z
 s3nRGs+ELYA/jghmvVslMUIaBJ3kDs5I8MGMAsuhbsQd0OHELF8B/I2PmgqIiV5600Uk
 GGuaZlY2/jnH3uJU2Y/IzCi5d3L7mOxjOg8WczDyLQ4fzBoRnHc1vFusv2SZ2UlaYm8l Ag== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 363xyhrth0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jan 2021 15:07:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10JF6tqT050272;
        Tue, 19 Jan 2021 15:07:24 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 3649qpacvy-460
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jan 2021 15:07:24 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 10JEm9qJ015716;
        Tue, 19 Jan 2021 14:48:10 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 Jan 2021 06:48:09 -0800
Date:   Tue, 19 Jan 2021 17:48:03 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] net: dsa: b53: fix an off by one in checking "vlan->vid"
Message-ID: <YAbxI97Dl/pmBy5V@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9868 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 adultscore=0
 malwarescore=0 bulkscore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101190092
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9868 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 mlxlogscore=999 bulkscore=0 priorityscore=1501 spamscore=0
 mlxscore=0 impostorscore=0 lowpriorityscore=0 suspectscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101190092
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The > comparison should be >= to prevent accessing one element beyond
the end of the dev->vlans[] array in the caller function, b53_vlan_add().
The "dev->vlans" array is allocated in the b53_switch_init() function
and it has "dev->num_vlans" elements.

Fixes: a2482d2ce349 ("net: dsa: b53: Plug in VLAN support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/dsa/b53/b53_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 288b5a5c3e0d..95c7fa171e35 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1404,7 +1404,7 @@ int b53_vlan_prepare(struct dsa_switch *ds, int port,
 	    !(vlan->flags & BRIDGE_VLAN_INFO_UNTAGGED))
 		return -EINVAL;
 
-	if (vlan->vid_end > dev->num_vlans)
+	if (vlan->vid_end >= dev->num_vlans)
 		return -ERANGE;
 
 	b53_enable_vlan(dev, true, ds->vlan_filtering);
-- 
2.29.2

