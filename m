Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A586C401123
	for <lists+netdev@lfdr.de>; Sun,  5 Sep 2021 20:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238133AbhIESMn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Sep 2021 14:12:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238124AbhIESMm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Sep 2021 14:12:42 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4854EC061575
        for <netdev@vger.kernel.org>; Sun,  5 Sep 2021 11:11:39 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id f129so4420119pgc.1
        for <netdev@vger.kernel.org>; Sun, 05 Sep 2021 11:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=OPUF51LUrNgqFz089ayyIgiIPyx3bxOlE6TuCkJQbtc=;
        b=QZ8nW7XRowuxxeoiKinfslzSSbhxKf3/ooCykpizH+IxAwHCavShXEMFC5rRgqdVPM
         MpYiqZ9SXLnKvnWWbuxuDlbKnhsQZESVk7xuk9WRg4stByY5vaCK8HPGzzT58ZVAuDod
         hERP3gCd9yLu/1rmL4wvwg9gGnVq0Qw8S3r6o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=OPUF51LUrNgqFz089ayyIgiIPyx3bxOlE6TuCkJQbtc=;
        b=DcrMik29cltMTMCENAhNRRrNpUSl0LeTzpUXp86OMBG9BEDGhz1M6du5WhGIuXkbHB
         569Q1n8S9jXEw4nfw13YXx4s67hnKpRIVV6eIWcBAmJhdu3A0zYmDNVyoZzr5iboUtfH
         sd2xKBpVJPAsdY4JfN/nXuqy7Q17GcHIPsrTblkqkrYNKqGv4OtXVznna79WfzyH9Pom
         lnkCuEqoS4vflJscr9MhxCUJrjpYB1aU0Z+CtC0gzScIcQhm3Yhi+erPatadpCwGum+s
         D/BZe02xfi7plr8aiwD+eEPhksxBSGjidq82zC6DgwzwvZz03NrleE1fY8wokihCiLZS
         tsOg==
X-Gm-Message-State: AOAM531X9HXUGXs5csq1HZXO6VNOMbsbCz5mcd7HBca5pCe8bnR0WeDV
        VdzSrLj1pLh/XbTb3TEnhG1edFeB2ybBBA==
X-Google-Smtp-Source: ABdhPJysbVtzYwFTD4bWeGzARZCmZXtDhv1MZO4Ljkf2Ar0vheyZwy5IGipuwpEU5suVynVB7lR0HA==
X-Received: by 2002:a63:78c5:: with SMTP id t188mr8508720pgc.386.1630865498553;
        Sun, 05 Sep 2021 11:11:38 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d13sm5058115pfn.114.2021.09.05.11.11.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 Sep 2021 11:11:38 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edwin.peer@broadcom.com,
        gospo@broadcom.com
Subject: [PATCH net 5/5] bnxt_en: Fix possible unintended driver initiated error recovery
Date:   Sun,  5 Sep 2021 14:10:59 -0400
Message-Id: <1630865459-19146-6-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1630865459-19146-1-git-send-email-michael.chan@broadcom.com>
References: <1630865459-19146-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000bf9cc605cb4376bd"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000bf9cc605cb4376bd

If error recovery is already enabled, bnxt_timer() will periodically
check the heartbeat register and the reset counter.  If we get an
error recovery async. notification from the firmware (e.g. change in
primary/secondary role), we will immediately read and update the
heartbeat register and the reset counter.  If the timer for the next
health check expires soon after this, we may read the heartbeat register
again in quick succession and find that it hasn't changed.  This will
trigger error recovery unintentionally.

The likelihood is small because we also reset fw_health->tmr_counter
which will reset the interval for the next health check.  But the
update is not protected and bnxt_timer() can miss the update and
perform the health check without waiting for the full interval.

Fix it by only reading the heartbeat register and reset counter in
bnxt_async_event_process() if error recovery is trasitioning to the
enabled state.  Also add proper memory barriers so that when enabling
for the first time, bnxt_timer() will see the tmr_counter interval and
perform the health check after the full interval has elapsed.

