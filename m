Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF61273777
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 02:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729367AbgIVAbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 20:31:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:60648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729355AbgIVAbU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Sep 2020 20:31:20 -0400
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 37BDE23A9F;
        Tue, 22 Sep 2020 00:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600734680;
        bh=wlbjAv6fMP17XrzPZTReecH5K/caX6fXoIM/jGBO7y0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mmtko8zdYM6Gb7MzbPc97y1JGEzRSMajKMgKFoVIJqH+Lb3nLDpdj3TPeZP9WFEGS
         wdcHik5tG94r9Jl2lzNIoCB5cOCeEaFNoR+LZ/XB4MuWgZpFUY9Y1mhr478+pLLeZ8
         HC84q8lid3b5EDLYUDjQrUpFZFlyecx3fVg4ynrU=
From:   saeed@kernel.org
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Moshe Shemesh <moshe@nvidia.com>, Aya Levin <ayal@nvidia.com>
Subject: [net V2 15/15] net/mlx5e: mlx5e_fec_in_caps() returns a boolean
Date:   Mon, 21 Sep 2020 17:31:01 -0700
Message-Id: <20200922003101.529117-16-saeed@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200922003101.529117-1-saeed@kernel.org>
References: <20200922003101.529117-1-saeed@kernel.org>
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

