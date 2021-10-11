Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA2AC4298DE
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 23:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235292AbhJKV2u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 17:28:50 -0400
Received: from mail-eopbgr150054.outbound.protection.outlook.com ([40.107.15.54]:23262
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235263AbhJKV2r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Oct 2021 17:28:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eZU94Bfv5eZMr1hlNE/uOKT1H97+dirY0x3BQ9PeaTsC0Sg3X42dv+/eU+eyRC2YJSRhllsdgIq0uBj/HKm9oH8DmaiJrohYuc/afizcYVtmFr2SVpq4WdATm3XTEtRi8kJKQ5kUlTTjRaEa9EbN0/AAap3Aa+/PSqH14kbwVXO6FaC6UJxEnqLCmj7tcwdnPq4zxZXnQ2ExyLFmCjZuZmK/p/xtIhatIQnTdVY5JkNwD4H0sNyz0c++zDl6RuKpny2zRNHspvPfPhzlTBkbUHuesOjhRIU1CkLyIy2YF4/ppZKZTljGtbwjCkb91Zw2jAcSFf8NwtEH8w4Ot9SDZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pOSBPYIy5rG7bMIlEcWq9WJYVe9cFjXsPT3SQ/gAtdQ=;
 b=K9slA1yvf7kPErGiW1ICFblftKoiR0S6D28iI+uLTUJ0cDMt2Py4+SJ1CGAv0zWZFkhUISZlyDoSJZCQhqA+Et6T9hnRYls4u9IfblbGl2gk4XyRJa4P9MsOJyhBYYIT6ztmmz9VhbhCvbVG5YeovBMYG9lX9r6dTq1IKFEZAdkmkOGRB0wGHapx9NGImTVWOLqWVD4HC6ciAXIz7iXSfJZ7E+jSrTJow4n8+yUUTFnhy3yJM3u9uGF3n9QNY6Zqkn7357ponb43+0XDLrgJ2znPNeLL7KNnxwDvEZ266Fo9vHCc0eNSJrT9no7kA6UsaMjG/bp+69Nc+rnzwB+u/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pOSBPYIy5rG7bMIlEcWq9WJYVe9cFjXsPT3SQ/gAtdQ=;
 b=HccJLccrNHi7j2WUj7pp4QESpcw6TKTqUn4cIo0VU5ufst+eiw2P3SiHt7JcWvhhcLRo6gVO2WMwWC8L/3CmYxTW5eVZ6yrOmp1JViyEMcdF2u0uI6m+rJvBe/kzVI0p0U3maCG5AlIh3rZtW1vv3gwSFK3hOMXOMnBCyz1qjOc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4910.eurprd04.prod.outlook.com (2603:10a6:803:5c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.25; Mon, 11 Oct
 2021 21:26:40 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4587.026; Mon, 11 Oct 2021
 21:26:40 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Po Liu <po.liu@nxp.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Rui Sousa <rui.sousa@nxp.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net 09/10] net: dsa: tag_ocelot_8021q: fix inability to inject STP BPDUs into BLOCKING ports
Date:   Tue, 12 Oct 2021 00:26:15 +0300
Message-Id: <20211011212616.2160588-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211011212616.2160588-1-vladimir.oltean@nxp.com>
References: <20211011212616.2160588-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0260.eurprd07.prod.outlook.com
 (2603:10a6:803:b4::27) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.53.217) by VI1PR07CA0260.eurprd07.prod.outlook.com (2603:10a6:803:b4::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.4 via Frontend Transport; Mon, 11 Oct 2021 21:26:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0e4cef79-934d-4fbb-fbed-08d98cfdd05a
X-MS-TrafficTypeDiagnostic: VI1PR04MB4910:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB491024336540F113B4847802E0B59@VI1PR04MB4910.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j/ZCCMGtCU3QLvsYi/WwmNk1IScf05Kh3nZL4SgZRoBqp6OLoNmcyeB3nkfRi9CXUYE57UX7Lv7ZM6dBJeEJuGVA+MmfV+fcpdaLDMY/tp83XO5fGFsjvYjYXxUf9MiarjVko3UN5Xltnl9p2rYdLC2CWiSakQsv1FJ4Ba7W9sYqokQ8qBioTLJ0lRn4qvB9waKFe67tSgssf0WJJnnFrXWbk3VbP5FG3l5uSp4qHDfSwOrajYdjHq7sSkE8Dm2sPfK3KnTB1x6waw/7pGCeFzj8xN8zGgwnR7+YClvvWScq+cX+wt5A+oPTMx+a8EzIsebzSG3I9bKW/ZvS1IU6U39PMjQVimW2VdERq3NRam1KJl37iw0RNTcHtNsZJjz5xKnNa+F/jarleGqU79vuZNUwmXSYhEg9PlI/F6722aXM35H+hLbV3ltZ5HG1uGkZgtMBVT4Iyeo7RvrJKIIWdnZb7x40BfPaP9w2SqR4J4RllRugk7b3tR19rjC8MCKhF/1rAB1BaaZ0sx2WthTUmwOYKlGqhXya+8ZLX5abaVaSOipwPhSxypyYKAQWKV3gBld3n8mdIPBlXjWYubpL/7bMYYxVYaYEFB/s1MNmCo2iOs6bFdL/2GF/lbRwGKRJWgOhchfolIkA6++PZmnY/p+aLh/sm+xXoweop+i1lAGFsMc2j7hoJ5U5A0gDYFZlzYn5jxbxP5TeEOItoEJALw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(8676002)(66476007)(44832011)(66556008)(66946007)(54906003)(110136005)(52116002)(26005)(6486002)(5660300002)(508600001)(4326008)(6506007)(956004)(38350700002)(1076003)(6666004)(36756003)(6512007)(86362001)(38100700002)(6636002)(83380400001)(316002)(2616005)(7416002)(2906002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Wi8M1Mx6naYjFfAR6TcKMUfQWdugsicqZJcGBLUD7uN/l9tCJs3t5JCXXIJt?=
 =?us-ascii?Q?vHw++w+ayQoYiGgfKG7h+w61i3x87hJmyW/VHw3XmLgMEVuoNjAepA4d5MwP?=
 =?us-ascii?Q?E96iNHp/rqFULcyaWial4f39OwVQ/+ChXaQWjonw7mfdejksEajNMNjeADgr?=
 =?us-ascii?Q?EzNaVfI5f5UrA/Cjw1LOt+DxAXIgBuE6lh+k0rO453v9SrrR1E80PIHwPRrZ?=
 =?us-ascii?Q?4JMx1qlpWvRR7s1YvFlC3Bn7CEndNVycqH4VsltY8IimT6oFb2g+oeKYfGuN?=
 =?us-ascii?Q?6WLYeclboavLy9k5OSqSWzMAx248oZT8WRMutDVt2JjEXfNdL3WTcaYNCJt6?=
 =?us-ascii?Q?GZlbuy4PyG9S1q8q5HRdpQyTU73mKCFpnHuYeToY8Y8/h+RWC0cjVrnP63UJ?=
 =?us-ascii?Q?2nIY8GSA348ynDY3/+MEbc78g6+QPh31WT03xozGRVbTtGUIpbajAyqeDqcz?=
 =?us-ascii?Q?2sdN1PrKmbL5lHAKfwzlaFObs2d7hr8korTQmEN+9aGkDRN+OGsuU3fn1jsk?=
 =?us-ascii?Q?zeC3Qzb32jMYga61BdL08L3/O0offiVjXmLhQsWdS5tnt3AgEL5Dmj3lc6rb?=
 =?us-ascii?Q?XZBi+xElahU7M/LgwAp2SHWreavgC/tkpRiqxEB1o4hWrFfKMl/2KTrVCgAD?=
 =?us-ascii?Q?cD6mhXmcGRk+m+T878o+Ik8R0jkCPulvPJA+Mx7y30DmICuiUOKaIge+JmOt?=
 =?us-ascii?Q?UUwmYGXzoDi7OVJfuYBpTwi1N/1SAatq0KCiye/H3qS504k7CtSLouyUvcMm?=
 =?us-ascii?Q?41YN+PuO+GGs+chyjbO5D+RqVJXdVX0mkG30PfqVDswJMIv+GpGeeDagXaov?=
 =?us-ascii?Q?lIhxzAFvM5MFhc2x//LHZTMjeVyihNWGM0grCu9ewOoDASK9ELou3pLxjLgb?=
 =?us-ascii?Q?AGGB9U/j8YRLrWHakrXzm0jyAjgj3qCe1ej2j0w+df/BgUdwblyLVek1fFJF?=
 =?us-ascii?Q?Fsp65iYxZPjJ+cUiiJWoyct2YSOCXcdmSU/dVT0Ov3xZrxIqdRMZsAirIRna?=
 =?us-ascii?Q?xlnY8e/cNe3co77I9LVx1hUsWKRqX74ZDqDHFNv6jG1sgIWOGDGzBXxk6TWa?=
 =?us-ascii?Q?9RyYUQFfnICYTv8wl6rVXGVfaq9ON9/RZabxMt1F21mLrNf+9awKWRbAiZ11?=
 =?us-ascii?Q?QwG2akGHG9fj93zcIOrpJao4vb/ZPnrPDcO5jqnW0b/P+GP6p/lG5wtIrm3S?=
 =?us-ascii?Q?7pCJy2g+hkdF3KpMbBOb/lOMgMwXMF0CIBn40H4RcJH2/kcERjMPpgpU6D/e?=
 =?us-ascii?Q?FXYU09QiiXnk6jIVkIJVheRjDUJtE8Ys3mgf47vdqhoubspDwMA/j6qF/fDj?=
 =?us-ascii?Q?Oz/tLBXKEoi0BlzrZUtg+Iny?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e4cef79-934d-4fbb-fbed-08d98cfdd05a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Oct 2021 21:26:40.1513
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cYi5GelVGYudWw14EpEY993skrTTWbrMNADLMvxpd6IOc6VHBrNS8MELPQ568MNDushy2XnA8MpDrzJHB3iJiA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4910
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When setting up a bridge with stp_state 1, topology changes are not
detected and loops are not blocked. This is because the standard way of
transmitting a packet, based on VLAN IDs redirected by VCAP IS2 to the
right egress port, does not override the port STP state (in the case of
Ocelot switches, that's really the PGID_SRC masks).

To force a packet to be injected into a port that's BLOCKING, we must
send it as a control packet, which means in the case of this tagger to
send it using the manual register injection method. We already do this
for PTP frames, extend the logic to apply to any link-local MAC DA.

Fixes: 7c83a7c539ab ("net: dsa: add a second tagger for Ocelot switches based on tag_8021q")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/tag_ocelot_8021q.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/dsa/tag_ocelot_8021q.c b/net/dsa/tag_ocelot_8021q.c
index d05c352f96e5..3412051981d7 100644
--- a/net/dsa/tag_ocelot_8021q.c
+++ b/net/dsa/tag_ocelot_8021q.c
@@ -42,8 +42,9 @@ static struct sk_buff *ocelot_xmit(struct sk_buff *skb,
 	u16 tx_vid = dsa_8021q_tx_vid(dp->ds, dp->index);
 	u16 queue_mapping = skb_get_queue_mapping(skb);
 	u8 pcp = netdev_txq_to_tc(netdev, queue_mapping);
+	struct ethhdr *hdr = eth_hdr(skb);
 
-	if (ocelot_ptp_rew_op(skb))
+	if (ocelot_ptp_rew_op(skb) || is_link_local_ether_addr(hdr->h_dest))
 		return ocelot_defer_xmit(dp, skb);
 
 	return dsa_8021q_xmit(skb, netdev, ETH_P_8021Q,
-- 
2.25.1

