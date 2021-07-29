Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC733DA6ED
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 16:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbhG2O4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 10:56:31 -0400
Received: from mail-eopbgr70054.outbound.protection.outlook.com ([40.107.7.54]:28666
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229934AbhG2O43 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Jul 2021 10:56:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hZtk+yXWpx3JPaCdTk058ssnzNoasucQNFuOB9gIh/voncAE7KtdLuCt6YOeBS8rGBFC4nXuAFpHcgfRithM4LD7knQ4aMVS/M1mPm5nuVFialzqle36GbN7kK419KqLtJOvPHXqaMuCkcja/DC831YMebPAHQ+CACN4JCwiLqICuKPYz2nTCJr+j8GjmRMGRKbX+SJKUoK3havQlPeS3+ffIdBCiQK1Whu86sBfNGisx8SdsSgx69Gm6u+Fx9PmYYWph6v6qyhwPEEG2hLjCOSVtN32bzEVWSUOFtrIQiDpx/i9jonDUrrUTUiCFiFs5O+wV6vxiLjSQcBBrNx/Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l8eoQYCmFkfTNsYwAOqHD0/GKlXYt8LZTLIMYBF+sls=;
 b=OHRY9Z9zijbbkBQzFoWld6FIAagxbvY8D4e2P5pL9seY5ctOVmS91dONDrwkOByoI0HJwqO0hta7V65MPCbtI6qbfScTon5sgLJ7i0O+i6PoVYUDgT0csJUm1OMP0pvliyD6cFwhoGFvUv1D0BBWjRh5WtCkrodaS1qoOUMd2TkSiu6Bk969JfvIbI0nI7HnglVC0syhN2BV2SeoatI3uGZWbZMtVQjSsDo2jFGRcHy2LefDM56Mtd97CRdWY4WIKLXsSKcZ4SJSDsIdDOPMQaGu5A/Vfwx4j81DnBCyCnwRD9NAcYO+WhT6W1NtTDbS6vcE82hqX5ZUu7I8Zrv/Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l8eoQYCmFkfTNsYwAOqHD0/GKlXYt8LZTLIMYBF+sls=;
 b=IYMUjShcHOYjCfjGeLhminBWPIs2FY2Kb4HDj9MmpNV5e5IioMiEf08bFSJZh1o/cPTujPmsNgnYSUoDCMhv1uAnHiYye4Uom+lYF/aWkvtLJrj/HOl5Jt4p5td6KJYpABTbBKfgyiJaFqO7W+XsNVdYg1Cv1WmOmCrpFUu7VgY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4224.eurprd04.prod.outlook.com (2603:10a6:803:49::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.19; Thu, 29 Jul
 2021 14:56:23 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4373.021; Thu, 29 Jul 2021
 14:56:23 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: [PATCH net-next] net: dsa: don't set skb->offload_fwd_mark when not offloading the bridge
Date:   Thu, 29 Jul 2021 17:56:00 +0300
Message-Id: <20210729145600.392712-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR07CA0002.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.76.66.29) by AM0PR07CA0002.eurprd07.prod.outlook.com (2603:10a6:208:ac::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.9 via Frontend Transport; Thu, 29 Jul 2021 14:56:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d8f3e5d7-b1b3-4c6e-bd35-08d952a10867
X-MS-TrafficTypeDiagnostic: VI1PR04MB4224:
X-Microsoft-Antispam-PRVS: <VI1PR04MB4224091550535557B79B36BDE0EB9@VI1PR04MB4224.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GeWnDAae8FIBqGGjt1uUwGGvt3fU+JoD3n7/7c823V28cGHmXrSAlRwKAbulsPQgAgGe1KXvhshSYYNbjTdksrxTOmPJsjZMbh9DasIkx4VBx72Ekx6KTeAjN93w97p5U5JxoVR56fCC0L1bX/fQRTESvRTImtel2yJszaO76VqqaIpPd0ZbCf/s8Ni1pTgGP0BH/yP+KD127+V2uTceIbr8FoKfUsZZd1ZFqTpUZUzQJEN/Mux5oVhoBOzTPLUd3OXdN3h8wUhdGd4p08oHpbYDBYRmPWFiJjtOltkYosCuxQJxuey0It8UQS8k2PTsarlgZuSFIsq+aA/eDz3SdsAWFuK8DdyKxXuGOmc0zZdH4Fo01TXHIAgCKtwosSTC9Y+ZOSi8gWT5sJsqV9ymvFIufbf851KFrFM0bzvGtIGqRTUbSyhjA2jDU1HR3wmDjDjAQ3Or8mn80Q9p0c51OFWNE8BEgy3uTLxUEg09mIIvzhYEdyVOzvHeGdSBRYSqUJRipY8+riPpyTv/NfeqNbFGLW2WzPC+WxznZIkXN+Asj6YAGSGX9MrZYgJ5jlu+1IhBOke8Igu3h0OeahwXKolmHQfiagMIWTS0Cq73SfvzaKTa4VwCh+qDdAn+bqvhQpbkElp2OSthIJERi+be4jwHwCIRmBBhsS+91h0AK/vcdPOkjRgBaV1GKbRpgW0Yn5tfO3OrYO3HzPqYuTLcAA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39850400004)(366004)(346002)(396003)(136003)(316002)(6512007)(5660300002)(86362001)(110136005)(26005)(54906003)(66946007)(36756003)(66476007)(83380400001)(66556008)(186003)(2906002)(6666004)(956004)(478600001)(38100700002)(2616005)(52116002)(38350700002)(1076003)(6486002)(44832011)(4326008)(6506007)(8936002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?g3ryD5gclTG+AGprgjENBlDsGB2i+YRfzi2H6Q7Ja0aakILqA/JcJOq9bhvQ?=
 =?us-ascii?Q?iHEhSyAQq8+HQVstzhtLzkkJvWH/+y3oKWFrMbYHQNdqnaO+W3l1OkpiGF9T?=
 =?us-ascii?Q?IpW3EgLB3zgEybiht+zoQ91ZZ1RlwxlYUzOzbguNq+7xQDhz/mjjy+N5WeO3?=
 =?us-ascii?Q?eLtICys+YG03h3opsLrPqPfPRk3fUp90nyW2uK4I5Nyup9cQYl+xgKAFHMQd?=
 =?us-ascii?Q?6jutPCqSVnwdiWshuO9ZZJUVIigTrgqVSIY5w8xNwtEtaDeLp5OXlc+21G62?=
 =?us-ascii?Q?Bt/eSFRdMXROd7wXvzpBfgKH7UDZA7sQ4/aIjv/b04oUcCHlrtDA0CcuAMIc?=
 =?us-ascii?Q?hoYKnJA5NuMi8cSuJeGIo7NEya0xQLiCnJLhtymSV81fK1uOkhVwbXTg6sWo?=
 =?us-ascii?Q?xU4+1P84i5kJjic5WfCFComplZkfjB4BMVY92o6C22nuth5omx5ll9ZmJKFe?=
 =?us-ascii?Q?c/40s0DrQscMjTvp1g9o6k2huQgRgsth19n7sZSZ8C1+fkEKFsLVrMoCxngp?=
 =?us-ascii?Q?Pf71F5Duyxf1QVXBMNbjxAfJPmpBsgv0g1nw5n+EGYyteIVuHHCwex5FZxRA?=
 =?us-ascii?Q?KxMO/bCSPNTuB7lFG3M6vrkhpFp/XnuUW7e4900rO+MqRrwxiESe2yTLlBc/?=
 =?us-ascii?Q?17Q87N4SF08Wjgq1xNuBuO1787aY5k85hBsYwVU6heqTYsduqafS49TgkeAW?=
 =?us-ascii?Q?e7C0JM/PjKSgsaf0HAhUtDOGfOMpMvZ+KygYpie8gbRgtD0LviL+18Z3MOWV?=
 =?us-ascii?Q?cbH1Rg/moLkdlU9f5DzzWgetrSGRCTmNyZ4q5Y2mbFPFh8685XM4E+pcW9a2?=
 =?us-ascii?Q?cCNY9COwjc+29j5bkTm0GhiXUBxQS3czMAGLb1FYl3qW4QdVfC6dt4Es307d?=
 =?us-ascii?Q?pLzOHr/IeMCLz/jqw8p0l2Dcb5M2Wt8lf4+pdEfJbZ3RIG2kYV0ULhU6DONO?=
 =?us-ascii?Q?37KIy9SJEmEmKbx1XLGzETzAvFUxWTOMBP5hpysIrUgwbgtaBU6LgI0wy19L?=
 =?us-ascii?Q?Uhubt8av7R9PCB8KaPOgUtmVDfLvLLjbW/nXOE8W+VNpLBAeqDqMHtsR/1B/?=
 =?us-ascii?Q?fSTuFAgy+gRKGAfWRofqrNBtLvCOJaZZxOkiPSQ4cX6alFuaEJW0RS7nJ3dR?=
 =?us-ascii?Q?NfKPHbbxCLd8maYElCSFJmbXkOdGqRnP4DlA9XLbDb8MBIGMz1hYgObtaCvO?=
 =?us-ascii?Q?s0nBX2FeG8u/rivYjSO0YUcKV625RkIRKcz6EuSynEycv2ZqU2UEifa/5x1E?=
 =?us-ascii?Q?U07mMLEA1JWLB8uDHdq3cf4aEoIDwP38IP755rpybrmcJO0M6wNQ4K/5iLXD?=
 =?us-ascii?Q?qCjRSGyidvmzSdk8XLes7hnA?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8f3e5d7-b1b3-4c6e-bd35-08d952a10867
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2021 14:56:23.6552
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hw++BhJaQ7vzMUanFBJ64I8jzWj52ontfVyTGSBrUZ60L8q/q3ovTmOlX1NbBn64yDtd8IAeiAvvKZBdD6PT8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4224
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA has gained the recent ability to deal gracefully with upper
interfaces it cannot offload, such as the bridge, bonding or team
drivers. When such uppers exist, the ports are still in standalone mode
as far as the hardware is concerned.

But when we deliver packets to the software bridge in order for that to
do the forwarding, there is an unpleasant surprise in that the bridge
will refuse to forward them. This is because we unconditionally set
skb->offload_fwd_mark = true, meaning that the bridge thinks the frames
were already forwarded in hardware by us.

Since dp->bridge_dev is populated only when there is hardware offload
for it, but not in the software fallback case, let's introduce a new
helper that can be called from the tagger data path which sets the
skb->offload_fwd_mark accordingly to zero when there is no hardware
offload for bridging. This lets the bridge forward packets back to other
interfaces of our switch, if needed.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Tobias Waldekranz <tobias@waldekranz.com>
---
 net/dsa/dsa_priv.h         | 14 ++++++++++++++
 net/dsa/tag_brcm.c         |  4 ++--
 net/dsa/tag_dsa.c          | 15 +++++++++++----
 net/dsa/tag_hellcreek.c    |  2 +-
 net/dsa/tag_ksz.c          |  2 +-
 net/dsa/tag_lan9303.c      |  3 ++-
 net/dsa/tag_mtk.c          |  2 +-
 net/dsa/tag_ocelot.c       |  2 +-
 net/dsa/tag_ocelot_8021q.c |  2 +-
 net/dsa/tag_rtl4_a.c       |  2 +-
 net/dsa/tag_sja1105.c      | 20 ++++++++++++++------
 net/dsa/tag_xrs700x.c      |  2 +-
 12 files changed, 50 insertions(+), 20 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index da3ad02d6ceb..e43c5dc04282 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -440,6 +440,20 @@ dsa_find_designated_bridge_port_by_vid(struct net_device *master, u16 vid)
 	return NULL;
 }
 
+/* If the ingress port offloads the bridge, we mark the frame as autonomously
+ * forwarded by hardware, so the software bridge doesn't forward in twice, back
+ * to us, because we already did. However, if we're in fallback mode and we do
+ * software bridging, we are not offloading it, therefore the dp->bridge_dev
+ * pointer is not populated, and flooding needs to be done by software (we are
+ * effectively operating in standalone ports mode).
+ */
+static inline void dsa_default_offload_fwd_mark(struct sk_buff *skb)
+{
+	struct dsa_port *dp = dsa_slave_to_port(skb->dev);
+
+	skb->offload_fwd_mark = !!(dp->bridge_dev);
+}
+
 /* switch.c */
 int dsa_switch_register_notifier(struct dsa_switch *ds);
 void dsa_switch_unregister_notifier(struct dsa_switch *ds);
diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
index 0750af951fc9..a27f5096777a 100644
--- a/net/dsa/tag_brcm.c
+++ b/net/dsa/tag_brcm.c
@@ -167,7 +167,7 @@ static struct sk_buff *brcm_tag_rcv_ll(struct sk_buff *skb,
 	/* Remove Broadcom tag and update checksum */
 	skb_pull_rcsum(skb, BRCM_TAG_LEN);
 
-	skb->offload_fwd_mark = 1;
+	dsa_default_offload_fwd_mark(skb);
 
 	return skb;
 }
@@ -271,7 +271,7 @@ static struct sk_buff *brcm_leg_tag_rcv(struct sk_buff *skb,
 	/* Remove Broadcom tag and update checksum */
 	skb_pull_rcsum(skb, BRCM_LEG_TAG_LEN);
 
-	skb->offload_fwd_mark = 1;
+	dsa_default_offload_fwd_mark(skb);
 
 	/* Move the Ethernet DA and SA */
 	memmove(skb->data - ETH_HLEN,
diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
index 0f258218c8cf..3607499d0697 100644
--- a/net/dsa/tag_dsa.c
+++ b/net/dsa/tag_dsa.c
@@ -198,8 +198,8 @@ static struct sk_buff *dsa_xmit_ll(struct sk_buff *skb, struct net_device *dev,
 static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
 				  u8 extra)
 {
+	bool trap = false, trunk = false;
 	int source_device, source_port;
-	bool trunk = false;
 	enum dsa_code code;
 	enum dsa_cmd cmd;
 	u8 *dsa_header;
@@ -210,8 +210,6 @@ static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
 	cmd = dsa_header[0] >> 6;
 	switch (cmd) {
 	case DSA_CMD_FORWARD:
-		skb->offload_fwd_mark = 1;
-
 		trunk = !!(dsa_header[1] & 7);
 		break;
 
@@ -230,7 +228,6 @@ static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
 			 * device (like a bridge) that forwarding has
 			 * already been done by hardware.
 			 */
-			skb->offload_fwd_mark = 1;
 			break;
 		case DSA_CODE_MGMT_TRAP:
 		case DSA_CODE_IGMP_MLD_TRAP:
@@ -238,6 +235,7 @@ static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
 			/* Traps have, by definition, not been
 			 * forwarded by hardware, so don't mark them.
 			 */
+			trap = true;
 			break;
 		default:
 			/* Reserved code, this could be anything. Drop
@@ -271,6 +269,15 @@ static struct sk_buff *dsa_rcv_ll(struct sk_buff *skb, struct net_device *dev,
 	if (!skb->dev)
 		return NULL;
 
+	/* When using LAG offload, skb->dev is not a DSA slave interface,
+	 * so we cannot call dsa_default_offload_fwd_mark and we need to
+	 * special-case it.
+	 */
+	if (trunk)
+		skb->offload_fwd_mark = true;
+	else if (!trap)
+		dsa_default_offload_fwd_mark(skb);
+
 	/* If the 'tagged' bit is set; convert the DSA tag to a 802.1Q
 	 * tag, and delete the ethertype (extra) if applicable. If the
 	 * 'tagged' bit is cleared; delete the DSA tag, and ethertype
diff --git a/net/dsa/tag_hellcreek.c b/net/dsa/tag_hellcreek.c
index 424130f85f59..c41208cbd936 100644
--- a/net/dsa/tag_hellcreek.c
+++ b/net/dsa/tag_hellcreek.c
@@ -44,7 +44,7 @@ static struct sk_buff *hellcreek_rcv(struct sk_buff *skb,
 
 	pskb_trim_rcsum(skb, skb->len - HELLCREEK_TAG_LEN);
 
-	skb->offload_fwd_mark = true;
+	dsa_default_offload_fwd_mark(skb);
 
 	return skb;
 }
diff --git a/net/dsa/tag_ksz.c b/net/dsa/tag_ksz.c
index a201ccf2435d..1c2dfa80f9b0 100644
--- a/net/dsa/tag_ksz.c
+++ b/net/dsa/tag_ksz.c
@@ -24,7 +24,7 @@ static struct sk_buff *ksz_common_rcv(struct sk_buff *skb,
 
 	pskb_trim_rcsum(skb, skb->len - len);
 
-	skb->offload_fwd_mark = true;
+	dsa_default_offload_fwd_mark(skb);
 
 	return skb;
 }
diff --git a/net/dsa/tag_lan9303.c b/net/dsa/tag_lan9303.c
index 26207ef39ebc..cf7cf2fa1240 100644
--- a/net/dsa/tag_lan9303.c
+++ b/net/dsa/tag_lan9303.c
@@ -115,7 +115,8 @@ static struct sk_buff *lan9303_rcv(struct sk_buff *skb, struct net_device *dev,
 	skb_pull_rcsum(skb, 2 + 2);
 	memmove(skb->data - ETH_HLEN, skb->data - (ETH_HLEN + LAN9303_TAG_LEN),
 		2 * ETH_ALEN);
-	skb->offload_fwd_mark = !(lan9303_tag1 & LAN9303_TAG_RX_TRAPPED_TO_CPU);
+	if (!(lan9303_tag1 & LAN9303_TAG_RX_TRAPPED_TO_CPU))
+		dsa_default_offload_fwd_mark(skb);
 
 	return skb;
 }
diff --git a/net/dsa/tag_mtk.c b/net/dsa/tag_mtk.c
index cc3ba864ad5b..3fb80e43f3a5 100644
--- a/net/dsa/tag_mtk.c
+++ b/net/dsa/tag_mtk.c
@@ -92,7 +92,7 @@ static struct sk_buff *mtk_tag_rcv(struct sk_buff *skb, struct net_device *dev,
 	if (!skb->dev)
 		return NULL;
 
-	skb->offload_fwd_mark = 1;
+	dsa_default_offload_fwd_mark(skb);
 
 	return skb;
 }
diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
index 190f4bfd3bef..3252634a29b8 100644
--- a/net/dsa/tag_ocelot.c
+++ b/net/dsa/tag_ocelot.c
@@ -104,7 +104,7 @@ static struct sk_buff *ocelot_rcv(struct sk_buff *skb,
 		 */
 		return NULL;
 
-	skb->offload_fwd_mark = 1;
+	dsa_default_offload_fwd_mark(skb);
 	skb->priority = qos_class;
 
 	/* Ocelot switches copy frames unmodified to the CPU. However, it is
diff --git a/net/dsa/tag_ocelot_8021q.c b/net/dsa/tag_ocelot_8021q.c
index d0781b058610..c95de71d13b0 100644
--- a/net/dsa/tag_ocelot_8021q.c
+++ b/net/dsa/tag_ocelot_8021q.c
@@ -49,7 +49,7 @@ static struct sk_buff *ocelot_rcv(struct sk_buff *skb,
 	if (!skb->dev)
 		return NULL;
 
-	skb->offload_fwd_mark = 1;
+	dsa_default_offload_fwd_mark(skb);
 
 	return skb;
 }
diff --git a/net/dsa/tag_rtl4_a.c b/net/dsa/tag_rtl4_a.c
index 57c46b4ab2b3..f6b63aad6551 100644
--- a/net/dsa/tag_rtl4_a.c
+++ b/net/dsa/tag_rtl4_a.c
@@ -114,7 +114,7 @@ static struct sk_buff *rtl4a_tag_rcv(struct sk_buff *skb,
 		skb->data - ETH_HLEN - RTL4_A_HDR_LEN,
 		2 * ETH_ALEN);
 
-	skb->offload_fwd_mark = 1;
+	dsa_default_offload_fwd_mark(skb);
 
 	return skb;
 }
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index c1f993d592ef..664cb802b71a 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -405,8 +405,6 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 	is_link_local = sja1105_is_link_local(skb);
 	is_meta = sja1105_is_meta_frame(skb);
 
-	skb->offload_fwd_mark = 1;
-
 	if (sja1105_skb_has_tag_8021q(skb)) {
 		/* Normal traffic path. */
 		sja1105_vlan_rcv(skb, &source_port, &switch_id, &vid);
@@ -437,6 +435,9 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 		return NULL;
 	}
 
+	if (!is_link_local)
+		dsa_default_offload_fwd_mark(skb);
+
 	return sja1105_rcv_meta_state_machine(skb, &meta, is_link_local,
 					      is_meta);
 }
@@ -480,7 +481,8 @@ static struct sk_buff *sja1110_rcv_meta(struct sk_buff *skb, u16 rx_header)
 
 static struct sk_buff *sja1110_rcv_inband_control_extension(struct sk_buff *skb,
 							    int *source_port,
-							    int *switch_id)
+							    int *switch_id,
+							    bool *host_only)
 {
 	u16 rx_header;
 
@@ -494,6 +496,9 @@ static struct sk_buff *sja1110_rcv_inband_control_extension(struct sk_buff *skb,
 	 */
 	rx_header = ntohs(*(__be16 *)skb->data);
 
+	if (rx_header & SJA1110_RX_HEADER_HOST_ONLY)
+		*host_only = true;
+
 	if (rx_header & SJA1110_RX_HEADER_IS_METADATA)
 		return sja1110_rcv_meta(skb, rx_header);
 
@@ -545,13 +550,13 @@ static struct sk_buff *sja1110_rcv(struct sk_buff *skb,
 				   struct packet_type *pt)
 {
 	int source_port = -1, switch_id = -1;
+	bool host_only = false;
 	u16 vid;
 
-	skb->offload_fwd_mark = 1;
-
 	if (sja1110_skb_has_inband_control_extension(skb)) {
 		skb = sja1110_rcv_inband_control_extension(skb, &source_port,
-							   &switch_id);
+							   &switch_id,
+							   &host_only);
 		if (!skb)
 			return NULL;
 	}
@@ -569,6 +574,9 @@ static struct sk_buff *sja1110_rcv(struct sk_buff *skb,
 		return NULL;
 	}
 
+	if (!host_only)
+		dsa_default_offload_fwd_mark(skb);
+
 	return skb;
 }
 
diff --git a/net/dsa/tag_xrs700x.c b/net/dsa/tag_xrs700x.c
index a31ff7fcb45f..da231c16ac82 100644
--- a/net/dsa/tag_xrs700x.c
+++ b/net/dsa/tag_xrs700x.c
@@ -46,7 +46,7 @@ static struct sk_buff *xrs700x_rcv(struct sk_buff *skb, struct net_device *dev,
 		return NULL;
 
 	/* Frame is forwarded by hardware, don't forward in software. */
-	skb->offload_fwd_mark = 1;
+	dsa_default_offload_fwd_mark(skb);
 
 	return skb;
 }
-- 
2.25.1

