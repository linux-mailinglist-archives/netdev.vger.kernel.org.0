Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6AC0453F89
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 05:34:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232903AbhKQEhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 23:37:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:41442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231983AbhKQEhF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 23:37:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B3F6619F6;
        Wed, 17 Nov 2021 04:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637123647;
        bh=q5+ayHVuQGGf2sqcj9QuTW/GsOFmsbM9YF4CVcRPeTE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i/O0NPH59MmiyWe3xrAnjHKTwl9wyyCWCuYXBWLKGR0LLo6iDFsb3Im/5hJLTQq1+
         nnal4boLrnHVYRaTelZztI5IaEnZ50EhBRdLZ59Ntb46kEjCWEF78T0ALkG829kFth
         zpM1eDrBllIyjFxlLOfFXEA4JqTNoy0iflhWoNyqWA3K9JwWuY17RDzviPaRmyYNTc
         +hWXeQ2KT/X/B0XIXMdlys46mpXxFFmPX3RElChC8my9KvDw9QLru0OHc4Iztbdr8Q
         MLb10iwjWAeJa+Ig1PEfcmGS2CJLuoNVjMQwbQcYmUfhRW+4vt7L5ZEEISOEqmPKmv
         7rBfHFiXTsSng==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v0 03/15] net/mlx5: Avoid printing health buffer when firmware is unavailable
Date:   Tue, 16 Nov 2021 20:33:45 -0800
Message-Id: <20211117043357.345072-4-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211117043357.345072-1-saeed@kernel.org>
References: <20211117043357.345072-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Use firmware version field as an indication to health buffer's sanity.
When firmware version is 0xFFFFFFFF, deduce that firmware is unavailable
and avoid printing the health buffer to dmesg as it doesn't provide
debug info.

Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/health.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index 64f1abc4dc36..75121bc1eaa5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -420,6 +420,11 @@ static void print_health_info(struct mlx5_core_dev *dev)
 	if (!ioread8(&h->synd))
 		return;
 
+	if (ioread32be(&h->fw_ver) == 0xFFFFFFFF) {
+		mlx5_log(dev, LOGLEVEL_ERR, "PCI slot is unavailable\n");
+		return;
+	}
+
 	rfr_severity = ioread8(&h->rfr_severity);
 	severity  = mlx5_health_get_severity(rfr_severity);
 	mlx5_log(dev, severity, "Health issue observed, %s, severity(%d) %s:\n",
-- 
2.31.1

