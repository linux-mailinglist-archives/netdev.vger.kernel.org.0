Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0123C5F2F
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 17:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235585AbhGLPZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 11:25:50 -0400
Received: from mail-eopbgr50084.outbound.protection.outlook.com ([40.107.5.84]:23552
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235550AbhGLPZb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Jul 2021 11:25:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BmobA9Uakx/LG/BsWclT58QmEx/kj8LDV2PJlE1gosr290FRUg1eqlILE+7t29TgPzPUIGv5DHzf9hB8E7OOs7v2VSU95RV8qgApODvE27zob/wc+2GXg57UdyDnHcrP8WoQNU9hdvYa7kIfSLbhQpmbwKmN9rV0zc6S1lB01Fgj/xkK0I6SkYMcxmR10kmMC3rUgZ5J5CfxCdd/nzgkHma6+WenvlAAKYHdrbunwxbh1lDfopQB1cjantGAy7vhjxT8zTg6+7cYu+DyIYBs/scvmEJdG1jrvBUJZUb58Y8rbenIcCFzCOt/h+2QA1VPW3LaTJ3tS376arj1KRQnMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PhRJZfuWSZ6soOzr0n7BBsWXwa+g+/chbcyOA+nDW4s=;
 b=Eu35toHCgLGdIDTSul1NnySSVfSRFyXSgFP+Lavm7G2upX7s0dJquX9xgWEZ+zzCoEDKwP1os8IiPkNsjEi0N00d/TTOtQi9+Y2FxDDu+GG25KrPcULyb+8qifjEF43pltLfdI5MKCZSgMSYjshSc34J3jCsTMKwKJEzK999Nu3YX0oGtWAGmBkfeoqVZX9HsnSuYgIsHtQQAx9TlszntHmT3vsbHW/DGfUe3FyL2zlTE+fl7Nz8WdI36mxulvaTFlsiUYNFF+zam0jfAi8AHvpekt1AflXaD/kzbEZmB9x7B1nB7sh9CdxgNdg2gCAVHrBXPeFwbwz++RJ9SyeRBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PhRJZfuWSZ6soOzr0n7BBsWXwa+g+/chbcyOA+nDW4s=;
 b=Vx4KCH/+UXcrZWokHMxlRqTfsIvcyGLIw69eEZcUzDvaFQkwKb8mroXWLFbbejhN8eUL/IWkCbPS5+mAapqK0cGaN4F0xtrgARXfoOKVBef4bjAwVM/nSJF2H3feGDN/GE9Me186gGFenfq8gKAvuOFJIlS4j1JjBW/E3q7qEM4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2798.eurprd04.prod.outlook.com (2603:10a6:800:ae::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Mon, 12 Jul
 2021 15:22:41 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::b1a0:d654:a578:53ab%7]) with mapi id 15.20.4308.026; Mon, 12 Jul 2021
 15:22:40 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [RFC PATCH v3 net-next 24/24] net: dsa: tag_dsa: offload the bridge forwarding process
