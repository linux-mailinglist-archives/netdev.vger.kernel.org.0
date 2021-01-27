Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2E70305D29
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 14:30:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238414AbhA0N2M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 08:28:12 -0500
Received: from correo.us.es ([193.147.175.20]:40282 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238383AbhA0N0G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 08:26:06 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0E4FD2A2BAD
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 14:24:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 00FBDDA73F
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 14:24:22 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id EAA16DA794; Wed, 27 Jan 2021 14:24:21 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B4524DA792;
        Wed, 27 Jan 2021 14:24:19 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 27 Jan 2021 14:24:19 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 87D2E426CC84;
        Wed, 27 Jan 2021 14:24:19 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 1/3] netfilter: nft_dynset: honor stateful expressions in set definition
Date:   Wed, 27 Jan 2021 14:25:10 +0100
Message-Id: <20210127132512.5472-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210127132512.5472-1-pablo@netfilter.org>
References: <20210127132512.5472-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the set definition contains stateful expressions, allocate them for
the newly added entries from the packet path.

Fixes: 65038428b2c6 ("netfilter: nf_tables: allow to specify stateful expression in set definition")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 2 ++
 net/netfilter/nf_tables_api.c     | 5 ++---
 net/netfilter/nft_dynset.c        | 6 ++++++
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index f4af8362d234..4b6ecf532623 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -721,6 +721,8 @@ void *nft_set_elem_init(const struct nft_set *set,
 			const struct nft_set_ext_tmpl *tmpl,
 			const u32 *key, const u32 *key_end, const u32 *data,
 			u64 timeout, u64 expiration, gfp_t gfp);
+int nft_set_elem_expr_clone(const struct nft_ctx *ctx, struct nft_set *set,
+			    struct nft_expr *expr_array[]);
 void nft_set_elem_destroy(const struct nft_set *set, void *elem,
 			  bool destroy_expr);
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 15c467f1a9dd..8d3aa97b52e7 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5235,9 +5235,8 @@ static void nf_tables_set_elem_destroy(const struct nft_ctx *ctx,
 	kfree(elem);
 }
 
-static int nft_set_elem_expr_clone(const struct nft_ctx *ctx,
-				   struct nft_set *set,
-				   struct nft_expr *expr_array[])
+int nft_set_elem_expr_clone(const struct nft_ctx *ctx, struct nft_set *set,
+			    struct nft_expr *expr_array[])
 {
 	struct nft_expr *expr;
 	int err, i, k;
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 0b053f75cd60..86204740f6c7 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -295,6 +295,12 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 			err = -EOPNOTSUPP;
 			goto err_expr_free;
 		}
+	} else if (set->num_exprs > 0) {
+		err = nft_set_elem_expr_clone(ctx, set, priv->expr_array);
+		if (err < 0)
+			return err;
+
+		priv->num_exprs = set->num_exprs;
 	}
 
 	nft_set_ext_prepare(&priv->tmpl);
-- 
2.20.1

