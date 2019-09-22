Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A87F0BA129
	for <lists+netdev@lfdr.de>; Sun, 22 Sep 2019 07:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727524AbfIVFWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Sep 2019 01:22:14 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:49470 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727501AbfIVFWO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Sep 2019 01:22:14 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 07A87247729FEC1F7A8F;
        Sun, 22 Sep 2019 13:22:08 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Sun, 22 Sep 2019 13:21:59 +0800
From:   Mao Wenan <maowenan@huawei.com>
To:     <netanel@amazon.com>, <saeedb@amazon.com>, <zorik@amazon.com>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, Mao Wenan <maowenan@huawei.com>
Subject: [PATCH v2 net] net: ena: Select DIMLIB for ENA_ETHERNET
Date:   Sun, 22 Sep 2019 13:38:08 +0800
Message-ID: <20190922053808.117965-1-maowenan@huawei.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190921200741.1c3289e8@cakuba.netronome.com>
References: <20190921200741.1c3289e8@cakuba.netronome.com>
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
So, this patch is to select DIMLIB for ENA_ETHERNET.

Fixes: 282faf61a053 ("net: ena: switch to dim algorithm for rx adaptive interrupt moderation")
Signed-off-by: Mao Wenan <maowenan@huawei.com>
---
 v2: change subject of patch, use the "select" keyword instead of "depends".
 drivers/net/ethernet/amazon/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/amazon/Kconfig b/drivers/net/ethernet/amazon/Kconfig
index 69ca99d8ac26..cca72a75f551 100644
--- a/drivers/net/ethernet/amazon/Kconfig
+++ b/drivers/net/ethernet/amazon/Kconfig
@@ -19,6 +19,7 @@ if NET_VENDOR_AMAZON
 config ENA_ETHERNET
 	tristate "Elastic Network Adapter (ENA) support"
 	depends on PCI_MSI && !CPU_BIG_ENDIAN
+	select DIMLIB
 	---help---
 	  This driver supports Elastic Network Adapter (ENA)"
 
-- 
2.20.1

