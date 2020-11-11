Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB18B2AF72B
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 18:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727543AbgKKRFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 12:05:19 -0500
Received: from mail-vi1eur05on2098.outbound.protection.outlook.com ([40.107.21.98]:52321
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727359AbgKKRFH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 12:05:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lcfVFXiGtmLyUjEEvaR6BNPjFnqiRufxLcSDSrkGw0ra8GC1e1Guo8TQ7OyGm2goNWGOqY19XEI3cSlEu7w5vcKAsErUmpf0bQSbZSiXE3fcoAP9HQbihsSSE4//fLutKQgBep/Va0Rl9lptYkXQC8HCcIziNwS4FivYRnU6aMZJ9JjgofVSeKdoLH29M29dr5YgqYL4qoSkAxD1o1C+FYctGrIdzznW1vuqA5GblBjXbwWrwedjfF7X/JJSZBIlCeAhjhI74xnYRTOQqYiS0c/MWkfdvFTxnCkPcn/vxAoPfukaeQrZB5Q737m3RVwYbhp+cPuFmIqTnh91X2YbiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o/zjsxodsPWfYciQ7+XzoB5+Pjcy5WwsLEjLEmYqfGQ=;
 b=gdRaOF4wSw1HgsbjnSvtroIkYMJIZeCgIolVH/oi9yYQk0DFqJhdwzYH3w0l9WIEfUkKWo5yG0zmd17v1mO96Z+ZSevfvXKQv8kTsgM+Y9sJnKIXr1TokbGmh9kYDRz9w3ojO3u+0XjR9zc4ED28q+V1ypyCrsLGsKVvI+YZ3x1sbPrd1hFUgn1AgivgbT3NwTBCX58OrKm04g279poQ9XKx6l3/FcAteCdIZePjhD6scvntG24LJHcx2h1SDovxNpy5GcQRvfljCistCfT8E8O5eawC4zAT94JhhTpneRbzbn0mnYIjkiKJlUOfguKN1zb3h8/D94O6HHE68Fa52w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o/zjsxodsPWfYciQ7+XzoB5+Pjcy5WwsLEjLEmYqfGQ=;
 b=GkznpIjGoF3Krjj+JfrspaJhQq0rhC7uDs/8EL5eNU3AlaxXyrPLJwDhq+BOHDyPOpSGRVfZH17r72VMDASSnJskp7EalDZ0/Tq366SalDPAEeSC9r43g0P4RcOUI85pl21lArrHH5KbLXhZc2aBJM9hxJ8bpseynu+Fl0iCQ8I=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=voleatech.de;
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com (2603:10a6:20b:1d4::23)
 by AM8PR05MB7524.eurprd05.prod.outlook.com (2603:10a6:20b:1d3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Wed, 11 Nov
 2020 17:04:58 +0000
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4]) by AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4%7]) with mapi id 15.20.3541.025; Wed, 11 Nov 2020
 17:04:58 +0000
From:   sven.auhagen@voleatech.de
To:     anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        kuba@kernel.org
Cc:     davem@davemloft.net, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        sandeep.penigalapati@intel.com, brouer@redhat.com,
        pmenzel@molgen.mpg.de
Subject: [PATCH v4 2/6] igb: take vlan double header into account
Date:   Wed, 11 Nov 2020 18:04:49 +0100
Message-Id: <20201111170453.32693-3-sven.auhagen@voleatech.de>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20201111170453.32693-1-sven.auhagen@voleatech.de>
References: <20201111170453.32693-1-sven.auhagen@voleatech.de>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [37.209.79.82]
X-ClientProxiedBy: FR2P281CA0013.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::23) To AM8PR05MB7251.eurprd05.prod.outlook.com
 (2603:10a6:20b:1d4::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (37.209.79.82) by FR2P281CA0013.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:a::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.21 via Frontend Transport; Wed, 11 Nov 2020 17:04:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ca683a6b-4afd-4190-8da1-08d88663eb64
X-MS-TrafficTypeDiagnostic: AM8PR05MB7524:
X-Microsoft-Antispam-PRVS: <AM8PR05MB7524D485756948E2A80F6856EFE80@AM8PR05MB7524.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v/vW7VJIMhT3i6aTlAV/ndaGFrx7+i1JFGltSU/U3cedbUfy4s25uWJl/kiZtr4J0mCej3U4rb8QSvJvr4e01bZ99L+KAX23pcDduz6/nuW9rlgrgnK/bY7cNJ0iqySWrqVt4uS96Ggwi9NCPblvj3eeYynITqsESl8a+G+U8gs7w7F1YA2sECQzNqbUzFimFiVWtxPBOm2Ljc/MVTNFa4tEs6zqex2iw8NAbLoqq3I4k9RZ8HcDN+XyKHKIBLTwxR1HtWDfWj3e0b6SwItHsVIKEt84PdxMnCqB/RmSFvQZZpCLtMYJ0Z9YKZG9iSg/gWu87oDO6N6f4+YFC3rj/cOtuYw8s/2Hn4RzzsIu4mQpquUa4A78diceP4d5rjF/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7251.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39830400003)(346002)(366004)(136003)(396003)(6506007)(5660300002)(69590400008)(66476007)(66556008)(1076003)(66946007)(86362001)(8676002)(8936002)(9686003)(7416002)(26005)(52116002)(316002)(956004)(4326008)(6666004)(2616005)(6512007)(16526019)(186003)(2906002)(6486002)(36756003)(478600001)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: phRX/fe6gASOxTSWZCwHYBTxB8aRM56D4takULjulLZUHn/gGYFUH9bUAcrK2v0hf8yIhreImWsSsBttoXZfq3SjgAuJWtIR3NDFezGyCfxKuk6VT1YPMdSC7iOz5KknXO5ZmgK3z12RYQ62+8aUSc2k2mTcr1Ib1ea/7lABAikXo/rRYNHfsEg4bvnYFQ8faXL2JcH1dz/VjvanimqWqq/IlfUYwfE5RKjWuGNeMiWUSVjyesA9b8NagGUgjI4O0QLzLTes5AeQuf1j/f1EnBVZ7s6wvHPS+ZG6DhI/+RmdzVyyp49o4gsG2ou4+AMOXZ/tvr3gBM8XljBvvUSt5vJoA4lFKgpNcwR1a2kqJYkjNxWKTX51VR3kttgs+R9RciZKzgdkKjnM9dh/bCLKA4dltLnA0ejMMmJeO05Juq22WSLK1CBbuKgnd1+Ls6Piu8loM+jRHkMhwKuxLGYPSuou6uLbIDIChCrdR5l1dfiH75ZsPUEdNyufEdKJe4czk5EKUXRqO8gbi0qZuF0clE3Qjn6PrcZurr9MQeAs3CjCJB8tttr9uaVmDchvu3lYdds9DFcmA9AVY9JBJKdZ2wIXoEnP/tN11F76haKUIuOw6xSgrLaF+dbiTkKz3e56sN0sv7sAKZwTUY+a+LDkCw==
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: ca683a6b-4afd-4190-8da1-08d88663eb64
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7251.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2020 17:04:58.3837
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mNnwRQQ8eVQPBeEsy2XgAh+OD6opa29D7px4We7ZrTQjykB9QSxgPB256EhH+8RLJS/tS46mMPb2vyBdlfaMDp96jygfx966yDyqdrc+jZ0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR05MB7524
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Auhagen <sven.auhagen@voleatech.de>

