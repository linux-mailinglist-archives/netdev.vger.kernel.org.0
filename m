Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07443614412
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 06:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbiKAFI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 01:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiKAFI1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 01:08:27 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E9ECE0E4
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 22:08:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=2x36l3SznhLQmcwcjhxK19k/WOdI5pFX2zebetp4nOk=; b=sEuueyizaO+KRUtgyip51lk8to
        VQN5CJH/NJbJnDILVe6QVUBLd4DVepPE2DtpMfSLUVJJJei5ILskzdPcQwQ9gQ3t3BO47zSAoEsGy
        dv7lfCPRjcI6q/+mQAhLaeRpch6uW4z5tZyVSBQ83imJb7m6mCoh9h4EHEIanspFjc54vyrrYAkMv
        ipHP4/nf8Vmhzhp8q5QjpY/016BXOuOrN9HOP5+jLUQYRZfrQlzUnIEzO536NZqDArDQ5dQJFAQbl
        b9ucx63unPYv2o3vtTtS4dhWitnZmPfR7XfxIK3Sxy1s3xSfirnVsx6g3IOTceR1iF7KT3HYtfxjf
        0juxw0wg==;
Received: from [2601:1c2:d80:3110::a2e7] (helo=casper.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1opjVf-004KJj-J2; Tue, 01 Nov 2022 05:08:24 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH] net: octeontx2-pf: mcs: consider MACSEC setting
Date:   Mon, 31 Oct 2022 22:08:13 -0700
Message-Id: <20221101050813.31567-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Fix build errors when MACSEC=m and OCTEONTX2_PF=y by having
OCTEONTX2_PF depend on MACSEC if it is enabled. By adding
"|| !MACSEC", this means that MACSEC is not required -- it can
be disabled for this driver.

drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.o: in function `otx2_remove':
../drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c:(.text+0x2fd0): undefined reference to `cn10k_mcs_free'
mips64-linux-ld: drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.o: in function `otx2_mbox_up_handler_mcs_intr_notify':
../drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c:(.text+0x4610): undefined reference to `cn10k_handle_mcs_event'

Reported-by: kernel test robot <lkp@intel.com>
Fixes: c54ffc73601c ("octeontx2-pf: mcs: Introduce MACSEC hardware offloading")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Subbaraya Sundeep <sbhatta@marvell.com>
Cc: Sunil Goutham <sgoutham@marvell.com>
Cc: Geetha sowjanya <gakula@marvell.com>
Cc: hariprasad <hkelam@marvell.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
---
 drivers/net/ethernet/marvell/octeontx2/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -- a/drivers/net/ethernet/marvell/octeontx2/Kconfig b/drivers/net/ethernet/marvell/octeontx2/Kconfig
--- a/drivers/net/ethernet/marvell/octeontx2/Kconfig
+++ b/drivers/net/ethernet/marvell/octeontx2/Kconfig
@@ -36,6 +36,7 @@ config OCTEONTX2_PF
 	select DIMLIB
 	depends on PCI
 	depends on PTP_1588_CLOCK_OPTIONAL
+	depends on MACSEC || !MACSEC
 	help
 	  This driver supports Marvell's OcteonTX2 NIC physical function.
 
