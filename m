Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C615936A2E9
	for <lists+netdev@lfdr.de>; Sat, 24 Apr 2021 22:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237032AbhDXUPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Apr 2021 16:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236954AbhDXUPX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Apr 2021 16:15:23 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01E00C061574
        for <netdev@vger.kernel.org>; Sat, 24 Apr 2021 13:14:45 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id y32so37502453pga.11
        for <netdev@vger.kernel.org>; Sat, 24 Apr 2021 13:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=mtgcrmZrqNZGFCkS+u927MfG5EFte8sJew6F0NG9cYU=;
        b=RxrCrxfnFbaqGJHWlq5IhHLtMyJWj6apM6qjvUalb6zcXosMfdZJJakXrwfySyLLQE
         1dOe+nFbaWV3/H8mrJ13X3hHrCZii3KoNnDHV+9BdsP9N5naXlvJaMo0g5Bvq0OI9vVW
         InaG/OAK6mK7Z+4jUjgRZ8nnFQW7ZRWHchkpk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=mtgcrmZrqNZGFCkS+u927MfG5EFte8sJew6F0NG9cYU=;
        b=hKeZneG4eIyLusuEYIADOloCMaDnBk993dyh8HJMDqmhCDyve5wH6NqIzSR4TVEY09
         am9Cpm21TCySx+FJ/nBqOZhvSlcUYjss3mTWfDlxY/zyjrAJSp1xfG7P6H+ic34jl2kF
         d4aywBgc8Ny8JIinc1pNlcyTruh8KGr2B5K/ZIqWz3qrUoIJg3DxpOcj5+jMDk+8WCAr
         UvwLdttzk1mz7GxPKREp0uXfk0L5XpFNbKb5AFZvU4THQU8thM4RzWeqSDeu78/OT7ss
         6bsqu03y10QPnT5qiuWC1+4B5dyUJDvimg8JFM6B5/nt5jdjizMZzT/RbqhM5hiqZu6i
         j2jQ==
X-Gm-Message-State: AOAM5324zjXOGFlXyjjO5+8h4iqR3gNIpUYTOWGD77TdXd+9+z96DNp5
        PlvjDyA71qqZE2U8RkledRRRB1AaVQLEbxLd
X-Google-Smtp-Source: ABdhPJzo7pkTwVTwmH6/CDY5Clljc3tcu6noRArbd61SnGKaY0fsAVRerpHqMSm9W0WFvI4/7s8wFg==
X-Received: by 2002:a63:fb15:: with SMTP id o21mr9751971pgh.337.1619295284151;
        Sat, 24 Apr 2021 13:14:44 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z29sm7914070pga.52.2021.04.24.13.14.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 24 Apr 2021 13:14:43 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 02/10] bnxt_en: Add a new phy_flags field to the main driver structure.
Date:   Sat, 24 Apr 2021 16:14:23 -0400
Message-Id: <1619295271-30853-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1619295271-30853-1-git-send-email-michael.chan@broadcom.com>
References: <1619295271-30853-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000003c92f505c0bd9086"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000003c92f505c0bd9086

Copy the phy related feature flags from the firmware call
HWRM_PORT_PHY_QCAPS to this new field.  We can also remove the flags
field in the bnxt_test_info structure.  It's cleaner to have all PHY
related flags in one location, directly copied from the firmware.