Increase the packet header padding to include double VLAN tagging.
This patch uses a macro for this.

Suggested-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
---
 drivers/net/ethernet/intel/igb/igb.h      | 5 +++++
 drivers/net/ethernet/intel/igb/igb_main.c | 7 +++----
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb.h b/drivers/net/ethernet/intel/igb/igb.h
index 0286d2fceee4..aaa954aae574 100644
--- a/drivers/net/ethernet/intel/igb/igb.h
+++ b/drivers/net/ethernet/intel/igb/igb.h
@@ -138,6 +138,8 @@ struct vf_mac_filter {
 /* this is the size past which hardware will drop packets when setting LPE=0 */
 #define MAXIMUM_ETHERNET_VLAN_SIZE 1522
 
+#define IGB_ETH_PKT_HDR_PAD	(ETH_HLEN + ETH_FCS_LEN + (VLAN_HLEN * 2))
+
 /* Supported Rx Buffer Sizes */
 #define IGB_RXBUFFER_256	256
 #define IGB_RXBUFFER_1536	1536
@@ -247,6 +249,9 @@ enum igb_tx_flags {
 #define IGB_SFF_ADDRESSING_MODE		0x4
 #define IGB_SFF_8472_UNSUP		0x00
 
+/* TX resources are shared between XDP and netstack
+ * and we need to tag the buffer type to distinguish them
+ */
 enum igb_tx_buf_type {
 	IGB_TYPE_SKB = 0,
 	IGB_TYPE_XDP,
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 08cc6f59aa2e..0a9198037b98 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -2826,7 +2826,7 @@ static int igb_setup_tc(struct net_device *dev, enum tc_setup_type type,
 
 static int igb_xdp_setup(struct net_device *dev, struct bpf_prog *prog)
 {
-	int i, frame_size = dev->mtu + ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN;
+	int i, frame_size = dev->mtu + IGB_ETH_PKT_HDR_PAD;
 	struct igb_adapter *adapter = netdev_priv(dev);
 	bool running = netif_running(dev);
 	struct bpf_prog *old_prog;
@@ -3950,8 +3950,7 @@ static int igb_sw_init(struct igb_adapter *adapter)
 	/* set default work limits */
 	adapter->tx_work_limit = IGB_DEFAULT_TX_WORK;
 
-	adapter->max_frame_size = netdev->mtu + ETH_HLEN + ETH_FCS_LEN +
-				  VLAN_HLEN;
+	adapter->max_frame_size = netdev->mtu + IGB_ETH_PKT_HDR_PAD;
 	adapter->min_frame_size = ETH_ZLEN + ETH_FCS_LEN;
 
 	spin_lock_init(&adapter->nfc_lock);
@@ -6491,7 +6490,7 @@ static void igb_get_stats64(struct net_device *netdev,
 static int igb_change_mtu(struct net_device *netdev, int new_mtu)
 {
 	struct igb_adapter *adapter = netdev_priv(netdev);
-	int max_frame = new_mtu + ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN;
+	int max_frame = new_mtu + IGB_ETH_PKT_HDR_PAD;
 
 	if (adapter->xdp_prog) {
 		int i;
-- 
2.20.1

