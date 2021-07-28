Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6883D9510
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 20:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbhG1SMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 14:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230427AbhG1SMG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 14:12:06 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32828C0613CF
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 11:12:05 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id mt6so6455192pjb.1
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 11:12:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=H+Rqa7Ccw13r/GyqL1W7ZH42PxLAPfwGjBbmnfLTMnk=;
        b=Vk+82mbHKMGs75bYqwFE5RWQ0i6uuDP+WUKM8OupfWWgq0Enuo4QOpzadhTLibiq4V
         g2ZCiPwa5/bq3ctGYJzoJFhBFut9c0OF85T+z/Uzka98ioNSXbluMX2SaF15FJUBJrh7
         rCaoAyrESBTNv0Re+VW7QfhPYi9yuuklkjjXI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=H+Rqa7Ccw13r/GyqL1W7ZH42PxLAPfwGjBbmnfLTMnk=;
        b=f4oX8iDsUYuulPiLV6wqBALyHs1SAyMmZN6/2ChPhfz862/wkT+Wgf8atDLBWRdthm
         m+pEdWNyZiu14cQtcLlPGtANVbf92phDppdpfcTPW5amexO22AusGLNYjAiMXrbtwQrg
         +5xVgbEygc18CTmHUBP8m0lgt4xkTs8NoG08agqrhBWkT3oE5QXfIg5VOdO0jmcjnfLR
         R8ENDdnApaIkIpaAS+orwE5AoV2pQPvKgslZaxQQSgss7AGpfA+Bse434gkKmPSuKX31
         fWbgZaktJ+lXgYR8Ld/3nzvWKV2KV8i9S9rT10vwZxX5jWd83DKdMABjv66b7dUSQch4
         dfGw==
X-Gm-Message-State: AOAM53157Yt616ArZLLTVwhLGMzNk3XujmuXqx/lvbD73KHcOR3jIV8M
        Owp1Br0djHal++iiQLZf3uTLGg==
X-Google-Smtp-Source: ABdhPJwVjzdtYKyFp47kiGrQ/syT86fMgRU/FSCL6En2siXdv4H+Sq+LYmRFu+i4hoPV/tYsVairlw==
X-Received: by 2002:a17:902:7085:b029:114:eb3f:fe29 with SMTP id z5-20020a1709027085b0290114eb3ffe29mr961481plk.40.1627495924430;
        Wed, 28 Jul 2021 11:12:04 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a16sm678901pfo.66.2021.07.28.11.12.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Jul 2021 11:12:03 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com,
        richardcochran@gmail.com, pavan.chebbi@broadcom.com,
        edwin.peer@broadcom.com
Subject: [PATCH net-next 4/6] bnxt_en: 1PPS functions to configure TSIO pins
Date:   Wed, 28 Jul 2021 14:11:43 -0400
Message-Id: <1627495905-17396-5-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1627495905-17396-1-git-send-email-michael.chan@broadcom.com>
References: <1627495905-17396-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000007b252705c832ec66"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000007b252705c832ec66

From: Pavan Chebbi <pavan.chebbi@broadcom.com>

Application will send ioctls to set/clear PPS pin functions
based on user input. This patch implements the driver
callbacks that will configure the TSIO pins using firmware
commands. After firmware reset, the TSIO pins will be reconfigured
again.

Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 174 +++++++++++++++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h |   5 +
 3 files changed, 178 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 8b0db8116b87..13e44ce3963f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -12150,6 +12150,7 @@ static void bnxt_fw_reset_task(struct work_struct *work)
 			bnxt_reenable_sriov(bp);
 		bnxt_vf_reps_alloc(bp);
 		bnxt_vf_reps_open(bp);
+		bnxt_ptp_reapply_pps(bp);
 		bnxt_dl_health_recovery_done(bp);
 		bnxt_dl_health_status_update(bp, true);
 		rtnl_unlock();
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
index 5b51c9e0464e..c389a2a65a90 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
@@ -155,10 +155,180 @@ static int bnxt_ptp_adjfreq(struct ptp_clock_info *ptp_info, s32 ppb)
 	return rc;
 }
 
