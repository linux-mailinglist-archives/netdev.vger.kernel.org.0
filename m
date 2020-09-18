Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28D5C270350
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 19:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbgIRR3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 13:29:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:38496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbgIRR26 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 13:28:58 -0400
Received: from sx1.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D661522211;
        Fri, 18 Sep 2020 17:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600450138;
        bh=wlbjAv6fMP17XrzPZTReecH5K/caX6fXoIM/jGBO7y0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q3Pt6m7KjpN9pNh9vj2LC4z9dI8Z35xmIuvU8aHNU45YIm5lBolpkkqbTyN+KMnlz
         mk072puTAI0yNycwdmTMVVu7c2jPLDT3DNU8uWHh1rJ81bcSkTHjOQXoILh5gdypfo
         QJSdOpb3bH1mfROizhjXLU0TQJ09rcL55/3shUGc=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Moshe Shemesh <moshe@nvidia.com>, Aya Levin <ayal@nvidia.com>
Subject: [net 15/15] net/mlx5e: mlx5e_fec_in_caps() returns a boolean
Date:   Fri, 18 Sep 2020 10:28:39 -0700
Message-Id: <20200918172839.310037-16-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200918172839.310037-1-saeed@kernel.org>
References: <20200918172839.310037-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@nvidia.com>

Returning errno is a bug, fix that.

Also fixes smatch warnings:
drivers/net/ethernet/mellanox/mlx5/core/en/port.c:453
mlx5e_fec_in_caps() warn: signedness bug returning '(-95)'

Fixes: 2132b71f78d2 ("net/mlx5e: Advertise globaly supported FEC modes")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Aya Levin <ayal@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/port.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port.c b/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
index 5de1cb9f5330..96608dbb9314 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
@@ -490,11 +490,8 @@ bool mlx5e_fec_in_caps(struct mlx5_core_dev *dev, int fec_policy)
 	int err;
 	int i;
 
-	if (!MLX5_CAP_GEN(dev, pcam_reg))
-		return -EOPNOTSUPP;
-
-	if (!MLX5_CAP_PCAM_REG(dev, pplm))
-		return -EOPNOTSUPP;
+	if (!MLX5_CAP_GEN(dev, pcam_reg) || !MLX5_CAP_PCAM_REG(dev, pplm))
+		return false;
 
 	MLX5_SET(pplm_reg, in, local_port, 1);
 	err =  mlx5_core_access_reg(dev, in, sz, out, sz, MLX5_REG_PPLM, 0, 0);
-- 
2.26.2

