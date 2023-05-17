Return-Path: <netdev+bounces-3343-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5336270684D
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 14:38:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 594DD28103F
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 12:38:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 934D218B03;
	Wed, 17 May 2023 12:38:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A0518AF7
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 12:38:22 +0000 (UTC)
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E64FE3C07;
	Wed, 17 May 2023 05:38:16 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1pzGPw-0004Tr-UU; Wed, 17 May 2023 14:38:08 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>
Subject: [PATCH net 2/3] netfilter: nf_tables: fix nft_trans type confusion
Date: Wed, 17 May 2023 14:37:55 +0200
Message-Id: <20230517123756.7353-3-fw@strlen.de>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20230517123756.7353-1-fw@strlen.de>
References: <20230517123756.7353-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

nft_trans_FOO objects all share a common nft_trans base structure, but
trailing fields depend on the real object size. Access is only safe after
trans->msg_type check.

Check for rule type first.  Found by code inspection.

Fixes: 1a94e38d254b ("netfilter: nf_tables: add NFTA_RULE_ID attribute")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 59fb8320ab4d..dc5675962de4 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3865,12 +3865,10 @@ static struct nft_rule *nft_rule_lookup_byid(const struct net *net,
 	struct nft_trans *trans;
 
 	list_for_each_entry(trans, &nft_net->commit_list, list) {
-		struct nft_rule *rule = nft_trans_rule(trans);
-
 		if (trans->msg_type == NFT_MSG_NEWRULE &&
 		    trans->ctx.chain == chain &&
 		    id == nft_trans_rule_id(trans))
-			return rule;
+			return nft_trans_rule(trans);
 	}
 	return ERR_PTR(-ENOENT);
 }
-- 
2.39.3


