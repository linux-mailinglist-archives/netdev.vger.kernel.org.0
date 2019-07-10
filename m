Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 913C864472
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 11:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727140AbfGJJdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 05:33:04 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2199 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726080AbfGJJdE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jul 2019 05:33:04 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id DC934521168DE750CA9A;
        Wed, 10 Jul 2019 17:32:59 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Wed, 10 Jul 2019 17:32:52 +0800
From:   Mao Wenan <maowenan@huawei.com>
To:     <davem@davemloft.net>, <saeedm@mellanox.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Mao Wenan <maowenan@huawei.com>
Subject: [PATCH net-next] net: mlx5: Fix compiling error in tls.c
Date:   Wed, 10 Jul 2019 17:38:52 +0800
Message-ID: <20190710093852.34549-1-maowenan@huawei.com>
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

There are some errors while compiling tls.c if
CONFIG_MLX5_FPGA_TLS is not obvious on.

drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c: In function mlx5e_tls_set_ipv4_flow:
./include/linux/mlx5/device.h:61:39: error: invalid application of sizeof to incomplete type struct mlx5_ifc_tls_flow_bits
 #define __mlx5_st_sz_bits(typ) sizeof(struct mlx5_ifc_##typ##_bits)
                                       ^
./include/linux/compiler.h:330:9: note: in definition of macro __compiletime_assert
   if (!(condition))     \
         ^~~~~~~~~
...

drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c: In function mlx5e_tls_build_netdev:
drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c:202:13: error: MLX5_ACCEL_TLS_TX undeclared (first use in this function); did you mean __MLX5_ACCEL_TLS_H__?
  if (caps & MLX5_ACCEL_TLS_TX) {
             ^~~~~~~~~~~~~~~~~
             __MLX5_ACCEL_TLS_H__
drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c:207:13: error: MLX5_ACCEL_TLS_RX undeclared (first use in this function); did you mean MLX5_ACCEL_TLS_TX?
  if (caps & MLX5_ACCEL_TLS_RX) {
             ^~~~~~~~~~~~~~~~~
             MLX5_ACCEL_TLS_TX
drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.c:212:15: error: MLX5_ACCEL_TLS_LRO undeclared (first use in this function); did you mean MLX5_ACCEL_TLS_RX?
  if (!(caps & MLX5_ACCEL_TLS_LRO)) {
               ^~~~~~~~~~~~~~~~~~
               MLX5_ACCEL_TLS_RX
make[5]: *** [drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls.o] Error 1
make[5]: *** Waiting for unfinished jobs....
make[4]: *** [drivers/net/ethernet/mellanox/mlx5/core] Error 2
make[3]: *** [drivers/net/ethernet/mellanox] Error 2
make[3]: *** Waiting for unfinished jobs....
make[2]: *** [drivers/net/ethernet] Error 2
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [drivers/net] Error 2
make[1]: *** Waiting for unfinished jobs....
make: *** [drivers] Error 2
make: *** Waiting for unfinished jobs....

this patch is to fix this error using 'depends on MLX5_FPGA_TLS' when MLX5_TLS is set.

Fixes: e2869fb2068b ("net/mlx5: Kconfig, Better organize compilation flags")

Signed-off-by: Mao Wenan <maowenan@huawei.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
index 37fef8c..1da2770 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -139,6 +139,7 @@ config MLX5_TLS
 	depends on MLX5_CORE_EN
 	depends on TLS_DEVICE
 	depends on TLS=y || MLX5_CORE=m
+	depends on MLX5_FPGA_TLS
 	select MLX5_ACCEL
 	default n
 	help
-- 
2.7.4

