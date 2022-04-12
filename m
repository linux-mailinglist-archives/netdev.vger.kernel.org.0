Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7CAF4FCAF1
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 03:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343646AbiDLBC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 21:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349450AbiDLA7j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 20:59:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBFA938186;
        Mon, 11 Apr 2022 17:53:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8454B819BC;
        Tue, 12 Apr 2022 00:52:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CB1DC385AB;
        Tue, 12 Apr 2022 00:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724778;
        bh=cYzXXg1Vy1q7vvQEVY1rET2xsZpGFJS5PCjsVVvLFiQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tEzjUtYA5xc7PaqVhCOuAvyT1lDe/D8K+jsVT+rrVwTXjcIqRocVz4yYDlkp4Zrpy
         AWvd3h8zLUmOIZjLYU3swL7zjctiRuEOM7CxTGnTyg6XVaYaaWdRKlrMIDcis6mdrR
         SxmMO2k5dDS7OAUywFuuTQAIakOlPlVcN9JF456bWNFJszrBiwOvwjGMrAsAYOt+J3
         EKbb1g0HZ7q9f+4/+CAm8dbc/wh9BKpb8Y6P5F5xi8o63ROZllzfAtwiADkA7QAkU4
         Qf1wRj0y2Urf5S3/smqYP1S8nnw9kpQQafwY+5kZ5y5gf/lytvNPjT4uW3U2RYemgC
         JEuSrI3HNF3jg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>, horatiu.vultur@microchip.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 4/7] net: micrel: fix KS8851_MLL Kconfig
Date:   Mon, 11 Apr 2022 20:52:45 -0400
Message-Id: <20220412005248.351701-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412005248.351701-1-sashal@kernel.org>
References: <20220412005248.351701-1-sashal@kernel.org>
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
index b7e2f49696b7..aa12bace8673 100644
--- a/drivers/net/ethernet/micrel/Kconfig
+++ b/drivers/net/ethernet/micrel/Kconfig
@@ -45,6 +45,7 @@ config KS8851
 config KS8851_MLL
 	tristate "Micrel KS8851 MLL"
 	depends on HAS_IOMEM
+	depends on PTP_1588_CLOCK_OPTIONAL
 	select MII
 	---help---
 	  This platform driver is for Micrel KS8851 Address/data bus
-- 
2.35.1

