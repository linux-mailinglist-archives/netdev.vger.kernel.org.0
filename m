Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2F85473A60
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 02:45:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbhLNBpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 20:45:52 -0500
Received: from mail-eopbgr130043.outbound.protection.outlook.com ([40.107.13.43]:7390
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229579AbhLNBpw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Dec 2021 20:45:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JHv4YBvkz301EzbiuiNM/seNyFhQevusTMFsbo2JkuCDyAXhefA96ZBhv82s5+Zq49Uyd4wIjZAyps6Mq7LlZwcRsLWfggOkkw+NVVqP2aPxFVdXWfYMTZ3EHR3iMFmmpg9X40c+39JjtlsXIve3M719SLpShdF2BI/VbbdBTnHtBe/YWLLZYNdEL8c7/Qmqw7VaVWxSkBx4CtVpCY9SiHse7wVMNzEFqbURyPU2tUj1Xb4DRGYt2VCy4aimp7EOZ5Naz9CtOkaAJHnPlnphzVcDBJvJr6B0sqdAuSjNin6FzVXyudNTOsoRaBHoCyLsHHWjifap4cJ76uoZQhShXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zh3XdwBGaNd4tBQPMHSBWKVqXbgqgAj6+rcKoihZpvY=;
 b=PwvcvZ5O50sJRQ5flMmQcbA/FnKxfLSNAKJok4jxojkwVu/2ggtPhYQZyQffJml4Yq1t1muZ4o7c1BLlOF6PP+uShzsC7/ibxzqrmmhTI03TZzMphJm50PX7x00c9S+Jp4IVE7fTMevLqpWid/XYin7BIfW7QvnX1KOOZi/E8MgL54TbrAHGpaLF7JzCjam4pF516UnptnkXbjwqt3sjIOSzbAzYdMilbeRWs/1kdfLYOgbVqaT4v8x+NAQHTIr8d8B+pKchOXBy3iQhIcYpvCZDvEPUxjbznIFx5ArEB44gLySAd2svC0tVIiHYhqfpfJS7AKPriAY10+qfe3SQ5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zh3XdwBGaNd4tBQPMHSBWKVqXbgqgAj6+rcKoihZpvY=;
 b=bZVsXx+UPm8cp6H3ngGX/u5IJ+XKvCcN7gXteYAhisiJDRgu962jJUaqwiSge3J5MgVbofHkPQCvBIKZyDbAORUu6A479KCclgGNae3X2y7cKtiImBj2eqxcjNMdpWt0zGlNGyH4Cugu8sOC4Kctbj66T75wYnM4pgCY0cpsg9w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2800.eurprd04.prod.outlook.com (2603:10a6:800:b8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.18; Tue, 14 Dec
 2021 01:45:48 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4755.028; Tue, 14 Dec 2021
 01:45:48 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>
Subject: [PATCH net-next 1/3] net: dsa: tag_sja1105: fix zeroization of ds->priv on tag proto disconnect
Date:   Tue, 14 Dec 2021 03:45:34 +0200
Message-Id: <20211214014536.2715578-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211214014536.2715578-1-vladimir.oltean@nxp.com>
References: <20211214014536.2715578-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0027.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::14) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by FR3P281CA0027.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:1c::14) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Tue, 14 Dec 2021 01:45:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6f45b85b-7757-4fc8-753b-08d9bea373e8
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2800:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB28005DC044A827BEA63F3BD4E0759@VI1PR0402MB2800.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:962;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jXH2v5XGaJYabMvKwtLmfcKOIKR9imIMur4hIPSkpNRtAUn+u+xkB/uq73AIx0tsq9Y2BSUKJYR6nK0pFXAIZmiyCipAiPgXPmZ0nWU+ijtAlGOkG31emldIVWAUjgM7+XfqC6bNkrwhG8RpA3siAFG66bxqh1lXdUz2C66ZIve/Kz1UWcacfrPwujAMSYnSZTW8A0nRXSgN4eAZzuZbnvE+b+nEt7XXAahmJo3fSa7EwI6CYup4NEcONsb9ExVMi2sXocsVnl4E7Mv7r2zOEWT6KeUnV19TC9qlaNlP6kEWzaYXQKcu2W1deGdmDt+Ym2obYMu5YrSP0ti9HdOqFafLOQ+sBzJZOSwtNNFL22Cqo4BxO1nBM+mwjME3CxjvvGnHx4BuSTt2eZOhmRlYALaUHnwCYTI9JK5MxF+oKx3l+bucBZndMGNUJC8tIVqCaVjyClD5zWWm4XEAyPXdlH3pzQwJEcsmprmXT6HPrwDvMEHgcuylj8UXmaJnNJ+hXGos/Q/aMBbfaJP3aqadwwoiY3icjBU8o5boJyjNyAiIx6ILC8R/sSZPIMmF8NoLgR3gAaCSzkN4MuEEKymahkxyfhUBgMMcoSF21l0kfyrsQVdn5iQfYZ5cKrhT4qon2AexT7+dOlEiuUKR87i4tfxsAvUDunhoYyWE0gp0/k3fChAZcUsVXcEGIYPrjVVLCK/XDHjzYCsaPwxMtEuBmQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(52116002)(26005)(36756003)(956004)(2616005)(4326008)(508600001)(44832011)(186003)(6916009)(54906003)(83380400001)(86362001)(1076003)(8936002)(6666004)(2906002)(6512007)(38100700002)(38350700002)(5660300002)(316002)(66946007)(6486002)(4744005)(66476007)(8676002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XiZnBQ7RFaBrDu4GeiS0BREA1Wj6Fj/1K4TOh4PVywTv9RSTrrBw/Rmx/S2D?=
 =?us-ascii?Q?L/r8rLKGQ48zLTZxLtslNO+hHerx0bgdw48eoTUCIAfJEZAq0y+ScqHWLYJ2?=
 =?us-ascii?Q?4MvdkwGTL1Pxq4gpTlOFEAexFzl14pXIAEGdY8V9aEzTAcIYJmGH/TFiVAT+?=
 =?us-ascii?Q?govsx43pmGOxBJXVN6VNZ+fAQ3h85RJCZQDqx03soxkz29Qf2sBVnaG+wOsP?=
 =?us-ascii?Q?YTEV3PVZlClu3/6n1i3nrLGUp3CtKQ2gHWSbV97/fWygv/5bmPPJ5p3Y7Wo3?=
 =?us-ascii?Q?yiUVq0A6jTuoBA39OYQuy0hO0WLHw7YVAiLnNh5BZtE5xSlaPgaREi95AZ9A?=
 =?us-ascii?Q?g3f9aTGBN3wYHNAJAK8zuOgC/0NgTIlRsSpmTU7It1Th6b6qynmrClISwl+m?=
 =?us-ascii?Q?SWmEpfuObEDfqW8mJrrH+p4dfe/fkAerc6/lF1t6n42ovz0wJar7bKfRPWXe?=
 =?us-ascii?Q?+7rms6Lz3xQP+JFbO31kbOz0EUW/wN4tli/ln37ExTWCT5GAjT1Ffb4p1gxb?=
 =?us-ascii?Q?RyQnbJWmjK7qQdi2icFOOV8lB81Pry/OTnAmUFsMzvWoh45oJDSGZfdAYMlg?=
 =?us-ascii?Q?XhkPfIghNuSYbJKldMl7uSQFPao4nPAi0+kkzon48Gv9DbTXPUFmNpEYqrUm?=
 =?us-ascii?Q?3JuUvt+urmdOwqJNzVTtqeik+0o8bxuBVp1FNRa9bP9Ja74FSf5q/dz9NdGY?=
 =?us-ascii?Q?UfBlYdE6cTVev94S3cHf+m3VzjsY/Q/Exua0qRfKa+jxk9oNyKe1roUakrb2?=
 =?us-ascii?Q?2zVn/dlAICrsqLh9c0Tc0GMETuHq9fHkC74jYX8DJ621KavR1xc25Yhnaru8?=
 =?us-ascii?Q?RpRZ0SzFjarZAXyHkOLNNDoJdgDrXVBr1rxKEwlpl9MxDYHB8BvJ3WZbNWcJ?=
 =?us-ascii?Q?G3M2Xc7MZ0sTYcBssTWq7xN6rM+p9fWTkVP5EzStlsONwFBfv9l1mNSQGsIr?=
 =?us-ascii?Q?zw7Jw9/7h7YT6oRti5pUTOR9RmyZsD3cexPHNBOhSebBoWj5wnv3h0tJqz0V?=
 =?us-ascii?Q?dbEXxutzuFemsb5NXqBcEdWKkQqQG85Z4+czJ3t84uDk37G+a7K26P9X35TP?=
 =?us-ascii?Q?/kWGK3g5tfQN1Ut4mAc4fSr4ulhRSCYia4nnwCiu0fIIFPnz5f7uGH0K79qy?=
 =?us-ascii?Q?tYwiVatvSHSbEmMaYhJtxn4MnFLuBwhqpswm2Eq8RMUubUPh2H1p3aJjLFdQ?=
 =?us-ascii?Q?dW7q3UxZ+gSS8kdeICR0frDduoSP6RlV4U5+XPcGi6WTXsggfe8nyxRPZN29?=
 =?us-ascii?Q?hsKEEjDT2qOPONBbc6zUgN/ONbg/IVnw0TLNA8V/6KLN323y6eivap4fBZ7q?=
 =?us-ascii?Q?a0NJ43lwwCbshEVPnL2PtT7S86glElBJJuJ1waQZfBAXmcku4ZA16iZizaSV?=
 =?us-ascii?Q?DWrSt6f5h1NyRAvJYHqFxYm+oC/ijK5LOeBHvcTaRosObqEd9Iah7lqVlyeL?=
 =?us-ascii?Q?n/+3mlx4FJNJl7+FnI2U8lfDKSvdD/OrJ/JBceTpkJ3Rsj3CyRds6B7GVrbg?=
 =?us-ascii?Q?a1Wbkltml7qnGIIghFjUazFOMCZqjva1QLycvuCsEef4k2OIQSp8I+hZ7Bxw?=
 =?us-ascii?Q?vG97486qgF6r9wMjAdeXg+b33ELfCQSN7NnaqwCToz7nDUDnWzNr/RTYaDef?=
 =?us-ascii?Q?98emRgXw4fYvJ7Aq8YIP2p4=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f45b85b-7757-4fc8-753b-08d9bea373e8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 01:45:48.4915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mFAPDdi/a/Qrhxz9D+8WBdFgeLNqFPqqld8MlmQkgVGCD2QN59v0pURw0R/265/rCFORi5Oa8B/mcZihOsJN1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2800
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The method was meant to zeroize ds->tagger_data but got the wrong
pointer. Fix this.

Fixes: c79e84866d2a ("net: dsa: tag_sja1105: convert to tagger-owned data")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/tag_sja1105.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 93d2484b2480..b7095a033fc4 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -756,7 +756,7 @@ static void sja1105_disconnect(struct dsa_switch_tree *dst)
 			kthread_destroy_worker(priv->xmit_worker);
 
 		kfree(priv);
-		dp->ds->priv = NULL;
+		dp->ds->tagger_data = NULL;
 	}
 }
 
-- 
2.25.1

