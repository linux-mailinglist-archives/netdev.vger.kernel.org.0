Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FBC2392D96
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 14:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234914AbhE0MJW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 08:09:22 -0400
Received: from mail-eopbgr130057.outbound.protection.outlook.com ([40.107.13.57]:4997
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234941AbhE0MJP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 08:09:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hrbzZXIGQ6CLJGQpo10/HDToRwAEIeoW48KNdbHBeMW8ANfTikRC+lWQAnStEC8+gAn4D5rv4KaoTdZaVvXxD8dVyLcLkEC7DXsE9XF2JYraHekiipSm4r6Rkcyj5sUt6wzC/sBmCG3pitO+pidWaSQsu8MeTBd9sAZG4wrtu3aqbyEaRJgkSAJ1p19kmf9W4gq9maucxKUSZurBzkI+OxSNXlJj4SvWaQRMGYyb77ezZfrPeOn+6mgsy8w9cOtZBNiRE+T5pbiAEkQqDOrOxSgFdfwtVFZ/1x5jUUT1pO5Z87H3XxNpzma0BCK1v1ukCSOce+9CeSfnUgchgfAn3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sJS3Hj+6ttzVMi5PUlXK4EEgrMZFHeWEDyvxWYNDGHA=;
 b=O2xHyQV9dMq3TS6J9kkZ+ZopmmzVeeux3e3ghWnIqmq+wNF15jR6oN/suhCcwZXCJCUVNuuQ54FcFpS0qqALdtpsAkq8+GgO0U2aSp9/ddDdoJOtpIaBg1snUIcZR5qgZGgZkNwRfMODqkigKXnwRnA/07zasJV6Oq+gL3t3UuDimuUDCNyCRlpX5R+XmG7/4HldpsUZJVUUhz4JTpesfyXYGOwkWx0aXrkvQmQfSYrj0Nvf4zeeX2U61tXh+A+gglXuUJNSisPqG0EdHqrzydsmuBfOTexpxwYwd1zOrnqlEdts8mm7KlV+1TfbC1uAvm8kOmW+HqSDGvRGEpdMCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sJS3Hj+6ttzVMi5PUlXK4EEgrMZFHeWEDyvxWYNDGHA=;
 b=E+de6e6YDvpB0kzYm2mXug16h0q2Qi4RxhSnsNArfZyWYeNGRsg3TSwzUQfg/Rs9yyQ4DMflcmin6cAD/3XEvDGxyaJl8FVHD8UC4a0ejkr4gaVrJeql26XMMqkykmrTcEUeVXMZITMeL7a0KSCHDpQMYFI9wFNGualBWpYxsnQ=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB9PR04MB8429.eurprd04.prod.outlook.com (2603:10a6:10:24e::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Thu, 27 May
 2021 12:07:35 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3400:b139:f681:c8cf%9]) with mapi id 15.20.4150.027; Thu, 27 May 2021
 12:07:35 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, frieder.schrempf@kontron.de,
        andrew@lunn.ch
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com
Subject: [PATCH V1 net-next 2/2] net: fec: add ndo_select_queue to fix TX bandwidth fluctuations
Date:   Thu, 27 May 2021 20:07:22 +0800
Message-Id: <20210527120722.16965-3-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210527120722.16965-1-qiangqing.zhang@nxp.com>
References: <20210527120722.16965-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR02CA0110.apcprd02.prod.outlook.com
 (2603:1096:4:92::26) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR02CA0110.apcprd02.prod.outlook.com (2603:1096:4:92::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Thu, 27 May 2021 12:07:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6e675776-93df-4a9b-fe54-08d921080355
X-MS-TrafficTypeDiagnostic: DB9PR04MB8429:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB9PR04MB8429116D0450F4B7A2F28DC9E6239@DB9PR04MB8429.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W+fR292U+KOrXVQ0KAAt+/M+nKW50VVP5EjbMsUuaFxM0183mIS/za3216wUpMujII3qydevtt/qEErH6oOuVPz0pY2+34MCuehUUbmd4RT2AXtM7GS9g3trnnOtMhAlBi9lCnsb0o5t86mGjHsXA6clyETbGNN8pOWHtgLef6ckejgAukTq+nDCpl2Gkc1GGoppgZAETTgYTRLapnDLJhsVs07wKJDFhMbOL7YypJc7QWjFBaTdx8nriQT1lRyrsVZ6HdV80+3nLbyjKiwFr+L1G2e4Q/oc93A1NdXLoYoyudTFa7Ti91bel93EkAvVvDg/cXkvyhzRlxvuGR1/JBODJx491b6qoPArN3omjtihR+vwTtBxuOiHZ6bWqir8rTqSCU/D9zfUdLB0aWjSDuJptOdQx4USGfBY8/KaTc4j+OGeGlqdLKdia3aihCyt7LUz5iWrzIh+db3sN5kvPAvjUOMjUIvqDQM+n+qAkhUfOdPCR5VR0RLnN7pLpfClLC1kgR+ElKMLRNgNHZf5jjY01/faBm+q2q6nRnOoP1BEKKows6W2WXVjAlZklOr2S7y5X9257qO6ULsT7QnhLbaR2n35mWV7wneGfbeiXeOgUIP8Rifgz8XPVT+8e1hV6aZVdLhNWscfdIXAGrpHkyRLUtl19wPVW6sCwVYWf7z7xRVjM8oxKXqIc2aagNcb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(366004)(346002)(39850400004)(136003)(26005)(6512007)(83380400001)(38350700002)(38100700002)(186003)(16526019)(2906002)(86362001)(8936002)(8676002)(4326008)(6506007)(6486002)(52116002)(6666004)(66556008)(66476007)(316002)(1076003)(66946007)(2616005)(956004)(5660300002)(36756003)(478600001)(69590400013);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?tDWP8fvjbxq2Y6J68vGuJrwUw+ne+qwsXAitQ1frhyUHXzfilWhwcoQx6IT1?=
 =?us-ascii?Q?lm0eXakq2YL8eCmeePsnQabA2PXqkb70MKFfkQe+QBqY80H5VpL9rUYuO0Hx?=
 =?us-ascii?Q?e+Md8//9R11BCxrcz36INRYODi0pmPij1Ia/soh8SG1RIcCd/JVDM54dboxX?=
 =?us-ascii?Q?yU+46fukfh1FRDFEhrSPIh3fvhgk61H8WX5+/lRuWAj3+OJKM0FOAsoHyoqR?=
 =?us-ascii?Q?mxDB702gBgEyz62DGGAXxU35qpzFPE1jBfIPvXDF1nFtGZHRKhH7vxyy8Jgp?=
 =?us-ascii?Q?fe0E/k4jZDB24hAos6qmzpCXEEy6tA/lrULcvWabSpnzbDRgK6+uXKfI40P9?=
 =?us-ascii?Q?QMn2xxYjyoU6FvcbM+jDIdI1ziadxiuLlUGJ98UsFxdd4oVDQR45sBJEx7wF?=
 =?us-ascii?Q?7uRtLpZ7PZSYTSImzD5FBK8ew8VA7FKA2QOUolr3Dli/7o+iSry3i0cQOfvU?=
 =?us-ascii?Q?upRAZGPoS86rkBX23alB8eXfK6+DDcMWq3LOjP5sBtw6BfXOgsGDKU7YrR19?=
 =?us-ascii?Q?ncCcXXjK68ol2kO+Xto4VXNHLU7Ew0pqns+qBajJ+3RRUf6bY+vPh3zwN+oQ?=
 =?us-ascii?Q?76Q/SvJNXz4W3RkLz9d3Fn2SkZLaopCmKYiQKWBIKm/3nBewBeerjpcwL0Ww?=
 =?us-ascii?Q?JNDc6Wkzjv46BTBLIlBd42pHeezrnf1NWPTpi37i1FG1/hv74Hsq8eV2Pkoh?=
 =?us-ascii?Q?v3EImbgBulksRNk1iMFAL+aZ/KXh3Bmr2wyQ6yYrIB4pqSc+Xx5r/PS2wTMH?=
 =?us-ascii?Q?xez9HcZ/HFxbMiiiumKQHUHUFN8nMbMdWwlJ7fkxor1CePMAZdLK5CDa7CXm?=
 =?us-ascii?Q?DpfMmylFb17bszMSiriAiKFoiAowAolW0+I0E0jpyzmyL6Nlwyz/MI6oQPdL?=
 =?us-ascii?Q?jq+O207W1QUJrMm/ka8pPEzY0Xml4GhBIuA5cvncp1zvETPtaDDLMv6ri390?=
 =?us-ascii?Q?IBVO+C9QLEwvTx+OHSbwOG1IvWAWoNuV7MFStSXOVtbHQiDe3ZdoiIgrFkvY?=
 =?us-ascii?Q?wFb+qbXgEhDrskST7+jCYSR8R/F5YNH+9IGfT1CXlk+BrQjgVTdayv7nwORi?=
 =?us-ascii?Q?+ZaGYSyV8I6btu/wGoLTaZWgcz3xwmeRy8iYCsoq+pwV6dNsoL3htBWcrHMw?=
 =?us-ascii?Q?CqAVu1KNdTk/AvhLIuCIoDm/ezoWEa7Ooy/WMlqE9SPXRH31b0AVN49HIGiW?=
 =?us-ascii?Q?tGKetanAkWi8Pvhckdgc70WPJY2W7oSmSIZ+9Q/ISyiomEZRuMIYrHaabx99?=
 =?us-ascii?Q?/3NmBtBniBx+YmDL9b/soM65+ZUUdLJG8NuftrWAjQjD3hu8/W61h/vu/8Cd?=
 =?us-ascii?Q?1ne969xekX0Bnr3yKZd0h5jj?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e675776-93df-4a9b-fe54-08d921080355
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2021 12:07:35.1328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T22tqjc0XnV4lOwCdYqG/NG2fcNgXEv1sHh7+5B9tM3zdFecabpfeS5uU2u8Ab2Qk6RolRpOBVO6oFBjW7H6ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8429
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

As we know that AVB is enabled by default, and the ENET IP design is
queue 0 for best effort, queue 1&2 for AVB Class A&B. Bandwidth of each
queue 1&2 set in driver is 50%, TX bandwidth fluctuated when selecting
tx queues randomly with FEC_QUIRK_HAS_AVB quirk available.

This patch adds ndo_select_queue callback to select queues for
transmitting to fix this issue. It will always return queue 0 if this is
not a vlan packet, and return queue 1 or 2 based on priority of vlan
packet.

You may complain that in fact we only use single queue for trasmitting
if we are not targeted to VLAN. Yes, but seems we have no choice, since
AVB is enabled when the driver probed, we can't switch this feature
dynamicly. After compare multiple queues to single queue, TX throughput
almost no improvement.

One way we can implemet is to configure the driver to multiple queues
with Round-robin scheme by default. Then add ndo_setup_tc callback to
enable/disable AVB feature for users. Unfortunately, ENET AVB IP seems
not follow the standard 802.1Qav spec. We only can program
DMAnCFG[IDLE_SLOPE] field to calculate bandwidth fraction. And idle
slope is restricted to certain valus (a total of 19). It's far away from
CBS QDisc implemented in Linux TC framework. If you strongly suggest to do
this, I think we only can support limited numbers of bandwidth and reject
others, but it's really urgly and wried.

With this patch, VLAN tagged packets route to queue 0/1/2 based on vlan
priority; VLAN untagged packets route to queue 0.

Reported-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 32 +++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 053a0e547e4f..6d7e2db17995 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -76,6 +76,8 @@ static void fec_enet_itr_coal_init(struct net_device *ndev);
 
 #define DRIVER_NAME	"fec"
 
+static const u16 fec_enet_vlan_pri_to_queue[8] = {0, 0, 1, 1, 1, 2, 2, 2};
+
 /* Pause frame feild and FIFO threshold */
 #define FEC_ENET_FCE	(1 << 5)
 #define FEC_ENET_RSEM_V	0x84
@@ -3236,10 +3238,40 @@ static int fec_set_features(struct net_device *netdev,
 	return 0;
 }
 
+u16 fec_enet_get_raw_vlan_tci(struct sk_buff *skb)
+{
+	struct vlan_ethhdr *vhdr;
+	unsigned short vlan_TCI = 0;
+
+	if (skb->protocol == ntohs(ETH_P_ALL)) {
+		vhdr = (struct vlan_ethhdr *)(skb->data);
+		vlan_TCI = ntohs(vhdr->h_vlan_TCI);
+	}
+
+	return vlan_TCI;
+}
+
+u16 fec_enet_select_queue(struct net_device *ndev, struct sk_buff *skb,
+			  struct net_device *sb_dev)
+{
+	struct fec_enet_private *fep = netdev_priv(ndev);
+	u16 vlan_tag;
+
+	if (!(fep->quirks & FEC_QUIRK_HAS_AVB))
+		return netdev_pick_tx(ndev, skb, NULL);
+
+	vlan_tag = fec_enet_get_raw_vlan_tci(skb);
+	if (!vlan_tag)
+		return vlan_tag;
+
+	return fec_enet_vlan_pri_to_queue[vlan_tag >> 13];
+}
+
 static const struct net_device_ops fec_netdev_ops = {
 	.ndo_open		= fec_enet_open,
 	.ndo_stop		= fec_enet_close,
 	.ndo_start_xmit		= fec_enet_start_xmit,
+	.ndo_select_queue       = fec_enet_select_queue,
 	.ndo_set_rx_mode	= set_multicast_list,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_tx_timeout		= fec_timeout,
-- 
2.17.1

