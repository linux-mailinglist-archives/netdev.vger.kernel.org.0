Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8B5066D928
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 10:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235916AbjAQJDr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 04:03:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235975AbjAQJB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 04:01:29 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2042.outbound.protection.outlook.com [40.107.8.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 115592313C;
        Tue, 17 Jan 2023 01:00:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NbwC/ayUUdCssRl76NQpoDpBXF8/HyisfRdeu36c7tUayuWJU5fKt2aNfScPTWpuwYm/NBHoftIeNtKUiUi8+gbiH6wp7PdlUas1/C3S9ewIMU7yAIi8INH+37QWdJZxwQZzya7W3CI/D2T7eAWPSaCxMPCmd8g1fRBBSi7JwRICs3h4KBWdFfdBNp5Yws4NsJd1ToCcnPMFWhgwKfchdJekd/L6gHgHxxtDtyaAUBdqv2oYmD3WRscb8fxow6Wws3wKollRVKUiT3ylSYS8+meBxU11UluVlIckIU155d9Ppai6i5YQORxWt7N8/59AmyxtCX5ECduTSldCiNGqDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=upH1joA+5/L2/D4IJOUrmNnEzTo9jfQgvYrtCG15Ros=;
 b=K5roGUJU3JzT4HEoi3b23nPMtkffuk8Tk3KjhgRxXc7WcGAEoFbs5nkP6kNMWo+YhHTzMLmHrfLOtma5t1ik1MlSoK3qwHFHmN/NEb+XukRSKMlN20JkTEx8aNuueHQUCnpVVYUGeDygkKDbAzj355ZwPOEH8pDdTjF5ywzZDRnHq0fDrhMRZHXetchzgHXxK9qlvI6EHvEymd8rsiKd+H3/VNbCYrKG9mkuoLwFEt3Uz7ZVQF3qBiqKgGeoYefSTUZUiNTv5icDWrCTQwaV+OnnZp4D55F7LJNoQ8ipxZZefWn23YoDkEybYB1cbFl4BjAn+ysX8CbvUDwBdR+FmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=upH1joA+5/L2/D4IJOUrmNnEzTo9jfQgvYrtCG15Ros=;
 b=F62EnQ5VVnrp41Xkx9PFgK1y7nVCXji1VmTEUo3KGFjQd4yyiRzFxBrJfxfZpeR5CweQVO+38xlLJLadrM75E3bEe4oJTb1ocF12V/dX2PDeDlXNQrhEMIm6IvQfj/jPmShLqo0mLdPil903r8U2LPj6CN1bdVvfil8dU83NNvE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by GV1PR04MB9182.eurprd04.prod.outlook.com (2603:10a6:150:26::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.19; Tue, 17 Jan
 2023 09:00:07 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.5986.023; Tue, 17 Jan 2023
 09:00:07 +0000
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
Subject: [PATCH v3 net-next 05/12] docs: ethtool: document ETHTOOL_A_STATS_SRC and ETHTOOL_A_PAUSE_STATS_SRC
Date:   Tue, 17 Jan 2023 10:59:40 +0200
Message-Id: <20230117085947.2176464-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230117085947.2176464-1-vladimir.oltean@nxp.com>
References: <20230117085947.2176464-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0115.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7b::9) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|GV1PR04MB9182:EE_
X-MS-Office365-Filtering-Correlation-Id: 95b3f9f8-df05-4a4a-598a-08daf8693ab3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I5jLonPxaj17ecRTSPW2GX0rEmre2NjgwBq7p0rkpykJL14IXsNkhGxoBXGdU66Ajyt7TmcIaxPBuZZIADDS6ye9+qkSKU1hqTRGJwZYsCiKso9mIwK89A5IQ2VR1UK+HBUKOxYW5VThvfJD+pJIakCbuH2p1rLg+Wkd5AlEzgcAW96GXGHXrdHxtSyhJnKOfeourVEvK+m8D8/yqZ0efEGEsyYamXmfAEJWyI2BGH+o2+iGx7lRRjfbBpQ+myLzsAJJJwVaJ2k3gxuWQwe88ME1o5F5JE+brpzQ5o3BSqFrWJL3tLIFki+ONxBrUJBeoiRMkmkdnFtRsbrWwylDqPLEfpW+8iscFnLvm1ZpV+2mUpjEwZbPpr2H+K3ctf3VtXrw4ZnwS1lcW/8ik8Sro8zt7bFrveQ3nBB8juV9yn3kw06mxrxtYgFG2ubIEJs9w2ziEn2nR+Cmy08I5ApMDQQllNXlP02ji98bIFwQgKyV1aoBzcGv60Xmz6UjsIJomMmpoi5dsADUG8V2OU2AwqRf8VMP0oU5ulVZkJJJKPWq8m/MQ5TlB0jZqQ16XlfNGrR8OXbIRLYuCniRjY1Eid5LM/hjyALvGQhp6WXSMhPrJ8s/29HTZN8j9rxieVlqXp1J/6Ns3SOJN4cO8WPfmgIs7IAvp6bpMjsVQ52wb9l+JvQgoy2H4Id8xgtgTvEL/EGjNUEDg8N135ejiZyMZA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(39860400002)(396003)(366004)(346002)(451199015)(52116002)(26005)(6512007)(186003)(478600001)(6486002)(66556008)(66476007)(316002)(19627235002)(1076003)(6666004)(54906003)(66946007)(2616005)(8676002)(6506007)(6916009)(4326008)(38350700002)(8936002)(38100700002)(5660300002)(7416002)(41300700001)(83380400001)(44832011)(86362001)(36756003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FF/ot5cTjQV5DwBfxP8Tl0hQWZh6jh9A5VEx+aMy98biQ9I1uF4AfylzA+Kx?=
 =?us-ascii?Q?M3AfhMhMa1rTrWShQqvTrc6YJYxn5u8zNoqlBhn6qC6EvDExM1N+ts3Oxx0M?=
 =?us-ascii?Q?aloGVUjn2lG60xYTvZ36dlxfvhLEOwtqc2GwZ3YUC6VMmh9C6gsv78uGLmoL?=
 =?us-ascii?Q?QUbZf5FajcJlFLTwPxvIPAJ12EmL2bhH66D4YPGLgVaBeIRfmllK9CxChPS5?=
 =?us-ascii?Q?4eYGjsga9zIA1dNh+iSASwtJXXuBOrKu8nptk+so18xQtOuEi6NstfcMuG1a?=
 =?us-ascii?Q?5BFP9wUmV+ngNR3UXQtkR/DSLTFG1gwu/5i9tJzpFW3nJuaxV6AyzG+841vU?=
 =?us-ascii?Q?CHGTDDAicFIECUxx/IvFT1OrhexMaYVy3K6PtC+g3MGKp3c1n+doNzWpHfVO?=
 =?us-ascii?Q?uf+46sqwyXJBayYGnvrVZkculSz3nJHXYCPo9nP8oSnOQzBaFhGjLwj0jPcU?=
 =?us-ascii?Q?A+s1xG92sSNjq3v+ZtlhBRaQF9jrMS0iuAgrkzL4+0dcAKKHNBgm9CPPl3lx?=
 =?us-ascii?Q?jFtMpV7ucCEMk1gjt59J9ZKbdp1tsBP+2dGYUUe5g5aeo5Yw0uM9aax3pW0X?=
 =?us-ascii?Q?DSM8cW+ozp0N169a2EvA27KXFpgpL61T4QgnwKYxsf54qlQO0fJWTmOyycs6?=
 =?us-ascii?Q?R58L7Pmafj/EA47SD2PWgJy7JLw8r7zEprEpElEhszsU3hw68k/9GZvF1yJL?=
 =?us-ascii?Q?SiieoeJX3XB+r/9jMGZ7ALv2pxNXK32ybau3rV3WDxzqKmGfOvO+YGOP6/he?=
 =?us-ascii?Q?KFGhadL5WTBPeBMc0xNtc/VrFwlnkhy9nbM/UjjF/ULHcY/Pp7+SJMLbb+gW?=
 =?us-ascii?Q?KlBOhAB5zKWMYrkrLhhTvj2oXlbG06nHy3DxMMOL5iLE+coCUinB9atVb/10?=
 =?us-ascii?Q?QAwvi0COkw4sk9T//RKCTkXsIXNJ/X8CJJCQ5sulHu1SOYVmSPDMtQz9CLnU?=
 =?us-ascii?Q?efKkMJoyZCE4Rv2X0/mM4Ut49VQNhodgzsqOZIJiwhq+v6aL0EeAQv7fHT9V?=
 =?us-ascii?Q?5m9d7rFbdY1fdtXzTPVvdj3wyGOzd6E9vGJPl2096za99eH9vjdxWlPsCHfG?=
 =?us-ascii?Q?KBLYSJLa/uCHMmoDXf6llMrPjphCfebx+DWhbTsDfqyoB5YOwhm4X+5QRPdy?=
 =?us-ascii?Q?FxM3+2fVMJAe9NbyCi7Czz5olwn7AyyjI3qf5CFB8BKwPi5l/etLh3f7kCuu?=
 =?us-ascii?Q?Uzijoa4hF9caExdyyNrXFjzs1tg90ts8SWSfx6F+pd3pXbHSOWXCMuPLe65m?=
 =?us-ascii?Q?UH4wdjZMOBSq7C1Lj/hPLz9DHuomTpxokovNgx5wQuKuqHJnnexPsWw0pRTW?=
 =?us-ascii?Q?oXCugvxAc/cBn7IWAdpj1WAAjkdhZqdPOzZxTSgKWY4a8ZY2OUvBLuhXhZpD?=
 =?us-ascii?Q?BQA+Np2YVsSYRt9n1lY5XWBXCrTQi/azU7IyHga7k3Q8A4oj7ijszOXSLEPu?=
 =?us-ascii?Q?grXFcC8xSW5SyFKHg537IwkTsEABh6w0+9ej+X+ejAsYvp7eqzfTfICyE+jo?=
 =?us-ascii?Q?kH30glJNRAvOR45LOM+lixu8gWwpt+4y8iyZsX/UNT7qmgUnydyxn4c1K/mw?=
 =?us-ascii?Q?0uhy+ytJQXklmWVeSTpOE4w/GmyUVq3igVkQOm8y1/2E6L8/63ijxWbYQ0ER?=
 =?us-ascii?Q?kQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95b3f9f8-df05-4a4a-598a-08daf8693ab3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 09:00:06.8777
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2FS9NKXTenZIX4WxNL+WGI80oBSl9C4KMWiWk3U5ZTY2GWELfTHdbdbslY7MbZStIrVxB6aGkpVpQ6dl7XAhwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR04MB9182
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two new netlink attributes were added to PAUSE_GET and STATS_GET and
their replies. Document them.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3:
- adapt to renaming of constants
- add a single kernel-doc reference to enum ethtool_mac_stats_src
  (second one gives warning apparently)
v1->v2: patch is new

 Documentation/networking/ethtool-netlink.rst | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index 31413535dce5..1626e863eec9 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -1092,8 +1092,18 @@ Request contents:
 
   =====================================  ======  ==========================
   ``ETHTOOL_A_PAUSE_HEADER``             nested  request header
+  ``ETHTOOL_A_PAUSE_STATS_SRC``          u32     source of statistics
   =====================================  ======  ==========================
 
+``ETHTOOL_A_PAUSE_STATS_SRC`` is optional. It takes values from:
+
+.. kernel-doc:: include/uapi/linux/ethtool.h
+    :identifiers: ethtool_mac_stats_src
+
+If absent from the request, stats will be provided with
+an ``ETHTOOL_A_PAUSE_STATS_SRC`` attribute in the response equal to
+``ETHTOOL_MAC_STATS_SRC_AGGREGATE``.
+
 Kernel response contents:
 
   =====================================  ======  ==========================
@@ -1508,6 +1518,7 @@ Request contents:
 
   =======================================  ======  ==========================
   ``ETHTOOL_A_STATS_HEADER``               nested  request header
+  ``ETHTOOL_A_STATS_SRC``                  u32     source of statistics
   ``ETHTOOL_A_STATS_GROUPS``               bitset  requested groups of stats
   =======================================  ======  ==========================
 
@@ -1516,6 +1527,8 @@ Kernel response contents:
  +-----------------------------------+--------+--------------------------------+
  | ``ETHTOOL_A_STATS_HEADER``        | nested | reply header                   |
  +-----------------------------------+--------+--------------------------------+
+ | ``ETHTOOL_A_STATS_SRC``           | u32    | source of statistics           |
+ +-----------------------------------+--------+--------------------------------+
  | ``ETHTOOL_A_STATS_GRP``           | nested | one or more group of stats     |
  +-+---------------------------------+--------+--------------------------------+
  | | ``ETHTOOL_A_STATS_GRP_ID``      | u32    | group ID - ``ETHTOOL_STATS_*`` |
@@ -1577,6 +1590,11 @@ Low and high bounds are inclusive, for example:
  etherStatsPkts512to1023Octets 512  1023
  ============================= ==== ====
 
+``ETHTOOL_A_STATS_SRC`` is optional. Similar to ``PAUSE_GET``, it takes values
+from ``enum ethtool_mac_stats_src``. If absent from the request, stats will be
+provided with an ``ETHTOOL_A_STATS_SRC`` attribute in the response equal to
+``ETHTOOL_MAC_STATS_SRC_AGGREGATE``.
+
 PHC_VCLOCKS_GET
 ===============
 
-- 
2.34.1

