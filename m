Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1905BD4F76
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 13:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729274AbfJLL5K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 07:57:10 -0400
Received: from shells.gnugeneration.com ([66.240.222.126]:35814 "EHLO
        shells.gnugeneration.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728979AbfJLLzJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 07:55:09 -0400
Received: by shells.gnugeneration.com (Postfix, from userid 1000)
        id 85B511A40556; Sat, 12 Oct 2019 04:55:09 -0700 (PDT)
Date:   Sat, 12 Oct 2019 04:55:09 -0700
From:   Vito Caputo <vcaputo@pengaru.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: core: datagram: tidy up copy functions a bit
Message-ID: <20191012115509.jrqe43yozs7kknv5@shells.gnugeneration.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eliminate some verbosity by using min() macro and consolidating some
things, also fix inconsistent zero tests (! vs. == 0).

Signed-off-by: Vito Caputo <vcaputo@pengaru.com>
---
 net/core/datagram.c | 44 ++++++++++++++------------------------------
 1 file changed, 14 insertions(+), 30 deletions(-)

diff --git a/net/core/datagram.c b/net/core/datagram.c
index 4cc8dc5db2b7..08d403f93952 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -413,13 +413,11 @@ static int __skb_datagram_iter(const struct sk_buff *skb, int offset,
 					    struct iov_iter *), void *data)
 {
 	int start = skb_headlen(skb);
-	int i, copy = start - offset, start_off = offset, n;
+	int i, copy, start_off = offset, n;
 	struct sk_buff *frag_iter;
 
 	/* Copy header. */
-	if (copy > 0) {
-		if (copy > len)
-			copy = len;
+	if ((copy = min(start - offset, len)) > 0) {
 		n = cb(skb->data + offset, copy, data, to);
 		offset += n;
 		if (n != copy)
@@ -430,39 +428,33 @@ static int __skb_datagram_iter(const struct sk_buff *skb, int offset,
 
 	/* Copy paged appendix. Hmm... why does this look so complicated? */
 	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
-		int end;
 		const skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
+		int end = start + skb_frag_size(frag);
 
 		WARN_ON(start > offset + len);
 
-		end = start + skb_frag_size(frag);
-		if ((copy = end - offset) > 0) {
+		if ((copy = min(end - offset, len)) > 0) {
 			struct page *page = skb_frag_page(frag);
 			u8 *vaddr = kmap(page);
 
-			if (copy > len)
-				copy = len;
 			n = cb(vaddr + skb_frag_off(frag) + offset - start,
 			       copy, data, to);
 			kunmap(page);
 			offset += n;
 			if (n != copy)
 				goto short_copy;
-			if (!(len -= copy))
+			if ((len -= copy) == 0)
 				return 0;
 		}
 		start = end;
 	}
 
 	skb_walk_frags(skb, frag_iter) {
-		int end;
+		int end = start + frag_iter->len;
 
 		WARN_ON(start > offset + len);
 
-		end = start + frag_iter->len;
-		if ((copy = end - offset) > 0) {
-			if (copy > len)
-				copy = len;
+		if ((copy = min(end - offset, len)) > 0) {
 			if (__skb_datagram_iter(frag_iter, offset - start,
 						to, copy, fault_short, cb, data))
 				goto fault;
@@ -545,13 +537,11 @@ int skb_copy_datagram_from_iter(struct sk_buff *skb, int offset,
 				 int len)
 {
 	int start = skb_headlen(skb);
-	int i, copy = start - offset;
 	struct sk_buff *frag_iter;
+	int i, copy;
 
 	/* Copy header. */
-	if (copy > 0) {
-		if (copy > len)
-			copy = len;
+	if ((copy = min(start - offset, len)) > 0) {
 		if (copy_from_iter(skb->data + offset, copy, from) != copy)
 			goto fault;
 		if ((len -= copy) == 0)
@@ -561,24 +551,21 @@ int skb_copy_datagram_from_iter(struct sk_buff *skb, int offset,
 
 	/* Copy paged appendix. Hmm... why does this look so complicated? */
 	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
-		int end;
 		const skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
+		int end = start + skb_frag_size(frag);
 
 		WARN_ON(start > offset + len);
 
-		end = start + skb_frag_size(frag);
-		if ((copy = end - offset) > 0) {
+		if ((copy = min(end - offset, len)) > 0) {
 			size_t copied;
 
-			if (copy > len)
-				copy = len;
 			copied = copy_page_from_iter(skb_frag_page(frag),
 					  skb_frag_off(frag) + offset - start,
 					  copy, from);
 			if (copied != copy)
 				goto fault;
 
-			if (!(len -= copy))
+			if ((len -= copy) == 0)
 				return 0;
 			offset += copy;
 		}
@@ -586,14 +573,11 @@ int skb_copy_datagram_from_iter(struct sk_buff *skb, int offset,
 	}
 
 	skb_walk_frags(skb, frag_iter) {
-		int end;
+		int end = start + frag_iter->len;
 
 		WARN_ON(start > offset + len);
 
-		end = start + frag_iter->len;
-		if ((copy = end - offset) > 0) {
-			if (copy > len)
-				copy = len;
+		if ((copy = min(end - offset, len)) > 0) {
 			if (skb_copy_datagram_from_iter(frag_iter,
 							offset - start,
 							from, copy))
-- 
2.11.0