Date:   Mon, 12 Jul 2021 18:21:42 +0300
Message-Id: <20210712152142.800651-25-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210712152142.800651-1-vladimir.oltean@nxp.com>
References: <20210712152142.800651-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0101CA0058.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::26) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM4PR0101CA0058.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20 via Frontend Transport; Mon, 12 Jul 2021 15:22:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 55b34e6a-5bb0-4fe2-273a-08d94548e397
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2798:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2798E3DDC64FB95A0621611AE0159@VI1PR0402MB2798.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MzEkkI+MXb8sWZfPez9F1rPoYmuP/+C3xQKeO3iG+xdhO4I0zMTzD9lYWzWa54oOsV4hUHijobJpH92h50a7DcoVmffqALL5bRhCHxLA5nXq8gs26DcHBA37iIWYZvGnAx4lAsWk7R0B1d9I0E0JlAP5bDrFNKjpkfHgSu3gOXr3mr/535pObAq5r5wdGpVjBTEBjXEFqLQVu9oi7iP31Oum3qyGxoFQWTdgniGlPgaUW/+GA/Bv8yE7Bn0UcFvvJIAA9dvc3LLq/cUSKSqmevAnr5+V+TucpiWJLEI3tXGPLize56wg3E4HsSqjPAfLDi/qdMUBOG+tuDHiHPJ3wrCAoDNcDZ0mnwy/ldE4rpjFly4umzXvWn/Gq8Rz+SRIYIjtA6zyzy+9spGSvr77bjUXSd9Y0+zAfD7vLqyY6bdZ694OwkeaPCd+N0sME6/IGPGkVsSFU/0RaPasCLhKEeP2gEPDnEhWBfgf7XKEORzHV0NhW2ATrCgIn3muihSoyl6/5Cs9gkVl6MO3Kkp34UPmldegrXUx8NegKLUWjCAsv55tigjBCbBP6GYx4wiv3YXrFt0nH9egrBkzeOAVoDqGzL/oGLf241EIpMMqNYOb3eQc39jnvBUSZMVbYTn6K4EIA+1UWgbrd6PHS59Ij55knkWhoP2SN4sC6ueTZ7lilBmimXFhR1ytlZWYP5mSFLZh8EYOUXq+dGRvRnf0Lw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(396003)(136003)(366004)(83380400001)(66946007)(4326008)(110136005)(2906002)(52116002)(6506007)(54906003)(38350700002)(956004)(2616005)(186003)(8936002)(44832011)(316002)(1076003)(38100700002)(6666004)(478600001)(5660300002)(36756003)(6512007)(26005)(66476007)(6486002)(7416002)(8676002)(86362001)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ftcUt3gq4ciC+etsyVWzZb9PZd4cfI0ZlvtMSvyWZx8IkdYrw+0zM6fETY4W?=
 =?us-ascii?Q?xf8tFNR48Xf1UkRYdZdgIvmrCvLcJPvm3Fg1HPLOAeceIS5BaHpTzLFKwSga?=
 =?us-ascii?Q?ljmnnLZfgorssMu3jLVp7YKaH0afsbbgRBbiqD63pEAeu+5m69ddhxuJOXhK?=
 =?us-ascii?Q?5sv7sM/GBK2QHmL+jfRVgnE1nfXvttv2R+oGzMMhxDIDrjrjRKDseryYd86m?=
 =?us-ascii?Q?m4K4K0nT7xan3V6AOLf7SV/ZNUenz5VyOytYaElA7Bn5Q0TEvbMreDtZS8Ad?=
 =?us-ascii?Q?xj+EuOoIHH5GUNWDz3HESCqxVHho3dBGMlvAeUceHyJttM2LkKi4n378QUmy?=
 =?us-ascii?Q?/64rFUcBEOIWNQQNBmFj/OCTd2IsEfHn3VP0jRj1uKTef4UEoxXevQx8IOL+?=
 =?us-ascii?Q?uH9nTQCpfUEUr7jZ4QTgzbXF8OXGfVcOg01CODmjLPDGset9rCVHAD63eRMr?=
 =?us-ascii?Q?rEmEVsQ5kbwyIgWiqCcAQT/RHM2JnvgR7JCvL+efYH1Yhwzjpx39xvZI9laZ?=
 =?us-ascii?Q?PSyrejKUPoVud6TPeMLcUrteHUC6LPMqa81hLfuvif8LK1TNrtAoUb29Wzrg?=
 =?us-ascii?Q?LfttEyl/aTjqaHmuir46vvmSdo1ujTEDxspLhTvss1o6CnFlhEERYWd6uxMp?=
 =?us-ascii?Q?GDWCN9cRY+OmoKrquowTA0q1G5c+BU4OH6lfwwUxJzdMHrOK/jqEcNyzfzBK?=
 =?us-ascii?Q?jLM3UyzlwX8JyoIt4zbGQC27NxFSyyB/hetmhE4FUKNoqwhRLF2LWBoSl/vt?=
 =?us-ascii?Q?j7irFxpJepzMdaGDrvrMyintdHKOHHvMqJP1yXJl/fabEIinW0dUdX0a8Ejb?=
 =?us-ascii?Q?iuhKGjUaFTEyOu0bmiQzvcmp4pFxPIspCeYvzWcArZB2WFUR+VLkrMMZxg4C?=
 =?us-ascii?Q?/mLhFw34A3bZHo4sjMgNPy1eg5MjBIAjYO6JSNhx4Zwax0v1klAcWK6yMSY9?=
 =?us-ascii?Q?uByK/T7ct3o2VSU8BkfEHJTasUzITP8vjepQk56RDvC/By0CVcMmnM7VFiXh?=
 =?us-ascii?Q?CZw6wRIHf4L8dnHo2eTBSr5V8jiEIr3q6CFK6A6BpaTilQHWl1RC3zEgM8jb?=
 =?us-ascii?Q?wh5nHnJqUp2PxD11rsOWvjTGxPR8peN4Nkvj6YFA5+q7VpDIouvpE+OsUF5d?=
 =?us-ascii?Q?sqCyeHp4hQlDO2/yzBKoteW689/EXeCkLTgy58K3PeliB9FkrAOQ7xIDm66Z?=
 =?us-ascii?Q?JVUFwm/rakPuXlYjW0aVQ0Ec6LZdD0EJVKqvkp/uj5u8y1V26XL2h6vTXq5b?=
 =?us-ascii?Q?DE56GHFoQ6MBfhQSBM7j0Zx0B43PUl+Qd0IOcYyYeVTwA5zrUi4nhz3B0g9Y?=
 =?us-ascii?Q?UFuRK3Udl61+DmiK0y2OMlqo?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 55b34e6a-5bb0-4fe2-273a-08d94548e397
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2021 15:22:40.9630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bdjvc9XgQ39Wn7S2wahLQ46QUvDMQb5e7xkTzLS4K4UANRNrQOPohStw+H0V5jEJSIzIcd6tsiCKCRBJQym+Wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2798
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tobias Waldekranz <tobias@waldekranz.com>

