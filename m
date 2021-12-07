Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE9A646BBDA
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 13:54:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231657AbhLGM6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 07:58:08 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:36674 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231583AbhLGM6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 07:58:08 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31B12B8175A;
        Tue,  7 Dec 2021 12:54:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67DC0C341C6;
        Tue,  7 Dec 2021 12:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638881676;
        bh=6JN623Wf1cIT6pJuzLUO3rWixP7YcHB2HO5dgsI3tcM=;
        h=From:To:Cc:Subject:Date:From;
        b=b1EPuXxbh3NSS9zE3IGatJkgzk/cJuXDmR3ifFDCDFhj5/argxtJU3JmR0yzMjpn/
         /+pr+WMEBT2gBtwyn+/jY4aCYTaWDvVh1HjjOZOjjYTAoKkK6+mSO19DOWHpJGnX1V
         ovJaIki1AkUqBuGLXdFiGZ4jLqi0qVHZut9Ebm7j6T0sULxEJC3LwUWn0RAxkhCvmn
         kuJ2RlNsdDvJvpddvprTazRbxLqPmc+PqW9/XYAHD3NBMVPFxv9J046OiUgmnY1txI
         ZgI+mIfqycj5x1JJPwH2PrV3SBqrnFm0HM4/77fliDDnK9+XW/j9gfxcF45AtX74yz
         mOQhB/fTcKskQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Ayala Beker <ayala.beker@intel.com>,
        Miri Korenblit <miriam.rachel.korenblit@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] iwlwifi: work around reverse dependency on MEI
Date:   Tue,  7 Dec 2021 13:54:12 +0100
Message-Id: <20211207125430.2423871-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

If the iwlmei code is a loadable module, the main iwlwifi driver
cannot be built-in:

x86_64-linux-ld: drivers/net/wireless/intel/iwlwifi/pcie/trans.o: in function `iwl_pcie_prepare_card_hw':
trans.c:(.text+0x4158): undefined reference to `iwl_mei_is_connected'

Unfortunately, Kconfig enforces the opposite, forcing the MEI driver to
not be built-in if iwlwifi is a module.

There is no easy way to express the correct dependency in Kconfig,
this is the best workaround I could come up with, turning CONFIG_IWLMEI
into a 'bool' symbol, and spelling out the exact conditions under which
it may be enabled, and then using Makefile logic to ensure it is
built-in when iwlwifi is.

A better option would be change iwl_mei_is_connected() so it could be
called from iwlwifi regardless of whether the mei driver is reachable,
but that requires a larger rework in the driver.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/intel/iwlwifi/Kconfig      | 6 +++---
 drivers/net/wireless/intel/iwlwifi/Makefile     | 3 +--
 drivers/net/wireless/intel/iwlwifi/mei/Makefile | 4 +++-
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/Kconfig b/drivers/net/wireless/intel/iwlwifi/Kconfig
index cf1125d84929..474afc6f82a8 100644
--- a/drivers/net/wireless/intel/iwlwifi/Kconfig
+++ b/drivers/net/wireless/intel/iwlwifi/Kconfig
@@ -93,10 +93,10 @@ config IWLWIFI_BCAST_FILTERING
 	  expect incoming broadcasts for their normal operations.
 
 config IWLMEI
-	tristate "Intel Management Engine communication over WLAN"
-	depends on INTEL_MEI
+	bool "Intel Management Engine communication over WLAN"
+	depends on INTEL_MEI=y || INTEL_MEI=IWLMVM
+	depends on IWLMVM=y || IWLWIFI=m
 	depends on PM
-	depends on IWLMVM
 	help
 	  Enables the iwlmei kernel module.
 
diff --git a/drivers/net/wireless/intel/iwlwifi/Makefile b/drivers/net/wireless/intel/iwlwifi/Makefile
index 75a703eb1bdf..c117e105fe5c 100644
--- a/drivers/net/wireless/intel/iwlwifi/Makefile
+++ b/drivers/net/wireless/intel/iwlwifi/Makefile
@@ -29,7 +29,6 @@ iwlwifi-$(CONFIG_IWLWIFI_DEVICE_TRACING) += iwl-devtrace.o
 ccflags-y += -I$(src)
 
 obj-$(CONFIG_IWLDVM)	+= dvm/
-obj-$(CONFIG_IWLMVM)	+= mvm/
-obj-$(CONFIG_IWLMEI)	+= mei/
+obj-$(CONFIG_IWLMVM)	+= mvm/ mei/
 
 CFLAGS_iwl-devtrace.o := -I$(src)
diff --git a/drivers/net/wireless/intel/iwlwifi/mei/Makefile b/drivers/net/wireless/intel/iwlwifi/mei/Makefile
index 8e3ef0347db7..98b561c3820f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mei/Makefile
+++ b/drivers/net/wireless/intel/iwlwifi/mei/Makefile
@@ -1,5 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
-obj-$(CONFIG_IWLMEI)	+= iwlmei.o
+ifdef CONFIG_IWLMEI
+obj-$(CONFIG_IWLWIFI)	+= iwlmei.o
+endif
 iwlmei-y += main.o
 iwlmei-y += net.o
 iwlmei-$(CONFIG_IWLWIFI_DEVICE_TRACING) += trace.o
-- 
2.29.2

