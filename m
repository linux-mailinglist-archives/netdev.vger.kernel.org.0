Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 715C9488D68
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 00:55:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236476AbiAIXzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 18:55:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234835AbiAIXzH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 18:55:07 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D301C06173F
        for <netdev@vger.kernel.org>; Sun,  9 Jan 2022 15:55:07 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id f8so9713784pgf.8
        for <netdev@vger.kernel.org>; Sun, 09 Jan 2022 15:55:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=mqPXIEzXEkMXNHKulNZ5f6q36U+GNeGKdUyNd77TVrc=;
        b=Ipse4nh1ZAOYYnlxS874hgJImE05CuHDU75zksfSUmaEVvDhGATOIoGzIzX4dhGdEh
         nzP04poN2agGsFMxS8sAlrsxmo1VMcCJMf5WIRLz0fkthLh2ypMBsSsOTpZBvKgegEr+
         rrnwxqVt9r6x7Tvdm7x1vFKWb3n/bhD9fnDmU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=mqPXIEzXEkMXNHKulNZ5f6q36U+GNeGKdUyNd77TVrc=;
        b=BFLPqU9UlP7DhZlINtD3V//Ucn+7aQpCEE2eJcF/aOPFMSrxKgOBsvxO2yTg8VbbPU
         xZh19ohSN4Wt3WYdzKCV3iesq1Gae5zgYnoOEEHr4A4SvslrpgQ9FAcwN4kOTujiiMO9
         HS2ORr4VWty9ec/+OzQt5Ya8qW9MM4CwjgwplnCLkmEATMqkafdoJpq31zLIC2/XNtEq
         HgbidDQ5/TENjsynDpvi5XrTWLd6BtGL4lnlTdhyr7fL7T8r5lCd5/LprAlUNpohJ3L2
         lfDY6niJ2rYr4wpb8tl8FKb21dnRGQYIkAn8LHWB/mfHdCsnRr3pjJnKvhPfSNGRXTXo
         TSAg==
X-Gm-Message-State: AOAM531hjm9lf0FT8UTR6bF7+OtyMyx3UWr+Zc7n6IeVjId+O4MsQzDV
        l2tzJ+VZlhiLT5HuDK3TAhNxbw==
X-Google-Smtp-Source: ABdhPJxvBCPX6KnGlFt8H0Pz+j+hNh5HKsZz2lMYbyUySmPCW4zGEuLhbEWu1G8fF9J5+mSyd9ciaQ==
X-Received: by 2002:a63:ac54:: with SMTP id z20mr2140627pgn.302.1641772506705;
        Sun, 09 Jan 2022 15:55:06 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id ls6sm6948611pjb.33.2022.01.09.15.55.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 09 Jan 2022 15:55:06 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next v2 3/4] bnxt_en: use firmware provided max timeout for messages
Date:   Sun,  9 Jan 2022 18:54:44 -0500
Message-Id: <1641772485-10421-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1641772485-10421-1-git-send-email-michael.chan@broadcom.com>
References: <1641772485-10421-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000001b0c9305d52ef36e"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000001b0c9305d52ef36e

From: Edwin Peer <edwin.peer@broadcom.com>

Some older devices cannot accommodate the 40 seconds timeout
cap for long running commands (such as NVRAM commands) due to
hardware limitations. Allow these devices to request more time for
these long running commands, but print a warning, since the longer
timeout may cause the hung task watchdog to trigger. In the case of a
firmware update operation, this is preferable to failing outright.

v2: Use bp->hwrm_cmd_max_timeout directly without the constants.

Fixes: 881d8353b05e ("bnxt_en: Add an upper bound for all firmware command timeouts.")
Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          | 6 ++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          | 3 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c | 4 ++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  | 9 +++------
 drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c     | 2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h     | 3 +--
 6 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 46f28ee4d05d..2a000d5ae3bf 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -8034,6 +8034,12 @@ static int bnxt_hwrm_ver_get(struct bnxt *bp)
 	bp->hwrm_cmd_timeout = le16_to_cpu(resp->def_req_timeout);
 	if (!bp->hwrm_cmd_timeout)
 		bp->hwrm_cmd_timeout = DFLT_HWRM_CMD_TIMEOUT;
