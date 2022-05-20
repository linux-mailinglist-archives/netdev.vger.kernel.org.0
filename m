Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 687B652F3F1
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 21:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353291AbiETTnd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 15:43:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353279AbiETTn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 15:43:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C2AC199487;
        Fri, 20 May 2022 12:43:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ADB2B61BD5;
        Fri, 20 May 2022 19:43:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E31A8C36AE5;
        Fri, 20 May 2022 19:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653075805;
        bh=Zsa+f6JCTzDTQi/tJsr1BPpvgwcSPn0bBlCB7MGA9x8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ATxhh3SCoyDIvjyBnvDp4a5iDHXO6AYZTxT4uh62WYvhDH9bg1PjaDtpVacHPWJg8
         KaCYgOQGaU5btpo0MDAAJyW0E1qP9ni2xhONFs/P4EIXICfuW94kn847Q7iwu+/Zdm
         65GKUGV9ZgCqfShZwtAmN06mQujISyeCfJIALXC+5tLqJ5nkqD2MBqnTKZ8YBmUL6N
         tdEG+Hb4aFa4IWmQMdUtI3EpEaYrH6g1WSUyCGr26I7IvqqfDPgwO7YN3qMplogXn9
         IpPWDL4hQ+LV4WidaU+j2cvR4FZev3JP8jER77ndRiv3HyNlblSnbjptLsd6vm5AqY
         L+15LmfZFt79w==
From:   Jakub Kicinski <kuba@kernel.org>
To:     kvalo@kernel.org, johannes@sipsolutions.net
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, toke@toke.dk
Subject: [PATCH net-next 2/8] wifi: ath9k: silence array-bounds warning on GCC 12
Date:   Fri, 20 May 2022 12:43:14 -0700
Message-Id: <20220520194320.2356236-3-kuba@kernel.org>
X-Mailer: git-send-email 2.34.3
In-Reply-To: <20220520194320.2356236-1-kuba@kernel.org>
References: <20220520194320.2356236-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

GCC 12 says:

drivers/net/wireless/ath/ath9k/mac.c: In function ‘ath9k_hw_resettxqueue’:
drivers/net/wireless/ath/ath9k/mac.c:373:22: warning: array subscript 32 is above array bounds of ‘struct ath9k_tx_queue_info[10]’ [-Warray-bounds]
  373 |         qi = &ah->txq[q];
      |               ~~~~~~~^~~

I don't know where it got the 32 from, relegate the warning to W=1+.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: toke@toke.dk
CC: kvalo@kernel.org
CC: linux-wireless@vger.kernel.org
---
 drivers/net/wireless/ath/ath9k/Makefile | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
index eff94bcd1f0a..9bdfcee2f448 100644
--- a/drivers/net/wireless/ath/ath9k/Makefile
+++ b/drivers/net/wireless/ath/ath9k/Makefile
@@ -45,6 +45,11 @@ ath9k_hw-y:=	\
 		ar9003_eeprom.o \
 		ar9003_paprd.o
 
+# FIXME: temporarily silence -Warray-bounds on non W=1+ builds
+ifndef KBUILD_EXTRA_WARN
+CFLAGS_mac.o += -Wno-array-bounds
+endif
+
 ath9k_hw-$(CONFIG_ATH9K_WOW) += ar9003_wow.o
 
 ath9k_hw-$(CONFIG_ATH9K_BTCOEX_SUPPORT) += btcoex.o \
-- 
2.34.3