To keep the BNXT_PHY_CFG_ABLE() macro logic the same, we need to make
a slight adjustment to check that it is a PF.

Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 29 ++++---------------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     | 19 +++++++-----
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  8 ++---
 3 files changed, 22 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 573c039e6046..f08427b7dbe7 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4145,7 +4145,7 @@ static void bnxt_free_mem(struct bnxt *bp, bool irq_re_init)
 	bnxt_free_ntp_fltrs(bp, irq_re_init);
 	if (irq_re_init) {
 		bnxt_free_ring_stats(bp);
-		if (!(bp->fw_cap & BNXT_FW_CAP_PORT_STATS_NO_RESET) ||
+		if (!(bp->phy_flags & BNXT_PHY_FL_PORT_STATS_NO_RESET) ||
 		    test_bit(BNXT_STATE_IN_FW_RESET, &bp->state))
 			bnxt_free_port_stats(bp);
 		bnxt_free_ring_grps(bp);
@@ -9116,7 +9116,7 @@ static void bnxt_report_link(struct bnxt *bp)
 		}
 		netdev_info(bp->dev, "NIC Link is Up, %u Mbps %s%s duplex, Flow control: %s\n",
 			    speed, signal, duplex, flow_ctrl);
-		if (bp->flags & BNXT_FLAG_EEE_CAP)
+		if (bp->phy_flags & BNXT_PHY_FL_EEE_CAP)
 			netdev_info(bp->dev, "EEE is %s\n",
 				    bp->eee.eee_active ? "active" :
 							 "not active");
@@ -9148,10 +9148,6 @@ static int bnxt_hwrm_phy_qcaps(struct bnxt *bp)
 	struct hwrm_port_phy_qcaps_output *resp = bp->hwrm_cmd_resp_addr;
 	struct bnxt_link_info *link_info = &bp->link_info;
 
-	bp->flags &= ~BNXT_FLAG_EEE_CAP;
-	if (bp->test_info)
-		bp->test_info->flags &= ~(BNXT_TEST_FL_EXT_LPBK |
-					  BNXT_TEST_FL_AN_PHY_LPBK);
 	if (bp->hwrm_spec_code < 0x10201)
 		return 0;
 
@@ -9162,31 +9158,17 @@ static int bnxt_hwrm_phy_qcaps(struct bnxt *bp)
 	if (rc)
 		goto hwrm_phy_qcaps_exit;
 
+	bp->phy_flags = resp->flags;
 	if (resp->flags & PORT_PHY_QCAPS_RESP_FLAGS_EEE_SUPPORTED) {
 		struct ethtool_eee *eee = &bp->eee;
 		u16 fw_speeds = le16_to_cpu(resp->supported_speeds_eee_mode);
 
-		bp->flags |= BNXT_FLAG_EEE_CAP;
 		eee->supported = _bnxt_fw_to_ethtool_adv_spds(fw_speeds, 0);
 		bp->lpi_tmr_lo = le32_to_cpu(resp->tx_lpi_timer_low) &
 				 PORT_PHY_QCAPS_RESP_TX_LPI_TIMER_LOW_MASK;
 		bp->lpi_tmr_hi = le32_to_cpu(resp->valid_tx_lpi_timer_high) &
 				 PORT_PHY_QCAPS_RESP_TX_LPI_TIMER_HIGH_MASK;
 	}
-	if (resp->flags & PORT_PHY_QCAPS_RESP_FLAGS_EXTERNAL_LPBK_SUPPORTED) {
-		if (bp->test_info)
-			bp->test_info->flags |= BNXT_TEST_FL_EXT_LPBK;
-	}
-	if (resp->flags & PORT_PHY_QCAPS_RESP_FLAGS_AUTONEG_LPBK_SUPPORTED) {
-		if (bp->test_info)
-			bp->test_info->flags |= BNXT_TEST_FL_AN_PHY_LPBK;
-	}
-	if (resp->flags & PORT_PHY_QCAPS_RESP_FLAGS_SHARED_PHY_CFG_SUPPORTED) {
-		if (BNXT_PF(bp))
-			bp->fw_cap |= BNXT_FW_CAP_SHARED_PORT_CFG;
-	}
-	if (resp->flags & PORT_PHY_QCAPS_RESP_FLAGS_CUMULATIVE_COUNTERS_ON_RESET)
-		bp->fw_cap |= BNXT_FW_CAP_PORT_STATS_NO_RESET;
 
 	if (bp->hwrm_spec_code >= 0x10a01) {
 		if (bnxt_phy_qcaps_no_speed(resp)) {
@@ -9277,7 +9259,7 @@ int bnxt_update_link(struct bnxt *bp, bool chng_link_state)
 			      PORT_PHY_QCFG_RESP_PHY_ADDR_MASK;
 	link_info->module_status = resp->module_status;
 
-	if (bp->flags & BNXT_FLAG_EEE_CAP) {
+	if (bp->phy_flags & BNXT_PHY_FL_EEE_CAP) {
 		struct ethtool_eee *eee = &bp->eee;
 		u16 fw_speeds;
 
@@ -9855,7 +9837,7 @@ static bool bnxt_eee_config_ok(struct bnxt *bp)
 	struct ethtool_eee *eee = &bp->eee;
 	struct bnxt_link_info *link_info = &bp->link_info;
 
-	if (!(bp->flags & BNXT_FLAG_EEE_CAP))
+	if (!(bp->phy_flags & BNXT_PHY_FL_EEE_CAP))
 		return true;
 
 	if (eee->eee_enabled) {
@@ -12450,6 +12432,7 @@ static int bnxt_probe_phy(struct bnxt *bp, bool fw_dflt)
 	int rc = 0;
 	struct bnxt_link_info *link_info = &bp->link_info;
 
+	bp->phy_flags = 0;
 	rc = bnxt_hwrm_phy_qcaps(bp);
 	if (rc) {
 		netdev_err(bp->dev, "Probe phy can't get phy capabilities (rc: %x)\n",
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 29061c577baa..6c4fb78c59fe 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1341,9 +1341,6 @@ struct bnxt_led_info {
 
 struct bnxt_test_info {
 	u8 offline_mask;
-	u8 flags;
-#define BNXT_TEST_FL_EXT_LPBK		0x1
-#define BNXT_TEST_FL_AN_PHY_LPBK	0x2
 	u16 timeout;
 	char string[BNXT_MAX_TEST][ETH_GSTRING_LEN];
 };
@@ -1693,7 +1690,6 @@ struct bnxt {
 	#define BNXT_FLAG_SHARED_RINGS	0x200
 	#define BNXT_FLAG_PORT_STATS	0x400
 	#define BNXT_FLAG_UDP_RSS_CAP	0x800
-	#define BNXT_FLAG_EEE_CAP	0x1000
 	#define BNXT_FLAG_NEW_RSS_CAP	0x2000
 	#define BNXT_FLAG_WOL_CAP	0x4000
 	#define BNXT_FLAG_ROCEV1_CAP	0x8000
@@ -1720,8 +1716,10 @@ struct bnxt {
 #define BNXT_NPAR(bp)		((bp)->port_partition_type)
 #define BNXT_MH(bp)		((bp)->flags & BNXT_FLAG_MULTI_HOST)
 #define BNXT_SINGLE_PF(bp)	(BNXT_PF(bp) && !BNXT_NPAR(bp) && !BNXT_MH(bp))
+#define BNXT_SH_PORT_CFG_OK(bp)	(BNXT_PF(bp) &&				\
+				 ((bp)->phy_flags & BNXT_PHY_FL_SHARED_PORT_CFG))
 #define BNXT_PHY_CFG_ABLE(bp)	((BNXT_SINGLE_PF(bp) ||			\
-				  ((bp)->fw_cap & BNXT_FW_CAP_SHARED_PORT_CFG)) && \
+				  BNXT_SH_PORT_CFG_OK(bp)) &&		\
 				 (bp)->link_info.phy_state == BNXT_PHY_STATE_ENABLED)
 #define BNXT_CHIP_TYPE_NITRO_A0(bp) ((bp)->flags & BNXT_FLAG_CHIP_NITRO_A0)
 #define BNXT_RX_PAGE_MODE(bp)	((bp)->flags & BNXT_FLAG_RX_PAGE_MODE)
@@ -1871,11 +1869,9 @@ struct bnxt {
 	#define BNXT_FW_CAP_EXT_STATS_SUPPORTED		0x00040000
 	#define BNXT_FW_CAP_ERR_RECOVER_RELOAD		0x00100000
 	#define BNXT_FW_CAP_HOT_RESET			0x00200000
-	#define BNXT_FW_CAP_SHARED_PORT_CFG		0x00400000
 	#define BNXT_FW_CAP_VLAN_RX_STRIP		0x01000000
 	#define BNXT_FW_CAP_VLAN_TX_INSERT		0x02000000
 	#define BNXT_FW_CAP_EXT_HW_STATS_SUPPORTED	0x04000000
-	#define BNXT_FW_CAP_PORT_STATS_NO_RESET		0x10000000
 	#define BNXT_FW_CAP_RING_MONITOR		0x40000000
 
 #define BNXT_NEW_RM(bp)		((bp)->fw_cap & BNXT_FW_CAP_NEW_RM)
@@ -2010,6 +2006,15 @@ struct bnxt {
 	u32			lpi_tmr_lo;
 	u32			lpi_tmr_hi;
 
+	/* copied from flags in hwrm_port_phy_qcaps_output */
+	u8			phy_flags;
+#define BNXT_PHY_FL_EEE_CAP		PORT_PHY_QCAPS_RESP_FLAGS_EEE_SUPPORTED
+#define BNXT_PHY_FL_EXT_LPBK		PORT_PHY_QCAPS_RESP_FLAGS_EXTERNAL_LPBK_SUPPORTED
+#define BNXT_PHY_FL_AN_PHY_LPBK		PORT_PHY_QCAPS_RESP_FLAGS_AUTONEG_LPBK_SUPPORTED
+#define BNXT_PHY_FL_SHARED_PORT_CFG	PORT_PHY_QCAPS_RESP_FLAGS_SHARED_PHY_CFG_SUPPORTED
+#define BNXT_PHY_FL_PORT_STATS_NO_RESET	PORT_PHY_QCAPS_RESP_FLAGS_CUMULATIVE_COUNTERS_ON_RESET
+#define BNXT_PHY_FL_NO_PHY_LPBK		PORT_PHY_QCAPS_RESP_FLAGS_LOCAL_LPBK_NOT_SUPPORTED
+
 	u8			num_tests;
 	struct bnxt_test_info	*test_info;
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 3b66e300c962..c664ec52ebcf 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -2912,7 +2912,7 @@ static int bnxt_set_eee(struct net_device *dev, struct ethtool_eee *edata)
 	if (!BNXT_PHY_CFG_ABLE(bp))
 		return -EOPNOTSUPP;
 
-	if (!(bp->flags & BNXT_FLAG_EEE_CAP))
+	if (!(bp->phy_flags & BNXT_PHY_FL_EEE_CAP))
 		return -EOPNOTSUPP;
 
 	mutex_lock(&bp->link_lock);
@@ -2963,7 +2963,7 @@ static int bnxt_get_eee(struct net_device *dev, struct ethtool_eee *edata)
 {
 	struct bnxt *bp = netdev_priv(dev);
 
-	if (!(bp->flags & BNXT_FLAG_EEE_CAP))
+	if (!(bp->phy_flags & BNXT_PHY_FL_EEE_CAP))
 		return -EOPNOTSUPP;
 
 	*edata = bp->eee;
@@ -3215,7 +3215,7 @@ static int bnxt_disable_an_for_lpbk(struct bnxt *bp,
 	int rc;
 
 	if (!link_info->autoneg ||
-	    (bp->test_info->flags & BNXT_TEST_FL_AN_PHY_LPBK))
+	    (bp->phy_flags & BNXT_PHY_FL_AN_PHY_LPBK))
 		return 0;
 
 	rc = bnxt_query_force_speeds(bp, &fw_advertising);
@@ -3416,7 +3416,7 @@ static void bnxt_self_test(struct net_device *dev, struct ethtool_test *etest,
 	}
 
 	if ((etest->flags & ETH_TEST_FL_EXTERNAL_LB) &&
-	    (bp->test_info->flags & BNXT_TEST_FL_EXT_LPBK))
+	    (bp->phy_flags & BNXT_PHY_FL_EXT_LPBK))
 		do_ext_lpbk = true;
 
 	if (etest->flags & ETH_TEST_FL_OFFLINE) {
-- 
2.18.1


--0000000000003c92f505c0bd9086
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEINrVvBX9EUjhg1G6tdCl77ECmsZ4F888
qb44XhlDdNKcMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDQy
NDIwMTQ0NFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQBDSbPNjTAkfkH1tKcY6IUc6q0F1hicJHpL4hsacnlzL9RzLgHR
ysAMzaElc66cHO2vxB1QDcLoGJDJuQ5OwWjfiuAiNlxnWsji7YRAGtK44kKHZ9FrqoNyhwDRq8Ic
ibe/lFPDhBkDRiO1/8mAmBonhNlJ9oIQjwJk9lg8OJ8xGxyx+WUhSYFu8GElktJ597qX8jg6yo9R
sb4qK0V8w4gPFNW9F1FZFa6LKnYOoItvHexjyOP7OlNJWr0F6GeAKpbU0t7XiKpLw2LrO6z9Rg3r
NkxpT+I2Onk4QWkeBbm89HVgmWmCgpd8ve6h/qK8cTQfkj7kW92BB3dGr7JUeiWo
--0000000000003c92f505c0bd9086--
