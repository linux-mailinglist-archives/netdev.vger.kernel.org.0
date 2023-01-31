Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97C9F6823F0
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 06:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbjAaF1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 00:27:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbjAaF0T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 00:26:19 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F41193B652
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 21:26:16 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id p24so13935806plw.11
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 21:26:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=LZMtM3zkrQ4/7MsHSkny8rbXRCoOzYl9+aMnRGuCTIM=;
        b=IZ+kIPZsSvroACSAzFhsEUuge7+QiCctdPusL4vwWxGKH1/FRqGya2yDSaXRG9bT0t
         ydkWurDLNIEqZz0JslDlIo3oPUbbGfz4nt6uznevkddSCSSPJe93gX7f5BgL9+TlUiho
         ajMAS6hJj8vn6NlxCA4lNVKtPKfv6Qfydjq7Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LZMtM3zkrQ4/7MsHSkny8rbXRCoOzYl9+aMnRGuCTIM=;
        b=B1j3Q2qgQHounpm7Z0sE/te0y1dQ++zkmBDv/9jAvsDzgfwFT0dsW6w64mBik526AS
         srtET9G/37/BK1krIrCMAJkYGtMIJRBacVU1KG0rheuuUhm/b2cqVFPlD4sbbpRZYX4i
         8MytF3KbJj3ce85TicKuxbx9aGlCc4slfhIbcPycDrkA22qLkO/ifLim9ra61SjjuhlL
         x3UoJcNd5nh5UvEwuHNIyKs9HPL+T4wHv6j//puWEVjqW4+KojmWjzXiF4MxjR7vVTY8
         hCO/jzao6e5Rg+j+WTrr5L+waxIZhZod0arDFrwQm4pR3qXkUO6L1oxjzEjxvhdl8Eyf
         kY8Q==
X-Gm-Message-State: AO0yUKUU1DvHlJnZOCwHmBobsFe071elVG+aanTreNi59cjC7jW3OE4n
        xVP3rEyi39fcyIgAVups/hllMQ==
X-Google-Smtp-Source: AK7set9rG4/wvbXREvsLElTymVc7TRCB+uG5RyXpJn6pk4eALGuYZARTtzw/GVuZL2fVNrDI81M10Q==
X-Received: by 2002:a17:902:d48d:b0:196:4f0d:c31f with SMTP id c13-20020a170902d48d00b001964f0dc31fmr20226420plg.12.1675142776386;
        Mon, 30 Jan 2023 21:26:16 -0800 (PST)
Received: from localhost.localdomain ([2605:a601:a780:1400:a879:b64b:d9bd:3c1])
        by smtp.gmail.com with ESMTPSA id jk15-20020a170903330f00b001960cccc318sm2310106plb.121.2023.01.30.21.26.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 21:26:15 -0800 (PST)
From:   Ajit Khaparde <ajit.khaparde@broadcom.com>
To:     ajit.khaparde@broadcom.com
Cc:     andrew.gospodarek@broadcom.com, davem@davemloft.net,
        edumazet@google.com, jgg@ziepe.ca, kuba@kernel.org,
        leon@kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, michael.chan@broadcom.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        selvin.xavier@broadcom.com, gregkh@linuxfoundation.org,
        Hongguang Gao <hongguang.gao@broadcom.com>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: [PATCH net-next v9 6/8] bnxt_en: Remove struct bnxt access from RoCE driver
Date:   Mon, 30 Jan 2023 21:25:55 -0800
Message-Id: <20230131052557.99119-7-ajit.khaparde@broadcom.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20230131052557.99119-1-ajit.khaparde@broadcom.com>
References: <20230131052557.99119-1-ajit.khaparde@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000027abe305f3889280"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000027abe305f3889280
Content-Transfer-Encoding: 8bit

From: Hongguang Gao <hongguang.gao@broadcom.com>

Decouple RoCE driver from directly accessing L2's private bnxt
structure. Move the fields needed by RoCE driver into bnxt_en_dev.
They'll be passed to RoCE driver by bnxt_rdma_aux_device_add()
function.

