Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0504266847F
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 21:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240732AbjALUyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 15:54:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233096AbjALUxV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 15:53:21 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 596631CFF9
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 12:29:54 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id w3so21378878ply.3
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 12:29:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=dP2Aepcx6Ah6HrWwBzYXsYmLE3fxs6zdi63zjiDZXPA=;
        b=cL38afo2DNhcUZ/hhRRvo7BcHbKZr9zly6gNZPZ7iAwg7kCbuQJOGi8RDNvFXLmKdE
         IpWMjwbuBoF34C5VWvJ4C79I2utKOdmAjv3mN3docE8Wcyi7CxmGy9QGolXNBBsZvDDF
         MZMQjwVon6P09k8iyoQwaR524Qe4yMclBPM9o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dP2Aepcx6Ah6HrWwBzYXsYmLE3fxs6zdi63zjiDZXPA=;
        b=P9gQId9xC1ir3NC9wJ/FxbRRBfXaDT5SbH/aqwBo9JX+Ztj/m7BXhx2PtcNHBbLRBN
         b3UHmp7BYvG4qZ6LqvuHS8qq7EYSfLAYxrglqCMI8AvzWR7iF8SLmU9t42W+lXoTAFB3
         Ddgl9tBc6sw/j/TSk0ooRz59tPNC6yXKieQuvXqqRbKT2ybYYcD+soZ5SuDk359TR/Ps
         L1KVj/lHGu92msTSJA6jOLBJ+fAD/HVDQlDShgSLMhpFQStv2KZudGwKjTQpgo/pdx9f
         zdCrwKwSX6Ms8KI6h9JvdRHXhtm4tt9vOFWVaDEwLDujvmpY5rx7PmttTfMA0ke83r7S
         VaDw==
X-Gm-Message-State: AFqh2krZ32AEsSLKmIFcYJpqNQY4O9J8xZhccsYwEDLdGmqttlACUrGT
        cWzUTUsnW3NaSVwa92KdUJwLQw==
X-Google-Smtp-Source: AMrXdXuvMpyPqkIEHoSeT7UCTOBurlHGqumacbSKPPfVWo10/Oufa0nhr/+qZWJYA+/WLzQYzgLLQw==
X-Received: by 2002:a17:902:bb86:b0:193:1f24:a042 with SMTP id m6-20020a170902bb8600b001931f24a042mr18479651pls.29.1673555393800;
        Thu, 12 Jan 2023 12:29:53 -0800 (PST)
Received: from C02GC2QQMD6T.wifi.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 129-20020a630887000000b004777c56747csm10283855pgi.11.2023.01.12.12.29.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 12:29:53 -0800 (PST)
From:   Ajit Khaparde <ajit.khaparde@broadcom.com>
To:     ajit.khaparde@broadcom.com
Cc:     andrew.gospodarek@broadcom.com, davem@davemloft.net,
        edumazet@google.com, jgg@ziepe.ca, kuba@kernel.org,
        leon@kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, michael.chan@broadcom.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        selvin.xavier@broadcom.com, Leon Romanovsky <leonro@nvidia.com>
Subject: [PATCH net-next v7 5/8] bnxt_en: Use auxiliary bus calls over proprietary calls
Date:   Thu, 12 Jan 2023 12:29:36 -0800
Message-Id: <20230112202939.19562-6-ajit.khaparde@broadcom.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20230112202939.19562-1-ajit.khaparde@broadcom.com>
References: <20230112202939.19562-1-ajit.khaparde@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000c94b1b05f216fabe"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000c94b1b05f216fabe
Content-Transfer-Encoding: 8bit

Wherever possible use the function ops provided by auxiliary bus
instead of using proprietary ops.

Defined bnxt_re_suspend and bnxt_re_resume calls which can be
invoked by the bnxt_en driver instead of the ULP stop/start calls.

Signed-off-by: Ajit Khaparde <ajit.khaparde@broadcom.com>
Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
Reviewed-by: Selvin Xavier <selvin.xavier@broadcom.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/bnxt_re/main.c          | 102 +++++++++++-------
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c |  40 ++++---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h |   2 -
 3 files changed, 87 insertions(+), 57 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/main.c b/drivers/infiniband/hw/bnxt_re/main.c
index e1777c8e6d5e..ae04198c33b7 100644
--- a/drivers/infiniband/hw/bnxt_re/main.c
+++ b/drivers/infiniband/hw/bnxt_re/main.c
@@ -226,45 +226,6 @@ static void bnxt_re_set_resource_limits(struct bnxt_re_dev *rdev)
 		bnxt_re_limit_vf_res(&rdev->qplib_ctx, num_vfs);
 }
 
