Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB6249C2B6
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 05:40:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232381AbiAZEkj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 23:40:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231732AbiAZEkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 23:40:37 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11B4FC06161C
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 20:40:37 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id 128so21668552pfe.12
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 20:40:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XGZB2XFcIfu0nWC8N+TkPx5yCoEwOxvPaEYwIl9ycjs=;
        b=DgoYaZqcpPwg04OhNio5Q7btqiIHEZPkqSMVG+ZnD7wAKQheQ4cma6778VDrcpc8Pg
         jU37GTabuH11HwKZO/+GlNSYQ2/TsWnp7p3hlGXUO9iJDjsdd6tQgFDXG/R2kpuohZhv
         9+76vW9Sz+otwIFh2nQoykjs6uaXsQ6WNpdew=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=XGZB2XFcIfu0nWC8N+TkPx5yCoEwOxvPaEYwIl9ycjs=;
        b=yaQ5uISTJqwU6Es9FQkIXMJ7z0IGjqvhVUm0myGgXDw0DGAp6Y3wwv3f3MTebxltEI
         tiUgGoPN9TeQky6kUTeqz3bfMx1qWtX7QX76uUpclzWAC0k00nSk+wpjvcRAscdpohjc
         LmT5dZdPKorFkGR8sHI3fzZXhAUZyFqkdtXvYclxtQ6r8BSMRnIjaTcz9bG65K57nl3L
         6/1vPNlTwgll1MZufMWFee30fPRiNtr1Tj6eE9PXh+X5z596K5NvL4CVI39NWFEPgald
         s4ci8DZjz2s0MW0Mo6r0yuNHwZlabbie1t7tHQh9/yE9zyyY611GDcAVo/6ymL6CALnY
         2EyA==
X-Gm-Message-State: AOAM533b9eQRVkDHnb8+vDnE7MLgF7EStat4OcO+LcQ5VyTG8Oe2+1Aq
        X829h9bK56yVzo3eFge+BFuTvg==
X-Google-Smtp-Source: ABdhPJxSo98aMfCnEw4GCHG9si+9CbuxzPICXtm2Io2nNq6zn8yh4MNcebRRqijaATxA90dYNz4kTQ==
X-Received: by 2002:a63:6902:: with SMTP id e2mr17718533pgc.196.1643172036291;
        Tue, 25 Jan 2022 20:40:36 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s12sm559957pfk.65.2022.01.25.20.40.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jan 2022 20:40:35 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com,
        pavan.chebbi@broadcom.com,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH net-next 3/5] bnxt_en: Add driver support to use Real Time Counter for PTP
Date:   Tue, 25 Jan 2022 23:40:11 -0500
Message-Id: <1643172013-31729-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1643172013-31729-1-git-send-email-michael.chan@broadcom.com>
References: <1643172013-31729-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000008f82dc05d674cdcb"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000008f82dc05d674cdcb

From: Pavan Chebbi <pavan.chebbi@broadcom.com>

Add support for RTC mode if it is supported by firmware.  In RTC
mode, the PHC is set to the 64-bit clock.  Because the legacy interface
is 48-bit, the driver still has to keep track of the upper 16 bits and
handle the rollover.

Cc: Richard Cochran <richardcochran@gmail.com>
Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  7 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 73 ++++++++++++++++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h |  4 +-
 4 files changed, 79 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 4f94136a011a..514798a4f15b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -7414,6 +7414,7 @@ static int __bnxt_hwrm_ptp_qcfg(struct bnxt *bp)
 	struct hwrm_port_mac_ptp_qcfg_output *resp;
 	struct hwrm_port_mac_ptp_qcfg_input *req;
 	struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
+	bool phc_cfg;
 	u8 flags;
 	int rc;
 
@@ -7456,7 +7457,8 @@ static int __bnxt_hwrm_ptp_qcfg(struct bnxt *bp)
 		rc = -ENODEV;
 		goto exit;
 	}
-	rc = bnxt_ptp_init(bp);
+	phc_cfg = (flags & PORT_MAC_PTP_QCFG_RESP_FLAGS_RTC_CONFIGURED) != 0;
+	rc = bnxt_ptp_init(bp, phc_cfg);
 	if (rc)
 		netdev_warn(bp->dev, "PTP initialization failed.\n");
 exit:
@@ -7514,6 +7516,8 @@ static int __bnxt_hwrm_func_qcaps(struct bnxt *bp)
 		bp->fw_cap |= BNXT_FW_CAP_EXT_HW_STATS_SUPPORTED;
 	if (BNXT_PF(bp) && (flags_ext & FUNC_QCAPS_RESP_FLAGS_EXT_PTP_PPS_SUPPORTED))
 		bp->fw_cap |= BNXT_FW_CAP_PTP_PPS;
