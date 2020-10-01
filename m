Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B28B27F8BD
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 06:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730806AbgJAEdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 00:33:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:39892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725925AbgJAEd3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 00:33:29 -0400
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C85C2311A;
        Thu,  1 Oct 2020 04:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601526800;
        bh=e3ak71DCWUV6xKVoIVqCVjqpOZbIyMPiNaKI7R/Y+dM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AVYNsq120mkPSR2sUbg/TDIQwP0XnYTT6rj2xN9v5o+TDllhTH5+rQS7c1WUtxoSr
         AaDzuifxhNOVDKkJamGBxSR3rakBMBEzdiS0AMKEotKgWc9XP/ODLE+5YCLPk5EaTt
         MVJm4KU+Kt7REL5+oIGipuke0G8jk95ykSjHGb+U=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 15/15] net/mlx5e: Fix potential null pointer dereference
Date:   Wed, 30 Sep 2020 21:33:02 -0700
Message-Id: <20201001043302.48113-16-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001043302.48113-1-saeed@kernel.org>
References: <20201001043302.48113-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavoars@kernel.org>

Calls to kzalloc() and kvzalloc() should be null-checked
in order to avoid any potential failures. In this case,
a potential null pointer dereference.

Fix this by adding null checks for _parse_attr_ and _flow_
right after allocation.

Addresses-Coverity-ID: 1497154 ("Dereference before null check")
Fixes: c620b772152b ("net/mlx5: Refactor tc flow attributes structure")
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 186dc2961000..a0c356987e1a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4536,20 +4536,22 @@ mlx5e_alloc_flow(struct mlx5e_priv *priv, int attr_size,
 	struct mlx5e_tc_flow_parse_attr *parse_attr;
 	struct mlx5_flow_attr *attr;
 	struct mlx5e_tc_flow *flow;
-	int out_index, err;
+	int err = -ENOMEM;
+	int out_index;
 
 	flow = kzalloc(sizeof(*flow), GFP_KERNEL);
 	parse_attr = kvzalloc(sizeof(*parse_attr), GFP_KERNEL);
+	if (!parse_attr || !flow)
+		goto err_free;
 
 	flow->flags = flow_flags;
 	flow->cookie = f->cookie;
 	flow->priv = priv;
 
 	attr = mlx5_alloc_flow_attr(get_flow_name_space(flow));
-	if (!parse_attr || !flow || !attr) {
-		err = -ENOMEM;
+	if (!attr)
 		goto err_free;
-	}
+
 	flow->attr = attr;
 
 	for (out_index = 0; out_index < MLX5_MAX_FLOW_FWD_VPORTS; out_index++)
-- 
2.26.2

