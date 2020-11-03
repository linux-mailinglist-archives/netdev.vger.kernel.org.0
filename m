Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D20D2A473D
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 15:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729423AbgKCODH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 09:03:07 -0500
Received: from mail-eopbgr80082.outbound.protection.outlook.com ([40.107.8.82]:32134
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729242AbgKCOCf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 09:02:35 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZmUvNNAUDcMlq4r5WCFI6/ttY7aOLNSncY5Ks49dxyJFLuU0jj7p7cg7Po+BmZaUMFkEjfwj7xkjHEAckiZVJd1CDNy+OFDuabWQRw664er460zz21ErSn/mNDP2dyR6HDxd3xjmYXoDBqRZFGq7OM3IZdsQVpjmaHAsvs25GUnfD1YOGUq6TEuuaEvJVefUF17rx/XFdH//whYV20ivnA7iKXCSl5qKl2qsP1DpM21Lstpop0tO1wkAhc1yt57tK/qnTl1znyfhJad9mndFO3WF2HUNmXbgn/Ilg1WlIv8qdMfOuHYJv0QdHwUrSz7HF/GO6fxcJ1gJqJ1+3YDLuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q9sulBhXO9iitiGgBSHHCV4UkdGW9F+VFLnF5Es4ItU=;
 b=FSjafGb3FSwrZRVbMW864Pw3+D3gNFvPbe/c9MI2lKuEbulohEeKCBIMiInLnPiV8ygQcfAar4ivfXd+P5RueoX/SiOCBtdy/asJxvpIs2Pf8DZV8Qsr0bnjH0iD8bWkaelazFD4T8aV704NipkiVA4nHLNs7AQ250vvvgBuGNWzUCZ0oJjEkpCXBkExoKdoiS1Z/kxpu38myiiX/fEwbJed8lxI74haIWZBZUagvFBNaUpqnQxg10MnkcmRqQDov59WzymW//o2rsho5HWFJzm+OnDJjDIxvf4r347Yps9z3bWfiQLaQN/5BvUeLZ/uXfDhkGmjULslH30tnwJEqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q9sulBhXO9iitiGgBSHHCV4UkdGW9F+VFLnF5Es4ItU=;
 b=BTcikKjMEF23al810XnDnx/ILAd86YvUDLajIyeYYetRlRVMxFKXztje+z9cqJBx+DeVYOlxtlfuwXCQGSQU1ljWr7Q2hdEZjntvv74jNIqimCUG4I/M3j5Q4oNsyZj9yfEc5P7+5dnIgvnUU3uAr3Qpg6XdVm7dVjnOrVkOp78=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com (2603:10a6:208:170::28)
 by AM0PR0402MB3507.eurprd04.prod.outlook.com (2603:10a6:208:24::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21; Tue, 3 Nov
 2020 14:02:30 +0000
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::21b9:fda3:719f:f37b]) by AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::21b9:fda3:719f:f37b%3]) with mapi id 15.20.3499.032; Tue, 3 Nov 2020
 14:02:30 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH net-next] enetc: Remove Tx checksumming offload code
