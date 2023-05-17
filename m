Return-Path: <netdev+bounces-3148-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AC4FC705CA3
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 03:51:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E260D28134E
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 01:51:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FA4417FF;
	Wed, 17 May 2023 01:50:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC51817D0
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 01:50:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F6C3C4339B;
	Wed, 17 May 2023 01:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684288253;
	bh=Ocgi91VRkCwlG1K+bbEL304TtCWklxMMcZmbo6Wo/SU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R/KEOTiOSgIu1OE6vBHvw7V8CIHhr3R6UaiSdRkgvk6eYrUNaL+w4nm9C+kZ74dhO
	 ovddHDS74YzH2uuJiNuPZ5MJqWC/6Ar5a0ZMVp0lbp9ag0f16zSR7Qpto9Dbz+khqG
	 u6LHzW5olEKOmAItehm60vdWNzFejBA4ZVRvr2oupQk9Tx/XYSsAT2P3xTCSxwOs3P
	 YWI8XIOa0Bb2XRp3R2l+B4wHU+p4IfFiontdTQnazapV04CWY6gxTg6qHGnM+FeopM
	 FuL+9TFYsSB2FLeM+vbnZaXrBg/Yh5GJrcMh4VMGPwGdJdrlJEY2y2XM9N/hUuYC4e
	 p6PiUVj2vYJjg==
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
Subject: [PATCH net 1/7] tls: rx: device: fix checking decryption status
Date: Tue, 16 May 2023 18:50:36 -0700
Message-Id: <20230517015042.1243644-2-kuba@kernel.org>
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

skb->len covers the entire skb, including the frag_list.
In fact we're guaranteed that rxm->full_len <= skb->len,
so since the change under Fixes we were not checking decrypt
status of any skb but the first.

Note that the skb_pagelen() added here may feel a bit costly,
but it's removed by subsequent fixes, anyway.

Reported-by: Tariq Toukan <tariqt@nvidia.com>
Fixes: 86b259f6f888 ("tls: rx: device: bound the frag walk")
Tested-by: Shai Amiram <samiram@nvidia.com>
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


