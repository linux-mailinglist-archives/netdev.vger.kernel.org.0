Return-Path: <netdev+bounces-11617-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 79B68733B29
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 22:49:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 35280281827
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 20:49:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88D0B6AA4;
	Fri, 16 Jun 2023 20:49:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3976963CB
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 20:49:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32482C433C0;
	Fri, 16 Jun 2023 20:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686948593;
	bh=dRgWOFupJBvQFN5fWyyFou9rJxqL/N0jUqwKeAOC0bk=;
	h=From:To:Cc:Subject:Date:From;
	b=cMmLORLQbUdxWfEq0Do/jdYbrH879mM24EqlEmQgGNelp+JX4L37uaDzgWn1EJGTQ
	 FeZkecfU+o/ZAgohCS26vMGSKgtF+Iu8iN7jEA4x7Juu35xidhJhunUraUyIovm6ow
	 guZUHfJhv7/i71t9Gw880HX86wr2Zye4gKoRmUQbY6Hg80P3thvTu/EdCq5FOZLxqt
	 7feIgP5N0jT+FElrdOeFANAhw5gvOAdxKmQBj1RLeJziI5TWKjSXgXKb9Hxx+zZLEA
	 b1y9LPKEcxZalCjKR+gpu1l/qgj7HTb9RtJgAswo4vKUuQhj0EeFYrJI0bznk4RErr
	 UClvi6joGmX+w==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	linyunsheng@huawei.com,
	Jakub Kicinski <kuba@kernel.org>,
	Simon Horman <simon.horman@corigine.com>,
	richardbgobert@gmail.com
Subject: [PATCH net-next v2] gro: move the tc_ext comparison to a helper
Date: Fri, 16 Jun 2023 13:49:39 -0700
Message-Id: <20230616204939.2373785-1-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The double ifdefs (one for the variable declaration and
one around the code) are quite aesthetically displeasing.
Factor this code out into a helper for easier wrapping.

This will become even more ugly when another skb ext
comparison is added in the future.

The resulting machine code looks the same, the compiler
seems to try to use %rax more and some blocks more around
but I haven't spotted minor differences.

Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
v2:
 - reword commit message a little
 - return the value instead of in/out arg
v1: https://lore.kernel.org/all/20230613205105.1996166-1-kuba@kernel.org/

CC: richardbgobert@gmail.com
---
 net/core/gro.c | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/net/core/gro.c b/net/core/gro.c
index dca800068e41..0759277dc14e 100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -304,6 +304,24 @@ void napi_gro_flush(struct napi_struct *napi, bool flush_old)
 }
 EXPORT_SYMBOL(napi_gro_flush);
 
+static unsigned long gro_list_prepare_tc_ext(const struct sk_buff *skb,
+					     const struct sk_buff *p,
+					     unsigned long diffs)
+{
+#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
+	struct tc_skb_ext *skb_ext;
+	struct tc_skb_ext *p_ext;
+
+	skb_ext = skb_ext_find(skb, TC_SKB_EXT);
+	p_ext = skb_ext_find(p, TC_SKB_EXT);
+
+	diffs |= (!!p_ext) ^ (!!skb_ext);
+	if (!diffs && unlikely(skb_ext))
+		diffs |= p_ext->chain ^ skb_ext->chain;
+#endif
+	return diffs;
+}
+
 static void gro_list_prepare(const struct list_head *head,
 			     const struct sk_buff *skb)
 {
@@ -338,23 +356,11 @@ static void gro_list_prepare(const struct list_head *head,
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
+			diffs |= gro_list_prepare_tc_ext(skb, p, diffs);
 		}
 
 		NAPI_GRO_CB(p)->same_flow = !diffs;
-- 
2.40.1


