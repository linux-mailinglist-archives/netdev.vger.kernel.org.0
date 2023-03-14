Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 725FD6B9953
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 16:32:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbjCNPc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 11:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbjCNPcZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 11:32:25 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on20609.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e1b::609])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93BDEB06C6;
        Tue, 14 Mar 2023 08:31:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SdI1BeoJHLXCo4dBgq43xzroaivPEXUo3dr9L0uszMkyTbQ04LtBqhf1a9q+yxpSu08VWNOYNGVo2ALsPA/dGnhMaiHLCHWmCBuO2yEvlH1ROW8yDkUQMie5FbMOxts4XIAtHwQPPbfEqK7d0Ofsb8grlidhjrmUt2CHsSRFJmIZycGY246XEjhTnCIPSE7Dxo+hOco1+zrQGyMDk+rCa37RnViwDIVgIaGokdA05DH89TBlkod8W7oYB5Dm4Gi2oqpYmbQdRjQlKgxED7Yhluy5JX1ePM3x2aURq4W9yLHEv4OPXfddWS5d7pEJzIdDtghLW0bwfoaiEkREUuJrnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qk2r6KYkNOwyNXdPOcdw1X2vVAJ+TEmGL08OgQu7efA=;
 b=nCKPPYGgxRPPAROuiPEyvlpjP6j3LmV3IzBfWicvllnruQS4/slRYoE4lHGHIJrxXLBz7VjRmz9sh8LyUYD5CZT+cG4Pea6nbTSRrYZ06u2H4yktmb5x8Noc/N5WHa2nYvdm88S03O205X/riJoh95S741g+4fDhDNt8Dl/eExXiG2QDETcDDC4tZ3BE/7y7Xd0D1Nl2Vp9dLo0HJjQDdpUGVDAZ+SdKoa8g9Xe5LJj1+jgYY7YEDcV4fqFSVwO7swkqrdfwk01A2pZYuofd2E/vQlp5PAQb+2ANVVRH711lwU7rTiPuF2znizp1AgUZepXuaqpyaxa3Xd1ggQbjHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qk2r6KYkNOwyNXdPOcdw1X2vVAJ+TEmGL08OgQu7efA=;
 b=TiaVwmWI7q6j75aE2chxIkSorX/fZ0/5VvcVZwnpus71KZAmXbGOBR6Tzknt0RyJKdkdWSVeafORa542PFhXBeaT+S4h0siiOwBmSq/xzSvVLlgWIvaPRXA+TsC2s2Gzs0FTT0lZJ7Tlonv5x+UAQxYnBxJAzT3kdRupcmUVOA8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by GVXPR04MB10021.eurprd04.prod.outlook.com (2603:10a6:150:112::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Tue, 14 Mar
 2023 15:31:12 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::29a3:120c:7d42:3ca8%7]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 15:31:12 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH net] net: phy: mscc: fix deadlock in phy_ethtool_{get,set}_wol()
