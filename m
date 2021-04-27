Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B28A36CC87
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 22:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239021AbhD0Uok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 16:44:40 -0400
Received: from mail.netfilter.org ([217.70.188.207]:54336 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235401AbhD0Uoi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 16:44:38 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id C53F464124;
        Tue, 27 Apr 2021 22:43:16 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 4/7] netfilter: nftables: add helper function to validate set element data
Date:   Tue, 27 Apr 2021 22:43:42 +0200
Message-Id: <20210427204345.22043-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210427204345.22043-1-pablo@netfilter.org>
References: <20210427204345.22043-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When binding sets to rule, validate set element data according to
set definition. This patch adds a helper function to be reused by
the catch-all set element support.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 3342f260d534..faf0424375e8 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4499,10 +4499,9 @@ static int nft_validate_register_store(const struct nft_ctx *ctx,
 				       enum nft_data_types type,
 				       unsigned int len);
 
-static int nf_tables_bind_check_setelem(const struct nft_ctx *ctx,
-					struct nft_set *set,
-					const struct nft_set_iter *iter,
-					struct nft_set_elem *elem)
+static int nft_setelem_data_validate(const struct nft_ctx *ctx,
+				     struct nft_set *set,
+				     struct nft_set_elem *elem)
 {
 	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
 	enum nft_registers dreg;
@@ -4514,6 +4513,14 @@ static int nf_tables_bind_check_setelem(const struct nft_ctx *ctx,
 					   set->dlen);
 }
 
+static int nf_tables_bind_check_setelem(const struct nft_ctx *ctx,
+					struct nft_set *set,
+					const struct nft_set_iter *iter,
+					struct nft_set_elem *elem)
+{
+	return nft_setelem_data_validate(ctx, set, elem);
+}
+
 int nf_tables_bind_set(const struct nft_ctx *ctx, struct nft_set *set,
 		       struct nft_set_binding *binding)
 {
-- 
2.30.2

