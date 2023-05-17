Return-Path: <netdev+bounces-3153-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B1F8705CA9
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 03:52:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 260BA1C20C67
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 01:52:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CF3717E3;
	Wed, 17 May 2023 01:50:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E7AB3D8C
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 01:50:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AD38C433AE;
	Wed, 17 May 2023 01:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684288257;
	bh=2dNkN1Y1pHMHX7bq+FeTf/jjL3U+dLU6ffpZ89B/EZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RDUwT+U35hWCjUgUaobnMZGwGhOFsrv7GM7NA+HwA/wVxz2acm3Or0Wg+CTVQg9nv
	 kl9FQjcRDwZiHcH4bUvRkqznBdlKaY7rk1tYce4ZJQzzTwA1eSmLHjLW1GoVW7DZQ3
	 qE871BMNED+G/D8zcuCN+IA0NF/SlAN4Uab9bUjt/v954uNEVeAOvEusfYNH8Uraq5
	 WGanj8vtMmawn2Sai/y0RFMd4YkdTFv1XhQ0uOfAFhp9ST5Md2etRuA0xrwRC3KLJ9
	 CUzZk4pP1ve3xFz6viRQPVMGrp++euGOzAEA1fZNFRaCOh5VxwkQx9uu+DJ5MBjuQz
	 YP2Kn1f/N0u8g==
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
Subject: [PATCH net 7/7] tls: rx: strp: don't use GFP_KERNEL in softirq context
Date: Tue, 16 May 2023 18:50:42 -0700
Message-Id: <20230517015042.1243644-8-kuba@kernel.org>
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

When receive buffer is small, or the TCP rx queue looks too
complicated to bother using it directly - we allocate a new
skb and copy data into it.

We already use sk->sk_allocation... but nothing actually
sets it to GFP_ATOMIC on the ->sk_data_ready() path.

Users of HW offload are far more likely to experience problems
due to scheduling while atomic. "Copy mode" is very rarely
triggered with SW crypto.

Fixes: 84c61fe1a75b ("tls: rx: do not use the standard strparser")
Tested-by: Shai Amiram <samiram@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_sw.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 635b8bf6b937..6e6a7c37d685 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2304,10 +2304,14 @@ static void tls_data_ready(struct sock *sk)
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
 	struct sk_psock *psock;
+	gfp_t alloc_save;
 
 	trace_sk_data_ready(sk);
 
+	alloc_save = sk->sk_allocation;
+	sk->sk_allocation = GFP_ATOMIC;
 	tls_strp_data_ready(&ctx->strp);
+	sk->sk_allocation = alloc_save;
 
 	psock = sk_psock_get(sk);
 	if (psock) {
-- 
2.40.1


