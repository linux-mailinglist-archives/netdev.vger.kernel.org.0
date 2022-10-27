Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42FE160FAE1
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 16:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233473AbiJ0OzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 10:55:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236026AbiJ0Oy4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 10:54:56 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2050.outbound.protection.outlook.com [40.107.22.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A6DB1A202
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 07:54:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eH5q7P4uVdRj3gj1fsbztQEuyr7wDvykKktlYySFtkYl592C63UM4Xs7K8od3iX9m4p28x4INKtJJqd/MPuMi67j3fRiVfyWV996cyttjaS+clIOYKw1z3gNxpSt5OaHrdhdrEAjvfQ3ECpfrz364D8K6vDzFVF7PmAVx1XhBfRVRFMYMARtWjV+lCHpgWzi17GYOutBlzvhpUrh0Zjq0Dt3GUVkf58nhOPp7BBP/cVnSQoz9QRQ5J0B9EgN5RNUYIszVmgRQft3g+drJ6gC4OUGivTQZo+LziGBc/kxbd9KXrjljpum/LP1sDqXtP3qfZnYgSpdQ+hb9pRRH7ybVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fiEF6UHV0boHTHdrsd1IB8UwCQslNjjJaT2Pr+3pOKI=;
 b=nmFGLnfnLDWHMgqjXPJU55qdRMIXfKrh1JicOjHX1hyCijlt3/FsliEOu5qQAvvtowFKi72ZdjABhCFRtPxxlnSonMgi/sM7PmDHRt88XgHbREPikwCib3zJzV4+EFTN0OjeTBKF6Sj5DTs8Jom4WBTEr79aQ3xRoVmf+ud7DSirSprdGMymkAY03INWL7SJjZT8w1BOT4iEo01FKHNqyx78a97avWlE6gVMWhy+BbErkrXPfSekeF0WD+w/lg5lr28iiLIUtCirDcFOQ2z7hUi6LIp65R2SHuxtjpiyr/q5YUpAhyoMFHF22EbECrd/EnLG6LafFGlj2/2Y3/utZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fiEF6UHV0boHTHdrsd1IB8UwCQslNjjJaT2Pr+3pOKI=;
 b=OlIQ2F4ngMKfbHLMJjRCtcm9itl6s6gI+9hZ+pAO99RLeQ9g+dTmvuC0QeaRZ3TlzB72h4IrPv6WDV3MNzmmVc1hc8wUmEvhJn1uoEyjZVDjZTsca+e6TAmz8o6q1A1AiElxQlz8lxIvJtwCST/ujlfEqS3cB7mF3hBgBQMp5EU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7990.eurprd04.prod.outlook.com (2603:10a6:20b:2a5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Thu, 27 Oct
 2022 14:54:53 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::6710:c5fd:bc88:2035]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::6710:c5fd:bc88:2035%6]) with mapi id 15.20.5746.028; Thu, 27 Oct 2022
 14:54:53 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Michael Walle <michael@walle.cc>,
        Heiko Thiery <heiko.thiery@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: [PATCH net] net: dsa: fall back to default tagger if we can't load the one from DT
