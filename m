Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 966C069A8BE
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 10:59:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbjBQJ7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 04:59:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbjBQJ7Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 04:59:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9E6FF766;
        Fri, 17 Feb 2023 01:59:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A928DB82B5C;
        Fri, 17 Feb 2023 09:59:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B79B0C433D2;
        Fri, 17 Feb 2023 09:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676627953;
        bh=gC8fzzrUSCg6UTwoBVpBiyclU6InTgw8Xj/2u293vJw=;
        h=From:To:Cc:Subject:Date:From;
        b=oMNOFSe2pTsipWtyloa74226iH3ACac154G9g2N0S4dnIrndUg8YuXwQ8v55gIBAQ
         Yv9eEm5Y9lb7dZVlQ+XKlu75rbTSekfMU0wCdClNrUIvNN3QMLbhtmmJXFyA2J2dw6
         xbwdd7lTCleT9URT+tuPGOmLm2bTlhq4gacjdDq2PaJUkFhVLmDlTDw/pB1kwCt3Pi
         hylju8/CQpr/8ZniEN30W+uHlPue4xHMPYuFhRsdG0K9ycWFdjXHA6HDJMov3LTtXH
         2zhpuAklhlSlLSfuu+iOddHeB+24nRN1qIJkuMmGk1R9FVGii7Xq6mVl1K1yCh+euh
         wJF4LjTDS05kw==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Jes Sorensen <Jes.Sorensen@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Bitterblue Smith <rtl8821cerfe2@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: rtl8xxxu: add LEDS_CLASS dependency
Date:   Fri, 17 Feb 2023 10:59:04 +0100
Message-Id: <20230217095910.2480356-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

rtl8xxxu now unconditionally uses LEDS_CLASS, so a Kconfig dependency
is required to avoid link errors:

aarch64-linux-ld: drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.o: in function `rtl8xxxu_disconnect':
rtl8xxxu_core.c:(.text+0x730): undefined reference to `led_classdev_unregister'

ERROR: modpost: "led_classdev_unregister" [drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.ko] undefined!
ERROR: modpost: "led_classdev_register_ext" [drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.ko] undefined!

Fixes: 3be01622995b ("wifi: rtl8xxxu: Register the LED and make it blink")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/realtek/rtl8xxxu/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/Kconfig b/drivers/net/wireless/realtek/rtl8xxxu/Kconfig
index 091d3ad98093..2eed20b0988c 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/Kconfig
+++ b/drivers/net/wireless/realtek/rtl8xxxu/Kconfig
@@ -5,6 +5,7 @@
 config RTL8XXXU
 	tristate "Realtek 802.11n USB wireless chips support"
 	depends on MAC80211 && USB
+	depends on LEDS_CLASS
 	help
 	  This is an alternative driver for various Realtek RTL8XXX
 	  parts written to utilize the Linux mac80211 stack.
-- 
2.39.1