Signed-off-by: Hongguang Gao <hongguang.gao@broadcom.com>
Signed-off-by: Ajit Khaparde <ajit.khaparde@broadcom.com>
Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
Reviewed-by: Selvin Xavier <selvin.xavier@broadcom.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/bnxt_re/main.c          | 22 ++++++-------------
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c |  9 ++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h | 11 ++++++++++
 3 files changed, 27 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index ffcd2a4d9f9a..ed7ac6acaaff 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -112,16 +112,14 @@ static int bnxt_re_setup_chip_ctx(struct bnxt_re_dev *rdev, u8 wqe_mode)
 {
 	struct bnxt_qplib_chip_ctx *chip_ctx;
 	struct bnxt_en_dev *en_dev;
-	struct bnxt *bp;
 
 	en_dev = rdev->en_dev;
-	bp = netdev_priv(en_dev->net);
 
 	chip_ctx = kzalloc(sizeof(*chip_ctx), GFP_KERNEL);
 	if (!chip_ctx)
 		return -ENOMEM;
-	chip_ctx->chip_num = bp->chip_num;
-	chip_ctx->hw_stats_size = bp->hw_ring_stats_size;
+	chip_ctx->chip_num = en_dev->chip_num;
+	chip_ctx->hw_stats_size = en_dev->hw_ring_stats_size;
 
 	rdev->chip_ctx = chip_ctx;
 	/* rest members to follow eventually */
@@ -129,7 +127,7 @@ static int bnxt_re_setup_chip_ctx(struct bnxt_re_dev *rdev, u8 wqe_mode)
 	rdev->qplib_res.cctx = rdev->chip_ctx;
 	rdev->rcfw.res = &rdev->qplib_res;
 	rdev->qplib_res.dattr = &rdev->dev_attr;
-	rdev->qplib_res.is_vf = BNXT_VF(bp);
+	rdev->qplib_res.is_vf = BNXT_EN_VF(en_dev);
 
 	bnxt_re_set_drv_mode(rdev, wqe_mode);
 	if (bnxt_qplib_determine_atomics(en_dev->pdev))
@@ -142,10 +140,7 @@ static int bnxt_re_setup_chip_ctx(struct bnxt_re_dev *rdev, u8 wqe_mode)
 
 static void bnxt_re_get_sriov_func_type(struct bnxt_re_dev *rdev)
 {
-	struct bnxt *bp;
-
-	bp = netdev_priv(rdev->en_dev->net);
-	if (BNXT_VF(bp))
+	if (BNXT_EN_VF(rdev->en_dev))
 		rdev->is_virtfn = 1;
 }
 
@@ -957,7 +952,6 @@ static int bnxt_re_query_hwrm_pri2cos(struct bnxt_re_dev *rdev, u8 dir,
 				      u64 *cid_map)
 {
 	struct hwrm_queue_pri2cos_qcfg_input req = {0};
-	struct bnxt *bp = netdev_priv(rdev->netdev);
 	struct hwrm_queue_pri2cos_qcfg_output resp;
 	struct bnxt_en_dev *en_dev = rdev->en_dev;
 	struct bnxt_fw_msg fw_msg;
@@ -974,7 +968,7 @@ static int bnxt_re_query_hwrm_pri2cos(struct bnxt_re_dev *rdev, u8 dir,
 	flags |= (dir & 0x01);
 	flags |= HWRM_QUEUE_PRI2COS_QCFG_INPUT_FLAGS_IVLAN;
 	req.flags = cpu_to_le32(flags);
-	req.port_id = bp->pf.port_id;
+	req.port_id = en_dev->pf_port_id;
 
 	bnxt_re_fill_fw_msg(&fw_msg, (void *)&req, sizeof(req), (void *)&resp,
 			    sizeof(resp), DFLT_HWRM_CMD_TIMEOUT);
@@ -1547,7 +1541,6 @@ static int bnxt_re_probe(struct auxiliary_device *adev,
 static int bnxt_re_suspend(struct auxiliary_device *adev, pm_message_t state)
 {
 	struct bnxt_re_dev *rdev = auxiliary_get_drvdata(adev);
-	struct bnxt *bp;
 
 	if (!rdev)
 		return 0;
@@ -1559,15 +1552,14 @@ static int bnxt_re_suspend(struct auxiliary_device *adev, pm_message_t state)
 	 * ie. by calling bnxt_re_dev_stop and release the MSIx vectors as
 	 * L2 driver want to modify the MSIx table.
 	 */
-	bp = netdev_priv(rdev->netdev);
 
 	ibdev_info(&rdev->ibdev, "Handle device suspend call");
-	/* Check the current device state from L2 structure and move the
+	/* Check the current device state from bnxt_en_dev and move the
 	 * device to detached state if FW_FATAL_COND is set.
 	 * This prevents more commands to HW during clean-up,
 	 * in case the device is already in error.
 	 */
-	if (test_bit(BNXT_STATE_FW_FATAL_COND, &bp->state))
+	if (test_bit(BNXT_STATE_FW_FATAL_COND, &rdev->en_dev->en_state))
 		set_bit(ERR_DEVICE_DETACHED, &rdev->rcfw.cmdq.flags);
 
 	bnxt_re_dev_stop(rdev);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
index f6d348b36e13..fc5ded5d0d09 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
@@ -287,6 +287,7 @@ void bnxt_ulp_stop(struct bnxt *bp)
 			pm_message_t pm = {};
 
 			adrv = to_auxiliary_drv(adev->dev.driver);
+			edev->en_state = bp->state;
 			adrv->suspend(adev, pm);
 		}
 	}
@@ -313,6 +314,7 @@ void bnxt_ulp_start(struct bnxt *bp, int err)
 			struct auxiliary_driver *adrv;
 
 			adrv = to_auxiliary_drv(adev->dev.driver);
+			edev->en_state = bp->state;
 			adrv->resume(adev);
 		}
 	}
@@ -447,6 +449,13 @@ static void bnxt_set_edev_info(struct bnxt_en_dev *edev, struct bnxt *bp)
 		edev->flags |= BNXT_EN_FLAG_ROCEV1_CAP;
 	if (bp->flags & BNXT_FLAG_ROCEV2_CAP)
 		edev->flags |= BNXT_EN_FLAG_ROCEV2_CAP;
+	if (bp->flags & BNXT_FLAG_VF)
+		edev->flags |= BNXT_EN_FLAG_VF;
+
+	edev->chip_num = bp->chip_num;
+	edev->hw_ring_stats_size = bp->hw_ring_stats_size;
+	edev->pf_port_id = bp->pf.port_id;
+	edev->en_state = bp->state;
 }
 
 void bnxt_rdma_aux_device_init(struct bnxt *bp)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