Date:   Thu, 27 Oct 2022 17:54:39 +0300
Message-Id: <20221027145439.3086017-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0027.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::40) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AS8PR04MB7990:EE_
X-MS-Office365-Filtering-Correlation-Id: ea05043b-18a1-4cd1-9811-08dab82b3457
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TcAF1sZ7HMLwpsBEqtZDKzupkRoNXmb5EvEvdgEMqXSokOGqyYRLY6SfJdSfVkiB5cw/RHU7frywiFQqH+1VH7XaF3qzVVSeR0yNAhiTs25uP/8WuOJY523JRfYZR+KBy+qcMkgWImYDY9ydJpCzqUOujG+/EYLR0WR4jMuF908z9adZ57LYiygBtUgwV7ACM4orZYjKxo0Re3/NAg3vk8IOrr91+VhZ5wwWcHwSnBxK6AqYhqz211Iq4yLxFs8w1bIL5Sd7gD09TTItNRy1DdzRR34jQJadXo+ZpbT3MKMhHQjJnTicDjUBfik+mrUuZ6Lp/Iqdxspuxa6dH6xBS7GUaFsun3NCekEmryxQd4UX+X3ul6N0wUAzbTf3c+GAGDoIySftQZTc9+R0/pfWntm3mj2qGpv1lmzSW16BH4kkipH1UL9V2tWSt+GLvgw1Jo5rynDUwCkjXnY8r+smUux+1o9mtB7tNs9yarbN9j5HjPTZd67In/RixwmxypDxRBLCFyVWeRyGkLWHbc7VRkECfoUX1PqSRmlfPhqeXCX65JVIdaDQqUNboqM15NR8jaKW/cdb8agdiw8JvzZLFfzSPU7fNy96+hQ6IHyd6H7BlJDQaPoXeSsAU+xQsyUW35TeoCD+WwiL7/OIN/+/gFjijnzkxdSrGxj9nVFH7nXTaDhkzOCzlWP/cY8Xt8totnZDnHmFLuRqCpTaVdHhELMv4rcunhlbcRJCXtcrvpB/z4mUhyXEfaGzHgrjhAFYqRMVUYeGT56eI47fG6A0yDZmc66YjR0L50iN7G9AGkk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(346002)(376002)(39860400002)(366004)(451199015)(86362001)(36756003)(38100700002)(38350700002)(186003)(1076003)(2906002)(44832011)(52116002)(2616005)(26005)(6666004)(478600001)(6512007)(6506007)(83380400001)(8676002)(54906003)(6486002)(7416002)(8936002)(6916009)(66556008)(316002)(66476007)(4326008)(5660300002)(66946007)(966005)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ywbKnakFqB5u5dOm/7bbDv9jun2cuKCoK6pQ1CACEzxZYNjAFKGjns6XoWEB?=
 =?us-ascii?Q?dc2VybgpEupu7ER5B9PBc2wNp5/cQEQn+/cJyx6CwHieLz98k8vbdtrDCzmj?=
 =?us-ascii?Q?tl2wOx0J/8gkyObSeCJNKC8QCaB/iyVEpLt+5KpnZHpW/wWCONExTYhXH/6l?=
 =?us-ascii?Q?zoqmoplnbmz82Kgx5cPve5x6xOfWBKF2sAfIIoW4eVrSqldtDygB2g+83svh?=
 =?us-ascii?Q?IdPs2/D3n7me9ngz0cY7OdtdfhEThaxp23ShGh+rOX0P+bFcrHtEmIi8Rk8Z?=
 =?us-ascii?Q?WWzZzR7i17d7qS5921LuVOHOht+JgxFMUdhFHgPJ78qbPGWLdozMS9oFXMuJ?=
 =?us-ascii?Q?0/XHOl67xTiRo1LJb2RX7uqhzEeg3fV99j8fX1Pb+H8zje3b6p1KpDaIIDFp?=
 =?us-ascii?Q?RUkjup5JYi7cDBq/bwQXUa5YjZ9OKFaLFT9fDLI3+Uqtc77h/FN8Gga9wJgj?=
 =?us-ascii?Q?ynnLpWGbah/2nWi9JdF/n6ga9EOeRRM/2hhuyNiHtnnOLmiuPt9bMcrIwVV3?=
 =?us-ascii?Q?oif7SxjSMlBIB0/4ZX8ztrHThghohbVxl9Zh5tZ7vVIUYe2CJLp6S3ixxqNu?=
 =?us-ascii?Q?LVFC1O9l1GMdFBBzqn6i2uAZmQuZDJnXOTYPJBv5J1Sh+b26WnuNQRr1ryj9?=
 =?us-ascii?Q?ta47C8VAk+Pn4eNA/Lk19sCJ6Rvl0SP2b8p6p8dFdZuGOJNBlQG8RGVOr8nQ?=
 =?us-ascii?Q?xTiyTEXl+Gc+/XYGnlsOhF3MbxYuNKvEVw+naaKArgR2iZZLm+9/bo78Hzms?=
 =?us-ascii?Q?NgQg3zgwjLb2Xxxmg11YvJKjUbwbrqqDjk0T9l2wG0zVMwjn9v2j89dJcvRz?=
 =?us-ascii?Q?AFvsZgmC99n4HgRBzp0dvE7zWLT1eztKGkbppHZS7tEB8lEaD+rjadrRSstK?=
 =?us-ascii?Q?yOKclh9dvo0R8lptGe0YG7vghsSUAbUyudwaqYyHWoGogvEIn76D2Y+erK/w?=
 =?us-ascii?Q?OZ0qwrQT7rVPpuLThjD7/DZJnnY/mcceS+5y/0BtazLU4uZXyUPYbYWDKCsc?=
 =?us-ascii?Q?5QhkMT4rMrLrSkfvTr8C76Zw+PzYXPE9or+nG/ZgWJlFnfcmgPRms+ocyLjf?=
 =?us-ascii?Q?SGegwQ3sP6+T1WvDnTCqsYe02Lt0ohxa5WpfmRoPCtwarViiq/cHJzL167o/?=
 =?us-ascii?Q?5YMsOHWUsBgz5KpFaKztIgUyigYbP3ukhZWPyRHu3ja83MV/8zdwqdHdUJSr?=
 =?us-ascii?Q?QI6F9Gb+N3qWUuisaUD9tuCvwKBSfPhwB9XExP69z5FVDtYkeZtA23XdnVuu?=
 =?us-ascii?Q?lKA/8K0I12zfgi4DGYc7BAQ0aFTtoASDx+CywrIwxIYYP/rDMMzpl2tleP3G?=
 =?us-ascii?Q?VSleQ3hXhOqUeBunXchSn8tsRpGHiakklyj9JpfwDNEmMX1IsROdSdIyVU6c?=
 =?us-ascii?Q?PDzqy6gAKAwChcDNpMPKbuYiH94mRFx0jVf94BvrMZEdOgMEtQgMVZeZdxt+?=
 =?us-ascii?Q?wkyQ7fathJHghlhRfRokuAKyhfztgKYhH6cpVoDX0gxJ5BAXse5a4TNSAIid?=
 =?us-ascii?Q?BKealEG4fTvsbDu/xYIcdPloBGsuk30lVfLCb7lOLN1pUAsF7SQFiKQEv1xP?=
 =?us-ascii?Q?7q47c1+vCSx/11885xJ2TeNDUusqzww8KQWv0lK21EY96ZYIbPn7S4vAXTws?=
 =?us-ascii?Q?cw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea05043b-18a1-4cd1-9811-08dab82b3457
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2022 14:54:52.9637
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ef//p9l/K4WQ6yjaCNpFULXyVQua9ropAtBCcD4eqPintDBKT89ZEYzXLC5lbv2YQjk4/caMTH082hgGdgkBfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7990
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA tagging protocol drivers can be changed at runtime through sysfs and
at probe time through the device tree (support for the latter was added
later).