Date:   Tue,  3 Nov 2020 16:02:13 +0200
Message-Id: <20201103140213.3294-1-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [83.217.231.2]
X-ClientProxiedBy: AM0PR03CA0008.eurprd03.prod.outlook.com
 (2603:10a6:208:14::21) To AM0PR04MB6754.eurprd04.prod.outlook.com
 (2603:10a6:208:170::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15141.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR03CA0008.eurprd03.prod.outlook.com (2603:10a6:208:14::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Tue, 3 Nov 2020 14:02:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 46c05b01-c52d-4b68-2f70-08d880011a43
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3507:
X-Microsoft-Antispam-PRVS: <AM0PR0402MB3507C805C7DF081968C0A65296110@AM0PR0402MB3507.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AxQW6PZDfgRi0NJ9YlCLBmbJbfIAt6BCMPI8ujphtnTlh2AkkzBzzuOfEMWULWEiREcK8THWZDpZGjzIO8l5jL8SF18sxk6y1lp9kbI9ncSokQxiEkpVOMvLeZB3OLmWKytLhQmkx31gOj9gMBAropQ30L1x7FwCW3SFN9U/TpRHFBa5Myqa+BQYc4y90ODktuCCdcr66JxxzxaW8n++PRrKgoWKPhXzPk2OdiQOSqhjww2ojqsb+b0kgq8iT2Y2NY+aWZBa652aS2rOYy9DjXWOzsQNwsQXfxVPSffWzdabjX9JmNmIhU0FVllmposbI0C9WcJNiEbvN69aF/uPng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6754.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(498600001)(4326008)(66556008)(66476007)(6486002)(36756003)(2906002)(5660300002)(66946007)(86362001)(44832011)(7696005)(54906003)(52116002)(2616005)(1076003)(6916009)(26005)(8676002)(8936002)(186003)(956004)(16526019)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: c8n7NVPn8+uUf7N7NTYESFRlmaW+XhiLuwsAACOgjoGI6xYDjQlJ6bLKBca9AH8iKZZJxWKJJeUbRtCbsseCVddZY/maUyVL8xhB6KWMhmt5LqgbAyCf13btCuo3orBKfscKlYYz3K4X0cEG35uUr10amK+69lgdg0DxJOgcppZ49ACQkd+uzIomDTWmbP67x/g/y/y++WMN1p9IDy2fLrpxuHKSQfjTK7nKQSLrifoGl+bQXGizVp6zTkrj8YzZiY4E5WkGusAST99AuX8yUQBnh4FDYbdE69qYN/lJHLsSzbWdElR1zUZVExuOEq5/d3zecEy0Q8lKL4gi1jpiYkvYfpVBW48Og8NxVu9asLM5wBSDBgIEwqLJKP82ONZES6km0daaLhcKrcIPPAqMMM4QEXMa8s9R/O7R0Sej2mBoh/DSXrt+GiEK71w950UZjalBV8iz+84lKaVBeNx0gmAky06cnXVheWDU6/k7MuoJmvw/RnHhfNywRzT2D/L3CqcTyVWKabZhP6h+ZJmksi8GRZQ9LPSXN3xDwhpg45B1h/7UDkZtGUhbBg+L4gVGu15VxT1qJvTmtk+kL2z6cs+Y+Z7a85zesFTwHV9LY0lpPLcT+JKwkTHJsNjoaBW9EJxokHMW3QKp2Vok1gqrxg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46c05b01-c52d-4b68-2f70-08d880011a43
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6754.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2020 14:02:29.9556
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eUSyuINQXqc/I6st835uBoxVbYauzv1LnM2OMw0Aqc7P8xV7bTY+V9RRB4dPN3bHELe7siqAqDlSE3xxi0p9GQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3507
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tx checksumming has been defeatured and completely removed
from the h/w reference manual. Made a little cleanup for the
TSE case as this is complementary code.

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c  | 51 ++-----------------
 drivers/net/ethernet/freescale/enetc/enetc.h  |  5 +-
 .../net/ethernet/freescale/enetc/enetc_hw.h   | 47 ++++++++---------
 .../net/ethernet/freescale/enetc/enetc_pf.c   | 10 +---
 .../net/ethernet/freescale/enetc/enetc_vf.c   | 10 +---
 5 files changed, 32 insertions(+), 91 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index 52be6e315752..01089c30b462 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -47,40 +47,6 @@ netdev_tx_t enetc_xmit(struct sk_buff *skb, struct net_device *ndev)
 	return NETDEV_TX_OK;
 }
 
-static bool enetc_tx_csum(struct sk_buff *skb, union enetc_tx_bd *txbd)
-{
-	int l3_start, l3_hsize;
-	u16 l3_flags, l4_flags;
-
-	if (skb->ip_summed != CHECKSUM_PARTIAL)
-		return false;
-
-	switch (skb->csum_offset) {
-	case offsetof(struct tcphdr, check):
-		l4_flags = ENETC_TXBD_L4_TCP;
-		break;
-	case offsetof(struct udphdr, check):
-		l4_flags = ENETC_TXBD_L4_UDP;
-		break;
-	default:
-		skb_checksum_help(skb);
-		return false;
-	}
-
-	l3_start = skb_network_offset(skb);
-	l3_hsize = skb_network_header_len(skb);
-
-	l3_flags = 0;
-	if (skb->protocol == htons(ETH_P_IPV6))
-		l3_flags = ENETC_TXBD_L3_IPV6;
-
-	/* write BD fields */
-	txbd->l3_csoff = enetc_txbd_l3_csoff(l3_start, l3_hsize, l3_flags);
-	txbd->l4_csoff = l4_flags;
-
-	return true;
-}
-
 static void enetc_unmap_tx_buff(struct enetc_bdr *tx_ring,
 				struct enetc_tx_swbd *tx_swbd)
 {
@@ -146,22 +112,16 @@ static int enetc_map_tx_buffs(struct enetc_bdr *tx_ring, struct sk_buff *skb,
 	if (do_vlan || do_tstamp)
 		flags |= ENETC_TXBD_FLAGS_EX;
 
-	if (enetc_tx_csum(skb, &temp_bd))
-		flags |= ENETC_TXBD_FLAGS_CSUM | ENETC_TXBD_FLAGS_L4CS;
-	else if (tx_ring->tsd_enable)
+	if (tx_ring->tsd_enable)
 		flags |= ENETC_TXBD_FLAGS_TSE | ENETC_TXBD_FLAGS_TXSTART;
 
 	/* first BD needs frm_len and offload flags set */
 	temp_bd.frm_len = cpu_to_le16(skb->len);
 	temp_bd.flags = flags;
 
-	if (flags & ENETC_TXBD_FLAGS_TSE) {
-		u32 temp;
-
-		temp = (skb->skb_mstamp_ns >> 5 & ENETC_TXBD_TXSTART_MASK)
-			| (flags << ENETC_TXBD_FLAGS_OFFSET);
-		temp_bd.txstart = cpu_to_le32(temp);
-	}
+	if (flags & ENETC_TXBD_FLAGS_TSE)
+		temp_bd.txstart = enetc_txbd_set_tx_start(skb->skb_mstamp_ns,
+							  flags);
 
 	if (flags & ENETC_TXBD_FLAGS_EX) {
 		u8 e_flags = 0;
@@ -1897,8 +1857,7 @@ static void enetc_kfree_si(struct enetc_si *si)
 static void enetc_detect_errata(struct enetc_si *si)
 {
 	if (si->pdev->revision == ENETC_REV1)
-		si->errata = ENETC_ERR_TXCSUM | ENETC_ERR_VLAN_ISOL |
-			     ENETC_ERR_UCMCSWP;
+		si->errata = ENETC_ERR_VLAN_ISOL | ENETC_ERR_UCMCSWP;
 }
 
 int enetc_pci_probe(struct pci_dev *pdev, const char *name, int sizeof_priv)
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index dd0fb0c066d7..8532d23b54f5 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -147,9 +147,8 @@ struct enetc_msg_swbd {
 
 #define ENETC_REV1	0x1
 enum enetc_errata {
-	ENETC_ERR_TXCSUM	= BIT(0),
-	ENETC_ERR_VLAN_ISOL	= BIT(1),
-	ENETC_ERR_UCMCSWP	= BIT(2),
+	ENETC_ERR_VLAN_ISOL	= BIT(0),
+	ENETC_ERR_UCMCSWP	= BIT(1),
 };
 
 #define ENETC_SI_F_QBV BIT(0)
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index 17cf7c94fdb5..68ef4f959982 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -374,8 +374,7 @@ union enetc_tx_bd {
 		__le16 frm_len;
 		union {
 			struct {
-				__le16 l3_csoff;
-				u8 l4_csoff;
+				u8 reserved[3];
 				u8 flags;
 			}; /* default layout */
 			__le32 txstart;
@@ -398,41 +397,37 @@ union enetc_tx_bd {
 	} wb; /* writeback descriptor */
 };
 
-#define ENETC_TXBD_FLAGS_L4CS	BIT(0)
-#define ENETC_TXBD_FLAGS_TSE	BIT(1)
-#define ENETC_TXBD_FLAGS_W	BIT(2)
-#define ENETC_TXBD_FLAGS_CSUM	BIT(3)
-#define ENETC_TXBD_FLAGS_TXSTART BIT(4)
-#define ENETC_TXBD_FLAGS_EX	BIT(6)
-#define ENETC_TXBD_FLAGS_F	BIT(7)
+enum enetc_txbd_flags {
+	ENETC_TXBD_FLAGS_RES0 = BIT(0), /* reserved */
+	ENETC_TXBD_FLAGS_TSE = BIT(1),
+	ENETC_TXBD_FLAGS_W = BIT(2),
+	ENETC_TXBD_FLAGS_RES3 = BIT(3), /* reserved */
+	ENETC_TXBD_FLAGS_TXSTART = BIT(4),
+	ENETC_TXBD_FLAGS_EX = BIT(6),
+	ENETC_TXBD_FLAGS_F = BIT(7)
+};
 #define ENETC_TXBD_TXSTART_MASK GENMASK(24, 0)
 #define ENETC_TXBD_FLAGS_OFFSET 24
+
+static inline __le32 enetc_txbd_set_tx_start(u64 tx_start, u8 flags)
+{
+	u32 temp;
+
+	temp = (tx_start >> 5 & ENETC_TXBD_TXSTART_MASK) |
+	       (flags << ENETC_TXBD_FLAGS_OFFSET);
+
+	return cpu_to_le32(temp);
+}
+
 static inline void enetc_clear_tx_bd(union enetc_tx_bd *txbd)
 {
 	memset(txbd, 0, sizeof(*txbd));
 }
 
-/* L3 csum flags */
-#define ENETC_TXBD_L3_IPCS	BIT(7)
-#define ENETC_TXBD_L3_IPV6	BIT(15)
-
-#define ENETC_TXBD_L3_START_MASK	GENMASK(6, 0)
-#define ENETC_TXBD_L3_SET_HSIZE(val)	((((val) >> 2) & 0x7f) << 8)
-
 /* Extension flags */
 #define ENETC_TXBD_E_FLAGS_VLAN_INS	BIT(0)
 #define ENETC_TXBD_E_FLAGS_TWO_STEP_PTP	BIT(2)
 
-static inline __le16 enetc_txbd_l3_csoff(int start, int hdr_sz, u16 l3_flags)
-{
-	return cpu_to_le16(l3_flags | ENETC_TXBD_L3_SET_HSIZE(hdr_sz) |
-			   (start & ENETC_TXBD_L3_START_MASK));
-}
-
-/* L4 csum flags */
-#define ENETC_TXBD_L4_UDP	BIT(5)
-#define ENETC_TXBD_L4_TCP	BIT(6)
-
 union enetc_rx_bd {
 	struct {
 		__le64 addr;
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 419306342ac5..ecdc2af8c292 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -714,22 +714,16 @@ static void enetc_pf_netdev_setup(struct enetc_si *si, struct net_device *ndev,
 	ndev->watchdog_timeo = 5 * HZ;
 	ndev->max_mtu = ENETC_MAX_MTU;
 
-	ndev->hw_features = NETIF_F_SG | NETIF_F_RXCSUM | NETIF_F_HW_CSUM |
+	ndev->hw_features = NETIF_F_SG | NETIF_F_RXCSUM |
 			    NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
 			    NETIF_F_HW_VLAN_CTAG_FILTER | NETIF_F_LOOPBACK;
-	ndev->features = NETIF_F_HIGHDMA | NETIF_F_SG |
-			 NETIF_F_RXCSUM | NETIF_F_HW_CSUM |
+	ndev->features = NETIF_F_HIGHDMA | NETIF_F_SG | NETIF_F_RXCSUM |
 			 NETIF_F_HW_VLAN_CTAG_TX |
 			 NETIF_F_HW_VLAN_CTAG_RX;
 
 	if (si->num_rss)
 		ndev->hw_features |= NETIF_F_RXHASH;
 
-	if (si->errata & ENETC_ERR_TXCSUM) {
-		ndev->hw_features &= ~NETIF_F_HW_CSUM;
-		ndev->features &= ~NETIF_F_HW_CSUM;
-	}
-
 	ndev->priv_flags |= IFF_UNICAST_FLT;
 
 	if (si->hw_features & ENETC_SI_F_QBV)
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_vf.c b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
index 7b5c82c7e4e5..39c1a09e69a9 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_vf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
@@ -120,22 +120,16 @@ static void enetc_vf_netdev_setup(struct enetc_si *si, struct net_device *ndev,
 	ndev->watchdog_timeo = 5 * HZ;
 	ndev->max_mtu = ENETC_MAX_MTU;
 
-	ndev->hw_features = NETIF_F_SG | NETIF_F_RXCSUM | NETIF_F_HW_CSUM |
+	ndev->hw_features = NETIF_F_SG | NETIF_F_RXCSUM |
 			    NETIF_F_HW_VLAN_CTAG_TX |
 			    NETIF_F_HW_VLAN_CTAG_RX;
-	ndev->features = NETIF_F_HIGHDMA | NETIF_F_SG |
-			 NETIF_F_RXCSUM | NETIF_F_HW_CSUM |
+	ndev->features = NETIF_F_HIGHDMA | NETIF_F_SG | NETIF_F_RXCSUM |
 			 NETIF_F_HW_VLAN_CTAG_TX |
 			 NETIF_F_HW_VLAN_CTAG_RX;
 
 	if (si->num_rss)
 		ndev->hw_features |= NETIF_F_RXHASH;
 
-	if (si->errata & ENETC_ERR_TXCSUM) {
-		ndev->hw_features &= ~NETIF_F_HW_CSUM;
-		ndev->features &= ~NETIF_F_HW_CSUM;
-	}
-
 	/* pick up primary MAC address from SI */
 	enetc_get_primary_mac_addr(&si->hw, ndev->dev_addr);
 }
-- 
2.17.1

