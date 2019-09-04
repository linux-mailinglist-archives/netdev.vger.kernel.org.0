Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E833FA8A12
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731889AbfIDP6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 11:58:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:60226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731864AbfIDP6Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 11:58:16 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C31EC2339D;
        Wed,  4 Sep 2019 15:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612695;
        bh=cDQdUbuMn1b5AsgpIoufO5CSV0ThiaKeL+JwRAY08IQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R+uhGunFxhcqtIZjMckA/am23AFISbF0UlNxQlV+yc+h8ISmZpUVdrUbbB6+mHxO+
         HSZJj7dNC/x7y1+L9TJ7L+ItiBvb6oy10IK5BIwYUNmJ1cIqHYJ2SjKC6C/DGROSZd
         fg96fhgTYhsq/uMNMPRgTZD70MchtIElbUyKEV28=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 23/94] netfilter: nft_flow_offload: missing netlink attribute policy
Date:   Wed,  4 Sep 2019 11:56:28 -0400
Message-Id: <20190904155739.2816-23-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904155739.2816-1-sashal@kernel.org>
References: <20190904155739.2816-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 14c415862c0630e01712a4eeaf6159a2b1b6d2a4 ]

The netlink attribute policy for NFTA_FLOW_TABLE_NAME is missing.

Fixes: a3c90f7a2323 ("netfilter: nf_tables: flow offload expression")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_flow_offload.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index aa5f571d43619..f14de444c31a4 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -146,6 +146,11 @@ static int nft_flow_offload_validate(const struct nft_ctx *ctx,
 	return nft_chain_validate_hooks(ctx->chain, hook_mask);
 }
 
+static const struct nla_policy nft_flow_offload_policy[NFTA_FLOW_MAX + 1] = {
+	[NFTA_FLOW_TABLE_NAME]	= { .type = NLA_STRING,
+				    .len = NFT_NAME_MAXLEN - 1 },
+};
+
 static int nft_flow_offload_init(const struct nft_ctx *ctx,
 				 const struct nft_expr *expr,
 				 const struct nlattr * const tb[])
@@ -204,6 +209,7 @@ static const struct nft_expr_ops nft_flow_offload_ops = {
 static struct nft_expr_type nft_flow_offload_type __read_mostly = {
 	.name		= "flow_offload",
 	.ops		= &nft_flow_offload_ops,
+	.policy		= nft_flow_offload_policy,
 	.maxattr	= NFTA_FLOW_MAX,
 	.owner		= THIS_MODULE,
 };
-- 
2.20.1

