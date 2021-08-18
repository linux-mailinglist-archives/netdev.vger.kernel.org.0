Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEADE3F0332
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 14:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236505AbhHRMEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 08:04:33 -0400
Received: from mail-eopbgr00067.outbound.protection.outlook.com ([40.107.0.67]:52143
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236286AbhHRMEM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 08:04:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nrl8Lp8OzJPj7ljKhCzkQP3sXWG6iuaXZ9zlPS5ax8qSnX5AOPo98u6tLlKk+eYioDC4YgzhFqHXvey9YhHWnLWBboFMwsZM8BsNrp+vxauE04kaDuZvYBP5A/zW4IEx93a40Yj+eJ5eqOU01vOExBS1AsmtJho8b8rSCUi4FpjVplHOeoRcijOmpqJVHlkv0qTYrmQZfVqyTDmx3vKE+N6WnpTI4gusaYzp5Yk7CkNXKkZnmrFpZZGESeivI4kfnEZmbJnzhvtuHV4RxOvqnot290Z05hIRrZUdt0XPOw4f/+bSksOco3pGhH3SsyNdQAGTT+ylLGMvfl0/AqyYOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ib6lpp6wQMl+qbN+dlEZgpJNaZnPswQqpEVfJXtZ2wk=;
 b=hzhun4kS8qzouELneBS7rbj1JbaL3y+/bEhFnsSCi00JNaCMyjThYH/l5VMdZJF7Zx/L+SNjWHAcXOFXuM/IIPlyZII1MSPC3LRX1L9mSDKHqvYPwYkrprW2glZNVUp/RNgsk6ZAN/k4oh8qCPkHI/UEEFkpMEJ/IdAIu2RclO6Ww/Ca0ZBACjpfnC033/XNI4nVsnDPWjW7euPrr2ZT98kC3JqjsR+3h0Jfyox0W9HniNGE2wNan1NwJ/27BTfgCf8GQToR7rzmbRMCsWcy2vfgca68gRx3KbAaniTcrr0CrGLa8JL3cmVgp2Awq2SL8fukRei9uZf1sE5JRp74fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ib6lpp6wQMl+qbN+dlEZgpJNaZnPswQqpEVfJXtZ2wk=;
 b=BcZCI+9s0poN5qoLsPbizeGlqyeOdcRyMCJMFRRWned4TNJwKggNOs9hFpt87LsBrkDtCy/F2gwvgYJD6BD7T5dThqzZdqleDVnv1W5Ah5oaXPEi91WpVLWU3mDDSAt3sCbAB+FZScQ0R3kP6t/N+PtEIevjBB/g1XEIWYYWJ6o=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3839.eurprd04.prod.outlook.com (2603:10a6:803:21::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Wed, 18 Aug
 2021 12:03:05 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4415.024; Wed, 18 Aug 2021
 12:03:05 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: [RFC PATCH net-next 10/20] net: dsa: tag_8021q: add support for imprecise RX based on the VBID
Date:   Wed, 18 Aug 2021 15:01:40 +0300
Message-Id: <20210818120150.892647-11-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210818120150.892647-1-vladimir.oltean@nxp.com>
References: <20210818120150.892647-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0134.eurprd08.prod.outlook.com
 (2603:10a6:800:d5::12) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by VI1PR08CA0134.eurprd08.prod.outlook.com (2603:10a6:800:d5::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Wed, 18 Aug 2021 12:03:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fe4681f5-c0c5-41ae-bf1b-08d962402230
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3839:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB383978114DC9D49D94C98CBEE0FF9@VI1PR0402MB3839.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bttw9si0LNrKM5FeSBhYJmaMrKN0mIN1ZnLBmt+u3Y8xEWdHEx3Ax1DfLe4VE5rGp1FuoMU/wOvJHf1YdQjvvwxhwaU5+O//4CQ2Ex3A/59wWDH7vP8SlLx7/e3mWoygNwVlAxPEzIGjaaRDS4cyHartSQcSlsEXSnca3txUvIajT7ePswAP7pv/eVujQRCrcG9P6urqDZzjPJKdibJ11VruwaA7JwUzBhByb14TXKpQWky8et5F15bJIuWSzuBkAH70E5mh6RCSFWgP9nuHdoSEQG4ThTh/t2DBUK+jZp/1CSkd8ZNupIPjCi2MCp8q7ptOlgqtR7OC+G1hGRHbO7q5dG4nnkE+l+NgqExbLuQdyBK7B81RgrFhmUD7Bon83YaKGe+hRYcKO4SONfBTiB7oEgB/b2okE5m0Lf/r6EpndiYB50SWlXgVUybOA/VS4HHzszEGFIN3RsBWffpoqh/rZHy9mQ0OpO4eoSJVgZ1KIQg6I5J/gw4NVOdcxfyIPFJYC80WSwMD2f2VlwzB9O9II7WMnmWJD2YTo2KUog8uwf1dcFo0GwcHbvenjRxT8gZdoJItmT7+eX6F5DzAFpVuZGkLaQZ4zAR8Rh6PTtrAXFuESe8oPqwRArcIYBu5ySVzlzpqtVZO3GfSBaY+cGtl+s9iMh77QqtKrY9TEHfIsevozYheQgSIWJTUpKPN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(39850400004)(366004)(376002)(66476007)(2906002)(66556008)(8936002)(6506007)(186003)(7406005)(7416002)(52116002)(26005)(86362001)(66946007)(6486002)(44832011)(36756003)(5660300002)(1076003)(110136005)(54906003)(6512007)(8676002)(316002)(6666004)(38350700002)(38100700002)(956004)(478600001)(83380400001)(2616005)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VVcMN8zq4Pt9qdMS8/coVkRFNU6ey5Q0Eq3DtK0c67uF0T9VWt5Z3MFL/iv+?=
 =?us-ascii?Q?g3GwQKsZlk1Oc4YMeQDpE3G9bArg8OQRtSHvysJXJ4L1if6NymMlrffeHbc6?=
 =?us-ascii?Q?s6lmRFFwecsT461gZLtL1QvKbAtQ5jgUGI1CpU7+jFWoVdyV30Y7CR61cgoF?=
 =?us-ascii?Q?1aOPzxsWGTRCo77iltnm3IBK0PASZt13O0BZZOVDRLV1HbKA7U4FEI7WaKfk?=
 =?us-ascii?Q?cLFrYHIaBVzG94lsmg32LTlEXVe9MCaaBJvd5t2hDEYLsWvFa46XziGHRut3?=
 =?us-ascii?Q?+qhHTjooqDTztTL9seUxICc/ObhPYMbYvR1qdpxPe1P5yfie3xLtS+qImAWk?=
 =?us-ascii?Q?kVASmqVgPMhdvsYDhVnEGMRuM8YTITRwShMzlz/Wouk/Al1SvyvqJ+HUAg6p?=
 =?us-ascii?Q?48HMjPxWtjA0ujAx8Ypa5DQzIDJ75cHz6ScTL8XS67HRw2Y7gQ1jiSSXyDS9?=
 =?us-ascii?Q?Ab9VSnwN1PqDjVqvosRgLNUqEhA3gHl+pxC5EU4DGQy6WrVKG0gKV1l+jie+?=
 =?us-ascii?Q?BFa9DGBMYU4FPHkityNNdZcmOo01ELC/PPo3R6v1MLk3O7135hPSKJH2Llk/?=
 =?us-ascii?Q?DawJ5AwXMuSICYnk5SU414WTBidlfkMpeG4rNbJy/k/Y0Ekv7UdkzTCLxtz4?=
 =?us-ascii?Q?B7L3aIMOaS5YyWp9WTXQMP3al0627uAftm/VZ2blj32usYQpZeFm/+fVavg1?=
 =?us-ascii?Q?Py5LUFzbEXMeH6XVXy5z/I3QrUQpMBAsd5BZUObC418x9u8IeY7usFmNv2i2?=
 =?us-ascii?Q?ChRQp6PLLdPjPEjzl+D/iiFocF0AoDZojCemXJYJOnrT9RWH0GTAKN1TXp4+?=
 =?us-ascii?Q?OdSHGb9cFxsB78JyS179F4fzxkOLcLGIXR4sxmpvedRgJNEKNUeeMh+yIHtO?=
 =?us-ascii?Q?JCzFL+XYBzoaxR8NBAgjq+GzS8IMlqTllWL2G8W/8aFdDIFyqzxBC2GkMz28?=
 =?us-ascii?Q?Wagp+NJm5mNu3nAtB12cjhwnRe6vgyY0bdvbOqRPUB8DRSiY9b+Rvak8/zLj?=
 =?us-ascii?Q?+/sYYZkWQya9dvx27I8mrvMVeApojJkL6gQwA6GeZ1JJg9qlMnVG0H8huLGj?=
 =?us-ascii?Q?kjcvKJ48yvi2sCodTLIIXHzzRt5f4GaS2CwRpMQ1Av3EMD8LFFejM6bqqxDJ?=
 =?us-ascii?Q?SAoYEpaKHIzDqWAWM7yv5nq/rpF0+lm7maLuN0zWz3lY9YY+n1qMpHGjkUym?=
 =?us-ascii?Q?liFuleBC9xJ+I0QLBVdT7v3qH2g9mGDPBcC5BXBy8NWMhyqCp6tCyiQzFwpZ?=
 =?us-ascii?Q?mzjAWuH0DHNhOpmVlFEVabNQjuy+DCQL5E/OQXBvV0CcoEBz1jlQ4o+JBJZB?=
 =?us-ascii?Q?8ORZjCEYsx+vXJWCvnrvZf9z?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe4681f5-c0c5-41ae-bf1b-08d962402230
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 12:03:04.3113
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eRx0dchh9ijqkOlg8uIWqdtXtMBL+PZOcSVtDWu4KbLucDprvPnBc/P9UQswiZQKUQfwgHoMYrlKdsikAU6grw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3839
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to dsa_find_designated_bridge_port_by_vid() which performs
imprecise RX for VLAN-aware bridges, let's introduce a helper in
tag_8021q for performing imprecise RX based on the VLAN that it has
allocated for a VLAN-unaware bridge. Make the sja1105 driver use this.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/linux/dsa/8021q.h  |  6 +++++-
 net/dsa/tag_8021q.c        | 39 +++++++++++++++++++++++++++++++++++++-
 net/dsa/tag_ocelot_8021q.c |  2 +-
 net/dsa/tag_sja1105.c      | 22 ++++++++++++---------
 4 files changed, 57 insertions(+), 12 deletions(-)

diff --git a/include/linux/dsa/8021q.h b/include/linux/dsa/8021q.h
index 29b9c0e195ae..ac537d983fee 100644
--- a/include/linux/dsa/8021q.h
+++ b/include/linux/dsa/8021q.h
@@ -39,7 +39,11 @@ void dsa_tag_8021q_bridge_leave(struct dsa_switch *ds, int port,
 struct sk_buff *dsa_8021q_xmit(struct sk_buff *skb, struct net_device *netdev,
 			       u16 tpid, u16 tci);
 
-void dsa_8021q_rcv(struct sk_buff *skb, int *source_port, int *switch_id);
+void dsa_8021q_rcv(struct sk_buff *skb, int *source_port, int *switch_id,
+		   int *vbid);
+
+struct net_device *dsa_tag_8021q_find_port_by_vbid(struct net_device *master,
+						   int vbid);
 
 u16 dsa_8021q_bridge_tx_fwd_offload_vid(int bridge_num);
 
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index ae94c684961d..b47a4f7a67bb 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -532,7 +532,40 @@ struct sk_buff *dsa_8021q_xmit(struct sk_buff *skb, struct net_device *netdev,
 }
 EXPORT_SYMBOL_GPL(dsa_8021q_xmit);
 
-void dsa_8021q_rcv(struct sk_buff *skb, int *source_port, int *switch_id)
+struct net_device *dsa_tag_8021q_find_port_by_vbid(struct net_device *master,
+						   int vbid)
+{
+	struct dsa_port *cpu_dp = master->dsa_ptr;
+	struct dsa_switch_tree *dst = cpu_dp->dst;
+	struct dsa_port *dp;
+
+	if (WARN_ON(!vbid))
+		return NULL;
+
+	list_for_each_entry(dp, &dst->ports, list) {
+		if (dp->type != DSA_PORT_TYPE_USER)
+			continue;
+
+		if (!dp->bridge_dev)
+			continue;
+
+		if (dp->stp_state != BR_STATE_LEARNING &&
+		    dp->stp_state != BR_STATE_FORWARDING)
+			continue;
+
+		if (dp->cpu_dp != cpu_dp)
+			continue;
+
+		if (dp->bridge_num + 1 == vbid)
+			return dp->slave;
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(dsa_tag_8021q_find_port_by_vbid);
+
+void dsa_8021q_rcv(struct sk_buff *skb, int *source_port, int *switch_id,
+		   int *vbid)
 {
 	u16 vid, tci;
 
@@ -549,6 +582,10 @@ void dsa_8021q_rcv(struct sk_buff *skb, int *source_port, int *switch_id)
 
 	*source_port = dsa_8021q_rx_source_port(vid);
 	*switch_id = dsa_8021q_rx_switch_id(vid);
+
+	if (vbid)
+		*vbid = dsa_tag_8021q_rx_vbid(vid);
+
 	skb->priority = (tci & VLAN_PRIO_MASK) >> VLAN_PRIO_SHIFT;
 }
 EXPORT_SYMBOL_GPL(dsa_8021q_rcv);
diff --git a/net/dsa/tag_ocelot_8021q.c b/net/dsa/tag_ocelot_8021q.c
index 3038a257ba05..5bf848446106 100644
--- a/net/dsa/tag_ocelot_8021q.c
+++ b/net/dsa/tag_ocelot_8021q.c
@@ -42,7 +42,7 @@ static struct sk_buff *ocelot_rcv(struct sk_buff *skb,
 {
 	int src_port, switch_id;
 
-	dsa_8021q_rcv(skb, &src_port, &switch_id);
+	dsa_8021q_rcv(skb, &src_port, &switch_id, NULL);
 
 	skb->dev = dsa_master_find_slave(netdev, switch_id, src_port);
 	if (!skb->dev)
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index 5b80a9049e2c..088709ef877a 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -383,7 +383,7 @@ static bool sja1110_skb_has_inband_control_extension(const struct sk_buff *skb)
  * packet.
  */
 static void sja1105_vlan_rcv(struct sk_buff *skb, int *source_port,
-			     int *switch_id, u16 *vid)
+			     int *switch_id, int *vbid, u16 *vid)
 {
 	struct vlan_ethhdr *hdr = (struct vlan_ethhdr *)skb_mac_header(skb);
 	u16 vlan_tci;
@@ -393,8 +393,8 @@ static void sja1105_vlan_rcv(struct sk_buff *skb, int *source_port,
 	else
 		vlan_tci = ntohs(hdr->h_vlan_TCI);
 
-	if (vid_is_dsa_8021q_rxvlan(vlan_tci & VLAN_VID_MASK))
-		return dsa_8021q_rcv(skb, source_port, switch_id);
+	if (vid_is_dsa_8021q(vlan_tci & VLAN_VID_MASK))
+		return dsa_8021q_rcv(skb, source_port, switch_id, vbid);
 
 	/* Try our best with imprecise RX */
 	*vid = vlan_tci & VLAN_VID_MASK;
@@ -403,7 +403,7 @@ static void sja1105_vlan_rcv(struct sk_buff *skb, int *source_port,
 static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 				   struct net_device *netdev)
 {
-	int source_port = -1, switch_id = -1;
+	int source_port = -1, switch_id = -1, vbid = -1;
 	struct sja1105_meta meta = {0};
 	struct ethhdr *hdr;
 	bool is_link_local;
@@ -416,7 +416,7 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 
 	if (sja1105_skb_has_tag_8021q(skb)) {
 		/* Normal traffic path. */
-		sja1105_vlan_rcv(skb, &source_port, &switch_id, &vid);
+		sja1105_vlan_rcv(skb, &source_port, &switch_id, &vbid, &vid);
 	} else if (is_link_local) {
 		/* Management traffic path. Switch embeds the switch ID and
 		 * port ID into bytes of the destination MAC, courtesy of
@@ -435,7 +435,9 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 		return NULL;
 	}
 
-	if (source_port == -1 || switch_id == -1)
+	if (vbid >= 1)
+		skb->dev = dsa_tag_8021q_find_port_by_vbid(netdev, vbid);
+	else if (source_port == -1 || switch_id == -1)
 		skb->dev = dsa_find_designated_bridge_port_by_vid(netdev, vid);
 	else
 		skb->dev = dsa_master_find_slave(netdev, switch_id, source_port);
@@ -555,7 +557,7 @@ static struct sk_buff *sja1110_rcv_inband_control_extension(struct sk_buff *skb,
 static struct sk_buff *sja1110_rcv(struct sk_buff *skb,
 				   struct net_device *netdev)
 {
-	int source_port = -1, switch_id = -1;
+	int source_port = -1, switch_id = -1, vbid = -1;
 	bool host_only = false;
 	u16 vid = 0;
 
@@ -569,9 +571,11 @@ static struct sk_buff *sja1110_rcv(struct sk_buff *skb,
 
 	/* Packets with in-band control extensions might still have RX VLANs */
 	if (likely(sja1105_skb_has_tag_8021q(skb)))
-		sja1105_vlan_rcv(skb, &source_port, &switch_id, &vid);
+		sja1105_vlan_rcv(skb, &source_port, &switch_id, &vbid, &vid);
 
-	if (source_port == -1 || switch_id == -1)
+	if (vbid >= 1)
+		skb->dev = dsa_tag_8021q_find_port_by_vbid(netdev, vbid);
+	else if (source_port == -1 || switch_id == -1)
 		skb->dev = dsa_find_designated_bridge_port_by_vid(netdev, vid);
 	else
 		skb->dev = dsa_master_find_slave(netdev, switch_id, source_port);
-- 
2.25.1

