Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EDFE28620C
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 17:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728298AbgJGPZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 11:25:25 -0400
Received: from mail-eopbgr00116.outbound.protection.outlook.com ([40.107.0.116]:11397
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727717AbgJGPZX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 11:25:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W2xF+NSLilU9BLR3FuuAOvmJhBHdh/R6ttsuapEnAMXrJDQwUplt298LTh/X/jo4l6F2uiskdUjkXyZDLilBMkm3j2wQUcu0kRX4MmQRZyVKsM+jRNm80WPxpTh74xPUVxJ5VcuVODFlnV5ljDXbfUl2NEhhUu4U8zgIbEw2ZSba4FeV3WnzRqTJlxS0uS/TQN3kZwXfRp/wwfVbqUP5ZsPr6v6WaInstRF82AVqxRPOuV6mEo5to+SayhtnwlJh3VhFIkw4frfgYYwb1QtT8+gqmq08dgNudaf5vHGi9gY4Qcp8i7zC2/y8buAhCGyJPGK5c8OquMN0+yTqeUl/iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fVG1VvosppfYgEKtYYjKCLGbwLAM1yt2+vxeLFoSi3I=;
 b=iGVCeeSz17k4P1BVWi72YvY7RE9AvH74gHtiDf2Yx6KzPIXSn3rTGWPDbI8kX1nI0jkyAJpzY7B1MyPx0yqRRMTGatx/pCAb+pDvDgZkntrl9Lm8kbBf9TxwbWAdhml9JsY4kKB+Nn7EIjtnWSyCFxAKOYaup6jZYPBF1kuLs6e5a3WU6zL41Vxpg4klUvPY1UpT5O9IUPcOxd6TsTWe4CEEy+YRRIPC5XGgf17v85Os4Skx+Nvo3upCP3Nm/HtUfUaoVPHGgvLE3V4Ino25BEW+OYheimn+/DFhJc/RxkrYwu/INs7EH9GTgtKsexC10G9yPtgV/ohlN15be/Hd7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fVG1VvosppfYgEKtYYjKCLGbwLAM1yt2+vxeLFoSi3I=;
 b=Up556XNFclE40SO6NZHsa1ajWrsEIzKs0kfY2BptjEI+vdlDp7yHu/qXDbVzFJkJllrm/Ehz/pt7JRoDtJIgtpSvqBkJJL0BAbpWQmMrew9XPPJbQAim/lhruTaI/uV9YsLTO76arWZp8kkdDkhG2BqGRlH+pntYlHvd2kwCgAU=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=voleatech.de;
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com (2603:10a6:20b:1d4::23)
 by AM0PR05MB6082.eurprd05.prod.outlook.com (2603:10a6:208:125::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21; Wed, 7 Oct
 2020 15:25:16 +0000
Received: from AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4]) by AM8PR05MB7251.eurprd05.prod.outlook.com
 ([fe80::f132:2cc:34f2:5e4%7]) with mapi id 15.20.3433.045; Wed, 7 Oct 2020
 15:25:16 +0000
From:   sven.auhagen@voleatech.de
To:     anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com
Cc:     davem@davemloft.net, netdev@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, sandeep.penigalapati@intel.com,
        brouer@redhat.com
