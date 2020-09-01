Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC1D2591F9
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 16:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbgIAO6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 10:58:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbgIAO6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 10:58:46 -0400
Received: from xavier.telenet-ops.be (xavier.telenet-ops.be [IPv6:2a02:1800:120:4::f00:14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E0AEC061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 07:58:45 -0700 (PDT)
Received: from ramsan ([84.195.186.194])
        by xavier.telenet-ops.be with bizsmtp
        id Neyi230094C55Sk01eyihL; Tue, 01 Sep 2020 16:58:42 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1kD7kA-00060w-9K; Tue, 01 Sep 2020 16:58:42 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1kD7kA-0003sy-7X; Tue, 01 Sep 2020 16:58:42 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] chelsio/chtls: CHELSIO_INLINE_CRYPTO should depend on CHELSIO_T4
Date:   Tue,  1 Sep 2020 16:58:41 +0200
Message-Id: <20200901145841.14893-1-geert+renesas@glider.be>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While CHELSIO_INLINE_CRYPTO is a guard symbol, and just enabling it does
not cause any additional code to be compiled in, all configuration
options protected by it depend on CONFIG_CHELSIO_T4.  Hence it doesn't
make much sense to bother the user with the guard symbol question when
CONFIG_CHELSIO_T4 is disabled.

Fix this by moving the dependency from the individual config options to
the guard symbol.

Fixes: 44fd1c1fd8219551 ("chelsio/chtls: separate chelsio tls driver from crypto driver")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/net/ethernet/chelsio/inline_crypto/Kconfig | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/Kconfig b/drivers/net/ethernet/chelsio/inline_crypto/Kconfig
index a3ef057031e4a50b..be70b59b6f8070e5 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/Kconfig
+++ b/drivers/net/ethernet/chelsio/inline_crypto/Kconfig
@@ -5,6 +5,7 @@
 
 config CHELSIO_INLINE_CRYPTO
 	bool "Chelsio Inline Crypto support"
+	depends on CHELSIO_T4
 	default y
 	help
 	  Enable support for inline crypto.
@@ -14,7 +15,6 @@ if CHELSIO_INLINE_CRYPTO
 
 config CRYPTO_DEV_CHELSIO_TLS
 	tristate "Chelsio Crypto Inline TLS Driver"
-	depends on CHELSIO_T4
 	depends on TLS_TOE
 	help
 	  Support Chelsio Inline TLS with Chelsio crypto accelerator.
@@ -25,7 +25,6 @@ config CRYPTO_DEV_CHELSIO_TLS
 
 config CHELSIO_IPSEC_INLINE
        tristate "Chelsio IPSec XFRM Tx crypto offload"
-       depends on CHELSIO_T4
        depends on XFRM_OFFLOAD
        depends on INET_ESP_OFFLOAD || INET6_ESP_OFFLOAD
        help
-- 
2.17.1

