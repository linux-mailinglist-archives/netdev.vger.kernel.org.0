Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4BEA52216F
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 18:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245597AbiEJQoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 12:44:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245440AbiEJQoA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 12:44:00 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50046.outbound.protection.outlook.com [40.107.5.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC8356758
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 09:40:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZBF9kzUWChg1gmaYll8q0fqd24J7KVdk1KXKYDHL5CElHm/yVDiFBDi7MFWT6ZylpSYmZlGf2VQqU8W8oyDZqK3ZIdWviwAHnI5/jTy5tKHGDi8nXByob9oO5PFh6O7dN/bAcuxuHEY/mLz4KfVqzwqbgj+tE0/PtDdIWPTVBh2F/mblPuaWWG1Uu3SPx1JCRB0XKaqVx+5uTKDYt1oqLNN4KSIxmJHjQf2/KwVs0SsPGz2lfXgKDSKmjMssdE1HAKMuWUh678tDSbesDzzY+OiPYOC/ysCLsITPn1/3M3JIUBDN9GKFH797xHeVzu7MFUBt/NtndYllxZwoy8YJQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fmWUo0KcV/e1yhcXECYVSYyxAl0KFXD+GlWs2nX0Bbs=;
 b=fX92CcCAtQ4NzS52IMy+EMvvGhifx4ryB0UCTmvDT5lE5cy7eInihPl07W/zXiZ9SNuBv3Ya2bETdDh0/9jFTFDF/qCSF393y3vQHBdBkGooSApX+xahBz/CkKGrvwUNcI4tF0y1vTsd2oEdtRpGbRpG1LBzvZ0GuJ5tVZlzvqiGkzPSMOdMNH88s0LmKlGiQWsvoc1W6vefOlQUutoWSWYUW3b1AXQx0Bt3SISmECGXluFKZkUplpiq+X++knvfDfvk66gR41EmbPuLvsZDUw5P9pMvzUc6Obf1pSi2G8qxJSAYNuRniT4ZiPg+LeDEmWQUMQu1uw+//Z7Tcd7dJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fmWUo0KcV/e1yhcXECYVSYyxAl0KFXD+GlWs2nX0Bbs=;
 b=HPp5b65aziBv2Du79j0nrbqX50Jk4WWNXN9cn051evkLzUN3J7zjkiP1rNtFF2kF0R1anQ8PZxrrcXkTSPE8xIRrFmexCnIWG2svNW+90fVWvVacaMseUnGwS6F/e04dnWKFIL3HTMTTxk4ah9g/QVPCVIxh9iy0OKh+ktV6+N0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DBAPR04MB7365.eurprd04.prod.outlook.com (2603:10a6:10:1a2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Tue, 10 May
 2022 16:40:00 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 16:39:59 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next] net: enetc: kill PHY-less mode for PFs
Date:   Tue, 10 May 2022 19:39:50 +0300
Message-Id: <20220510163950.8724-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0084.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::25) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d9aaa8b3-da18-4b7f-ddc8-08da32a3b94d
X-MS-TrafficTypeDiagnostic: DBAPR04MB7365:EE_
X-Microsoft-Antispam-PRVS: <DBAPR04MB73657329DA36EB4FFBC14107E0C99@DBAPR04MB7365.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rmd7+VihcvJBiB92SHazT3s869xS2UUbOhicFxsB0wLI+LXHSZeQUUspRapk0wopQIGFoze3t0GBRfUYBiMAszfC6XOmJ8/X6v+3kBNoLE6yrSkjCgRQiOARcMQgsrpTCaATlbF98FE0CbwT+OQJLuGnt2w9GDa4PJQcOoVne2Sg3EY1IZXATiYnEbLQ/CrBSgAfc3n2SiG4ObY0drzwScuqsDWrgO2n7D3RBrzyb1GboqDCh6sz/ghHSrxNyQq5dhIRABeK0hMBSaYchDhKy74UOwyNEeWkDDC6+vjXDlqs3Pey0vI+UCvh4cq1Dom6LzGjfbAMh0BRMCtNkupq49WV5U3MovpW8zH9HmkWST+pWKPLiiMTKA0iVD4j4MHdQgKK6wpd1bli6gQJCr1OJHZn+G/Avvf7p0Q8NM4zse8hNZ7ug11iyVlw32s1AUkDuUUy/yUGDydUvoui+bw26/ngRHTmEoamvdMro8YoJVpPIqXeAIIhJulL5bLCMfKJujiufFxiWiha13dsY3wieL8zU2oCEBLVvbGmfKMoRaVH+/MCfb0TWxK+bL4MCY6xgjEF747V2VGiZHGLzyuZQ2A07At25Nh+8suDyYve4Kguo4U42YWzolTnlk7SWJurZJeZgAnY3UFnMM3iWMFupNr9+KS4x80oOKYbNQFPjZZDD0WoN7shfeR6g/r8OTYDIPvRWl6Iia8DhOAdEog9Vg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(52116002)(83380400001)(26005)(44832011)(6512007)(6666004)(66556008)(36756003)(5660300002)(186003)(1076003)(2616005)(2906002)(38100700002)(508600001)(38350700002)(8936002)(316002)(6486002)(66476007)(8676002)(4326008)(66946007)(86362001)(54906003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hGEQAhAXn7AERvzm6QT2ewS8WraiRip667R5LdYrEeINQpkfHMV+P3UdcUVs?=
 =?us-ascii?Q?+3AY/zRX5hoAcSP/h/q4/QOjZ5lpSmyfqtjgQKhMo/eiRA6lsgyJ9KnPSwuS?=
 =?us-ascii?Q?nmUai9Ut2X0Xr01RD4z9GFCcPbG2G+4tB7aKRCHfmSizy9U+B8p2CW3pjzmA?=
 =?us-ascii?Q?i+nWQNkagRKLhUsfb/SAqY0RTjejSkEvtl64nTOguOPSVGMm2N0WuFKOGord?=
 =?us-ascii?Q?xzDyQJqqzh/jcaIt9ibyF7nvxxaravTvL/lecTDaDqxDAJCjlG4U09Jl8Ret?=
 =?us-ascii?Q?ofiyXkIeMnPqTiuxqeJ+q8a4f6p7Q21qxnbusx8fVkmOj/NVf8zj3h6FVwx9?=
 =?us-ascii?Q?7RJe1kmHCALtfOCG0vxp64e7qt/7Ub2XOAApr8hNvhW7XVLljez/y75uSe/X?=
 =?us-ascii?Q?oeg6SlTPOjmxRswaLCeMPypxt8khTGDVc5sjOhvGo3/S9+/0UIJiX76Jy4mp?=
 =?us-ascii?Q?s0+MQ0iSEvHAaB/1DX1FLXmqy+qWEgM7wYWbZMuHUJj90YbwR9b2PywchBdt?=
 =?us-ascii?Q?+/oShc0oTKVlyyqUpBhzR3LqIn3MSnO2qd1b7/w3qMBmjMM5gd1N4IqR2PYy?=
 =?us-ascii?Q?W999PCfWhe6NKR0ZqHBaSQ1G0ZZqR8oPtUYLuSoAWU8jiz3gTQBHSLmWI7+o?=
 =?us-ascii?Q?mwjiqTteDmWV1HPasmKFxrfSB8EY92nPVaO3L7PJUTrmS3njU/KiPIbYsFTB?=
 =?us-ascii?Q?6VjtENmoDGhtO9aEvkuXtOyezpHIq/pQYw4WR97HBGlVZqCizs9Un3dKvnwX?=
 =?us-ascii?Q?uv+BxfgEbgFN+vSEO9WWsRPXGS0ZZPKCd6GQ9/+EIMeYn7I7S9hn/hp1GsTm?=
 =?us-ascii?Q?wOyt0jidc+jGcfA8skIv70UpOZ8RUaahIZlgdDQ1uBpUcSObAL/oqnLxyS8w?=
 =?us-ascii?Q?bnBZ8yvsI8K65rgmFgzreL33BpL04di1NhueP5oi4XUGhFQBenk9o2S3bM3U?=
 =?us-ascii?Q?QI8aIukz+4v9YlYXct7EBIyCX12pl/lk+DAmHdUEE8eIknzMkYQ5vAQoy++9?=
 =?us-ascii?Q?gB5ZLf+CmcSgzFWv4pAFpYcmW3pC/uchnWieN21qnVUbROVWLBvipWsF+u9J?=
 =?us-ascii?Q?/XDmG87isUHxsNug8qmDznUhRWjIAGiTL0mFzGiFK3hiMjO2SuGM8Vg316xK?=
 =?us-ascii?Q?Lj+ctq/bw4r3FcBsUpQQ4qUUPFS2OR6YnWSuWPPqaSTdzLaQCzkrcLLKv6tj?=
 =?us-ascii?Q?/4ComVusJhtQCEtt5Oz5bIivHL5FO8FTC5bkE2zIOUmhqpsx+mS4ovabW7dq?=
 =?us-ascii?Q?TC4neGFithwfDVPPukLQfJ/qJUoSDZOm4/499NpKsUUU9Zzb7fEax1x6L5WV?=
 =?us-ascii?Q?ueeY1NaFxuhX/ErIcFNk1RIemSKbiQsnFzJHzXd+0fFCJesrDdJ1vKxjtUsz?=
 =?us-ascii?Q?iELLc4fS490+TkAKkiobbPYVvMJ1Iptj2ynRkNFyr/1tY5I6/bzIq9T3VYTZ?=
 =?us-ascii?Q?tuacQq7UBsHG2f75GV1zKW9YWkaRWFY7YgksSw/aByZWBESuZxc3IIzkcOz7?=
 =?us-ascii?Q?QcenogXCVlke7B4UnMu8XGOdsJg//TCqY/hdBA3thudzj2sCPZdgGhN6HTkw?=
 =?us-ascii?Q?07YiX8jTcnuOB85chp3XiFyZIOCvUUL8t0Hb0a1ypOJ8P/3sQvDG6DxH9E2R?=
 =?us-ascii?Q?5nBenv0VsWsUCTDU53XRcKYQ+T3viPSmt+u0VYC8CefX0oBePvYNyEDm+UMu?=
 =?us-ascii?Q?YSBt3WNcClyI+Gh9kPa5GUrf2Mgy5jtoZEjeaeEKWX9xqJGNSmdeA3jw486G?=
 =?us-ascii?Q?hFiHQw91mc2SNlLgOJL3ncrUGAtYpIo=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9aaa8b3-da18-4b7f-ddc8-08da32a3b94d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 16:39:59.7854
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EQUfO1hfbl0clELpBAp4RPSmPCKzLom/wSLIgsxwyiQHl5ySym5yYLlDBo/g5lIEex9cKbEhmvXw9P1Jtw/wEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7365
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Right now, a PHY-less port (no phy-mode, no fixed-link, no phy-handle)
doesn't register with phylink, but calls netif_carrier_on() from
enetc_start().

This makes sense for a VF, but for a PF, this is braindead, because we
never call enetc_mac_enable() so the MAC is left inoperational.
Furthermore, commit 71b77a7a27a3 ("enetc: Migrate to PHYLINK and
PCS_LYNX") put the nail in the coffin because it removed the initial
netif_carrier_off() call done right after register_netdev().

Without that call, netif_carrier_on() does not call
linkwatch_fire_event(), so the operstate remains IF_OPER_UNKNOWN.

Just deny the broken configuration by requiring that a phy-mode is
present, and always register a PF with phylink.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../net/ethernet/freescale/enetc/enetc_pf.c   | 24 +++++++++++--------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 7cccdf54359f..5cc2847ad05e 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -1105,8 +1105,7 @@ static int enetc_phylink_create(struct enetc_ndev_priv *priv,
 
 static void enetc_phylink_destroy(struct enetc_ndev_priv *priv)
 {
-	if (priv->phylink)
-		phylink_destroy(priv->phylink);
+	phylink_destroy(priv->phylink);
 }
 
 /* Initialize the entire shared memory for the flow steering entries
@@ -1273,16 +1272,20 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 		goto err_alloc_msix;
 	}
 
-	if (!of_get_phy_mode(node, &pf->if_mode)) {
-		err = enetc_mdiobus_create(pf, node);
-		if (err)
-			goto err_mdiobus_create;
-
-		err = enetc_phylink_create(priv, node);
-		if (err)
-			goto err_phylink_create;
+	err = of_get_phy_mode(node, &pf->if_mode);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to read PHY mode\n");
+		goto err_phy_mode;
 	}
 
+	err = enetc_mdiobus_create(pf, node);
+	if (err)
+		goto err_mdiobus_create;
+
+	err = enetc_phylink_create(priv, node);
+	if (err)
+		goto err_phylink_create;
+
 	err = register_netdev(ndev);
 	if (err)
 		goto err_reg_netdev;
@@ -1296,6 +1299,7 @@ static int enetc_pf_probe(struct pci_dev *pdev,
 err_mdiobus_create:
 	enetc_free_msix(priv);
 err_config_si:
+err_phy_mode:
 err_alloc_msix:
 	enetc_free_si_resources(priv);
 err_alloc_si_res:
-- 
2.25.1

