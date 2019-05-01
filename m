Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02A6F10C81
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 19:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbfEAR4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 13:56:06 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:43216 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbfEAR4G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 13:56:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=vtf5983kAwdwRcJoK8YBWMJEtNZvr4pAWg3yK7xtt/U=; b=VJ+G+iGFYm/qUouhWijOYsFHS
        z9FdOkIF/bW3+DAC6YwugtySXsEJvTcePqWqAPkdp2aZ43PWg3xKGyXyAUZb3Da8j9ywFHlJ7tn9b
        FHS6hs/O+c1ZWrPPXil1uQBQ3jBFVg+HyLI5FMcyVUFKttH7C6f/Tf4xRbOsFjFb+617WZCWxupPp
        TfRomOawmHJi/JAUXRQuX+OuJ31TrC9G7UCCVuURUIaj7oSCAChxc0lVu4CWhRVHAgtLJ7LkVm5Is
        VgdgZ7tgR4qlMnF7IgLqsYQHlVA5VCF5NmdTRgGGqGHcoCpLAJ6VpYwmz2cgzx3ukYUdZcQrmVOTn
        UW51hp3nA==;
Received: from willy by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hLtSf-0007dl-8W; Wed, 01 May 2019 17:56:05 +0000
Date:   Wed, 1 May 2019 10:56:05 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     davem@davemloft.net
Cc:     hch@lst.de, netdev@vger.kernel.org
Subject: Re: [PATCH v2 3/7] net: Use skb accessors in network drivers
Message-ID: <20190501175604.GA28500@bombadil.infradead.org>
References: <20190501144457.7942-1-willy@infradead.org>
 <20190501144457.7942-4-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190501144457.7942-4-willy@infradead.org>
User-Agent: Mutt/1.9.2 (2017-12-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 01, 2019 at 07:44:53AM -0700, Matthew Wilcox wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> In preparation for renaming skb_frag fields, use the fine accessors which
> already exist.

It turns out not all network drivers are under drivers/net.  And others
aren't built on x86 by allyesconfig.

I'll fold this into a future v3.

diff --git a/drivers/crypto/chelsio/chtls/chtls_io.c b/drivers/crypto/chelsio/chtls/chtls_io.c
index 1285a1bceda7..8bfbdb003a20 100644
--- a/drivers/crypto/chelsio/chtls/chtls_io.c
+++ b/drivers/crypto/chelsio/chtls/chtls_io.c
@@ -1137,7 +1137,9 @@ int chtls_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 			}
 			/* Update the skb. */
 			if (merge) {
-				skb_shinfo(skb)->frags[i - 1].size += copy;
+				skb_frag_size_add(
+						&skb_shinfo(skb)->frags[i - 1],
+						copy);
 			} else {
 				skb_fill_page_desc(skb, i, page, off, copy);
 				if (off + copy < pg_size) {
@@ -1250,7 +1252,7 @@ int chtls_sendpage(struct sock *sk, struct page *page,
 
 		i = skb_shinfo(skb)->nr_frags;
 		if (skb_can_coalesce(skb, i, page, offset)) {
-			skb_shinfo(skb)->frags[i - 1].size += copy;
+			skb_frag_size_add(&skb_shinfo(skb)->frags[i - 1], copy);
 		} else if (i < MAX_SKB_FRAGS) {
 			get_page(page);
 			skb_fill_page_desc(skb, i, page, offset, copy);
diff --git a/drivers/hsi/clients/ssi_protocol.c b/drivers/hsi/clients/ssi_protocol.c
index 9f506c00ad85..7e43559a8652 100644
--- a/drivers/hsi/clients/ssi_protocol.c
+++ b/drivers/hsi/clients/ssi_protocol.c
@@ -194,7 +194,7 @@ static void ssip_skb_to_msg(struct sk_buff *skb, struct hsi_msg *msg)
 		sg = sg_next(sg);
 		BUG_ON(!sg);
 		frag = &skb_shinfo(skb)->frags[i];
-		sg_set_page(sg, skb_page_frag(frag), frag->size,
+		sg_set_page(sg, skb_frag_page(frag), skb_frag_size(frag),
 				frag->page_offset);
 	}
 }
diff --git a/drivers/staging/unisys/visornic/visornic_main.c b/drivers/staging/unisys/visornic/visornic_main.c
index 1c1a470d2e50..bbfc4befcec2 100644
--- a/drivers/staging/unisys/visornic/visornic_main.c
+++ b/drivers/staging/unisys/visornic/visornic_main.c
@@ -285,8 +285,8 @@ static int visor_copy_fragsinfo_from_skb(struct sk_buff *skb,
 			count = add_physinfo_entries(page_to_pfn(
 				  skb_frag_page(&skb_shinfo(skb)->frags[frag])),
 				  skb_shinfo(skb)->frags[frag].page_offset,
-				  skb_shinfo(skb)->frags[frag].size, count,
-				  frags_max, frags);
+				  skb_frag_size(&skb_shinfo(skb)->frags[frag]),
+				  count, frags_max, frags);
 			/* add_physinfo_entries only returns
 			 * zero if the frags array is out of room
 			 * That should never happen because we
diff --git a/drivers/target/iscsi/cxgbit/cxgbit_target.c b/drivers/target/iscsi/cxgbit/cxgbit_target.c
index 9cac100b3169..9121dce05269 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_target.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_target.c
@@ -1406,7 +1406,8 @@ static void cxgbit_lro_skb_dump(struct sk_buff *skb)
 			pdu_cb->ddigest, pdu_cb->frags);
 	for (i = 0; i < ssi->nr_frags; i++)
 		pr_info("skb 0x%p, frag %d, off %u, sz %u.\n",
-			skb, i, ssi->frags[i].page_offset, ssi->frags[i].size);
+			skb, i, ssi->frags[i].page_offset,
+			skb_frag_size(&ssi->frags[i]));
 }
 
 static void cxgbit_lro_hskb_reset(struct cxgbit_sock *csk)
@@ -1450,7 +1451,7 @@ cxgbit_lro_skb_merge(struct cxgbit_sock *csk, struct sk_buff *skb, u8 pdu_idx)
 		hpdu_cb->frags++;
 		hpdu_cb->hfrag_idx = hfrag_idx;
 
-		len = hssi->frags[hfrag_idx].size;
+		len = skb_frag_size(&hssi->frags[hfrag_idx]);;
 		hskb->len += len;
 		hskb->data_len += len;
 		hskb->truesize += len;
@@ -1470,7 +1471,7 @@ cxgbit_lro_skb_merge(struct cxgbit_sock *csk, struct sk_buff *skb, u8 pdu_idx)
 
 			get_page(skb_frag_page(&hssi->frags[dfrag_idx]));
 
-			len += hssi->frags[dfrag_idx].size;
+			len += skb_frag_size(&hssi->frags[dfrag_idx]);
 
 			hssi->nr_frags++;
 			hpdu_cb->frags++;
