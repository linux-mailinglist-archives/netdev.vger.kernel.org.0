Return-Path: <netdev+bounces-450-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6667C6F76DC
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 22:20:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A0F4E1C21641
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 20:20:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00AFB19BD1;
	Thu,  4 May 2023 19:52:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66550C136
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 19:52:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BDD7C433EF;
	Thu,  4 May 2023 19:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683229931;
	bh=rfkCg9B+Uvetc2GT2qTCmHz1yUEX93yjIvZN6vRS91Q=;
	h=From:To:Cc:Subject:Date:From;
	b=OBqScsuzOsXoknANOCAaILgnUd/mqTMiaJPsBvOzpSo/I/SLAkRWKQVkgM/6f5kgg
	 gIkHiepUKKKY6bkzTTBthyrgBfTlmy9/a4SW/I//nGAQaS9VkqBJqiSe1w8NS/7P9/
	 Kl9DOjcB5E+7Uvu8eMlI/Ka5+4+5Yez1yGHhUxbZGSWPXqlq5d+9H1VwpnxffbAGDt
	 2tk19tfd8rm+bngF+PO9LiALRhQJmCDgrXft0j89mIz6Sy/iznhP5bauY71GrMVtHL
	 DnCmGGN3QZ3B1T4PBOf5TwdQ3nkKvmzhFieihiSfVnKg7tZe09pgSgcFcet6YiIGVK
	 iqdFGMs7lF+8A==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Hector Martin <marcan@marcan.st>,
	Linus Walleij <linus.walleij@linaro.org>,
	Julian Calaby <julian.calaby@gmail.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	aspriel@gmail.com,
	franky.lin@broadcom.com,
	hante.meuleman@broadcom.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	rmk+kernel@armlinux.org.uk,
	wright.feng@cypress.com,
	linux-wireless@vger.kernel.org,
	brcm80211-dev-list.pdl@broadcom.com,
	SHA-cyfmac-dev-list@infineon.com,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 01/13] wifi: brcmfmac: pcie: Provide a buffer of random bytes to the device
Date: Thu,  4 May 2023 15:51:53 -0400
Message-Id: <20230504195207.3809116-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Hector Martin <marcan@marcan.st>

[ Upstream commit 91918ce88d9fef408bb12c46a27c73d79b604c20 ]

Newer Apple firmwares on chipsets without a hardware RNG require the
host to provide a buffer of 256 random bytes to the device on
initialization. This buffer is present immediately before NVRAM,
suffixed by a footer containing a magic number and the buffer length.

This won't affect chips/firmwares that do not use this feature, so do it
unconditionally for all Apple platforms (those with an Apple OTP).

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Hector Martin <marcan@marcan.st>
Reviewed-by: Julian Calaby <julian.calaby@gmail.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230214080034.3828-3-marcan@marcan.st
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../broadcom/brcm80211/brcmfmac/pcie.c        | 32 +++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 4aa199be0df35..2227f1a0784e2 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -23,6 +23,7 @@
 #include <linux/bcma/bcma.h>
 #include <linux/sched.h>
 #include <linux/io.h>
+#include <linux/random.h>
 #include <asm/unaligned.h>
 
 #include <soc.h>
@@ -1396,6 +1397,13 @@ brcmf_pcie_init_share_ram_info(struct brcmf_pciedev_info *devinfo,
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
@@ -1431,6 +1439,30 @@ static int brcmf_pcie_download_fw_nvram(struct brcmf_pciedev_info *devinfo,
 			  nvram_len;
 		memcpy_toio(devinfo->tcm + address, nvram, nvram_len);
 		brcmf_fw_nvram_free(nvram);
+
+		if (devinfo->otp.valid) {
+			size_t rand_len = BRCMF_RANDOM_SEED_LENGTH;
+			struct brcmf_random_seed_footer footer = {
+				.length = cpu_to_le32(rand_len),
+				.magic = cpu_to_le32(BRCMF_RANDOM_SEED_MAGIC),
+			};
+			void *randbuf;
+
+			/* Some Apple chips/firmwares expect a buffer of random
+			 * data to be present before NVRAM
+			 */
+			brcmf_dbg(PCIE, "Download random seed\n");
+
+			address -= sizeof(footer);
+			memcpy_toio(devinfo->tcm + address, &footer,
+				    sizeof(footer));
+
+			address -= rand_len;
+			randbuf = kzalloc(rand_len, GFP_KERNEL);
+			get_random_bytes(randbuf, rand_len);
+			memcpy_toio(devinfo->tcm + address, randbuf, rand_len);
+			kfree(randbuf);
+		}
 	} else {
 		brcmf_dbg(PCIE, "No matching NVRAM file found %s\n",
 			  devinfo->nvram_name);
-- 
2.39.2


