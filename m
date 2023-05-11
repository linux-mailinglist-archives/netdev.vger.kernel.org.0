Return-Path: <netdev+bounces-1631-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 860CD6FE94D
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 03:22:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 41ED928160B
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 01:22:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57A8B1106;
	Thu, 11 May 2023 01:20:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACFC4636
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 01:20:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35D89C433A0;
	Thu, 11 May 2023 01:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683768042;
	bh=WfY7l7efyiZ/BUNWvr2PWOVR6931VlvLJ/P3a5Ij7Z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kVRHsmXeWKc3K2LU5/vWudALXOYG+1IF/yot9L9dsPyawX44FI6pIZxX4M4pewBfQ
	 ucr7OOoFgDIYV5nISps/0JdfELbgNDhTkIxfWgIV/shM1Z0846enOiMuLRvWUER7oi
	 VhD/H4bLOeWycChwYPIIwBgKiLzaaKCrvVWoKZUQaREmpf+6uWZbMLnpwk01HOkUkB
	 BEqYkbUSKALOf0ZgS9yW+GYKDQuKOkzPrSQE3Sb2Tt63vk/44UgL7wDHzKS2Yrhkr5
	 V1F4K8KE6eGC9o2wUKZa1/eR04daKwI0Jj3E47IZZycoxSbUGaHXqy2Hm+7ch95thA
	 WDLG/8PVfpqvw==
From: Jakub Kicinski <kuba@kernel.org>
To: tariqt@nvidia.com
Cc: netdev@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>
Subject: [RFC / RFT net 2/7] tls: rx: strp: set the skb->len of detached / CoW'ed skbs
Date: Wed, 10 May 2023 18:20:29 -0700
Message-Id: <20230511012034.902782-3-kuba@kernel.org>
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

alloc_skb_with_frags() fills in page frag sizes but does not
set skb->len and skb->data_len. Set those correctly otherwise
device offload will most likely generate an empty skb and
hit the BUG() at the end of __skb_nsg().

Fixes: 84c61fe1a75b ("tls: rx: do not use the standard strparser")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_strp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/tls/tls_strp.c b/net/tls/tls_strp.c
index 955ac3e0bf4d..90b220d1145c 100644
--- a/net/tls/tls_strp.c
+++ b/net/tls/tls_strp.c
@@ -56,6 +56,8 @@ static struct sk_buff *tls_strp_msg_make_copy(struct tls_strparser *strp)
 		offset += skb_frag_size(frag);
 	}
 
+	skb->len = len;
+	skb->data_len = len;
 	skb_copy_header(skb, strp->anchor);
 	rxm = strp_msg(skb);
 	rxm->offset = 0;
-- 
2.40.1


