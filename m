Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F509666033
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 17:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235345AbjAKQSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 11:18:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235628AbjAKQRu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 11:17:50 -0500
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2080.outbound.protection.outlook.com [40.107.247.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F0EE625C;
        Wed, 11 Jan 2023 08:17:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iDNUtrPo8HqftJnBAMjw1nUVszMM7cSL3pdoGJZj4STCRO7G4pH1XgTO9iUelcjThvlSjX7uuMyhzdcTbQd8gvigNo3ClvJp23PqQLa9yvzYemqTeGL3QxGGzthsRzwE9+DJ/tmgCoLgnERU+OLviGXOtCVwIwdlJcitzk4BGTGapc+88mJYvEP9JUTIKWA4pDUCISnUywWg7B+PrIkRUS1dm9fvX6izJGwp0N3JOeg8Pi7gc4JY1tnlxHTut738Ph7X3PWjBkZzvNyoGj5S3QPNlsVDOJUfMCxzQZzMTk2ULlN4k3kBtZgmC9CxAMdPEAeepYTgfyd9zkxMPs1VzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uz0/yH9xibMBYfJaN/oInbHGTP30pDPWCaVjYJrlXTo=;
 b=oATudsCJ7V5B5wH/7nQJCHVkhnILUPvuwrk1AO9VG0yieAFrewN2Mll5XvJ1Izi1uR4bXZ+I9n2mzxWFKBb/CXbIDEC8hQiUljBa8t4YH06X1TH4Ft6iR1G9jJfX2623UuIqVN4pgifPSK5SSRuePL6+d0Yx/boHi9SD3mZ5tx5RLno4kVaGQB9qbi5dh7gRy//Nai4Pv9PDIQlW0iL1ukmL1vncpzMCl1fPGNteJKrA7s/C6j5lGMtI7KJy1+ZIxt9jMgXbvRYPXNSRYMrcM4ckxeGxHpFK4fwhmEDiYheE7Msaiem6ZB8Je3BgKEzl5rx+N7yKhIMlCbuz9LVCrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uz0/yH9xibMBYfJaN/oInbHGTP30pDPWCaVjYJrlXTo=;
 b=SZQ7+3vblT2zObmPeozoVJPNI/sqzITvYgcwcfHisGNx1LrYv3sitMskXQsPDGDqfsDnTtqBJFx+JlGrEpySx5OKmYBIvVL2fFK4w9Fa8Q6YwJNEC1v8jAS4VcisNx6oZD0Lx/IZKOun72NUPJELO+WNBZAT7DXw6Pei5JlH0Yw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB9PR04MB8462.eurprd04.prod.outlook.com (2603:10a6:10:2cd::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Wed, 11 Jan
 2023 16:17:27 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.5986.018; Wed, 11 Jan 2023
 16:17:27 +0000
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
Subject: [PATCH v2 net-next 07/12] net: ethtool: add helpers for MM addFragSize translation
Date:   Wed, 11 Jan 2023 18:17:01 +0200
Message-Id: <20230111161706.1465242-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230111161706.1465242-1-vladimir.oltean@nxp.com>
References: <20230111161706.1465242-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0163.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:67::8) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DB9PR04MB8462:EE_
X-MS-Office365-Filtering-Correlation-Id: 378872e5-d9b0-4872-cc4f-08daf3ef5492
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VQ14mn+KI/VvGa4oYVWG2LyaZtDTE3wNg+zU+uXkKazem/bMhhYWAOrTQgvWtk1HMnXyJSklfa2saMiUmARgUXoT5TJ6cGhPsp9ziX9qNaJ3BvBDyO+HDoCLKQjPrYM4S0qKu/vjzoLLXrC4WrsE2rr4LezKDnxuJyhv0cKfa2ealdN46cFtVd3qW/30KMynXgzvYvVStvWakjtCesiSqVst2nn5pxvXuucjML0Z64JR7bq++Ripx8X+rGHI9h22C3d1Ml5Uf8vQSj+my2LiASxX5xBanEXR86nAFGm19VbTCIFRST7w6UTD3m6Pn1t8zGdTW/Mi5YCtSOPS3Wh1COIvtFhopRcB5uBZ7+cRNWSiw76ehSmm7ZT/NtndDTwRjJBuAQ2VrZKPMCzxfMFk3x7ztgYLWFYhl4t4KnNFtQ/eN7AIYRJeV3bvuqL1htyY3Se673jbUDh6Pkpzq5gUX+QnT0vwdfPfiQZffOt3tY8Ndsz995y3s/iSQv066Z6Ykig5Az0xf+EQ43UwKUifMKDd83n7z6g3u0dfoyoIB1lSROKszb5I6V3Qn0/zEqab1JJRVS0bxj9Q4ttvjpc/SxRPAO/reDZLWfs0LssMg3l+5zzx0gGfead+lM0bUgBFjN7KLjNehomYnAM2d71DyKh5qi0fuSNU+RE7B8kgRw+TfaBNXR3B6BbxX6D6jdtV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(39860400002)(376002)(346002)(366004)(451199015)(36756003)(26005)(186003)(8936002)(6666004)(6512007)(6486002)(6506007)(1076003)(2616005)(66946007)(5660300002)(66476007)(66556008)(52116002)(7416002)(6916009)(316002)(4326008)(86362001)(41300700001)(38100700002)(38350700002)(478600001)(54906003)(8676002)(83380400001)(44832011)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SDeHSY7Gb4qd4vQmyjSG3O3BfZjAe8ik3qq7iPT6+7hscdTnkmqpSFs/8yrY?=
 =?us-ascii?Q?06/jjKskfrQGiJvyGcGc+m0hm+zVxZBvZBcLPCEF7lb4iGn1KivZbBk2Ekeu?=
 =?us-ascii?Q?LJrYf/INo5NUq3vNDdj777fmQYaoL8PaMSxJNkWjN07PvTTa5IVlI1a7XvuM?=
 =?us-ascii?Q?CwHr8aHbjWD9gpq4P6a+VjwznaclgYfEunvo+vtnBENNdxUoV/EGTM0zZshf?=
 =?us-ascii?Q?b/RXJ0Nck+HI2T0i5T7JnG//yV3gdS4VY2Y0GUpMqLMw6MuA1TGh63QYNOaz?=
 =?us-ascii?Q?i2wpAzs4j5q6GlSuG4vGvV2VCIW6rPbomhgMySgFdGA6m5wGsRcpN1ODNGg5?=
 =?us-ascii?Q?Fke5etSRf2Ihubci4wPfuCv6bxav9EeELrpWydeVRiyVXy559KBVpH2Lax/p?=
 =?us-ascii?Q?Ig0KJ2VO5HOXbngoBbPcjt9eJlCx9yAi0ia8SRWp+w14vujbA81b3zdFNdDO?=
 =?us-ascii?Q?i7Bxg65Y+oR6uyymgVRMDZD4yhyNZdHYzQZGHM66CVV5jrxyzjFjzBt6Z+Sx?=
 =?us-ascii?Q?D1xt6hvpAoySZg9/J5KWs0EQZdnhn+jzK7o2IMY5WgJPrjrcpOYwS0mDMczI?=
 =?us-ascii?Q?FRTmUeIvM5nHrlkL1nxm+zMtGmUvkkQJv4JRCad0kJh5xmFDQkeDG9c7Hmau?=
 =?us-ascii?Q?+os2gqzUhb9OU/UTKePmtBybBirYfQqg+KU5uSR9a5yEI3WT+Sphcf2GIMG9?=
 =?us-ascii?Q?c8E3eEpCW7fIjzi7k0+ZsQTxCDIsZG8A2AhNoyg5H2tjRFQAe9VIaaSPvBJQ?=
 =?us-ascii?Q?g38LLHmXDJHPLqZg4SPvChrflP3rsUOInnAFe7JAENguOqk0bjDMQYc+uJjK?=
 =?us-ascii?Q?XTlqiYGvOc3BPcvDTtx2LsdiAr5lGucvpVfcG7KStumvUPSsNicSKFp5sKda?=
 =?us-ascii?Q?Ca+RbVAK01WhUY3JQV6DQhzuL6OGBzCxsnRhKpEkqQzKQ7Kz9VFOgvzw4fiP?=
 =?us-ascii?Q?mrf97tUEO5jmcVOHGeikK3RfUL2T7IMx1q3iWJP9z+AV6XuQ8T44Fd2yyhOT?=
 =?us-ascii?Q?mntWoBl5S3L2XNYNnl5evXrBpAVD/uLWv/dyJGgbR4CfmtssttF7sdeRE7Hz?=
 =?us-ascii?Q?pfQjs1HEekvML78zYNT15NdOWzJJtMjXHwFbAbMKY/nwkE0GEhXR8ly0iaq1?=
 =?us-ascii?Q?3ipayjBGU9MfiD3yePj2f+4T0OpN6r4RAXD5YcHs/xaVJ68YWcDjyQclCwJS?=
 =?us-ascii?Q?fNpgtDN8P4rVdZfULMf1cb52B/dr0YmCUTSlRbZC7VW3mWo2nh5Z9eb3btpb?=
 =?us-ascii?Q?BQb+d7uJrT7gQC39PtNNql/fsCa6D4H77dLms3ZvBOlsTpb0lZh5Uhv30K5h?=
 =?us-ascii?Q?ahG08egjmBzahZg8QVgAhDALGguQ0TtrPX5abXYHjU/gEPL2BXXYJovXojDd?=
 =?us-ascii?Q?emdPAGN4IdAC0SCPmRa2QYyh0OwrqmFEl7ICkUVl4x30jk48d0PI6jfUdCeA?=
 =?us-ascii?Q?VjXy8mcCQpzdNgkmT/NpzWcWkzcnXgr0zWQ3juVtAYbjwKODtBxxoBmjHzlb?=
 =?us-ascii?Q?fqyHHa2eggGKc62yYx+U2xTxh2myOvnPdzVCN/dqMh3jqRa/lxW6T1MoNJCm?=
 =?us-ascii?Q?dE+n5uQ74B6zBRj205hLS/x1bimXrfd039/zsi93BHOFrTiTsAQNy6Lvl8ru?=
 =?us-ascii?Q?1Q=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 378872e5-d9b0-4872-cc4f-08daf3ef5492
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2023 16:17:27.0173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p4UEgL0Z2UsSEg4mDtG7UZRhXAB6ipSAStSKEuflEo7ShP3/OF559UgFsOfV8iNhBd1AtRYarliC18MFuchWHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8462
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We deliberately make the Linux UAPI pass the additional fragment size in
octets, even though IEEE 802.3 defines it as discrete values, and
addFragSize is just the multiplier. This is because there is nothing
impossible in operating with an in-between value for the fragment size
of non-final preempted fragments, and there may even appear hardware
which supports the in-between sizes.

For the hardware which just understands addFragSize as being a
multiplier, create two helpers which translate back and forth the values
passed in octets.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: patch is new

 include/linux/ethtool.h | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 01b1e34dc30e..1c3e8fc53609 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -979,6 +979,45 @@ void ethtool_aggregate_pause_stats(struct net_device *dev,
 void ethtool_aggregate_rmon_stats(struct net_device *dev,
 				  struct ethtool_rmon_stats *rmon_stats);
 
+/**
+ * ethtool_mm_add_frag_size_std_to_oct - Translate standard add_frag_size into
+ *	value in octets
+ * @val_std: Value of addFragSize variable in octets
+ */
+static inline u32 ethtool_mm_add_frag_size_std_to_oct(u32 val_std)
+{
+	return 64 * (1 + val_std) - 4;
+}
+
+/**
+ * ethtool_mm_add_frag_size_oct_to_std - Translate add_frag_size into
+ *	standard value
+ * @val_oct: Value of addFragSize variable in octets
+ * @val_std: Pointer where the standard addFragSize value is to be returned
+ * @extack: Netlink extended ack
+ *
+ * Translate a value in octets to one of 0, 1, 2, 3 according to the reverse
+ * application of the 802.3 formula 64 * (1 + addFragSize) - 4. To be called
+ * by drivers which do not support programming addFragSize to a continuous
+ * range. Returns error on other fragment length values.
+ */
+static inline int ethtool_mm_add_frag_size_oct_to_std(u32 val_oct, u32 *val_std,
+						      struct netlink_ext_ack *extack)
+{
+	u32 add_frag_size;
+
+	for (add_frag_size = 0; add_frag_size < 4; add_frag_size++) {
+		if (ethtool_mm_add_frag_size_std_to_oct(add_frag_size) == val_oct) {
+			*val_std = add_frag_size;
+			return 0;
+		}
+	}
+
+	NL_SET_ERR_MSG_MOD(extack,
+			   "addFragSize required to be one of 60, 124, 188 or 252");
+	return -EINVAL;
+}
+
 /**
  * ethtool_sprintf - Write formatted string to ethtool string data
  * @data: Pointer to start of string to update
-- 
2.34.1

