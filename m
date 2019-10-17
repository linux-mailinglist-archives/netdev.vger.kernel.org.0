Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF7CDAC34
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 14:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393817AbfJQM25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 08:28:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:40442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728190AbfJQM25 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Oct 2019 08:28:57 -0400
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50CDE2064B;
        Thu, 17 Oct 2019 12:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571315336;
        bh=km90kikPGJ4xCHyAYt4M0hZ7XB168CwACQASC4xdi44=;
        h=From:To:Cc:Subject:Date:From;
        b=CRzix+J+voDybyw1GyVhKj9umYgPZrZEMjKePLgJBSCX41DxIHny7CoVy8QP0B0XN
         sz6W29unMvjKox13k+T9sq6/zDrWq9mUIaGuvMllAjP/pL2RFI652TLAgnLid9Qa0Z
         kgIfwlv8GHBoN220mJJ9zoKtrnXGImgATypO2m14=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, ilias.apalodimas@linaro.org,
        lorenzo.bianconi@redhat.com
Subject: [PATCH v2 net-next] net: socionext: netsec: fix xdp stats accounting
Date:   Thu, 17 Oct 2019 14:28:32 +0200
Message-Id: <50cf2bc622d81c8447713113c5c6a7d0fd4f5c95.1571315083.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Increment netdev rx counters even for XDP_DROP verdict. Report even
tx bytes for xdp buffers (TYPE_NETSEC_XDP_TX or TYPE_NETSEC_XDP_NDO).
Moreover account pending buffer length in netsec_xdp_queue_one as it is
done for skb counterpart

Tested-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
Changes since v1:
- fix BQL accounting
- target the patch to next-next
---
 drivers/net/ethernet/socionext/netsec.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index f9e6744d8fd6..c40294470bfa 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -252,7 +252,6 @@
 #define NETSEC_XDP_CONSUMED      BIT(0)
 #define NETSEC_XDP_TX            BIT(1)
 #define NETSEC_XDP_REDIR         BIT(2)
-#define NETSEC_XDP_RX_OK (NETSEC_XDP_PASS | NETSEC_XDP_TX | NETSEC_XDP_REDIR)
 
 enum ring_id {
 	NETSEC_RING_TX = 0,
@@ -661,6 +660,7 @@ static bool netsec_clean_tx_dring(struct netsec_priv *priv)
 			bytes += desc->skb->len;
 			dev_kfree_skb(desc->skb);
 		} else {
+			bytes += desc->xdpf->len;
 			xdp_return_frame(desc->xdpf);
 		}
 next:
@@ -858,6 +858,7 @@ static u32 netsec_xdp_queue_one(struct netsec_priv *priv,
 	tx_desc.addr = xdpf->data;
 	tx_desc.len = xdpf->len;
 
+	netdev_sent_queue(priv->ndev, xdpf->len);
 	netsec_set_tx_de(priv, tx_ring, &tx_ctrl, &tx_desc, xdpf);
 
 	return NETSEC_XDP_TX;
@@ -1030,7 +1031,7 @@ static int netsec_process_rx(struct netsec_priv *priv, int budget)
 
 next:
 		if ((skb && napi_gro_receive(&priv->napi, skb) != GRO_DROP) ||
-		    xdp_result & NETSEC_XDP_RX_OK) {
+		    xdp_result) {
 			ndev->stats.rx_packets++;
 			ndev->stats.rx_bytes += xdp.data_end - xdp.data;
 		}
-- 
2.21.0

