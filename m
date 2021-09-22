Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD77F414C36
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 16:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236284AbhIVOjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 10:39:25 -0400
Received: from mail-eopbgr60064.outbound.protection.outlook.com ([40.107.6.64]:12042
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236231AbhIVOjX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 10:39:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZcDo1JW8Thgw7GkEWr9HRmTKZIz9BPE6rqIfzV/SvJ9PGJbxGBFkPl3BrymvfWZEktn2Htq1Bd1eqIPmMjoZ1OXXwxkSTpNDtIHGlKoMflXnKDU5VJA3Ooxjhg7aOov4NbJ910GbEf7qD/lqaSHWAAlk1mLfELXlgQB8cPXTBfJC7c3JXAnbeP7fecAjErqI/qOIUXrEOHpLrcndcuwhepAC5cLjnFOio/rLlSmN+QHJiK5U7mjN1KQpzJytpWQeZZTbk6lwRB6vaK4eF78JSCnByA/LbS669sP06rSHv/LSp6GTB3vdSKNY4jG4VTWYVbl2uAS+542JnvI99KE/Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=jCVtrouVoPPE/B9RvJ5rjm/xniD1+deC4riFJecjBVg=;
 b=Es9k90Re1efjvYg7sVrvkb3Lmka1g9tAHPoo43GHOSI3ACxqdMuSVPtJOIjBt59gvJ6Is7EqwIDwSYSRUHyW48eROwm+lCyGI0U7m6hlwaBYK3DLYQnrv8xtuvzfF9Ooq7ZF6PDuaFsL5igfvscKP5MawMPjUPgBprXYdccD3vvYypZr5OaN7KIRJG8n15ZCaNoRoEIvk8DQ20J4Bh9+WawhS0Ga7Mz5sa3dcUHfSCfz3ebMzSdOPHf12oCQp/pF6pwHcDLE/teAdkdOMlsk+lb2foDzZ8kaAibcRSKbAe5dxY4puYaAfBHx/phhTxqgroi65VgAxCPd8Osi0nlTMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jCVtrouVoPPE/B9RvJ5rjm/xniD1+deC4riFJecjBVg=;
 b=M7/bY3DUl4dbekDDxwIC1TD8/uRABbxgrukNmIj0J9myVIwKSOo9a8fCRsI60xPh4cxsRQjfzj79EXD2qCsIYQpQ9SW7HicwbZxp4xMjD0zBsIUSoGzj6GvRv4g2//tvW6ViSF2ZCJksr3EpR7v96h/ycxrV8ZhPQG8pnGKTeZI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4431.eurprd04.prod.outlook.com (2603:10a6:803:6f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Wed, 22 Sep
 2021 14:37:48 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 14:37:48 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net 2/2] net: dsa: sja1105: break dependency between dsa_port_is_sja1105 and switch driver