Date:   Tue, 14 Mar 2023 17:30:25 +0200
Message-Id: <20230314153025.2372970-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BEXP281CA0017.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::27)
 To AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|GVXPR04MB10021:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a4a80f9-6825-45fa-e78c-08db24a1222f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BcDG50/UqkpjW+k4FmcNzE62PGzNjLZR/VT0NJ2s6eUsuCX6Z9ncT6oULpZa2ssc8ivBdt0EzgllJdiPiKPSFhV/CsvBlGB0a/wgUPbOwwTJQ8wcnTmPY3kGJshE4YeHf0Umx9nvnggHW+A48FHx7oyFhOPHanswcRDb6yHReHWccXaLpLDY5LEyaSd1OvRYGHaK495NJERUuM7KxWJB7wVT96dR2UzpWD/WnkLp8snyupgnbgbwvCIIzRMiImGhTNP0Bz8nasDZZwAEZzfwzmpqV+1jt6oa9t86JwDOLEWjk7K3jyxhOFl/LjDXQDXDBbRl5//aBt8ERt/qTwdDHHGtLa6VR1zcBlPlKaqmjxBOMQ3sxvSa4bjZaL2MjhWJ2wHtYXooy96h0Kk4C7FleQSvwAO8maLaOUMlhZmbg072KXDucKQ2dHWHNy3HzgQWYaeVJ5hzY1LYi0ooLbNZfviwNRq+v8AVoXRYhBlaWDSX0KxExKRQX98plrk9v7+cpMdwfGzbO29XzPM1OwioDAWFETa4hf3d56JwkrmqLswTttQ4MT7zwf7zg73jo3aLTVeaZr/EM8j87K/ytiduAMo3VwXfOYjn0ANT6B6KWa3/TtJX2tx3zTHYtdTosaG/mOeIJE9FNzKBNFC/Z3nu4skQSTkxEWKb+8+IRWRLWX9QG9l3xr/h0+ulZaJEpfUwbHI0GABCBW2Yn8CSFJvz+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(366004)(136003)(396003)(39860400002)(376002)(451199018)(54906003)(41300700001)(478600001)(66556008)(66476007)(4326008)(8676002)(8936002)(66946007)(6916009)(86362001)(38350700002)(38100700002)(36756003)(26005)(6512007)(186003)(6486002)(6666004)(52116002)(1076003)(5660300002)(44832011)(2906002)(316002)(6506007)(83380400001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IV8rTmOPtIy/VF4TcLzJRHaXHBzeTuYx3W6cUbqTWM/zuIEAdokpgjyyiA7T?=
 =?us-ascii?Q?MpHTKjfsY02JzU+E6t/I06RGDsvJuP+4KR4Ubz66skqCvfCl7kJ9EtSpe3Dq?=
 =?us-ascii?Q?wT160WLlccCviBnee1YMK+qiIQz2PR/VVYwBqSwejTUIg0FAqajP2kjHYbRQ?=
 =?us-ascii?Q?rK2d/W2aA+qA9b+1oXMiQtuA/5pSUGXENgvzeiWNn0vhGlhrzh9r0oaWLU7i?=
 =?us-ascii?Q?0AEDtir0jO8pVK+BTs37aUxVSKMj4652+8UEw/kpNSZM4EPoSZTZnwIhCal7?=
 =?us-ascii?Q?sTj/mnYOgDfPK66EKprmMD3clMedsC4yU4+k7YXTfDTPC3VMZvryB4Z+EEqt?=
 =?us-ascii?Q?168PglmIZyVcv4Tnei4wVeQTjOBg76c/8lN2kDxiQjm3vErWM/45qPKjExOV?=
 =?us-ascii?Q?lURunHi/3ErrC3iUxZVQxhdKB13SVlU9FjBY/oswx3u/teMrZ7rXuydQCIBl?=
 =?us-ascii?Q?dYPdRUOlZLGGlAXIfoNRu/s42WEx5tEe/2lybMRub0Ty/BfDjZ/7gz9yDKpD?=
 =?us-ascii?Q?9LgBiFTE2TkDu7ExQUDlu3ZVdSEZ1kAajrqkiMHUzU4bDGlrYDXumui8oqt9?=
 =?us-ascii?Q?+aDgRaO93gus2c1sMOO70raChc64s0eHtO0C3CrHy6xV2Kzf1u867sQiKD9A?=
 =?us-ascii?Q?TgRbaLf49IWOFxl7nB5wqt2hzRBq1oh+uqMPSu3l3NLIAjlAQPRldX1/GsYP?=
 =?us-ascii?Q?P4jM2i/spZ0qD32LJMu+N3JYHFaBkZSnfH14QV1v7pwFrkSnVZvnjTccHG64?=
 =?us-ascii?Q?4wu0vZeOGE9ds6Z858jiV12qvAcS1v0i3tDwGA2W+QO5nEzzU2ZC4FT26Kqk?=
 =?us-ascii?Q?+IJiYEdsttolawSjBbLye6TLmEnehLGSS+Eg434lc9FwvJrEagQiF/aEHqlz?=
 =?us-ascii?Q?K3pGRoBsFyscymcFCViJINxzqbdumezqqm+KhpIHHCOGtoNKfzLANWXOn7h4?=
 =?us-ascii?Q?or7pQo01I89byx9nQEaDr63jqLTnuHu71tT4l+D15LepJxqu6q5qOrkkm6eO?=
 =?us-ascii?Q?0HgdwXplvzW0LKJgHdq6pbYCGnnnWUoIzSpczkqc4AdSANluXNi/iVelMv5P?=
 =?us-ascii?Q?gm3YdWlCPJE26RD752B2M7Yqe6DYvxAr8sBAYm+WonfoL90YGoIPtFM2GJ52?=
 =?us-ascii?Q?QPS4n3aYI5g+IbWmb3H4bDYbzndSe27QxWvTwXnnBW/4oahz6cjduZt5EpDR?=
 =?us-ascii?Q?XMzg3HF3Hsb6hlG2QFmXPKBBRyzmdp0yCw6jaqVRn7fp3nXagqAGXWh31CAY?=
 =?us-ascii?Q?yQ+oHLTFArc3qrVHceXqHRF70hPhUnZ+CXYDZe1D6KAR0FOhYp1psZg8xNwj?=
 =?us-ascii?Q?X0voih9BSqa6HyfL45rNVemlNP0D9HFPhEoxtTVmbyCmXFwLcShzHPoim9HC?=
 =?us-ascii?Q?xR8f6XYMcMXWjKeoYAAURNvbm3I21uezS9wiT6PrJdgr956sCEBLUwJbAkB5?=
 =?us-ascii?Q?zvhEfp0fjwp7gS3y1Hv0QfT57qwvLEH487su7vhIip4DmWI8wY8iFJMB/U1p?=
 =?us-ascii?Q?aO/WATNVIj6uODKk8p5gy0fLQSxsSLxKEL/03osf5ybNwm1DWUlcwD4NPfFZ?=
 =?us-ascii?Q?BjGvIfabZrerWytwt3dE0mZnVux3j8TQDRqu8WBa9LsnE3nshSroMZZ7Q+xG?=
 =?us-ascii?Q?NA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a4a80f9-6825-45fa-e78c-08db24a1222f
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 15:31:12.3548
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9bV4kVXBgt1he6mYjzDpjJgto+IRfMOCZ+hH0h/OhfNWWu2Zsm/eLvFbBgrcEa+zrWD2tpYN9PipC/EWREcPaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR04MB10021
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        T_SPF_PERMERROR,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the blamed commit, phy_ethtool_get_wol() and phy_ethtool_set_wol()
acquire phydev->lock, but the mscc phy driver implementations,
vsc85xx_wol_get() and vsc85xx_wol_set(), acquire the same lock as well,
resulting in a deadlock.

