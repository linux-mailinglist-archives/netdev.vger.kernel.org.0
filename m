Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9F3C402775
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 12:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343697AbhIGK6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 06:58:21 -0400
Received: from mail-db8eur05on2042.outbound.protection.outlook.com ([40.107.20.42]:9677
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1343685AbhIGK6R (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Sep 2021 06:58:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DUGFYC1vU1YwDbNFSGJh4ihmVZBJvzNXYmgvqirnoCDMYDbCcSDYeV18ZbsqQyful1f+9KtDf6H+AfF5Hy9ZnDO8Z1/M1gAH1c4UEhTOizqI/Mn11+41/o3f28Z1KYuwOnV4+9A1dX2618w1J75YzJeoRI9UKHbYUZ3Cmvp25I6Sn75yGPMJeb3yYNkw7yPY6/RgjMB0ULEmAvMGeLdLVeMUkanxGNVidnlontp77yrWtGJ58fAG/f/Zv948jIz0T5q3MG81BMBxJzJ9mLB/N2LTL4A2huj3269tbFM2WiNZbZ8he8CULYtn1r5RPaLYGS/X/XHp34Xkzyi7zNTyVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=91JEltll2f4dC4e8q5WhoS1JMsKPgMU/VAfm96LpZic=;
 b=Ck2PAAVY4er6pUOR3sI18RpzDPypSubq32q76Y2dCFGpKPYMdkbiGAUIft4Z3KsAQF2iSUOQHO3BkpdWiW0vfrrL53SU+OLajOrqEEXZLiWVDfD+U70p7a15A92sHBS+05XlJonTjM4jyZOAHQmk+Avf2S/+xkG/y0/vyhR7wIQQoef6bhLuclsw2+ceztJL1NpUkQqhNFfhLuoMtfW7tcvOkrHBQAYlJXKI6haoJCvT/E75dXyYL8hmss7gu02H2BHvHkhbUjWypmvfEA48vJ2IEPX8FUZn9JyRB8cABvmmx9EvHdJHF6qUpPlcoQwMTelExQW7CuMxUaADRx0FNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=91JEltll2f4dC4e8q5WhoS1JMsKPgMU/VAfm96LpZic=;
 b=grstrSBBIjjtrWibhFJNc/ViZTP0m/7JyEf37l/oP/tyaW7w0P/pG9p7I1j4p9RSXYUe6KSp9eTwUujsNLOfXAgEur8PAHIU1f6MgX7fCXCqz9HfU17QGEpaVjFtyzUEwokf3PUEImAG0D5P+iD7FvCE3HffdxLPNzi2X+JDl38=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7382.eurprd04.prod.outlook.com (2603:10a6:10:1ab::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.22; Tue, 7 Sep
 2021 10:57:09 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::5d5a:30b0:2bc2:312f]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::5d5a:30b0:2bc2:312f%9]) with mapi id 15.20.4500.014; Tue, 7 Sep 2021
 10:57:09 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, linux@armlinux.org.uk, andrew@lunn.ch,
        hkallweit1@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com
