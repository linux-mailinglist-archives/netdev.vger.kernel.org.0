Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47F8647F7C9
	for <lists+netdev@lfdr.de>; Sun, 26 Dec 2021 16:40:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234160AbhLZPjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Dec 2021 10:39:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234000AbhLZPiz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Dec 2021 10:38:55 -0500
Received: from mail.marcansoft.com (marcansoft.com [IPv6:2a01:298:fe:f::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA612C061784;
        Sun, 26 Dec 2021 07:38:54 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: hector@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id CD7B544B48;
        Sun, 26 Dec 2021 15:38:45 +0000 (UTC)
From:   Hector Martin <marcan@marcan.st>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>
Cc:     Hector Martin <marcan@marcan.st>, Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Daniel (Deognyoun) Kim" <dekim@broadcom.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
Subject: [PATCH 17/34] brcmfmac: pcie: Provide a buffer of random bytes to the device
Date:   Mon, 27 Dec 2021 00:36:07 +0900
Message-Id: <20211226153624.162281-18-marcan@marcan.st>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211226153624.162281-1-marcan@marcan.st>
References: <20211226153624.162281-1-marcan@marcan.st>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Newer Apple firmwares on chipsets without a hardware RNG require the
host to provide a buffer of 256 random bytes to the device on
initialization. This buffer is present immediately before NVRAM,
suffixed by a footer containing a magic number and the buffer length.

This won't affect chips/firmwares that do not use this feature, so do it
unconditionally.

Signed-off-by: Hector Martin <marcan@marcan.st>
---
 .../broadcom/brcm80211/brcmfmac/pcie.c        | 30 +++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 40d0fc6fa9ce..feeaa3e06853 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -12,6 +12,7 @@
 #include <linux/interrupt.h>
 #include <linux/bcma/bcma.h>
 #include <linux/sched.h>
+#include <linux/random.h>
 #include <asm/unaligned.h>
 
 #include <soc.h>
@@ -1662,6 +1663,13 @@ brcmf_pcie_init_share_ram_info(struct brcmf_pciedev_info *devinfo,
 	return 0;
 }
 
+struct brcmf_random_seed_footer {
+	__le32 length;
+	__le32 magic;
+};
+
+#define BRCMF_RANDOM_SEED_MAGIC		0xfeedc0de
+#define BRCMF_RANDOM_SEED_LENGTH	0x100
 
 static int brcmf_pcie_download_fw_nvram(struct brcmf_pciedev_info *devinfo,
 					const struct firmware *fw, void *nvram,
@@ -1693,11 +1701,33 @@ static int brcmf_pcie_download_fw_nvram(struct brcmf_pciedev_info *devinfo,
 	brcmf_pcie_write_ram32(devinfo, devinfo->ci->ramsize - 4, 0);
 
 	if (nvram) {
+		size_t rand_len = BRCMF_RANDOM_SEED_LENGTH;
+		struct brcmf_random_seed_footer footer = {
+			.length = cpu_to_le32(rand_len),
+			.magic = cpu_to_le32(BRCMF_RANDOM_SEED_MAGIC),
+		};
+		void *randbuf;
+
 		brcmf_dbg(PCIE, "Download NVRAM %s\n", devinfo->nvram_name);
 		address = devinfo->ci->rambase + devinfo->ci->ramsize -
 			  nvram_len;
 		brcmf_pcie_copy_mem_todev(devinfo, address, nvram, nvram_len);
 		brcmf_fw_nvram_free(nvram);
+
+		/* Some Apple chips/firmwares expect a buffer of random data
+		 * to be present before NVRAM
+		 */
+		brcmf_dbg(PCIE, "Download random seed\n");
+
+		address -= sizeof(footer);
+		brcmf_pcie_copy_mem_todev(devinfo, address, &footer,
+					  sizeof(footer));
+
+		address -= rand_len;
+		randbuf = kzalloc(rand_len, GFP_KERNEL);
+		get_random_bytes(randbuf, rand_len);
+		brcmf_pcie_copy_mem_todev(devinfo, address, randbuf, rand_len);
+		kfree(randbuf);
 	} else {
 		brcmf_dbg(PCIE, "No matching NVRAM file found %s\n",
 			  devinfo->nvram_name);
-- 
2.33.0

