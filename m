Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B27B282D36
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 21:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbgJDTX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 15:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726294AbgJDTX0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 15:23:26 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1F85C0613CE
        for <netdev@vger.kernel.org>; Sun,  4 Oct 2020 12:23:26 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id 7so4329620pgm.11
        for <netdev@vger.kernel.org>; Sun, 04 Oct 2020 12:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=PPmo+WJZUzQEQ48r9G1VzLXNXh4aiIQ0rWsSzXp6P8U=;
        b=c/xv3kcnabByZmO7twJp5TZ6XeUlx2Sx5PK1VY5xsOjhQF7H4wGohJ4V0IcDqGm9R6
         WpLcI3IsOMNuI2b+YyfXcwCXlb+f5Dq5/+vzEjyPAWMkZtXMuSCwrv1ke59AQ7vU62qw
         ug02TZw0b1b+D8y2zsEeY8tazcYVCG8vD/64I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=PPmo+WJZUzQEQ48r9G1VzLXNXh4aiIQ0rWsSzXp6P8U=;
        b=jtxywB4gU7Fol6gJjlNvWD7ciuKi60L4QUU0jthh04r+p30ueP3VtUHE0F+o4RweIj
         HxFn9NKIqRu+ucH1bhsDho1Zb78CSfhXUYdnyyv8y/GDympNWZWI5pC1UrLpX4cqiOJs
         tZ6KTxCZn38CPkI2XgJQe8Rz8beC8ZTFuzRZkCv8XlIw/sWbhsuxWzgGc3gLaQtYq2vF
         XzHq8M48FvweF2DbTOOZaixEi0bjkys8Ler3AOCzRGumgo37dyajnUKhVLNp9X1Kg8yR
         ltCwlQbiRxx1kyBBitDmeHQEEvKzzX2GgtOY6+BgZNZEPvxYeOdfIYpfWv78z1Ga/UhT
         8PrQ==
X-Gm-Message-State: AOAM532oVqUtTdAO0brX3vobkb/Sv2MD3kWwOCi7Rh+gKgn3kRtq/g34
        151lOoPURD58BE/Xn2GkXYyNds8a6dF4LQ==
X-Google-Smtp-Source: ABdhPJySAXfb9mD8ijjW3RmQdIGA3PGA/mdCJwO7Gs6g2ZKGcCYVqbAXsFGf6dYDVqTnp+xX4UDvsQ==
X-Received: by 2002:a63:2bd1:: with SMTP id r200mr11060352pgr.20.1601839406155;
        Sun, 04 Oct 2020 12:23:26 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 138sm9824234pfu.180.2020.10.04.12.23.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 04 Oct 2020 12:23:25 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com,
        Edwin Peer <edwin.peer@broadcom.com>
Subject: [PATCH net-next 03/11] bnxt_en: log firmware status on firmware init failure
Date:   Sun,  4 Oct 2020 15:22:53 -0400
Message-Id: <1601839381-10446-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1601839381-10446-1-git-send-email-michael.chan@broadcom.com>
References: <1601839381-10446-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000d1fa5505b0dd4cf1"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000d1fa5505b0dd4cf1

From: Edwin Peer <edwin.peer@broadcom.com>

Firmware now supports device independent discovery of the status
register location. This status register can provide more detailed
information about firmware errors, especially if problems occur
before the HWRM interface is functioning. Attempt to map this
register if it is present and report the firmware status on firmware
init failures.

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 56 +++++++++++++++++++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  4 ++
 2 files changed, 55 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index cf730ec92a0f..224f76e784b8 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -7366,6 +7366,47 @@ static int bnxt_alloc_fw_health(struct bnxt *bp)
 	return 0;
 }
 
