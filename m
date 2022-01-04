Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C792483CE9
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 08:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231531AbiADHc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 02:32:28 -0500
Received: from marcansoft.com ([212.63.210.85]:47642 "EHLO mail.marcansoft.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232560AbiADHcL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 02:32:11 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: hector@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 0C1ED422CC;
        Tue,  4 Jan 2022 07:32:01 +0000 (UTC)
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
        Dmitry Osipenko <digetx@gmail.com>
Cc:     Hector Martin <marcan@marcan.st>, Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
Subject: [PATCH v2 33/35] brcmfmac: common: Add support for downloading TxCap blobs
Date:   Tue,  4 Jan 2022 16:26:56 +0900
Message-Id: <20220104072658.69756-34-marcan@marcan.st>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220104072658.69756-1-marcan@marcan.st>
References: <20220104072658.69756-1-marcan@marcan.st>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The TxCap blobs are additional data blobs used on Apple devices, and
are uploaded analogously to CLM blobs. Add core support for doing this.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Hector Martin <marcan@marcan.st>
---
 .../broadcom/brcm80211/brcmfmac/bus.h         |  1 +
 .../broadcom/brcm80211/brcmfmac/common.c      | 97 +++++++++++++------
 2 files changed, 71 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
index b13af8f631f3..f4bd98da9761 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
@@ -39,6 +39,7 @@ enum brcmf_bus_protocol_type {
 /* Firmware blobs that may be available */
 enum brcmf_blob_type {
 	BRCMF_BLOB_CLM,
+	BRCMF_BLOB_TXCAP,
 };
 
 struct brcmf_mp_device;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index c84c48e49fde..d65308c3f070 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -101,7 +101,7 @@ void brcmf_c_set_joinpref_default(struct brcmf_if *ifp)
 
 static int brcmf_c_download(struct brcmf_if *ifp, u16 flag,
 			    struct brcmf_dload_data_le *dload_buf,
-			    u32 len)
+			    u32 len, const char *var)
 {
 	s32 err;
 
@@ -112,17 +112,17 @@ static int brcmf_c_download(struct brcmf_if *ifp, u16 flag,
 	dload_buf->crc = cpu_to_le32(0);
 	len = sizeof(*dload_buf) + len - 1;
 
-	err = brcmf_fil_iovar_data_set(ifp, "clmload", dload_buf, len);
+	err = brcmf_fil_iovar_data_set(ifp, var, dload_buf, len);
 
 	return err;
 }
 
-static int brcmf_c_process_clm_blob(struct brcmf_if *ifp)
+static int brcmf_c_download_blob(struct brcmf_if *ifp,
+				 const void *data, size_t size,
+				 const char *loadvar, const char *statvar)
 {
 	struct brcmf_pub *drvr = ifp->drvr;
-	struct brcmf_bus *bus = drvr->bus_if;
 	struct brcmf_dload_data_le *chunk_buf;
-	const struct firmware *clm = NULL;
 	u32 chunk_len;
 	u32 datalen;
 	u32 cumulative_len;
@@ -132,20 +132,11 @@ static int brcmf_c_process_clm_blob(struct brcmf_if *ifp)
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	err = brcmf_bus_get_blob(bus, &clm, BRCMF_BLOB_CLM);
-	if (err || !clm) {
-		brcmf_info("no clm_blob available (err=%d), device may have limited channels available\n",
-			   err);
-		return 0;
-	}
-
 	chunk_buf = kzalloc(sizeof(*chunk_buf) + MAX_CHUNK_LEN - 1, GFP_KERNEL);
-	if (!chunk_buf) {
-		err = -ENOMEM;
-		goto done;
-	}
+	if (!chunk_buf)
+		return -ENOMEM;
 
-	datalen = clm->size;
+	datalen = size;
 	cumulative_len = 0;
 	do {
 		if (datalen > MAX_CHUNK_LEN) {
@@ -154,9 +145,10 @@ static int brcmf_c_process_clm_blob(struct brcmf_if *ifp)
 			chunk_len = datalen;
 			dl_flag |= DL_END;
 		}
-		memcpy(chunk_buf->data, clm->data + cumulative_len, chunk_len);
+		memcpy(chunk_buf->data, data + cumulative_len, chunk_len);
 
-		err = brcmf_c_download(ifp, dl_flag, chunk_buf, chunk_len);
+		err = brcmf_c_download(ifp, dl_flag, chunk_buf, chunk_len,
+				       loadvar);
 
 		dl_flag &= ~DL_BEGIN;
 
@@ -165,20 +157,64 @@ static int brcmf_c_process_clm_blob(struct brcmf_if *ifp)
 	} while ((datalen > 0) && (err == 0));
 
 	if (err) {
-		bphy_err(drvr, "clmload (%zu byte file) failed (%d)\n",
-			 clm->size, err);
-		/* Retrieve clmload_status and print */
-		err = brcmf_fil_iovar_int_get(ifp, "clmload_status", &status);
+		bphy_err(drvr, "%s (%zu byte file) failed (%d)\n",
+			 loadvar, size, err);
+		/* Retrieve status and print */
+		err = brcmf_fil_iovar_int_get(ifp, statvar, &status);
 		if (err)
-			bphy_err(drvr, "get clmload_status failed (%d)\n", err);
+			bphy_err(drvr, "get %s failed (%d)\n", statvar, err);
 		else
-			brcmf_dbg(INFO, "clmload_status=%d\n", status);
+			brcmf_dbg(INFO, "%s=%d\n", statvar, status);
 		err = -EIO;
 	}
 
 	kfree(chunk_buf);
-done:
-	release_firmware(clm);
+	return err;
+}
+
+static int brcmf_c_process_clm_blob(struct brcmf_if *ifp)
+{
+	struct brcmf_pub *drvr = ifp->drvr;
+	struct brcmf_bus *bus = drvr->bus_if;
+	const struct firmware *fw = NULL;
+	s32 err;
+
+	brcmf_dbg(TRACE, "Enter\n");
+
+	err = brcmf_bus_get_blob(bus, &fw, BRCMF_BLOB_CLM);
+	if (err || !fw) {
+		brcmf_info("no clm_blob available (err=%d), device may have limited channels available\n",
+			   err);
+		return 0;
+	}
+
+	err = brcmf_c_download_blob(ifp, fw->data, fw->size,
+				    "clmload", "clmload_status");
+
+	release_firmware(fw);
+	return err;
+}
+
+static int brcmf_c_process_txcap_blob(struct brcmf_if *ifp)
+{
+	struct brcmf_pub *drvr = ifp->drvr;
+	struct brcmf_bus *bus = drvr->bus_if;
+	const struct firmware *fw = NULL;
+	s32 err;
+
+	brcmf_dbg(TRACE, "Enter\n");
+
+	err = brcmf_bus_get_blob(bus, &fw, BRCMF_BLOB_TXCAP);
+	if (err || !fw) {
+		brcmf_info("no txcap_blob available (err=%d)\n", err);
+		return 0;
+	}
+
+	brcmf_info("TxCap blob found, loading\n");
+	err = brcmf_c_download_blob(ifp, fw->data, fw->size,
+				    "txcapload", "txcapload_status");
+
+	release_firmware(fw);
 	return err;
 }
 
@@ -248,6 +284,13 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 		goto done;
 	}
 
+	/* Do TxCap downloading, if needed */
+	err = brcmf_c_process_txcap_blob(ifp);
+	if (err < 0) {
+		bphy_err(drvr, "download TxCap blob file failed, %d\n", err);
+		goto done;
+	}
+
 	/* query for 'ver' to get version info from firmware */
 	memset(buf, 0, sizeof(buf));
 	err = brcmf_fil_iovar_data_get(ifp, "ver", buf, sizeof(buf));
-- 
2.33.0

