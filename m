Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 179A749C2B8
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 05:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233238AbiAZEkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 23:40:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231732AbiAZEkj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 23:40:39 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFD5EC061744
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 20:40:39 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id u11so21341751plh.13
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 20:40:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=455jHzpZKl+i99QBAMM/nIa+UODXenNPvKvUf3S1ZoA=;
        b=QqdY3UdV66zX/5R0GpMBiT2ySITYNL+ZY/NOM6y5Vd53cdQYZ486VEoHJAdYIR9p11
         WAybCx6F3OySJ6nA1p/yW/5xpSpGlcNWFxQMKl9c17MNbR25s7HDdXVPDOxvMWhka14l
         6wBFkyvSorPYfuLDgCwPV/Tq/vAsCjR+JGma8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=455jHzpZKl+i99QBAMM/nIa+UODXenNPvKvUf3S1ZoA=;
        b=73IR/c4KwDFZ9rphRUb3v37YsicsEEZEfpEcpf0cWI8X/nzKo8pQG3+dIL/Di4+AIk
         DttLo79JA/umqhyWguCdaQTnTVk9RAtYpSI4A/WO8Xir0gHkfJFGgINiEOPjX/l0dp9u
         3TWZnoEnVKmSKOVXafRZMVj3S41RIhS/87s/PABy/9l/7LVcMtK75TPmYmyNaSl0zwhO
         pMuembyHSXVJ+dR2DlxN9rXOr3Sb+5tDGKnwjcgySsgDFNTw/vztAgumgJFIjDcJQBOB
         jmzzCtxcIZv5nWhSpLeU5BXg0+Y+3moHRYmyN1ktzIv1iihsBAWV0IAe04fEjAmlIAY+
         9ZmQ==
X-Gm-Message-State: AOAM530hRXAwpTbyfOJWzXjMXmvmyxaTxevtkQy52gfBFeBxk3L+fInp
        8qAASTN+N+L7jAY86ABBdY2Sng==
X-Google-Smtp-Source: ABdhPJxcme0n0VkCVTMosb9vQMtoneqP0tbpT7CsRsETfO3WxjssrczBUXPq2eKA8uFuOlPOqlwN1Q==
X-Received: by 2002:a17:90a:14a4:: with SMTP id k33mr6907376pja.21.1643172038987;
        Tue, 25 Jan 2022 20:40:38 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s12sm559957pfk.65.2022.01.25.20.40.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jan 2022 20:40:38 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com,
        pavan.chebbi@broadcom.com,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH net-next 5/5] bnxt_en: Handle async event when the PHC is updated in RTC mode
Date:   Tue, 25 Jan 2022 23:40:13 -0500
Message-Id: <1643172013-31729-6-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1643172013-31729-1-git-send-email-michael.chan@broadcom.com>
References: <1643172013-31729-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000b7f0fc05d674cd36"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000b7f0fc05d674cd36

From: Pavan Chebbi <pavan.chebbi@broadcom.com>

In Multi-host environment, when the PHC is updated by one host,
an async message from firmware will be sent to other hosts.
Re-initialize the timecounter when the driver receives this
async message.

Cc: Richard Cochran <richardcochran@gmail.com>
Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 29 +++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 514798a4f15b..c313221348c5 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -233,6 +233,7 @@ static const u16 bnxt_async_events_arr[] = {
 	ASYNC_EVENT_CMPL_EVENT_ID_ECHO_REQUEST,
 	ASYNC_EVENT_CMPL_EVENT_ID_PPS_TIMESTAMP,
 	ASYNC_EVENT_CMPL_EVENT_ID_ERROR_REPORT,
+	ASYNC_EVENT_CMPL_EVENT_ID_PHC_UPDATE,
 };
 
 static struct workqueue_struct *bnxt_pf_wq;
@@ -2079,6 +2080,16 @@ static void bnxt_event_error_report(struct bnxt *bp, u32 data1, u32 data2)
 	(BNXT_EVENT_RING_TYPE(data2) ==	\
 	 ASYNC_EVENT_CMPL_RING_MONITOR_MSG_EVENT_DATA2_DISABLE_RING_TYPE_RX)
 
+#define BNXT_EVENT_PHC_EVENT_TYPE(data1)	\
+	(((data1) & ASYNC_EVENT_CMPL_PHC_UPDATE_EVENT_DATA1_FLAGS_MASK) >>\
+	 ASYNC_EVENT_CMPL_PHC_UPDATE_EVENT_DATA1_FLAGS_SFT)
+
+#define BNXT_EVENT_PHC_RTC_UPDATE(data1)	\
+	(((data1) & ASYNC_EVENT_CMPL_PHC_UPDATE_EVENT_DATA1_PHC_TIME_MSB_MASK) >>\
+	 ASYNC_EVENT_CMPL_PHC_UPDATE_EVENT_DATA1_PHC_TIME_MSB_SFT)
+
+#define BNXT_PHC_BITS	48
+
 static int bnxt_async_event_process(struct bnxt *bp,
 				    struct hwrm_async_event_cmpl *cmpl)
 {
@@ -2258,6 +2269,24 @@ static int bnxt_async_event_process(struct bnxt *bp,
 		bnxt_event_error_report(bp, data1, data2);
 		goto async_event_process_exit;
 	}
+	case ASYNC_EVENT_CMPL_EVENT_ID_PHC_UPDATE: {
+		switch (BNXT_EVENT_PHC_EVENT_TYPE(data1)) {
+		case ASYNC_EVENT_CMPL_PHC_UPDATE_EVENT_DATA1_FLAGS_PHC_RTC_UPDATE:
+			if (bp->fw_cap & BNXT_FW_CAP_PTP_RTC) {
+				struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
+				u64 ns;
+
+				spin_lock_bh(&ptp->ptp_lock);
+				bnxt_ptp_update_current_time(bp);
+				ns = (((u64)BNXT_EVENT_PHC_RTC_UPDATE(data1) <<
+				       BNXT_PHC_BITS) | ptp->current_time);
+				bnxt_ptp_rtc_timecounter_init(ptp, ns);
+				spin_unlock_bh(&ptp->ptp_lock);
+			}
+			break;
+		}
+		goto async_event_process_exit;
+	}
 	case ASYNC_EVENT_CMPL_EVENT_ID_DEFERRED_RESPONSE: {
 		u16 seq_id = le32_to_cpu(cmpl->event_data2) & 0xffff;
 
-- 
2.18.1


--000000000000b7f0fc05d674cd36
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIMF1tnxxc+pRSDqqIBnp+yJP8vIsRyUn
bYpFaLh16UMWMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDEy
NjA0NDAzOVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQBBunDsgwCoeUsakE9qZHbuKYGCbTi/OURDe9BEe9N0RaCqlSAW
KElFGTVwXzzY4V7f2g+N5YrYa9Aa9DsxD1od6WCkt2IWP12j/P7NHZso9CEt9UNSrKvtpPHTiNuX
PEPpPB10VqYx+VeBP8+AnWhmZGItcALaeYDFJx6/us1slUqQ3zytBPLttmSZgrm8WLYx+mEvgaNh
hTRi31UykMUqpdU4AC6x5NZOno0npnFSZPjn6Z2QApMJ5cBfTqEoIH4ihh2WHf7muO+/jrq0v3OH
Pxh9MKLYnXaUIr4l4QosipdMpHaFt0Amcnx1a+64FmnOr/UwoMYEIQ3LZ3tdMCag
--000000000000b7f0fc05d674cd36--
