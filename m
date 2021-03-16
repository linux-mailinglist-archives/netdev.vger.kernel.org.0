Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6058F33CB76
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 03:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234552AbhCPCby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 22:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234593AbhCPCbt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 22:31:49 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15493C06174A
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 19:31:49 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id n10so21627233pgl.10
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 19:31:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=56pbCXUCTIMwBCnBXwsN4mUu3TR1rVl3IjVXaBpHfgs=;
        b=PUqbPkrgrw9wuKWmPkv5NxyPBSG7+Cyl5Xs2F+aRDO8OK6AYMIE284eARFcPC1c3FO
         DCJqZjYbSj8KIjOUImDk3kvXi/4Cxxva3LAJfRwckapUYxdFEc4pvts4VcKQlR5Tays4
         /2e+3k1SLTWvzJ7IT6toArY4/Z2x9sYxhW6qlxdNfLWeOcPJTPPxPoeqmfVi8y3tgJ4P
         uMplLgHd/76UmV5IyeZ1Hhevkg1nQ4NzF3hDBSokv/Eiz+dJ+FxjvGECMdsDi6cmD29y
         CDUfB5wei5xw3aXrkCvOjY+ooPvztqvZum9sQJD5W6CBUgGiCalDNGyt30FuX3qMsFp2
         MbCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=56pbCXUCTIMwBCnBXwsN4mUu3TR1rVl3IjVXaBpHfgs=;
        b=NabRFW8OFHAkTseyRUDNB+iv6uKW97fK+WwpskjHgG+sHnFvfXI9gYKd1Sh3Ymmw2S
         mY2nM9ZOynjW3i8TPQpmYyfHVC2bJfDIRJU9avQfbElD7V7BXQUS1yUpsnj2YugTLwax
         Us4M5fnGp8Gu1qAwbBQ92r6UR5MieZw956efUkfNrg0I4eBsl5Pl50SZSsc+N27bZ36p
         qzAgpANmUdUqmzbHsiENWmDDU9wdkIobAifJ9S5iaDkNh5Vro/W9AbpM9a98M3wi2Bmt
         1DR3B+ahtdkZcq2uugTa4ijAv1trmj1UxGUdEkfCpnvoixaqAnq8QLxcWwYGSlCS/bys
         uOqA==
X-Gm-Message-State: AOAM531fuX3ZgdPnoopIkydQVm+3nhpTj8VLx5lehv6gbR5RKRoJIRhn
        DnFz0qKDe3Vy55OC1/jzREVLGb6h8BJZ9w==
X-Google-Smtp-Source: ABdhPJxo+XBGxeAR/uJAzrU3XrjOttxFy+l/2oUnTntOkv9V+fVpgM4b7SUKxOrdQSeJwrL1t2D/8Q==
X-Received: by 2002:a63:1312:: with SMTP id i18mr1841291pgl.108.1615861908237;
        Mon, 15 Mar 2021 19:31:48 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id t18sm8687743pgg.33.2021.03.15.19.31.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 19:31:47 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 2/4] ionic: generic tx skb mapping
Date:   Mon, 15 Mar 2021 19:31:34 -0700
Message-Id: <20210316023136.22702-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210316023136.22702-1-snelson@pensando.io>
References: <20210316023136.22702-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make the new ionic_tx_map_tso() usable by the non-TSO paths,
and pull the call up a level into ionic_tx() before calling
the csum or no-csum routines.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_txrx.c  | 142 +++++++++---------
 1 file changed, 68 insertions(+), 74 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index 639000a2e495..1d27d6cad504 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -605,11 +605,13 @@ static dma_addr_t ionic_tx_map_frag(struct ionic_queue *q,
 	return dma_addr;
 }
 
