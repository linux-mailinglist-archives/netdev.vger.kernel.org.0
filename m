Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED112832C9
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 11:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725936AbgJEJJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 05:09:32 -0400
Received: from mail-db8eur05on2046.outbound.protection.outlook.com ([40.107.20.46]:32832
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725885AbgJEJJb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 05:09:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hX05uNUN9RhbS3V1YAWL8EvR7QpMBM5TEBQGJAJV9EFuV5wRh3Dw+qemgjsm67lvKcg+rBVrB7LvNs8YhzsTy7I4SeyUHgR0lr3nEBJVlvmFo13f3ss/R+Sec4+8HndC9HHczMlKO8AiAjpz8M5cPKbt/aBM5NYANGElvaDimAhBQJ2uoVzYbsGBlsOVH3teiE5hFVohpaGmHA1toZCF1Ob5LCJPJwQl/ofys4+y3t+Q/86KKN8rhzKkqrT/g4HojvCCQAnUnucCgj/GrKmiALY0lB+pnURHILCa4DZt2Zwq7VVDbW/1n372tz4H33dqOaJaZ0fz832HQaYkOQE/bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CDplQdyy8vlnjGDiJtq9NV5iSMvRXyVDKr5hT64GPUE=;
 b=ZqWjC6lfDxXJViWMGhruX1aQ6ZXYq1QBX+Z+S4Wq0w1NZEhBynlTfsDiXV2LCor2vrDZFnaeT3X1TyQN4Q8LcK27QATB/5N6AlDdBWO/AS+teb+ZGBBXhtPh7bX73vuRPGClkIXre8GHbWCX6Tb1Ogdz8ND9994f6/A5joCYcJ0rDPNYTEFVs0fWVP0ywTnUjpH5xp8MmMFybSg1ui2HIsEs2Go8cgAeadEKNnic3dds9sRF2q4u8HS9yfh64GmD/4591S3fiJPz1djGYUd7hIHuKtfwWFluG5NFFLz+t+tDoO4osdCSJc1R2ueUxzp8iCkmTzExQuJlpS1qn3XC5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CDplQdyy8vlnjGDiJtq9NV5iSMvRXyVDKr5hT64GPUE=;
 b=lP071sWQ2X82AFB7vcY7xdTqqplcoe8si6pM5HHnZ+XPl8A0vlzg3IBb5SweLMUTxABZQ2oiMM+yf+0jruZ6ycNY2zcMcfY4uKaoZ1ZxCp7gfrbSvtIWbGwyAvma9z1mTQ7s+UBHYcAY94e/JEI7gGUWTJIBal32Txi/JUWKrlM=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB2861.eurprd04.prod.outlook.com (2603:10a6:800:b5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.39; Mon, 5 Oct
 2020 09:09:23 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.044; Mon, 5 Oct 2020
 09:09:23 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com,
        netdev@vger.kernel.org, UNGLinuxDriver@microchip.com
Subject: [PATCH net 2/2] net: mscc: ocelot: warn when encoding an out-of-bounds watermark value
Date:   Mon,  5 Oct 2020 12:09:12 +0300
Message-Id: <20201005090912.424121-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201005090912.424121-1-vladimir.oltean@nxp.com>
References: <20201005090912.424121-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.229.171]
X-ClientProxiedBy: VI1PR06CA0198.eurprd06.prod.outlook.com
 (2603:10a6:802:2c::19) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.229.171) by VI1PR06CA0198.eurprd06.prod.outlook.com (2603:10a6:802:2c::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.36 via Frontend Transport; Mon, 5 Oct 2020 09:09:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9c9ca2a5-a33f-4ce3-bdf6-08d8690e59e5
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2861:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2861B10741FD4D7F5184E8FEE00C0@VI1PR0402MB2861.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J5p8Tpq6pkz/ODGTirfJIFl4v9gU91eTJwVzoPxv3KEHjrhTjlp4wzxLZrypwx6ipMfY0UjoE0xNVJcz9NRL1FO9QnEqJ7BKtd5STgVCrKsmsgvjmngBHoVeoqFecH93EBz2ii5AzrBXyvA+obX/NHUW6kP/hDPiBlNIG5TPJ8r/XB94+HEooHv54cSZqadeSbdohLovbCG7xx0++QWhzsXE8Oj4nh89/unaQasQEpRpQhdEl78GEYWyMjTHv3PSdBuU57nK1N3SaHMEAgeCchEliImqPzy0ZBwEw2gs7PzXqN2+YUjtBXu2Vlqqy/u7raGYAiurQm6G/y1okq32cR1qolclQS56p00Nl2D+wt9nw6JZBJ8NxqlmLrok5i+R
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(376002)(396003)(39860400002)(366004)(52116002)(186003)(16526019)(1076003)(66556008)(66476007)(8676002)(2906002)(2616005)(956004)(478600001)(83380400001)(86362001)(36756003)(69590400008)(4326008)(316002)(5660300002)(6512007)(6506007)(26005)(6666004)(6916009)(44832011)(8936002)(66946007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: zvQStqS8Lt+UmWM4tWmV7qZ7XbMCesIK0yZwJ/CUUg9PzueT7QguW7NapWOIm2T8QQCbxiupJiy9RMVBscJlHqUyC1tjfFpVi/GY2iSmFwso8hkaZEpK1VBdRwt4MY7JexsDy2nooIs/h9AxDiQfcPRMB2UWccl9/ktgrtYSbqaRC3UuMA4MEPRaVGDM3NRhWvixs1Krtus8E5IfKf2XDAMYz151n/+c7Uz2v6pjFPAW1NSkQO+xHhdn8RrmyfFG3om7uwdLrRCJdRre2UyGL7qrWzpwCV0go0WpnGfWOETS9sU9icfn3vfOD8GVnPzSTh119tRbWIogFxddpdtdJ5RKzBt3xamFVaK3nJRSufN8RCDACIkr839a/63D3Rml6Yihon52LK7eXmZyENvsuEiTncJbNQyxp2YA1gLQdA2+DGmFL4Tpw9ZYmuRGgEXgk84AoCiaz/qi55oqo7CyG1rDewyuhzFE2/rcemF9pAUDX4jjnWa1mwgMoc7ndQ4apYsu0rwboWO4qll59ri7P2IuEgi2zRE9Xe03yFY3+KlN5uGusNidlPWqE9+b96suA/MVHVq8v63LxF1iBHx7+ZykUUm1XcVqUuVY0ojmADfoOTowdRmejgeMJoWXbA46BhE5uRJ2QgJ8nHaXkoHTjg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c9ca2a5-a33f-4ce3-bdf6-08d8690e59e5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2020 09:09:23.4290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ewpu0TgkaF8AU9SaFHKpdUGhElYR8Qyv81xdowXq1pxFSWK0wk889nOFG46SmXcv7VGC42FqL53S0akKGk/UeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2861
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is an upper bound to the value that a watermark may hold. That
upper bound is not immediately obvious during configuration, and it
might be possible to have accidental truncation.

Actually this has happened already, add a warning to prevent it from
happening again.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix_vsc9959.c     | 2 ++
 drivers/net/dsa/ocelot/seville_vsc9953.c   | 2 ++
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 2 ++
 3 files changed, 6 insertions(+)

diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 4fc67ff212de..cb0f3d28ecac 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -998,6 +998,8 @@ static int vsc9959_prevalidate_phy_mode(struct ocelot *ocelot, int port,
  */
 static u16 vsc9959_wm_enc(u16 value)
 {
+	WARN_ON(value >= 16 * BIT(8));
+
 	if (value >= BIT(8))
 		return BIT(8) | (value / 16);
 
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index e993f3eac3eb..76576cf0ba8a 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1049,6 +1049,8 @@ static int vsc9953_prevalidate_phy_mode(struct ocelot *ocelot, int port,
  */
 static u16 vsc9953_wm_enc(u16 value)
 {
+	WARN_ON(value >= 16 * BIT(9));
+
 	if (value >= BIT(9))
 		return BIT(9) | (value / 16);
 
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index f3e54589e6d6..79b88bc69c75 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -754,6 +754,8 @@ static int ocelot_reset(struct ocelot *ocelot)
  */
 static u16 ocelot_wm_enc(u16 value)
 {
+	WARN_ON(value >= 16 * BIT(8));
+
 	if (value >= BIT(8))
 		return BIT(8) | (value / 16);
 
-- 
2.25.1