Subject: [PATCH 2/7] igb: take vlan double header into account
Date:   Wed,  7 Oct 2020 17:25:01 +0200
Message-Id: <20201007152506.66217-3-sven.auhagen@voleatech.de>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
In-Reply-To: <20201007152506.66217-1-sven.auhagen@voleatech.de>
References: <20201007152506.66217-1-sven.auhagen@voleatech.de>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [109.193.235.168]
X-ClientProxiedBy: AM0PR05CA0077.eurprd05.prod.outlook.com
 (2603:10a6:208:136::17) To AM8PR05MB7251.eurprd05.prod.outlook.com
 (2603:10a6:20b:1d4::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from svensmacbookair.sven.lan (109.193.235.168) by AM0PR05CA0077.eurprd05.prod.outlook.com (2603:10a6:208:136::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21 via Frontend Transport; Wed, 7 Oct 2020 15:25:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c1925426-b8d9-4367-c554-08d86ad53180
X-MS-TrafficTypeDiagnostic: AM0PR05MB6082:
X-Microsoft-Antispam-PRVS: <AM0PR05MB60829C85B32D3FBDB246E50CEF0A0@AM0PR05MB6082.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QW7HVDb+McRDImmx/MfxkYo3wBTn8P0BoWSOf7tEG0BaTB/XHwZfWrImsiEt9CRZwC1kIZRKjY7V5tCZnrr266Yoqiewt2RrygzSTk4W4vA87MFMTQwzu0oWlNiUtsdwIhA6OgYYt94RCBTMG8wDxCuftXgYWNJ7bh+im3NbAfnD4Fiw+6nzoVgwSqQ1z3DahkuwkjoPHPXE51x5l1jtcWVvo4Yz8BQo/P267B1TIkc/tmHJcyOQXHALRANySlis+A8+tEYmENL3HDnfYkSdRPne+wKpZqezArlBlFxQTVBOI21Wfpe2V57RWcvl0apnN4t85Qyk+3bTB5sUlf/r7g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR05MB7251.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39830400003)(136003)(366004)(346002)(376002)(186003)(66476007)(16526019)(2906002)(26005)(6486002)(5660300002)(9686003)(66946007)(6512007)(6506007)(83380400001)(6666004)(52116002)(66556008)(8936002)(36756003)(316002)(86362001)(8676002)(956004)(2616005)(1076003)(478600001)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: gEN/QoCMIj4l+J8yfQ824NaVEgjzK+wPHBkfsTxeOkrHxSQyRpgizeSOg0ozXz/8D2QOKZ4UUW4435Ej8Dc68+qviSkmnOvPra8xodHgOVE3RjvQQuOxa8QrJkdnVoHVIMVAll3JcfliXZOLhjTGAhhFaJDo6fMVRxZ/yEG6+t7Wr1xyw3nsHOpqjkWgvFjtDmNQy0QvrjBZ2fo6ueM+uvj6ol2SdOq1k/XRaHs3UDUMhbS65zxg7drHiUxPuibjwjdG+geBo81KFZSec39GCmhH32EbGPTqxiqjN3e2ZSjp02zo8Y4AVwq/H8Z+yABTo/oJEB+ZHzg/QkLeWZ33sKKxlzh+xyi+t2naWQcsno8vOLryr6d7XMFSHFLF7aR8gfdpI5hKKdyWae3ta4fN/BwL6a4w63yMtZ3ksPLDFmh31Wh9bT8eaGcqlzWalPrtoWICED4sO89lq+gu+peQUC4ZS3kZI7NlYp+fM1rtP2PMKx40kqMGRIYRJc6cIxTl9v7ifylg6gm3UymZklz02gsGKr3JEP0p+kbaaPyQPY8A4NJXVLzy0k4H5/7eU9d17+8vidc/U3e2WPWFf4elEyo9M7K2QmHnYdFqAHdVIhbwalNkaJ3Tt6wUCFIaaVZ4FzMWpihUnilJn9f3/MRe0w==
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: c1925426-b8d9-4367-c554-08d86ad53180
X-MS-Exchange-CrossTenant-AuthSource: AM8PR05MB7251.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Oct 2020 15:25:16.5629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: azyEOJOEyxdIPpbPCr/4Ywq02Q+bg7UOY0LEiO08tnVMG3jDYvSXASM8s2KbjyldflgjDiFhy7NOAdSaGaC1Y6KfUsi2n4tY3hTGSDnkGm0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6082
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sven Auhagen <sven.auhagen@voleatech.de>

Increase the packet header padding to include double VLAN tagging.
This patch uses a macro for this.

Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
---
 drivers/net/ethernet/intel/igb/igb.h      | 5 +++++
 drivers/net/ethernet/intel/igb/igb_main.c | 7 +++----
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb.h b/drivers/net/ethernet/intel/igb/igb.h
index 0286d2fceee4..7afb67cf9b94 100644
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
 
+/* TX ressources are shared between XDP and netstack
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

