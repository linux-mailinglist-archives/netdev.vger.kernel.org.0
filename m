Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05F7659F171
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 04:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbiHXCm3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 22:42:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiHXCm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 22:42:29 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 450624AD50;
        Tue, 23 Aug 2022 19:42:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=Z5Rai+Yz/ML3qX99QzbSgFXXkcvlBJv03xi3Ix5d6i4=; b=ue3EAigaYRtDCLNW20ElIoK+19
        MWQ2/+dkTh2rP9uDPgZXUEueLmMhy5+77jUcXXQrlNghMbZ8VI+5yf/I134lA9qB2iVrQwth1TpEd
        VpYD/ezS7CRuu4p+N3aZm8DsDpyQGuOSmeM+VtsbEmK/+yqPDcu7PTj8QAZnOkPIbryD2hE/p6hO/
        f+M6dlpAWuIOvaQu27JLlN5YaeRWwwYg7qxVhi25YrVQ8T5K8QU9ZDHMS1e38P4bAQ7gf4pA7zs+A
        1yIs2VRQuzRDJ4DVhY3oWOGzLemk9+pnQxkl2iXtpy0guyhpSSANShgJ3iT/dOL1c76IvLDqyUSmv
        fwnM3sTA==;
Received: from [2601:1c0:6280:3f0::a6b3] (helo=casper.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oQgLX-00Freh-9N; Wed, 24 Aug 2022 02:42:23 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ravi Gunasekaran <r-gunasekaran@ti.com>,
        linux-omap@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH net-next] net: ethernet: ti: davinci_mdio: fix build for mdio bitbang uses
Date:   Tue, 23 Aug 2022 19:42:16 -0700
Message-Id: <20220824024216.4939-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

davinci_mdio.c uses mdio bitbang APIs, so it should select
MDIO_BITBANG to prevent build errors.

arm-linux-gnueabi-ld: drivers/net/ethernet/ti/davinci_mdio.o: in function `davinci_mdio_remove':
drivers/net/ethernet/ti/davinci_mdio.c:649: undefined reference to `free_mdio_bitbang'
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/davinci_mdio.o: in function `davinci_mdio_probe':
drivers/net/ethernet/ti/davinci_mdio.c:545: undefined reference to `alloc_mdio_bitbang'
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/davinci_mdio.o: in function `davinci_mdiobb_read':
drivers/net/ethernet/ti/davinci_mdio.c:236: undefined reference to `mdiobb_read'
arm-linux-gnueabi-ld: drivers/net/ethernet/ti/davinci_mdio.o: in function `davinci_mdiobb_write':
drivers/net/ethernet/ti/davinci_mdio.c:253: undefined reference to `mdiobb_write'

Fixes: d04807b80691 ("net: ethernet: ti: davinci_mdio: Add workaround for errata i2329")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Ravi Gunasekaran <r-gunasekaran@ti.com>
Cc: linux-omap@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Sudip Mukherjee (Codethink) <sudipm.mukherjee@gmail.com>
---
 drivers/net/ethernet/ti/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/ti/Kconfig
+++ b/drivers/net/ethernet/ti/Kconfig
@@ -33,6 +33,7 @@ config TI_DAVINCI_MDIO
 	tristate "TI DaVinci MDIO Support"
 	depends on ARCH_DAVINCI || ARCH_OMAP2PLUS || ARCH_KEYSTONE || ARCH_K3 || COMPILE_TEST
 	select PHYLIB
+	select MDIO_BITBANG
 	help
 	  This driver supports TI's DaVinci MDIO module.
 
