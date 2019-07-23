Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6410F70F8D
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 05:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387876AbfGWDIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 23:08:41 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:36384 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387867AbfGWDIj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 23:08:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=0IvlViPyxl+f+SF9gkfdNHcrlY6HkdmhrUpT65kWPVg=; b=ILaLKm5Smv8+NsRNN/JuFR2nk+
        EDYsO2lSRXu7hsLC7rQudgOYgHevU6W2BD69R/vaKZrteLWLB0ylnVB70dQqeW262NBc0lWCzIn2h
        tbsHChOIfw1aos3MiFzhGlWjfbjK9WZwfsNrJFO387D1q7vXj5SDdASl5iDQ0cty7jHOaaNg3VXI+
        Mugh+y40vFxlpmlaG98tv7bB2V4CGUqZMdRvoZHUxurnh9Hi3H2UUH/zVMtlkzu2iDGfvuOo7xdTT
        eEEoMttzDehOmTuvVoVz4xm8B7KnAQ7OYDK5ViPU4vCF/A7gcaDCXrbJrs/harpN+/762WU8wYavd
        jOIgVJeQ==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hplAJ-00036f-Bq; Tue, 23 Jul 2019 03:08:35 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     davem@davemloft.net
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>, hch@lst.de,
        netdev@vger.kernel.org
Subject: [PATCH v3 2/7] net: Use skb accessors in network core
Date:   Mon, 22 Jul 2019 20:08:26 -0700
Message-Id: <20190723030831.11879-3-willy@infradead.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190723030831.11879-1-willy@infradead.org>
References: <20190723030831.11879-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