$ ip link set swp3 down
============================================
WARNING: possible recursive locking detected
mscc_felix 0000:00:00.5 swp3: Link is Down
--------------------------------------------
ip/375 is trying to acquire lock:
ffff3d7e82e987a8 (&dev->lock){+.+.}-{4:4}, at: vsc85xx_wol_get+0x2c/0xf4

but task is already holding lock:
ffff3d7e82e987a8 (&dev->lock){+.+.}-{4:4}, at: phy_ethtool_get_wol+0x3c/0x6c

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&dev->lock);
  lock(&dev->lock);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

2 locks held by ip/375:
 #0: ffffd43b2a955788 (rtnl_mutex){+.+.}-{4:4}, at: rtnetlink_rcv_msg+0x144/0x58c
 #1: ffff3d7e82e987a8 (&dev->lock){+.+.}-{4:4}, at: phy_ethtool_get_wol+0x3c/0x6c

Call trace:
 __mutex_lock+0x98/0x454
 mutex_lock_nested+0x2c/0x38
 vsc85xx_wol_get+0x2c/0xf4
 phy_ethtool_get_wol+0x50/0x6c
 phy_suspend+0x84/0xcc
 phy_state_machine+0x1b8/0x27c
 phy_stop+0x70/0x154
 phylink_stop+0x34/0xc0
 dsa_port_disable_rt+0x2c/0xa4
 dsa_slave_close+0x38/0xec
 __dev_close_many+0xc8/0x16c
 __dev_change_flags+0xdc/0x218
 dev_change_flags+0x24/0x6c
 do_setlink+0x234/0xea4
 __rtnl_newlink+0x46c/0x878
 rtnl_newlink+0x50/0x7c
 rtnetlink_rcv_msg+0x16c/0x58c

