Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD01926A259
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 11:36:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgIOJgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 05:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbgIOJgA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 05:36:00 -0400
Received: from xavier.telenet-ops.be (xavier.telenet-ops.be [IPv6:2a02:1800:120:4::f00:14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AFBFC061788
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 02:35:59 -0700 (PDT)
Received: from ramsan ([84.195.186.194])
        by xavier.telenet-ops.be with bizsmtp
        id U9bt230034C55Sk019btuN; Tue, 15 Sep 2020 11:35:55 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1kI7NQ-00060F-Vq; Tue, 15 Sep 2020 11:35:52 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1kI7NQ-0007eP-T2; Tue, 15 Sep 2020 11:35:52 +0200
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Arnd Bergmann <arnd@arndb.de>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] chelsio/chtls: Re-add dependencies on CHELSIO_T4 to fix modular CHELSIO_T4
Date:   Tue, 15 Sep 2020 11:35:51 +0200
Message-Id: <20200915093551.29368-1-geert+renesas@glider.be>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As CHELSIO_INLINE_CRYPTO is bool, and CHELSIO_T4 is tristate, the
dependency of CHELSIO_INLINE_CRYPTO on CHELSIO_T4 is not sufficient to
protect CRYPTO_DEV_CHELSIO_TLS and CHELSIO_IPSEC_INLINE.  The latter two
are also tristate, hence if CHELSIO_T4=n, they cannot be builtin, as
that would lead to link failures like:

    drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_main.c:259: undefined reference to `cxgb4_port_viid'

and

    drivers/net/ethernet/chelsio/inline_crypto/ch_ipsec/chcr_ipsec.c:752: undefined reference to `cxgb4_reclaim_completed_tx'

Fix this by re-adding dependencies on CHELSIO_T4 to tristate symbols.
The dependency of CHELSIO_INLINE_CRYPTO on CHELSIO_T4 is kept to avoid
asking the user.

Fixes: 6bd860ac1c2a0ec2 ("chelsio/chtls: CHELSIO_INLINE_CRYPTO should depend on CHELSIO_T4")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/net/ethernet/chelsio/inline_crypto/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/Kconfig b/drivers/net/ethernet/chelsio/inline_crypto/Kconfig
index 1923e713b53a1bf5..7dfa57348d542921 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/Kconfig
+++ b/drivers/net/ethernet/chelsio/inline_crypto/Kconfig
@@ -15,6 +15,7 @@ if CHELSIO_INLINE_CRYPTO
 
 config CRYPTO_DEV_CHELSIO_TLS
 	tristate "Chelsio Crypto Inline TLS Driver"
+	depends on CHELSIO_T4
 	depends on TLS_TOE
 	help
 	  Support Chelsio Inline TLS with Chelsio crypto accelerator.
@@ -25,6 +26,7 @@ config CRYPTO_DEV_CHELSIO_TLS
 
 config CHELSIO_IPSEC_INLINE
        tristate "Chelsio IPSec XFRM Tx crypto offload"
+       depends on CHELSIO_T4
        depends on XFRM_OFFLOAD
        depends on INET_ESP_OFFLOAD || INET6_ESP_OFFLOAD
        help
-- 
2.17.1

