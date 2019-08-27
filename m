Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEEFE9DBE3
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 05:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbfH0DJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 23:09:36 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:52196 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728025AbfH0DJg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Aug 2019 23:09:36 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 6F790A9139607350119D;
        Tue, 27 Aug 2019 11:09:33 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Tue, 27 Aug 2019 11:09:23 +0800
From:   Mao Wenan <maowenan@huawei.com>
To:     <saeedm@mellanox.com>, <leon@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        Mao Wenan <maowenan@huawei.com>
Subject: [PATCH -next] net: mlx5: Kconfig: Fix MLX5_CORE_EN dependencies
Date:   Tue, 27 Aug 2019 11:12:51 +0800
Message-ID: <20190827031251.98881-1-maowenan@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When MLX5_CORE_EN=y and PCI_HYPERV_INTERFACE is not set, below errors are found:
drivers/net/ethernet/mellanox/mlx5/core/en_main.o: In function `mlx5e_nic_enable':
en_main.c:(.text+0xb649): undefined reference to `mlx5e_hv_vhca_stats_create'
drivers/net/ethernet/mellanox/mlx5/core/en_main.o: In function `mlx5e_nic_disable':
en_main.c:(.text+0xb8c4): undefined reference to `mlx5e_hv_vhca_stats_destroy'

This because CONFIG_PCI_HYPERV_INTERFACE is newly introduced by 'commit 348dd93e40c1
("PCI: hv: Add a Hyper-V PCI interface driver for software backchannel interface"),
Fix this by making MLX5_CORE_EN imply PCI_HYPERV_INTERFACE.

Fixes: cef35af34d6d ("net/mlx5e: Add mlx5e HV VHCA stats agent")
Signed-off-by: Mao Wenan <maowenan@huawei.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
index 37fef8c..a6a70ce 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -35,6 +35,7 @@ config MLX5_CORE_EN
 	depends on IPV6=y || IPV6=n || MLX5_CORE=m
 	select PAGE_POOL
 	select DIMLIB
+	imply PCI_HYPERV_INTERFACE
 	default n
 	---help---
 	  Ethernet support in Mellanox Technologies ConnectX-4 NIC.
-- 
2.7.4

