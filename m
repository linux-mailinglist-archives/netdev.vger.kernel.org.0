Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB64942173B
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 21:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238984AbhJDTSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 15:18:46 -0400
Received: from mail-eopbgr50077.outbound.protection.outlook.com ([40.107.5.77]:3542
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238700AbhJDTSc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 15:18:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GWYBkXJzrHatYr0+owH6DWs99SAmZkjrzzhPSfNewwy8NmoSd7vQgxn1w+UAnS7v0MEQzxd/LPB7ceX/xux+UDU6uT2MvxdBSXj+thT0aS6C2Q4cwIRjk0Ek96qdUL1Y0/kJEWrrtMeUtW8UHTMTIRTMZIvstf8IfNg77z3sXVnsZ1XK2PdpnIyFZq6VcteW6rQ/lNLZ7GZsf/WbGgP0rDEoBlwZz9Gu7pZLPIo5hPvQNphtGNCvQChOxprX2IK0Is/p5I16YNCDG+f0x4pHK/22aEVaPNaI1NqbDCAIRJMuURqOk3LVlgaH0UQ5fSaSU8XoLBmjJLrj37AOG0jYng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MwqogHcbsow8dBZ9T8Dw1UllQRhGDdyQ20Ce5cmhTTc=;
 b=b1WCVfV/uRfPYweCTQmdwfmf3h3/ZfScQ3+xPdY8n6eEITpbIo1FoBbZcoXI68XV/Vf0cTWTUSAs0e4sxVqmMWOdrtHJm112XGjagr/JWZTQAKpmk7aJYDPFaa4srA2DQDnITUGjfEqrVvKe106RWFkaaG/USx/z69Z/1y1TdS1hWpND8O0T/bOzixYMeUrFuh8uUk5sdXF6GxmsNaihUaOBs/fOYgz9GWPnugoSpJAX+k+MIvVX+oGcOhT76s4BtjqNrhHKw8W9Cpvi6acyIEFqeS4GGCeCgNbcwMwQMYhHb+Nh1SZj4u4B8ZgowX6IQxbk5fh6cBFlhgrqoAARAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MwqogHcbsow8dBZ9T8Dw1UllQRhGDdyQ20Ce5cmhTTc=;
 b=R+zZqDN00zLvWpXWW73cwOPfTdKp/T12N9jdyfNLeGOhEczs9MscO1Ja5YJe4L22UYzj18WIP9vrIByKz6+sKiSyA/qrIMHsnVoLye4v8JAwjU4mZD0Vt5pSyIEmCFBgVnnKVuceOZeVWrUPPH3nKOLgpR62yjEij5o0Epz5cb8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB9PR03MB7434.eurprd03.prod.outlook.com (2603:10a6:10:22c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.19; Mon, 4 Oct
 2021 19:16:05 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4566.022; Mon, 4 Oct 2021
 19:16:05 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Anderson <sean.anderson@seco.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: [RFC net-next PATCH 11/16] net: macb: Support restarting PCS autonegotiation
Date:   Mon,  4 Oct 2021 15:15:22 -0400
Message-Id: <20211004191527.1610759-12-sean.anderson@seco.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211004191527.1610759-1-sean.anderson@seco.com>
References: <20211004191527.1610759-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR08CA0023.namprd08.prod.outlook.com
 (2603:10b6:208:239::28) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from plantagenet.inhand.com (50.195.82.171) by MN2PR08CA0023.namprd08.prod.outlook.com (2603:10b6:208:239::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.17 via Frontend Transport; Mon, 4 Oct 2021 19:16:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fe3b666a-cb2a-4349-49c1-08d9876b6954
X-MS-TrafficTypeDiagnostic: DB9PR03MB7434:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB9PR03MB743471C53B7A33C4C1E7AD1296AE9@DB9PR03MB7434.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZUp5O0RQ5hEgKdtCT2jHOWxSE55vV0wDRNdVNPds1KdI9HdQV3sWOWEhCQDbZThv+xWd9kRBTOdhAkdnLZhXCsdwMAKehexj1fSpKdcHlraPoymVDW8T29+pslODSTT0nkx7id+c7IvpZxZhcLhuRi1u6fGj8ScplXwOagaQcYhfpkKASY7YPk5hFo2H+3WyAjhmNkeexEQ2QX6ZW8pkf+hqVbHNlbynZCxVGzv3cioMptlL6K6tN14xP0VoR4eL+Pj1nGSjzfnaLJwf2L8eriUrBbRKljqcQOqalbr3ihdQaP3fa77cdy+4buqRxzeq+LFg4QHRHmYlYzIMGTNJ5YmzWssTpHbmmT7+FQy06Bl9o0fPPDzEhd0LiKmPiryrJ0BjY1bEvgaupRHs7TE9TdDHwtp8QaCcTe2Lw/7+YVW2Q7bwXiY/TBQElsQoZ3nazbTzrY83BuDfHFeneZ4pFOcD1s11ByHU+1IytyvQvansIcpxkmDMefcxtmFtl3+3ec6mbypRuWxkqm7mJFvAG+uPDF0UIIiwJPOBRXFZOkYiNnpppb1A9qN60VuPjPM3MSq5cMrnmrvNZtmq+nWcgarXfanmsrxm3dEJRFeajgoquA/UmYJoX3pY+U3hrBnxFlD1pum1EVfM/3mDN0BYh6EGZjk4DIbsfMFPPoxJb0uIT8VT6mQJfQUcGFyzoY50abJkYmhIzZcS0MaEPizL8g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(1076003)(86362001)(4326008)(44832011)(6486002)(5660300002)(66946007)(508600001)(38350700002)(83380400001)(52116002)(956004)(66556008)(66476007)(38100700002)(110136005)(6506007)(2906002)(186003)(8936002)(316002)(8676002)(2616005)(54906003)(26005)(6666004)(36756003)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?otb40rf4lZwuXT61DX6N7+Joe8U9M4BE3qR72vVyLugsXQ5Lyp9JC04eTNEe?=
 =?us-ascii?Q?g1R4npzp2FeiX1Yhpdj5x4jpQtF+eP797SzOujT2zjbs7iG29zoQa3MkFJmf?=
 =?us-ascii?Q?Y0mCleHH5iyZbNouCnhFdsFXIrPIYhdo2TvUULonaPmbrexXRds1QOYTTWar?=
 =?us-ascii?Q?cy4DwxpOMq1fe80M8e4+7lKS6UqD90hkEwnRiyy7+b5lsnbiCTlNtZ4CnEer?=
 =?us-ascii?Q?vuTYcUXEeV1Oy0Js6Kia47+QEv09qVK7ejWLuBEClKjdmSNmFUaSY4aXdj6B?=
 =?us-ascii?Q?ZT6AH5zNlg7ZWvks6FIUbN4K9EJkasWHzsBR6sETYCrTCkfJbyqnXlExL4t+?=
 =?us-ascii?Q?wEOR2B7aCSvcKV2YY1zXekKvf8Px/MU1LfbFxAoYjfV3VHqHdJOJNV5DQwo4?=
 =?us-ascii?Q?tLASI+2z43VA98ExST5O06mGwe67JPsTPt4YXQas4lz52IjKlIwwJr6whreW?=
 =?us-ascii?Q?BUfknETW5I7QLBpVUEl74zc79SQ3SVQ1oviBNlJWk2YnECM6mbxAB513hwp6?=
 =?us-ascii?Q?Kyu6IyoZzgfQNA/gOLaE5aBV7LhdNsBH0mNG/uJRm9TrWFUEDfxngT03Kbe2?=
 =?us-ascii?Q?ayQhzGSXU+X4a5Mt+F0wNiedJKxtIn4VDaTf9g66EFhLZIXqCQEGFWU/FhBZ?=
 =?us-ascii?Q?BGdN2TozxlVoMvsbqJ816OPXkuuiJ47fMoFFKeecAElx7dnIdjcf3Fd98sUI?=
 =?us-ascii?Q?RatFVP+5aHl6sBRCnNl+bMg2pSzgQlmAJ3Mzx8n1behfIghL22drVjSw90Sc?=
 =?us-ascii?Q?zd5O9vWNVHlSMRhktcSPVrjbGCeKjS7U3aUvRPo6/JsSjmpjoC6W8uiE6gNs?=
 =?us-ascii?Q?UA9Cnie599J7/t7rXOKrqCXphc5wUA37emES15qbLYBt2zgK2dnuP4yi6x8L?=
 =?us-ascii?Q?RX0i9PL67I+/ann+bslIp12XRQOTYUH1AB3Gu5yyPJwT/TMP84jlVi0oyLSX?=
 =?us-ascii?Q?dnjgHgo6XXAt2JJWstKAVLJKu4QyTTcLshgxhE/fJwq75RPTdmb36//rKWIf?=
 =?us-ascii?Q?MITKr9wMJ/tborjirQ5jHgdlOudYcje49Gb6OY+p3RjOyIJRvRrHMFIBdnMA?=
 =?us-ascii?Q?pzbcantlbPEKVWSoGdWjQuZnFKLEDsDakSDMu3uFHg9hPuJhZkzTB+7FMVI9?=
 =?us-ascii?Q?/PDdtGMX6IVabs9Mi2JdC6iOuh1VtBvcHlAqqI+fsyQ2Qsc+NVVhNuL2vkM4?=
 =?us-ascii?Q?MLaSMhc/JiYgPRPc0ts83FWXoyqS0ijEJbspLXcw+SYZLk8ysS/2fpSEnb28?=
 =?us-ascii?Q?jDxeQO47awPVRXPRM31+RHzuMNbWOgfpAm/Cm1MFTlPjlSmq09mYZNtBT8JZ?=
 =?us-ascii?Q?9ssfmLaUcFeF545ZetmXcXyD?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe3b666a-cb2a-4349-49c1-08d9876b6954
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2021 19:16:05.0328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yLKgB4Fuq7lhYCCOqvVZTYUoa2A9dB/bej2maRf88IJeQ5FKHeg/nnIzv4gSGCmN36cvlwDrR7s8zB/rZaTEHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR03MB7434
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds support for restarting autonegotiation using the internal PCS.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

 drivers/net/ethernet/cadence/macb_main.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 08dcccd94f87..b938cdf4bb59 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -662,6 +662,21 @@ static int macb_pcs_config(struct phylink_pcs *pcs, unsigned int mode,
 	return changed;
 }
 
+static void macb_pcs_an_restart(struct phylink_pcs *pcs)
+{
+	struct macb *bp = pcs_to_macb(pcs);
+	u32 bmcr;
+	unsigned long flags;
+
+	spin_lock_irqsave(&bp->lock, flags);
+
+	bmcr = gem_readl(bp, PCSCNTRL);
+	bmcr |= BMCR_ANENABLE;
+	gem_writel(bp, PCSCNTRL, bmcr);
+
+	spin_lock_irqsave(&bp->lock, flags);
+}
+
 static void macb_usx_pcs_get_state(struct phylink_pcs *pcs,
 				   struct phylink_link_state *state)
 {
@@ -733,6 +748,7 @@ static const struct phylink_pcs_ops macb_phylink_usx_pcs_ops = {
 static const struct phylink_pcs_ops macb_phylink_pcs_ops = {
 	.pcs_get_state = macb_pcs_get_state,
 	.pcs_config = macb_pcs_config,
+	.pcs_an_restart = macb_pcs_an_restart,
 };
 
 static void macb_mac_config(struct phylink_config *config, unsigned int mode,
-- 
2.25.1

