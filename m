Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B966525963
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 03:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376350AbiEMB2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 21:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376345AbiEMB2h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 21:28:37 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71E5728ED19;
        Thu, 12 May 2022 18:28:36 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4KzrWj1srjzCsg1;
        Fri, 13 May 2022 09:23:45 +0800 (CST)
Received: from dggpeml500008.china.huawei.com (7.185.36.147) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 13 May 2022 09:28:34 +0800
Received: from huawei.com (10.67.175.34) by dggpeml500008.china.huawei.com
 (7.185.36.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 13 May
 2022 09:28:34 +0800
From:   Ren Zhijie <renzhijie2@huawei.com>
To:     <ecree.xilinx@gmail.com>, <habetsm.xilinx@gmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Ren Zhijie <renzhijie2@huawei.com>
Subject: [PATCH -next] sfc: siena: Fix Kconfig dependencies
Date:   Fri, 13 May 2022 09:27:21 +0800
Message-ID: <20220513012721.140871-1-renzhijie2@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.175.34]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500008.china.huawei.com (7.185.36.147)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If CONFIG_PTP_1588_CLOCK=m and CONFIG_SFC_SIENA=y, the siena driver will fail to link:

drivers/net/ethernet/sfc/siena/ptp.o: In function `efx_ptp_remove_channel':
ptp.c:(.text+0xa28): undefined reference to `ptp_clock_unregister'
drivers/net/ethernet/sfc/siena/ptp.o: In function `efx_ptp_probe_channel':
ptp.c:(.text+0x13a0): undefined reference to `ptp_clock_register'
ptp.c:(.text+0x1470): undefined reference to `ptp_clock_unregister'
drivers/net/ethernet/sfc/siena/ptp.o: In function `efx_ptp_pps_worker':
ptp.c:(.text+0x1d29): undefined reference to `ptp_clock_event'
drivers/net/ethernet/sfc/siena/ptp.o: In function `efx_siena_ptp_get_ts_info':
ptp.c:(.text+0x301b): undefined reference to `ptp_clock_index'

To fix this build error, make SFC_SIENA depends on PTP_1588_CLOCK.

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: d48523cb88e0("sfc: Copy shared files needed for Siena (part 2)")
Signed-off-by: Ren Zhijie <renzhijie2@huawei.com>
---
 drivers/net/ethernet/sfc/siena/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/sfc/siena/Kconfig b/drivers/net/ethernet/sfc/siena/Kconfig
index 3d52aee50d5a..3675233e963a 100644
--- a/drivers/net/ethernet/sfc/siena/Kconfig
+++ b/drivers/net/ethernet/sfc/siena/Kconfig
@@ -2,6 +2,7 @@
 config SFC_SIENA
 	tristate "Solarflare SFC9000 support"
 	depends on PCI
+	depends on PTP_1588_CLOCK
 	select MDIO
 	select CRC32
 	help
-- 
2.17.1

