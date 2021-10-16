Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF5DC42FF7E
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 02:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239328AbhJPAl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 20:41:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:58806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239360AbhJPAlQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 20:41:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0433B61242;
        Sat, 16 Oct 2021 00:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634344749;
        bh=lVcqIlvm3wdEiiidjxhZ4J0BbnX9VyfDNKhXfWgW/n4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YlcZbxsf/0sLV72F2vpS0mHasZHV9s/fPy/fsYxkjJ87i8H+C3Vdq6uGnhTFeSbhs
         3EWyYq/yO4ayk5TR2E1PIz4t+MrIe00TLdy07nZEpl7yhrcL9QHfiBpoLYiUiu8oSt
         wmYbejPep33M2hK51QjwehKtNLBtyACdyk0M7tVh2cKi7OY66IIphurV1Lqc2yoo83
         2NY2BZlnMpY8cqs/yIdVll5X1Aw3DBkIw/AHrQ9zpDQ4BUOqU8+TtbkrdQ5ttbIl9g
         t8KyPrww8Px09jpnIPVD6y9Bewitei5SSaOhuzceoxaBvL0lDLa25oiZwGD+NGoeHO
         hXee/5hr5eZnA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Rongwei Liu <rongweil@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 12/13] net/mlx5: Use native_port_num as 1st option of device index
Date:   Fri, 15 Oct 2021 17:39:01 -0700
Message-Id: <20211016003902.57116-13-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211016003902.57116-1-saeed@kernel.org>
References: <20211016003902.57116-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rongwei Liu <rongweil@nvidia.com>

Using "native_port_num" can support more NICs.

Fallback to PCIe IDs if "native_port_num" query fails.

Signed-off-by: Rongwei Liu <rongweil@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/mlx5/driver.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index aecc38b90de5..cf508685abca 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1245,7 +1245,12 @@ static inline int mlx5_core_native_port_num(struct mlx5_core_dev *dev)
 
 static inline int mlx5_get_dev_index(struct mlx5_core_dev *dev)
 {
-	return PCI_FUNC(dev->pdev->devfn);
+	int idx = MLX5_CAP_GEN(dev, native_port_num);
+
+	if (idx >= 1 && idx <= MLX5_MAX_PORTS)
+		return idx - 1;
+	else
+		return PCI_FUNC(dev->pdev->devfn);
 }
 
 enum {
-- 
2.31.1