Subject: [PATCH net 1/2] net: phylink: add suspend/resume support
Date:   Tue,  7 Sep 2021 18:56:46 +0800
Message-Id: <20210907105647.16068-2-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210907105647.16068-1-qiangqing.zhang@nxp.com>
References: <20210907105647.16068-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0001.APCP153.PROD.OUTLOOK.COM (2603:1096:4:140::7)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SI2P153CA0001.APCP153.PROD.OUTLOOK.COM (2603:1096:4:140::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.1 via Frontend Transport; Tue, 7 Sep 2021 10:57:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 790d13e5-675b-4096-f180-08d971ee3cdb
X-MS-TrafficTypeDiagnostic: DBAPR04MB7382:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBAPR04MB7382198235C7F8467E52A811E6D39@DBAPR04MB7382.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I9cqn5As9fuIxGP5xbOZfFztkd9J3srycY+p7objCj97GXXTpB2fmF0e33nG7wCEwpI75uOlJQgr9ZY9r7KWXjifg2Ar2iRUFILfKdKUgtqW5O/eceb6UEYbCIYjVfnDPf0TCADinHH7RMTD+KQzJKNjIHZn5XCsnu9vTbFQN4laHt1t0vON1YAvOA6Pv3zjT68R/Osv9yT6dorM3/uqsoZ2iFj+nECGlnrnX1CXJJwm9pJmlXq4qknqVG0v0MYiIl4LwKICVzwePh86Ii5gOGvQXLT0AHI85XO7/vex0WGfBkatEpIY5ASkUUnQ6mefKQlPovEJNOXUWr+04plveVWlaJdLfHZdhpByUc6piNO9pzVaNVPEX4e1MbpXsks7ydsyCQJczooMJGNAO/904ikptX2ODNjayFO7vgolzF8euyQheRpADrP2FwVKyflEMZ4Ay1J0jlsbqlzz+Z+VwpbrPBxKKhWy85gheyUEudx7+JZeU5wiCpXg6D8X4UHngiwxcVQMP7jnImjOXNtVZu5cqawFpjSKhDc97PN8wGuKIDYz9FCEV0AIoGqKUt66BgX7qM5MV0bix/TRGyOQtLAUDwiUNKLMwBUKfWsHNaLDAPLPy4E4gWo9tomG7TgbKzzm9ziZPl/FdAsU2z887OfLL+exeaLSjksLF7WJ8g5CuJ0UZRi9pLCNXyTK0MwWKUE2zPhmupWcDx2fAXXsEw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(366004)(396003)(136003)(1076003)(316002)(186003)(52116002)(8936002)(38100700002)(5660300002)(36756003)(38350700002)(15650500001)(26005)(66946007)(86362001)(4326008)(2616005)(956004)(2906002)(6512007)(6486002)(7416002)(6666004)(83380400001)(6506007)(66476007)(478600001)(66556008)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YHTp7k+5aK5o3ed5z6p8gfcroZD6hHwzlB/6ekIuhHCtIUTecLB0CE4nbOlU?=
 =?us-ascii?Q?mCfPryil6zPn2/ft2szCBZsyp8J0FX0D/bV+RSe2NzNe5161iDnQ8BPiTLTr?=
 =?us-ascii?Q?P3llKJpNscbrQ78qMiihf7Ugvx90aoIgGa6nKpcLzetSVlnE0zJAUyowf/oT?=
 =?us-ascii?Q?oUPQHJNIbYTWWI9VD1QMihCUkmlR936gWkr6+HLRGGi5YCj6ii9DtLg+lkvs?=
 =?us-ascii?Q?syigfXQMnO1lldq8iwjfCx2NSJ9fEtd1E2orhpQWQK7PXODqSPi791w9VPu5?=
 =?us-ascii?Q?H12vL1BzjDkTKFemebvcoDznkIoLhACgGdlHv8X11uqkh6+F3cExeiIAJcA1?=
 =?us-ascii?Q?ksDR+/hXQUoP6EgDpfvnd7Gx8M++4qxDa9drCso2Gwx/rNaSQ/+7OrDeEqhI?=
 =?us-ascii?Q?VDO5mWc98wEveQX+2pcvK0pix+bY75HV8fbhA3nQb7oXOtbkm7Hxf4y/5fpR?=
 =?us-ascii?Q?FlqhKBYw21d56SVEspzCfzHy82HqsoYE3hB0FEmG4nOFJZ5RY2xbPB7m2J2D?=
 =?us-ascii?Q?0N8663KnSJ6zlAlzRDyw2hOASRABqZ8Ve0kZMYOHuq5HljhPDGp7sw32/NEF?=
 =?us-ascii?Q?tebRhhunpmP1aE/r3l7YxbTU9sgxC3pS3nAXQVBLTPUJtqqRxmiqvqBCASDK?=
 =?us-ascii?Q?8ZdnMMNQ6zVdn/l+JkqAyKmxD1BCLU41UEuBtbp70j/En3un4Nj3IuMy4/WA?=
 =?us-ascii?Q?WsQ2/M6dR9F0EPlY094El1HNMS9JTfuytag8qnwl7tRBJHGDSFQ0m85Iu7dB?=
 =?us-ascii?Q?uVEuihIWNlHtsk2kv6Is2B6Oaahz7SWbpLI243lGjVK764FEDbcSBFGj4Jp2?=
 =?us-ascii?Q?5ey8k32iTHFn6UxLlJSipMH4Xdd/iWNfxXMD1PPpvPpWT0Bg88JP327vUSHz?=
 =?us-ascii?Q?l70RIlqdh1p6wCemgAe5nAaykqlixsZyN6PxlQ7pZM5FwR44ty5wkmhFMD4V?=
 =?us-ascii?Q?v2bzZWwVWrvwIwNLulMeDIyZ0wMgfOWpi+MGRtZD7N8QZdrTLAbQaMXNBiek?=
 =?us-ascii?Q?Xv7BxPmdq66KJoKgoxd5yVEINIahiUi/kH+Cxii6dKuR00A7jGYQ3sY0VzZO?=
 =?us-ascii?Q?H9mftX9KhmmLMCuf0pegMA6wm4PiZz9zpvNI8jsO4AIo6RN1x8BFWl8WTCk1?=
 =?us-ascii?Q?sLeCdWmWPAGE7PhFmIeLh9lR6DQKo8mDyio5Ysf/ou9wZhihoo6RUN0mKjzp?=
 =?us-ascii?Q?8qodNi0YmK+3YiY6k+qn1D9eMDysyc3mBZA1YjiyWjm3vxZGloxFyYJJwAYK?=
 =?us-ascii?Q?JUMW4IZ+YeFxMSQHowL2xWFijkSAx24JR4YL/mGbXQ/ta3jHaosIKlDfieWt?=
 =?us-ascii?Q?WRpfwaIxmO8tS3EBPbBLM11b?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 790d13e5-675b-4096-f180-08d971ee3cdb
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2021 10:57:08.8759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BV80L2hBDD/KDZChvJlLpvM2C7XnxwoXVJD9XsQyDyjIrV8jAlqlNxFKA8m4X6QBJWdbFw6CwdoWS36oImnOMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7382
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>

Joakim Zhang reports that Wake-on-Lan with the stmmac ethernet driver broke
when moving the incorrect handling of mac link state out of mac_config().
This reason this breaks is because the stmmac's WoL is handled by the MAC
rather than the PHY, and phylink doesn't cater for that scenario.

This patch adds the necessary phylink code to handle suspend/resume events
according to whether the MAC still needs a valid link or not. This is the
barest minimum for this support.

Reported-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Tested-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/phy/phylink.c | 82 +++++++++++++++++++++++++++++++++++++++
 include/linux/phylink.h   |  3 ++
 2 files changed, 85 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 2cdf9f989dec..a1464b764d4d 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -33,6 +33,7 @@
 enum {
 	PHYLINK_DISABLE_STOPPED,
 	PHYLINK_DISABLE_LINK,
+	PHYLINK_DISABLE_MAC_WOL,
 };
 
 /**
@@ -1282,6 +1283,9 @@ EXPORT_SYMBOL_GPL(phylink_start);
  * network device driver's &struct net_device_ops ndo_stop() method.  The
  * network device's carrier state should not be changed prior to calling this
  * function.
+ *
+ * This will synchronously bring down the link if the link is not already
+ * down (in other words, it will trigger a mac_link_down() method call.)
  */
 void phylink_stop(struct phylink *pl)
 {
@@ -1301,6 +1305,84 @@ void phylink_stop(struct phylink *pl)
 }
 EXPORT_SYMBOL_GPL(phylink_stop);
 
+/**
+ * phylink_suspend() - handle a network device suspend event
+ * @pl: a pointer to a &struct phylink returned from phylink_create()
+ * @mac_wol: true if the MAC needs to receive packets for Wake-on-Lan
+ *
+ * Handle a network device suspend event. There are several cases:
+ * - If Wake-on-Lan is not active, we can bring down the link between
+ *   the MAC and PHY by calling phylink_stop().
+ * - If Wake-on-Lan is active, and being handled only by the PHY, we
+ *   can also bring down the link between the MAC and PHY.
+ * - If Wake-on-Lan is active, but being handled by the MAC, the MAC
+ *   still needs to receive packets, so we can not bring the link down.
+ */
+void phylink_suspend(struct phylink *pl, bool mac_wol)
+{
+	ASSERT_RTNL();
+
+	if (mac_wol && (!pl->netdev || pl->netdev->wol_enabled)) {
+		/* Wake-on-Lan enabled, MAC handling */
+		mutex_lock(&pl->state_mutex);
+
+		/* Stop the resolver bringing the link up */
+		__set_bit(PHYLINK_DISABLE_MAC_WOL, &pl->phylink_disable_state);
+
+		/* Disable the carrier, to prevent transmit timeouts,
+		 * but one would hope all packets have been sent. This
+		 * also means phylink_resolve() will do nothing.
+		 */
+		netif_carrier_off(pl->netdev);
+
+		/* We do not call mac_link_down() here as we want the
+		 * link to remain up to receive the WoL packets.
+		 */
+		mutex_unlock(&pl->state_mutex);
+	} else {
+		phylink_stop(pl);
+	}
+}
+EXPORT_SYMBOL_GPL(phylink_suspend);
+
+/**
+ * phylink_resume() - handle a network device resume event
+ * @pl: a pointer to a &struct phylink returned from phylink_create()
+ *
+ * Undo the effects of phylink_suspend(), returning the link to an
+ * operational state.
+ */
+void phylink_resume(struct phylink *pl)
+{
+	ASSERT_RTNL();
+
+	if (test_bit(PHYLINK_DISABLE_MAC_WOL, &pl->phylink_disable_state)) {
+		/* Wake-on-Lan enabled, MAC handling */
+
+		/* Call mac_link_down() so we keep the overall state balanced.
+		 * Do this under the state_mutex lock for consistency. This
+		 * will cause a "Link Down" message to be printed during
+		 * resume, which is harmless - the true link state will be
+		 * printed when we run a resolve.
+		 */
+		mutex_lock(&pl->state_mutex);
+		phylink_link_down(pl);
+		mutex_unlock(&pl->state_mutex);
+
+		/* Re-apply the link parameters so that all the settings get
+		 * restored to the MAC.
+		 */
+		phylink_mac_initial_config(pl, true);
+
+		/* Re-enable and re-resolve the link parameters */
+		clear_bit(PHYLINK_DISABLE_MAC_WOL, &pl->phylink_disable_state);
+		phylink_run_resolve(pl);
+	} else {
+		phylink_start(pl);
+	}
+}
+EXPORT_SYMBOL_GPL(phylink_resume);
+
 /**
  * phylink_ethtool_get_wol() - get the wake on lan parameters for the PHY
  * @pl: a pointer to a &struct phylink returned from phylink_create()
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index afb3ded0b691..237291196ce2 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -451,6 +451,9 @@ void phylink_mac_change(struct phylink *, bool up);
 void phylink_start(struct phylink *);
 void phylink_stop(struct phylink *);
 
+void phylink_suspend(struct phylink *pl, bool mac_wol);
+void phylink_resume(struct phylink *pl);
+
 void phylink_ethtool_get_wol(struct phylink *, struct ethtool_wolinfo *);
 int phylink_ethtool_set_wol(struct phylink *, struct ethtool_wolinfo *);
 
-- 
2.17.1

