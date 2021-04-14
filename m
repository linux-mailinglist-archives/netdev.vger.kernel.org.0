Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0116635FE54
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 01:16:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237177AbhDNXQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 19:16:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:48958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235787AbhDNXQf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 19:16:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7DBE61244;
        Wed, 14 Apr 2021 23:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618442173;
        bh=yO+zByxMetjppPRmftdw3a+yBJ2CIIiTNlJer3JPl/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OSTXcHTuLaks0KwL5MFG6HGAjBruDQN/cFvkr2rSN2xzf9otpFvz8869FUeBPuHA1
         lz+lhbbL4uPCSLNCWLiIfbRt2NfaysOgytsDU3yNlZbyj3ys9MLmKjvT0rx+7YmBoc
         c5qxn6BIj9JJOQ/YKW0S6jS4JoWfrXTr8ndbvsT/FaqZ46/znsvOekuCTrproxIOIC
         D0S+jylZN3gFH2Yd7fs8vysyw6brGVU7nLy7JmeluhuyPIg4p5a6iFdiN0dinFUFPy
         MvEyY7azGi2Tnt7+Qz632VK9XS0AmWQQFR45AoY8BbMJWAc4Wh2y5tREw8s4JnHBiO
         vYE3BCW0cw4sQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        wenxu <wenxu@ucloud.cn>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 3/3] net/mlx5e: fix ingress_ifindex check in mlx5e_flower_parse_meta
Date:   Wed, 14 Apr 2021 16:16:10 -0700
Message-Id: <20210414231610.136376-4-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210414231610.136376-1-saeed@kernel.org>
References: <20210414231610.136376-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

In the nft_offload there is the mate flow_dissector with no
ingress_ifindex but with ingress_iftype that only be used
in the software. So if the mask of ingress_ifindex in meta is
0, this meta check should be bypass.

Fixes: 6d65bc64e232 ("net/mlx5e: Add mlx5e_flower_parse_meta support")
Signed-off-by: wenxu <wenxu@ucloud.cn>
Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index df2a0af854bb..d675107d9eca 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1895,6 +1895,9 @@ static int mlx5e_flower_parse_meta(struct net_device *filter_dev,
 		return 0;
 
 	flow_rule_match_meta(rule, &match);
+	if (!match.mask->ingress_ifindex)
+		return 0;
+
 	if (match.mask->ingress_ifindex != 0xFFFFFFFF) {
 		NL_SET_ERR_MSG_MOD(extack, "Unsupported ingress ifindex mask");
 		return -EOPNOTSUPP;
-- 
2.30.2

