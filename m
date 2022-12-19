Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07369651128
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 18:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232012AbiLSRTt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 12:19:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231959AbiLSRTd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 12:19:33 -0500
Received: from box.opentheblackbox.net (box.opentheblackbox.net [IPv6:2600:3c02::f03c:92ff:fee2:82bc])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 165212FB;
        Mon, 19 Dec 2022 09:19:33 -0800 (PST)
Received: from authenticated-user (box.opentheblackbox.net [172.105.151.37])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.opentheblackbox.net (Postfix) with ESMTPSA id EB7B83EA50;
        Mon, 19 Dec 2022 12:19:31 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=pgazz.com; s=mail;
        t=1671470372; bh=9bYAYnsF3sM0kY4DcqJgvSrfn3Yhvu5t4LsWQCVQ22c=;
        h=From:To:Cc:Subject:Date:From;
        b=GJQcaj2xzpKLi5sHc3YQsD6NWInQKxVlMsfPXGSd/qlRDRg1emOaEYSLxr5ZmnJuu
         XQ4rx/Vz1CIH56ag6NqmeL8WRtR3Bk2fyjPJ4egMEOwFnnBpVWrQt8Ww9mjkh7+JRX
         J7CckD7a3o3jwPpXwkeuQPKdKpAjYO3LYOrfUurdlNnSDmlqLLm1tXSJH7HBdNrR3r
         S+PRCP024baGQTjsdTe/BpCgi7ZSr9wY3G/By6PGl+RX9kLxWYEi+Mmni1pgYJBl4c
         wt2NNus2JCUUYtmiVxY+3LqFwectQVi1eghXHD6S8FTKeIhmDUjufdcXkpJGra7ejn
         t8DPptsHTOv0w==
From:   Paul Gazzillo <paul@pgazz.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Zheng Bin <zhengbin13@huawei.com>,
        Suman Ghosh <sumang@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paul Gazzillo <paul@pgazz.com>
Subject: [PATCH v2] octeontx2_pf: Select NET_DEVLINK when enabling OCTEONTX2_PF
Date:   Mon, 19 Dec 2022 12:19:11 -0500
Message-Id: <20221219171918.834772-1-paul@pgazz.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_SBL_CSS,RCVD_IN_XBL,
        SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When using COMPILE_TEST, the driver controlled by OCTEONTX2_PF does
not select NET_DEVLINK while the related OCTEONTX2_AF driver does.
This means that when OCTEONTX2_PF is enabled from a default
configuration, linker errors will occur due to undefined references to
code controlled by NET_DEVLINK.

1. make.cross ARCH=x86_64 defconfig
2. make.cross ARCH=x86_64 menuconfig
3. Enable COMPILE_TEST
   General setup  --->
     Compile also drivers which will not load
4. Enable OCTEONTX2_PF
   Device Drivers  --->
     Network device support  --->
       Ethernet driver support  --->
         Marvell OcteonTX2 NIC Physical Function driver
5. Exit and save configuration.  NET_DEVLINK will still be disabled.
6. make.cross ARCH=x86_64 several linker errors, for example,
   ld: drivers/net/ethernet/marvell/octeontx2/nic/otx2_devlink.o:
     in function `otx2_register_dl':
   otx2_devlink.c:(.text+0x142): undefined reference to `devlink_alloc_ns'

This fix adds "select NET_DEVLINK" link to OCTEONTX2_PF's Kconfig
specification to match OCTEONTX2_AF.

Fixes: 2da489432747 ("octeontx2-pf: devlink params support to set mcam entry count")
Signed-off-by: Paul Gazzillo <paul@pgazz.com>
---
v1 -> v2: Added the fixes tag

 drivers/net/ethernet/marvell/octeontx2/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/Kconfig b/drivers/net/ethernet/marvell/octeontx2/Kconfig
index 3f982ccf2c85..639893d87055 100644
--- a/drivers/net/ethernet/marvell/octeontx2/Kconfig
+++ b/drivers/net/ethernet/marvell/octeontx2/Kconfig
@@ -31,6 +31,7 @@ config NDC_DIS_DYNAMIC_CACHING
 config OCTEONTX2_PF
 	tristate "Marvell OcteonTX2 NIC Physical Function driver"
 	select OCTEONTX2_MBOX
+	select NET_DEVLINK
 	depends on (64BIT && COMPILE_TEST) || ARM64
 	depends on PCI
 	depends on PTP_1588_CLOCK_OPTIONAL
-- 
2.25.1

