Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA25213F839
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 20:18:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437621AbgAPTQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 14:16:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:41252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733091AbgAPQzl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 11:55:41 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5766B2192A;
        Thu, 16 Jan 2020 16:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193741;
        bh=N19053XbNoSi+CqfIZwUBqiWoKNj/vKaB4JSfsdBJx8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q24qCQdycETW9wiHdq7ZIkq815zzlIMZH52ENiuknEkjYlsZbZxmHwCU7ZfEJrdqM
         Akum96XbZQknjQ7YjPHxvjTx5CS5hi6zdOAsIGrhHKsF6yrqDZZmEbsfJ+Qa+LmjLz
         h4fKWbIPYTe+K8LRmttZK+5NfLzkzO2cncUxTUro=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 032/671] netfilter: nft_osf: usage from output path is not valid
Date:   Thu, 16 Jan 2020 11:44:23 -0500
Message-Id: <20200116165502.8838-32-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165502.8838-1-sashal@kernel.org>
References: <20200116165502.8838-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fernando Fernandez Mancera <ffmancera@riseup.net>

[ Upstream commit 4a3e71b7b7dbaf3562be9d508260935aa13cb48b ]

The nft_osf extension, like xt_osf, is not supported from the output
path.

Fixes: b96af92d6eaf ("netfilter: nf_tables: implement Passive OS fingerprint module in nft_osf")
Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_osf.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/netfilter/nft_osf.c b/net/netfilter/nft_osf.c
index a35fb59ace73..df4e3e0412ed 100644
--- a/net/netfilter/nft_osf.c
+++ b/net/netfilter/nft_osf.c
@@ -69,6 +69,15 @@ static int nft_osf_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	return -1;
 }
 
+static int nft_osf_validate(const struct nft_ctx *ctx,
+			    const struct nft_expr *expr,
+			    const struct nft_data **data)
+{
+	return nft_chain_validate_hooks(ctx->chain, (1 << NF_INET_LOCAL_IN) |
+						    (1 << NF_INET_PRE_ROUTING) |
+						    (1 << NF_INET_FORWARD));
+}
+
 static struct nft_expr_type nft_osf_type;
 static const struct nft_expr_ops nft_osf_op = {
 	.eval		= nft_osf_eval,
@@ -76,6 +85,7 @@ static const struct nft_expr_ops nft_osf_op = {
 	.init		= nft_osf_init,
 	.dump		= nft_osf_dump,
 	.type		= &nft_osf_type,
+	.validate	= nft_osf_validate,
 };
 
 static struct nft_expr_type nft_osf_type __read_mostly = {
-- 
2.20.1

