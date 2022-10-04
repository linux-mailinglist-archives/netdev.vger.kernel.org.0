Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08D925F4779
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 18:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiJDQYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 12:24:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbiJDQYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 12:24:02 -0400
Received: from albert.telenet-ops.be (albert.telenet-ops.be [IPv6:2a02:1800:110:4::f00:1a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF1A962A90
        for <netdev@vger.kernel.org>; Tue,  4 Oct 2022 09:23:58 -0700 (PDT)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed50:e15b:43db:96f7:952f])
        by albert.telenet-ops.be with bizsmtp
        id TsPv2800f2GKRF306sPv17; Tue, 04 Oct 2022 18:23:57 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1ofki3-000hGR-8o; Tue, 04 Oct 2022 18:23:55 +0200
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1ofki2-007yf0-JW; Tue, 04 Oct 2022 18:23:54 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <linux@rempel-privat.de>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] net: pse-pd: PSE_REGULATOR should depend on REGULATOR
Date:   Tue,  4 Oct 2022 18:23:53 +0200
Message-Id: <709caac8873ff2a8b72b92091429be7c1a939959.1664900558.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Regulator based PSE controller driver relies on regulator support to
be enabled.  If regulator support is disabled, it will still compile
fine, but won't operate correctly.

Hence add a dependency on REGULATOR, to prevent asking the user about
this driver when configuring a kernel without regulator support.

Fixes: 66741b4e94ca7bb1 ("net: pse-pd: add regulator based PSE driver")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/net/pse-pd/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/pse-pd/Kconfig b/drivers/net/pse-pd/Kconfig
index 73d163704068ac27..687dec49c1e13fa0 100644
--- a/drivers/net/pse-pd/Kconfig
+++ b/drivers/net/pse-pd/Kconfig
@@ -14,6 +14,7 @@ if PSE_CONTROLLER
 
 config PSE_REGULATOR
 	tristate "Regulator based PSE controller"
+	depends on REGULATOR || COMPILE_TEST
 	help
 	  This module provides support for simple regulator based Ethernet Power
 	  Sourcing Equipment without automatic classification support. For
-- 
2.25.1