Allow the DSA tagger to generate FORWARD frames for offloaded skbs
sent from a bridge that we offload, allowing the switch to handle any
frame replication that may be required. This also means that source
address learning takes place on packets sent from the CPU, meaning
that return traffic no longer needs to be flooded as unknown unicast.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/tag_dsa.c | 52 +++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 44 insertions(+), 8 deletions(-)

diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
index a822355afc90..0f258218c8cf 100644
--- a/net/dsa/tag_dsa.c
+++ b/net/dsa/tag_dsa.c
@@ -126,7 +126,42 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
 				   u8 extra)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
+	u8 tag_dev, tag_port;
+	enum dsa_cmd cmd;
 	u8 *dsa_header;
+	u16 pvid = 0;
+	int err;
+
+	if (skb->offload_fwd_mark) {
+		struct dsa_switch_tree *dst = dp->ds->dst;
+		struct net_device *br = dp->bridge_dev;
+
+		cmd = DSA_CMD_FORWARD;
+
+		/* When offloading forwarding for a bridge, inject FORWARD
+		 * packets on behalf of a virtual switch device with an index
+		 * past the physical switches.
+		 */
+		tag_dev = dst->last_switch + 1 + dp->bridge_num;
+		tag_port = 0;
+
+		/* If we are offloading forwarding for a VLAN-unaware bridge,
+		 * inject packets to hardware using the bridge's pvid, since
+		 * that's where the packets ingressed from.
+		 */
+		if (!br_vlan_enabled(br)) {
+			/* Safe because __dev_queue_xmit() runs under
+			 * rcu_read_lock_bh()
+			 */
+			err = br_vlan_get_pvid_rcu(br, &pvid);
+			if (err)
+				return NULL;
+		}
+	} else {
+		cmd = DSA_CMD_FROM_CPU;
+		tag_dev = dp->ds->index;
+		tag_port = dp->index;
+	}
 
 	if (skb->protocol == htons(ETH_P_8021Q)) {
 		if (extra) {
@@ -134,10 +169,10 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
 			memmove(skb->data, skb->data + extra, 2 * ETH_ALEN);
 		}
 
-		/* Construct tagged FROM_CPU DSA tag from 802.1Q tag. */
+		/* Construct tagged DSA tag from 802.1Q tag. */
 		dsa_header = skb->data + 2 * ETH_ALEN + extra;
-		dsa_header[0] = (DSA_CMD_FROM_CPU << 6) | 0x20 | dp->ds->index;
-		dsa_header[1] = dp->index << 3;
+		dsa_header[0] = (cmd << 6) | 0x20 | tag_dev;
+		dsa_header[1] = tag_port << 3;
 
 		/* Move CFI field from byte 2 to byte 1. */
 		if (dsa_header[2] & 0x10) {
@@ -148,12 +183,13 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
 		skb_push(skb, DSA_HLEN + extra);
 		memmove(skb->data, skb->data + DSA_HLEN + extra, 2 * ETH_ALEN);
 
-		/* Construct untagged FROM_CPU DSA tag. */
+		/* Construct untagged DSA tag. */
 		dsa_header = skb->data + 2 * ETH_ALEN + extra;
-		dsa_header[0] = (DSA_CMD_FROM_CPU << 6) | dp->ds->index;
-		dsa_header[1] = dp->index << 3;
-		dsa_header[2] = 0x00;
-		dsa_header[3] = 0x00;
+
+		dsa_header[0] = (cmd << 6) | tag_dev;
+		dsa_header[1] = tag_port << 3;
+		dsa_header[2] = pvid >> 8;
+		dsa_header[3] = pvid & 0xff;
 	}
 
 	return skb;
-- 
2.25.1

