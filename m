Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 020371AA45A
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 15:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2636054AbgDONXz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 09:23:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:54384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408870AbgDOLey (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 07:34:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 975F12078A;
        Wed, 15 Apr 2020 11:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586950494;
        bh=p1enY6KEEfPg5BERZrqrGi5lTMcebhV3eMgurFeKhkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p9+rchdp8pv/+xrLJFMCK/9c1iprQgdKAjghRQQ6O3Pb5/yrwQljR4CRHUF5KC0js
         AzXXYfUMFUlZai0goYO+TZQ2e/on2/TsNLwEh4N9MZsUINua7cqkeVZ2mbJBomFk9h
         IO/fUdhPVfj/OhU1j5wn2av74nTtsi9+pyCPS7Qs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 007/129] net/mlx5e: Enforce setting of a single FEC mode
Date:   Wed, 15 Apr 2020 07:32:42 -0400
Message-Id: <20200415113445.11881-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415113445.11881-1-sashal@kernel.org>
References: <20200415113445.11881-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

[ Upstream commit 4bd9d5070b92da012f2715cf8e4859acb78b8f35 ]

Ethtool command allow setting of several FEC modes in a single set
command. The driver can only set a single FEC mode at a time. With this
patch driver will reply not-supported on setting several FEC modes.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index d674cb6798950..d1664ff1772b6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -1541,6 +1541,10 @@ static int mlx5e_set_fecparam(struct net_device *netdev,
 	int mode;
 	int err;
 
+	if (bitmap_weight((unsigned long *)&fecparam->fec,
+			  ETHTOOL_FEC_BASER_BIT + 1) > 1)
+		return -EOPNOTSUPP;
+
 	for (mode = 0; mode < ARRAY_SIZE(pplm_fec_2_ethtool); mode++) {
 		if (!(pplm_fec_2_ethtool[mode] & fecparam->fec))
 			continue;
-- 
2.20.1