In preparation for unifying the skb_frag and bio_vec, use the fine
accessors which already exist and use skb_frag_t instead of
struct skb_frag_struct.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/skbuff.h |  2 +-
 net/core/skbuff.c      | 24 ++++++++++++++----------
 net/core/tso.c         |  8 ++++----
 net/ipv4/tcp.c         | 14 ++++++++------
 net/kcm/kcmsock.c      |  8 ++++----
 net/tls/tls_device.c   | 14 +++++++-------
 6 files changed, 38 insertions(+), 32 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index d8af86d995d6..f9078e7edb53 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3166,7 +3166,7 @@ static inline bool skb_can_coalesce(struct sk_buff *skb, int i,
 	if (skb_zcopy(skb))
 		return false;
 	if (i) {
-		const struct skb_frag_struct *frag = &skb_shinfo(skb)->frags[i - 1];
+		const skb_frag_t *frag = &skb_shinfo(skb)->frags[i - 1];
 
 		return page == skb_frag_page(frag) &&
 		       off == frag->page_offset + skb_frag_size(frag);
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 6f1e31f674a3..e32081709a0d 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2485,19 +2485,19 @@ int skb_send_sock_locked(struct sock *sk, struct sk_buff *skb, int offset,
 	for (fragidx = 0; fragidx < skb_shinfo(skb)->nr_frags; fragidx++) {
 		skb_frag_t *frag  = &skb_shinfo(skb)->frags[fragidx];
 
-		if (offset < frag->size)
+		if (offset < skb_frag_size(frag))
 			break;
 
-		offset -= frag->size;
+		offset -= skb_frag_size(frag);
 	}
 
 	for (; len && fragidx < skb_shinfo(skb)->nr_frags; fragidx++) {
 		skb_frag_t *frag  = &skb_shinfo(skb)->frags[fragidx];
 
-		slen = min_t(size_t, len, frag->size - offset);
+		slen = min_t(size_t, len, skb_frag_size(frag) - offset);
 
 		while (slen) {
-			ret = kernel_sendpage_locked(sk, frag->page.p,
+			ret = kernel_sendpage_locked(sk, skb_frag_page(frag),
 						     frag->page_offset + offset,
 						     slen, MSG_DONTWAIT);
 			if (ret <= 0)
@@ -2975,11 +2975,15 @@ skb_zerocopy(struct sk_buff *to, struct sk_buff *from, int len, int hlen)
 	skb_zerocopy_clone(to, from, GFP_ATOMIC);
 
 	for (i = 0; i < skb_shinfo(from)->nr_frags; i++) {
+		int size;
+
 		if (!len)
 			break;
 		skb_shinfo(to)->frags[j] = skb_shinfo(from)->frags[i];
-		skb_shinfo(to)->frags[j].size = min_t(int, skb_shinfo(to)->frags[j].size, len);
-		len -= skb_shinfo(to)->frags[j].size;
+		size = min_t(int, skb_frag_size(&skb_shinfo(to)->frags[j]),
+					len);
+		skb_frag_size_set(&skb_shinfo(to)->frags[j], size);
+		len -= size;
 		skb_frag_ref(to, j);
 		j++;
 	}
@@ -3293,7 +3297,7 @@ static int skb_prepare_for_shift(struct sk_buff *skb)
 int skb_shift(struct sk_buff *tgt, struct sk_buff *skb, int shiftlen)
 {
 	int from, to, merge, todo;
-	struct skb_frag_struct *fragfrom, *fragto;
+	skb_frag_t *fragfrom, *fragto;
 
 	BUG_ON(shiftlen > skb->len);
 
@@ -3625,10 +3629,10 @@ static inline skb_frag_t skb_head_frag_to_page_desc(struct sk_buff *frag_skb)
 	struct page *page;
 
 	page = virt_to_head_page(frag_skb->head);
-	head_frag.page.p = page;
+	__skb_frag_set_page(&head_frag, page);
 	head_frag.page_offset = frag_skb->data -
 		(unsigned char *)page_address(page);
-	head_frag.size = skb_headlen(frag_skb);
+	skb_frag_size_set(&head_frag, skb_headlen(frag_skb));
 	return head_frag;
 }
 
@@ -4021,7 +4025,7 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
 
 		pinfo->nr_frags = nr_frags + 1 + skbinfo->nr_frags;
 
-		frag->page.p	  = page;
+		__skb_frag_set_page(frag, page);
 		frag->page_offset = first_offset;
 		skb_frag_size_set(frag, first_size);
 
diff --git a/net/core/tso.c b/net/core/tso.c
index 43f4eba61933..d4d5c077ad72 100644
--- a/net/core/tso.c
+++ b/net/core/tso.c
@@ -55,8 +55,8 @@ void tso_build_data(struct sk_buff *skb, struct tso_t *tso, int size)
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[tso->next_frag_idx];
 
 		/* Move to next segment */
-		tso->size = frag->size;
-		tso->data = page_address(frag->page.p) + frag->page_offset;
+		tso->size = skb_frag_size(frag);
+		tso->data = skb_frag_address(frag);
 		tso->next_frag_idx++;
 	}
 }
@@ -79,8 +79,8 @@ void tso_start(struct sk_buff *skb, struct tso_t *tso)
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[tso->next_frag_idx];
 
 		/* Move to next segment */
-		tso->size = frag->size;
-		tso->data = page_address(frag->page.p) + frag->page_offset;
+		tso->size = skb_frag_size(frag);
+		tso->data = skb_frag_address(frag);
 		tso->next_frag_idx++;
 	}
 }
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 7846afacdf0b..bb14c7c72f3c 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1776,19 +1776,21 @@ static int tcp_zerocopy_receive(struct sock *sk,
 				break;
 			frags = skb_shinfo(skb)->frags;
 			while (offset) {
-				if (frags->size > offset)
+				if (skb_frag_size(frags) > offset)
 					goto out;
-				offset -= frags->size;
+				offset -= skb_frag_size(frags);
 				frags++;
 			}
 		}
-		if (frags->size != PAGE_SIZE || frags->page_offset) {
+		if (skb_frag_size(frags) != PAGE_SIZE || frags->page_offset) {
 			int remaining = zc->recv_skip_hint;
+			int size = skb_frag_size(frags);
 
-			while (remaining && (frags->size != PAGE_SIZE ||
+			while (remaining && (size != PAGE_SIZE ||
 					     frags->page_offset)) {
-				remaining -= frags->size;
+				remaining -= size;
 				frags++;
+				size = skb_frag_size(frags);
 			}
 			zc->recv_skip_hint -= remaining;
 			break;
@@ -3779,7 +3781,7 @@ int tcp_md5_hash_skb_data(struct tcp_md5sig_pool *hp,
 		return 1;
 
 	for (i = 0; i < shi->nr_frags; ++i) {
-		const struct skb_frag_struct *f = &shi->frags[i];
+		const skb_frag_t *f = &shi->frags[i];
 		unsigned int offset = f->page_offset;
 		struct page *page = skb_frag_page(f) + (offset >> PAGE_SHIFT);
 
diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index 5dbc0c48f8cb..05f63c4300e9 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -635,15 +635,15 @@ static int kcm_write_msgs(struct kcm_sock *kcm)
 			frag_offset = 0;
 do_frag:
 			frag = &skb_shinfo(skb)->frags[fragidx];
-			if (WARN_ON(!frag->size)) {
+			if (WARN_ON(!skb_frag_size(frag))) {
 				ret = -EINVAL;
 				goto out;
 			}
 
 			ret = kernel_sendpage(psock->sk->sk_socket,
-					      frag->page.p,
+					      skb_frag_page(frag),
 					      frag->page_offset + frag_offset,
-					      frag->size - frag_offset,
+					      skb_frag_size(frag) - frag_offset,
 					      MSG_DONTWAIT);
 			if (ret <= 0) {
 				if (ret == -EAGAIN) {
@@ -678,7 +678,7 @@ static int kcm_write_msgs(struct kcm_sock *kcm)
 			sent += ret;
 			frag_offset += ret;
 			KCM_STATS_ADD(psock->stats.tx_bytes, ret);
-			if (frag_offset < frag->size) {
+			if (frag_offset < skb_frag_size(frag)) {
 				/* Not finished with this frag */
 				goto do_frag;
 			}
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 7c0b2b778703..4ec8a06fa5d1 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -243,14 +243,14 @@ static void tls_append_frag(struct tls_record_info *record,
 	skb_frag_t *frag;
 
 	frag = &record->frags[record->num_frags - 1];
-	if (frag->page.p == pfrag->page &&
-	    frag->page_offset + frag->size == pfrag->offset) {
-		frag->size += size;
+	if (skb_frag_page(frag) == pfrag->page &&
+	    frag->page_offset + skb_frag_size(frag) == pfrag->offset) {
+		skb_frag_size_add(frag, size);
 	} else {
 		++frag;
-		frag->page.p = pfrag->page;
+		__skb_frag_set_page(frag, pfrag->page);
 		frag->page_offset = pfrag->offset;
-		frag->size = size;
+		skb_frag_size_set(frag, size);
 		++record->num_frags;
 		get_page(pfrag->page);
 	}
@@ -301,8 +301,8 @@ static int tls_push_record(struct sock *sk,
 		frag = &record->frags[i];
 		sg_unmark_end(&offload_ctx->sg_tx_data[i]);
 		sg_set_page(&offload_ctx->sg_tx_data[i], skb_frag_page(frag),
-			    frag->size, frag->page_offset);
-		sk_mem_charge(sk, frag->size);
+			    skb_frag_size(frag), frag->page_offset);
+		sk_mem_charge(sk, skb_frag_size(frag));
 		get_page(skb_frag_page(frag));
 	}
 	sg_mark_end(&offload_ctx->sg_tx_data[record->num_frags - 1]);
-- 
2.20.1