Fixes: 7e914027f757 ("bnxt_en: Enable health monitoring.")
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 25 ++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 40a390652d8d..9b86516e59a1 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -2202,25 +2202,34 @@ static int bnxt_async_event_process(struct bnxt *bp,
 		if (!fw_health)
 			goto async_event_process_exit;
 
-		fw_health->enabled = EVENT_DATA1_RECOVERY_ENABLED(data1);
-		fw_health->master = EVENT_DATA1_RECOVERY_MASTER_FUNC(data1);
-		if (!fw_health->enabled) {
+		if (!EVENT_DATA1_RECOVERY_ENABLED(data1)) {
+			fw_health->enabled = false;
 			netif_info(bp, drv, bp->dev,
 				   "Error recovery info: error recovery[0]\n");
 			break;
 		}
+		fw_health->master = EVENT_DATA1_RECOVERY_MASTER_FUNC(data1);
 		fw_health->tmr_multiplier =
 			DIV_ROUND_UP(fw_health->polling_dsecs * HZ,
 				     bp->current_interval * 10);
 		fw_health->tmr_counter = fw_health->tmr_multiplier;
-		fw_health->last_fw_heartbeat =
-			bnxt_fw_health_readl(bp, BNXT_FW_HEARTBEAT_REG);
-		fw_health->last_fw_reset_cnt =
-			bnxt_fw_health_readl(bp, BNXT_FW_RESET_CNT_REG);
+		if (!fw_health->enabled) {
+			fw_health->last_fw_heartbeat =
+				bnxt_fw_health_readl(bp, BNXT_FW_HEARTBEAT_REG);
+			fw_health->last_fw_reset_cnt =
+				bnxt_fw_health_readl(bp, BNXT_FW_RESET_CNT_REG);
+		}
 		netif_info(bp, drv, bp->dev,
 			   "Error recovery info: error recovery[1], master[%d], reset count[%u], health status: 0x%x\n",
 			   fw_health->master, fw_health->last_fw_reset_cnt,
 			   bnxt_fw_health_readl(bp, BNXT_FW_HEALTH_REG));
+		if (!fw_health->enabled) {
+			/* Make sure tmr_counter is set and visible to
+			 * bnxt_health_check() before setting enabled to true.
+			 */
+			smp_wmb();
+			fw_health->enabled = true;
+		}
 		goto async_event_process_exit;
 	}
 	case ASYNC_EVENT_CMPL_EVENT_ID_DEBUG_NOTIFICATION:
@@ -11258,6 +11267,8 @@ static void bnxt_fw_health_check(struct bnxt *bp)
 	if (!fw_health->enabled || test_bit(BNXT_STATE_IN_FW_RESET, &bp->state))
 		return;
 
+	/* Make sure it is enabled before checking the tmr_counter. */
+	smp_rmb();
 	if (fw_health->tmr_counter) {
 		fw_health->tmr_counter--;
 		return;
-- 
2.18.1


--000000000000bf9cc605cb4376bd
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIAyjLXpjrT+htsq2OJKW6t4XEefz79NE
uNhrWLb780W6MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDkw
NTE4MTEzOVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQDLphw2uLymxONJyDD/4sVMQgTn6CUH9Zw2AL5eTpRi4EscS4Sl
LrkKXor+WuDs3/S+o5nFlebznSsPW+vbOKEfutghSjREB0sloVNyRT+AiUmjTzqqbholMGxDFX8+
mTYNgKj1WT5sms1HRlwk5Jn+ykoPxDTLZ8p/KU3bkkHDJ+1+EqcW8GSYsH0Kz9DXHsRdag3xLSIO
Z7gW70qpumAdwwVpo6+Y805gQpiOftLJCFyuWiZqGaSS9N86ZHMaRDmyCnZdr2VaeqdRD4a8lZQZ
4KZ8tZIaZWkiDCycYWpLi7kInsREJcXYqc2KQV2MoIDQUVpif0RbNLp6auA+d7p2
--000000000000bf9cc605cb4376bd--