Date:   Wed, 22 Sep 2021 17:37:26 +0300
Message-Id: <20210922143726.2431036-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210922143726.2431036-1-vladimir.oltean@nxp.com>
References: <20210922143726.2431036-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR0P264CA0207.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1f::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.53.217) by PR0P264CA0207.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1f::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14 via Frontend Transport; Wed, 22 Sep 2021 14:37:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d4ee5ddc-50e5-471b-49de-08d97dd68c9f
X-MS-TrafficTypeDiagnostic: VI1PR04MB4431:
X-Microsoft-Antispam-PRVS: <VI1PR04MB4431016FDF55DC933DD00095E0A29@VI1PR04MB4431.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pDRESAkEZmsBiDJ6J3ddoxsntbshG0QR1a3HbxK/+CX+liHrmqiNCPQ+Tzorh7STiSYQ+WEapdRPMKlNoysq+/va1qTuZVWLWgHh9lesUIaIGzn3RTVyy5aeCpyFscGjmhrSy+TGMHT1U83Vaftf0hBxqoGROXz3bPaRF5wlAeoQ2kUlunpmtRleJVBOuEDZvbRpNx0nETXpZ7gZa0iACqEn8RjUtR7Def7tenetTFbtgCxU9d9CAiNv0IJzotiHEKphAkzJezBjXxZZYnRD8nS6boTHlC2hbjZShdESS4TOWwzte1x0/Xbti9PsDlF8RJKjBoPvfo2t53zEVKiLabbPdHnIMc2C37H1jH7X5tDqm6oOwaN/E7NFLX5hCzuGN4wluaFZ+L1SXj2RuPe4aVRP/xYCoA8seF5+a/7bEqxstYkd8TgTU3NUPo5XEirZhzYc35iX6WUbRWp1kC5Vh/uI3Qr9Guh8Df+6Zt7J7Kv9DJrJHeVWTUJuHcuKPYOw1nz4uN0vK33PNzM2CGq8kM/ZnkIdXHJEzlqzv2tqroTNpClcNTNEmcnyQSPJ8bvkNgKf/ggTS22S8h9HNbiP0nVsrD9X0TbiiuOOo0IqFg2foJOWmIHxY5eQ0b4QHp5w2GH74uY/bOJApAUYtJvgLdpOrwJHpt6dFTJ6tj40nFijRdsaEkN1bjRU/C2wflHssmTJWlxQCeO6lLZPTAZgCvObnUUuP785gyJPyc2QGVDgE/pIy3OUwaWB30Q7YehiVeJ90Ixy7e09keMtTowajKZyva9LobNumDpfx52lu0c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(83380400001)(316002)(110136005)(44832011)(2616005)(508600001)(52116002)(26005)(86362001)(4326008)(66556008)(186003)(36756003)(5660300002)(66476007)(1076003)(6486002)(2906002)(6506007)(6512007)(6666004)(966005)(8936002)(38100700002)(38350700002)(8676002)(66946007)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wBOGZ67B88uH76LH6huXXKk378MhIBDuyOwBaOVS89Ypw7O/e5EANj7QA5rj?=
 =?us-ascii?Q?YtpW/aTHVyLs+RycXAPNuQLDf+9z9wVziU6GwH7XFiZYKpsi7UzaTfYpF+yM?=
 =?us-ascii?Q?eoyNKxXPhBc6Dr5MjPL2lIMxo52nYGoH2kovdEKFnsrs4N4yZTGYYGENRJEB?=
 =?us-ascii?Q?bAE2NRmNVWswVvxRKqPelUuwxAqW/aR+PdciFcknqXuLYUwp7bG6flKvAnG6?=
 =?us-ascii?Q?3ME6V7qsCmn8zc0SfX7f7o8iAbDAxBhx4PN4ukEuT7Cz7AZLvAv7SGfAaQ0t?=
 =?us-ascii?Q?cxNHLVkRkL+Ix5prcNw3SIWTqLOxTTPFN3n8PovKquTGJUEYdSVR8jewahQk?=
 =?us-ascii?Q?U4cDseq5y8qKqCJwUb3/CXknaGhya3EBJSNkQ2caxz889nEzCcXEXI14OVne?=
 =?us-ascii?Q?+/iNb6+MvWPcs93wOazEwwUqDIb1aYMHf+0AT10bCHT6Yg1HeNj+17XsK/Ez?=
 =?us-ascii?Q?mgMouNL548TXjX/e3geUDkem186VwjWG3Pjn3XM+Tas8zlOChr+fAG8ZaZGP?=
 =?us-ascii?Q?73ntYzt9kZ3Q6Y/zOfhqlgrEjmWs1m546hSxpDbvUw6KOwuQ8faF/YL9ZQ1+?=
 =?us-ascii?Q?asEFa17qrSkCdywbxnFvC1BZv6IryZgNC2k5MLZpMXX69hhRm0kBeHSHpcGp?=
 =?us-ascii?Q?L/s9+5BHOD+Xl8CyF9jGrF4KfYd5p/E+/uArVC705wIVUJ3qFAASYBU1vYS6?=
 =?us-ascii?Q?HlAIFQxJ0RC7ArkX+jhX2s39Yp3pSfJ7FR8RRXRijqyM6QIVG2dc9D6wLUsx?=
 =?us-ascii?Q?mGRM/6pfUcNZJkH8raLtK3amhA7oDbZQp1xlcPIiuGBsRrgrXatUdGeI2cWu?=
 =?us-ascii?Q?bhqu5stprGYM/As++lQlTQxRDl2S8kceYrUjPLWdiUKgGzWmGAXYpvDbCaGf?=
 =?us-ascii?Q?8jAkjJASMySea5bLHnWWs+HXZej0tl3XSu1ruKv1jGCK2n3H1VpBAmYOtehG?=
 =?us-ascii?Q?t9d3BcGp51EWOl7aFIgaf6N7RLpmaGD+CJOLVTxNAnzNzvun/DM6ghtxl7o6?=
 =?us-ascii?Q?HuCIDt9dARg71i3RUButAv9N1NLO1X1Tdzo5P9uWWhcwZG8u/XjEDLdl56K/?=
 =?us-ascii?Q?u4DPi+13krdHo1Q4oGwb6IVBSle/auYvGjLv/hR5tiCqEvRxAHgm5f7YPdNm?=
 =?us-ascii?Q?E62UMh+0ODawEB7RBI/chhZia+zaMdeZPdtFRo3Nng3Gopu6n0GukzwA7yaD?=
 =?us-ascii?Q?TTw66zOC+Zfk4dvJ9gDoDOOi/AfI3gei7KxW2UPc63W59OxA1cUfyhWijBbK?=
 =?us-ascii?Q?U3I6Gv2DHDEfFFCJR/tq7tUyJMSN9ouABH+Fyg07JlyWbY5GGByz9X0B7Pd8?=
 =?us-ascii?Q?GhvL0273Ko7dfYoGHM/auWkn?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4ee5ddc-50e5-471b-49de-08d97dd68c9f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 14:37:48.6517
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jNL3JPMzHp2xDyWll2L9akuRay4QLLZNCf1ntew9Q1NfGYAFueT6ZSzS6Ecc3CQPyOblCJWxUHHvKf3TWkUTgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4431
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's nice to be able to test a tagging protocol with dsa_loop, but not
at the cost of losing the ability of building the tagging protocol and
switch driver as modules, because as things stand, there is a circular
dependency between the two. Tagging protocol drivers cannot depend on
switch drivers, that is a hard fact.

