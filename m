Return-Path: <netdev+bounces-3151-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 694E1705CA6
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 03:51:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E98E1C20D40
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 01:51:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B5DA3C24;
	Wed, 17 May 2023 01:50:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C3E217D1
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 01:50:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C30D7C433D2;
	Wed, 17 May 2023 01:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684288254;
	bh=J019Q6YcMMdEle88f534McuAiMyzzgnfvWyH/+6Dq2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=khDlXeXSv/ac4Rjb0Z+fO1hXb/sWoJLJs29tFsy86k2CsPGn+haIQV+50yIiwkhwX
	 s/QeLGeP/OdjRKkLiwEG7kJsYX/nqR7SYNL/+a6J7EFuErNB4u+uHQckscyjL1Pn81
	 rx4dqdeHpj2BfZreyBaKXefWld/vbQ1vvt74BuMgHE85VHoaw61/DV25yld1kHfC9l
	 Eyzh4HoGY8p5FCoeLlDvAsWXiDaP3hlLAm+zR21kkcmV4alCGXtB0NKp9DdjrKBN0y
	 0OZiIvnn+e1FsQIy2jSwUC2Pqk48y+C4vdXwbasqmPmQy58pGJ4DHTOcZIkz96zzxS
	 yD3MdxqNJn8Kg==
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
Subject: [PATCH net 2/7] tls: rx: strp: set the skb->len of detached / CoW'ed skbs
Date: Tue, 16 May 2023 18:50:37 -0700
Message-Id: <20230517015042.1243644-3-kuba@kernel.org>
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

alloc_skb_with_frags() fills in page frag sizes but does not
set skb->len and skb->data_len. Set those correctly otherwise
device offload will most likely generate an empty skb and
hit the BUG() at the end of __skb_nsg().

Fixes: 84c61fe1a75b ("tls: rx: do not use the standard strparser")
Tested-by: Shai Amiram <samiram@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/tls/tls_strp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/tls/tls_strp.c b/net/tls/tls_strp.c
index 955ac3e0bf4d..24016c865e00 100644
--- a/net/tls/tls_strp.c
+++ b/net/tls/tls_strp.c
@@ -56,6 +56,8 @@ static struct sk_buff *tls_strp_msg_make_copy(struct tls_strparser *strp)
 		offset += skb_frag_size(frag);
 	}
 
+	skb->len = strp->stm.full_len;
+	skb->data_len = strp->stm.full_len;
 	skb_copy_header(skb, strp->anchor);
 	rxm = strp_msg(skb);
 	rxm->offset = 0;
-- 
2.40.1


