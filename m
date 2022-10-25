Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EAD360D28C
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 19:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232732AbiJYRcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 13:32:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232632AbiJYRcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 13:32:13 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EE03176B89
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 10:31:47 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id g16so8038718qtu.2
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 10:31:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=1M7TR/9m0g+UHlj2ntSZZr2MOSmC9G1zYEdYzIhS1Rc=;
        b=d/BmF/toQ4JqoddCZGrK5OUKapZz0TObM5rB6WTB4tPJGUlrJ1re5ynNcBiGbpVIRG
         3GL9Knl79hXxjccWerjynIIhXusEqu7KEo7rGCBJbStdG7NLC+khyQ04Xs71TYgf9qHw
         DjILQYnpcF07hAfVEiWZJXjORBaR8+rxtCNMQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1M7TR/9m0g+UHlj2ntSZZr2MOSmC9G1zYEdYzIhS1Rc=;
        b=QImcJLeIjtzaMELXpduh/LttThkZ9+psu648cZqtU3yQXwoITFQwBW5uCWmdBG5ZLp
         t8wLGfYggoSZ/223YrKkslXZ25f4F89uIAI97Vy2K2sLXVTLnR94/PLwuXlJBXnB9LHi
         UJ0hB9BMxk4oiTfobitTY9ogL5ecRyNmzv5vZFG74GonmT53zyEihRNqSo9lp3nAe77h
         4utcKqz2oMqDuSf4jXxk8aH4TPLlzk2btH+n5V/zPvJrozedgA1V6Jlk3PZ4a9VISN9U
         tbJ3UmmPfGTodlHzeG/2Mryd9JS37komDS4TwyRxY3pSpN1yUQ8I68Isvd3L16yfNz3L
         2MeQ==
X-Gm-Message-State: ACrzQf0qBYQsRs+MKPuE3JeTa9a34YpIeWLl5wo38hFamMe+npsqk2X/
        mtMIPHsMFo9vK/2SlZgxzRwoAboLMyCB2Q==
X-Google-Smtp-Source: AMsMyM4djSZ0FZUSVwgmWgMiWY8U6zzx7fYYrolR4qb2bJPkCARcWLzTDRjLxacxDq+oGiYFIFM+mQ==
X-Received: by 2002:a05:622a:44b:b0:39c:f5bf:694d with SMTP id o11-20020a05622a044b00b0039cf5bf694dmr31862147qtx.531.1666719095804;
        Tue, 25 Oct 2022 10:31:35 -0700 (PDT)
Received: from C02GC2QQMD6T.wifi.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u6-20020a37ab06000000b006eed094dcdasm2329034qke.70.2022.10.25.10.31.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 10:31:35 -0700 (PDT)
From:   Ajit Khaparde <ajit.khaparde@broadcom.com>
To:     ajit.khaparde@broadcom.com
Cc:     andrew.gospodarek@broadcom.com, davem@davemloft.net,
        edumazet@google.com, jgg@ziepe.ca, kuba@kernel.org,
        leon@kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, michael.chan@broadcom.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        selvin.xavier@broadcom.com,
        Hongguang Gao <hongguang.gao@broadcom.com>
Subject: [PATCH v2 6/6] bnxt_en: Remove struct bnxt access from RoCE driver
Date:   Tue, 25 Oct 2022 10:31:10 -0700
Message-Id: <20221025173110.33192-7-ajit.khaparde@broadcom.com>
X-Mailer: git-send-email 2.37.0 (Apple Git-136)
In-Reply-To: <20221025173110.33192-1-ajit.khaparde@broadcom.com>
References: <20220724231458.93830-1-ajit.khaparde@broadcom.com>
 <20221025173110.33192-1-ajit.khaparde@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000004887c805ebdf4846"
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000004887c805ebdf4846
Content-Transfer-Encoding: 8bit

From: Hongguang Gao <hongguang.gao@broadcom.com>

Decouple RoCE driver from directly accessing L2's private bnxt
structure. Move the fields needed by RoCE driver into bnxt_en_dev.
They'll be passed to RoCE driver by bnxt_rdma_aux_device_add()
function.

Signed-off-by: Hongguang Gao <hongguang.gao@broadcom.com>
Signed-off-by: Ajit Khaparde <ajit.khaparde@broadcom.com>
Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
---
 drivers/infiniband/hw/bnxt_re/main.c          | 22 ++++++-------------
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c |  9 ++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h | 11 ++++++++++
 3 files changed, 27 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index 1266cfe7ea88..446025fa0bfb 100644
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
 
