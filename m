Return-Path: <netdev+bounces-1927-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D59A76FFA76
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 21:40:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F25D31C21064
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 19:40:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36F3C944C;
	Thu, 11 May 2023 19:40:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230929444
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 19:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A607FC4339C;
	Thu, 11 May 2023 19:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683834017;
	bh=2QLWUuv7sWoxq91M2t52vu5y6W5FZRv+CbpLAWryEGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TOTv007gMjK5K7HgCerMXY7+dcOfXUX0CPb/El6sFxWYzJZEirx24u5XlZYSHTg4D
	 K9b9tADl7OlZ2UEAyavuTq6x5KLIqxNrpi9gu3lIIn0R4zajBFWTedKVcFJALGH8Hu
	 PkPrVVq3pSfYrqa44z1dUDzzYhN142S46+5Y0B/JqifapjODOznlDNc3Fy7vl5xvCi
	 sCz1p+yu8JoKUy0q+9Jv4IdeP2bWH2ZXZF5gjcSS8acsmF+QlsNg+tiHR2SyKSJbdp
	 74ik5tZTWhuGzVnLtNzKhmJCnyMU+QSOng+D7rfqnsRBXgSBEVvsS9xDMcgLJy9UmO
	 N4WSmsxcnX6oQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>,
	kadlec@netfilter.org,
	fw@strlen.de,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 7/9] netfilter: nf_tables: deactivate anonymous set from preparation phase
Date: Thu, 11 May 2023 15:39:40 -0400
Message-Id: <20230511193945.623476-7-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230511193945.623476-1-sashal@kernel.org>
References: <20230511193945.623476-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit c1592a89942e9678f7d9c8030efa777c0d57edab ]

Toggle deleted anonymous sets as inactive in the next generation, so
users cannot perform any update on it. Clear the generation bitmask
in case the transaction is aborted.

The following KASAN splat shows a set element deletion for a bound
anonymous set that has been already removed in the same transaction.

[   64.921510] ==================================================================
[   64.923123] BUG: KASAN: wild-memory-access in nf_tables_commit+0xa24/0x1490 [nf_tables]
[   64.924745] Write of size 8 at addr dead000000000122 by task test/890
[   64.927903] CPU: 3 PID: 890 Comm: test Not tainted 6.3.0+ #253
[   64.931120] Call Trace:
[   64.932699]  <TASK>
[   64.934292]  dump_stack_lvl+0x33/0x50
[   64.935908]  ? nf_tables_commit+0xa24/0x1490 [nf_tables]
[   64.937551]  kasan_report+0xda/0x120
[   64.939186]  ? nf_tables_commit+0xa24/0x1490 [nf_tables]
[   64.940814]  nf_tables_commit+0xa24/0x1490 [nf_tables]
[   64.942452]  ? __kasan_slab_alloc+0x2d/0x60
[   64.944070]  ? nf_tables_setelem_notify+0x190/0x190 [nf_tables]
[   64.945710]  ? kasan_set_track+0x21/0x30
[   64.947323]  nfnetlink_rcv_batch+0x709/0xd90 [nfnetlink]
[   64.948898]  ? nfnetlink_rcv_msg+0x480/0x480 [nfnetlink]

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables.h |  1 +
 net/netfilter/nf_tables_api.c     | 12 ++++++++++++
 net/netfilter/nft_dynset.c        |  2 +-
 net/netfilter/nft_lookup.c        |  2 +-
 net/netfilter/nft_objref.c        |  2 +-
 5 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 6bacbf57ac175..a1ccf1276f3ee 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -614,6 +614,7 @@ struct nft_set_binding {
 };
 
 enum nft_trans_phase;
+void nf_tables_activate_set(const struct nft_ctx *ctx, struct nft_set *set);
 void nf_tables_deactivate_set(const struct nft_ctx *ctx, struct nft_set *set,
 			      struct nft_set_binding *binding,
 			      enum nft_trans_phase phase);
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 12d815b9aa131..f82a61d92aa90 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4936,12 +4936,24 @@ static void nf_tables_unbind_set(const struct nft_ctx *ctx, struct nft_set *set,
 	}
 }
 
+void nf_tables_activate_set(const struct nft_ctx *ctx, struct nft_set *set)
+{
+	if (nft_set_is_anonymous(set))
+		nft_clear(ctx->net, set);
+
+	set->use++;
+}
+EXPORT_SYMBOL_GPL(nf_tables_activate_set);
+
 void nf_tables_deactivate_set(const struct nft_ctx *ctx, struct nft_set *set,
 			      struct nft_set_binding *binding,
 			      enum nft_trans_phase phase)
 {
 	switch (phase) {
 	case NFT_TRANS_PREPARE:
+		if (nft_set_is_anonymous(set))
+			nft_deactivate_next(ctx->net, set);
+
 		set->use--;
 		return;
 	case NFT_TRANS_ABORT:
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 6983e6ddeef90..e65a83328b554 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -342,7 +342,7 @@ static void nft_dynset_activate(const struct nft_ctx *ctx,
 {
 	struct nft_dynset *priv = nft_expr_priv(expr);
 
-	priv->set->use++;
+	nf_tables_activate_set(ctx, priv->set);
 }
 
 static void nft_dynset_destroy(const struct nft_ctx *ctx,
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index d9ad1aa818564..68a5dea805480 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -167,7 +167,7 @@ static void nft_lookup_activate(const struct nft_ctx *ctx,
 {
 	struct nft_lookup *priv = nft_expr_priv(expr);
 
-	priv->set->use++;
+	nf_tables_activate_set(ctx, priv->set);
 }
 
 static void nft_lookup_destroy(const struct nft_ctx *ctx,
diff --git a/net/netfilter/nft_objref.c b/net/netfilter/nft_objref.c
index 5d8d91b3904db..7f8e480b6be5b 100644
--- a/net/netfilter/nft_objref.c
+++ b/net/netfilter/nft_objref.c
@@ -184,7 +184,7 @@ static void nft_objref_map_activate(const struct nft_ctx *ctx,
 {
 	struct nft_objref_map *priv = nft_expr_priv(expr);
 
-	priv->set->use++;
+	nf_tables_activate_set(ctx, priv->set);
 }
 
 static void nft_objref_map_destroy(const struct nft_ctx *ctx,
-- 
2.39.2