+static void __bnxt_map_fw_health_reg(struct bnxt *bp, u32 reg)
+{
+	writel(reg & BNXT_GRC_BASE_MASK, bp->bar0 +
+					 BNXT_GRCPF_REG_WINDOW_BASE_OUT +
+					 BNXT_FW_HEALTH_WIN_MAP_OFF);
+}
+
+static void bnxt_try_map_fw_health_reg(struct bnxt *bp)
+{
+	void __iomem *hs;
+	u32 status_loc;
+	u32 reg_type;
+	u32 sig;
+
+	__bnxt_map_fw_health_reg(bp, HCOMM_STATUS_STRUCT_LOC);
+	hs = bp->bar0 + BNXT_FW_HEALTH_WIN_OFF(HCOMM_STATUS_STRUCT_LOC);
+
+	sig = readl(hs + offsetof(struct hcomm_status, sig_ver));
+	if ((sig & HCOMM_STATUS_SIGNATURE_MASK) != HCOMM_STATUS_SIGNATURE_VAL) {
+		if (bp->fw_health)
+			bp->fw_health->status_reliable = false;
+		return;
+	}
+
+	if (__bnxt_alloc_fw_health(bp)) {
+		netdev_warn(bp->dev, "no memory for firmware status checks\n");
+		return;
+	}
+
+	status_loc = readl(hs + offsetof(struct hcomm_status, fw_status_loc));
+	bp->fw_health->regs[BNXT_FW_HEALTH_REG] = status_loc;
+	reg_type = BNXT_FW_HEALTH_REG_TYPE(status_loc);
+	if (reg_type == BNXT_FW_HEALTH_REG_TYPE_GRC) {
+		__bnxt_map_fw_health_reg(bp, status_loc);
+		bp->fw_health->mapped_regs[BNXT_FW_HEALTH_REG] =
+			BNXT_FW_HEALTH_WIN_OFF(status_loc);
+	}
+
+	bp->fw_health->status_reliable = true;
+}
+
 static int bnxt_map_fw_health_regs(struct bnxt *bp)
 {
 	struct bnxt_fw_health *fw_health = bp->fw_health;
@@ -7382,14 +7423,12 @@ static int bnxt_map_fw_health_regs(struct bnxt *bp)
 			reg_base = reg & BNXT_GRC_BASE_MASK;
 		if ((reg & BNXT_GRC_BASE_MASK) != reg_base)
 			return -ERANGE;
-		fw_health->mapped_regs[i] = BNXT_FW_HEALTH_WIN_BASE +
-					    (reg & BNXT_GRC_OFFSET_MASK);
+		fw_health->mapped_regs[i] = BNXT_FW_HEALTH_WIN_OFF(reg);
 	}
 	if (reg_base == 0xffffffff)
 		return 0;
 
-	writel(reg_base, bp->bar0 + BNXT_GRCPF_REG_WINDOW_BASE_OUT +
-			 BNXT_FW_HEALTH_WIN_MAP_OFF);
+	__bnxt_map_fw_health_reg(bp, reg_base);
 	return 0;
 }
 
@@ -11002,8 +11041,15 @@ static int bnxt_fw_init_one_p1(struct bnxt *bp)
 
 	bp->fw_cap = 0;
 	rc = bnxt_hwrm_ver_get(bp);
