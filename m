Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E208D10978
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 16:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbfEAOpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 10:45:11 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:49352 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727082AbfEAOpC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 10:45:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=L5inO2MdptwVhYfeiB1Ep3i6nE0Ul52PHndwz3iqKCc=; b=X+5dXxjKDHue9SlzBdDzb67zY
        z8wjq2fvMENoFa/ZosJF3wTzOyw4Mit4mvPBWr0y2+gT5OsSGriLVTIENhOv/pWSyyVZKfh+GmLF8
        mfijUX2CcOhlWoXTX5gbLzkU+B35sWDQuQ78p7UrIiGnSdCjosWszWQ6eoxMq14e+E5/cyxjg+yXr
        imhm5LcGcwxWhJC/14dZUOMoni9XIHEfFV1mPX4BFEDuzPMPQx5Ft97xsyxQHClNkD7QNI0vhg4XB
        x+8tTXbvUWs3hdvQAAhpYhEgsmTKAy6k0T3sRRFHahI93Ad1eHj0RIj4G5FNSXq2leraw6WYMs022
        nQBQQFPpg==;
Received: from willy by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hLqTk-00025k-0p; Wed, 01 May 2019 14:45:00 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     davem@davemloft.net
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>, hch@lst.de,
        netdev@vger.kernel.org
Subject: [PATCH v2 4/7] net: Use skb accessors in network core
Date:   Wed,  1 May 2019 07:44:54 -0700
Message-Id: <20190501144457.7942-5-willy@infradead.org>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20190501144457.7942-1-willy@infradead.org>
References: <20190501144457.7942-1-willy@infradead.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

In preparation for renaming skb_frag_t members, use the fine accessors
which already exist.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 net/core/skbuff.c    | 22 +++++++++++++---------
 net/core/tso.c       |  8 ++++----
 net/ipv4/tcp.c       | 12 +++++++-----
 net/kcm/kcmsock.c    |  8 ++++----
 net/tls/tls_device.c | 14 +++++++-------
 5 files changed, 35 insertions(+), 29 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 40796b8bf820..b689e13be808 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2325,19 +2325,19 @@ int skb_send_sock_locked(struct sock *sk, struct sk_buff *skb, int offset,
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
@@ -2809,11 +2809,15 @@ skb_zerocopy(struct sk_buff *to, struct sk_buff *from, int len, int hlen)
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
@@ -3459,10 +3463,10 @@ static inline skb_frag_t skb_head_frag_to_page_desc(struct sk_buff *frag_skb)
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
 
@@ -3855,7 +3859,7 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
 
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
index 6baa6dc1b13b..1a4c2efb03f8 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1801,19 +1801,21 @@ static int tcp_zerocopy_receive(struct sock *sk,
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
diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index 44fdc641710d..9a16a4d2a83a 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -638,15 +638,15 @@ static int kcm_write_msgs(struct kcm_sock *kcm)
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
@@ -681,7 +681,7 @@ static int kcm_write_msgs(struct kcm_sock *kcm)
 			sent += ret;
 			frag_offset += ret;
 			KCM_STATS_ADD(psock->stats.tx_bytes, ret);
-			if (frag_offset < frag->size) {
+			if (frag_offset < skb_frag_size(frag)) {
 				/* Not finished with this frag */
 				goto do_frag;
 			}
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index cc0256939eb6..80c5776e3ec0 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -233,14 +233,14 @@ static void tls_append_frag(struct tls_record_info *record,
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
@@ -287,8 +287,8 @@ static int tls_push_record(struct sock *sk,
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

