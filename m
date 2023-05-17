Return-Path: <netdev+bounces-3150-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A19E705CA5
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 03:51:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2546A1C20D7C
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 01:51:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1718117E0;
	Wed, 17 May 2023 01:50:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7149917F6
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 01:50:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4D35C433A4;
	Wed, 17 May 2023 01:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684288255;
	bh=6Soro1dxCF7Dyji58n7ohJvkvcrWw/+daCIt6x9qrAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ngMFZRaUXM9F3dKDyFvALxISZq8dYx236NMG+l+89Is3j8Vo5y64Ef7yVMZ8pGBa2
	 VPf+njQeLIGhlzj7/Stipc64zexS11go5oEHiiFLt/ICEuZabll0Xp6ic2YyaDnYb1
	 4kyziahZ9xgw4ihkzB+mPsQLYeF97jEgCWZxyzVHy9k6UrbRuztbmhLtIvUL4E3hiE
	 KTAJ7C3KRKj0Cw5GqQ/SRp7+gN6le74UmmU6IwDI0Ghh9kPCRWuVDlZ78GDv34h1Q0
	 sse7hruio1rnehALfmTlqXzn/7DMEcWE9wVHN5R/NtA5GBKS+R17OEN2w+YvnXyYqK
	 ZvJUQSlekMFrw==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	borisp@nvidia.com,
	john.fastabend@gmail.com,
	tariqt@nvidia.com,
	Jakub Kicinski <kuba@kernel.org>,
	Shai Amiram <samiram@nvidia.com>
Subject: [PATCH net 4/7] tls: rx: strp: fix determining record length in copy mode
Date: Tue, 16 May 2023 18:50:39 -0700
Message-Id: <20230517015042.1243644-5-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230517015042.1243644-1-kuba@kernel.org>
References: <20230517015042.1243644-1-kuba@kernel.org>
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
Tested-by: Shai Amiram <samiram@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_strp.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/net/tls/tls_strp.c b/net/tls/tls_strp.c
index 2b6fa9855999..e2e48217e7ac 100644
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