-	if (rc)
+	bnxt_try_map_fw_health_reg(bp);
+	if (rc) {
+		if (bp->fw_health && bp->fw_health->status_reliable)
+			netdev_err(bp->dev,
+				   "Firmware not responding, status: 0x%x\n",
+				   bnxt_fw_health_readl(bp,
+							BNXT_FW_HEALTH_REG));
 		return rc;
+	}
 
 	if (bp->fw_cap & BNXT_FW_CAP_KONG_MB_CHNL) {
 		rc = bnxt_alloc_kong_hwrm_resources(bp);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 74387259e1c6..e940a242d958 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1494,6 +1494,7 @@ struct bnxt_fw_health {
 	u8 enabled:1;
 	u8 master:1;
 	u8 fatal:1;
+	u8 status_reliable:1;
 	u8 tmr_multiplier;
 	u8 tmr_counter;
 	u8 fw_reset_seq_cnt;
@@ -1521,6 +1522,9 @@ struct bnxt_fw_reporter_ctx {
 #define BNXT_FW_HEALTH_WIN_BASE		0x3000
 #define BNXT_FW_HEALTH_WIN_MAP_OFF	8
 
+#define BNXT_FW_HEALTH_WIN_OFF(reg)	(BNXT_FW_HEALTH_WIN_BASE +	\
+					 ((reg) & BNXT_GRC_OFFSET_MASK))
+
 #define BNXT_FW_STATUS_HEALTHY		0x8000
 #define BNXT_FW_STATUS_SHUTDOWN		0x100000
 
-- 
2.18.1


--000000000000d1fa5505b0dd4cf1
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
ENt96uQJNu/QKZCsRxnu8bu9XkzIQTTFs7+NKghvf+h9ck5SSEvV5vlzS8HDlhKReyLBOxx5AgMB
AAGjggHQMIIBzDAOBgNVHQ8BAf8EBAMCBaAwgZ4GCCsGAQUFBwEBBIGRMIGOME0GCCsGAQUFBzAC
hkFodHRwOi8vc2VjdXJlLmdsb2JhbHNpZ24uY29tL2NhY2VydC9nc3BlcnNvbmFsc2lnbjJzaGEy
ZzNvY3NwLmNydDA9BggrBgEFBQcwAYYxaHR0cDovL29jc3AyLmdsb2JhbHNpZ24uY29tL2dzcGVy
c29uYWxzaWduMnNoYTJnMzBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYm
aHR0cHM6Ly93d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBEBgNVHR8E
PTA7MDmgN6A1hjNodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzcGVyc29uYWxzaWduMnNoYTJn
My5jcmwwJAYDVR0RBB0wG4EZbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggr
BgEFBQcDBDAfBgNVHSMEGDAWgBRpcoJiMWeVRIV3kYDEBDZJnXsLYTAdBgNVHQ4EFgQUyZbpLEwR
KZHEh+rXp6GbCZmMEwUwDQYJKoZIhvcNAQELBQADggEBADZsABrJEwqeVLJJcX+rKN/oFPl/Sb1f
4NQRqf0J5IHlqI7oSUUaSVHviPvq4QyTMh7P9KHkuTwANTnTPr4f4y1SirdtxgZKy1xDmt1KjL5u
nA4rBLSA+Kp/mo0DMxKKQY/LsZNS3Zn+HIAZpXTUEFotC5qgN35ua7sP0hTynKzfLG8Fi565tQkX
Si7Gzq+VM1jcLa3+kjHalTIlC7q7gkvVhgEwmztW1SuO7pJn0/GOncxYGQXEk3PIH3QbPNO8VMkx
3YeEtbaXosR5XLWchobv9S5HB9h4t0TUbZh2kX0HlGzgFLCPif27aL7ZpahFcoCS928kT+/V4tAj
BB+IwnkxggJvMIICawIBATBtMF0xCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52
LXNhMTMwMQYDVQQDEypHbG9iYWxTaWduIFBlcnNvbmFsU2lnbiAyIENBIC0gU0hBMjU2IC0gRzMC
DF5npqHWO504Sj4Q1TANBglghkgBZQMEAgEFAKCB1DAvBgkqhkiG9w0BCQQxIgQghYU4pxET8S5+
7tYXsnnwZ5MUAXwKIkB3Izzv9TcyFn0wGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG
9w0BCQUxDxcNMjAxMDA0MTkyMzI2WjBpBgkqhkiG9w0BCQ8xXDBaMAsGCWCGSAFlAwQBKjALBglg
hkgBZQMEARYwCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMAsGCSqGSIb3DQEBCjALBgkqhkiG9w0B
AQcwCwYJYIZIAWUDBAIBMA0GCSqGSIb3DQEBAQUABIIBAI9tDqHCiOoXXtKDLHVSCOEo7/iO/onA
wZKtirru35z1CGJbYLYX+/qxggMUrNZpV48PMTfUsy2+dN+S9ufmGtPtrDcs3UAqC4xSFKucb8H2
FlQ3UtFdNlIfNSDbF8DPe0nITdWQ8QjVcWAOXLwTj7dS/xK8QgSIe+2pjqxO/Y6RjySA6IWQpWmV
98soNRucW/KgjSQFkkQ647zumBlUxtsSxUv43jwlIDEAhdOrc5TsmG+oiVXmWI44R1UAm/65GS7P
5F7DmyvIKgk7E4ZOKZNT3RDp8iQDDdRL7DeBYq1FHF+AOW/dvvAboqGnaiOSxaj0G1FxL7NJuLEM
5LzJGkc=
--000000000000d1fa5505b0dd4cf1--
