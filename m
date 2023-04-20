Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0F6F6E9DF5
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 23:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232222AbjDTVgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 17:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231728AbjDTVgr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 17:36:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C46C630D2;
        Thu, 20 Apr 2023 14:36:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5FEF164C0F;
        Thu, 20 Apr 2023 21:36:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E847C433D2;
        Thu, 20 Apr 2023 21:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682026604;
        bh=Z8PCVb43VPYumi49oswxlbKcQT64xKfIJwE1ERJqy3E=;
        h=From:To:Cc:Subject:Date:From;
        b=pzg1ftMPa8YHaOG0kF2gofVqmQEfLbiqFO2EKPfC+6IduvV1lxpsVJRUUCSLQfSUu
         6RWi+xZHCBtqyMZbfUYQsVBjt0oKJ1EEjSGMpDTlUFv58XiZ02YaDAbziXtePijID2
         PIsDVh9cmkxuo9UEjeNZ/zjfCPjpCAByHVxjqnSczE9zOzxF2eBVN7KmmnsuDZSYRR
         Z01vnDe6IPqPV65CrgNs8vZEyk5hULT3UqlJIGs/QHlT0yAOny/vHIeH3l3KKr3oU3
         TuCH6nqhtlh7mdynoy9YfrUwgrzcDlikKQYxe+L6GRm8o7b5eACRbuOdaY5FO5GOve
         MM9U1SePfql4Q==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Christian Marangi <ansuelsmth@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: dsa: qca8k: fix LEDS_CLASS dependency
Date:   Thu, 20 Apr 2023 23:36:31 +0200
Message-Id: <20230420213639.2243388-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

With LEDS_CLASS=m, a built-in qca8k driver fails to link:

arm-linux-gnueabi-ld: drivers/net/dsa/qca/qca8k-leds.o: in function `qca8k_setup_led_ctrl':
qca8k-leds.c:(.text+0x1ea): undefined reference to `devm_led_classdev_register_ext'

Change the dependency to avoid the broken configuration.

Fixes: 1e264f9d2918 ("net: dsa: qca8k: add LEDs basic support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/dsa/qca/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/qca/Kconfig b/drivers/net/dsa/qca/Kconfig
index 7a86d6d6a246..4347b42c50fd 100644
--- a/drivers/net/dsa/qca/Kconfig
+++ b/drivers/net/dsa/qca/Kconfig
@@ -19,7 +19,7 @@ config NET_DSA_QCA8K
 config NET_DSA_QCA8K_LEDS_SUPPORT
 	bool "Qualcomm Atheros QCA8K Ethernet switch family LEDs support"
 	depends on NET_DSA_QCA8K
-	depends on LEDS_CLASS
+	depends on LEDS_CLASS=y || LEDS_CLASS=NET_DSA_QCA8K
 	help
 	  This enabled support for LEDs present on the Qualcomm Atheros
 	  QCA8K Ethernet switch chips.
-- 
2.39.2

