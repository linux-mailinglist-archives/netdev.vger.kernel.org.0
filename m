Return-Path: <netdev+bounces-10522-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C4E9D72ED50
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 22:51:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0B2121C2088E
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 20:51:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1200023D56;
	Tue, 13 Jun 2023 20:51:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903BB136A
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 20:51:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BCA2C433C8;
	Tue, 13 Jun 2023 20:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686689467;
	bh=u2W/j/Wm08jr9OVh1h4FO/pfdXuO010GZuUSpXxY6c0=;
	h=From:To:Cc:Subject:Date:From;
	b=krjR0p8nVdjnDYE6WVcxM29drBekPOOSu23iX2F/uL8z6H4IW8ssyviWKDbu/g9eg
	 CQMv30ghD/Y5V2pJEL76S0H2+6zDh/N47iyHZBY/Y1mBGOFc9qfsDfeuXdxOpn22eh
	 A1jifK0oUMRBeIl7G0O8qZhrCgmhO9oBONxu5tTmnbz++mi4mfys62/VA3mCVKIxyU
	 MPZ/zqvovUircyBu9Ob9qr+fKXt7dyiJLhHSoFTOHRTxfSerx2x1e9M8JK44CCKsPw
	 qRcpy6951InbpUaZWR+l+LgIT1NT9h7ARgro6LUbSoAP7sKqbAJsGTqb+GCZDYXSXe
	 FblOKDTX8r9/w==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	Jakub Kicinski <kuba@kernel.org>,
	richardbgobert@gmail.com
Subject: [PATCH net-next] gro: move the tc_ext comparison to a helper
Date: Tue, 13 Jun 2023 13:51:05 -0700
Message-Id: <20230613205105.1996166-1-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The double ifdefs are quite aesthetically displeasing.
Use a helper function to make the code more compact.
The resulting machine code looks the same (with minor
movement of some basic blocks).

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: richardbgobert@gmail.com
---
 net/core/gro.c | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/net/core/gro.c b/net/core/gro.c
index ab9a447dfba7..90889e1f3f9a 100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -305,6 +305,23 @@ void napi_gro_flush(struct napi_struct *napi, bool flush_old)
 }
 EXPORT_SYMBOL(napi_gro_flush);
 
+static void gro_list_prepare_tc_ext(const struct sk_buff *skb,
+				    const struct sk_buff *p,
+				    unsigned long *diffs)
+{
+#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
+	struct tc_skb_ext *skb_ext;
+	struct tc_skb_ext *p_ext;
+
+	skb_ext = skb_ext_find(skb, TC_SKB_EXT);
+	p_ext = skb_ext_find(p, TC_SKB_EXT);
+
+	*diffs |= (!!p_ext) ^ (!!skb_ext);
+	if (!*diffs && unlikely(skb_ext))
+		*diffs |= p_ext->chain ^ skb_ext->chain;
+#endif
+}
+
 static void gro_list_prepare(const struct list_head *head,
 			     const struct sk_buff *skb)
 {
@@ -339,23 +356,11 @@ static void gro_list_prepare(const struct list_head *head,
 		 * avoid trying too hard to skip each of them individually
 		 */
 		if (!diffs && unlikely(skb->slow_gro | p->slow_gro)) {
-#if IS_ENABLED(CONFIG_SKB_EXTENSIONS) && IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
-			struct tc_skb_ext *skb_ext;
-			struct tc_skb_ext *p_ext;
-#endif
-
 			diffs |= p->sk != skb->sk;
 			diffs |= skb_metadata_dst_cmp(p, skb);
 			diffs |= skb_get_nfct(p) ^ skb_get_nfct(skb);
 
-#if IS_ENABLED(CONFIG_SKB_EXTENSIONS) && IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
-			skb_ext = skb_ext_find(skb, TC_SKB_EXT);
-			p_ext = skb_ext_find(p, TC_SKB_EXT);
-
-			diffs |= (!!p_ext) ^ (!!skb_ext);
-			if (!diffs && unlikely(skb_ext))
-				diffs |= p_ext->chain ^ skb_ext->chain;
-#endif
+			gro_list_prepare_tc_ext(skb, p, &diffs);
 		}
 
 		NAPI_GRO_CB(p)->same_flow = !diffs;
-- 
2.40.1


