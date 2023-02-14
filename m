Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63543695F11
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 10:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232262AbjBNJ1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 04:27:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232435AbjBNJ0l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 04:26:41 -0500
Received: from mail.marcansoft.com (marcansoft.com [212.63.210.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03B0F24C9C;
        Tue, 14 Feb 2023 01:26:08 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: sendonly@marcansoft.com)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 322F13FA55;
        Tue, 14 Feb 2023 09:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=marcan.st; s=default;
        t=1676366767; bh=GjQ7JnomOjli6BmGH+xkgFqLoR9Wvx1VAunDAgO4Jkc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=P1oHjR63XXc3SfV16f3P8iKyoDSYJPuSTOJzBr9yd97Podb44aZ49MMzroAFKoPBt
         /3rJ5JDCiYZTi1ZSXjIMOBPMQ8btBeb8iGdxegRLjeBtJ5H6gBl3/cNMcW0GR0xoh/
         Y9D90V6dDlL437WoOBhGeTSXFLHTI4w3eO2Mz2LxSOloLGz9D7zOElP+GC456yFJ66
         NZxS+Efn9k5QqHp33ADVvT4t09ivUDVFPy3fzE9t7VPDcFzt37SqhFtRRb1NJL2SRH
         Z48gk6NA+atMJgxx8JMpchRInlAtlRzcm9bV3vo2JUhOFzYv9Be9mBfWoNXVRMdoDf
         2BelOGWTuDCDw==
From:   Hector Martin <marcan@marcan.st>
To:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Linus Walleij <linus.walleij@linaro.org>,
        asahi@lists.linux.dev, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hector Martin <marcan@marcan.st>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 08/10] brcmfmac: common: Add support for downloading TxCap blobs
Date:   Tue, 14 Feb 2023 18:24:21 +0900
Message-Id: <20230214092423.15175-8-marcan@marcan.st>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230214091651.10178-1-marcan@marcan.st>
References: <20230214091651.10178-1-marcan@marcan.st>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The TxCap blobs are additional data blobs used on Apple devices, and
are uploaded analogously to CLM blobs. Add core support for doing this.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Hector Martin <marcan@marcan.st>
---
 .../broadcom/brcm80211/brcmfmac/bus.h         |  1 +
 .../broadcom/brcm80211/brcmfmac/common.c      | 93 ++++++++++++++-----
 2 files changed, 70 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
index 501136e011b5..fe31051a9e11 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bus.h
@@ -55,6 +55,7 @@ enum brcmf_bus_protocol_type {
 /* Firmware blobs that may be available */
 enum brcmf_blob_type {
 	BRCMF_BLOB_CLM,
+	BRCMF_BLOB_TXCAP,
 };
 
 struct brcmf_mp_device;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index f235beaddddb..be68dd0cbbd2 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -101,7 +101,7 @@ void brcmf_c_set_joinpref_default(struct brcmf_if *ifp)
 
 static int brcmf_c_download(struct brcmf_if *ifp, u16 flag,
 			    struct brcmf_dload_data_le *dload_buf,
-			    u32 len)
+			    u32 len, const char *var)
 {
 	s32 err;
 
@@ -111,18 +111,18 @@ static int brcmf_c_download(struct brcmf_if *ifp, u16 flag,
 	dload_buf->len = cpu_to_le32(len);
 	dload_buf->crc = cpu_to_le32(0);
 
-	err = brcmf_fil_iovar_data_set(ifp, "clmload", dload_buf,
+	err = brcmf_fil_iovar_data_set(ifp, var, dload_buf,
 				       struct_size(dload_buf, data, len));
 
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
@@ -132,21 +132,14 @@ static int brcmf_c_process_clm_blob(struct brcmf_if *ifp)
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	err = brcmf_bus_get_blob(bus, &clm, BRCMF_BLOB_CLM);
-	if (err || !clm) {
-		brcmf_info("no clm_blob available (err=%d), device may have limited channels available\n",
-			   err);
-		return 0;
-	}
-
 	chunk_buf = kzalloc(struct_size(chunk_buf, data, MAX_CHUNK_LEN),
 			    GFP_KERNEL);
 	if (!chunk_buf) {
 		err = -ENOMEM;
-		goto done;
+		return -ENOMEM;
 	}
 
-	datalen = clm->size;
+	datalen = size;
 	cumulative_len = 0;
 	do {
 		if (datalen > MAX_CHUNK_LEN) {
@@ -155,9 +148,10 @@ static int brcmf_c_process_clm_blob(struct brcmf_if *ifp)
 			chunk_len = datalen;
 			dl_flag |= DL_END;
 		}
-		memcpy(chunk_buf->data, clm->data + cumulative_len, chunk_len);
+		memcpy(chunk_buf->data, data + cumulative_len, chunk_len);
 
-		err = brcmf_c_download(ifp, dl_flag, chunk_buf, chunk_len);
+		err = brcmf_c_download(ifp, dl_flag, chunk_buf, chunk_len,
+				       loadvar);
 
 		dl_flag &= ~DL_BEGIN;
 
@@ -166,20 +160,64 @@ static int brcmf_c_process_clm_blob(struct brcmf_if *ifp)
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
 
@@ -291,6 +329,13 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
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
2.35.1

