Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0B4346BEFF
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 16:15:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234297AbhLGPSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 10:18:37 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38506 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbhLGPSg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 10:18:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB8FBB80782;
        Tue,  7 Dec 2021 15:15:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51959C341C1;
        Tue,  7 Dec 2021 15:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638890103;
        bh=xxF6Nm2aBsMxEff2TkdoXeMHocqjOshQ8GbBna8ovUY=;
        h=From:To:Cc:Subject:Date:From;
        b=qXQflwPi4XW0XAwlgafUg1Sq0TeYe27GgLJm4wNYJUfUK2N6ICN8hq8sD2/ZcRg/v
         WHTDBsSH4zvlUICZVXLzlbimjg9keWa2yEL4mg85vLh3arSz/H7lL653jE5VjZPX9c
         7W5gIRRYGy/QHfpjvmR1r9hFYJns7QDIqs/85W3p5JWtCZRci9pYBvdc2IGX7zgTYN
         hOqzwtIyR1G12qXRAj0DQfU+lioEyDfywNxbqJL5vQVFxDRO3PBy3jfVR1osUdkSN/
         OnTK/fmIhg5qr8UWZpTisuPccqRnmmiQzDbToQOwtrIPMO70C9/BctFD29orWb+x9g
         amxcPAh1WLV3A==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ayala Beker <ayala.beker@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [v2] iwlwifi: work around reverse dependency on MEI
Date:   Tue,  7 Dec 2021 16:14:36 +0100
Message-Id: <20211207151447.3338818-1-arnd@kernel.org>
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

To work around this, decouple iwlmei from iwlwifi and add the
dependency in the other direction.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/intel/iwlwifi/Kconfig | 52 +++++++++++-----------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/Kconfig b/drivers/net/wireless/intel/iwlwifi/Kconfig
index cf1125d84929..c21c0c68849a 100644
--- a/drivers/net/wireless/intel/iwlwifi/Kconfig
+++ b/drivers/net/wireless/intel/iwlwifi/Kconfig
@@ -2,6 +2,7 @@
 config IWLWIFI
 	tristate "Intel Wireless WiFi Next Gen AGN - Wireless-N/Advanced-N/Ultimate-N (iwlwifi) "
 	depends on PCI && HAS_IOMEM && CFG80211
+	depends on IWLMEI || !IWLMEI
 	select FW_LOADER
 	help
 	  Select to build the driver supporting the:
@@ -92,32 +93,6 @@ config IWLWIFI_BCAST_FILTERING
 	  If unsure, don't enable this option, as some programs might
 	  expect incoming broadcasts for their normal operations.
 
-config IWLMEI
-	tristate "Intel Management Engine communication over WLAN"
-	depends on INTEL_MEI
-	depends on PM
-	depends on IWLMVM
-	help
-	  Enables the iwlmei kernel module.
-
-	  CSME stands for Converged Security and Management Engine. It is a CPU
-	  on the chipset and runs a dedicated firmware. AMT (Active Management
-	  Technology) is one of the applications that run on that CPU. AMT
-	  allows to control the platform remotely.
-
-	  This kernel module allows to communicate with the Intel Management
-	  Engine over Wifi. This is supported starting from Tiger Lake
-	  platforms and has been tested on 9260 devices only.
-	  If AMT is configured not to use the wireless device, this module is
-	  harmless (and useless).
-	  Enabling this option on a platform that has a different device and
-	  has Wireless enabled on AMT can prevent WiFi from working correctly.
-
-	  For more information see
-	  <https://software.intel.com/en-us/manageability/>
-
-	  If unsure, say N.
-
 menu "Debugging Options"
 
 config IWLWIFI_DEBUG
@@ -172,3 +147,28 @@ config IWLWIFI_DEVICE_TRACING
 endmenu
 
 endif
+
+config IWLMEI
+	tristate "Intel Management Engine communication over WLAN"
+	depends on INTEL_MEI
+	depends on PM
+	help
+	  Enables the iwlmei kernel module.
+
+	  CSME stands for Converged Security and Management Engine. It is a CPU
+	  on the chipset and runs a dedicated firmware. AMT (Active Management
+	  Technology) is one of the applications that run on that CPU. AMT
+	  allows to control the platform remotely.
+
+	  This kernel module allows to communicate with the Intel Management
+	  Engine over Wifi. This is supported starting from Tiger Lake
+	  platforms and has been tested on 9260 devices only.
+	  If AMT is configured not to use the wireless device, this module is
+	  harmless (and useless).
+	  Enabling this option on a platform that has a different device and
+	  has Wireless enabled on AMT can prevent WiFi from working correctly.
+
+	  For more information see
+	  <https://software.intel.com/en-us/manageability/>
+
+	  If unsure, say N.
-- 
2.29.2

