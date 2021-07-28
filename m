Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34F623D950E
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 20:12:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbhG1SMH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 14:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230290AbhG1SME (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 14:12:04 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B50FC061757
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 11:12:02 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id b6so6388497pji.4
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 11:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=CLV4reKKkB91DCSDYBCKO7YKwyZ7DplJsDD4+t2aFKs=;
        b=T/GLN0EoVoYmnN45zNMlmTXjkv+cBHq7j/vpeTH01TDW/3mPlNFFF+/C9SPQdKjIRB
         LJdL5P73/G8zJQqmlqICPzyvJvNt6jus89c3/T1pVgdbW7CHw4hONahsM5Le1mVI6wZo
         kHpeozY4a2EUI53I5sKilj9t7OHBc7r0ZAK9Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=CLV4reKKkB91DCSDYBCKO7YKwyZ7DplJsDD4+t2aFKs=;
        b=lHkDdPj/AGeq6SSGrVOCVlXuPPJkb8ht8DzlInHSfbipTKMnPFl2ngCzubqvZ7hcpC
         Qp6dt/OMXdrFnj5JF2v8svQJ386PHU9sMT2CCDbQ95OCKVgQkK6qYcVqyLUILmCHSb8/
         /hTjxhPqyRmQ8RpfPhPcCHsh7fcLJFqxp86iyJ8oFGMBueN3Tx4C1XmhYC/whxkQ5j0V
         QLX6dKyZLbVlqYKH88DtrZPdNwmRQTWgzl80nLUYUriYSKexwe2Dlg6WrlIguppeO8Ps
         2Aci2W+bImSSJeD5bVDcAgwjgMUSTwNwPXA8aXLG+beDcyycyyjxW5DXJ8CK1mLZytvq
         VyHQ==
X-Gm-Message-State: AOAM532LfZJcVTDv/pxa5c9vSpD9NjqMNpaTmhe/AiEVhORkYYgCoMUh
        403/j5CzUypQJu3+lAVKR1+4aQ==
X-Google-Smtp-Source: ABdhPJzyAoU52Cj9scnDhbXJAFaJAA3YsdfKza0htQqeF9kRhtkZJY4rtHbBeJ+ApM0exyXRGtjeqw==
X-Received: by 2002:a17:902:d4cc:b029:12b:9b9f:c38d with SMTP id o12-20020a170902d4ccb029012b9b9fc38dmr802268plg.41.1627495921850;
        Wed, 28 Jul 2021 11:12:01 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a16sm678901pfo.66.2021.07.28.11.12.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Jul 2021 11:12:01 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com,
        richardcochran@gmail.com, pavan.chebbi@broadcom.com,
        edwin.peer@broadcom.com
Subject: [PATCH net-next 2/6] bnxt_en: Do not read the PTP PHC during chip reset
Date:   Wed, 28 Jul 2021 14:11:41 -0400
Message-Id: <1627495905-17396-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1627495905-17396-1-git-send-email-michael.chan@broadcom.com>
References: <1627495905-17396-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000053e8a405c832ecfc"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000053e8a405c832ecfc

During error recovery or hot firmware upgrade, the chip may be under
reset and the PHC register read cycles may cause completion timeouts.
Check that the chip is not under reset condition before proceeding
to read the PHC by checking the flag BNXT_STATE_IN_FW_RESET.  We also
need to take the ptp_lock before we set this flag to prevent race
conditions.

We need this logic because the PHC now will stay registered after
bnxt_close().

Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 18 ++++++++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 28 +++++++++++++------
 2 files changed, 35 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 7cb2b79c154c..c9c158fb86c5 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11397,13 +11397,20 @@ static bool is_bnxt_fw_ok(struct bnxt *bp)
 static void bnxt_force_fw_reset(struct bnxt *bp)
 {
 	struct bnxt_fw_health *fw_health = bp->fw_health;
+	struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
 	u32 wait_dsecs;
 
 	if (!test_bit(BNXT_STATE_OPEN, &bp->state) ||
 	    test_bit(BNXT_STATE_IN_FW_RESET, &bp->state))
 		return;
 
-	set_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
+	if (ptp) {
+		spin_lock_bh(&ptp->ptp_lock);
+		set_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
+		spin_unlock_bh(&ptp->ptp_lock);
+	} else {
+		set_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
+	}
 	bnxt_fw_reset_close(bp);
 	wait_dsecs = fw_health->master_func_wait_dsecs;
 	if (fw_health->master) {
@@ -11459,9 +11466,16 @@ void bnxt_fw_reset(struct bnxt *bp)
 	bnxt_rtnl_lock_sp(bp);
 	if (test_bit(BNXT_STATE_OPEN, &bp->state) &&
 	    !test_bit(BNXT_STATE_IN_FW_RESET, &bp->state)) {
+		struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
 		int n = 0, tmo;
 
-		set_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
+		if (ptp) {
+			spin_lock_bh(&ptp->ptp_lock);
+			set_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
+			spin_unlock_bh(&ptp->ptp_lock);
+		} else {
+			set_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
+		}
 		if (bp->pf.active_vfs &&
 		    !test_bit(BNXT_STATE_FW_FATAL_COND, &bp->state))
 			n = bnxt_get_registered_vfs(bp);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
index d2bd4fc1091b..49531e7e3c6d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
@@ -55,16 +55,19 @@ static int bnxt_ptp_settime(struct ptp_clock_info *ptp_info,
 }
 
 /* Caller holds ptp_lock */
-static u64 bnxt_refclk_read(struct bnxt *bp, struct ptp_system_timestamp *sts)
+static int bnxt_refclk_read(struct bnxt *bp, struct ptp_system_timestamp *sts,
+			    u64 *ns)
 {
 	struct bnxt_ptp_cfg *ptp = bp->ptp_cfg;
-	u64 ns;
+
+	if (test_bit(BNXT_STATE_IN_FW_RESET, &bp->state))
+		return -EIO;
 
 	ptp_read_system_prets(sts);
-	ns = readl(bp->bar0 + ptp->refclk_mapped_regs[0]);
+	*ns = readl(bp->bar0 + ptp->refclk_mapped_regs[0]);
 	ptp_read_system_postts(sts);
-	ns |= (u64)readl(bp->bar0 + ptp->refclk_mapped_regs[1]) << 32;
-	return ns;
+	*ns |= (u64)readl(bp->bar0 + ptp->refclk_mapped_regs[1]) << 32;
+	return 0;
 }
 
 static void bnxt_ptp_get_current_time(struct bnxt *bp)
@@ -75,7 +78,7 @@ static void bnxt_ptp_get_current_time(struct bnxt *bp)
 		return;
 	spin_lock_bh(&ptp->ptp_lock);
 	WRITE_ONCE(ptp->old_time, ptp->current_time);
-	ptp->current_time = bnxt_refclk_read(bp, NULL);
+	bnxt_refclk_read(bp, NULL, &ptp->current_time);
 	spin_unlock_bh(&ptp->ptp_lock);
 }
 
@@ -108,9 +111,14 @@ static int bnxt_ptp_gettimex(struct ptp_clock_info *ptp_info,
 	struct bnxt_ptp_cfg *ptp = container_of(ptp_info, struct bnxt_ptp_cfg,
 						ptp_info);
 	u64 ns, cycles;
+	int rc;
 
 	spin_lock_bh(&ptp->ptp_lock);
-	cycles = bnxt_refclk_read(ptp->bp, sts);
+	rc = bnxt_refclk_read(ptp->bp, sts, &cycles);
+	if (rc) {
+		spin_unlock_bh(&ptp->ptp_lock);
+		return rc;
+	}
 	ns = timecounter_cyc2time(&ptp->tc, cycles);
 	spin_unlock_bh(&ptp->ptp_lock);
 	*ts = ns_to_timespec64(ns);
@@ -309,8 +317,10 @@ static void bnxt_unmap_ptp_regs(struct bnxt *bp)
 static u64 bnxt_cc_read(const struct cyclecounter *cc)
 {
 	struct bnxt_ptp_cfg *ptp = container_of(cc, struct bnxt_ptp_cfg, cc);
+	u64 ns = 0;
 
-	return bnxt_refclk_read(ptp->bp, NULL);
+	bnxt_refclk_read(ptp->bp, NULL, &ns);
+	return ns;
 }
 
 static void bnxt_stamp_tx_skb(struct bnxt *bp, struct sk_buff *skb)
@@ -439,7 +449,7 @@ int bnxt_ptp_init(struct bnxt *bp)
 	}
 	if (bp->flags & BNXT_FLAG_CHIP_P5) {
 		spin_lock_bh(&ptp->ptp_lock);
-		ptp->current_time = bnxt_refclk_read(bp, NULL);
+		bnxt_refclk_read(bp, NULL, &ptp->current_time);
 		WRITE_ONCE(ptp->old_time, ptp->current_time);
 		spin_unlock_bh(&ptp->ptp_lock);
 		ptp_schedule_worker(ptp->ptp_clock, 0);
-- 
2.18.1


--00000000000053e8a405c832ecfc
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIM7sKlG9ceSzGEK0fgrW3WlhdBr79E9+
aTK/temlfWVNMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDcy
ODE4MTIwMlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQA7nyU162q2klOxz9Q6DzqF+9xhCppcCT0RbHZ1s90VGRjWWG7M
kY6wqAPEQP8aPSOFio+P989JeYvyg/dNG5wL8vLGnXu5rG5T8UTJElgsKok43DuiM1IVUkzFZqRg
7tlPf+fekhL1VIZJTwvYaDUzMIIc1hINe9WGKfP/lbgxE/2EzFXYjgWJB7x8DOEmv8vHfEBqTrZc
IJvtYa9JG5bTGWV8mPOCjkeqvZx9thKoHWnd+dIeI9zPXC4+EC5XrZUmwkhMhHRgBO4s0Kmae/94
jUj7/IUPAThlKN29kJHQdEfM8Dr+q1coJFzyLpZfqMO6CHbZq4568xrBZQXX163m
--00000000000053e8a405c832ecfc--