-static int bnxt_ptp_enable(struct ptp_clock_info *ptp,
+static int bnxt_ptp_cfg_pin(struct bnxt *bp, u8 pin, u8 usage)
+{
+	struct hwrm_func_ptp_pin_cfg_input req = {0};
+	struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
+	u8 state = usage != BNXT_PPS_PIN_NONE;
+	u8 *pin_state, *pin_usg;
+	u32 enables;
+	int rc;
+
+	if (!TSIO_PIN_VALID(pin)) {
+		netdev_err(ptp->bp->dev, "1PPS: Invalid pin. Check pin-function configuration\n");
+		return -EOPNOTSUPP;
+	}
+
+	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_FUNC_PTP_PIN_CFG, -1, -1);
+	enables = (FUNC_PTP_PIN_CFG_REQ_ENABLES_PIN0_STATE |
+		   FUNC_PTP_PIN_CFG_REQ_ENABLES_PIN0_USAGE) << (pin * 2);
+	req.enables = cpu_to_le32(enables);
+
+	pin_state = &req.pin0_state;
+	pin_usg = &req.pin0_usage;
+
+	*(pin_state + (pin * 2)) = state;
+	*(pin_usg + (pin * 2)) = usage;
+
+	rc = hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
+	if (rc)
+		return rc;
+
+	ptp->pps_info.pins[pin].usage = usage;
+	ptp->pps_info.pins[pin].state = state;
+
+	return 0;
+}
+
+static int bnxt_ptp_cfg_event(struct bnxt *bp, u8 event)
+{
+	struct hwrm_func_ptp_cfg_input req = {0};
+
+	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_FUNC_PTP_CFG, -1, -1);
+	req.enables = cpu_to_le16(FUNC_PTP_CFG_REQ_ENABLES_PTP_PPS_EVENT);
+	req.ptp_pps_event = event;
+	return hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
+}
+
+void bnxt_ptp_reapply_pps(struct bnxt *bp)
+{
+	struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
+	struct bnxt_pps *pps;
+	u32 pin = 0;
+	int rc;
+
+	if (!ptp || !(bp->fw_cap & BNXT_FW_CAP_PTP_PPS) ||
+	    !(ptp->ptp_info.pin_config))
+		return;
+	pps = &ptp->pps_info;
+	for (pin = 0; pin < BNXT_MAX_TSIO_PINS; pin++) {
+		if (pps->pins[pin].state) {
+			rc = bnxt_ptp_cfg_pin(bp, pin, pps->pins[pin].usage);
+			if (!rc && pps->pins[pin].event)
+				rc = bnxt_ptp_cfg_event(bp,
+							pps->pins[pin].event);
+			if (rc)
+				netdev_err(bp->dev, "1PPS: Failed to configure pin%d\n",
+					   pin);
+		}
+	}
+}
+
+static int bnxt_get_target_cycles(struct bnxt_ptp_cfg *ptp, u64 target_ns,
+				  u64 *cycles_delta)
+{
+	u64 cycles_now;
+	u64 nsec_now, nsec_delta;
+	int rc;
+
+	spin_lock_bh(&ptp->ptp_lock);
+	rc = bnxt_refclk_read(ptp->bp, NULL, &cycles_now);
+	if (rc) {
+		spin_unlock_bh(&ptp->ptp_lock);
+		return rc;
+	}
+	nsec_now = timecounter_cyc2time(&ptp->tc, cycles_now);
+	spin_unlock_bh(&ptp->ptp_lock);
+
+	nsec_delta = target_ns - nsec_now;
+	*cycles_delta = div64_u64(nsec_delta << ptp->cc.shift, ptp->cc.mult);
+	return 0;
+}
+
+static int bnxt_ptp_perout_cfg(struct bnxt_ptp_cfg *ptp,
+			       struct ptp_clock_request *rq)
+{
+	struct hwrm_func_ptp_cfg_input req = {0};
+	struct bnxt *bp = ptp->bp;
+	struct timespec64 ts;
+	u64 target_ns, delta;
+	u16 enables;
+	int rc;
+
+	ts.tv_sec = rq->perout.start.sec;
+	ts.tv_nsec = rq->perout.start.nsec;
+	target_ns = timespec64_to_ns(&ts);
+
+	rc = bnxt_get_target_cycles(ptp, target_ns, &delta);
+	if (rc)
+		return rc;
+
+	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_FUNC_PTP_CFG, -1, -1);
+
+	enables = FUNC_PTP_CFG_REQ_ENABLES_PTP_FREQ_ADJ_EXT_PERIOD |
+		  FUNC_PTP_CFG_REQ_ENABLES_PTP_FREQ_ADJ_EXT_UP |
+		  FUNC_PTP_CFG_REQ_ENABLES_PTP_FREQ_ADJ_EXT_PHASE;
+	req.enables = cpu_to_le16(enables);
+	req.ptp_pps_event = 0;
+	req.ptp_freq_adj_dll_source = 0;
+	req.ptp_freq_adj_dll_phase = 0;
+	req.ptp_freq_adj_ext_period = cpu_to_le32(NSEC_PER_SEC);
+	req.ptp_freq_adj_ext_up = 0;
+	req.ptp_freq_adj_ext_phase_lower = cpu_to_le32(delta);
+
+	return hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
+}
+
+static int bnxt_ptp_enable(struct ptp_clock_info *ptp_info,
 			   struct ptp_clock_request *rq, int on)
 {
-	return -EOPNOTSUPP;
+	struct bnxt_ptp_cfg *ptp = container_of(ptp_info, struct bnxt_ptp_cfg,
+						ptp_info);
+	struct bnxt *bp = ptp->bp;
+	u8 pin_id;
+	int rc;
+
+	switch (rq->type) {
+	case PTP_CLK_REQ_EXTTS:
+		/* Configure an External PPS IN */
+		pin_id = ptp_find_pin(ptp->ptp_clock, PTP_PF_EXTTS,
+				      rq->extts.index);
+		if (!on)
+			break;
+		rc = bnxt_ptp_cfg_pin(bp, pin_id, BNXT_PPS_PIN_PPS_IN);
+		if (rc)
+			return rc;
+		rc = bnxt_ptp_cfg_event(bp, BNXT_PPS_EVENT_EXTERNAL);
+		if (!rc)
+			ptp->pps_info.pins[pin_id].event = BNXT_PPS_EVENT_EXTERNAL;
+		return rc;
+	case PTP_CLK_REQ_PEROUT:
+		/* Configure a Periodic PPS OUT */
+		pin_id = ptp_find_pin(ptp->ptp_clock, PTP_PF_PEROUT,
+				      rq->perout.index);
+		if (!on)
+			break;
+
+		rc = bnxt_ptp_cfg_pin(bp, pin_id, BNXT_PPS_PIN_PPS_OUT);
+		if (!rc)
+			rc = bnxt_ptp_perout_cfg(ptp, rq);
+
+		return rc;
+	case PTP_CLK_REQ_PPS:
+		/* Configure PHC PPS IN */
+		rc = bnxt_ptp_cfg_pin(bp, 0, BNXT_PPS_PIN_PPS_IN);
+		if (rc)
+			return rc;
+		rc = bnxt_ptp_cfg_event(bp, BNXT_PPS_EVENT_INTERNAL);
+		if (!rc)
+			ptp->pps_info.pins[0].event = BNXT_PPS_EVENT_INTERNAL;
+		return rc;
+	default:
+		netdev_err(ptp->bp->dev, "Unrecognized PIN function\n");
+		return -EOPNOTSUPP;
+	}
+
+	return bnxt_ptp_cfg_pin(bp, pin_id, BNXT_PPS_PIN_NONE);
 }
 
 static int bnxt_hwrm_ptp_cfg(struct bnxt *bp)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
