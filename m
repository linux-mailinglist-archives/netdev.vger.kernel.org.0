Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE584561EC5
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 17:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235274AbiF3PH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 11:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235681AbiF3PH5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 11:07:57 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6034E27CD2
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 08:07:52 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id i67-20020a252246000000b0066c5c387c1bso15583181ybi.14
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 08:07:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=lhJlmzK0yPV9B2Itz3wiD6v75XpyvjhPVi3IyJospIw=;
        b=ZuNlqwTMmpIRLnSLFMGQy5lxhCLHCLv1NQm/ckp2+iISUYWssFXXL1AzXb6fjTTvch
         l/Nz7kMKYwwdEu33GPe6NpKo8nncuKr0+BmHnYRmAaB1nOcpSF5qIh4IdgQplcJK1aUi
         qniPjzRFtRa0bc9FiwGL9Y2hQD9ph3qIPBjWWJcPAnhtapeXDTUwm+J8HwfNmWa6jZkf
         edDM4+pRjkeCqGeorpJY5kylPE4eABFxEczPTC6nYZ2bJbv9JLyRI0FhvkNIeR6Qq7mc
         ID4GCURQ2sXyIFvHqdKz4DFiMi0l36b2qhNiauDB8P4j9kuRI4DWBq8qUeV0Ry5gxhqk
         QQoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=lhJlmzK0yPV9B2Itz3wiD6v75XpyvjhPVi3IyJospIw=;
        b=BEgOE+YQsG3eJdta4j1GOurc2mcNIrZPZJcniWf+iHWlHTanGC22vXax2FxemeYUrU
         Wgh58TlrU53FhP/xwQCA8gmZQNCtEPrpOhUdshN3EfOBOQEDGgGjRvh+XSinWZNZqynz
         R+5treatRTOVQ2rQdukqBjfDT2CEZzm2f/PcrIBtHVbNz7UCIM0RKyAts/wSnDh2fWlp
         UJwLy/Ks6bmQBVVHkELeY/QB0qpXR5x0AQifTNvNxQaI9PO/relndBfubFitBvEs/kk8
         /EoFzQqTjxwpMZJn14PP8tbrcl3GtU7cwrxGmUWlK2yK+buRm/DwOpENnpytUYC3rY6Z
         EpTA==
X-Gm-Message-State: AJIora+07K5vdmA/9qYz9RJ7pVX1ADc2dzhR7BeuoG3SsWtxCcHv6ZU6
        Sezne71DIMdeeoNs2T0ht1P2JRMzXpwjVw==
X-Google-Smtp-Source: AGRyM1tX+m3fUhsLf90h8E3FYZC/mbl1Dt8o612N0sN41pRf9GBmWbY5IcBNxjDwUj8neVLdc+QdzH98QabVWQ==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:690c:31e:b0:2ff:bfd6:c8b2 with SMTP
 id bg30-20020a05690c031e00b002ffbfd6c8b2mr11118180ywb.24.1656601671698; Thu,
 30 Jun 2022 08:07:51 -0700 (PDT)
Date:   Thu, 30 Jun 2022 15:07:50 +0000
Message-Id: <20220630150750.3247281-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH net-next] net: add skb_[inner_]tcp_all_headers helpers
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most drivers use "skb_transport_offset(skb) + tcp_hdrlen(skb)"
to compute headers length for a TCP packet, but others
use more convoluted (but equivalent) ways.

Add skb_tcp_all_headers() and skb_inner_tcp_all_headers()
helpers to harmonize this a bit.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 drivers/infiniband/ulp/ipoib/ipoib_ib.c       |  2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c      |  6 ++--
 .../net/ethernet/atheros/atl1c/atl1c_main.c   |  9 +++---
 .../net/ethernet/atheros/atl1e/atl1e_main.c   |  8 ++---
 drivers/net/ethernet/atheros/atlx/atl1.c      |  7 ++---
 .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.c   | 17 ++++-------
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  7 ++---
 drivers/net/ethernet/broadcom/tg3.c           |  2 +-
 drivers/net/ethernet/brocade/bna/bnad.c       |  6 ++--
 drivers/net/ethernet/cadence/macb_main.c      |  2 +-
 .../ethernet/cavium/thunder/nicvf_queues.c    |  4 +--
 drivers/net/ethernet/chelsio/cxgb4/sge.c      |  2 +-
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c |  6 ++--
 drivers/net/ethernet/cisco/enic/enic_main.c   |  5 ++--
 drivers/net/ethernet/emulex/benet/be_main.c   |  6 ++--
 drivers/net/ethernet/freescale/fec_main.c     |  2 +-
 .../net/ethernet/fungible/funeth/funeth_tx.c  |  2 +-
 drivers/net/ethernet/google/gve/gve_tx_dqo.c  |  4 +--
 drivers/net/ethernet/hisilicon/hns/hns_enet.c |  6 ++--
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  4 +--
 .../net/ethernet/hisilicon/hns3/hns3_trace.h  |  3 +-
 drivers/net/ethernet/ibm/ehea/ehea_main.c     |  2 +-
 drivers/net/ethernet/intel/e1000/e1000_main.c |  4 +--
 drivers/net/ethernet/intel/e1000e/netdev.c    |  4 +--
 drivers/net/ethernet/intel/ixgb/ixgb_main.c   |  2 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c    |  2 +-
 drivers/net/ethernet/marvell/mvneta.c         |  4 +--
 .../marvell/octeontx2/nic/otx2_txrx.c         |  4 +--
 drivers/net/ethernet/marvell/sky2.c           |  2 +-
 drivers/net/ethernet/mellanox/mlx4/en_tx.c    |  4 +--
 .../mellanox/mlx5/core/en_accel/ktls_tx.c     |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   |  4 +--
 .../net/ethernet/myricom/myri10ge/myri10ge.c  |  2 +-
 drivers/net/ethernet/netronome/nfp/nfd3/dp.c  |  5 ++--
 drivers/net/ethernet/netronome/nfp/nfdk/dp.c  |  5 ++--
 .../ethernet/netronome/nfp/nfp_net_common.c   |  7 ++---
 .../net/ethernet/pensando/ionic/ionic_txrx.c  |  5 ++--
 .../ethernet/qlogic/netxen/netxen_nic_main.c  |  2 +-
 drivers/net/ethernet/qlogic/qede/qede_fp.c    |  8 ++---
 .../net/ethernet/qlogic/qlcnic/qlcnic_io.c    |  2 +-
 drivers/net/ethernet/qualcomm/emac/emac-mac.c |  4 +--
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  2 +-
 .../net/ethernet/synopsys/dwc-xlgmac-net.c    |  2 +-
 drivers/net/wireless/ath/wil6210/txrx.c       |  4 +--
 drivers/net/xen-netback/netback.c             |  4 +--
 drivers/staging/qlge/qlge_main.c              |  2 +-
 include/linux/tcp.h                           | 30 +++++++++++++++++++
 net/tls/tls_device_fallback.c                 |  6 ++--
 48 files changed, 119 insertions(+), 115 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_ib.c b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
