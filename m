Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA7D66D92C
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 10:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236082AbjAQJD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 04:03:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236103AbjAQJBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 04:01:40 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2042.outbound.protection.outlook.com [40.107.8.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B83430295;
        Tue, 17 Jan 2023 01:00:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bGwxojH5TuyyKAmQkcF9U1V+QHOk3Na5/iWgsQjWCnTl5ASak3hmZd39Eib9yMsBk66uB03joazcEewNRjZFgFDRc0AfBw2CrxvotItSqI4/VJFYbWup4x1CZrLiHSEtWN8tuia97ioiM1nUzaE6okdSaSRR4XV4iEhm0EgsNQeWaQu/p4NgO96fiWiNmxk8/u30d6MHvb5eP+s5oBz0MpLIDd1j+oE5u1w6qkOh1XrKIeBEIfqRY05NNsibR5qb4P/V1t1yg+QBH07GKcsNu75oCGPDowrFS6Tk7D7r2PC/aO0OulVbQFnMo/A0yiuq4JXdVbsb04d7pAAxzw8KOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VrhFs7Gp7ZYt6fsRqG6usv/p25wO3m2Pu8TOq6E/dzA=;
 b=aIsizc8FalCYTGuOLeTCEaBwb4J7iLCFhY2ShUWwy2/jeBQEF9sqr5rUh1Il+8NrgcybppwYVPX3gkkzEacKAChyolcZL5N7A0iBOTn22ky5T4bT/Q515tEgsy03LLdeCkPW19Uf3lKBFDEB3QFkgby5AKSkkIFzFbvxyq2sytUdWa11qcU0wC1LAMRAQfdR7RWodmk91RFwCStNNK/C6Fw8SpIu6I4g4mdG7Bsgs4rlYbmkifnRP4IGlUYq1SqUu0rrfhyBmDytn23RLMFqh4su/BJvQRlNPdhvUblRZ7DGLEH7ch7T0mud+lBrXey1L5AyOgGRtwfEiblP06Cmmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VrhFs7Gp7ZYt6fsRqG6usv/p25wO3m2Pu8TOq6E/dzA=;
 b=rY/EcaknI3r43rzK6WgEKpNXrbCsbtGwWWfmmlgqFfxyiOt8LJMv3Z0d9r05tZw2m6BvKoXh93ZNYHSzcI9s1LVG/QycLQji9aXDwg23O7ih+bVPoxIvvOEa5MmSsWm4RSrP/SUBukGclitJ5nYhn8zkEsOIwpLa2nz76H4cTpE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by GV1PR04MB9182.eurprd04.prod.outlook.com (2603:10a6:150:26::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.19; Tue, 17 Jan
 2023 09:00:10 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%4]) with mapi id 15.20.5986.023; Tue, 17 Jan 2023
 09:00:10 +0000
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
Subject: [PATCH v3 net-next 07/12] net: ethtool: add helpers for MM fragment size translation
Date:   Tue, 17 Jan 2023 10:59:42 +0200
Message-Id: <20230117085947.2176464-8-vladimir.oltean@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 92a9bd1b-75de-4496-7723-08daf8693c7f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a4oJ08CNO9oueJQYhR8pxj0sqpqwOkNuTQsNXSaeVymzCw+V3Fzq0EjeIg60C/vRuDZRXwZTaONlIiU9zYsC5kwNlIY/W8IyicpUgyRS9w+cFY3isN1IiEnSJMP6z+/3aFfQFQi9twL7S88/2/xWLAWiF0eoz4XkZsKw4IZDjnlQxG75tCDxFm74nIDHRsu6HvaR+v+yoVZCt8DHofyYqyhUOxEogfkkbX0pbxNX3qK+YjvIfH1iMKHsIX9u7ml0hYOc98/wTdCa93ySvmWMzI46bh30vhm6iCqqD62sNCUlaAZkZecajEnWW9CPpzaMswDQZ2bMrVh+raNrwTIjCxCB7J/HLdGkivKWzVRY9Qqs07noPW2wm6MHRfFcTuYj3N08834Gbl/pTHyPzDodgym/sAuk9niVuS94YCehJtxrQCxqxweUmj0w0ZCfKjkhWj4fj4WCG5N38CpWFcM7Ms3/d9ZyfhpWkXV5WqP8QEngfD2Vh3yp3QqAeLiU8l1pvtIzZiJ2bIelvhsWUvG0N8EeX2MPOehqKcI/60VVhC2wvpIljMqqEisN+E2oDdThUdXb1JmqAnsiEglSbN2iTFon1YQRevE5N1WXyHeOWB87UGc3Y4KNicSRY1m1Fkv712AazShELELvfoz0OgH741+RMtmzAEFGuAIljeimiqRcf0ys8QB8/keEQFlNPQdx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(39860400002)(396003)(366004)(346002)(451199015)(52116002)(26005)(6512007)(186003)(478600001)(6486002)(66556008)(66476007)(316002)(1076003)(6666004)(54906003)(66946007)(2616005)(8676002)(6506007)(6916009)(4326008)(38350700002)(8936002)(38100700002)(5660300002)(7416002)(41300700001)(83380400001)(44832011)(86362001)(36756003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kmHeIaBGKNbXLdxa0DyqgRw66p2pEPCT8Dqzxq/twc9H9fb/yCnttvzhey6Y?=
 =?us-ascii?Q?9gvDcddr7ejjbQO1rhxazqLzoooh0GvHIzAUtacfV1E/6s+SqvMMhjcD8ps3?=
 =?us-ascii?Q?DvEBxm7Q+yuMhF1flSMlmczzi7m6r8K3hCLtUpGKe/CSEeRsy2m4vosTueue?=
 =?us-ascii?Q?4XOxXqw5fSCl8BfajFVfv/vwBmRW1rTFag8yA4C0k8LKmk7n7qNr/134WDA1?=
 =?us-ascii?Q?1cHc2xpthSiWKP2nKbmk2US4mPPHOlvxgI5KkiC/Vi5qzCArbBkN2j/sqDI2?=
 =?us-ascii?Q?8KXZWTt62lChwTGnIvxthiY8E7IXdXjMhSxvgPM7AEPu/UqkhJ9w+gwiXnp6?=
 =?us-ascii?Q?fWr/iDtFbwZj/xCv2+Okd0kfzLhsihdtEavhDh4CslW0eMf9Yy1JfJRknFCD?=
 =?us-ascii?Q?N1H7zq+sv8da90xuKmjuW3KAggaxnLeyPffLELGPXIJ60yDWNIDOCr12EJ6K?=
 =?us-ascii?Q?pst10kBWYD6dsj0d4paptKGlAm+E/A6sp++7IneFlGccttPSc5unfwyqdOQ2?=
 =?us-ascii?Q?yZrQ6hyzOuOhvJF0wIalZJkl3U5tQfjHqvKMk7/xdLoT72hcZKXO7xVxxTFf?=
 =?us-ascii?Q?tRoSqKiPUi6C9TmDPzkhQe8KqCldYMlRcCKneh9K3H7tZyPPTAfvw68dddFS?=
 =?us-ascii?Q?TJ1XyOrFq9DnnkBqGS83LABWM4nfCYR0uBBQpncxqcVxhNcYag86pUZgQzQT?=
 =?us-ascii?Q?7ocKmS9EM6zjflrf7opdt1jnthhzz6FdXwNMAhfCZTN1ZH9gFw+guhZuMpGn?=
 =?us-ascii?Q?fhRXIQ2mPygCOXZ2TiALqj4PCNiotRe8Ykl82BVdtEJGHGhJ/DAAaEx2ttBk?=
 =?us-ascii?Q?GBXCbfGCkHVFMUbsT1bB6zrTmFLtk9lTbCPoMdfsTgUESOiAOVXRV7DqGQWh?=
 =?us-ascii?Q?nGMB3c+al5Ox7RXCCNghdi1dsqa+JMeXD8+qJtRprKyjzY0RISJSKWt5gaSn?=
 =?us-ascii?Q?ur8nn6jxj1O66hEVE6uXyw8zZJRzXNzTfrMPEYKN8NLehyqzVr4sbg/To5ZG?=
 =?us-ascii?Q?nwX6KJOAXV8nYzk58rWHyRq4xP/qz/UTMPYnO/i68TlfAqV759zN40suf4Nv?=
 =?us-ascii?Q?6HiTwUvZbUMOILK7DTEHtSTIIy7LlUKog9ehLiWiUklRQz43g/Y2mojHw6ra?=
 =?us-ascii?Q?vbVME3vyqTnSqpQvhzqK5vIQa6UOIi4C71aK3ASN5A2meVD5B5F3p/3HxjqS?=
 =?us-ascii?Q?A4q6VJ01M3QeUAUjYY60upLAXpZKg4s9wkb7W5jwaswc3sIWNuH7F6aS6SHC?=
 =?us-ascii?Q?mAgTiUqT4SCe9tJHEL/bm4daykKXt7qLGkkL3qarvfvV+s8KMShJg9qODDyJ?=
 =?us-ascii?Q?6vHRQJqpC5t8gMatftgIaHNuQ1YZxqm5DsJZmuYw7IjaDW6sfr/I5YNc3YXI?=
 =?us-ascii?Q?go+PRmFyS6nH36f+JV4/HohyjTwp30ZKzsKZ+Vyy44jmWh+JBjPK6susv5Xd?=
 =?us-ascii?Q?lkK/KrAIjyqxh3NSkSf41pHiDq2mOEesiPPHHoH3sSvDpda/SOSHWoltvr1W?=
 =?us-ascii?Q?DxbsIBn4cbgO53l/qnb5ONbo2J1Ea2zoPzuuOQKq+iwciqwrI2DUpLZuynLx?=
 =?us-ascii?Q?PXJiWVz44y6cvVKm8tosZSpD4RlK5zkU7mqv8hc9RvhtfFAq/lpVdv/DlA6B?=
 =?us-ascii?Q?aw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92a9bd1b-75de-4496-7723-08daf8693c7f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jan 2023 09:00:10.0024
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QOkdGmaEax8tlRA0ESxoCckCKbTKSgWog5BxJEGz0zYWu3N7BK0C0iLO3CnC3G/9FQ0ObD/8Jvwt6MJjLKXKWg==
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

