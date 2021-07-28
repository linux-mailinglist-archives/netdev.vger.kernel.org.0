Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D1013D950F
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 20:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbhG1SMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 14:12:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbhG1SMF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 14:12:05 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0FE7C061765
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 11:12:03 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id ca5so6364978pjb.5
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 11:12:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=sexhwTvb3Q+GZCJkuUlzsBoKy2ylMsNzTismU60EOdk=;
        b=WLdGfyUgZqhDGcifo0MuAJULtwQ1A6a0CxI8t8wUc6uQQXwRC6Znm9lSpiRs9UXwvF
         DRiMthdKsnf2F0szMho2Av4PYmukuJuEoZArXY4IQDSHU9tWSq0IxpDYI5GSUDVf3Sxs
         RvaSYiIu8Ga+Jw5BsqopDYQsf7Eo+tV3wzrpI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=sexhwTvb3Q+GZCJkuUlzsBoKy2ylMsNzTismU60EOdk=;
        b=YnwR3nvoY+AepwZrEl1kiFZeHXMIVAL4AHatHnxTQqDRnPtlzauYWHJqhP9tXMGVgC
         FeIsiUXbh7IPGXxk6VVq1szNmKA92IEKeSOKW6sygqhz/zZZL/IV5m0kT4lXaHNnTf14
         W+fbhLPUbEFMx6dkZrI9QSagm7o8sILIGvnDsd3TQ2cqbrAjv3aWAhy8OkLEqyFyMmEh
         NDYbI9xJ30jdeSEXxLFSWKl79hWFFZ8yurxhn69hJBG+VUPAIA+FhiLYvOi48VLxJhua
         oRlwFq+meiQCn3fbnB7Cr5D1YBDfK37XESwiVDp4HA9sJ1O0ibeQ3i8KgSKTDtGsViTp
         lFvg==
X-Gm-Message-State: AOAM53245+4Bc651oe6rc2GxIBBaTrpyevXEKo4IxWHuGb7li/xTkfZQ
        4i3Di7baB8c6UrlQyjanNBZcTQ==
X-Google-Smtp-Source: ABdhPJx3Hi1i8AJjvCH2nugquoaYj/5BokfpAgK9xvthYNLtMDxiuVXZNVVTZGshfCxUoBwSmaliXg==
X-Received: by 2002:a65:4307:: with SMTP id j7mr111215pgq.387.1627495923160;
        Wed, 28 Jul 2021 11:12:03 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a16sm678901pfo.66.2021.07.28.11.12.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Jul 2021 11:12:02 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com,
        richardcochran@gmail.com, pavan.chebbi@broadcom.com,
        edwin.peer@broadcom.com
Subject: [PATCH net-next 3/6] bnxt_en: 1PPS support for 5750X family chips
Date:   Wed, 28 Jul 2021 14:11:42 -0400
Message-Id: <1627495905-17396-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1627495905-17396-1-git-send-email-michael.chan@broadcom.com>
References: <1627495905-17396-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000067833b05c832ec7d"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000067833b05c832ec7d

From: Pavan Chebbi <pavan.chebbi@broadcom.com>

1PPS (One Pulse Per Second) is a signal generated either
by the NIC PHC or an external timing source.
Integrating the support to configure and use 1PPS using
the TSIO pins along with PTP timestamps will add Grand
Master capability to the 5750X family chipsets.

This patch initializes the driver data structures and
registers the 1PPS with kernel, based on the TSIO pins'
capability in the hardware. This will create a /dev/ppsX
device which applications can use to receive PPS events.

Later patches will define functions to configure and use
the pins.

Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  2 +
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 89 ++++++++++++++++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h | 22 +++++
 4 files changed, 113 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index c9c158fb86c5..8b0db8116b87 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -7545,6 +7545,8 @@ static int __bnxt_hwrm_func_qcaps(struct bnxt *bp)
 	flags_ext = le32_to_cpu(resp->flags_ext);
 	if (flags_ext & FUNC_QCAPS_RESP_FLAGS_EXT_EXT_HW_STATS_SUPPORTED)
 		bp->fw_cap |= BNXT_FW_CAP_EXT_HW_STATS_SUPPORTED;
