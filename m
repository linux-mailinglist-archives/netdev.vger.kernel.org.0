Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5C443F803
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 09:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232273AbhJ2Huq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 03:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbhJ2Hum (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 03:50:42 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ABBFC061570
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 00:48:14 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id q187so9190107pgq.2
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 00:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1ovZkDJ9NDClPvbcrrtW0v1NdbLyn9mFqov7qXgI32Y=;
        b=G4JHlE3wH6+7bnpY9Nv4VJa8hIWoPF/0OFbuK9E2X9jtX8boOimHKiR5y5JGm654tx
         xl45LK7igkZEjWFwgFgboJWcLv+WCA60a/nMV4AqPiX7vJh8kN55BxGTJh80FCIo5eED
         L9JvbzPIl8n6Z/5k56dIuXCWTlmamyhevMxts=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1ovZkDJ9NDClPvbcrrtW0v1NdbLyn9mFqov7qXgI32Y=;
        b=nixaeLndQuT3ix0FOLyWDryhnO2ULrpsLB9h/2v8hc4YumsCvczX6JPOWbGFe70fEC
         0um02gvPnUYweppJxJy/CKh3t5B4KQPlCrj/7P1+TLb8Yii1wtHi5VVCpbTLv5/5gHL4
         Gr3QYsjnTOQGlsdpUVSRFS0Yrrxi9BHuPn9j4BQCvRm2Ego7cRmsBsTpOv8NxBk3A61e
         LydWWYo/TfQksX+1MV0bYUOfpg1Z7EIq9WuSNo+7h/ujVKGHXozGPvvrYLgGB/N84ZFp
         toagBbs0cThn9/FYmOYV+9RXqecQtI1em6390lNvc0jF/3gJnERo6AXxNMzca5QVPMeX
         GB7Q==
X-Gm-Message-State: AOAM533+s+QnL+yF3E4mLAYeRZqOR/0IlJ4tG0SOKQ8zFQ8/WByuPhJR
        LWDZ5LGnFPpjdMfGFBDHcvOfsQ==
X-Google-Smtp-Source: ABdhPJzW8eY3KO2x0TVPq3ioeaqfUmdfVfmwjz86S6hZx4cCoMxLXWffR2AecCm2I3eSBWNb1s26RA==
X-Received: by 2002:a63:9316:: with SMTP id b22mr7060991pge.463.1635493693520;
        Fri, 29 Oct 2021 00:48:13 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s18sm5721186pfc.87.2021.10.29.00.48.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 29 Oct 2021 00:48:13 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edwin.peer@broadcom.com,
        gospo@broadcom.com, jiri@nvidia.com
Subject: [PATCH net-next v2 01/19] bnxt_en: refactor printing of device info
Date:   Fri, 29 Oct 2021 03:47:38 -0400
Message-Id: <1635493676-10767-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1635493676-10767-1-git-send-email-michael.chan@broadcom.com>
References: <1635493676-10767-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000b0159405cf790c28"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000b0159405cf790c28

From: Edwin Peer <edwin.peer@broadcom.com>

The device info logged during probe will be reused by the devlink
driver_reinit code in a following patch. Extract this logic into
the new bnxt_print_device_info() function. The board index needs
to be saved in the driver context so that the board information
can be retrieved at a later time, outside of the probe function.

Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 67 +++++------------------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h | 51 ++++++++++++++++-
 2 files changed, 63 insertions(+), 55 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 66263aa0d96b..8ff398525488 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -85,55 +85,7 @@ MODULE_DESCRIPTION("Broadcom BCM573xx network driver");
 
 #define BNXT_TX_PUSH_THRESH 164
 
-enum board_idx {
-	BCM57301,
-	BCM57302,
-	BCM57304,
-	BCM57417_NPAR,
-	BCM58700,
-	BCM57311,
-	BCM57312,
-	BCM57402,
-	BCM57404,
-	BCM57406,
-	BCM57402_NPAR,
-	BCM57407,
-	BCM57412,
-	BCM57414,
-	BCM57416,
-	BCM57417,
-	BCM57412_NPAR,
-	BCM57314,
-	BCM57417_SFP,
-	BCM57416_SFP,
-	BCM57404_NPAR,
-	BCM57406_NPAR,
-	BCM57407_SFP,
-	BCM57407_NPAR,
-	BCM57414_NPAR,
-	BCM57416_NPAR,
-	BCM57452,
-	BCM57454,
-	BCM5745x_NPAR,
-	BCM57508,
-	BCM57504,
-	BCM57502,
-	BCM57508_NPAR,
-	BCM57504_NPAR,
-	BCM57502_NPAR,
-	BCM58802,
-	BCM58804,
-	BCM58808,
-	NETXTREME_E_VF,
-	NETXTREME_C_VF,
-	NETXTREME_S_VF,
-	NETXTREME_C_VF_HV,
-	NETXTREME_E_VF_HV,
-	NETXTREME_E_P5_VF,
-	NETXTREME_E_P5_VF_HV,
-};
-
-/* indexed by enum above */
+/* indexed by enum board_idx */
 static const struct {
 	char *name;
 } board_info[] = {
@@ -13186,6 +13138,15 @@ static int bnxt_map_db_bar(struct bnxt *bp)
 	return 0;
 }
 
+void bnxt_print_device_info(struct bnxt *bp)
+{
+	netdev_info(bp->dev, "%s found at mem %lx, node addr %pM\n",
+		    board_info[bp->board_idx].name,
+		    (long)pci_resource_start(bp->pdev, 0), bp->dev->dev_addr);
+
+	pcie_print_link_status(bp->pdev);
+}
+
 static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	struct net_device *dev;
@@ -13209,10 +13170,11 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		return -ENOMEM;
 
 	bp = netdev_priv(dev);
+	bp->board_idx = ent->driver_data;
 	bp->msg_enable = BNXT_DEF_MSG_ENABLE;
 	bnxt_set_max_func_irqs(bp, max_irqs);
 
-	if (bnxt_vf_pciid(ent->driver_data))
+	if (bnxt_vf_pciid(bp->board_idx))
 		bp->flags |= BNXT_FLAG_VF;
 
 	if (pdev->msix_cap)
@@ -13382,10 +13344,7 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		devlink_port_type_eth_set(&bp->dl_port, bp->dev);
 	bnxt_dl_fw_reporters_create(bp);
 
-	netdev_info(dev, "%s found at mem %lx, node addr %pM\n",
-		    board_info[ent->driver_data].name,
-		    (long)pci_resource_start(pdev, 0), dev->dev_addr);
-	pcie_print_link_status(pdev);
+	bnxt_print_device_info(bp);
 
 	pci_save_state(pdev);
 	return 0;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 19fe6478e9b4..55da89cb62b5 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1586,6 +1586,54 @@ struct bnxt_fw_reporter_ctx {
 #define BNXT_FW_RETRY			5
 #define BNXT_FW_IF_RETRY		10
 
+enum board_idx {
+	BCM57301,
+	BCM57302,
+	BCM57304,
+	BCM57417_NPAR,
+	BCM58700,
+	BCM57311,
+	BCM57312,
+	BCM57402,
+	BCM57404,
+	BCM57406,
+	BCM57402_NPAR,
+	BCM57407,
+	BCM57412,
+	BCM57414,
+	BCM57416,
+	BCM57417,
+	BCM57412_NPAR,
+	BCM57314,
+	BCM57417_SFP,
+	BCM57416_SFP,
+	BCM57404_NPAR,
+	BCM57406_NPAR,
+	BCM57407_SFP,
+	BCM57407_NPAR,
+	BCM57414_NPAR,
+	BCM57416_NPAR,
+	BCM57452,
+	BCM57454,
+	BCM5745x_NPAR,
+	BCM57508,
+	BCM57504,
+	BCM57502,
+	BCM57508_NPAR,
+	BCM57504_NPAR,
+	BCM57502_NPAR,
+	BCM58802,
+	BCM58804,
+	BCM58808,
+	NETXTREME_E_VF,
+	NETXTREME_C_VF,
+	NETXTREME_S_VF,
+	NETXTREME_C_VF_HV,
+	NETXTREME_E_VF_HV,
+	NETXTREME_E_P5_VF,
+	NETXTREME_E_P5_VF_HV,
+};
+
 struct bnxt {
 	void __iomem		*bar0;
 	void __iomem		*bar1;
@@ -2049,6 +2097,7 @@ struct bnxt {
 	struct list_head	tc_indr_block_list;
 	struct dentry		*debugfs_pdev;
 	struct device		*hwmon_dev;
+	enum board_idx		board_idx;
 };
 
 #define BNXT_NUM_RX_RING_STATS			8
@@ -2219,5 +2268,5 @@ int bnxt_get_port_parent_id(struct net_device *dev,
 			    struct netdev_phys_item_id *ppid);
 void bnxt_dim_work(struct work_struct *work);
 int bnxt_hwrm_set_ring_coal(struct bnxt *bp, struct bnxt_napi *bnapi);
-
+void bnxt_print_device_info(struct bnxt *bp);
 #endif
-- 
2.18.1


--000000000000b0159405cf790c28
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEICAQblpFbSjwuFa0vTQmmvHexXSyaP4X
aLzgbbZVA+bgMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMTAy
OTA3NDgxNFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQClU9tBOy53ejTLysirxBwVI/DUew0xSkEDPRhb9auNxal4CTv9
ep5iNnjFBlbzyF+0FLR5nppMoIX8VoPEUomH1I/+vSk/pCbhiz1Xi0oRKZhtvi4Fi1r5fRvcGD0s
OkJOL88i/a2buWnb7wTFzcWlguZWsqtcxlMQWAexJl3n49uJ+uae84+N+ofaaQEQeRnxUWTYY/ZR
VN/B/i7y+ME4jUQ1aGaDHaEKATBz1meijvfto7Qd5G45mz/tVs+XTvaSmb2kmVLrZqOHbPjxwqh1
Gzp8mc644xarE+dscRFQsUDJb8ImKmJia95lbXSisKTKqLFN7vGzlYZjYWRoTwqe
--000000000000b0159405cf790c28--
