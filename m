Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C20E3B8CC7
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 10:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395289AbfITI1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 04:27:16 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2691 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388411AbfITI1Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Sep 2019 04:27:16 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 10334526B13114035257;
        Fri, 20 Sep 2019 16:27:14 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Fri, 20 Sep 2019 16:27:03 +0800
From:   Mao Wenan <maowenan@huawei.com>
To:     <netanel@amazon.com>, <saeedb@amazon.com>, <zorik@amazon.com>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, Mao Wenan <maowenan@huawei.com>
Subject: [PATCH net] net: ena: Add dependency for ENA_ETHERNET
Date:   Fri, 20 Sep 2019 16:44:05 +0800
Message-ID: <20190920084405.140750-1-maowenan@huawei.com>
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

If CONFIG_ENA_ETHERNET=y and CONFIG_DIMLIB=n,
below erros can be found:
drivers/net/ethernet/amazon/ena/ena_netdev.o: In function `ena_dim_work':
ena_netdev.c:(.text+0x21cc): undefined reference to `net_dim_get_rx_moderation'
ena_netdev.c:(.text+0x21cc): relocation truncated to
fit: R_AARCH64_CALL26 against undefined symbol `net_dim_get_rx_moderation'
drivers/net/ethernet/amazon/ena/ena_netdev.o: In function `ena_io_poll':
ena_netdev.c:(.text+0x7bd4): undefined reference to `net_dim'
ena_netdev.c:(.text+0x7bd4): relocation truncated to fit:
R_AARCH64_CALL26 against undefined symbol `net_dim'

After commit 282faf61a053 ("net: ena: switch to dim algorithm for rx adaptive
interrupt moderation"), it introduces dim algorithm, which configured by CONFIG_DIMLIB.

Fixes: 282faf61a053 ("net: ena: switch to dim algorithm for rx adaptive interrupt moderation")
Signed-off-by: Mao Wenan <maowenan@huawei.com>
---
 drivers/net/ethernet/amazon/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/Kconfig b/drivers/net/ethernet/amazon/Kconfig
index 69ca99d..fe46df4 100644
--- a/drivers/net/ethernet/amazon/Kconfig
+++ b/drivers/net/ethernet/amazon/Kconfig
@@ -18,7 +18,7 @@ if NET_VENDOR_AMAZON
 
 config ENA_ETHERNET
 	tristate "Elastic Network Adapter (ENA) support"
-	depends on PCI_MSI && !CPU_BIG_ENDIAN
+	depends on PCI_MSI && !CPU_BIG_ENDIAN && DIMLIB
 	---help---
 	  This driver supports Elastic Network Adapter (ENA)"
 
-- 
2.7.4

