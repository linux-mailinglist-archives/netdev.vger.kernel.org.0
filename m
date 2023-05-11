Return-Path: <netdev+bounces-1633-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 592376FE952
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 03:22:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 79E591C20EB9
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 01:22:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15A9F637;
	Thu, 11 May 2023 01:20:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 368E9801
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 01:20:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9A13C433AA;
	Thu, 11 May 2023 01:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683768044;
	bh=zViDysBZ4IcIdZPhitHcyT9KMRp86O+qTv//E+5g0UU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=se6/7MfH9rkcnP5refl1z2NbiR2NEJDEyz7/Lg91/zX+deahH3dXF/1z4gwMufJfh
	 svdOE6bucMBtdhKJ1JCs+lreyxV6kOwLj16F6HC/ILARIxuGDPc7sNXUJziToyiI2J
	 Yjyw//7G2sw1G95gnWnQjpw8G/GYE0i5NVFrFq8gvqOLc6xVMEoqc0kvSSQTrkmMpg
	 WPcmwTpYbIyNGanVdCFO1tas3FKklT8o6qU31EenArJG6osVUrZ2Re4ZlYOD8c7A8b
	 PLRWeP2sG2/ApWLQE1H6v+v1l33AVJLqwc28gs3kXEViTKfyoWUYrH33aH7zEvezN/
	 kTH6BImBXwVAA==
From: Jakub Kicinski <kuba@kernel.org>
To: tariqt@nvidia.com
Cc: netdev@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>
Subject: [RFC / RFT net 7/7] tls: rx: strp: don't use GFP_KERNEL in softirq context
Date: Wed, 10 May 2023 18:20:34 -0700
Message-Id: <20230511012034.902782-8-kuba@kernel.org>
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

When receive buffer is small, or the TCP rx queue looks too
complicated to bother using it directly - we allocate a new
skb and copy data into it.

We already use sk->sk_allocation... but nothing actually
sets it to GFP_ATOMIC on the ->sk_data_ready() path.

Users of HW offload are far more likely to experience problems
due to scheduling while atomic. "Copy mode" is very rarely
triggered with SW crypto.

Fixes: 84c61fe1a75b ("tls: rx: do not use the standard strparser")
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