The reasoning behind the blamed patch was that accessing dp->priv should
first make sure that the structure behind that pointer is what we really
think it is.

Currently the "sja1105" and "sja1110" tagging protocols only operate
with the sja1105 switch driver, just like any other tagging protocol and
switch combination. The only way to mix and match them is by modifying
the code, and this applies to dsa_loop as well (by default that uses
DSA_TAG_PROTO_NONE). So while in principle there is an issue, in
practice there isn't one.

Until we extend dsa_loop to allow user space configuration, treat the
problem as a non-issue and just say that DSA ports found by tag_sja1105
are always sja1105 ports, which is in fact true. But keep the
dsa_port_is_sja1105 function so that it's easy to patch it during
testing, and rely on dead code elimination.

Fixes: 994d2cbb08ca ("net: dsa: tag_sja1105: be dsa_loop-safe")
Link: https://lore.kernel.org/netdev/20210908220834.d7gmtnwrorhharna@skbuf/
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c |  3 +--
 include/linux/dsa/sja1105.h            | 15 +--------------
 net/dsa/Kconfig                        |  1 -
 3 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 2f8cc6686c38..181d814bd4e7 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -3117,7 +3117,7 @@ static void sja1105_teardown(struct dsa_switch *ds)
 	sja1105_static_config_free(&priv->static_config);
 }
 
-const struct dsa_switch_ops sja1105_switch_ops = {
+static const struct dsa_switch_ops sja1105_switch_ops = {
 	.get_tag_protocol	= sja1105_get_tag_protocol,
 	.setup			= sja1105_setup,
 	.teardown		= sja1105_teardown,
@@ -3166,7 +3166,6 @@ const struct dsa_switch_ops sja1105_switch_ops = {
 	.port_bridge_tx_fwd_offload = dsa_tag_8021q_bridge_tx_fwd_offload,
 	.port_bridge_tx_fwd_unoffload = dsa_tag_8021q_bridge_tx_fwd_unoffload,
 };
-EXPORT_SYMBOL_GPL(sja1105_switch_ops);
 
 static const struct of_device_id sja1105_dt_ids[];
 
diff --git a/include/linux/dsa/sja1105.h b/include/linux/dsa/sja1105.h
index 0485ab2fcc46..9e07079528a5 100644
--- a/include/linux/dsa/sja1105.h
+++ b/include/linux/dsa/sja1105.h
@@ -88,22 +88,9 @@ static inline s64 sja1105_ticks_to_ns(s64 ticks)
 	return ticks * SJA1105_TICK_NS;
 }
 
-#if IS_ENABLED(CONFIG_NET_DSA_SJA1105)
-
-extern const struct dsa_switch_ops sja1105_switch_ops;
-
-static inline bool dsa_port_is_sja1105(struct dsa_port *dp)
-{
-	return dp->ds->ops == &sja1105_switch_ops;
-}
-
-#else
-
 static inline bool dsa_port_is_sja1105(struct dsa_port *dp)
 {
-	return false;
+	return true;
 }
 
-#endif
-
 #endif /* _NET_DSA_SJA1105_H */
diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
index 548285539752..bca1b5d66df2 100644
--- a/net/dsa/Kconfig
+++ b/net/dsa/Kconfig
@@ -138,7 +138,6 @@ config NET_DSA_TAG_LAN9303
 
 config NET_DSA_TAG_SJA1105
 	tristate "Tag driver for NXP SJA1105 switches"
-	depends on NET_DSA_SJA1105 || !NET_DSA_SJA1105
 	select PACKING
 	help
 	  Say Y or M if you want to enable support for tagging frames with the
-- 
2.25.1

