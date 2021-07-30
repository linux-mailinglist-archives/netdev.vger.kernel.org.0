Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8839F3DBD97
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 19:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbhG3RTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 13:19:16 -0400
Received: from mail-eopbgr130043.outbound.protection.outlook.com ([40.107.13.43]:45569
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230327AbhG3RS5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 13:18:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UFyGc/BgG3/4TI53xClcCMZy6qI+Slnz74YFAA8PGSf54SwTP3peY6fw3BMe/Z4SD0/OkMF0TqzwPwJ/jujeCrOjgRJ2Pjo6s8x9UW6HoxxuGpZHyOzsqjep2YWGiF8+3zQR63oPIe2xZTlZxaBXjyD9yYvGnqpcgX62Df8UarbQUJbxFGZMsnrf03fUGWHPuYFwCCTJNWUhbvqsRhDNUYyLRK70S3glwzw78yfy1Zx6QTWhM8wozkaNIVvcFvF44zdtmL6TMDSIZ+DwUJTJ7zICpGUhFMho8fHL3pIVWQ+1Ckx2zZbjmC7HmSHznr/TmDeFfxDCOL2XSQNE5gyu0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZkvshXB0uErqhw46mqeZ8k2TSBDdDqNiEqlT68BQcZ4=;
 b=eRE3zDi2Azbdf8tpXNfgveGqGkazRUIfrL5dsVX5e1lrxqfGLT/NuT0QbwO/XFLxYoMlz/l/auGALVpLo9uF3zUj8DziaxH/ZwdDwR8n62f3AaX5QNYG0TtsnF3EKsZoxw2vgiLszejgQRwZpi/tqFCgwohj65KZL/YUad2rxI1rB6R+NG/rMReoWlzOxQ3CpeQx7mUKiNCa+vL6HUJdQG/O76IOVuyPYR26pguu5Z6kGWV5jwGAnTax9o0AtwkrT2R3nb3CPCOfKXOV8BvBULjlBJyoaWAqVpLIFDeDGON49428QVrBy5ucN1JfEZk8sMQJVdlchHKqziQDjCqCXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZkvshXB0uErqhw46mqeZ8k2TSBDdDqNiEqlT68BQcZ4=;
 b=n3bIQiPyxIeezzcXyUE1QTH/gZUng4S0VOqMOIM3sskQ6zY64W9YMNONOONOWfBjLpZVY1pamPtHkWKkp5zR2Zz9VwyLy2oT/ylVI/d/sqj4C4S1PJQZfAmF92oydoEhcq4brfORpSK6rrU7JF++ouWPWcyC0H1vvBWgA4GK0Ak=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB3967.eurprd04.prod.outlook.com (2603:10a6:803:4c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.25; Fri, 30 Jul
 2021 17:18:45 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4373.025; Fri, 30 Jul 2021
 17:18:45 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net 6/6] net: dsa: sja1105: match FDB entries regardless of inner/outer VLAN tag
Date:   Fri, 30 Jul 2021 20:18:15 +0300
Message-Id: <20210730171815.1773287-7-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210730171815.1773287-1-vladimir.oltean@nxp.com>
References: <20210730171815.1773287-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0202CA0008.eurprd02.prod.outlook.com
 (2603:10a6:200:89::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM4PR0202CA0008.eurprd02.prod.outlook.com (2603:10a6:200:89::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17 via Frontend Transport; Fri, 30 Jul 2021 17:18:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 48ee15f7-d1a0-4230-8f57-08d9537e1668
X-MS-TrafficTypeDiagnostic: VI1PR04MB3967:
X-Microsoft-Antispam-PRVS: <VI1PR04MB396765E1CD683B33D3DE5852E0EC9@VI1PR04MB3967.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EcAjqkJSzJKALGeT1o5UPEBKliqPE0Y+oTuc0/GSV0ItejA5loaZzqc/l27QQXY+BtJOp9iab3AeuC3HS2Pn0i/sv2dscU4QJsF7SmB4gp433D9g1YR9eyjZ3opOCLso0NKhwTEAmNpW7p3Fc6GREAU01BeEVsEtEHiV/rcZeAnIcDy7ydeYxH+H7Qffm2vzAxB53Ezql2ihNjra+LBMwtLTud0kVpO+v4b4wlIMUH+c3vq04uSIN2aG2x0ug9lzUIUoxl3af//cRwbfpEh17HADfBZxLMBckh2UQgyX3xK8O0eYqv7JqyMum6l0251VXwvqHgt6MsDG+7CQmkQKUw8MhJ1I2XbLd1VhvFZANbPc2n5zv1mTrrwshM75KzYa2fLmzlXXVBYE3B7URPrrjnG/jYpQTKWtDx8uo7iaMiedt48XvOUI61QVbWy7l+Ku94IsFYTEeFEinavDvFuUvo+4kBVbbB21oPh6X0VHRGo7swLolC08xJutH3jidsGR6mMWDp9jyjerYb1Lgkh31YZS6BGcGW/YGN4LtUTosLugoFTXodkBJS8wS4RPrCoeSUbGsF33/Vd638rbm6k+gZuWr4WRQyd4LCfRowKHT8i2lr9iLW+1o8ujnGJN/LrxXCSCuhZtTMxJQgHweiSFglNATMYZS9Zx/vnw9nkaekAgBu9mwxHZivh6Izzv+I86MznCtIFF3w6b/KgvqCe+VF5hG7yieNS7RkPQAjoY2Mw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(396003)(376002)(39850400004)(366004)(2906002)(86362001)(6512007)(6506007)(478600001)(956004)(83380400001)(2616005)(316002)(38100700002)(36756003)(6666004)(38350700002)(6486002)(44832011)(52116002)(186003)(4326008)(26005)(66476007)(8936002)(66556008)(5660300002)(110136005)(1076003)(8676002)(54906003)(66946007)(26953001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ELrMHv0P74dX4ZRoHCRMKf9xoJY0qvMsNMvDiClj4xsxSjxRgoqQOJh5R+70?=
 =?us-ascii?Q?yRYkKezKSW8F2ZbVQrundnCTOWoATtDhwxnpg1R+I7SroYpQAtxZzmBu1nXN?=
 =?us-ascii?Q?iPqNwX5CIVAntvoF4+J/9QxZa3boO8QUV1Bnh34nWiNlRMlL2FT3y0DjXbvo?=
 =?us-ascii?Q?NGK4IuqL/roiGjP5qYT7RGtTDfHusysdcTWFSRVDiV/auKD+Q82eYfTiY8Ur?=
 =?us-ascii?Q?7eUy6R+2oockaxubyDywL2bgX55VCAhbaHGx6P23UR07/t5nEeVdh/KHpMwz?=
 =?us-ascii?Q?E9Y/0FmaNWEsHv9uplXRAX7tkkUCd5sCUsWO61Bg9zQrLE73T0Dgdeuph5sX?=
 =?us-ascii?Q?A9sETffAV26vH2C4k4114FxshD3I4AYluBwWJRyt1Wnv3i3fX3O5dQJOLCEs?=
 =?us-ascii?Q?NhWU0dFZdVonmLNpEGYXexUiDH52q1q/aCOXCfZ0K1L5ex9vatrmvpm+XqwC?=
 =?us-ascii?Q?jLV4yOAx43F5tBKqN9sM7yJdHz3xD6/0t2jNDTzel1tdQVm+ONYzzS6YRLwP?=
 =?us-ascii?Q?0DBGMYqUwAFBVjyBPvMQEZE/PUotBR/eCxJHDdrRF6JEvYJG/rXkgAwfGvXN?=
 =?us-ascii?Q?pC2U8BfBo2wqQZGg2nVuFmloVFCfyCY57Jhn7G8xicM8Zp7HEBkdpLC6qMVa?=
 =?us-ascii?Q?1OI1Q1lhNbEMpIGVn3yrh2KDWHzajx8z/pPBjwCS37JFEO7jB8DFx1d6RsiR?=
 =?us-ascii?Q?fU9M0BVCwnYAeH8PKEY6dOW+89Eo/SqC2O45EFlTCvybdzfOaYUJdqP/NNKK?=
 =?us-ascii?Q?+3sRMDDSJwwGXLwrzfDry9MItesKhTKGEs1fEhBtSDGtvDQ+eoffEh4n+C1b?=
 =?us-ascii?Q?m+nh4XM2kv/6IMVjg2itsq0PdwLRf0kGiyawdEE55gkW5B5Ff2Ph6bA6vjKk?=
 =?us-ascii?Q?q571kK2mx2N9iRZZr0oX1IWAel43D3gvAp566KX0Uom+1MpeKiP/CTokmE5d?=
 =?us-ascii?Q?q+5DGOxvBxF1kbIO1AOebXNXplNEWHUn1CUTMe7eg+C7Klkch10rTZolM0tV?=
 =?us-ascii?Q?MeCKg/WzK2/USP/1mm3GbZfKOq514F4zTYbqutlB7nyCOKMFCq5O07iOkvk1?=
 =?us-ascii?Q?CtlbRI8lPZwPiCtFL+TMyetgU5Es6/Mc6t8J9Cb2xe4ku5mfkSbEaQHa2D06?=
 =?us-ascii?Q?6yCh0mfd4vB8e4dx/PiZIG9q0zb2G+CmxZjbVfQBX9op1gWVnIXQop6GG6Ec?=
 =?us-ascii?Q?bMm2Vhho7gzhpSLdO75v0i8oLhF6+vwRgmnXw8bAKBl146ZbFaTHQr5Yyisk?=
 =?us-ascii?Q?Vq7iWniRjpjtzj6gBxZF92dqTHtxa37yFe5R9ytIeNP4lUO+puZwQKg3+xag?=
 =?us-ascii?Q?X/SXfPPAtNcFqq2W4uTmssiM?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48ee15f7-d1a0-4230-8f57-08d9537e1668
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2021 17:18:45.7890
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /gMGo4enh2P0a8gAC/YJTIFb+X4v9r6VHDVWe0qbkeNzAiH8Nh57NIb4dnYflE26L2nK2FVva/T8bYPFIYuDmQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB3967
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On SJA1105P/Q/R/S and SJA1110, the L2 Lookup Table entries contain a
maskable "inner/outer tag" bit which means:
- when set to 1: match single-outer and double tagged frames
- when set to 0: match untagged and single-inner tagged frames
- when masked off: match all frames regardless of the type of tag

This driver does not make any meaningful distinction between inner tags
(matches on TPID) and outer tags (matches on TPID2). In fact, all VLAN
table entries are installed as SJA1110_VLAN_D_TAG, which means that they
match on both inner and outer tags.

So it does not make sense that we install FDB entries with the IOTAG bit
set to 1.

In VLAN-unaware mode, we set both TPID and TPID2 to 0xdadb, so the
switch will see frames as outer-tagged or double-tagged (never inner).
So the FDB entries will match if IOTAG is set to 1.

In VLAN-aware mode, we set TPID to 0x8100 and TPID2 to 0x88a8. So the
switch will see untagged and 802.1Q-tagged packets as inner-tagged, and
802.1ad-tagged packets as outer-tagged. So untagged and 802.1Q-tagged
packets will not match FDB entries if IOTAG is set to 1, but 802.1ad
tagged packets will. Strange.

To fix this, simply mask off the IOTAG bit from FDB entries, and make
them match regardless of whether the VLAN tag is inner or outer.

Fixes: 1da73821343c ("net: dsa: sja1105: Add FDB operations for P/Q/R/S series")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 335b608bad11..8667c9754330 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1445,10 +1445,8 @@ int sja1105pqrs_fdb_add(struct dsa_switch *ds, int port,
 	/* Search for an existing entry in the FDB table */
 	l2_lookup.macaddr = ether_addr_to_u64(addr);
 	l2_lookup.vlanid = vid;
-	l2_lookup.iotag = SJA1105_S_TAG;
 	l2_lookup.mask_macaddr = GENMASK_ULL(ETH_ALEN * 8 - 1, 0);
 	l2_lookup.mask_vlanid = VLAN_VID_MASK;
-	l2_lookup.mask_iotag = BIT(0);
 	l2_lookup.destports = BIT(port);
 
 	tmp = l2_lookup;
@@ -1538,10 +1536,8 @@ int sja1105pqrs_fdb_del(struct dsa_switch *ds, int port,
 
 	l2_lookup.macaddr = ether_addr_to_u64(addr);
 	l2_lookup.vlanid = vid;
-	l2_lookup.iotag = SJA1105_S_TAG;
 	l2_lookup.mask_macaddr = GENMASK_ULL(ETH_ALEN * 8 - 1, 0);
 	l2_lookup.mask_vlanid = VLAN_VID_MASK;
-	l2_lookup.mask_iotag = BIT(0);
 	l2_lookup.destports = BIT(port);
 
 	rc = sja1105_dynamic_config_read(priv, BLK_IDX_L2_LOOKUP,
-- 
2.25.1

