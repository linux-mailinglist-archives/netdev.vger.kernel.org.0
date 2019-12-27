Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC26012B78A
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 18:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728497AbfL0RuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 12:50:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:42366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728404AbfL0RoU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 12:44:20 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC55920740;
        Fri, 27 Dec 2019 17:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468659;
        bh=RtFS6Ig+xSxNO0ISJNYHYxVZI60x+9oEXxbVu9DCVwA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cXD2YjiKxuLcIjJfV4vb+V//C8HfUKT8Me3bXM4Jaguw5fhkG/tMz72F68hDq0BzT
         ljuXzop6Sn+r66J/5FgLAUcHwYPohVZ4COoP/HPp5A5U8Ld5r6l8h7e4RT6OWTYgRQ
         ZwnVUWckYSUOpeW3OgJ7DGLAYF1hFTcNxTN7SEQg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 21/84] netfilter: nf_tables: validate NFT_DATA_VALUE after nft_data_init()
Date:   Fri, 27 Dec 2019 12:42:49 -0500
Message-Id: <20191227174352.6264-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174352.6264-1-sashal@kernel.org>
References: <20191227174352.6264-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 0d2c96af797ba149e559c5875c0151384ab6dd14 ]

Userspace might bogusly sent NFT_DATA_VERDICT in several netlink
attributes that assume NFT_DATA_VALUE. Moreover, make sure that error
path invokes nft_data_release() to decrement the reference count on the
chain object.

Fixes: 96518518cc41 ("netfilter: add nftables")
Fixes: 0f3cd9b36977 ("netfilter: nf_tables: add range expression")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c |  4 +++-
 net/netfilter/nft_bitwise.c   |  4 ++--
 net/netfilter/nft_cmp.c       |  6 ++++++
 net/netfilter/nft_range.c     | 10 ++++++++++
 4 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 42f79f9532c6..4711a8b56f32 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4117,8 +4117,10 @@ static int nft_get_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		return err;
 
 	err = -EINVAL;
-	if (desc.type != NFT_DATA_VALUE || desc.len != set->klen)
+	if (desc.type != NFT_DATA_VALUE || desc.len != set->klen) {
+		nft_data_release(&elem.key.val, desc.type);
 		return err;
+	}
 
 	priv = set->ops->get(ctx->net, set, &elem, flags);
 	if (IS_ERR(priv))
diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index fff8073e2a56..058ee84ea531 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -83,7 +83,7 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 			    tb[NFTA_BITWISE_MASK]);
 	if (err < 0)
 		return err;
-	if (d1.len != priv->len) {
+	if (d1.type != NFT_DATA_VALUE || d1.len != priv->len) {
 		err = -EINVAL;
 		goto err1;
 	}
@@ -92,7 +92,7 @@ static int nft_bitwise_init(const struct nft_ctx *ctx,
 			    tb[NFTA_BITWISE_XOR]);
 	if (err < 0)
 		goto err1;
-	if (d2.len != priv->len) {
+	if (d2.type != NFT_DATA_VALUE || d2.len != priv->len) {
 		err = -EINVAL;
 		goto err2;
 	}
diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
index 79d48c1d06f4..7007045c0849 100644
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -82,6 +82,12 @@ static int nft_cmp_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	if (err < 0)
 		return err;
 
+	if (desc.type != NFT_DATA_VALUE) {
+		err = -EINVAL;
+		nft_data_release(&priv->data, desc.type);
+		return err;
+	}
+
 	priv->sreg = nft_parse_register(tb[NFTA_CMP_SREG]);
 	err = nft_validate_register_load(priv->sreg, desc.len);
 	if (err < 0)
diff --git a/net/netfilter/nft_range.c b/net/netfilter/nft_range.c
index cedb96c3619f..2e1d2ec2f52a 100644
--- a/net/netfilter/nft_range.c
+++ b/net/netfilter/nft_range.c
@@ -70,11 +70,21 @@ static int nft_range_init(const struct nft_ctx *ctx, const struct nft_expr *expr
 	if (err < 0)
 		return err;
 
+	if (desc_from.type != NFT_DATA_VALUE) {
+		err = -EINVAL;
+		goto err1;
+	}
+
 	err = nft_data_init(NULL, &priv->data_to, sizeof(priv->data_to),
 			    &desc_to, tb[NFTA_RANGE_TO_DATA]);
 	if (err < 0)
 		goto err1;
 
+	if (desc_to.type != NFT_DATA_VALUE) {
+		err = -EINVAL;
+		goto err2;
+	}
+
 	if (desc_from.len != desc_to.len) {
 		err = -EINVAL;
 		goto err2;
-- 
2.20.1