+	if (BNXT_PF(bp) && (flags_ext & FUNC_QCAPS_RESP_FLAGS_EXT_PTP_PPS_SUPPORTED))
+		bp->fw_cap |= BNXT_FW_CAP_PTP_PPS;
 
 	bp->tx_push_thresh = 0;
 	if ((flags & FUNC_QCAPS_RESP_FLAGS_PUSH_MODE_SUPPORTED) &&
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index bcf8d00b8c80..aa733f1b235a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1887,6 +1887,7 @@ struct bnxt {
 	#define BNXT_FW_CAP_VLAN_RX_STRIP		0x01000000
 	#define BNXT_FW_CAP_VLAN_TX_INSERT		0x02000000
 	#define BNXT_FW_CAP_EXT_HW_STATS_SUPPORTED	0x04000000
+	#define BNXT_FW_CAP_PTP_PPS			0x10000000
 	#define BNXT_FW_CAP_RING_MONITOR		0x40000000
 
 #define BNXT_NEW_RM(bp)		((bp)->fw_cap & BNXT_FW_CAP_NEW_RM)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
index 49531e7e3c6d..5b51c9e0464e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
@@ -412,6 +412,80 @@ static const struct ptp_clock_info bnxt_ptp_caps = {
 	.enable		= bnxt_ptp_enable,
 };
 
+static int bnxt_ptp_verify(struct ptp_clock_info *ptp_info, unsigned int pin,
+			   enum ptp_pin_function func, unsigned int chan)
+{
+	struct bnxt_ptp_cfg *ptp = container_of(ptp_info, struct bnxt_ptp_cfg,
+						ptp_info);
+	/* Allow only PPS pin function configuration */
+	if (ptp->pps_info.pins[pin].usage <= BNXT_PPS_PIN_PPS_OUT &&
+	    func != PTP_PF_PHYSYNC)
+		return 0;
+	else
+		return -EOPNOTSUPP;
+}
+
+/* bp->hwrm_cmd_lock held by the caller */
+static int bnxt_ptp_pps_init(struct bnxt *bp)
+{
+	struct hwrm_func_ptp_pin_qcfg_output *resp = bp->hwrm_cmd_resp_addr;
+	struct hwrm_func_ptp_pin_qcfg_input req = {0};
+	struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
+	struct ptp_clock_info *ptp_info;
+	struct bnxt_pps *pps_info;
+	u8 *pin_usg;
+	u32 i, rc;
+
+	/* Query current/default PIN CFG */
+	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_FUNC_PTP_PIN_QCFG, -1, -1);
+
+	rc = _hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
+	if (rc || !resp->num_pins)
+		return -EOPNOTSUPP;
+
+	ptp_info = &ptp->ptp_info;
+	pps_info = &ptp->pps_info;
+	pps_info->num_pins = resp->num_pins;
+	ptp_info->n_pins = pps_info->num_pins;
+	ptp_info->pin_config = kcalloc(ptp_info->n_pins,
+				       sizeof(*ptp_info->pin_config),
+				       GFP_KERNEL);
+	if (!ptp_info->pin_config)
+		return -ENOMEM;
+
+	/* Report the TSIO capability to kernel */
+	pin_usg = &resp->pin0_usage;
+	for (i = 0; i < pps_info->num_pins; i++, pin_usg++) {
+		snprintf(ptp_info->pin_config[i].name,
+			 sizeof(ptp_info->pin_config[i].name), "bnxt_pps%d", i);
+		ptp_info->pin_config[i].index = i;
+		ptp_info->pin_config[i].chan = i;
+		if (*pin_usg == BNXT_PPS_PIN_PPS_IN)
+			ptp_info->pin_config[i].func = PTP_PF_EXTTS;
+		else if (*pin_usg == BNXT_PPS_PIN_PPS_OUT)
+			ptp_info->pin_config[i].func = PTP_PF_PEROUT;
+		else
+			ptp_info->pin_config[i].func = PTP_PF_NONE;
+
+		pps_info->pins[i].usage = *pin_usg;
+	}
+
+	/* Only 1 each of ext_ts and per_out pins is available in HW */
+	ptp_info->n_ext_ts = 1;
+	ptp_info->n_per_out = 1;
+	ptp_info->pps = 1;
+	ptp_info->verify = bnxt_ptp_verify;
+
+	return 0;
+}
+
+static bool bnxt_pps_config_ok(struct bnxt *bp)
+{
+	struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
+
+	return !(bp->fw_cap & BNXT_FW_CAP_PTP_PPS) == !ptp->ptp_info.pin_config;
+}
+
 int bnxt_ptp_init(struct bnxt *bp)
 {
 	struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
@@ -424,9 +498,15 @@ int bnxt_ptp_init(struct bnxt *bp)
 	if (rc)
 		return rc;
 
-	if (ptp->ptp_clock)
+	if (ptp->ptp_clock && bnxt_pps_config_ok(bp))
 		return 0;
 
+	if (ptp->ptp_clock) {
+		ptp_clock_unregister(ptp->ptp_clock);
+		ptp->ptp_clock = NULL;
+		kfree(ptp->ptp_info.pin_config);
+		ptp->ptp_info.pin_config = NULL;
+	}
 	atomic_set(&ptp->tx_avail, BNXT_MAX_TX_TS);
 	spin_lock_init(&ptp->ptp_lock);
 
@@ -439,6 +519,10 @@ int bnxt_ptp_init(struct bnxt *bp)
 	timecounter_init(&ptp->tc, &ptp->cc, ktime_to_ns(ktime_get_real()));
 
 	ptp->ptp_info = bnxt_ptp_caps;
+	if ((bp->fw_cap & BNXT_FW_CAP_PTP_PPS)) {
+		if (bnxt_ptp_pps_init(bp))
+			netdev_err(bp->dev, "1pps not initialized, continuing without 1pps support\n");
+	}
 	ptp->ptp_clock = ptp_clock_register(&ptp->ptp_info, &bp->pdev->dev);
 	if (IS_ERR(ptp->ptp_clock)) {
 		int err = PTR_ERR(ptp->ptp_clock);
@@ -468,6 +552,9 @@ void bnxt_ptp_clear(struct bnxt *bp)
 		ptp_clock_unregister(ptp->ptp_clock);
 
 	ptp->ptp_clock = NULL;
+	kfree(ptp->ptp_info.pin_config);
+	ptp->ptp_info.pin_config = NULL;
+
 	if (ptp->tx_skb) {
 		dev_kfree_skb_any(ptp->tx_skb);
 		ptp->tx_skb = NULL;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
index 4135ea3ec788..619a6a1bf9fa 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
@@ -21,11 +21,33 @@
 #define BNXT_PTP_QTS_TX_ENABLES	(PORT_TS_QUERY_REQ_ENABLES_PTP_SEQ_ID |	\
 				 PORT_TS_QUERY_REQ_ENABLES_TS_REQ_TIMEOUT)
 
+struct pps_pin {
+	u8 usage;
+};
+
+#define BNXT_PPS_PIN_DISABLE	0
+#define BNXT_PPS_PIN_ENABLE	1
+#define BNXT_PPS_PIN_NONE	0
+#define BNXT_PPS_PIN_PPS_IN	1
+#define BNXT_PPS_PIN_PPS_OUT	2
+#define BNXT_PPS_PIN_SYNC_IN	3
+#define BNXT_PPS_PIN_SYNC_OUT	4
+
+#define BNXT_PPS_EVENT_INTERNAL	1
+#define BNXT_PPS_EVENT_EXTERNAL	2
+
+struct bnxt_pps {
+	u8 num_pins;
+#define BNXT_MAX_TSIO_PINS	4
+	struct pps_pin pins[BNXT_MAX_TSIO_PINS];
+};
+
 struct bnxt_ptp_cfg {
 	struct ptp_clock_info	ptp_info;
 	struct ptp_clock	*ptp_clock;
 	struct cyclecounter	cc;
 	struct timecounter	tc;
+	struct bnxt_pps		pps_info;
 	/* serialize timecounter access */
 	spinlock_t		ptp_lock;
 	struct sk_buff		*tx_skb;
-- 
2.18.1


--00000000000067833b05c832ec7d
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
xV4Em+0wQoEIR2kPG6yiZNtUK0tNCaZejYU/Mf/bzdKSwud3pLgHV8ls83y2OU/ha9xgJMLpRswv
xucFCxMsPmk0yoVmpbr92kIpLm+TomNZsL++LcDRa2ECAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUz2bMvqtXpXM0u3vAvRkalz60
CjswDQYJKoZIhvcNAQELBQADggEBAGUgeqqI/q2pkETeLr6oS7nnm1bkeNmtnJ2bnybNO/RdrbPj
DHVSiDCCrWr6xrc+q6OiZDKm0Ieq6BN+Wfr8h5mCkZMUdJikI85WcQTRk6EEF2lzIiaULmFD7U15
FSWQptLx+kiu63idTII4r3k/7+dJ5AhLRr4WCoXEme2GZkfSbYC3fEL46tb1w7w+25OEFCv1MtDZ
1CHkODrS2JGwDQxXKmyF64MhJiOutWHmqoGmLJVz1jnDvClsYtgT4zcNtoqKtjpWDYAefncWDPIQ
DauX1eWVM+KepL7zoSNzVbTipc65WuZFLR8ngOwkpknqvS9n/nKd885m23oIocC+GA4xggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwQeU+Y6hbenPzRMJsw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIOAnYYqnoeApj/GxfBIpksKylG5WDLaB
FTenY4jDSn1dMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDcy
ODE4MTIwM1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQAnlornHTp1celByrb98I9GMS9ji3J6/OfNY+DyDOn5zGFxw+mt
Qhu3mYrF0PVrptx3k44te5J9VhqB6UK3vQEYfulfio5BOFeYbIWBzyd0x8cMsnm5ifbc/mRf27lw
aqn2qKKtS4CmFel5mbTTPKvxX3lQ0HVBojkPUCFi908T4bdip+laDdPk63rUpLkoRG1JZ2QWt8gv
XLejXSJ+FXGvDkI+Do3usAgaEIvnHyI6kNZWj3h/g2J6ZZqubboKEr9MD1PDyqhntQse21Ep2PI4
RBakbyKC5f5fl+inF2G9eB5SIqdC5OmmufenZAJxGoV3vagz+BT3BOz7MP4tM4U2
--00000000000067833b05c832ec7d--