Removing the mutex_lock(&phydev->lock) calls from the driver restores
the functionality.

Fixes: 2f987d486610 ("net: phy: Add locks to ethtool functions")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/phy/mscc/mscc_main.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index 8a13b1ad9a33..62bf99e45af1 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -280,12 +280,9 @@ static int vsc85xx_wol_set(struct phy_device *phydev,
 	u16 pwd[3] = {0, 0, 0};
 	struct ethtool_wolinfo *wol_conf = wol;
 
-	mutex_lock(&phydev->lock);
 	rc = phy_select_page(phydev, MSCC_PHY_PAGE_EXTENDED_2);
-	if (rc < 0) {
-		rc = phy_restore_page(phydev, rc, rc);
-		goto out_unlock;
-	}
+	if (rc < 0)
+		return phy_restore_page(phydev, rc, rc);
 
 	if (wol->wolopts & WAKE_MAGIC) {
 		/* Store the device address for the magic packet */
@@ -323,7 +320,7 @@ static int vsc85xx_wol_set(struct phy_device *phydev,
 
 	rc = phy_restore_page(phydev, rc, rc > 0 ? 0 : rc);
 	if (rc < 0)
-		goto out_unlock;
+		return rc;
 
 	if (wol->wolopts & WAKE_MAGIC) {
 		/* Enable the WOL interrupt */
@@ -331,22 +328,19 @@ static int vsc85xx_wol_set(struct phy_device *phydev,
 		reg_val |= MII_VSC85XX_INT_MASK_WOL;
 		rc = phy_write(phydev, MII_VSC85XX_INT_MASK, reg_val);
 		if (rc)
-			goto out_unlock;
+			return rc;
 	} else {
 		/* Disable the WOL interrupt */
 		reg_val = phy_read(phydev, MII_VSC85XX_INT_MASK);
 		reg_val &= (~MII_VSC85XX_INT_MASK_WOL);
 		rc = phy_write(phydev, MII_VSC85XX_INT_MASK, reg_val);
 		if (rc)
-			goto out_unlock;
+			return rc;
 	}
 	/* Clear WOL iterrupt status */
 	reg_val = phy_read(phydev, MII_VSC85XX_INT_STATUS);
 
-out_unlock:
-	mutex_unlock(&phydev->lock);
-
-	return rc;
+	return 0;
 }
 
 static void vsc85xx_wol_get(struct phy_device *phydev,
@@ -358,10 +352,9 @@ static void vsc85xx_wol_get(struct phy_device *phydev,
 	u16 pwd[3] = {0, 0, 0};
 	struct ethtool_wolinfo *wol_conf = wol;
 
-	mutex_lock(&phydev->lock);
 	rc = phy_select_page(phydev, MSCC_PHY_PAGE_EXTENDED_2);
 	if (rc < 0)
-		goto out_unlock;
+		goto out_restore_page;
 
 	reg_val = __phy_read(phydev, MSCC_PHY_WOL_MAC_CONTROL);
 	if (reg_val & SECURE_ON_ENABLE)
@@ -377,9 +370,8 @@ static void vsc85xx_wol_get(struct phy_device *phydev,
 		}
 	}
 
-out_unlock:
+out_restore_page:
 	phy_restore_page(phydev, rc, rc > 0 ? 0 : rc);
-	mutex_unlock(&phydev->lock);
 }
 
 #if IS_ENABLED(CONFIG_OF_MDIO)
-- 
2.34.1

