Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD3A7177B
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 13:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731226AbfGWLwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 07:52:41 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:35832 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728765AbfGWLwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 07:52:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=HRW9+5V1BXXXKxhY4DmcGA5Dpp7a+Xj+ldwL1FZdnj8=; b=VpAP87tvZI+FXaC38/v3EtRGNz
        AllNXlZiVoCAEQSpHAARobwVYUHcVx9cfWXcSH9LbwCH0xHn4R9mV3GJhHv5raVbrIt9/vsI2dPDi
        3syyyl0qHGerqN6v2mBrrhG4+WOV0uHOJKdtTPrTFT5S7EbMRx800tB3YBJekxg1aAsWkDOzQ6knY
        0RGtHRQ4baCoSw5dXKpdwk/dbXDsPfwpFHp1CWUaBJwFHbHF0oBYkhm9eZbwFTcbIJs+NRcskrDwC
        3549lhKGMIX9vgaNMNCphd4DtdDOF9G+uYNedTeT/rOUIv7TKLILgMHh38QS7ZO8BL/gBNcw3Ym4R
        Yx/Gpyng==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hptLS-0006RB-TK; Tue, 23 Jul 2019 11:52:38 +0000
Date:   Tue, 23 Jul 2019 04:52:38 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>
Cc:     kbuild-all@01.org, netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [net-next:master 13/14]
 drivers/net/ethernet/faraday/ftgmac100.c:777:13: error: 'skb_frag_t {aka
 struct bio_vec}' has no member named 'size'
Message-ID: <20190723115238.GJ363@bombadil.infradead.org>
References: <201907231400.Q5QaKepi%lkp@intel.com>
 <20190723085844.Horde.ehPsGFdWI2BCQdl_UyzJxlS@www.vdorst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190723085844.Horde.ehPsGFdWI2BCQdl_UyzJxlS@www.vdorst.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 23, 2019 at 08:58:44AM +0000, René van Dorst wrote:
> Hi Matthew,
> 
> I see the same issue for the mediatek/mtk_eth_soc driver.

Thanks, Rene.  The root problem for both of these drivers is that neither
are built on x86 with CONFIG_COMPILE_TEST.  Is it possible to fix this?

An untested patch to fix both of these problems (and two more that I
spotted):

diff --git a/drivers/atm/he.c b/drivers/atm/he.c
index 211607986134..70b00ae4ec38 100644
--- a/drivers/atm/he.c
+++ b/drivers/atm/he.c
@@ -2580,10 +2580,9 @@ he_send(struct atm_vcc *vcc, struct sk_buff *skb)
 			slot = 0;
 		}
 
-		tpd->iovec[slot].addr = dma_map_single(&he_dev->pci_dev->dev,
-			(void *) page_address(frag->page) + frag->page_offset,
-				frag->size, DMA_TO_DEVICE);
-		tpd->iovec[slot].len = frag->size;
+		tpd->iovec[slot].addr = skb_frag_dma_map(&he_dev->pci_dev->dev,
+				frag, 0, skb_frag_size(frag), DMA_TO_DEVICE);
+		tpd->iovec[slot].len = skb_frag_size(frag);
 		++slot;
 
 	}
diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index 030fed65393e..dc8d3e726e75 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -774,7 +774,7 @@ static netdev_tx_t ftgmac100_hard_start_xmit(struct sk_buff *skb,
 	for (i = 0; i < nfrags; i++) {
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 
-		len = frag->size;
+		len = skb_frag_size(frag);
 
 		/* Map it */
 		map = skb_frag_dma_map(priv->dev, frag, 0, len,
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index f38c3fa7d705..9c4d1afa34e5 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -1958,7 +1958,7 @@ static int skb_to_sg_fd(struct dpaa_priv *priv,
 	/* populate the rest of SGT entries */
 	for (i = 0; i < nr_frags; i++) {
 		frag = &skb_shinfo(skb)->frags[i];
-		frag_len = frag->size;
+		frag_len = skb_frag_size(frag);
 		WARN_ON(!skb_frag_page(frag));
 		addr = skb_frag_dma_map(dev, frag, 0,
 					frag_len, dma_dir);
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 00991df44ed6..e529d86468b8 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -787,7 +787,8 @@ static inline int mtk_cal_txd_req(struct sk_buff *skb)
 	if (skb_is_gso(skb)) {
 		for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
 			frag = &skb_shinfo(skb)->frags[i];
-			nfrags += DIV_ROUND_UP(frag->size, MTK_TX_DMA_BUF_LEN);
+			nfrags += DIV_ROUND_UP(skb_frag_size(frag),
+						MTK_TX_DMA_BUF_LEN);
 		}
 	} else {
 		nfrags += skb_shinfo(skb)->nr_frags;