index adc5a9a235c2..c62986e4cc82 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
@@ -59,6 +59,9 @@ struct bnxt_en_dev {
 						 BNXT_EN_FLAG_ROCEV2_CAP)
 	#define BNXT_EN_FLAG_MSIX_REQUESTED	0x4
 	#define BNXT_EN_FLAG_ULP_STOPPED	0x8
+	#define BNXT_EN_FLAG_VF			0x10
+#define BNXT_EN_VF(edev)	((edev)->flags & BNXT_EN_FLAG_VF)
+
 	struct bnxt_ulp			*ulp_tbl;
 	int				l2_db_size;	/* Doorbell BAR size in
 							 * bytes mapped by L2
@@ -68,6 +71,14 @@ struct bnxt_en_dev {
 							 * bytes mapped as non-
 							 * cacheable.
 							 */
+	u16				chip_num;
+	u16				hw_ring_stats_size;
+	u16				pf_port_id;
+	unsigned long			en_state;	/* Could be checked in
+							 * RoCE driver suspend
+							 * mode only. Will be
+							 * updated in resume.
+							 */
 };
 
 static inline bool bnxt_ulp_registered(struct bnxt_en_dev *edev)
-- 
2.37.1 (Apple Git-137.1)


--00000000000027abe305f3889280
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
pZEyqKnwS1lKCzjX7mV5W955rFsFxChdAKfw0HilwtqdY24mhy62+GeaEkD0gYIj1tCmw9gnQToc
K+0s7xEunfR9pBrzmOwS3OQbcP0nJ8SmQ8R+reroH6LYuFpaqK1rgQIDAQABo4IB2zCCAdcwDgYD
VR0PAQH/BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3Vy
ZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEG
CCsGAQUFBzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWdu
MmNhMjAyMDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93
d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6
hjhodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNy
bDAlBgNVHREEHjAcgRphaml0LmtoYXBhcmRlQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEF
BQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUbrcTuh0mr2qP
xYdtyDgFeRIiE/gwDQYJKoZIhvcNAQELBQADggEBALrc1TljKrDhXicOaZlzIQyqOEkKAZ324i8X
OwzA0n2EcPGmMZvgARurvanSLD3mLeeuyq1feCcjfGM1CJFh4+EY7EkbFbpVPOIdstSBhbnAJnOl
aC/q0wTndKoC/xXBhXOZB8YL/Zq4ZclQLMUO6xi/fFRyHviI5/IrosdrpniXFJ9ukJoOXtvdrEF+
KlMYg/Deg9xo3wddCqQIsztHSkR4XaANdn+dbLRQpctZ13BY1lim4uz5bYn3M0IxyZWkQ1JuPHCK
aRJv0SfR88PoI4RB7NCEHqFwARTj1KvFPQi8pK/YISFydZYbZrxQdyWDidqm4wSuJfpE6i0cWvCd
u50xggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNh
MTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwM2Vrj
4nZK0WWosNswDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIBKtCJxjXolklUG4HEiI
azssZ1E5W+7J5KeBnSdqT8MSMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIzMDEzMTA1MjYxNlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQBslcBSdOrEa/GB9BegHYAbGvaDJKMBv9lJp6i7
VmRf2ONLwY/0w+KCWvDwIzIde0u6DTc6P748xmuHxbwMj5P4Efc6R2FUmqmKa7SZfTwEGx2McLwf
DB77xwNHnRsCIqhHopbLLg+flotJz/8gt9zX/T8+D73XgzFWLLWAMCq1O/pkHxlfatDTh19Vhn+2
zrCO81EZDfh8FTBWuIWUgjFravqS+M8eHEbXlsK/nwQpDPGH0cmp7W+sf9yxs+Pa0qyWtBjvS/ye
sCEbc8mZIldhVmOXVKYMnNUIHdy11cS6uXSltxXx/+5Ijf7nKnbHy/WTZhiKZgFebswyR5GI2BLn
--00000000000027abe305f3889280--