When changing through sysfs, it is assumed that the module for the new
tagging protocol was already loaded into the kernel (in fact this is
only a concern for Ocelot/Felix switches, where we have tag_ocelot.ko
and tag_ocelot_8021q.ko; for every other switch, the default and
alternative protocols are compiled within the same .ko, so there is
nothing for the user to load).

The kernel cannot currently call request_module(), because it has no way
of constructing the modalias name of the tagging protocol driver
("dsa_tag-%d", where the number is one of DSA_TAG_PROTO_*_VALUE).
The device tree only contains the string name of the tagging protocol
("ocelot-8021q"), and the only mapping between the string and the
DSA_TAG_PROTO_OCELOT_8021Q_VALUE is present in tag_ocelot_8021q.ko.
So this is a chicken-and-egg situation and dsa_core.ko has nothing based
on which it can automatically request the insertion of the module.

As a consequence, if CONFIG_NET_DSA_TAG_OCELOT_8021Q is built as module,
the switch will forever defer probing.

The long-term solution is to make DSA call request_module() somehow,
but that probably needs some refactoring.

What we can do to keep operating with existing device tree blobs is to
cancel the attempt to change the tagging protocol with the one specified
there, and to remain operating with the default one. Depending on the
situation, the default protocol might still allow some functionality
(in the case of ocelot, it does), and it's better to have that than to
fail to probe.

Fixes: deff710703d8 ("net: dsa: Allow default tag protocol to be overridden from DT")
Link: https://lore.kernel.org/lkml/20221027113248.420216-1-michael@walle.cc/
Reported-by: Heiko Thiery <heiko.thiery@gmail.com>
Reported-by: Michael Walle <michael@walle.cc>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa2.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index af0e2c0394ac..e504a18fc125 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -1409,9 +1409,9 @@ static enum dsa_tag_protocol dsa_get_tag_protocol(struct dsa_port *dp,
 static int dsa_port_parse_cpu(struct dsa_port *dp, struct net_device *master,
 			      const char *user_protocol)
 {
+	const struct dsa_device_ops *tag_ops = NULL;
 	struct dsa_switch *ds = dp->ds;
 	struct dsa_switch_tree *dst = ds->dst;
-	const struct dsa_device_ops *tag_ops;
 	enum dsa_tag_protocol default_proto;
 
 	/* Find out which protocol the switch would prefer. */
@@ -1434,10 +1434,17 @@ static int dsa_port_parse_cpu(struct dsa_port *dp, struct net_device *master,
 		}
 
 		tag_ops = dsa_find_tagger_by_name(user_protocol);
-	} else {
-		tag_ops = dsa_tag_driver_get(default_proto);
+		if (IS_ERR(tag_ops)) {
+			dev_warn(ds->dev,
+				 "Failed to find a tagging driver for protocol %s, using default\n",
+				 user_protocol);
+			tag_ops = NULL;
+		}
 	}
 
+	if (!tag_ops)
+		tag_ops = dsa_tag_driver_get(default_proto);
+
 	if (IS_ERR(tag_ops)) {
 		if (PTR_ERR(tag_ops) == -ENOPROTOOPT)
 			return -EPROBE_DEFER;
-- 
2.34.1

