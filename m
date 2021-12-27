Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E80BC47FAD9
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 09:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231491AbhL0IA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 03:00:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231485AbhL0IAy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 03:00:54 -0500
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4EE4C061401
        for <netdev@vger.kernel.org>; Mon, 27 Dec 2021 00:00:54 -0800 (PST)
Received: by mail-ua1-x933.google.com with SMTP id i6so25444910uae.6
        for <netdev@vger.kernel.org>; Mon, 27 Dec 2021 00:00:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=n4qeT8Pa+JIDYqoGrEyiUQDlYPL/LnsJgMGOiP+1xhU=;
        b=cavtnbm/93qCp6p+7cEll4sZos/q7lmtn6uC+uZBfwGG1a66Bt6eIHr+QSZsSWWS8m
         m9JIxBuqKV2UCwYCn/1etRTuHhqJP5BZeqDwKtLLI63jrr71Ag9Lzki8hR7UmkGKcLwi
         8pyCZPTvcy9qCHJnqXUCyFYNCWunCQMcEllmE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=n4qeT8Pa+JIDYqoGrEyiUQDlYPL/LnsJgMGOiP+1xhU=;
        b=JZXXrGHyshNqvUsIV4ZMHGI8C07f8Rzc/A+MeSgqkW5fFw2nwhmbulRg/Qje9TSSVw
         AfrzI3DZykA+A5a1Xh3NDKL2nM04fKjDESYchRLDOAyAbZk1+rwsurOo/zK7igENxK/J
         bzozMHhZi7C20eo3L3noF96HNeuKJEc2WJpgQWW/whjKhBMpobQGGukhPUDaycH3TNig
         Z8dDRbeFL1fBNixU25TGw/ogVm46aKVI1JAi1V7ZudjAFOKUBH7rPQIk3xy2SqFek5qA
         sEZZlohA6CePxdyRi4u8p+FuAQNnYxAM5jh3awJIPYWgButJ6QqKWExMMhHRJ7JJMUTL
         Xz8w==
X-Gm-Message-State: AOAM5305j5EZrP8m+DuUQN9Mw1vX5akHC+5HkRcBXFNfOeAAalWhQ2SN
        PpUQ4fbMXOlwT3SDZV60BDLypg==
X-Google-Smtp-Source: ABdhPJyLaQWg59gNCtBxtXmTr6E5EB+kL8khO2WJPvcwV2wKtgjhWpR6UHfcb8pgeHPNcFGS2KIGYQ==
X-Received: by 2002:a05:6102:3910:: with SMTP id e16mr4170711vsu.0.1640592053608;
        Mon, 27 Dec 2021 00:00:53 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o1sm2907587vkc.35.2021.12.27.00.00.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Dec 2021 00:00:53 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 4/7] bnxt_en: Support configurable CQE coalescing mode
Date:   Mon, 27 Dec 2021 03:00:29 -0500
Message-Id: <1640592032-8927-5-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1640592032-8927-1-git-send-email-michael.chan@broadcom.com>
References: <1640592032-8927-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000009a298705d41c1a7f"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000009a298705d41c1a7f

CQE coalescing mode is the same as the timer reset coalescing mode
on Broadcom devices.  Currently this mode is always enabled if it
is supported by the device.  Restructure the code slightly to support
dynamically changing this mode.

Add a flags field to struct bnxt_coal.  Initially, the CQE flag will
be set for the RX and TX side if the device supports it.  We need to
move bnxt_init_dflt_coal() to set up default coalescing until the
capability is determined.