index 2c3dca41d3bd9f22872a619ba69d503e7d4c0b9d..f7995519bbc893ee91a361f2895d14bfb2a719e3 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_ib.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_ib.c
@@ -573,7 +573,7 @@ int ipoib_send(struct net_device *dev, struct sk_buff *skb,
 	unsigned int usable_sge = priv->max_send_sge - !!skb_headlen(skb);
 
 	if (skb_is_gso(skb)) {
-		hlen = skb_transport_offset(skb) + tcp_hdrlen(skb);
+		hlen = skb_tcp_all_headers(skb);
 		phead = skb->data;
 		if (unlikely(!skb_pull(skb, hlen))) {
 			ipoib_warn(priv, "linear data too small\n");
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index 4d46780fad1316b70683be94e59c7419802fd074..f342bb85318917689d3c1909cdeaf8486602a0fe 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -1673,12 +1673,10 @@ static int xgbe_prep_tso(struct sk_buff *skb, struct xgbe_packet_data *packet)
 		return ret;
 
 	if (XGMAC_GET_BITS(packet->attributes, TX_PACKET_ATTRIBUTES, VXLAN)) {
-		packet->header_len = skb_inner_transport_offset(skb) +
-				     inner_tcp_hdrlen(skb);
+		packet->header_len = skb_inner_tcp_all_headers(skb);
 		packet->tcp_header_len = inner_tcp_hdrlen(skb);
 	} else {
-		packet->header_len = skb_transport_offset(skb) +
-				     tcp_hdrlen(skb);
+		packet->header_len = skb_tcp_all_headers(skb);
 		packet->tcp_header_len = tcp_hdrlen(skb);
 	}
 	packet->tcp_payload_len = skb->len - packet->header_len;
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 24fe967c18cdfd8d534089ac354df9c475d5444e..948584761e66ac627fa8ec898c4765ee0df64c7b 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -2072,7 +2072,7 @@ static u16 atl1c_cal_tpd_req(const struct sk_buff *skb)
 	tpd_req = skb_shinfo(skb)->nr_frags + 1;
 
 	if (skb_is_gso(skb)) {
-		proto_hdr_len = skb_transport_offset(skb) + tcp_hdrlen(skb);
+		proto_hdr_len = skb_tcp_all_headers(skb);
 		if (proto_hdr_len < skb_headlen(skb))
 			tpd_req++;
 		if (skb_shinfo(skb)->gso_type & SKB_GSO_TCPV6)
@@ -2107,7 +2107,7 @@ static int atl1c_tso_csum(struct atl1c_adapter *adapter,
 			if (real_len < skb->len)
 				pskb_trim(skb, real_len);
 
-			hdr_len = (skb_transport_offset(skb) + tcp_hdrlen(skb));
+			hdr_len = skb_tcp_all_headers(skb);
 			if (unlikely(skb->len == hdr_len)) {
 				/* only xsum need */
 				if (netif_msg_tx_queued(adapter))
@@ -2132,7 +2132,7 @@ static int atl1c_tso_csum(struct atl1c_adapter *adapter,
 			*tpd = atl1c_get_tpd(adapter, queue);
 			ipv6_hdr(skb)->payload_len = 0;
 			/* check payload == 0 byte ? */
-			hdr_len = (skb_transport_offset(skb) + tcp_hdrlen(skb));
+			hdr_len = skb_tcp_all_headers(skb);
 			if (unlikely(skb->len == hdr_len)) {
 				/* only xsum need */
 				if (netif_msg_tx_queued(adapter))
@@ -2219,7 +2219,8 @@ static int atl1c_tx_map(struct atl1c_adapter *adapter,
 	tso = (tpd->word1 >> TPD_LSO_EN_SHIFT) & TPD_LSO_EN_MASK;
 	if (tso) {
 		/* TSO */
-		map_len = hdr_len = skb_transport_offset(skb) + tcp_hdrlen(skb);
+		hdr_len = skb_tcp_all_headers(skb);
+		map_len = hdr_len;
 		use_tpd = tpd;
 
 		buffer_info = atl1c_get_tx_buffer(adapter, use_tpd);
diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
index 20681860a599e3f022904ae524e60ad05d058384..e013cff73de7c5c704b5ffacdc4c74f279d59f0f 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
@@ -1609,8 +1609,7 @@ static u16 atl1e_cal_tdp_req(const struct sk_buff *skb)
 	if (skb_is_gso(skb)) {
 		if (skb->protocol == htons(ETH_P_IP) ||
 		   (skb_shinfo(skb)->gso_type == SKB_GSO_TCPV6)) {
-			proto_hdr_len = skb_transport_offset(skb) +
-					tcp_hdrlen(skb);
+			proto_hdr_len = skb_tcp_all_headers(skb);
 			if (proto_hdr_len < skb_headlen(skb)) {
 				tpd_req += ((skb_headlen(skb) - proto_hdr_len +
 					   MAX_TX_BUF_LEN - 1) >>
@@ -1645,7 +1644,7 @@ static int atl1e_tso_csum(struct atl1e_adapter *adapter,
 			if (real_len < skb->len)
 				pskb_trim(skb, real_len);
 
-			hdr_len = (skb_transport_offset(skb) + tcp_hdrlen(skb));
+			hdr_len = skb_tcp_all_headers(skb);
 			if (unlikely(skb->len == hdr_len)) {
 				/* only xsum need */
 				netdev_warn(adapter->netdev,
@@ -1713,7 +1712,8 @@ static int atl1e_tx_map(struct atl1e_adapter *adapter,
 	segment = (tpd->word3 >> TPD_SEGMENT_EN_SHIFT) & TPD_SEGMENT_EN_MASK;
 	if (segment) {
 		/* TSO */
-		map_len = hdr_len = skb_transport_offset(skb) + tcp_hdrlen(skb);
+		hdr_len = skb_tcp_all_headers(skb);
+		map_len = hdr_len;
 		use_tpd = tpd;
 
 		tx_buffer = atl1e_get_tx_buffer(adapter, use_tpd);
diff --git a/drivers/net/ethernet/atheros/atlx/atl1.c b/drivers/net/ethernet/atheros/atlx/atl1.c
index 6a969969d221b46d552c23e015f03aa622eeb289..ff1fe09abf9f5659366f4f5816fb782e642dee95 100644
--- a/drivers/net/ethernet/atheros/atlx/atl1.c
+++ b/drivers/net/ethernet/atheros/atlx/atl1.c
@@ -2115,7 +2115,7 @@ static int atl1_tso(struct atl1_adapter *adapter, struct sk_buff *skb,
 				ntohs(iph->tot_len));
 			if (real_len < skb->len)
 				pskb_trim(skb, real_len);
-			hdr_len = (skb_transport_offset(skb) + tcp_hdrlen(skb));
+			hdr_len = skb_tcp_all_headers(skb);
 			if (skb->len == hdr_len) {
 				iph->check = 0;
 				tcp_hdr(skb)->check =
@@ -2206,7 +2206,7 @@ static void atl1_tx_map(struct atl1_adapter *adapter, struct sk_buff *skb,
 	retval = (ptpd->word3 >> TPD_SEGMENT_EN_SHIFT) & TPD_SEGMENT_EN_MASK;
 	if (retval) {
 		/* TSO */
-		hdr_len = skb_transport_offset(skb) + tcp_hdrlen(skb);
+		hdr_len = skb_tcp_all_headers(skb);
 		buffer_info->length = hdr_len;
 		page = virt_to_page(skb->data);
 		offset = offset_in_page(skb->data);
@@ -2367,8 +2367,7 @@ static netdev_tx_t atl1_xmit_frame(struct sk_buff *skb,
 	mss = skb_shinfo(skb)->gso_size;
 	if (mss) {
 		if (skb->protocol == htons(ETH_P_IP)) {
-			proto_hdr_len = (skb_transport_offset(skb) +
-					 tcp_hdrlen(skb));
+			proto_hdr_len = skb_tcp_all_headers(skb);
 			if (unlikely(proto_hdr_len > len)) {
 				dev_kfree_skb_any(skb);
 				return NETDEV_TX_OK;
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index 5729a5ab059d7cbc1b2314f23577708fb9bf964e..712b5595bc39385210aac42a9a34b16fa70ce35b 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -3421,12 +3421,9 @@ static int bnx2x_pkt_req_lin(struct bnx2x *bp, struct sk_buff *skb,
 
 			/* Headers length */
 			if (xmit_type & XMIT_GSO_ENC)
-				hlen = (int)(skb_inner_transport_header(skb) -
-					     skb->data) +
-					     inner_tcp_hdrlen(skb);
+				hlen = skb_inner_tcp_all_headers(skb);
 			else
-				hlen = (int)(skb_transport_header(skb) -
-					     skb->data) + tcp_hdrlen(skb);
+				hlen = skb_tcp_all_headers(skb);
 
 			/* Amount of data (w/o headers) on linear part of SKB*/
 			first_bd_sz = skb_headlen(skb) - hlen;
@@ -3534,15 +3531,13 @@ static u8 bnx2x_set_pbd_csum_enc(struct bnx2x *bp, struct sk_buff *skb,
 			ETH_TX_PARSE_BD_E2_TCP_HDR_LENGTH_DW_SHIFT) &
 			ETH_TX_PARSE_BD_E2_TCP_HDR_LENGTH_DW;
 
-		return skb_inner_transport_header(skb) +
-			inner_tcp_hdrlen(skb) - skb->data;
+		return skb_inner_tcp_all_headers(skb);
 	}
 
 	/* We support checksum offload for TCP and UDP only.
 	 * No need to pass the UDP header length - it's a constant.
 	 */
-	return skb_inner_transport_header(skb) +
-		sizeof(struct udphdr) - skb->data;
+	return skb_inner_transport_offset(skb) + sizeof(struct udphdr);
 }
 
 /**
@@ -3568,12 +3563,12 @@ static u8 bnx2x_set_pbd_csum_e2(struct bnx2x *bp, struct sk_buff *skb,
 			ETH_TX_PARSE_BD_E2_TCP_HDR_LENGTH_DW_SHIFT) &
 			ETH_TX_PARSE_BD_E2_TCP_HDR_LENGTH_DW;
 
-		return skb_transport_header(skb) + tcp_hdrlen(skb) - skb->data;
+		return skb_tcp_all_headers(skb);
 	}
 	/* We support checksum offload for TCP and UDP only.
 	 * No need to pass the UDP header length - it's a constant.
 	 */
-	return skb_transport_header(skb) + sizeof(struct udphdr) - skb->data;
+	return skb_transport_offset(skb) + sizeof(struct udphdr);
 }
 
 /* set FW indication according to inner or outer protocols if tunneled */
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index b474a4fe4039dd2a20933ed7b1fefcc9ef829865..11d35da619217b9f6929e508a346fed74faa5b6a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -535,12 +535,9 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		u32 hdr_len;
 
 		if (skb->encapsulation)
-			hdr_len = skb_inner_network_offset(skb) +
-				skb_inner_network_header_len(skb) +
-				inner_tcp_hdrlen(skb);
+			hdr_len = skb_inner_tcp_all_headers(skb);
 		else
-			hdr_len = skb_transport_offset(skb) +
-				tcp_hdrlen(skb);
+			hdr_len = skb_tcp_all_headers(skb);
 
 		txbd1->tx_bd_hsize_lflags |= cpu_to_le32(TX_BD_FLAGS_LSO |
 					TX_BD_FLAGS_T_IPID |
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index c28f8cc00d1cf102aee2291fb824cda5c8fd7f79..db1e9d810b4160aff3c3b3fb22938f7d10ea6763 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -7944,7 +7944,7 @@ static netdev_tx_t tg3_start_xmit(struct sk_buff *skb, struct net_device *dev)
 		iph = ip_hdr(skb);
 		tcp_opt_len = tcp_optlen(skb);
 
-		hdr_len = skb_transport_offset(skb) + tcp_hdrlen(skb) - ETH_HLEN;
+		hdr_len = skb_tcp_all_headers(skb) - ETH_HLEN;
 
 		/* HW/FW can not correctly segment packets that have been
 		 * vlan encapsulated.
diff --git a/drivers/net/ethernet/brocade/bna/bnad.c b/drivers/net/ethernet/brocade/bna/bnad.c
index f6fe08df568b2732e164181b80f0e04b950ffdf3..29dd0f93d6c03c5cf16331d35b594680fec56882 100644
--- a/drivers/net/ethernet/brocade/bna/bnad.c
+++ b/drivers/net/ethernet/brocade/bna/bnad.c
@@ -2823,8 +2823,7 @@ bnad_txq_wi_prepare(struct bnad *bnad, struct bna_tcb *tcb,
 			BNAD_UPDATE_CTR(bnad, tx_skb_mss_too_long);
 			return -EINVAL;
 		}
-		if (unlikely((gso_size + skb_transport_offset(skb) +
-			      tcp_hdrlen(skb)) >= skb->len)) {
+		if (unlikely((gso_size + skb_tcp_all_headers(skb)) >= skb->len)) {
 			txqent->hdr.wi.opcode = htons(BNA_TXQ_WI_SEND);
 			txqent->hdr.wi.lso_mss = 0;
 			BNAD_UPDATE_CTR(bnad, tx_skb_tso_too_short);
@@ -2872,8 +2871,7 @@ bnad_txq_wi_prepare(struct bnad *bnad, struct bna_tcb *tcb,
 				BNAD_UPDATE_CTR(bnad, tcpcsum_offload);
 
 				if (unlikely(skb_headlen(skb) <
-					    skb_transport_offset(skb) +
-				    tcp_hdrlen(skb))) {
+					    skb_tcp_all_headers(skb))) {
 					BNAD_UPDATE_CTR(bnad, tx_skb_tcp_hdr);
 					return -EINVAL;
 				}
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index d0ea8dbfa213dea880f292cfdc67916a9e4163bb..90a9798424af75cc2317ec5a33aee295219c523e 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -2267,7 +2267,7 @@ static netdev_tx_t macb_start_xmit(struct sk_buff *skb, struct net_device *dev)
 			/* only queue eth + ip headers separately for UDP */
 			hdrlen = skb_transport_offset(skb);
 		else
-			hdrlen = skb_transport_offset(skb) + tcp_hdrlen(skb);
+			hdrlen = skb_tcp_all_headers(skb);
 		if (skb_headlen(skb) < hdrlen) {
 			netdev_err(bp->dev, "Error - LSO headers fragmented!!!\n");
 			/* if this is required, would need to copy to single buffer */
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_queues.c b/drivers/net/ethernet/cavium/thunder/nicvf_queues.c
index 4367edbdd579713d5760323167c48bf14eabcb1e..06397cc8bb36ac7e9ed964f7578fd90566f951a0 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_queues.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_queues.c
@@ -1261,7 +1261,7 @@ int nicvf_xdp_sq_append_pkt(struct nicvf *nic, struct snd_queue *sq,
 static int nicvf_tso_count_subdescs(struct sk_buff *skb)
 {
 	struct skb_shared_info *sh = skb_shinfo(skb);
-	unsigned int sh_len = skb_transport_offset(skb) + tcp_hdrlen(skb);
+	unsigned int sh_len = skb_tcp_all_headers(skb);
 	unsigned int data_len = skb->len - sh_len;
 	unsigned int p_len = sh->gso_size;
 	long f_id = -1;    /* id of the current fragment */
@@ -1382,7 +1382,7 @@ nicvf_sq_add_hdr_subdesc(struct nicvf *nic, struct snd_queue *sq, int qentry,
 
 	if (nic->hw_tso && skb_shinfo(skb)->gso_size) {
 		hdr->tso = 1;
-		hdr->tso_start = skb_transport_offset(skb) + tcp_hdrlen(skb);
+		hdr->tso_start = skb_tcp_all_headers(skb);
 		hdr->tso_max_paysize = skb_shinfo(skb)->gso_size;
 		/* For non-tunneled pkts, point this to L2 ethertype */
 		hdr->inner_l3_offset = skb_network_offset(skb) - 2;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index f889f404305ca5800c1438404ed1db4d14fda021..ee52e3b1d74f73423274061c530b6ea79370d425 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -1531,7 +1531,7 @@ static netdev_tx_t cxgb4_eth_xmit(struct sk_buff *skb, struct net_device *dev)
 
 #if IS_ENABLED(CONFIG_CHELSIO_TLS_DEVICE)
 	if (cxgb4_is_ktls_skb(skb) &&
-	    (skb->len - (skb_transport_offset(skb) + tcp_hdrlen(skb))))
+	    (skb->len - skb_tcp_all_headers(skb)))
 		return adap->uld[CXGB4_ULD_KTLS].tx_handler(skb, dev);
 #endif /* CHELSIO_TLS_DEVICE */
 
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
index 60b648b46f75c40979ec3210374410b61c22ed63..bfee0e4e54b1d9b5547a1694aab4a0e529bcfb8c 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
@@ -1012,7 +1012,7 @@ chcr_ktls_write_tcp_options(struct chcr_ktls_info *tx_info, struct sk_buff *skb,
 	/* packet length = eth hdr len + ip hdr len + tcp hdr len
 	 * (including options).
 	 */
-	pktlen = skb_transport_offset(skb) + tcp_hdrlen(skb);
+	pktlen = skb_tcp_all_headers(skb);
 
 	ctrl = sizeof(*cpl) + pktlen;
 	len16 = DIV_ROUND_UP(sizeof(*wr) + ctrl, 16);
@@ -1907,7 +1907,7 @@ static int chcr_ktls_sw_fallback(struct sk_buff *skb,
 		return 0;
 
 	th = tcp_hdr(nskb);
-	skb_offset =  skb_transport_offset(nskb) + tcp_hdrlen(nskb);
+	skb_offset = skb_tcp_all_headers(nskb);
 	data_len = nskb->len - skb_offset;
 	skb_tx_timestamp(nskb);
 
@@ -1938,7 +1938,7 @@ static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)
 	unsigned long flags;
 
 	tcp_seq = ntohl(th->seq);
-	skb_offset = skb_transport_offset(skb) + tcp_hdrlen(skb);
+	skb_offset = skb_tcp_all_headers(skb);
 	skb_data_len = skb->len - skb_offset;
 	data_len = skb_data_len;
 
diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethernet/cisco/enic/enic_main.c
index 1c81b161de52b14fd6961633ccb1b1f99ef6f2f6..372fb7b3a2825a50fe468e2699a0225e2945c773 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -680,11 +680,10 @@ static int enic_queue_wq_skb_tso(struct enic *enic, struct vnic_wq *wq,
 	skb_frag_t *frag;
 
 	if (skb->encapsulation) {
-		hdr_len = skb_inner_transport_header(skb) - skb->data;
-		hdr_len += inner_tcp_hdrlen(skb);
+		hdr_len = skb_inner_tcp_all_headers(skb);
 		enic_preload_tcp_csum_encap(skb);
 	} else {
-		hdr_len = skb_transport_offset(skb) + tcp_hdrlen(skb);
+		hdr_len = skb_tcp_all_headers(skb);
 		enic_preload_tcp_csum(skb);
 	}
 
diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index cd4e243da5fa766ffa50ea3a39b755e4643e278c..bf452bb62e892905d484c20241e856941ba7d79f 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -737,9 +737,9 @@ void be_link_status_update(struct be_adapter *adapter, u8 link_status)
 static int be_gso_hdr_len(struct sk_buff *skb)
 {
 	if (skb->encapsulation)
-		return skb_inner_transport_offset(skb) +
-		       inner_tcp_hdrlen(skb);
-	return skb_transport_offset(skb) + tcp_hdrlen(skb);
+		return skb_inner_tcp_all_headers(skb);
+
+	return skb_tcp_all_headers(skb);
 }
 
 static void be_tx_stats_update(struct be_tx_obj *txo, struct sk_buff *skb)
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index a90275143d873b857db63ec1941b267bdd18603e..e8e2aa1e7f01b783f6e48564fd1c34b698375ef6 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -691,7 +691,7 @@ fec_enet_txq_put_hdr_tso(struct fec_enet_priv_tx_q *txq,
 			 struct bufdesc *bdp, int index)
 {
 	struct fec_enet_private *fep = netdev_priv(ndev);
-	int hdr_len = skb_transport_offset(skb) + tcp_hdrlen(skb);
+	int hdr_len = skb_tcp_all_headers(skb);
 	struct bufdesc_ex *ebdp = container_of(bdp, struct bufdesc_ex, desc);
 	void *bufaddr;
 	unsigned long dmabuf;
diff --git a/drivers/net/ethernet/fungible/funeth/funeth_tx.c b/drivers/net/ethernet/fungible/funeth/funeth_tx.c
index 0a4a590218ba9e4b83d81f8cfd4be5ede290c1a2..a97e3af00cb99e83f0e69e69c8ffca75d5f0a1fb 100644
--- a/drivers/net/ethernet/fungible/funeth/funeth_tx.c
+++ b/drivers/net/ethernet/fungible/funeth/funeth_tx.c
@@ -83,7 +83,7 @@ static struct sk_buff *fun_tls_tx(struct sk_buff *skb, struct funeth_txq *q,
 	const struct fun_ktls_tx_ctx *tls_ctx;
 	u32 datalen, seq;
 
-	datalen = skb->len - (skb_transport_offset(skb) + tcp_hdrlen(skb));
+	datalen = skb->len - skb_tcp_all_headers(skb);
 	if (!datalen)
 		return skb;
 
diff --git a/drivers/net/ethernet/google/gve/gve_tx_dqo.c b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
index ec394d9916681ad230d42e99707ed09dc05d6154..bbf8bec56189fd874fcbb239104f9a6c64f4eb41 100644
--- a/drivers/net/ethernet/google/gve/gve_tx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
@@ -386,7 +386,7 @@ static int gve_prep_tso(struct sk_buff *skb)
 				     (__force __wsum)htonl(paylen));
 
 		/* Compute length of segmentation header. */
-		header_len = skb_transport_offset(skb) + tcp_hdrlen(skb);
+		header_len = skb_tcp_all_headers(skb);
 		break;
 	default:
 		return -EINVAL;
@@ -598,9 +598,9 @@ static int gve_num_buffer_descs_needed(const struct sk_buff *skb)
  */
 static bool gve_can_send_tso(const struct sk_buff *skb)
 {
-	const int header_len = skb_checksum_start_offset(skb) + tcp_hdrlen(skb);
 	const int max_bufs_per_seg = GVE_TX_MAX_DATA_DESCS - 1;
 	const struct skb_shared_info *shinfo = skb_shinfo(skb);
+	const int header_len = skb_tcp_all_headers(skb);
 	const int gso_size = shinfo->gso_size;
 	int cur_seg_num_bufs;
 	int cur_seg_size;
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_enet.c b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
index 2f0bd21a90820c6daca6b9015b939e5bc2e2df89..d94cc8c6681f7291e9e6bbdc519c25f8eb1516a9 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -31,8 +31,6 @@
 #define HNS_BUFFER_SIZE_2048 2048
 
 #define BD_MAX_SEND_SIZE 8191
-#define SKB_TMP_LEN(SKB) \
-	(((SKB)->transport_header - (SKB)->mac_header) + tcp_hdrlen(SKB))
 
 static void fill_v2_desc_hw(struct hnae_ring *ring, void *priv, int size,
 			    int send_sz, dma_addr_t dma, int frag_end,
@@ -94,7 +92,7 @@ static void fill_v2_desc_hw(struct hnae_ring *ring, void *priv, int size,
 						     HNSV2_TXD_TSE_B, 1);
 					l4_len = tcp_hdrlen(skb);
 					mss = skb_shinfo(skb)->gso_size;
-					paylen = skb->len - SKB_TMP_LEN(skb);
+					paylen = skb->len - skb_tcp_all_headers(skb);
 				}
 			} else if (skb->protocol == htons(ETH_P_IPV6)) {
 				hnae_set_bit(tvsvsn, HNSV2_TXD_IPV6_B, 1);
@@ -108,7 +106,7 @@ static void fill_v2_desc_hw(struct hnae_ring *ring, void *priv, int size,
 						     HNSV2_TXD_TSE_B, 1);
 					l4_len = tcp_hdrlen(skb);
 					mss = skb_shinfo(skb)->gso_size;
-					paylen = skb->len - SKB_TMP_LEN(skb);
+					paylen = skb->len - skb_tcp_all_headers(skb);
 				}
 			}
 			desc->tx.ip_offset = ip_offset;
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index ae56306400b838e9daeb2c1e5d554d7dc1df846a..35d70041b9e8403f7348a2d7abf878c326f67d2c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1838,9 +1838,9 @@ static unsigned int hns3_tx_bd_num(struct sk_buff *skb, unsigned int *bd_size,
 static unsigned int hns3_gso_hdr_len(struct sk_buff *skb)
 {
 	if (!skb->encapsulation)
-		return skb_transport_offset(skb) + tcp_hdrlen(skb);
+		return skb_tcp_all_headers(skb);
 
-	return skb_inner_transport_offset(skb) + inner_tcp_hdrlen(skb);
+	return skb_inner_tcp_all_headers(skb);
 }
 
 /* HW need every continuous max_non_tso_bd_num buffer data to be larger
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_trace.h b/drivers/net/ethernet/hisilicon/hns3/hns3_trace.h
index 5153e5d41bbd62b0dc513c5ae4720b632404a817..b8a1ecb4b8fbe844e6d09e983df03df99d2c42cf 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_trace.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_trace.h
@@ -37,8 +37,7 @@ DECLARE_EVENT_CLASS(hns3_skb_template,
 		__entry->gso_segs = skb_shinfo(skb)->gso_segs;
 		__entry->gso_type = skb_shinfo(skb)->gso_type;
 		__entry->hdr_len = skb->encapsulation ?
-		skb_inner_transport_offset(skb) + inner_tcp_hdrlen(skb) :
-		skb_transport_offset(skb) + tcp_hdrlen(skb);
+		skb_inner_tcp_all_headers(skb) : skb_tcp_all_headers(skb);
 		__entry->ip_summed = skb->ip_summed;
 		__entry->fraglist = skb_has_frag_list(skb);
 		hns3_shinfo_pack(skb_shinfo(skb), __entry->size);
diff --git a/drivers/net/ethernet/ibm/ehea/ehea_main.c b/drivers/net/ethernet/ibm/ehea/ehea_main.c
index 8ce3348edf089f19e49abffc7740f57eaadd006a..5dc302880f5f621d8906748191bcd6341c0e3aa1 100644
--- a/drivers/net/ethernet/ibm/ehea/ehea_main.c
+++ b/drivers/net/ethernet/ibm/ehea/ehea_main.c
@@ -1617,7 +1617,7 @@ static void write_swqe2_immediate(struct sk_buff *skb, struct ehea_swqe *swqe,
 		 * For TSO packets we only copy the headers into the
 		 * immediate area.
 		 */
-		immediate_len = ETH_HLEN + ip_hdrlen(skb) + tcp_hdrlen(skb);
+		immediate_len = skb_tcp_all_headers(skb);
 	}
 
 	if (skb_is_gso(skb) || skb_data_size >= SWQE2_MAX_IMM) {
diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index 3f5feb55cfbaae03ffb233b7e1341e426d1b7f08..23299fc561999ad435863d5d19f1fffbfb56635b 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -2708,7 +2708,7 @@ static int e1000_tso(struct e1000_adapter *adapter,
 		if (err < 0)
 			return err;
 
-		hdr_len = skb_transport_offset(skb) + tcp_hdrlen(skb);
+		hdr_len = skb_tcp_all_headers(skb);
 		mss = skb_shinfo(skb)->gso_size;
 		if (protocol == htons(ETH_P_IP)) {
 			struct iphdr *iph = ip_hdr(skb);
@@ -3139,7 +3139,7 @@ static netdev_tx_t e1000_xmit_frame(struct sk_buff *skb,
 		max_per_txd = min(mss << 2, max_per_txd);
 		max_txd_pwr = fls(max_per_txd) - 1;
 
-		hdr_len = skb_transport_offset(skb) + tcp_hdrlen(skb);
+		hdr_len = skb_tcp_all_headers(skb);
 		if (skb->data_len && hdr_len == len) {
 			switch (hw->mac_type) {
 			case e1000_82544: {
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index fa06f68c8c8038c5355ff605f3854703259a739b..38e60def852070f39fc22bb1885157e016ecbea6 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -5474,7 +5474,7 @@ static int e1000_tso(struct e1000_ring *tx_ring, struct sk_buff *skb,
 	if (err < 0)
 		return err;
 
-	hdr_len = skb_transport_offset(skb) + tcp_hdrlen(skb);
+	hdr_len = skb_tcp_all_headers(skb);
 	mss = skb_shinfo(skb)->gso_size;
 	if (protocol == htons(ETH_P_IP)) {
 		struct iphdr *iph = ip_hdr(skb);
@@ -5846,7 +5846,7 @@ static netdev_tx_t e1000_xmit_frame(struct sk_buff *skb,
 		 * points to just header, pull a few bytes of payload from
 		 * frags into skb->data
 		 */
-		hdr_len = skb_transport_offset(skb) + tcp_hdrlen(skb);
+		hdr_len = skb_tcp_all_headers(skb);
 		/* we do this workaround for ES2LAN, but it is un-necessary,
 		 * avoiding it could save a lot of cycles
 		 */
diff --git a/drivers/net/ethernet/intel/ixgb/ixgb_main.c b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
index affdefcca7e307417cb4be1848225adfa887dbb9..fbe148669c80dd96504d22f44bc34bad70931261 100644
--- a/drivers/net/ethernet/intel/ixgb/ixgb_main.c
+++ b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
@@ -1187,7 +1187,7 @@ ixgb_tso(struct ixgb_adapter *adapter, struct sk_buff *skb)
 		if (err < 0)
 			return err;
 
-		hdr_len = skb_transport_offset(skb) + tcp_hdrlen(skb);
+		hdr_len = skb_tcp_all_headers(skb);
 		mss = skb_shinfo(skb)->gso_size;
 		iph = ip_hdr(skb);
 		iph->tot_len = 0;
diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index 57eff4e9e6de5f9cdfb46718597a53ddbd89dcdd..b6be0552a6c1d18247ab998f52b13fbc6f717e08 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -775,7 +775,7 @@ txq_put_hdr_tso(struct sk_buff *skb, struct tx_queue *txq, int length,
 		u32 *first_cmd_sts, bool first_desc)
 {
 	struct mv643xx_eth_private *mp = txq_to_mp(txq);
-	int hdr_len = skb_transport_offset(skb) + tcp_hdrlen(skb);
+	int hdr_len = skb_tcp_all_headers(skb);
 	int tx_index;
 	struct tx_desc *desc;
 	int ret;
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 384f5a16753d275a732354e1d9fffdf1e64b7e81..0caa2df87c044f5fefa8e6d11ce9b1cbf1a7f36d 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2664,8 +2664,8 @@ static int mvneta_rx_hwbm(struct napi_struct *napi,
 static inline void
 mvneta_tso_put_hdr(struct sk_buff *skb, struct mvneta_tx_queue *txq)
 {
-	int hdr_len = skb_transport_offset(skb) + tcp_hdrlen(skb);
 	struct mvneta_tx_buf *buf = &txq->buf[txq->txq_put_index];
+	int hdr_len = skb_tcp_all_headers(skb);
 	struct mvneta_tx_desc *tx_desc;
 
 	tx_desc = mvneta_txq_next_desc_get(txq);
@@ -2727,7 +2727,7 @@ static int mvneta_tx_tso(struct sk_buff *skb, struct net_device *dev,
 	if ((txq->count + tso_count_descs(skb)) >= txq->size)
 		return 0;
 
-	if (skb_headlen(skb) < (skb_transport_offset(skb) + tcp_hdrlen(skb))) {
+	if (skb_headlen(skb) < skb_tcp_all_headers(skb)) {
 		pr_info("*** Is this even possible?\n");
 		return 0;
 	}
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index 3baeafc408070fb8f6c85b3a984e68699f48c555..a18e8efd0f1ee53d891e9fd8faaef39aa2df1774 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -624,7 +624,7 @@ static void otx2_sqe_add_ext(struct otx2_nic *pfvf, struct otx2_snd_queue *sq,
 	ext->subdc = NIX_SUBDC_EXT;
 	if (skb_shinfo(skb)->gso_size) {
 		ext->lso = 1;
-		ext->lso_sb = skb_transport_offset(skb) + tcp_hdrlen(skb);
+		ext->lso_sb = skb_tcp_all_headers(skb);
 		ext->lso_mps = skb_shinfo(skb)->gso_size;
 
 		/* Only TSOv4 and TSOv6 GSO offloads are supported */
@@ -931,7 +931,7 @@ static bool is_hw_tso_supported(struct otx2_nic *pfvf,
 	 * be correctly modified, hence don't offload such TSO segments.
 	 */
 
-	payload_len = skb->len - (skb_transport_offset(skb) + tcp_hdrlen(skb));
+	payload_len = skb->len - skb_tcp_all_headers(skb);
 	last_seg_size = payload_len % skb_shinfo(skb)->gso_size;
 	if (last_seg_size && last_seg_size < 16)
 		return false;
diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index a1e907c852177c0022a42500313d1fd434726fcd..d70d8effb10e8be5e36e31fd1422cddbdaf82e65 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -1863,7 +1863,7 @@ static netdev_tx_t sky2_xmit_frame(struct sk_buff *skb,
 	if (mss != 0) {
 
 		if (!(hw->flags & SKY2_HW_NEW_LE))
-			mss += ETH_HLEN + ip_hdrlen(skb) + tcp_hdrlen(skb);
+			mss += skb_tcp_all_headers(skb);
 
 		if (mss != sky2->tx_last_mss) {
 			le = get_tx_le(sky2, &slot);
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
index af3b2b59a2a6940a2839b277815ec7c3b4af1008..43a4102e9c091758b33aa7377dcb82cab7c43a94 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
@@ -645,7 +645,7 @@ static int get_real_size(const struct sk_buff *skb,
 		*inline_ok = false;
 		*hopbyhop = 0;
 		if (skb->encapsulation) {
-			*lso_header_size = (skb_inner_transport_header(skb) - skb->data) + inner_tcp_hdrlen(skb);
+			*lso_header_size = skb_inner_tcp_all_headers(skb);
 		} else {
 			/* Detects large IPV6 TCP packets and prepares for removal of
 			 * HBH header that has been pushed by ip6_xmit(),
@@ -653,7 +653,7 @@ static int get_real_size(const struct sk_buff *skb,
 			 */
 			if (ipv6_has_hopopt_jumbo(skb))
 				*hopbyhop = sizeof(struct hop_jumbo_hdr);
-			*lso_header_size = skb_transport_offset(skb) + tcp_hdrlen(skb);
+			*lso_header_size = skb_tcp_all_headers(skb);
 		}
 		real_size = CTRL_SIZE + shinfo->nr_frags * DS_SIZE +
 			ALIGN(*lso_header_size - *hopbyhop + 4, DS_SIZE);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 4b6f0d1ea59ad729d63d087773963648694d51ca..cc5cb3010e6493e42f112ae3b47ed5865ef99bc8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -458,7 +458,7 @@ bool mlx5e_ktls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq *sq,
 	int datalen;
 	u32 seq;
 
-	datalen = skb->len - (skb_transport_offset(skb) + tcp_hdrlen(skb));
+	datalen = skb->len - skb_tcp_all_headers(skb);
 	if (!datalen)
 		return true;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 50d14cec4894beda28f87a9a4079601131ec89ad..64d78fd99c6e473bc4549bf483c829cc3023f793 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -152,14 +152,14 @@ mlx5e_tx_get_gso_ihs(struct mlx5e_txqsq *sq, struct sk_buff *skb, int *hopbyhop)
 
 	*hopbyhop = 0;
 	if (skb->encapsulation) {
-		ihs = skb_inner_transport_offset(skb) + inner_tcp_hdrlen(skb);
+		ihs = skb_tcp_all_headers(skb);
 		stats->tso_inner_packets++;
 		stats->tso_inner_bytes += skb->len - ihs;
 	} else {
 		if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4) {
 			ihs = skb_transport_offset(skb) + sizeof(struct udphdr);
 		} else {
-			ihs = skb_transport_offset(skb) + tcp_hdrlen(skb);
+			ihs = skb_tcp_all_headers(skb);
 			if (ipv6_has_hopopt_jumbo(skb)) {
 				*hopbyhop = sizeof(struct hop_jumbo_hdr);
 				ihs -= sizeof(struct hop_jumbo_hdr);
diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index 61497c3e4cfbdaf5809edac65311a28699e774f9..971dde8c328643fc2f456b30671a31f2dc94e15e 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -2692,7 +2692,7 @@ static netdev_tx_t myri10ge_xmit(struct sk_buff *skb,
 		 * send loop that we are still in the
 		 * header portion of the TSO packet.
 		 * TSO header can be at most 1KB long */
-		cum_len = -(skb_transport_offset(skb) + tcp_hdrlen(skb));
+		cum_len = -skb_tcp_all_headers(skb);
 
 		/* for IPv6 TSO, the checksum offset stores the
 		 * TCP header length, to save the firmware from
diff --git a/drivers/net/ethernet/netronome/nfp/nfd3/dp.c b/drivers/net/ethernet/netronome/nfp/nfd3/dp.c
index f9410d59146d14a19b5b6977d602d664ba82f80a..8a9d366196591dd56f2dd418f355039d04272792 100644
--- a/drivers/net/ethernet/netronome/nfp/nfd3/dp.c
+++ b/drivers/net/ethernet/netronome/nfp/nfd3/dp.c
@@ -81,12 +81,11 @@ nfp_nfd3_tx_tso(struct nfp_net_r_vector *r_vec, struct nfp_nfd3_tx_buf *txbuf,
 	if (!skb->encapsulation) {
 		l3_offset = skb_network_offset(skb);
 		l4_offset = skb_transport_offset(skb);
-		hdrlen = skb_transport_offset(skb) + tcp_hdrlen(skb);
+		hdrlen = skb_tcp_all_headers(skb);
 	} else {
 		l3_offset = skb_inner_network_offset(skb);
 		l4_offset = skb_inner_transport_offset(skb);
-		hdrlen = skb_inner_transport_header(skb) - skb->data +
-			inner_tcp_hdrlen(skb);
+		hdrlen = skb_inner_tcp_all_headers(skb);
 	}
 
 	txbuf->pkt_cnt = skb_shinfo(skb)->gso_segs;
diff --git a/drivers/net/ethernet/netronome/nfp/nfdk/dp.c b/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
index 300637e576a890234823b1ce64d55f5b633e663c..85dd376a6adc25a8adffe6325d2dee98b08c116e 100644
--- a/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
+++ b/drivers/net/ethernet/netronome/nfp/nfdk/dp.c
@@ -46,12 +46,11 @@ nfp_nfdk_tx_tso(struct nfp_net_r_vector *r_vec, struct nfp_nfdk_tx_buf *txbuf,
 	if (!skb->encapsulation) {
 		l3_offset = skb_network_offset(skb);
 		l4_offset = skb_transport_offset(skb);
-		hdrlen = skb_transport_offset(skb) + tcp_hdrlen(skb);
+		hdrlen = skb_tcp_all_headers(skb);
 	} else {
 		l3_offset = skb_inner_network_offset(skb);
 		l4_offset = skb_inner_transport_offset(skb);
-		hdrlen = skb_inner_transport_header(skb) - skb->data +
-			inner_tcp_hdrlen(skb);
+		hdrlen = skb_inner_tcp_all_headers(skb);
 	}
 
 	segs = skb_shinfo(skb)->gso_segs;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 0991fc122998e073bf0e8dcf925772e1f5350c6d..d92e0a5156314a35c8841c721683cbd02b141d4a 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -598,7 +598,7 @@ nfp_net_tls_tx(struct nfp_net_dp *dp, struct nfp_net_r_vector *r_vec,
 	if (!skb->sk || !tls_is_sk_tx_device_offloaded(skb->sk))
 		return skb;
 
-	datalen = skb->len - (skb_transport_offset(skb) + tcp_hdrlen(skb));
+	datalen = skb->len - skb_tcp_all_headers(skb);
 	seq = ntohl(tcp_hdr(skb)->seq);
 	ntls = tls_driver_ctx(skb->sk, TLS_OFFLOAD_CTX_DIR_TX);
 	resync_pending = tls_offload_tx_resync_pending(skb->sk);
@@ -666,7 +666,7 @@ void nfp_net_tls_tx_undo(struct sk_buff *skb, u64 tls_handle)
 	if (WARN_ON_ONCE(!skb->sk || !tls_is_sk_tx_device_offloaded(skb->sk)))
 		return;
 
-	datalen = skb->len - (skb_transport_offset(skb) + tcp_hdrlen(skb));
+	datalen = skb->len - skb_tcp_all_headers(skb);
 	seq = ntohl(tcp_hdr(skb)->seq);
 
 	ntls = tls_driver_ctx(skb->sk, TLS_OFFLOAD_CTX_DIR_TX);
@@ -1758,8 +1758,7 @@ nfp_net_features_check(struct sk_buff *skb, struct net_device *dev,
 	if (skb_is_gso(skb)) {
 		u32 hdrlen;
 
-		hdrlen = skb_inner_transport_header(skb) - skb->data +
-			inner_tcp_hdrlen(skb);
+		hdrlen = skb_inner_tcp_all_headers(skb);
 
 		/* Assume worst case scenario of having longest possible
 		 * metadata prepend - 8B
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index f54035455ad632cec0aa0a7e7dd592752f2916cd..c03986bf262890deaf3c99f48f78aade2d7b68ba 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -947,10 +947,9 @@ static int ionic_tx_tso(struct ionic_queue *q, struct sk_buff *skb)
 	}
 
 	if (encap)
-		hdrlen = skb_inner_transport_header(skb) - skb->data +
-			 inner_tcp_hdrlen(skb);
+		hdrlen = skb_inner_tcp_all_headers(skb);
 	else
-		hdrlen = skb_transport_offset(skb) + tcp_hdrlen(skb);
+		hdrlen = skb_tcp_all_headers(skb);
 
 	tso_rem = len;
 	seg_rem = min(tso_rem, hdrlen + mss);
diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
index 07dd3c3b1771123020f166dee9c91a29850fe448..4e6f00af17d92ed2fcac1c8df5d90cb3c55219a6 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
@@ -1877,7 +1877,7 @@ netxen_tso_check(struct net_device *netdev,
 	if ((netdev->features & (NETIF_F_TSO | NETIF_F_TSO6)) &&
 			skb_shinfo(skb)->gso_size > 0) {
 
-		hdr_len = skb_transport_offset(skb) + tcp_hdrlen(skb);
+		hdr_len = skb_tcp_all_headers(skb);
 
 		first_desc->mss = cpu_to_le16(skb_shinfo(skb)->gso_size);
 		first_desc->total_hdr_length = hdr_len;
diff --git a/drivers/net/ethernet/qlogic/qede/qede_fp.c b/drivers/net/ethernet/qlogic/qede/qede_fp.c
index b7cc36589f592e995e3a12bb80bc7c8e3af7dc42..7c2af482192d740c420b25799bb48ad467b8e511 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
@@ -260,11 +260,9 @@ static int map_frag_to_bd(struct qede_tx_queue *txq,
 static u16 qede_get_skb_hlen(struct sk_buff *skb, bool is_encap_pkt)
 {
 	if (is_encap_pkt)
-		return (skb_inner_transport_header(skb) +
-			inner_tcp_hdrlen(skb) - skb->data);
-	else
-		return (skb_transport_header(skb) +
-			tcp_hdrlen(skb) - skb->data);
+		return skb_inner_tcp_all_headers(skb);
+
+	return skb_tcp_all_headers(skb);
 }
 
 /* +2 for 1st BD for headers and 2nd BD for headlen (if required) */
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
index 8d43ca282956d10adc9f0576e36aac2a7900ff20..9da5e97f8a0ada4a1f38f3255ec024665f288173 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
@@ -497,7 +497,7 @@ static int qlcnic_tx_pkt(struct qlcnic_adapter *adapter,
 	}
 	opcode = QLCNIC_TX_ETHER_PKT;
 	if (skb_is_gso(skb)) {
-		hdr_len = skb_transport_offset(skb) + tcp_hdrlen(skb);
+		hdr_len = skb_tcp_all_headers(skb);
 		first_desc->mss = cpu_to_le16(skb_shinfo(skb)->gso_size);
 		first_desc->hdr_length = hdr_len;
 		opcode = (protocol == ETH_P_IPV6) ? QLCNIC_TX_TCP_LSO6 :
diff --git a/drivers/net/ethernet/qualcomm/emac/emac-mac.c b/drivers/net/ethernet/qualcomm/emac/emac-mac.c
index 80c95c331c82270af0da81bb57cca40e5f19c221..0d80447d4d3b4943221a983eb5a7d58f4ee9ad34 100644
--- a/drivers/net/ethernet/qualcomm/emac/emac-mac.c
+++ b/drivers/net/ethernet/qualcomm/emac/emac-mac.c
@@ -1264,7 +1264,7 @@ static int emac_tso_csum(struct emac_adapter *adpt,
 				pskb_trim(skb, pkt_len);
 		}
 
-		hdr_len = skb_transport_offset(skb) + tcp_hdrlen(skb);
+		hdr_len = skb_tcp_all_headers(skb);
 		if (unlikely(skb->len == hdr_len)) {
 			/* we only need to do csum */
 			netif_warn(adpt, tx_err, adpt->netdev,
@@ -1339,7 +1339,7 @@ static void emac_tx_fill_tpd(struct emac_adapter *adpt,
 
 	/* if Large Segment Offload is (in TCP Segmentation Offload struct) */
 	if (TPD_LSO(tpd)) {
-		mapped_len = skb_transport_offset(skb) + tcp_hdrlen(skb);
+		mapped_len = skb_tcp_all_headers(skb);
 
 		tpbuf = GET_TPD_BUFFER(tx_q, tx_q->tpd.produce_idx);
 		tpbuf->length = mapped_len;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index fe263cad8248e523263f5c54e7599b63782a37cf..6f14b00c0b14989d360ece0656c91e5a4551d292 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3961,7 +3961,7 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 		proto_hdr_len = skb_transport_offset(skb) + sizeof(struct udphdr);
 		hdr = sizeof(struct udphdr);
 	} else {
-		proto_hdr_len = skb_transport_offset(skb) + tcp_hdrlen(skb);
+		proto_hdr_len = skb_tcp_all_headers(skb);
 		hdr = tcp_hdrlen(skb);
 	}
 
diff --git a/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c b/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c
index d435519236e43e08632ab7ef855763a207b246c5..e54ce73396ee7845d7d89f0ca38501ca5936b6b8 100644
--- a/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c
+++ b/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c
@@ -81,7 +81,7 @@ static int xlgmac_prep_tso(struct sk_buff *skb,
 	if (ret)
 		return ret;
 
-	pkt_info->header_len = skb_transport_offset(skb) + tcp_hdrlen(skb);
+	pkt_info->header_len = skb_tcp_all_headers(skb);
 	pkt_info->tcp_header_len = tcp_hdrlen(skb);
 	pkt_info->tcp_payload_len = skb->len - pkt_info->header_len;
 	pkt_info->mss = skb_shinfo(skb)->gso_size;
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 5704defd7be1bbfca7273d89bca7e31fb8504d0c..237cbd5c5060bd3bc0b40c017317aaa23232128f 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -1782,9 +1782,7 @@ static int __wil_tx_vring_tso(struct wil6210_priv *wil, struct wil6210_vif *vif,
 	}
 
 	/* Header Length = MAC header len + IP header len + TCP header len*/
-	hdrlen = ETH_HLEN +
-		(int)skb_network_header_len(skb) +
-		tcp_hdrlen(skb);
+	hdrlen = skb_tcp_all_headers(skb);
 
 	gso_type = skb_shinfo(skb)->gso_type & (SKB_GSO_TCPV6 | SKB_GSO_TCPV4);
 	switch (gso_type) {
diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index fc61a44187377525b6f5b2163600fc1aef6dc3c7..a256695fc89ec3a2d98aa07e59b906df0cedefef 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -1201,9 +1201,7 @@ static int xenvif_tx_submit(struct xenvif_queue *queue)
 			}
 
 			mss = skb_shinfo(skb)->gso_size;
-			hdrlen = skb_transport_header(skb) -
-				skb_mac_header(skb) +
-				tcp_hdrlen(skb);
+			hdrlen = skb_tcp_all_headers(skb);
 
 			skb_shinfo(skb)->gso_segs =
 				DIV_ROUND_UP(skb->len - hdrlen, mss);
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 113a3efd12e95f6a6eea561cdcffc2e753c34e7e..6cd7fc9589c3c055a39db077d8e98bccb4bc607d 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -2461,7 +2461,7 @@ static int qlge_tso(struct sk_buff *skb, struct qlge_ob_mac_tso_iocb_req *mac_io
 		mac_iocb_ptr->flags3 |= OB_MAC_TSO_IOCB_IC;
 		mac_iocb_ptr->frame_len = cpu_to_le32((u32)skb->len);
 		mac_iocb_ptr->total_hdrs_len =
-			cpu_to_le16(skb_transport_offset(skb) + tcp_hdrlen(skb));
+			cpu_to_le16(skb_tcp_all_headers(skb));
 		mac_iocb_ptr->net_trans_offset =
 			cpu_to_le16(skb_network_offset(skb) |
 				    skb_transport_offset(skb)
diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 1168302b79274e5f2d9828e945c40f71a3fb8903..a9fbe22732c3ba67584df13344955b584f242b54 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -46,6 +46,36 @@ static inline unsigned int inner_tcp_hdrlen(const struct sk_buff *skb)
 	return inner_tcp_hdr(skb)->doff * 4;
 }
 
+/**
+ * skb_tcp_all_headers - Returns size of all headers for a TCP packet
+ * @skb: buffer
+ *
+ * Used in TX path, for a packet known to be a TCP one.
+ *
+ * if (skb_is_gso(skb)) {
+ *         int hlen = skb_tcp_all_headers(skb);
+ *         ...
+ */
+static inline int skb_tcp_all_headers(const struct sk_buff *skb)
+{
+	return skb_transport_offset(skb) + tcp_hdrlen(skb);
+}
+
+/**
+ * skb_inner_tcp_all_headers - Returns size of all headers for an encap TCP packet
+ * @skb: buffer
+ *
+ * Used in TX path, for a packet known to be a TCP one.
+ *
+ * if (skb_is_gso(skb) && skb->encapsulation) {
+ *         int hlen = skb_inner_tcp_all_headers(skb);
+ *         ...
+ */
+static inline int skb_inner_tcp_all_headers(const struct sk_buff *skb)
+{
+	return skb_inner_transport_offset(skb) + inner_tcp_hdrlen(skb);
+}
+
 static inline unsigned int tcp_optlen(const struct sk_buff *skb)
 {
 	return (tcp_hdr(skb)->doff - 5) * 4;
diff --git a/net/tls/tls_device_fallback.c b/net/tls/tls_device_fallback.c
index e40bedd112b68573ab8bfd845002e17253028c16..3bae29ae57ca2f8dbf2b6ca9c0dcd9bdcd99f6df 100644
--- a/net/tls/tls_device_fallback.c
+++ b/net/tls/tls_device_fallback.c
@@ -232,7 +232,7 @@ static int fill_sg_in(struct scatterlist *sg_in,
 		      s32 *sync_size,
 		      int *resync_sgs)
 {
-	int tcp_payload_offset = skb_transport_offset(skb) + tcp_hdrlen(skb);
+	int tcp_payload_offset = skb_tcp_all_headers(skb);
 	int payload_len = skb->len - tcp_payload_offset;
 	u32 tcp_seq = ntohl(tcp_hdr(skb)->seq);
 	struct tls_record_info *record;
@@ -310,8 +310,8 @@ static struct sk_buff *tls_enc_skb(struct tls_context *tls_ctx,
 				   struct sk_buff *skb,
 				   s32 sync_size, u64 rcd_sn)
 {
-	int tcp_payload_offset = skb_transport_offset(skb) + tcp_hdrlen(skb);
 	struct tls_offload_context_tx *ctx = tls_offload_ctx_tx(tls_ctx);
+	int tcp_payload_offset = skb_tcp_all_headers(skb);
 	int payload_len = skb->len - tcp_payload_offset;
 	void *buf, *iv, *aad, *dummy_buf;
 	struct aead_request *aead_req;
@@ -372,7 +372,7 @@ static struct sk_buff *tls_enc_skb(struct tls_context *tls_ctx,
 
 static struct sk_buff *tls_sw_fallback(struct sock *sk, struct sk_buff *skb)
 {
-	int tcp_payload_offset = skb_transport_offset(skb) + tcp_hdrlen(skb);
+	int tcp_payload_offset = skb_tcp_all_headers(skb);
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_offload_context_tx *ctx = tls_offload_ctx_tx(tls_ctx);
 	int payload_len = skb->len - tcp_payload_offset;
-- 
2.37.0.rc0.161.g10f37bed90-goog

