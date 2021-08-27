Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91BDE3F91BB
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 03:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244222AbhH0BAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 21:00:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:53802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244002AbhH0A73 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 20:59:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78E12610F9;
        Fri, 27 Aug 2021 00:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630025903;
        bh=E34m+DahsZMlpn1//nQ2cqGaChzD3rJ0UGaQWknHaAI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IsQlJL0Jr8x30FbzHizrE9/HUkOIvB98nhn2lbnihf+2Kr0W9BRsMkmAXP5CZQcK+
         ANapvpjFgGFNzBAFnGKFedNJOYXIJF7wBC/0fGDFc87bVA9YWSeQhkmwhTnPKLINk1
         jyE/vboErAiqigE5TGDUr1dcd/09bVfHZh005y6kX0F+m5tywd92AcQ+xnqK2QvXNu
         7t+ihM4slbo42N/1pRAVAvnEHk3QSa4PNz+eWY6EA0Q6sb4lGzMwVgkhwJEkH62avW
         8l7Ec0xyicemRiqDq1dXqkFVIP5dx6TWAo0cabNCtLPdoQT6bvdXp2HMNFxyn166VV
         NV+ceb1U6r/hw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Alex Vesker <valex@mellanox.com>,
        Alex Vesker <valex@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 12/17] net/mlx5: DR, Skip source port matching on FDB RX domain
Date:   Thu, 26 Aug 2021 17:57:57 -0700
Message-Id: <20210827005802.236119-13-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210827005802.236119-1-saeed@kernel.org>
References: <20210827005802.236119-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

The FDB RX pipe is connected to the wire and the source port for all
incoming packets equals to wire, single uplink port per PF, this means
there is no point of matching on the source port in such case.
Once we recognize such case, we will optimize the RX steering rule.
Note that in such case we clean both source_eswitch_owner_vhca_id and
source_port.

Signed-off-by: Alex Vesker <valex@mellanox.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_matcher.c       | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
index 6f6191d1d5a6..f0d9f941acfd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_matcher.c
@@ -396,6 +396,7 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_matcher *matcher,
 	struct mlx5dr_domain *dmn = matcher->tbl->dmn;
 	struct mlx5dr_ste_ctx *ste_ctx = dmn->ste_ctx;
 	struct mlx5dr_match_param mask = {};
+	bool allow_empty_match = false;
 	struct mlx5dr_ste_build *sb;
 	bool inner, rx;
 	int idx = 0;
@@ -428,6 +429,16 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_matcher *matcher,
 	if (ret)
 		return ret;
 
+	/* Optimize RX pipe by reducing source port match, since
+	 * the FDB RX part is connected only to the wire.
+	 */
+	if (dmn->type == MLX5DR_DOMAIN_TYPE_FDB &&
+	    rx && mask.misc.source_port) {
+		mask.misc.source_port = 0;
+		mask.misc.source_eswitch_owner_vhca_id = 0;
+		allow_empty_match = true;
+	}
+
 	/* Outer */
 	if (matcher->match_criteria & (DR_MATCHER_CRITERIA_OUTER |
 				       DR_MATCHER_CRITERIA_MISC |
@@ -619,7 +630,8 @@ static int dr_matcher_set_ste_builders(struct mlx5dr_matcher *matcher,
 	}
 
 	/* Empty matcher, takes all */
-	if (matcher->match_criteria == DR_MATCHER_CRITERIA_EMPTY)
+	if ((!idx && allow_empty_match) ||
+	    matcher->match_criteria == DR_MATCHER_CRITERIA_EMPTY)
 		mlx5dr_ste_build_empty_always_hit(&sb[idx++], rx);
 
 	if (idx == 0) {
-- 
2.31.1

