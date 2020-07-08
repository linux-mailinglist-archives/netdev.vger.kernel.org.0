Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1F0F218ECC
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 19:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728542AbgGHRqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 13:46:45 -0400
Received: from correo.us.es ([193.147.175.20]:34802 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726338AbgGHRq1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 13:46:27 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 34C953066B2
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 19:46:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 26AA5DA792
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 19:46:25 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1B6CEDA73F; Wed,  8 Jul 2020 19:46:25 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F1E7ADA78B;
        Wed,  8 Jul 2020 19:46:22 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 08 Jul 2020 19:46:22 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id C44774265A2F;
        Wed,  8 Jul 2020 19:46:22 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 08/12] netfilter: nf_tables: add NFTA_VERDICT_CHAIN_ID attribute
Date:   Wed,  8 Jul 2020 19:46:05 +0200
Message-Id: <20200708174609.1343-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200708174609.1343-1-pablo@netfilter.org>
References: <20200708174609.1343-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This netlink attribute allows you to identify the chain to jump/goto by
means of the chain ID.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 net/netfilter/nf_tables_api.c            | 16 +++++++++++++---
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 2304d1b7ba5e..683e75126d68 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -471,11 +471,13 @@ enum nft_data_attributes {
  *
  * @NFTA_VERDICT_CODE: nf_tables verdict (NLA_U32: enum nft_verdicts)
  * @NFTA_VERDICT_CHAIN: jump target chain name (NLA_STRING)
+ * @NFTA_VERDICT_CHAIN_ID: jump target chain ID (NLA_U32)
  */
 enum nft_verdict_attributes {
 	NFTA_VERDICT_UNSPEC,
 	NFTA_VERDICT_CODE,
 	NFTA_VERDICT_CHAIN,
+	NFTA_VERDICT_CHAIN_ID,
 	__NFTA_VERDICT_MAX
 };
 #define NFTA_VERDICT_MAX	(__NFTA_VERDICT_MAX - 1)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index fbe8f9209813..d86602797a69 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8242,6 +8242,7 @@ static const struct nla_policy nft_verdict_policy[NFTA_VERDICT_MAX + 1] = {
 	[NFTA_VERDICT_CODE]	= { .type = NLA_U32 },
 	[NFTA_VERDICT_CHAIN]	= { .type = NLA_STRING,
 				    .len = NFT_CHAIN_MAXNAMELEN - 1 },
+	[NFTA_VERDICT_CHAIN_ID]	= { .type = NLA_U32 },
 };
 
 static int nft_verdict_init(const struct nft_ctx *ctx, struct nft_data *data,
@@ -8278,10 +8279,19 @@ static int nft_verdict_init(const struct nft_ctx *ctx, struct nft_data *data,
 		break;
 	case NFT_JUMP:
 	case NFT_GOTO:
-		if (!tb[NFTA_VERDICT_CHAIN])
+		if (tb[NFTA_VERDICT_CHAIN]) {
+			chain = nft_chain_lookup(ctx->net, ctx->table,
+						 tb[NFTA_VERDICT_CHAIN],
+						 genmask);
+		} else if (tb[NFTA_VERDICT_CHAIN_ID]) {
+			chain = nft_chain_lookup_byid(ctx->net,
+						      tb[NFTA_VERDICT_CHAIN_ID]);
+			if (IS_ERR(chain))
+				return PTR_ERR(chain);
+		} else {
 			return -EINVAL;
-		chain = nft_chain_lookup(ctx->net, ctx->table,
-					 tb[NFTA_VERDICT_CHAIN], genmask);
+		}
+
 		if (IS_ERR(chain))
 			return PTR_ERR(chain);
 		if (nft_is_base_chain(chain))
-- 
2.20.1

