Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6327F560A5B
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 21:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbiF2Tel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 15:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230466AbiF2Tej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 15:34:39 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2063.outbound.protection.outlook.com [40.107.22.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C215F22BD9
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 12:34:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AZWZneRC8V7Qe6NL3HapNVEPd+HFS+ZfnIB/EtLwZdJlVipTZKVzumMpvYdKYR8OayKF4VTHT8n8qvtaTf6tixH/Xf2TTN2AQ2gMzT19BV9GDx3JKnwAFjculibuetH6ob88k5UeqGH8vzU6rpxIlGxeI/f1gRXMeu6jFF5ihe59vGsqDi3GySMz1CHEaXgjuHjtBGgK2smA4Fi+erPPxeLnVHM5hInFXBJRWp9bpdDWqeufMuoQRCxqdhnysLJch0D48ufhADMHLAYm4Y0jamyizeOj133vi9xglm3WB85J+04RPydpJUUNGTy3Nt7Oge7Z0hDNBROC2nOD7ZCLBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9UrC6fXVs9//lLejbaUhrXov7FbmdwHfoT89GAhgXcM=;
 b=QouzM4K9L3ql+5jGdUFzf0iwt6S7GKhCDdBsPlDUC0cu4gMXTv6l1p59bGUFvQfB13EsvkGS7kZFDDgeZ/98qm+hIjTlluaAiDzepPoa1Ite1tAKgJinTPqPAW7R+9JuzdRNPegXV+KPFm4/FMmj+YrXUP47Dyisf2wHh/5Ti5uiGTFN8ZTSjSir8FLc474GYroh/hLGxyOOAyBlaGAsBiYyAqUcJoAtpbCozKCGK2V+zxYeWHlRA60y5jn0U3iPJphtkAON2qdTZ6h0YQZ18uba0U+0xWOhFgsL0ki0EwiY+ybSrfPLGyonwKR69ql7JxEm2q8v000cyCJgvscS5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9UrC6fXVs9//lLejbaUhrXov7FbmdwHfoT89GAhgXcM=;
 b=R+gfTtgSPGWijqFT3BXs0bTqFR9Umec7NeR7fqmUOsp+OxFxwib5qQoAEJBnPL1CiQw7elm2Mfiwlh1QX7a2u1Xsimqmu7VaQl+5G3XNs85/uNmbg1fmCsMRxCpYTFCBM4UiUWAA8j0cfaMSp465P3u5KVOIMR+eOeYHOhHQlcs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4541.eurprd04.prod.outlook.com (2603:10a6:803:76::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Wed, 29 Jun
 2022 19:34:33 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5395.014; Wed, 29 Jun 2022
 19:34:33 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] net: phylink: fix NULL pl->pcs dereference during phylink_pcs_poll_start
Date:   Wed, 29 Jun 2022 22:33:58 +0300
Message-Id: <20220629193358.4007923-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P123CA0090.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:138::23) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dd922805-bff9-40f3-270c-08da5a0664ea
X-MS-TrafficTypeDiagnostic: VI1PR04MB4541:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fGi5tLUMH8y2MVX35J2wptLmWsJvzD7yPIMwcrmSTpZiLXbR1pOnI770UCJzsmtVCGsSEnB6+we0V24nHMuqfGdmiI0rJC8csTaqBWDHRm/kPvw5aFX0OsbKX6abtQj3Nfg/n4GbwqmrEh/Xq6GTxz4wd2BuadzHxEgRzSTseavGHjT35zieaGivg/UXSmJvacB6CbNw7q+l/ZxdCBp2iAafaeCGcsoctnC9AC676aREx9AesVXl/0DtHwudqJImixcOcQonovk2xzSAQOnagmIHsfaR7Ua3+0ZEIqSf8qFItJkLXXgKFAMHu+0zxlDDCpCz3KCgTT62bW8VcYVq4r6ghjDjeZxa+zfo+MoyHIikukTG9zSLs00uHd+T0aBrj/nISQQKv8vGP9SehQmImi1yaYTgZOAXNuE1D9ikRKHjJdQcr/5W3axiVZaw4opn3I9j6WZyVzVkKM5qctMDSPrBBC8U3FfwK5VwCiyTfVF5RAzdHyuIy6l1apntvGod4Q3H4Og04CVHDTQG92YaplB8iLQy7lBdlSoKWm0NTNxxL0Vc6iOMb/U2XJdkc9kMqQvA5JRLGM2WkYD8zJqZ/RiMSFsl+vWbXivdPvu9RLaj4F+vrGYt34cc9fFhjJo6uAiE+ys7ruJ3lz5iWTJTBLY/R1XOJTxv6PbZ2HR7CpHFxXyJ/COPIidUaoD4VgBsKMZHaPJPscJ4Dk/QoDlPeRx0F+CbpedN3ifri0PuBHVYYGneV2oi/fC/d7EBvpp5YBSBjUgrydO/3ykmyArGTrXj0Wfk4Ga+iIZbc/9qzEk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(396003)(346002)(366004)(136003)(4326008)(6512007)(66946007)(66476007)(44832011)(38350700002)(83380400001)(186003)(478600001)(8676002)(26005)(66556008)(8936002)(6506007)(6486002)(54906003)(36756003)(316002)(52116002)(2906002)(1076003)(6666004)(38100700002)(2616005)(86362001)(41300700001)(6916009)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pKDkoFMK+HNkUO1tRhVbaXteGxHRJIZkCqewJ1WYQwzGM9PWj0PFzpE6ct5b?=
 =?us-ascii?Q?rrpEmlT0zkpRBlRcIsKyJKhCqzinE/SMmV17j/+TPomvwdKp+RICqnGu55Pv?=
 =?us-ascii?Q?s9kvCo5lm+EAoYVOymtDr9cbgyJ8KOviZRsq3xsc/ybUqMJ+YGurwPQixmsh?=
 =?us-ascii?Q?BCgQQebvlKdT8ikpimVsI2KBXzKz/BfT8qh47z828XDNfJraLTNAYeJMdrAc?=
 =?us-ascii?Q?tsSHUxroXG8Nh+myVm/sEHg4C9nslOPI6/Ko4k3WDr6hq94NMtTqsNQvkdKG?=
 =?us-ascii?Q?96HuSRtjs8fCuEXqh6JAf1VxDdSU0R4J3aEgYq4x01y8uxi58e6SeAbXNfW5?=
 =?us-ascii?Q?gVg6E8/LhUpIqE3l+N3MckjvSmaZf/V0awWddXuj/joEzKGiwT2nQEG/KizA?=
 =?us-ascii?Q?gCAhuPq9725jrYkhtoa1NT1IH1p0Zu6a01KsYqPaXTzlSAokUoEfPLr3CdJv?=
 =?us-ascii?Q?AlBEydLhpF6+rn2lc0R5KghTOmrBwXsuOVou5Mju6l7+3dKoj80fIFkUKYDV?=
 =?us-ascii?Q?YixXjplf31aUYJ7xURJCLBXM6jhueobI257kZjglxtQsQPdgWBgJ8Hg4p4kE?=
 =?us-ascii?Q?QZNc3Ql44bn8VccIHnvQbzUEzy0Dv62uggsDgF4CtQs5lhejKdDrzD6dkOn1?=
 =?us-ascii?Q?y5v/flrxb+hG0usezXgBNZIhOW2lrG6/0suG6zagReW+I/oN84gFgPuHtBtY?=
 =?us-ascii?Q?/20GU3B3Zu/FtagGk7E8SNotr4P1Mxbvb/bpBGgOgz+h0maOVRrW91W07NW+?=
 =?us-ascii?Q?QI1Z1hl7aIk3Jro413LR2tR5gOKaOTdyTtLmpheX3klATTJkmsqSqQlZL7rf?=
 =?us-ascii?Q?gRfZ4gQrJ7RfBMMMU50nnPNARoJv4pGORMHiOjuVPenNT/w8ZBaLCiu4qHzQ?=
 =?us-ascii?Q?YLozDad+OI4LsX2miReW2ITsFnMA5S+q2lnvBBaY6qin8i5Q4h5EGm1FEWYY?=
 =?us-ascii?Q?KGQkNq346oF76RWe49GxKgVsWVZmX2klFN6SE9zugVzSKBfb4yBFxgnwB7Zm?=
 =?us-ascii?Q?gTcd/UxL4F8bKa2S4NOofpW3NcOKDuefj8oITgpoXkH9SGk9tfGMNkw1anH7?=
 =?us-ascii?Q?LidIoyK2Dae41Z4eCGxDoSADgoMObsgXWLRjEs901DlbdBUDH7uBGYw2GjoG?=
 =?us-ascii?Q?MuO6kwbWpRFwZt2LwDv+fur4hbHSNiLGigu3wTAFFNil9MEI9vwLqBNgeg2Y?=
 =?us-ascii?Q?s+cZpGykRT6A/013VxAZNiy3/XKa5EPUOQLHwJ1H1+qwK6lpc/RrL8kjVIAu?=
 =?us-ascii?Q?WxzItz9h/hgOUHhiRLKfLc7ylxsQxBnRvfqZ9jzdN6l2vhhd+O4zxO30cXBx?=
 =?us-ascii?Q?FYyrxi7ZVyl/ZTGigf/+dmYWKTjwV9VUF7/i+zv9WXTNBpgemYzhWowUjlt7?=
 =?us-ascii?Q?PNnIPWFakTMv93JOOVxuoBDZnPvp92qYGlTaglqrC5eQIkufHRy58luyn9ju?=
 =?us-ascii?Q?1DjRQLsTxJpzYJkPtbV/3zGPriyXuyZfCq/bvIjkzgf3kJktuBXJ5KateQDl?=
 =?us-ascii?Q?WyQDzOFh2ZFZikjVZDgwXwzub3jpTY7xWA21lc7F6xW+KGCyYMYT6r/s8hJt?=
 =?us-ascii?Q?dS3iINesJCmFWx2J/wb1JgJCG/Mlbsft2Fp//k3ZGXEIu24Qh/6NdgZzz3qF?=
 =?us-ascii?Q?GA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd922805-bff9-40f3-270c-08da5a0664ea
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2022 19:34:33.8373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jostr1sBuSiD3sLB7dzZCmQ6IlJjZ63icU9N7P2mTLgokphIKUDrikv74GLnVqj42ldEaUpYxhXQdgGYdDDjKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4541
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current link mode of the phylink instance may not require an
attached PCS. However, phylink_major_config() unconditionally
dereferences this potentially NULL pointer when restarting the link poll
timer, which will panic the kernel.

Fix the problem by checking whether a PCS exists in phylink_pcs_poll_start(),
otherwise do nothing. The code prior to the blamed patch also only
looked at pcs->poll within an "if (pcs)" block.

Fixes: bfac8c490d60 ("net: phylink: disable PCS polling over major configuration")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/phy/phylink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 1a7550f5fdf5..48f0b9b39491 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -766,7 +766,7 @@ static void phylink_pcs_poll_stop(struct phylink *pl)
 
 static void phylink_pcs_poll_start(struct phylink *pl)
 {
-	if (pl->pcs->poll && pl->cfg_link_an_mode == MLO_AN_INBAND)
+	if (pl->pcs && pl->pcs->poll && pl->cfg_link_an_mode == MLO_AN_INBAND)
 		mod_timer(&pl->link_poll, jiffies + HZ);
 }
 
-- 
2.25.1

