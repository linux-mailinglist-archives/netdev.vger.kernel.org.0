Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2376D1EF7F3
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 14:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728009AbgFEMa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 08:30:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:57036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726825AbgFEMZg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jun 2020 08:25:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFC0C206DC;
        Fri,  5 Jun 2020 12:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591359935;
        bh=YlJD6YMMhL+i0hLnJJh5R5tyM7+o3K7d6jXSpkPPa7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FrOC/K5UVGtKmdbU1t6USEevian+kaDJCceGQk5O4voOq4hcvKUzRWMXgKyS1wq3T
         iJZrKJxU7yDcn3OlDSz+Wo/ZElhowdCDJlaD1kD/Jba4KthTJwIqx20IRRB0YIRsLL
         EtcdnvowPt1liZZA57veMV6pDo1TW4YWXOoA0mqE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 14/17] net/mlx5e: replace EINVAL in mlx5e_flower_parse_meta()
Date:   Fri,  5 Jun 2020 08:25:13 -0400
Message-Id: <20200605122517.2882338-14-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200605122517.2882338-1-sashal@kernel.org>
References: <20200605122517.2882338-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit a683012a8e77675a1947cc8f11f97cdc1d5bb769 ]

The drivers reports EINVAL to userspace through netlink on invalid meta
match. This is confusing since EINVAL is usually reserved for malformed
netlink messages. Replace it by more meaningful codes.

Fixes: 6d65bc64e232 ("net/mlx5e: Add mlx5e_flower_parse_meta support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 4659c205cc01..46ff83408d05 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1824,7 +1824,7 @@ static int mlx5e_flower_parse_meta(struct net_device *filter_dev,
 	flow_rule_match_meta(rule, &match);
 	if (match.mask->ingress_ifindex != 0xFFFFFFFF) {
 		NL_SET_ERR_MSG_MOD(extack, "Unsupported ingress ifindex mask");
-		return -EINVAL;
+		return -EOPNOTSUPP;
 	}
 
 	ingress_dev = __dev_get_by_index(dev_net(filter_dev),
@@ -1832,13 +1832,13 @@ static int mlx5e_flower_parse_meta(struct net_device *filter_dev,
 	if (!ingress_dev) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Can't find the ingress port to match on");
-		return -EINVAL;
+		return -ENOENT;
 	}
 
 	if (ingress_dev != filter_dev) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Can't match on the ingress filter port");
-		return -EINVAL;
+		return -EOPNOTSUPP;
 	}
 
 	return 0;
-- 
2.25.1

