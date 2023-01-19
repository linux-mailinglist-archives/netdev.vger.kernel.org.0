Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BFE2673874
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 13:29:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbjASM3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 07:29:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbjASM17 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 07:27:59 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2079.outbound.protection.outlook.com [40.107.14.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD474ED21;
        Thu, 19 Jan 2023 04:27:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZEO5N33B3c+qDFk4RXQgbpqgr7cKlYqUyHtYoO3LzztgmUe2hPnz10kpFjPrI41Zv7sdjgjVqjJSSfD+HeDAK/EXRGS5VnRXuk8wjwnKKYbiWDUOaIj2xwOWcldaXhB4V8Vmov/eO7IFPUceXnf70AyGeYUdpi4tI92+MDYOnBHC9OEHfOASvVjywLpHra1qtFt86YVDmjkRKIs1qCmFBkXb2gyRyzvJUNUUP8dKe/Pl6v4qRBaJTpSCvUtKsp+eIfSn5WVAlHhwze3ivtb6NP3e7GCKj58ZDD7zfZCKctVtImt4arCGt/wXU9c5wkqZcGxNletKwEz9qrYTCzi+Bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z4W21MZjorFHix/oWTag/+RlbbnVBD8mhmhpca8aKQw=;
 b=b9XSca6NrMHrNShJjeGBaj7YMAw1vWoU2V218LGtskfVmBf/xS88lwuALNE3w1a/Q4q1xDLCJh6JeTICT/ItWRFWIH18PY1C6I6lz3Kr8YgWuJ45YNWsyqijkQBh6QpEErugqGQc7pxWvJd9hTz1VgUWRtqgpvqtxDkkMW2T92JE0Xo2GqruxhEIkk3kBzpByW+oBHUz6PfgsCRo6j6TjKKJdyptLTD2ZlXx4fAkpkEHhlGi8lP9mTM5x9ooKo7MA/f6FT3T73WczVC1RgXjWKnRDEg0SAVminZ70x9NkyJFUvvweZgxEBDNKIDrqrW1noRp/FJVpUoUcJlRf7KlQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z4W21MZjorFHix/oWTag/+RlbbnVBD8mhmhpca8aKQw=;
 b=BUHmRYNt6J+R1468P3fSf3n5zbzMn1pPDZsia1tX6zLKWzT/+xyFep2l+p6nsPc6VbhjYFLYVS9bh+DcQynM7gr0Dr9yvoZvIYprOTwXfK258NhbV4wjbk+nalgbMNnT2j3NVuo43rOiQ7fM2+0C01DLs9FmmyE3DWOyOZRQCKQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB9376.eurprd04.prod.outlook.com (2603:10a6:102:2b2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Thu, 19 Jan
 2023 12:27:53 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.6002.024; Thu, 19 Jan 2023
 12:27:53 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH v4 net-next 07/12] net: ethtool: add helpers for MM fragment size translation
Date:   Thu, 19 Jan 2023 14:26:59 +0200
Message-Id: <20230119122705.73054-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230119122705.73054-1-vladimir.oltean@nxp.com>
References: <20230119122705.73054-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM8P189CA0020.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:218::25) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB9376:EE_
X-MS-Office365-Filtering-Correlation-Id: 20c8a780-0550-4991-54ae-08dafa189644
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rQrqQJNM+X27EfyJjqFQ0BMr1ngGRyxUXcmOtmGyaldMB0YQanrMadHjfbk7gWaI7jUdsCN1IYI9bTplchhd4ixURwsgWmcLIBXHTjISALeAtN9KDHsFrBm6kDOAscwSnbC9PJuthMcGU4+U9sjSuh3sO+FhIQYcN1+eIZoTEZUJ+U99QFkOLelHWqyqDagFktM+yQn5c/BQjdc+7ZBgZkkZ6w4kocd5KszmQGwQvfnQvcFwztxrPOZURf2TIVxteLTxv7eUxta9MMFa72uECyuUZP/uNT9HduxpeLqpPa+p2l9VpExjYZ+O4sF3lRAVpJDk+z2oASEy5YNIYlPgh83mTMyBEsYvOpN3QFuSmltU1cd9ZmKkz+ug3dA1udg83taUGcHE2Vr7S6d5q3TjWQJSSLiXbOozbu6fcqD4Sh++wKYymHjgmXx3TaTF0lwJ+wUjSCcjoLJG19jNyzkM7tGsqzL6mxG+NYNcR3xizsL8XaAltnZJT8Z+vfH0vdqvKnHpJJOW28CkiqfcRmFvizmrSye3VxvxKDbyN1rmnwI1sVPTiglcF0zpzT8cIjgcIuteb2dh0VIbjvGCbHMQt2uWEPLP6Hs4+TgMXFxaPSHGdZKhnEjp6iciRzEsCko1nabeBVcJK7QpHFk7SCXvX+U9AGyCGZUQzLXLrxp13OwGCwRAGT/HzAfk0CaRjwdO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(136003)(346002)(366004)(451199015)(6506007)(66946007)(66476007)(44832011)(66556008)(7416002)(8936002)(5660300002)(2906002)(38350700002)(38100700002)(316002)(54906003)(52116002)(86362001)(36756003)(4326008)(6486002)(478600001)(6916009)(41300700001)(8676002)(26005)(1076003)(6512007)(186003)(83380400001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UrKRnffKYWbqdXyJZTSKzS2dNE5tZzkasIOdNr0Il3X/cmuGSOxVXt/rc1J0?=
 =?us-ascii?Q?Orzx/+bs71vSzSN4gvM+9eEGtZ5boc/Ojgl+LEoy1U48DArDFUdk9fMnjY71?=
 =?us-ascii?Q?MQy7bHq7wHuZbNDQ3oIqCVM0YRCC0DlkF4FfHYx/ubHYRn2JvcKg/LjNPDO/?=
 =?us-ascii?Q?7lyobvglkqIcfYAMp9S1u1ELDCcIYvZ7xC7+wCkcrWZxLp2jY98LEh41/bt+?=
 =?us-ascii?Q?ziRqsfoE8qMeEwg9FW0x0Lo7c8ZXRq8gUVhBwPN4i3W3g7uRCSRxuCNOq1mE?=
 =?us-ascii?Q?BmuJY4VOWyNq1cf+EctIn+ukuxr7FwymkfZ0Hg9Qj/hnkHrRBnYzjDgl3W7u?=
 =?us-ascii?Q?7tjC7zEk62srGffPvMBR2H/w2Ewc9AkI1CdfZZ7vVMZEZsoNtbjjXEaX7BSx?=
 =?us-ascii?Q?cUxJI8H8gJCdfcugGbMidHCsGS/6w2v/B4ALtYT4s21GIrw4jRsoQ8jrohwq?=
 =?us-ascii?Q?3w2jJDg+/vrTM6yvjalCdSUieX4rd2p9TZQ/fRE2/bCW7TWmtK2S1rHQvbld?=
 =?us-ascii?Q?PgtgCqfdkfaRJZe5adz57crleMXbqUGmyYa7W4diuNBKqFQOTxKwvHl89hOj?=
 =?us-ascii?Q?2dQ2ziesHEjy24//QI/wmP6cNjX5XMJx1Fl2jUUDex3KlZhgiUV+d3VuvgLR?=
 =?us-ascii?Q?JGWggmw9zASqA2gHVhtGDZSTzuii7t86ezkkuDdlG6dSNkLAlVOJVBm0Yey7?=
 =?us-ascii?Q?f0ZsycuS7ihi7bTxwt1asSbhMdTScR2yOiECbiIQjmwCCOSHXNQM2G2nQfLx?=
 =?us-ascii?Q?0BdGiI0uRHfyAizMlGvs4o+b+suRof31zacygPoanf8G+PgiVDSxQ66XiGBG?=
 =?us-ascii?Q?apbrqu1CigbiySYsRNjJdYCY/aqmQD/ggM3PEgSNgBCZXA0PxNIGWkpBOzQZ?=
 =?us-ascii?Q?EDvbXudVPvmx6+Tf00pff+RnjX+7OaUsG5vrGE5RBv/ZZOGuufakUS0iTHsp?=
 =?us-ascii?Q?cq0d38WvJheha6TQjOVezf93j1p3qji4k+NYUwGge09LQDZrEMaNubfGjmVK?=
 =?us-ascii?Q?ewzqeR/k89EZ5lwAHGtLtP0iLVOZqhjmI3ygit+Yw6cLdbfQzA8YyJvyGdXD?=
 =?us-ascii?Q?Dazic8BcxzC09P1x5wFzOXBAWjxCI9JeiBCuhbg5yRPOA2nR9zUXHqPtr4NO?=
 =?us-ascii?Q?t0ajodiLucLX6gUvpVHzqNKySKf/p9IcdF1D3uvwhbepNwf222cwdHGv/gTI?=
 =?us-ascii?Q?m5ELCfS2lERr5TFNRO0hvWGMiM0lyyOdX6r/Ds9bz6S9ruoKv868NE7ikfF1?=
 =?us-ascii?Q?ERUOyEI4Z8HQj1ob4sZmjBCaIc4fimAaQNGfpI30rXEllmOJN0qAl0ZLOBUB?=
 =?us-ascii?Q?0faNXMwEf/ZrMiBHEuKRZRu5gqJ7EG+eQww2aakxIBLaAd7RKASYPOAX3QOC?=
 =?us-ascii?Q?eBIDge69dE4ejY1+EmpENsQYv/477RbLXdXac3Jvj03T/JVgRITNoSU65ZKk?=
 =?us-ascii?Q?h6Sm/lLTRh7XlxI+DNTx80/OfMbd4kfkyWu2jay8YpPzdmBbcgvevZykYMDA?=
 =?us-ascii?Q?Yib0237h1ICRZedOHmIWSRbuZYd7h1sNe03khhSJSIEdNmQ23eLxsr2d1NYQ?=
 =?us-ascii?Q?iC3eK01koZrMSZK/nTtT9Wv5HVbxIOPssFA3c0gvRmKOZaSE2ycv3cvoicaQ?=
 =?us-ascii?Q?FA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20c8a780-0550-4991-54ae-08dafa189644
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 12:27:53.6847
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OMM/F9L3+LsZ8FJz7OeNLwDkT0HqNcGIZ10NsRf+VWbP66vCc7eA1id4vVhQUBbdZL3ID0d0Z3R9X/poVSeSbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9376
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We deliberately make the Linux UAPI pass the minimum fragment size in
octets, even though IEEE 802.3 defines it as discrete values, and
addFragSize is just the multiplier. This is because there is nothing
impossible in operating with an in-between value for the fragment size
of non-final preempted fragments, and there may even appear hardware
which supports the in-between sizes.

For the hardware which just understands the addFragSize multiplier,
create two helpers which translate back and forth the values passed in
octets.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v3->v4: none
v2->v3:
- adapt to renaming of "add_frag_size" to "min_frag_size"
- use some macros instead of 4 and 64
v1->v2: patch is new

 include/linux/ethtool.h | 42 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 6746dee5a3fd..6a8253d3fea8 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -15,6 +15,7 @@
 
 #include <linux/bitmap.h>
 #include <linux/compat.h>
+#include <linux/if_ether.h>
 #include <linux/netlink.h>
 #include <uapi/linux/ethtool.h>
 
@@ -1001,6 +1002,47 @@ void ethtool_aggregate_pause_stats(struct net_device *dev,
 void ethtool_aggregate_rmon_stats(struct net_device *dev,
 				  struct ethtool_rmon_stats *rmon_stats);
 
+/**
+ * ethtool_mm_frag_size_add_to_min - Translate (standard) additional fragment
+ *	size expressed as multiplier into (absolute) minimum fragment size
+ *	value expressed in octets
+ * @val_add: Value of addFragSize multiplier
+ */
+static inline u32 ethtool_mm_frag_size_add_to_min(u32 val_add)
+{
+	return (ETH_ZLEN + ETH_FCS_LEN) * (1 + val_add) - ETH_FCS_LEN;
+}
+
+/**
+ * ethtool_mm_frag_size_min_to_add - Translate (absolute) minimum fragment size
+ *	expressed in octets into (standard) additional fragment size expressed
+ *	as multiplier
+ * @val_min: Value of addFragSize variable in octets
+ * @val_add: Pointer where the standard addFragSize value is to be returned
+ * @extack: Netlink extended ack
+ *
+ * Translate a value in octets to one of 0, 1, 2, 3 according to the reverse
+ * application of the 802.3 formula 64 * (1 + addFragSize) - 4. To be called
+ * by drivers which do not support programming the minimum fragment size to a
+ * continuous range. Returns error on other fragment length values.
+ */
+static inline int ethtool_mm_frag_size_min_to_add(u32 val_min, u32 *val_add,
+						  struct netlink_ext_ack *extack)
+{
+	u32 add_frag_size;
+
+	for (add_frag_size = 0; add_frag_size < 4; add_frag_size++) {
+		if (ethtool_mm_frag_size_add_to_min(add_frag_size) == val_min) {
+			*val_add = add_frag_size;
+			return 0;
+		}
+	}
+
+	NL_SET_ERR_MSG_MOD(extack,
+			   "minFragSize required to be one of 60, 124, 188 or 252");
+	return -EINVAL;
+}
+
 /**
  * ethtool_sprintf - Write formatted string to ethtool string data
  * @data: Pointer to start of string to update
-- 
2.34.1

