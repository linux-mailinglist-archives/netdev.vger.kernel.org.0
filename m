Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 667494FCAE0
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 03:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244860AbiDLBCU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 21:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345205AbiDLA63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 20:58:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBB4A2ED67;
        Mon, 11 Apr 2022 17:51:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A69060B2B;
        Tue, 12 Apr 2022 00:51:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B3CC385A4;
        Tue, 12 Apr 2022 00:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724673;
        bh=ALhvnJwo26FxvnTU0TvhN/+2rW3DOotXJx2CRK1NBOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JbjCB0TR1Qf9OclbX9Z9r3RT4AVF6Z8/fu68Dzl/+NZ4czOlVWe4mPPAaE9VfQaHD
         u3jU36r4NgQuCAoV4FAYimmoi33J9hh9kBrkv1/avJyz/QDcndpFZDgFMnSYEn4/WC
         PcEvuJ+SBFKR6t8yqPmFXn0RmyTKPCJN70v0wIvGPKjJABNtPp+JCK0XmNGAdA6bkd
         c1VnFn1fetOxZ/ttVanYsUWMSczDgv1/tNMVqN+jSC3//cufZnG3oSfckVCDsoNIB5
         H5LBpTrJ5l1csJnD+6k2ct5k9v71RZIKvdlA4OawqXWp5o00qbPIgx/Y5CNL9+AmcN
         9Kko0vj1pw1pg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>, horatiu.vultur@microchip.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 09/21] net: micrel: fix KS8851_MLL Kconfig
Date:   Mon, 11 Apr 2022 20:50:28 -0400
Message-Id: <20220412005042.351105-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412005042.351105-1-sashal@kernel.org>
References: <20220412005042.351105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit c3efcedd272aa6dd5929e20cf902a52ddaa1197a ]

KS8851_MLL selects MICREL_PHY, which depends on PTP_1588_CLOCK_OPTIONAL,
so make KS8851_MLL also depend on PTP_1588_CLOCK_OPTIONAL since
'select' does not follow any dependency chains.

Fixes kconfig warning and build errors:

WARNING: unmet direct dependencies detected for MICREL_PHY
  Depends on [m]: NETDEVICES [=y] && PHYLIB [=y] && PTP_1588_CLOCK_OPTIONAL [=m]
  Selected by [y]:
  - KS8851_MLL [=y] && NETDEVICES [=y] && ETHERNET [=y] && NET_VENDOR_MICREL [=y] && HAS_IOMEM [=y]

ld: drivers/net/phy/micrel.o: in function `lan8814_ts_info':
micrel.c:(.text+0xb35): undefined reference to `ptp_clock_index'
ld: drivers/net/phy/micrel.o: in function `lan8814_probe':
micrel.c:(.text+0x2586): undefined reference to `ptp_clock_register'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/micrel/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/micrel/Kconfig b/drivers/net/ethernet/micrel/Kconfig
index b9c4d48e28e4..120ed4633a09 100644
--- a/drivers/net/ethernet/micrel/Kconfig
+++ b/drivers/net/ethernet/micrel/Kconfig
@@ -37,6 +37,7 @@ config KS8851
 config KS8851_MLL
 	tristate "Micrel KS8851 MLL"
 	depends on HAS_IOMEM
+	depends on PTP_1588_CLOCK_OPTIONAL
 	select MII
 	---help---
 	  This platform driver is for Micrel KS8851 Address/data bus
-- 
2.35.1

