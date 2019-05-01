Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E759810475
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 06:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726120AbfEAESD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 00:18:03 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37332 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726052AbfEAESD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 00:18:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Kug1dYHB0ZsiXiuR3uHXmJb4fcQDAYparFLxvaGF+xM=; b=IRo9j5C3dY8oOUREZpqx9cCXc
        Kpqkdin2EAv/OFv4DAuS/BwdZmjWLzkyod9Bex5bY+YFQgqmHyOoVdYAcozF5//JMpzXM8woXoDZR
        /8L2h28uJ6KnYO1mQm1C+8tLlyerr0HwFA75XCPwTaKdhs8RCfAgewhFe6gSNmJmrnShCPqBeaOKW
        7yaYAnfBh7kWq6B0HETnvUwIY5AGQ4RlvM49FeU+TzW2W0sm/0eh2UK0ess29zxTjkoKARXpqloBk
        fkGVFYu7U5MT/qQCZHixGACTMvJzzQFWl3I76J2u2yi2hhwWvbFdZtKnjI+GW+qdRNBXvVRqi6ha5
        DzmVfTJ8Q==;
Received: from willy by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hLggz-0002Ge-FC; Wed, 01 May 2019 04:18:01 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     davem@davemloft.net
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>, hch@lst.de,
        netdev@vger.kernel.org
Subject: [PATCH 4/5] net: Use skb accessors for skb->page
Date:   Tue, 30 Apr 2019 21:17:56 -0700
Message-Id: <20190501041757.8647-6-willy@infradead.org>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20190501041757.8647-1-willy@infradead.org>
References: <20190501041757.8647-1-willy@infradead.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

In preparation for renaming skb->page, use the fine accessors which
already exist.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 drivers/hsi/clients/ssi_protocol.c                 | 3 ++-
 drivers/net/ethernet/cavium/liquidio/lio_main.c    | 2 +-
 drivers/net/ethernet/cavium/liquidio/lio_vf_main.c | 2 +-
 drivers/net/ethernet/freescale/fec_main.c          | 2 +-
 drivers/net/ethernet/marvell/mvneta.c              | 2 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    | 2 +-
 drivers/net/ethernet/qualcomm/emac/emac-mac.c      | 3 ++-
 drivers/net/usb/usbnet.c                           | 2 +-
 drivers/net/xen-netback/netback.c                  | 4 ++--
 drivers/staging/octeon/ethernet-tx.c               | 3 +--
 drivers/target/iscsi/cxgbit/cxgbit_target.c        | 6 +++---
 net/core/skbuff.c                                  | 6 +++---
 net/core/tso.c                                     | 4 ++--
 net/kcm/kcmsock.c                                  | 2 +-
 net/tls/tls_device.c                               | 4 ++--
 15 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/drivers/hsi/clients/ssi_protocol.c b/drivers/hsi/clients/ssi_protocol.c
index 561abf7bdf1f..9f506c00ad85 100644
--- a/drivers/hsi/clients/ssi_protocol.c
+++ b/drivers/hsi/clients/ssi_protocol.c
@@ -194,7 +194,8 @@ static void ssip_skb_to_msg(struct sk_buff *skb, struct hsi_msg *msg)
 		sg = sg_next(sg);
 		BUG_ON(!sg);
 		frag = &skb_shinfo(skb)->frags[i];
-		sg_set_page(sg, frag->page.p, frag->size, frag->page_offset);
+		sg_set_page(sg, skb_page_frag(frag), frag->size,
+				frag->page_offset);
 	}
 }
 
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index fb6f813cff65..96ea3f6452a8 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -2463,7 +2463,7 @@ static netdev_tx_t liquidio_xmit(struct sk_buff *skb, struct net_device *netdev)
 
 			g->sg[(i >> 2)].ptr[(i & 3)] =
 				dma_map_page(&oct->pci_dev->dev,
-					     frag->page.p,
+					     skb_frag_page(frag),
 					     frag->page_offset,
 					     frag->size,
 					     DMA_TO_DEVICE);
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
index 54b245797d2e..b25db603443d 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
@@ -1536,7 +1536,7 @@ static netdev_tx_t liquidio_xmit(struct sk_buff *skb, struct net_device *netdev)
 
 			g->sg[(i >> 2)].ptr[(i & 3)] =
 				dma_map_page(&oct->pci_dev->dev,
-					     frag->page.p,
+					     skb_frag_page(frag),
 					     frag->page_offset,
 					     frag->size,
 					     DMA_TO_DEVICE);
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index a96ad20ee484..d0fcb4231451 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -387,7 +387,7 @@ fec_enet_txq_submit_frag_skb(struct fec_enet_priv_tx_q *txq,
 			ebdp->cbd_esc = cpu_to_fec32(estatus);
 		}
 
