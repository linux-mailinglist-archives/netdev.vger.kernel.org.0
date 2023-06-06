Return-Path: <netdev+bounces-8410-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 66EEE723F4C
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 12:23:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 21FD3281636
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 10:23:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A15192A71A;
	Tue,  6 Jun 2023 10:23:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E6028C3A
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 10:23:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D992C433D2;
	Tue,  6 Jun 2023 10:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686046992;
	bh=Mg9pfXFs+qeGayovgVVIZFj6K9PpbuYs6ytivVToYKY=;
	h=From:To:Cc:Subject:Date:From;
	b=HFhZ4t9GkyBuZWvD96AK1yzcI6UVWAfmhXbAXwZsDVNoreQ6Ts7fC4d4o/8MyRMIc
	 1np4KOXcY8WDCAfHh0fyE6wkLIBCqfLp7qzp8ryKD0oFOLWc5FgegvzUK+//ZDKTcp
	 5e96pf+TdY3QLbO9e0XGgQqjU2Rqynp8yiNsLyX4Blg6meSkGW9bnf4Hf2hFSWtagC
	 U7rbOxNRZVEF6pdmxtIJH5LP8/YEU03xuVLmJY33SUHG5WoJSo8NljryehhIb6o7Mn
	 wsZQgzp5IGzG/QlXp4FjpNcLoN2ieTYXjboy6U3HVziWw33LXHAQPJ0AazLUZmm7WS
	 E6owUpPselaTQ==
From: Leon Romanovsky <leon@kernel.org>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jakub Kicinski <kuba@kernel.org>,
	netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH ipsec-next v1] xfrm: delete not-needed clear to zero of encap_oa
Date: Tue,  6 Jun 2023 13:23:06 +0300
Message-Id: <1cd4aeb4a84ecb26171dbb90dc8300a0d71e0921.1686046811.git.leon@kernel.org>
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
Changelog:
v1:
 * Restored "uep->encap_oa = ep->encap_oa;" hunk in copy_to_user_encap()
v0: https://lore.kernel.org/all/1ed3e00428a0036bdea14eb4f5a45706a89f11eb.1685952635.git.leon@kernel.org
---
 net/key/af_key.c | 1 -
 1 file changed, 1 deletion(-)

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
-- 
2.40.1


