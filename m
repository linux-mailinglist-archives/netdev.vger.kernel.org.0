Return-Path: <netdev+bounces-1627-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A4796FE946
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 03:21:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4FD8C1C20EC3
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 01:21:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFB9D653;
	Thu, 11 May 2023 01:20:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6139162D
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 01:20:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D48EEC433D2;
	Thu, 11 May 2023 01:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683768042;
	bh=L2hVS35d0RXu42l+XnlW2bSi38Ctui759HLSg0Bt4hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=epA7M/A4Ix0ckCQelFz71sZ1bWfbysh2oakZRCI6x1FmfJw0ckYTxIeP+XD5cVYPb
	 deGamYIOhWe0ZmUQfQebNaAHTsY4OpmVeqn5cUN2SmmWXWT143x4RLp1E5RaFdtck4
	 cC8eCj0Jz8wbn5EWhEMSUsRdRA199/OoEy4Uizk5nv6KHEo6CQIw18IGRpA3bTqJJo
	 vvzudhTFd0PKdxYoJmsE6RWss7zcnWDwHYCwefA7ir1VQCOP2OOhaPi9MRKbLXdfgG
	 r1R8z+1ZTraYf9GRayYtNLdBhTfx+ZOh8ALMhVg5Wkp3YnZeIx8Gsa40FUq3NAGYRd
	 8mHVGI9oNPs3Q==
From: Jakub Kicinski <kuba@kernel.org>
To: tariqt@nvidia.com
Cc: netdev@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>
Subject: [RFC / RFT net 1/7] tls: rx: device: fix checking decryption status
Date: Wed, 10 May 2023 18:20:28 -0700
Message-Id: <20230511012034.902782-2-kuba@kernel.org>
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

skb->len covers the entire skb, including the frag_list.
In fact we're guaranteed that rxm->full_len <= skb->len,
so since the change under Fixes we were not checking decrypt
status of any skb but the first.

Note that the skb_pagelen() added here may feel a bit costly,
but it's removed by subsequent fixes, anyway.

Reported-by: Tariq Toukan <tariqt@nvidia.com>
Fixes: 86b259f6f888 ("tls: rx: device: bound the frag walk")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index a7cc4f9faac2..3b87c7b04ac8 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -1012,7 +1012,7 @@ int tls_device_decrypted(struct sock *sk, struct tls_context *tls_ctx)
 	struct sk_buff *skb_iter;
 	int left;
 
-	left = rxm->full_len - skb->len;
+	left = rxm->full_len + rxm->offset - skb_pagelen(skb);
 	/* Check if all the data is decrypted already */
 	skb_iter = skb_shinfo(skb)->frag_list;
 	while (skb_iter && left > 0) {
-- 
2.40.1