Reviewed-by: Andy Gospodarek <gospo@broadcom.com>
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 16 +++++++++++-----
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  1 +
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 11df2fc05f6a..48e61355ca00 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6496,8 +6496,8 @@ static void bnxt_hwrm_set_coal_params(struct bnxt *bp,
 	struct hwrm_ring_cmpl_ring_cfg_aggint_params_input *req)
 {
 	struct bnxt_coal_cap *coal_cap = &bp->coal_cap;
+	u16 val, tmr, max, flags = hw_coal->flags;
 	u32 cmpl_params = coal_cap->cmpl_params;
-	u16 val, tmr, max, flags = 0;
 
 	max = hw_coal->bufs_per_record * 128;
 	if (hw_coal->budget)
@@ -6540,8 +6540,6 @@ static void bnxt_hwrm_set_coal_params(struct bnxt *bp,
 			cpu_to_le16(BNXT_COAL_CMPL_AGGR_TMR_DURING_INT_ENABLE);
 	}
 
-	if (cmpl_params & RING_AGGINT_QCAPS_RESP_CMPL_PARAMS_TIMER_RESET)
-		flags |= RING_CMPL_RING_CFG_AGGINT_PARAMS_REQ_FLAGS_TIMER_RESET;
 	if ((cmpl_params & RING_AGGINT_QCAPS_RESP_CMPL_PARAMS_RING_IDLE) &&
 	    hw_coal->idle_thresh && hw_coal->coal_ticks < hw_coal->idle_thresh)
 		flags |= RING_CMPL_RING_CFG_AGGINT_PARAMS_REQ_FLAGS_RING_IDLE;
@@ -11897,7 +11895,13 @@ static void bnxt_cleanup_pci(struct bnxt *bp)
 
 static void bnxt_init_dflt_coal(struct bnxt *bp)
 {
+	struct bnxt_coal_cap *coal_cap = &bp->coal_cap;
 	struct bnxt_coal *coal;
+	u16 flags = 0;
+
+	if (coal_cap->cmpl_params &
+	    RING_AGGINT_QCAPS_RESP_CMPL_PARAMS_TIMER_RESET)
+		flags |= RING_CMPL_RING_CFG_AGGINT_PARAMS_REQ_FLAGS_TIMER_RESET;
 
 	/* Tick values in micro seconds.
 	 * 1 coal_buf x bufs_per_record = 1 completion record.
@@ -11910,6 +11914,7 @@ static void bnxt_init_dflt_coal(struct bnxt *bp)
 	coal->idle_thresh = 50;
 	coal->bufs_per_record = 2;
 	coal->budget = 64;		/* NAPI budget */
+	coal->flags = flags;
 
 	coal = &bp->tx_coal;
 	coal->coal_ticks = 28;
@@ -11917,6 +11922,7 @@ static void bnxt_init_dflt_coal(struct bnxt *bp)
 	coal->coal_ticks_irq = 2;
 	coal->coal_bufs_irq = 2;
 	coal->bufs_per_record = 1;
+	coal->flags = flags;
 
 	bp->stats_coal_ticks = BNXT_DEF_STATS_COAL_TICKS;
 }
@@ -12403,8 +12409,6 @@ static int bnxt_init_board(struct pci_dev *pdev, struct net_device *dev)
 	bp->rx_ring_size = BNXT_DEFAULT_RX_RING_SIZE;
 	bp->tx_ring_size = BNXT_DEFAULT_TX_RING_SIZE;
 
-	bnxt_init_dflt_coal(bp);
-
 	timer_setup(&bp->timer, bnxt_timer, 0);
 	bp->current_interval = BNXT_TIMER_INTERVAL;
 
@@ -13424,6 +13428,8 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	bnxt_fw_init_one_p3(bp);
 
+	bnxt_init_dflt_coal(bp);
+
 	if (dev->hw_features & BNXT_HW_FEATURE_VLAN_ALL_RX)
 		bp->flags |= BNXT_FLAG_STRIP_VLAN;
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 4c9507d82fd0..7bd9c5d237d9 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -847,6 +847,7 @@ struct bnxt_coal {
 	u16			idle_thresh;
 	u8			bufs_per_record;
 	u8			budget;
+	u16			flags;
 };
 
 struct bnxt_tpa_info {
-- 
2.18.1


--0000000000009a298705d41c1a7f
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIIpQZyZCU37lSsV+niRdOlGYvGe1TQc7
dxAR3D5SSOGRMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMTIy
NzA4MDA1NFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQAMOe+cKAsMBSyc4ZrqC9tTWBbqvXRWyzS+yWS7QXOPX0PoPFz7
V/iK+ftR8GdRT4YvwJLo5RiORf1jwKJ1orvL0bgYmml95WGOxr/S4m8JgUBWkpLgVpoA+GSOwXIY
XhYPZ/wYYi8QM6IIX04tQyG2cJTiBos5foDlBMn2vMTDm8MyZMnvSa3xDguWRiEHXJyu/cpJjxNE
n1p7/oPT8ILljEYNCBivmZ+5Y1xlfQ35BZ8allsZbVSAO5bB0vGTNNruARYC981MuAYNTMdjhtlb
eZwzyikTAdzR+3zxkKI2Cq3w95c/cFopatuQdEhzyCXbEMXpr758tMe5va0u2ISw
--0000000000009a298705d41c1a7f--
