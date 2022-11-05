Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F177A61D7F2
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 07:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbiKEGhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 02:37:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiKEGhT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 02:37:19 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D98A7F03C
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 23:36:18 -0700 (PDT)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4N473F4HXKzJnQY;
        Sat,  5 Nov 2022 14:32:57 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 5 Nov 2022 14:35:54 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Sat, 5 Nov
 2022 14:35:54 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <sbhatta@marvell.com>, <sgoutham@marvell.com>,
        <davem@davemloft.net>
Subject: [PATCH net] octeontx2-pf: fix build error when CONFIG_OCTEONTX2_PF=y
Date:   Sat, 5 Nov 2022 14:34:42 +0800
Message-ID: <20221105063442.2013981-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If CONFIG_MACSEC=m and CONFIG_OCTEONTX2_PF=y, it leads a build error:

  ld: drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.o: in function `otx2_pfaf_mbox_up_handler':
  otx2_pf.c:(.text+0x181c): undefined reference to `cn10k_handle_mcs_event'
  ld: drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.o: in function `otx2_probe':
  otx2_pf.c:(.text+0x437e): undefined reference to `cn10k_mcs_init'
  ld: drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.o: in function `otx2_remove':
  otx2_pf.c:(.text+0x5031): undefined reference to `cn10k_mcs_free'
  ld: drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.o: in function `otx2_mbox_up_handler_mcs_intr_notify':
  otx2_pf.c:(.text+0x5f11): undefined reference to `cn10k_handle_mcs_event'

Make CONFIG_OCTEONTX2_PF depends on CONFIG_MACSEC to fix it. Because
it has empty stub functions of cn10k, CONFIG_OCTEONTX2_PF can be enabled
if CONFIG_MACSEC is disabled

Fixes: c54ffc73601c ("octeontx2-pf: mcs: Introduce MACSEC hardware offloading")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/ethernet/marvell/octeontx2/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/Kconfig b/drivers/net/ethernet/marvell/octeontx2/Kconfig
index 993ac180a5db..6b4f640163f7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/Kconfig
+++ b/drivers/net/ethernet/marvell/octeontx2/Kconfig
@@ -32,6 +32,7 @@ config OCTEONTX2_PF
 	tristate "Marvell OcteonTX2 NIC Physical Function driver"
 	select OCTEONTX2_MBOX
 	select NET_DEVLINK
+	depends on MACSEC || !MACSEC
 	depends on (64BIT && COMPILE_TEST) || ARM64
 	select DIMLIB
 	depends on PCI
-- 
2.25.1