+	if (flags_ext & FUNC_QCAPS_RESP_FLAGS_EXT_PTP_64BIT_RTC_SUPPORTED)
+		bp->fw_cap |= BNXT_FW_CAP_PTP_RTC;
 	if (BNXT_PF(bp) && (flags_ext & FUNC_QCAPS_RESP_FLAGS_EXT_HOT_RESET_IF_SUPPORT))
 		bp->fw_cap |= BNXT_FW_CAP_HOT_RESET_IF;
 	if (BNXT_PF(bp) && (flags_ext & FUNC_QCAPS_RESP_FLAGS_EXT_FW_LIVEPATCH_SUPPORTED))
@@ -10288,6 +10292,7 @@ static int __bnxt_open_nic(struct bnxt *bp, bool irq_re_init, bool link_re_init)
 	/* VF-reps may need to be re-opened after the PF is re-opened */
 	if (BNXT_PF(bp))
 		bnxt_vf_reps_open(bp);
+	bnxt_ptp_init_rtc(bp, true);
 	return 0;
 
 open_err_irq:
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 440dfeb4948b..4b023e35c765 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1957,6 +1957,7 @@ struct bnxt {
 	#define BNXT_FW_CAP_EXT_STATS_SUPPORTED		0x00040000
 	#define BNXT_FW_CAP_ERR_RECOVER_RELOAD		0x00100000
 	#define BNXT_FW_CAP_HOT_RESET			0x00200000
+	#define BNXT_FW_CAP_PTP_RTC			0x00400000
 	#define BNXT_FW_CAP_VLAN_RX_STRIP		0x01000000
 	#define BNXT_FW_CAP_VLAN_TX_INSERT		0x02000000
 	#define BNXT_FW_CAP_EXT_HW_STATS_SUPPORTED	0x04000000
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
index 921aa7f75c9a..066e5a9bb29e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
@@ -19,6 +19,20 @@
 #include "bnxt_hwrm.h"
 #include "bnxt_ptp.h"
 
+static int bnxt_ptp_cfg_settime(struct bnxt *bp, u64 time)
+{
+	struct hwrm_func_ptp_cfg_input *req;
+	int rc;
+
+	rc = hwrm_req_init(bp, req, HWRM_FUNC_PTP_CFG);
+	if (rc)
+		return rc;
+
+	req->enables = cpu_to_le16(FUNC_PTP_CFG_REQ_ENABLES_PTP_SET_TIME);
+	req->ptp_set_time = cpu_to_le64(time);
+	return hwrm_req_send(bp, req);
+}
+
 int bnxt_ptp_parse(struct sk_buff *skb, u16 *seq_id, u16 *hdr_off)
 {
 	unsigned int ptp_class;
@@ -48,6 +62,9 @@ static int bnxt_ptp_settime(struct ptp_clock_info *ptp_info,
 						ptp_info);
 	u64 ns = timespec64_to_ns(ts);
 
+	if (ptp->bp->fw_cap & BNXT_FW_CAP_PTP_RTC)
+		return bnxt_ptp_cfg_settime(ptp->bp, ns);
+
 	spin_lock_bh(&ptp->ptp_lock);
 	timecounter_init(&ptp->tc, &ptp->cc, ns);
 	spin_unlock_bh(&ptp->ptp_lock);
@@ -730,6 +747,41 @@ static void bnxt_ptp_timecounter_init(struct bnxt *bp, bool init_tc)
 		timecounter_init(&ptp->tc, &ptp->cc, ktime_to_ns(ktime_get_real()));
 }
 
+/* Caller holds ptp_lock */
+void bnxt_ptp_rtc_timecounter_init(struct bnxt_ptp_cfg *ptp, u64 ns)
+{
+	timecounter_init(&ptp->tc, &ptp->cc, ns);
+	/* For RTC, cycle_last must be in sync with the timecounter value. */
+	ptp->tc.cycle_last = ns & ptp->cc.mask;
+}
+
+int bnxt_ptp_init_rtc(struct bnxt *bp, bool phc_cfg)
+{
+	struct timespec64 tsp;
+	u64 ns;
+	int rc;
+
+	if (!bp->ptp_cfg || !(bp->fw_cap & BNXT_FW_CAP_PTP_RTC))
+		return -ENODEV;
+
+	if (!phc_cfg) {
+		ktime_get_real_ts64(&tsp);
+		ns = timespec64_to_ns(&tsp);
+		rc = bnxt_ptp_cfg_settime(bp, ns);
+		if (rc)
+			return rc;
+	} else {
+		rc = bnxt_hwrm_port_ts_query(bp, PORT_TS_QUERY_REQ_FLAGS_CURRENT_TIME, &ns);
+		if (rc)
+			return rc;
+	}
+	spin_lock_bh(&bp->ptp_cfg->ptp_lock);
+	bnxt_ptp_rtc_timecounter_init(bp->ptp_cfg, ns);
+	spin_unlock_bh(&bp->ptp_cfg->ptp_lock);
+
+	return 0;
+}
+
 static void bnxt_ptp_free(struct bnxt *bp)
 {
 	struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
@@ -742,7 +794,7 @@ static void bnxt_ptp_free(struct bnxt *bp)
 	}
 }
 