+	bp->hwrm_cmd_max_timeout = le16_to_cpu(resp->max_req_timeout) * 1000;
+	if (!bp->hwrm_cmd_max_timeout)
+		bp->hwrm_cmd_max_timeout = HWRM_CMD_MAX_TIMEOUT;
+	else if (bp->hwrm_cmd_max_timeout > HWRM_CMD_MAX_TIMEOUT)
+		netdev_warn(bp->dev, "Device requests max timeout of %d seconds, may trigger hung task watchdog\n",
+			    bp->hwrm_cmd_max_timeout / 1000);
 
 	if (resp->hwrm_intf_maj_8b >= 1) {
 		bp->hwrm_max_req_len = le16_to_cpu(resp->max_req_win_len);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 5ec251a1100f..0da68dc35c69 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1987,7 +1987,8 @@ struct bnxt {
 
 	u16			hwrm_max_req_len;
 	u16			hwrm_max_ext_req_len;
-	int			hwrm_cmd_timeout;
+	unsigned int		hwrm_cmd_timeout;
+	unsigned int		hwrm_cmd_max_timeout;
 	struct mutex		hwrm_cmd_lock;	/* serialize hwrm messages */
 	struct hwrm_ver_get_output	ver_resp;
 #define FW_VER_STR_LEN		32
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c
index d3cb2f21946d..c06789882036 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c
@@ -32,7 +32,7 @@ static int bnxt_hwrm_dbg_dma_data(struct bnxt *bp, void *msg,
 		return -ENOMEM;
 	}
 
-	hwrm_req_timeout(bp, msg, HWRM_COREDUMP_TIMEOUT);
+	hwrm_req_timeout(bp, msg, bp->hwrm_cmd_max_timeout);
 	cmn_resp = hwrm_req_hold(bp, msg);
 	resp = cmn_resp;
 
@@ -125,7 +125,7 @@ static int bnxt_hwrm_dbg_coredump_initiate(struct bnxt *bp, u16 component_id,
 	if (rc)
 		return rc;
 
-	hwrm_req_timeout(bp, req, HWRM_COREDUMP_TIMEOUT);
+	hwrm_req_timeout(bp, req, bp->hwrm_cmd_max_timeout);
 	req->component_id = cpu_to_le16(component_id);
 	req->segment_id = cpu_to_le16(segment_id);
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 46859d9a01eb..003330e8cd58 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -31,9 +31,6 @@
 #include "bnxt_nvm_defs.h"	/* NVRAM content constant and structure defs */
 #include "bnxt_fw_hdr.h"	/* Firmware hdr constant and structure defs */
 #include "bnxt_coredump.h"
-#define FLASH_NVRAM_TIMEOUT	((HWRM_CMD_TIMEOUT) * 100)
-#define FLASH_PACKAGE_TIMEOUT	((HWRM_CMD_TIMEOUT) * 200)
-#define INSTALL_PACKAGE_TIMEOUT	((HWRM_CMD_TIMEOUT) * 200)
 
 static u32 bnxt_get_msglevel(struct net_device *dev)
 {
@@ -2194,7 +2191,7 @@ static int bnxt_flash_nvram(struct net_device *dev, u16 dir_type,
 		req->host_src_addr = cpu_to_le64(dma_handle);
 	}
 
-	hwrm_req_timeout(bp, req, FLASH_NVRAM_TIMEOUT);
+	hwrm_req_timeout(bp, req, bp->hwrm_cmd_max_timeout);
 	req->dir_type = cpu_to_le16(dir_type);
 	req->dir_ordinal = cpu_to_le16(dir_ordinal);
 	req->dir_ext = cpu_to_le16(dir_ext);
@@ -2540,8 +2537,8 @@ int bnxt_flash_package_from_fw_obj(struct net_device *dev, const struct firmware
 		return rc;
 	}
 
-	hwrm_req_timeout(bp, modify, FLASH_PACKAGE_TIMEOUT);
-	hwrm_req_timeout(bp, install, INSTALL_PACKAGE_TIMEOUT);
+	hwrm_req_timeout(bp, modify, bp->hwrm_cmd_max_timeout);
+	hwrm_req_timeout(bp, install, bp->hwrm_cmd_max_timeout);
 
 	hwrm_req_hold(bp, modify);
 	modify->host_src_addr = cpu_to_le64(dma_handle);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
index f75b2de8a14b..4c4027cfb322 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
@@ -529,7 +529,7 @@ static int __hwrm_send(struct bnxt *bp, struct bnxt_hwrm_ctx *ctx)
 	}
 
 	/* Limit timeout to an upper limit */
-	timeout = min_t(uint, ctx->timeout, HWRM_CMD_MAX_TIMEOUT);
+	timeout = min(ctx->timeout, bp->hwrm_cmd_max_timeout ?: HWRM_CMD_MAX_TIMEOUT);
 	/* convert timeout to usec */
 	timeout *= 1000;
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h
index 4d17f0d5363b..9a9fc4e8041b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h
@@ -58,11 +58,10 @@ void hwrm_update_token(struct bnxt *bp, u16 seq, enum bnxt_hwrm_wait_state s);
 
 #define BNXT_HWRM_MAX_REQ_LEN		(bp->hwrm_max_req_len)
 #define BNXT_HWRM_SHORT_REQ_LEN		sizeof(struct hwrm_short_input)
-#define HWRM_CMD_MAX_TIMEOUT		40000
+#define HWRM_CMD_MAX_TIMEOUT		40000U
 #define SHORT_HWRM_CMD_TIMEOUT		20
 #define HWRM_CMD_TIMEOUT		(bp->hwrm_cmd_timeout)
 #define HWRM_RESET_TIMEOUT		((HWRM_CMD_TIMEOUT) * 4)
-#define HWRM_COREDUMP_TIMEOUT		((HWRM_CMD_TIMEOUT) * 12)
 #define BNXT_HWRM_TARGET		0xffff
 #define BNXT_HWRM_NO_CMPL_RING		-1
 #define BNXT_HWRM_REQ_MAX_SIZE		128
-- 
2.18.1


--0000000000001b0c9305d52ef36e
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIOGzbxIleCrr5Mp7izaTLcFrmjAtAUPU
XPnMaqOHPvsvMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDEw
OTIzNTUwN1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQC1YMc9OWAXDVG2GBq6uify2xuXDJBbsV0hMHMHdYoxLicl5mbB
D7uMahQ3y1NLAZo0Q1+Ec+/O33s2tZY7ACe98X8gV3pnpMBmjK4LoYyQudexX/qHrdg9as/9Sg46
JZQxJWGrEj5jCVGXOpRD9yyGFgL2wh+iiV1Lv+hZEniPD7oMHIIIbuYl+7P+2INxA4kvwSn7qO8y
bNa6hCM4QgK0mmjRW1j+NpnfdAxoAok5hbRB6rntkFE0b/lSwLiZhzLzn5sYc62l6HIY4LNl3Sfw
SCdn+ObwUnM0HyaGpxWx0O8YjM/3mKYza64VHI9UaPDErZwGYLogdDcEIlQ7/brt
--0000000000001b0c9305d52ef36e--
