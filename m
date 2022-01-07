Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C762A486F4C
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 01:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344881AbiAGA7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 19:59:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344916AbiAGA6y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 19:58:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B45C06118C
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 16:58:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3EFD561EA7
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 00:58:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A0C2C36AEF;
        Fri,  7 Jan 2022 00:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641517127;
        bh=KJBin5FhZYF8zk2MdB2wpmPQh44P4pM3MGHYlausuE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lo/VHf4c/eRYprM5Qrn9u6bDyBt8N1JAjVK3nLjdpyqgegznrK0pgcJydQWZjkaVk
         aBN7qRuUQQELhWn1/F5LoSBnnHb9eulexLedEZhUMWIPQ03DemIwcbUjTuCPET8SLV
         LmDfMeHpUyRzsLeIqItII4Q+QXvzWXIBrRcQuot0T8xD+Zdhl6CBQPoOKYCYCTOFmM
         Wh3GkV/CtJSeRQZwT8CWd8fjstY1e4qquhSY/liI487kQgGBsuyqwaLLAK62tpNzRQ
         FXAluVli6za564tsaG0IuRnQbkX3sAgl49GTBiLZQfLzkBg+TxKZ2QGbEW2StzMpEP
         rh9qLEBo2Ph0Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Shay Drory <shayd@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 08/11] net/mlx5: Fix access to sf_dev_table on allocation failure
Date:   Thu,  6 Jan 2022 16:58:28 -0800
Message-Id: <20220107005831.78909-9-saeed@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220107005831.78909-1-saeed@kernel.org>
References: <20220107005831.78909-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

Even when SF devices are supported, the SF device table allocation
can still fail.
In such case mlx5_sf_dev_supported still reports true, but SF device
table is invalid. This can result in NULL table access.

Hence, fix it by adding NULL table check.

Fixes: 1958fc2f0712 ("net/mlx5: SF, Add auxiliary device driver")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
index f37db7cc32a6..7da012ff0d41 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/dev.c
@@ -30,10 +30,7 @@ bool mlx5_sf_dev_allocated(const struct mlx5_core_dev *dev)
 {
 	struct mlx5_sf_dev_table *table = dev->priv.sf_dev_table;
 
-	if (!mlx5_sf_dev_supported(dev))
-		return false;
-
-	return !xa_empty(&table->devices);
+	return table && !xa_empty(&table->devices);
 }
 
 static ssize_t sfnum_show(struct device *dev, struct device_attribute *attr, char *buf)
-- 
2.33.1