-static int ionic_tx_map_tso(struct ionic_queue *q, struct sk_buff *skb,
-			    struct ionic_buf_info *buf_info)
+static int ionic_tx_map_skb(struct ionic_queue *q, struct sk_buff *skb,
+			    struct ionic_desc_info *desc_info)
 {
+	struct ionic_buf_info *buf_info = desc_info->bufs;
 	struct device *dev = q->dev;
 	dma_addr_t dma_addr;
+	unsigned int nfrags;
 	skb_frag_t *frag;
 	int frag_idx;
 
@@ -620,15 +622,19 @@ static int ionic_tx_map_tso(struct ionic_queue *q, struct sk_buff *skb,
 	buf_info->len = skb_headlen(skb);
 	buf_info++;
 
-	for (frag_idx = 0; frag_idx < skb_shinfo(skb)->nr_frags; frag_idx++, buf_info++) {
-		frag = &skb_shinfo(skb)->frags[frag_idx];
+	frag = skb_shinfo(skb)->frags;
+	nfrags = skb_shinfo(skb)->nr_frags;
+	for (frag_idx = 0; frag_idx < nfrags; frag_idx++, frag++) {
 		dma_addr = ionic_tx_map_frag(q, frag, 0, skb_frag_size(frag));
 		if (dma_mapping_error(dev, dma_addr))
 			goto dma_fail;
 		buf_info->dma_addr = dma_addr;
 		buf_info->len = skb_frag_size(frag);
+		buf_info++;
 	}
 
+	desc_info->nbufs = 1 + nfrags;
+
 	return 0;
 
 dma_fail:
@@ -814,40 +820,29 @@ static void ionic_tx_tso_post(struct ionic_queue *q, struct ionic_txq_desc *desc
 	desc->hdr_len = cpu_to_le16(hdrlen);
 	desc->mss = cpu_to_le16(mss);
 
-	if (done) {
+	if (start) {
 		skb_tx_timestamp(skb);
 		netdev_tx_sent_queue(q_to_ndq(q), skb->len);
-		ionic_txq_post(q, !netdev_xmit_more(), ionic_tx_clean, skb);
+		ionic_txq_post(q, false, ionic_tx_clean, skb);
 	} else {
-		ionic_txq_post(q, false, ionic_tx_clean, NULL);
+		ionic_txq_post(q, done, NULL, NULL);
 	}
 }
 
-static struct ionic_txq_desc *ionic_tx_tso_next(struct ionic_queue *q,
-						struct ionic_txq_sg_elem **elem)
-{
-	struct ionic_txq_sg_desc *sg_desc = q->info[q->head_idx].txq_sg_desc;
-	struct ionic_txq_desc *desc = q->info[q->head_idx].txq_desc;
-
-	*elem = sg_desc->elems;
-	return desc;
-}
-
 static int ionic_tx_tso(struct ionic_queue *q, struct sk_buff *skb)
 {
-	struct ionic_buf_info buf_info[IONIC_MAX_FRAGS] = {{0}};
 	struct ionic_tx_stats *stats = q_to_tx_stats(q);
+	struct ionic_desc_info *desc_info;
+	struct ionic_buf_info *buf_info;
 	struct ionic_txq_sg_elem *elem;
 	struct ionic_txq_desc *desc;
 	unsigned int chunk_len;
 	unsigned int frag_rem;
-	unsigned int frag_idx;
 	unsigned int tso_rem;
 	unsigned int seg_rem;
 	dma_addr_t desc_addr;
 	dma_addr_t frag_addr;
 	unsigned int hdrlen;
-	unsigned int nfrags;
 	unsigned int len;
 	unsigned int mss;
 	bool start, done;
@@ -859,12 +854,14 @@ static int ionic_tx_tso(struct ionic_queue *q, struct sk_buff *skb)
 	bool encap;
 	int err;
 
-	if (unlikely(ionic_tx_map_tso(q, skb, buf_info)))
+	desc_info = &q->info[q->head_idx];
+	buf_info = desc_info->bufs;
+
+	if (unlikely(ionic_tx_map_skb(q, skb, desc_info)))
 		return -EIO;
 
 	len = skb->len;
 	mss = skb_shinfo(skb)->gso_size;
-	nfrags = skb_shinfo(skb)->nr_frags;
 	outer_csum = (skb_shinfo(skb)->gso_type & SKB_GSO_GRE_CSUM) ||
 		     (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_TUNNEL_CSUM);
 	has_vlan = !!skb_vlan_tag_present(skb);
@@ -892,7 +889,6 @@ static int ionic_tx_tso(struct ionic_queue *q, struct sk_buff *skb)
 	tso_rem = len;
 	seg_rem = min(tso_rem, hdrlen + mss);
 
-	frag_idx = 0;
 	frag_addr = 0;
 	frag_rem = 0;
 
@@ -904,19 +900,20 @@ static int ionic_tx_tso(struct ionic_queue *q, struct sk_buff *skb)
 		desc_addr = 0;
 		desc_len = 0;
 		desc_nsge = 0;
-		/* loop until a full tcp segment can be created */
+		/* use fragments until we have enough to post a single descriptor */
 		while (seg_rem > 0) {
-			/* if the fragment is exhausted get the next one */
+			/* if the fragment is exhausted then move to the next one */
 			if (frag_rem == 0) {
 				/* grab the next fragment */
-				frag_addr = buf_info[frag_idx].dma_addr;
-				frag_rem = buf_info[frag_idx].len;
-				frag_idx++;
+				frag_addr = buf_info->dma_addr;
+				frag_rem = buf_info->len;
+				buf_info++;
 			}
 			chunk_len = min(frag_rem, seg_rem);
 			if (!desc) {
 				/* fill main descriptor */
-				desc = ionic_tx_tso_next(q, &elem);
+				desc = desc_info->txq_desc;
+				elem = desc_info->txq_sg_desc->elems;
 				desc_addr = frag_addr;
 				desc_len = chunk_len;
 			} else {
@@ -933,16 +930,15 @@ static int ionic_tx_tso(struct ionic_queue *q, struct sk_buff *skb)
 		}
 		seg_rem = min(tso_rem, mss);
 		done = (tso_rem == 0);
-		if (done) {
-			memcpy(&q->info[q->head_idx].bufs, buf_info, sizeof(buf_info));
-			q->info[q->head_idx].nbufs = nfrags + 1;
-		}
 		/* post descriptor */
 		ionic_tx_tso_post(q, desc, skb,
 				  desc_addr, desc_nsge, desc_len,
 				  hdrlen, mss, outer_csum, vlan_tci, has_vlan,
 				  start, done);
 		start = false;
+		/* Buffer information is stored with the first tso descriptor */
+		desc_info = &q->info[q->head_idx];
+		desc_info->nbufs = 0;
 	}
 
 	stats->pkts += DIV_ROUND_UP(len - hdrlen, mss);
@@ -953,12 +949,12 @@ static int ionic_tx_tso(struct ionic_queue *q, struct sk_buff *skb)
 	return 0;
 }
 
-static int ionic_tx_calc_csum(struct ionic_queue *q, struct sk_buff *skb)
+static int ionic_tx_calc_csum(struct ionic_queue *q, struct sk_buff *skb,
+			      struct ionic_desc_info *desc_info)
 {
-	struct ionic_txq_desc *desc = q->info[q->head_idx].txq_desc;
+	struct ionic_txq_desc *desc = desc_info->txq_desc;
+	struct ionic_buf_info *buf_info = desc_info->bufs;
 	struct ionic_tx_stats *stats = q_to_tx_stats(q);
-	struct device *dev = q->dev;
-	dma_addr_t dma_addr;
 	bool has_vlan;
 	u8 flags = 0;
 	bool encap;
@@ -967,23 +963,22 @@ static int ionic_tx_calc_csum(struct ionic_queue *q, struct sk_buff *skb)
 	has_vlan = !!skb_vlan_tag_present(skb);
 	encap = skb->encapsulation;
 
-	dma_addr = ionic_tx_map_single(q, skb->data, skb_headlen(skb));
-	if (dma_mapping_error(dev, dma_addr))
-		return -ENOMEM;
-
 	flags |= has_vlan ? IONIC_TXQ_DESC_FLAG_VLAN : 0;
 	flags |= encap ? IONIC_TXQ_DESC_FLAG_ENCAP : 0;
 
 	cmd = encode_txq_desc_cmd(IONIC_TXQ_DESC_OPCODE_CSUM_PARTIAL,
-				  flags, skb_shinfo(skb)->nr_frags, dma_addr);
+				  flags, skb_shinfo(skb)->nr_frags,
+				  buf_info->dma_addr);
 	desc->cmd = cpu_to_le64(cmd);
-	desc->len = cpu_to_le16(skb_headlen(skb));
-	desc->csum_start = cpu_to_le16(skb_checksum_start_offset(skb));
-	desc->csum_offset = cpu_to_le16(skb->csum_offset);
+	desc->len = cpu_to_le16(buf_info->len);
 	if (has_vlan) {
 		desc->vlan_tci = cpu_to_le16(skb_vlan_tag_get(skb));
 		stats->vlan_inserted++;
+	} else {
+		desc->vlan_tci = 0;
 	}
+	desc->csum_start = cpu_to_le16(skb_checksum_start_offset(skb));
+	desc->csum_offset = cpu_to_le16(skb->csum_offset);
 
 	if (skb_csum_is_sctp(skb))
 		stats->crc32_csum++;
@@ -993,12 +988,12 @@ static int ionic_tx_calc_csum(struct ionic_queue *q, struct sk_buff *skb)
 	return 0;
 }
 
-static int ionic_tx_calc_no_csum(struct ionic_queue *q, struct sk_buff *skb)
+static int ionic_tx_calc_no_csum(struct ionic_queue *q, struct sk_buff *skb,
+				 struct ionic_desc_info *desc_info)
 {
-	struct ionic_txq_desc *desc = q->info[q->head_idx].txq_desc;
+	struct ionic_txq_desc *desc = desc_info->txq_desc;
+	struct ionic_buf_info *buf_info = desc_info->bufs;
 	struct ionic_tx_stats *stats = q_to_tx_stats(q);
-	struct device *dev = q->dev;
-	dma_addr_t dma_addr;
 	bool has_vlan;
 	u8 flags = 0;
 	bool encap;
@@ -1007,67 +1002,66 @@ static int ionic_tx_calc_no_csum(struct ionic_queue *q, struct sk_buff *skb)
 	has_vlan = !!skb_vlan_tag_present(skb);
 	encap = skb->encapsulation;
 
-	dma_addr = ionic_tx_map_single(q, skb->data, skb_headlen(skb));
-	if (dma_mapping_error(dev, dma_addr))
-		return -ENOMEM;
-
 	flags |= has_vlan ? IONIC_TXQ_DESC_FLAG_VLAN : 0;
 	flags |= encap ? IONIC_TXQ_DESC_FLAG_ENCAP : 0;
 
 	cmd = encode_txq_desc_cmd(IONIC_TXQ_DESC_OPCODE_CSUM_NONE,
-				  flags, skb_shinfo(skb)->nr_frags, dma_addr);
+				  flags, skb_shinfo(skb)->nr_frags,
+				  buf_info->dma_addr);
 	desc->cmd = cpu_to_le64(cmd);
-	desc->len = cpu_to_le16(skb_headlen(skb));
+	desc->len = cpu_to_le16(buf_info->len);
 	if (has_vlan) {
 		desc->vlan_tci = cpu_to_le16(skb_vlan_tag_get(skb));
 		stats->vlan_inserted++;
+	} else {
+		desc->vlan_tci = 0;
 	}
+	desc->csum_start = 0;
+	desc->csum_offset = 0;
 
 	stats->csum_none++;
 
 	return 0;
 }
 
-static int ionic_tx_skb_frags(struct ionic_queue *q, struct sk_buff *skb)
+static int ionic_tx_skb_frags(struct ionic_queue *q, struct sk_buff *skb,
+			      struct ionic_desc_info *desc_info)
 {
-	struct ionic_txq_sg_desc *sg_desc = q->info[q->head_idx].txq_sg_desc;
-	unsigned int len_left = skb->len - skb_headlen(skb);
+	struct ionic_txq_sg_desc *sg_desc = desc_info->txq_sg_desc;
+	struct ionic_buf_info *buf_info = &desc_info->bufs[1];
 	struct ionic_txq_sg_elem *elem = sg_desc->elems;
 	struct ionic_tx_stats *stats = q_to_tx_stats(q);
-	struct device *dev = q->dev;
-	dma_addr_t dma_addr;
-	skb_frag_t *frag;
-	u16 len;
+	unsigned int i;
 
-	for (frag = skb_shinfo(skb)->frags; len_left; frag++, elem++) {
-		len = skb_frag_size(frag);
-		elem->len = cpu_to_le16(len);
-		dma_addr = ionic_tx_map_frag(q, frag, 0, len);
-		if (dma_mapping_error(dev, dma_addr))
-			return -ENOMEM;
-		elem->addr = cpu_to_le64(dma_addr);
-		len_left -= len;
-		stats->frags++;
+	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++, buf_info++, elem++) {
+		elem->addr = cpu_to_le64(buf_info->dma_addr);
+		elem->len = cpu_to_le16(buf_info->len);
 	}
 
+	stats->frags += skb_shinfo(skb)->nr_frags;
+
 	return 0;
 }
 
 static int ionic_tx(struct ionic_queue *q, struct sk_buff *skb)
 {
+	struct ionic_desc_info *desc_info = &q->info[q->head_idx];
 	struct ionic_tx_stats *stats = q_to_tx_stats(q);
 	int err;
 
+	if (unlikely(ionic_tx_map_skb(q, skb, desc_info)))
+		return -EIO;
+
 	/* set up the initial descriptor */
 	if (skb->ip_summed == CHECKSUM_PARTIAL)
-		err = ionic_tx_calc_csum(q, skb);
+		err = ionic_tx_calc_csum(q, skb, desc_info);
 	else
-		err = ionic_tx_calc_no_csum(q, skb);
+		err = ionic_tx_calc_no_csum(q, skb, desc_info);
 	if (err)
 		return err;
 
 	/* add frags */
-	err = ionic_tx_skb_frags(q, skb);
+	err = ionic_tx_skb_frags(q, skb, desc_info);
 	if (err)
 		return err;
 
-- 
2.17.1

