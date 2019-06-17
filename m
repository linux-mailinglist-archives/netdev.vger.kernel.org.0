Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85E33483A4
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 15:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727675AbfFQNOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 09:14:38 -0400
Received: from mout.kundenserver.de ([217.72.192.73]:59811 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbfFQNOi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 09:14:38 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue107 [212.227.15.145]) with ESMTPA (Nemesis) id
 1MSLlu-1i5ZU81MPA-00Sf0J; Mon, 17 Jun 2019 15:14:32 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Georg Waibel <georg.waibel@sensor-technik.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next] net: dsa: sja1105: fix ptp link error
Date:   Mon, 17 Jun 2019 15:14:10 +0200
Message-Id: <20190617131430.2263299-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:Cbo0bDy1UH8bqER4Qp7aRiwrEJ20S2OwFY8IWvJF7xUMxR3jm1w
 szu8rCAuFQtfvBZL5XF5sLfoHGHkW4Ii6XZKAec959gp5syty+2/3cAorV6R0W8GW/MXBu4
 dJa+kWhW+CvfqhLyZmSIb2sQXA5OpZIt7X9bQxzXaGSz/ZQjULBO1T2rQkQYtl+am2mJpon
 T6JrFpttgxViy+tbdYwKA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Te+YLwwLAkk=:uS+K7S69nn6ArdXVOMIXLx
 3pyNFJavGZxkXmRgVGCrRg05nta2FAl/OaAwu9yP54IR+J7f1j9hwmPvJzGSq46UHKvoeFArK
 j3s5xchTwxJPyBnPzw+fitud0I9n74lBPyPP16/xJ3JW4/xY7UkZor/HUk2UBuxqgeeS9icpC
 UP2+9TKr6vCFEqJwNvG/Bt0lua4dbFe3CN6dFQXXMMIrPemqSqaY0clIy5VoWZNcxRTjXrfUB
 +8ZXPhc0KQPdl4zUk2hpxe6PdhHa184HYwrCY4vUx7vGgmrXyjmzYE5zlSsFIdBYsXB0o7Msx
 NP8+l0vQz1qEBfwj35yGwfLN6lGc3t0O2oHL7gMwkTC3n2YewJsAeZBXE2ni9rGiau8SxEmCm
 tvA92xr4XUMei3a5AT5M3aHCLhOyhqyvRsvRR1qPDxpnHkz5vCFRQTCCv9qe9rAKY9ThJjbNv
 k31rg0iiPj5Pd7OV849pFdw0ZjywupN1t3iQZ8OPs6M8zlAgjPePEhLPxFh7wzbuQv+Sx51X8
 xv149mR5gFTyJ5rKprMmoM99sof8ePTiy2FFp1TRkqgkcQ/jyqJmJmXz8dQrZMmvZjKwjCpD4
 vK7Ua2t0MgI80zqnt/WrtUD/8iaVNnpHl/caEZD4bA0wobB6hVnaqDFG0TfkXokNxHyEDmyT8
 4pDpJrmecrz7ryY5wnQ1kb4oJ+ISQV5fyxWrnxL5P7hCa6gyhmckOVmD2Hctw5ZaO80Kg/574
 nKw5S60/zfTAvzPYdn+PxiA2cn/CjYsS55zvBw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Due to a reversed dependency, it is possible to build
the lower ptp driver as a loadable module and the actual
driver using it as built-in, causing a link error:

drivers/net/dsa/sja1105/sja1105_spi.o: In function `sja1105_static_config_upload':
sja1105_spi.c:(.text+0x6f0): undefined reference to `sja1105_ptp_reset'
drivers/net/dsa/sja1105/sja1105_spi.o:(.data+0x2d4): undefined reference to `sja1105et_ptp_cmd'
drivers/net/dsa/sja1105/sja1105_spi.o:(.data+0x604): undefined reference to `sja1105pqrs_ptp_cmd'
drivers/net/dsa/sja1105/sja1105_main.o: In function `sja1105_remove':
sja1105_main.c:(.text+0x8d4): undefined reference to `sja1105_ptp_clock_unregister'
drivers/net/dsa/sja1105/sja1105_main.o: In function `sja1105_rxtstamp_work':
sja1105_main.c:(.text+0x964): undefined reference to `sja1105_tstamp_reconstruct'
drivers/net/dsa/sja1105/sja1105_main.o: In function `sja1105_setup':
sja1105_main.c:(.text+0xb7c): undefined reference to `sja1105_ptp_clock_register'
drivers/net/dsa/sja1105/sja1105_main.o: In function `sja1105_port_deferred_xmit':
sja1105_main.c:(.text+0x1fa0): undefined reference to `sja1105_ptpegr_ts_poll'
sja1105_main.c:(.text+0x1fc4): undefined reference to `sja1105_tstamp_reconstruct'
drivers/net/dsa/sja1105/sja1105_main.o:(.rodata+0x5b0): undefined reference to `sja1105_get_ts_info'

Change the Makefile logic to always build the ptp module
the same way as the rest. Another option would be to
just add it to the same module and remove the exports,
but I don't know if there was a good reason to keep them
separate.

Fixes: bb77f36ac21d ("net: dsa: sja1105: Add support for the PTP clock")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/dsa/sja1105/Kconfig  | 2 +-
 drivers/net/dsa/sja1105/Makefile | 5 ++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/sja1105/Kconfig b/drivers/net/dsa/sja1105/Kconfig
index 105e8d3e380e..770134a66e48 100644
--- a/drivers/net/dsa/sja1105/Kconfig
+++ b/drivers/net/dsa/sja1105/Kconfig
@@ -18,7 +18,7 @@ tristate "NXP SJA1105 Ethernet switch family support"
 	    - SJA1105S (Gen. 2, SGMII, TT-Ethernet)
 
 config NET_DSA_SJA1105_PTP
-tristate "Support for the PTP clock on the NXP SJA1105 Ethernet switch"
+	bool "Support for the PTP clock on the NXP SJA1105 Ethernet switch"
 	depends on NET_DSA_SJA1105
 	help
 	  This enables support for timestamping and PTP clock manipulations in
diff --git a/drivers/net/dsa/sja1105/Makefile b/drivers/net/dsa/sja1105/Makefile
index 946eea7d8480..9a22f68b39e9 100644
--- a/drivers/net/dsa/sja1105/Makefile
+++ b/drivers/net/dsa/sja1105/Makefile
@@ -1,6 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
 obj-$(CONFIG_NET_DSA_SJA1105) += sja1105.o
-obj-$(CONFIG_NET_DSA_SJA1105_PTP) += sja1105_ptp.o
 
 sja1105-objs := \
     sja1105_spi.o \
@@ -9,3 +8,7 @@ sja1105-objs := \
     sja1105_clocking.o \
     sja1105_static_config.o \
     sja1105_dynamic_config.o \
+
+ifdef CONFIG_NET_DSA_SJA1105_PTP
+obj-$(CONFIG_NET_DSA_SJA1105) += sja1105_ptp.o
+endif
-- 
2.20.0

