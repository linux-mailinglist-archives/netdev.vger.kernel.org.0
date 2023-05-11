Return-Path: <netdev+bounces-1629-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F1016FE948
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 03:21:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ABB0E28155B
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 01:21:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E18D081E;
	Thu, 11 May 2023 01:20:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5038063A
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 01:20:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3F63C433A1;
	Thu, 11 May 2023 01:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683768043;
	bh=b8az4R8dYUkWGYWi4C0EGW3MFAb1E2wtwl10OTR/PRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iN5FUsOsHYXyLEk8jf31+CJ5LP9gdlgU7tEMC+3icwVUhQEu21XKx4HCLbNvSEZFu
	 RHRGC9t1EfJamPyCOOJQNVDqY+XUF57HOkjqynhGiYpfovqTsUYKrKCDkbNxqwSIj4
	 GQp3LZxTqsDH9lpnl8FWyfJ1RvKvzjuanq+at591UQeZe3GNJJfTmt99qYy6N9cqa/
	 QQPi2bIMeoPxqVbxS21YS0qVplJoBQ1PZY4jLPb35xVEHfkMA/lQfsMwLpJLLlJyHX
	 5g3U7Wxl992yjaH4TAKKJF8eoexsNflc3lXY6xO09pInsGkb6sq3qv+e4VQBUIEqen
	 fasEwfu69yDnQ==
From: Jakub Kicinski <kuba@kernel.org>
To: tariqt@nvidia.com
Cc: netdev@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>
Subject: [RFC / RFT net 4/7] tls: rx: strp: fix determining record length in copy mode
Date: Wed, 10 May 2023 18:20:31 -0700
Message-Id: <20230511012034.902782-5-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230511012034.902782-1-kuba@kernel.org>
References: <20230511012034.902782-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We call tls_rx_msg_size(skb) before doing skb->len += chunk.
So the tls_rx_msg_size() code will see old skb->len, most
likely leading to an over-read.

Worst case we will over read an entire record, next iteration
will try to trim the skb but may end up turning frag len negative
or discarding the subsequent record (since we already told TCP
we've read it during previous read but now we'll trim it out of
the skb).

Fixes: 84c61fe1a75b ("tls: rx: do not use the standard strparser")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_strp.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/net/tls/tls_strp.c b/net/tls/tls_strp.c
index 9a125c28da88..7b0c8145ace6 100644
--- a/net/tls/tls_strp.c
+++ b/net/tls/tls_strp.c
@@ -210,19 +210,28 @@ static int tls_strp_copyin(read_descriptor_t *desc, struct sk_buff *in_skb,
 					   skb_frag_size(frag),
 					   chunk));
 
-		sz = tls_rx_msg_size(strp, strp->anchor);
+		skb->len += chunk;
+		skb->data_len += chunk;
+		skb_frag_size_add(frag, chunk);
+
+		sz = tls_rx_msg_size(strp, skb);
 		if (sz < 0) {
 			desc->error = sz;
 			return 0;
 		}
 
 		/* We may have over-read, sz == 0 is guaranteed under-read */
-		if (sz > 0)
-			chunk =	min_t(size_t, chunk, sz - skb->len);
+		if (unlikely(sz && sz < skb->len)) {
+			int over = skb->len - sz;
+
+			WARN_ON_ONCE(over > chunk);
+			skb->len -= over;
+			skb->data_len -= over;
+			skb_frag_size_add(frag, -over);
+
+			chunk -= over;
+		}
 
-		skb->len += chunk;
-		skb->data_len += chunk;
-		skb_frag_size_add(frag, chunk);
 		frag++;
 		len -= chunk;
 		offset += chunk;
-- 
2.40.1


