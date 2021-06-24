Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C75873B3770
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 21:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232806AbhFXT7p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 15:59:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48621 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232178AbhFXT7n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 15:59:43 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <colin.king@canonical.com>)
        id 1lwVTT-00047p-DD; Thu, 24 Jun 2021 19:57:19 +0000
From:   Colin King <colin.king@canonical.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] netfilter: nf_tables: Fix dereference of null pointer flow
Date:   Thu, 24 Jun 2021 20:57:18 +0100
Message-Id: <20210624195718.170796-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

In the case where chain->flags & NFT_CHAIN_HW_OFFLOAD is false then
nft_flow_rule_create is not called and flow is NULL. The subsequent
error handling execution via label err_destroy_flow_rule will lead
to a null pointer dereference on flow when calling nft_flow_rule_destroy.
Since the error path to err_destroy_flow_rule has to cater for null
and non-null flows, only call nft_flow_rule_destroy if flow is non-null
to fix this issue.

Addresses-Coverity: ("Explicity null dereference")
Fixes: 3c5e44622011 ("netfilter: nf_tables: memleak in hw offload abort path")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/netfilter/nf_tables_api.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 390d4466567f..de182d1f7c4e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3446,7 +3446,8 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 	return 0;
 
 err_destroy_flow_rule:
-	nft_flow_rule_destroy(flow);
+	if (flow)
+		nft_flow_rule_destroy(flow);
 err_release_rule:
 	nf_tables_rule_release(&ctx, rule);
 err_release_expr:
-- 
2.31.1