@@ -986,7 +981,6 @@ static int bnxt_re_query_hwrm_pri2cos(struct bnxt_re_dev *rdev, u8 dir,
 				      u64 *cid_map)
 {
 	struct hwrm_queue_pri2cos_qcfg_input req = {0};
-	struct bnxt *bp = netdev_priv(rdev->netdev);
 	struct hwrm_queue_pri2cos_qcfg_output resp;
 	struct bnxt_en_dev *en_dev = rdev->en_dev;
 	struct bnxt_fw_msg fw_msg;
@@ -1003,7 +997,7 @@ static int bnxt_re_query_hwrm_pri2cos(struct bnxt_re_dev *rdev, u8 dir,
 	flags |= (dir & 0x01);
 	flags |= HWRM_QUEUE_PRI2COS_QCFG_INPUT_FLAGS_IVLAN;
 	req.flags = cpu_to_le32(flags);
-	req.port_id = bp->pf.port_id;
+	req.port_id = en_dev->pf_port_id;
 
 	bnxt_re_fill_fw_msg(&fw_msg, (void *)&req, sizeof(req), (void *)&resp,
 			    sizeof(resp), DFLT_HWRM_CMD_TIMEOUT);
@@ -1585,7 +1579,6 @@ static int bnxt_re_probe(struct auxiliary_device *adev,
 int bnxt_re_suspend(struct auxiliary_device *adev, pm_message_t state)
 {
 	struct bnxt_re_dev *rdev = auxiliary_get_drvdata(adev);
-	struct bnxt *bp;
 
 	if (!rdev)
 		return 0;
@@ -1597,15 +1590,14 @@ int bnxt_re_suspend(struct auxiliary_device *adev, pm_message_t state)
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
index ba0c281c74ba..1bbc76037910 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
@@ -286,6 +286,7 @@ void bnxt_ulp_stop(struct bnxt *bp)
 			pm_message_t pm = {};
 
 			adrv = to_auxiliary_drv(adev->dev.driver);
+			edev->en_state = bp->state;
 			adrv->suspend(adev, pm);
 		}
 	}
@@ -312,6 +313,7 @@ void bnxt_ulp_start(struct bnxt *bp, int err)
 			struct auxiliary_driver *adrv;
 
 			adrv = to_auxiliary_drv(adev->dev.driver);
+			edev->en_state = bp->state;
 			adrv->resume(adev);
 		}
 	}
@@ -496,6 +498,13 @@ static inline void bnxt_set_edev_info(struct bnxt_en_dev *edev, struct bnxt *bp)
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
 
 int bnxt_rdma_aux_device_add(struct bnxt *bp)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
index ba253ba5aba0..9a30fd848aaa 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
@@ -63,6 +63,9 @@ struct bnxt_en_dev {
 						 BNXT_EN_FLAG_ROCEV2_CAP)
 	#define BNXT_EN_FLAG_MSIX_REQUESTED	0x4
 	#define BNXT_EN_FLAG_ULP_STOPPED	0x8
+	#define BNXT_EN_FLAG_VF			0x10
+#define BNXT_EN_VF(edev)	((edev)->flags & BNXT_EN_FLAG_VF)
+
 	struct bnxt_ulp			*ulp_tbl;
 	int				l2_db_size;	/* Doorbell BAR size in
 							 * bytes mapped by L2
@@ -72,6 +75,14 @@ struct bnxt_en_dev {
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
2.37.0 (Apple Git-136)


--0000000000004887c805ebdf4846
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
4nZK0WWosNswDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIN4dgJTwjMXbbRhpAz3t
1EKDYZJkSjzk+XbMOymX0LqSMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIyMTAyNTE3MzE0NlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAQz+arX15Xs3TJZoLGsn5TJNfBt03iqbQFO1CL
GSP2Cpfyw7mWQUE6U7pUAkazWmRHKEL22X5i3Wud5HjtRX7QMWKwOuqSiLUzIqmw5yjGz5fi76pp
5/yRozAj+aigNSOVGTCACAzeuzcOIDMCkT7Efg/Wi53A7787L6uP9/6e4oH/D8rKB9nn3HllZcV8
aIm6WQBAM6/eU383CKt94JRAXEpXWBdI8JjHihDSR4qWJEUhxoxihxIlZrfBweRQq4QxmAVtzzae
GSsNmpuI3VS5/euR6HNhRJ6c93fG44lW/dvGFZq5+svzhxqOZgdwozaZHq5QOW/Nm7FmhBrULwTf
--0000000000004887c805ebdf4846--
