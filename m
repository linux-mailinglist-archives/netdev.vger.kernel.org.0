Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E09DF28081D
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 21:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733095AbgJATxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 15:53:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:40450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733031AbgJATxR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 15:53:17 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A17521D82;
        Thu,  1 Oct 2020 19:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601581996;
        bh=1q9hPhhtfibTMsqVbaaAYf+OabxR7NCQzWZkd98DhL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=StlTxWjua6zUq7zuSFuAid65f5LaQs7+bmFPvwZgaWyb0TFFolA/BDTwg7iSV6lB0
         D2XTX+f2sVgz3TX7oMie5pZP26tZDyJmgjM1sKS5MKcVaAN48c4c62k2yWxC18A275
         Nk28eyVbFVHABjQEuj1lko3Y4FKmY6BvGYUuLj2o=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net V2 12/15] net/mlx5e: Fix return status when setting unsupported FEC mode
Date:   Thu,  1 Oct 2020 12:52:44 -0700
Message-Id: <20201001195247.66636-13-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201001195247.66636-1-saeed@kernel.org>
References: <20201001195247.66636-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Verify the configured FEC mode is supported by at least a single link
mode before applying the command. Otherwise fail the command and return
"Operation not supported".
Prior to this patch, the command was successful, yet it falsely set all
link modes to FEC auto mode - like configuring FEC mode to auto. Auto
mode is the default configuration if a link mode doesn't support the
configured FEC mode.

Fixes: b5ede32d3329 ("net/mlx5e: Add support for FEC modes based on 50G per lane links")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Eran Ben Elisha <eranbe@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/port.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port.c b/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
index 96608dbb9314..308fd279669e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
@@ -569,6 +569,9 @@ int mlx5e_set_fec_mode(struct mlx5_core_dev *dev, u16 fec_policy)
 	if (fec_policy >= (1 << MLX5E_FEC_LLRS_272_257_1) && !fec_50g_per_lane)
 		return -EOPNOTSUPP;
 
+	if (fec_policy && !mlx5e_fec_in_caps(dev, fec_policy))
+		return -EOPNOTSUPP;
+
 	MLX5_SET(pplm_reg, in, local_port, 1);
 	err = mlx5_core_access_reg(dev, in, sz, out, sz, MLX5_REG_PPLM, 0, 0);
 	if (err)
-- 
2.26.2

