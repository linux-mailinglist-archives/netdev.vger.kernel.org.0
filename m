Return-Path: <netdev+bounces-7904-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DA57F7220A3
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 10:12:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 53C981C208DF
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 08:11:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 169B6125A7;
	Mon,  5 Jun 2023 08:11:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A55E611CB0
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 08:11:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C694AC433D2;
	Mon,  5 Jun 2023 08:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685952716;
	bh=4yhT8ATcjwYSiYGvqw870WXf5D97ke75n3XoIG+Bt3Q=;
	h=From:To:Cc:Subject:Date:From;
	b=NTXrKF87Ms85ThHMArS3ddBAfnpYoLIBlkioPq1FaUUHEbrk8RcIXpZISF99aeXtj
	 mnRdUbjOe9hndpYSdqaz7xAE3dMtadyyf+8HtdU+yd46d1peDt1p6mwxz60K/j46Ca
	 8lqZOKfCdqggV0WYzrHltQGP8asCfbGEmBqZWkJK5l4VQzQX8G2w1NXmCvB2PqYjJD
	 DBxoD6MeCBQgKgzRUTb994FwvbkPW/Cxw2M4bTvrRtO9VH3je6ZBtfn740daypu75f
	 NGnZEAbZPCo4vddZ1yiBVuR562gwBqkEpQxt9rQi50bCSz/TAlzO0R2VaolUnFOhqk
	 1BMuaAT5xNE1Q==
From: Leon Romanovsky <leon@kernel.org>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jakub Kicinski <kuba@kernel.org>,
	netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH ipsec-next] xfrm: delete not-needed clear to zero of encap_oa
Date: Mon,  5 Jun 2023 11:11:51 +0300
Message-Id: <1ed3e00428a0036bdea14eb4f5a45706a89f11eb.1685952635.git.leon@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

After commit 2f4796518315 ("af_key: Fix heap information leak"), there is
no need to clear encap_oa again as it is already initialized to zero.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/key/af_key.c     | 1 -
 net/xfrm/xfrm_user.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/net/key/af_key.c b/net/key/af_key.c
index 31ab12fd720a..14e891ebde61 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -1281,7 +1281,6 @@ static struct xfrm_state * pfkey_msg2xfrm_state(struct net *net,
 				ext_hdrs[SADB_X_EXT_NAT_T_DPORT-1];
 			natt->encap_dport = n_port->sadb_x_nat_t_port_port;
 		}
-		memset(&natt->encap_oa, 0, sizeof(natt->encap_oa));
 	}
 
 	err = xfrm_init_state(x);
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index c34a2a06ca94..ec713db148f3 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1077,7 +1077,6 @@ static int copy_to_user_encap(struct xfrm_encap_tmpl *ep, struct sk_buff *skb)
 	uep->encap_type = ep->encap_type;
 	uep->encap_sport = ep->encap_sport;
 	uep->encap_dport = ep->encap_dport;
-	uep->encap_oa = ep->encap_oa;
 
 	return 0;
 }
-- 
2.40.1