index 619a6a1bf9fa..84f2b06ed79a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
@@ -22,9 +22,13 @@
 				 PORT_TS_QUERY_REQ_ENABLES_TS_REQ_TIMEOUT)
 
 struct pps_pin {
+	u8 event;
 	u8 usage;
+	u8 state;
 };
 
+#define TSIO_PIN_VALID(pin) ((pin) < (BNXT_MAX_TSIO_PINS))
+
 #define BNXT_PPS_PIN_DISABLE	0
 #define BNXT_PPS_PIN_ENABLE	1
 #define BNXT_PPS_PIN_NONE	0
@@ -93,6 +97,7 @@ do {						\
 #endif
 
 int bnxt_ptp_parse(struct sk_buff *skb, u16 *seq_id);
+void bnxt_ptp_reapply_pps(struct bnxt *bp);
 int bnxt_hwtstamp_set(struct net_device *dev, struct ifreq *ifr);
 int bnxt_hwtstamp_get(struct net_device *dev, struct ifreq *ifr);
 int bnxt_get_tx_ts_p5(struct bnxt *bp, struct sk_buff *skb);
-- 
2.18.1


--0000000000007b252705c832ec66
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIBS45pXNHvPXIPOPnmtNUxVf0T+lAxZJ
HZoCdE5gugWDMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDcy
ODE4MTIwNFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQAE7sT+UrnsqJf4sQMlEqBinD3LIZFBtrqnZdq/xRLnHU0BR4SL
GX0z3Z3SSYoJ7AtKVbe8ue+5wsDdlaSV29hx/npgnWVKdDT7am/2qb7MoTVSUHlZPOiJ4UmITsnX
OUSOOiy2FpNlnMrpbrn30w/uHVEJrVJvLzI7C67g1NpvcOzx0bEHkNGKXjCOldwn4WBpgj4+q+mM
38Hhhr5ibMifdrD5h4X3EqkzNg/D0bMbWLfz9vXsd3AJ/uqwsj9U6m6jMT4kZwkQ2MVZULjK6V2D
xlVHkp/Xzkutz2qBPGmh5o/Wnglb2FHksHzLDKsAfLssVVNmDJHmFf4HlFD9Tvx6
--0000000000007b252705c832ec66--