-		bufaddr = page_address(this_frag->page.p) + this_frag->page_offset;
+		bufaddr = skb_frag_address(this_frag);
 
 		index = fec_enet_get_bd_index(bdp, &txq->bd);
 		if (((unsigned long) bufaddr) & fep->tx_align ||
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index c0a3718b2e2a..54dd9cb88dee 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2349,7 +2349,7 @@ static int mvneta_tx_frag_process(struct mvneta_port *pp, struct sk_buff *skb,
 
 	for (i = 0; i < nr_frags; i++) {
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
-		void *addr = page_address(frag->page.p) + frag->page_offset;
+		void *addr = skb_frag_address(frag);
 
 		tx_desc = mvneta_txq_next_desc_get(txq);
 		tx_desc->data_size = frag->size;
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 25fbed2b8d94..3f30f8f49906 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -2822,7 +2822,7 @@ static int mvpp2_tx_frag_process(struct mvpp2_port *port, struct sk_buff *skb,
 
 	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
-		void *addr = page_address(frag->page.p) + frag->page_offset;
+		void *addr = skb_frag_address(frag);
 
 		tx_desc = mvpp2_txq_next_desc_get(aggr_txq);
 		mvpp2_txdesc_txq_set(port, tx_desc, txq->id);
diff --git a/drivers/net/ethernet/qualcomm/emac/emac-mac.c b/drivers/net/ethernet/qualcomm/emac/emac-mac.c
index 20d2400ad300..dc4e58100264 100644
--- a/drivers/net/ethernet/qualcomm/emac/emac-mac.c
+++ b/drivers/net/ethernet/qualcomm/emac/emac-mac.c
@@ -1400,7 +1400,8 @@ static void emac_tx_fill_tpd(struct emac_adapter *adpt,
 		tpbuf = GET_TPD_BUFFER(tx_q, tx_q->tpd.produce_idx);
 		tpbuf->length = frag->size;
 		tpbuf->dma_addr = dma_map_page(adpt->netdev->dev.parent,
-					       frag->page.p, frag->page_offset,
+					       skb_frag_page(frag),
+					       frag->page_offset,
 					       tpbuf->length, DMA_TO_DEVICE);
 		ret = dma_mapping_error(adpt->netdev->dev.parent,
 					tpbuf->dma_addr);
diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 504282af27e5..5c893726aa09 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1338,7 +1338,7 @@ static int build_dma_sg(const struct sk_buff *skb, struct urb *urb)
 		struct skb_frag_struct *f = &skb_shinfo(skb)->frags[i];
 
 		total_len += skb_frag_size(f);
-		sg_set_page(&urb->sg[i + s], f->page.p, f->size,
+		sg_set_page(&urb->sg[i + s], skb_frag_page(f), f->size,
 				f->page_offset);
 	}
 	urb->transfer_buffer_length = total_len;
diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 1d9940d4e8c7..a96c5c2a2c5a 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -1055,7 +1055,7 @@ static int xenvif_handle_frag_list(struct xenvif_queue *queue, struct sk_buff *s
 			int j;
 			skb->truesize += skb->data_len;
 			for (j = 0; j < i; j++)
-				put_page(frags[j].page.p);
+				put_page(skb_frag_page(&frags[j]));
 			return -ENOMEM;
 		}
 
@@ -1067,7 +1067,7 @@ static int xenvif_handle_frag_list(struct xenvif_queue *queue, struct sk_buff *s
 			BUG();
 
 		offset += len;
-		frags[i].page.p = page;
+		__skb_frag_set_page(&frags[i], page);
 		frags[i].page_offset = 0;
 		skb_frag_size_set(&frags[i], len);
 	}
diff --git a/drivers/staging/octeon/ethernet-tx.c b/drivers/staging/octeon/ethernet-tx.c
index 317c9720467c..29a31f37f66b 100644
--- a/drivers/staging/octeon/ethernet-tx.c
+++ b/drivers/staging/octeon/ethernet-tx.c
@@ -281,8 +281,7 @@ int cvm_oct_xmit(struct sk_buff *skb, struct net_device *dev)
 			struct skb_frag_struct *fs = skb_shinfo(skb)->frags + i;
 
 			hw_buffer.s.addr = XKPHYS_TO_PHYS(
-				(u64)(page_address(fs->page.p) +
-				fs->page_offset));
+				(u64)skb_frag_address(fs));
 			hw_buffer.s.size = fs->size;
 			CVM_OCT_SKB_CB(skb)[i + 1] = hw_buffer.u64;
 		}
diff --git a/drivers/target/iscsi/cxgbit/cxgbit_target.c b/drivers/target/iscsi/cxgbit/cxgbit_target.c
index 29b350a0b58f..9cac100b3169 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_target.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_target.c
@@ -902,9 +902,9 @@ cxgbit_handle_immediate_data(struct iscsi_cmd *cmd, struct iscsi_scsi_req *hdr,
 		skb_frag_t *dfrag = &ssi->frags[pdu_cb->dfrag_idx];
 
 		sg_init_table(&ccmd->sg, 1);
-		sg_set_page(&ccmd->sg, dfrag->page.p, skb_frag_size(dfrag),
-			    dfrag->page_offset);
-		get_page(dfrag->page.p);
+		sg_set_page(&ccmd->sg, skb_frag_page(dfrag),
+				skb_frag_size(dfrag), dfrag->page_offset);
+		get_page(skb_frag_page(dfrag));
 
 		cmd->se_cmd.t_data_sg = &ccmd->sg;
 		cmd->se_cmd.t_data_nents = 1;
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 40796b8bf820..12b60fdcff46 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2337,7 +2337,7 @@ int skb_send_sock_locked(struct sock *sk, struct sk_buff *skb, int offset,
 		slen = min_t(size_t, len, frag->size - offset);
 
 		while (slen) {
-			ret = kernel_sendpage_locked(sk, frag->page.p,
+			ret = kernel_sendpage_locked(sk, skb_frag_page(frag),
 						     frag->page_offset + offset,
 						     slen, MSG_DONTWAIT);
 			if (ret <= 0)
@@ -3459,7 +3459,7 @@ static inline skb_frag_t skb_head_frag_to_page_desc(struct sk_buff *frag_skb)
 	struct page *page;
 
 	page = virt_to_head_page(frag_skb->head);
-	head_frag.page.p = page;
+	__skb_frag_set_page(&head_frag, page);
 	head_frag.page_offset = frag_skb->data -
 		(unsigned char *)page_address(page);
 	head_frag.size = skb_headlen(frag_skb);
@@ -3855,7 +3855,7 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
 
 		pinfo->nr_frags = nr_frags + 1 + skbinfo->nr_frags;
 
-		frag->page.p	  = page;
+		__skb_frag_set_page(frag, page);
 		frag->page_offset = first_offset;
 		skb_frag_size_set(frag, first_size);
 
diff --git a/net/core/tso.c b/net/core/tso.c
index 43f4eba61933..b4fc8481d5bd 100644
--- a/net/core/tso.c
+++ b/net/core/tso.c
@@ -56,7 +56,7 @@ void tso_build_data(struct sk_buff *skb, struct tso_t *tso, int size)
 
 		/* Move to next segment */
 		tso->size = frag->size;
-		tso->data = page_address(frag->page.p) + frag->page_offset;
+		tso->data = skb_frag_address(frag);
 		tso->next_frag_idx++;
 	}
 }
@@ -80,7 +80,7 @@ void tso_start(struct sk_buff *skb, struct tso_t *tso)
 
 		/* Move to next segment */
 		tso->size = frag->size;
-		tso->data = page_address(frag->page.p) + frag->page_offset;
+		tso->data = skb_frag_address(frag);
 		tso->next_frag_idx++;
 	}
 }
diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index 44fdc641710d..194c30b79007 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -644,7 +644,7 @@ static int kcm_write_msgs(struct kcm_sock *kcm)
 			}
 
 			ret = kernel_sendpage(psock->sk->sk_socket,
-					      frag->page.p,
+					      skb_frag_page(frag),
 					      frag->page_offset + frag_offset,
 					      frag->size - frag_offset,
 					      MSG_DONTWAIT);
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index cc0256939eb6..68c17af6f150 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -233,12 +233,12 @@ static void tls_append_frag(struct tls_record_info *record,
 	skb_frag_t *frag;
 
 	frag = &record->frags[record->num_frags - 1];
-	if (frag->page.p == pfrag->page &&
+	if (skb_frag_page(frag) == pfrag->page &&
 	    frag->page_offset + frag->size == pfrag->offset) {
 		frag->size += size;
 	} else {
 		++frag;
-		frag->page.p = pfrag->page;
+		__skb_frag_set_page(frag, pfrag->page);
 		frag->page_offset = pfrag->offset;
 		frag->size = size;
 		++record->num_frags;
-- 
2.20.1