-int bnxt_ptp_init(struct bnxt *bp)
+int bnxt_ptp_init(struct bnxt *bp, bool phc_cfg)
 {
 	struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
 	int rc;
@@ -754,6 +806,13 @@ int bnxt_ptp_init(struct bnxt *bp)
 	if (rc)
 		return rc;
 
+	if (bp->fw_cap & BNXT_FW_CAP_PTP_RTC) {
+		bnxt_ptp_timecounter_init(bp, false);
+		rc = bnxt_ptp_init_rtc(bp, phc_cfg);
+		if (rc)
+			goto out;
+	}
+
 	if (ptp->ptp_clock && bnxt_pps_config_ok(bp))
 		return 0;
 
@@ -762,7 +821,8 @@ int bnxt_ptp_init(struct bnxt *bp)
 	atomic_set(&ptp->tx_avail, BNXT_MAX_TX_TS);
 	spin_lock_init(&ptp->ptp_lock);
 
-	bnxt_ptp_timecounter_init(bp, true);
+	if (!(bp->fw_cap & BNXT_FW_CAP_PTP_RTC))
+		bnxt_ptp_timecounter_init(bp, true);
 
 	ptp->ptp_info = bnxt_ptp_caps;
 	if ((bp->fw_cap & BNXT_FW_CAP_PTP_PPS)) {
@@ -774,8 +834,8 @@ int bnxt_ptp_init(struct bnxt *bp)
 		int err = PTR_ERR(ptp->ptp_clock);
 
 		ptp->ptp_clock = NULL;
-		bnxt_unmap_ptp_regs(bp);
-		return err;
+		rc = err;
+		goto out;
 	}
 	if (bp->flags & BNXT_FLAG_CHIP_P5) {
 		spin_lock_bh(&ptp->ptp_lock);
@@ -785,6 +845,11 @@ int bnxt_ptp_init(struct bnxt *bp)
 		ptp_schedule_worker(ptp->ptp_clock, 0);
 	}
 	return 0;
+
+out:
+	bnxt_ptp_free(bp);
+	bnxt_unmap_ptp_regs(bp);
+	return rc;
 }
 
 void bnxt_ptp_clear(struct bnxt *bp)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
index 7c528e1f8713..ca850c5f0607 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
@@ -137,6 +137,8 @@ int bnxt_hwtstamp_set(struct net_device *dev, struct ifreq *ifr);
 int bnxt_hwtstamp_get(struct net_device *dev, struct ifreq *ifr);
 int bnxt_get_tx_ts_p5(struct bnxt *bp, struct sk_buff *skb);
 int bnxt_get_rx_ts_p5(struct bnxt *bp, u64 *ts, u32 pkt_ts);
-int bnxt_ptp_init(struct bnxt *bp);
+void bnxt_ptp_rtc_timecounter_init(struct bnxt_ptp_cfg *ptp, u64 ns);
+int bnxt_ptp_init_rtc(struct bnxt *bp, bool phc_cfg);
+int bnxt_ptp_init(struct bnxt *bp, bool phc_cfg);
 void bnxt_ptp_clear(struct bnxt *bp);
 #endif
-- 
2.18.1


--0000000000008f82dc05d674cdcb
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIAk29QmVbk0dZ6RKN6n4nHB+4WG88Yva
T+o9n6yTv7i7MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDEy
NjA0NDAzNlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQAYL/kVb2vw9FBwU1CblMEF5dYlAzn6yD60BWIEPTEznDBhJcaN
GoZlleopAVW/w1MsQjNvs1vy1GhoE944HFnRPMlrpAv+MItX97yhPlbQMe1cuJJel8MuPjrPl2ea
QpWr1zhAgNZDvRuoyX28MSGf1aFCRim39DIg9074jlTDIFqQ8BDo3rYlITWll7pX8/RtFrXxv6/Q
dsZ26N1+qk5WBF+iZRZT3Ndzgwu+DkJvJ5BGooHrhKa5QQMNxKVMrbyVqJ4JYn6OThU/R95B+1C5
s49G1HQX/LRlV7nhJMBPY8G8LGRA41dLWH2NRY3VCTIRqQuM3qCAjVDD3U2zswrz
--0000000000008f82dc05d674cdcb--