-/* for handling bnxt_en callbacks later */
-static void bnxt_re_stop(void *p)
-{
-	struct bnxt_re_dev *rdev = p;
-	struct bnxt *bp;
-
-	if (!rdev)
-		return;
-
-	/* L2 driver invokes this callback during device error/crash or device
-	 * reset. Current RoCE driver doesn't recover the device in case of
-	 * error. Handle the error by dispatching fatal events to all qps
-	 * ie. by calling bnxt_re_dev_stop and release the MSIx vectors as
-	 * L2 driver want to modify the MSIx table.
-	 */
-	bp = netdev_priv(rdev->netdev);
-
-	ibdev_info(&rdev->ibdev, "Handle device stop call from L2 driver");
-	/* Check the current device state from L2 structure and move the
-	 * device to detached state if FW_FATAL_COND is set.
-	 * This prevents more commands to HW during clean-up,
-	 * in case the device is already in error.
-	 */
-	if (test_bit(BNXT_STATE_FW_FATAL_COND, &bp->state))
-		set_bit(ERR_DEVICE_DETACHED, &rdev->rcfw.cmdq.flags);
-
-	bnxt_re_dev_stop(rdev);
-	bnxt_re_stop_irq(rdev);
-	/* Move the device states to detached and  avoid sending any more
-	 * commands to HW
-	 */
-	set_bit(BNXT_RE_FLAG_ERR_DEVICE_DETACHED, &rdev->flags);
-	set_bit(ERR_DEVICE_DETACHED, &rdev->rcfw.cmdq.flags);
-}
-
-static void bnxt_re_start(void *p)
-{
-}
-
 static void bnxt_re_sriov_config(void *p, int num_vfs)
 {
 	struct bnxt_re_dev *rdev = p;
@@ -341,8 +302,6 @@ static void bnxt_re_start_irq(void *handle, struct bnxt_msix_entry *ent)
 }
 
 static struct bnxt_ulp_ops bnxt_re_ulp_ops = {
-	.ulp_stop = bnxt_re_stop,
-	.ulp_start = bnxt_re_start,
 	.ulp_sriov_config = bnxt_re_sriov_config,
 	.ulp_irq_stop = bnxt_re_stop_irq,
 	.ulp_irq_restart = bnxt_re_start_irq
@@ -1585,6 +1544,65 @@ static int bnxt_re_probe(struct auxiliary_device *adev,
 	return rc;
 }
 
+static int bnxt_re_suspend(struct auxiliary_device *adev, pm_message_t state)
+{
+	struct bnxt_re_dev *rdev = auxiliary_get_drvdata(adev);
+	struct bnxt *bp;
+
+	if (!rdev)
+		return 0;
+
+	mutex_lock(&bnxt_re_mutex);
+	/* L2 driver may invoke this callback during device error/crash or device
+	 * reset. Current RoCE driver doesn't recover the device in case of
+	 * error. Handle the error by dispatching fatal events to all qps
+	 * ie. by calling bnxt_re_dev_stop and release the MSIx vectors as
+	 * L2 driver want to modify the MSIx table.
+	 */
+	bp = netdev_priv(rdev->netdev);
+
+	ibdev_info(&rdev->ibdev, "Handle device suspend call");
+	/* Check the current device state from L2 structure and move the
+	 * device to detached state if FW_FATAL_COND is set.
+	 * This prevents more commands to HW during clean-up,
+	 * in case the device is already in error.
+	 */
+	if (test_bit(BNXT_STATE_FW_FATAL_COND, &bp->state))
+		set_bit(ERR_DEVICE_DETACHED, &rdev->rcfw.cmdq.flags);
+
+	bnxt_re_dev_stop(rdev);
+	bnxt_re_stop_irq(rdev);
+	/* Move the device states to detached and  avoid sending any more
+	 * commands to HW
+	 */
+	set_bit(BNXT_RE_FLAG_ERR_DEVICE_DETACHED, &rdev->flags);
+	set_bit(ERR_DEVICE_DETACHED, &rdev->rcfw.cmdq.flags);
+	mutex_unlock(&bnxt_re_mutex);
+
+	return 0;
+}
+
+static int bnxt_re_resume(struct auxiliary_device *adev)
+{
+	struct bnxt_re_dev *rdev = auxiliary_get_drvdata(adev);
+
+	if (!rdev)
+		return 0;
+
+	mutex_lock(&bnxt_re_mutex);
+	/* L2 driver may invoke this callback during device recovery, resume.
+	 * reset. Current RoCE driver doesn't recover the device in case of
+	 * error. Handle the error by dispatching fatal events to all qps
+	 * ie. by calling bnxt_re_dev_stop and release the MSIx vectors as
+	 * L2 driver want to modify the MSIx table.
+	 */
+
+	ibdev_info(&rdev->ibdev, "Handle device resume call");
+	mutex_unlock(&bnxt_re_mutex);
+
+	return 0;
+}
+
 static const struct auxiliary_device_id bnxt_re_id_table[] = {
 	{ .name = BNXT_ADEV_NAME ".rdma", },
 	{},
@@ -1597,6 +1615,8 @@ static struct auxiliary_driver bnxt_re_driver = {
 	.probe = bnxt_re_probe,
 	.remove = bnxt_re_remove,
 	.shutdown = bnxt_re_shutdown,
+	.suspend = bnxt_re_suspend,
+	.resume = bnxt_re_resume,
 	.id_table = bnxt_re_id_table,
 };
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
index e7539946759d..e08b51ee8886 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
@@ -272,26 +272,31 @@ static void bnxt_ulp_put(struct bnxt_ulp *ulp)
 
 void bnxt_ulp_stop(struct bnxt *bp)
 {
+	struct bnxt_aux_dev *bnxt_aux = bp->aux_dev;
 	struct bnxt_en_dev *edev = bp->edev;
-	struct bnxt_ulp_ops *ops;
-	struct bnxt_ulp *ulp;
 
 	if (!edev)
 		return;
 
 	edev->flags |= BNXT_EN_FLAG_ULP_STOPPED;
-	ulp = edev->ulp_tbl;
-	ops = rtnl_dereference(ulp->ulp_ops);
-	if (!ops || !ops->ulp_stop)
-		return;
-	ops->ulp_stop(ulp->handle);
+	if (bnxt_aux) {
+		struct auxiliary_device *adev;
+
+		adev = &bnxt_aux->aux_dev;
+		if (adev->dev.driver) {
+			struct auxiliary_driver *adrv;
+			pm_message_t pm = {};
+
+			adrv = to_auxiliary_drv(adev->dev.driver);
+			adrv->suspend(adev, pm);
+		}
+	}
 }
 
 void bnxt_ulp_start(struct bnxt *bp, int err)
 {
+	struct bnxt_aux_dev *bnxt_aux = bp->aux_dev;
 	struct bnxt_en_dev *edev = bp->edev;
-	struct bnxt_ulp_ops *ops;
-	struct bnxt_ulp *ulp;
 
 	if (!edev)
 		return;
@@ -301,11 +306,18 @@ void bnxt_ulp_start(struct bnxt *bp, int err)
 	if (err)
 		return;
 
-	ulp = edev->ulp_tbl;
-	ops = rtnl_dereference(ulp->ulp_ops);
-	if (!ops || !ops->ulp_start)
-		return;
-	ops->ulp_start(ulp->handle);
+	if (bnxt_aux) {
+		struct auxiliary_device *adev;
+
+		adev = &bnxt_aux->aux_dev;
+		if (adev->dev.driver) {
+			struct auxiliary_driver *adrv;
+
+			adrv = to_auxiliary_drv(adev->dev.driver);
+			adrv->resume(adev);
+		}
+	}
+
 }
 
 void bnxt_ulp_sriov_cfg(struct bnxt *bp, int num_vfs)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
index 3bda864db1be..6525aad3b642 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.h
@@ -26,8 +26,6 @@ struct bnxt_msix_entry {
 };
 
 struct bnxt_ulp_ops {
-	void (*ulp_stop)(void *);
-	void (*ulp_start)(void *);
 	void (*ulp_sriov_config)(void *, int);
 	void (*ulp_irq_stop)(void *);
 	void (*ulp_irq_restart)(void *, struct bnxt_msix_entry *);
-- 
2.37.1 (Apple Git-137.1)


--000000000000c94b1b05f216fabe
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
4nZK0WWosNswDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIAJkXVBiiRBszRvOJYs3
cjpvogrAIYXnr6YqO7OTOzATMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTIzMDExMjIwMjk1NFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUD
BAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsG
CWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQBCYNNJUbnZvLQTTCumOt+Y5Vjv1SZQ3fYB2oYg
YLSoTE8HSdKgHjZcjlDO3HFPtKXrRFV10/DDsTqY7RqY9MmBpSZfmFmtuuqXIpX2p1P4lk7n5YCg
J2tbcnWsODF5J7AXzc2GDOsMcMARe976W3uWWvQ/mZUZ0Lw3j1z3xJqOqfl4wurIyUJVQjqFpOxD
0e8Cm0aKtr+XHbSYymQ4bMA1403VY+vwxf32+Dk+ZO54WK0vNP8xFqrk621OswpATMJb0aoBCR/4
jPjzYE7jHmpF6MtfdGUq6miC5qJDuoJXUqNrmBTJZSssXQXKPQeH/qLC+JcmQ/brIgbEu0Im85SL
--000000000000c94b1b05f216fabe--
