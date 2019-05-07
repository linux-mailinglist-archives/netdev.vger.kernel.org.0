Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7AD515AC2
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 07:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729261AbfEGFsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 01:48:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:60372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728923AbfEGFk5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 01:40:57 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D638B206A3;
        Tue,  7 May 2019 05:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207656;
        bh=SdEjLrzoirfnu9SPTTpVGyfMKMbThmogfoJTt9xhd1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hg6HY2L3gUEfHwO65T0/VIpzWYWje2QLjZ1Xb5aAerusmi8Pmrb84MHsBPYOJQ4NW
         Mwe3BWTSe/RoNIz0x/RbAGP2VLX9OQyszXoo88RHo+S8XMHwvVDgmw/ruzYt+mNb6y
         PfmU51AX0f2H4M60GysRkplbUTa1FVNafHRWREjo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <alexander.levin@microsoft.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 81/95] netfilter: nf_tables: warn when expr implements only one of activate/deactivate
Date:   Tue,  7 May 2019 01:38:10 -0400
Message-Id: <20190507053826.31622-81-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053826.31622-1-sashal@kernel.org>
References: <20190507053826.31622-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 0ef235c71755c5f36c50282fcf2d7d08709be344 ]

->destroy is only allowed to free data, or do other cleanups that do not
have side effects on other state, such as visibility to other netlink
requests.

Such things need to be done in ->deactivate.
As a transaction can fail, we need to make sure we can undo such
operations, therefore ->activate() has to be provided too.

So print a warning and refuse registration if expr->ops provides
only one of the two operations.

v2: fix nft_expr_check_ops to not repeat same check twice (Jones Desougi)

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 net/netfilter/nf_tables_api.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c445d57e3a5b..b149a7219084 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -220,6 +220,18 @@ static int nft_delchain(struct nft_ctx *ctx)
 	return err;
 }
 
+/* either expr ops provide both activate/deactivate, or neither */
+static bool nft_expr_check_ops(const struct nft_expr_ops *ops)
+{
+	if (!ops)
+		return true;
+
+	if (WARN_ON_ONCE((!ops->activate ^ !ops->deactivate)))
+		return false;
+
+	return true;
+}
+
 static void nft_rule_expr_activate(const struct nft_ctx *ctx,
 				   struct nft_rule *rule)
 {
@@ -1724,6 +1736,9 @@ static int nf_tables_delchain(struct net *net, struct sock *nlsk,
  */
 int nft_register_expr(struct nft_expr_type *type)
 {
+	if (!nft_expr_check_ops(type->ops))
+		return -EINVAL;
+
 	nfnl_lock(NFNL_SUBSYS_NFTABLES);
 	if (type->family == NFPROTO_UNSPEC)
 		list_add_tail_rcu(&type->list, &nf_tables_expressions);
@@ -1873,6 +1888,10 @@ static int nf_tables_expr_parse(const struct nft_ctx *ctx,
 			err = PTR_ERR(ops);
 			goto err1;
 		}
+		if (!nft_expr_check_ops(ops)) {
+			err = -EINVAL;
+			goto err1;
+		}
 	} else
 		ops = type->ops;
 
-- 
2.20.1

