Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD8725259BD
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 04:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376554AbiEMCkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 22:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376547AbiEMCkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 22:40:43 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89402F3E
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 19:40:42 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id bo5so6488359pfb.4
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 19:40:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dJfM4xY0ValZDkQBdAKToJEmNp3Cvvvaep2zjmO7YLI=;
        b=GJlUOwLkfT9gd3ymUgd4umJ11dr/DFotJt96TUskHr1KzCpaN/nNr+NFhyGDpKcDcZ
         zM4Q+09eslSqnpUJw6YAbBB8DHgKrw0m9VMfjuNTMbT5qvP214z+ncvFXtlI6M1rD77g
         ML9Wh5fnhZ6kZC949Uv96J9xeQZSHEKq3Dh8E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dJfM4xY0ValZDkQBdAKToJEmNp3Cvvvaep2zjmO7YLI=;
        b=zaV0D2V/ywaGoGeKBiYGOGzv905/NuVWqyXN90xZ1ig5L06vFwUq0z49vfU+EPyr9V
         SbWCcmm88gHWzLhZj7ju/W6tCZEf4HSvmsdmop6a0OanjQp/Vg4AwKlI070wrA7pdmbl
         j5U5ePX4Tx4tWMoSbhqZ/UIxg/iTHJTUNAk4uu0oAD7sbhCRqQn8M1+dUfd9espdriWC
         aducRHG2RBN4mu+DRpLg5m9FfYhkPQepG4NdLGjxs3HRJktcpQ1LmcImqUlJJ0idA1Sx
         w+MUUBJJb1Yx+edkwaheoFwbH9eo4YTqMbAm5aKrqLu+RbsTsvZQwVrMHoqdgYnewrWP
         3Zxw==
X-Gm-Message-State: AOAM530hzeJuSAnuQ9WLrhiQEbzOmcDRs6AHm/ojXopcBtRo6+vbUHjQ
        Y+loQJSlKyLAx20fEcrIyN8/cQ==
X-Google-Smtp-Source: ABdhPJyKAIYGJ9MWU9zMeMavTrDNl3iZRvpeg+xsuEYcLztjrZmedWp9SmS6N26o+3Qd/wFtQT5MtQ==
X-Received: by 2002:a63:4e61:0:b0:3c6:9e14:5511 with SMTP id o33-20020a634e61000000b003c69e145511mr2142346pgl.446.1652409641441;
        Thu, 12 May 2022 19:40:41 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t3-20020a1709027fc300b0015e8da1fb07sm587212plb.127.2022.05.12.19.40.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 May 2022 19:40:41 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com,
        Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH net-next 3/4] bnxt_en: Enable packet timestamping for all RX packets
Date:   Thu, 12 May 2022 22:40:23 -0400
Message-Id: <1652409624-8731-4-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1652409624-8731-1-git-send-email-michael.chan@broadcom.com>
References: <1652409624-8731-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000c1047d05dedb995b"
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        MIME_HEADER_CTYPE_ONLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,T_TVD_MIME_NO_HEADERS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000c1047d05dedb995b

From: Pavan Chebbi <pavan.chebbi@broadcom.com>

Add driver support to enable timestamping on all RX packets
that are received by the NIC. This capability can be requested
by the applications using SIOCSHWTSTAMP ioctl with filter type
HWTSTAMP_FILTER_ALL.

Cc: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  8 ++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  2 ++
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  3 +++
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 26 ++++++++++++++++++-
 4 files changed, 36 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index bcb3c16bf915..56b46b8206a7 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -2040,7 +2040,7 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 	}
 
 	if (unlikely((flags & RX_CMP_FLAGS_ITYPES_MASK) ==
-		     RX_CMP_FLAGS_ITYPE_PTP_W_TS)) {
+		     RX_CMP_FLAGS_ITYPE_PTP_W_TS) || bp->ptp_all_rx_tstamp) {
 		if (bp->flags & BNXT_FLAG_CHIP_P5) {
 			u32 cmpl_ts = le32_to_cpu(rxcmp1->rx_cmp_timestamp);
 			u64 ns, ts;
@@ -7659,7 +7659,7 @@ static int __bnxt_hwrm_func_qcaps(struct bnxt *bp)
 	struct hwrm_func_qcaps_output *resp;
 	struct hwrm_func_qcaps_input *req;
 	struct bnxt_hw_resc *hw_resc = &bp->hw_resc;
-	u32 flags, flags_ext;
+	u32 flags, flags_ext, flags_ext2;
 	int rc;
 
 	rc = hwrm_req_init(bp, req, HWRM_FUNC_QCAPS);
@@ -7704,6 +7704,10 @@ static int __bnxt_hwrm_func_qcaps(struct bnxt *bp)
 	if (BNXT_PF(bp) && (flags_ext & FUNC_QCAPS_RESP_FLAGS_EXT_FW_LIVEPATCH_SUPPORTED))
 		bp->fw_cap |= BNXT_FW_CAP_LIVEPATCH;
 
+	flags_ext2 = le32_to_cpu(resp->flags_ext2);
+	if (flags_ext2 & FUNC_QCAPS_RESP_FLAGS_EXT2_RX_ALL_PKTS_TIMESTAMPS_SUPPORTED)
+		bp->fw_cap |= BNXT_FW_CAP_RX_ALL_PKT_TS;
+
 	bp->tx_push_thresh = 0;
 	if ((flags & FUNC_QCAPS_RESP_FLAGS_PUSH_MODE_SUPPORTED) &&
 	    BNXT_FW_MAJ(bp) > 217)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index a498ee297946..a1dca8c58f54 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1968,6 +1968,7 @@ struct bnxt {
 	#define BNXT_FW_CAP_ERR_RECOVER_RELOAD		0x00100000
 	#define BNXT_FW_CAP_HOT_RESET			0x00200000
 	#define BNXT_FW_CAP_PTP_RTC			0x00400000
+	#define BNXT_FW_CAP_RX_ALL_PKT_TS		0x00800000
 	#define BNXT_FW_CAP_VLAN_RX_STRIP		0x01000000
 	#define BNXT_FW_CAP_VLAN_TX_INSERT		0x02000000
 	#define BNXT_FW_CAP_EXT_HW_STATS_SUPPORTED	0x04000000
@@ -2131,6 +2132,7 @@ struct bnxt {
 	struct bpf_prog		*xdp_prog;
 
 	struct bnxt_ptp_cfg	*ptp_cfg;
+	u8			ptp_all_rx_tstamp;
 
 	/* devlink interface and vf-rep structs */
 	struct devlink		*dl;
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index b3a48d6675fe..8a7f3f02ed90 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -3759,6 +3759,9 @@ static int bnxt_get_ts_info(struct net_device *dev,
 	info->rx_filters = (1 << HWTSTAMP_FILTER_NONE) |
 			   (1 << HWTSTAMP_FILTER_PTP_V2_L2_EVENT) |
 			   (1 << HWTSTAMP_FILTER_PTP_V2_L4_EVENT);
+
+	if (bp->fw_cap & BNXT_FW_CAP_RX_ALL_PKT_TS)
+		info->rx_filters |= (1 << HWTSTAMP_FILTER_ALL);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
index f9c94e5fe718..562f8f68a47d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
@@ -305,14 +305,27 @@ void bnxt_ptp_cfg_tstamp_filters(struct bnxt *bp)
 
 	if (hwrm_req_init(bp, req, HWRM_PORT_MAC_CFG))
 		goto out;
+
+	if (!(bp->fw_cap & BNXT_FW_CAP_RX_ALL_PKT_TS) && (ptp->tstamp_filters &
+	    (PORT_MAC_CFG_REQ_FLAGS_ALL_RX_TS_CAPTURE_ENABLE |
+	     PORT_MAC_CFG_REQ_FLAGS_PTP_RX_TS_CAPTURE_DISABLE))) {
+		ptp->tstamp_filters &= ~(PORT_MAC_CFG_REQ_FLAGS_ALL_RX_TS_CAPTURE_ENABLE |
+					 PORT_MAC_CFG_REQ_FLAGS_PTP_RX_TS_CAPTURE_DISABLE);
+		netdev_warn(bp->dev, "Unsupported FW for all RX pkts timestamp filter\n");
+	}
+
 	req->flags = cpu_to_le32(ptp->tstamp_filters);
 	req->enables = cpu_to_le32(PORT_MAC_CFG_REQ_ENABLES_RX_TS_CAPTURE_PTP_MSG_TYPE);
 	req->rx_ts_capture_ptp_msg_type = cpu_to_le16(ptp->rxctl);
 
-	if (!hwrm_req_send(bp, req))
+	if (!hwrm_req_send(bp, req)) {
+		bp->ptp_all_rx_tstamp = !!(ptp->tstamp_filters &
+					   PORT_MAC_CFG_REQ_FLAGS_ALL_RX_TS_CAPTURE_ENABLE);
 		return;
+	}
 	ptp->tstamp_filters = 0;
 out:
+	bp->ptp_all_rx_tstamp = 0;
 	netdev_warn(bp->dev, "Failed to configure HW packet timestamp filters\n");
 }
 
@@ -460,8 +473,13 @@ static int bnxt_hwrm_ptp_cfg(struct bnxt *bp)
 	int rc = 0;
 
 	switch (ptp->rx_filter) {
+	case HWTSTAMP_FILTER_ALL:
+		flags = PORT_MAC_CFG_REQ_FLAGS_ALL_RX_TS_CAPTURE_ENABLE;
+		break;
 	case HWTSTAMP_FILTER_NONE:
 		flags = PORT_MAC_CFG_REQ_FLAGS_PTP_RX_TS_CAPTURE_DISABLE;
+		if (bp->fw_cap & BNXT_FW_CAP_RX_ALL_PKT_TS)
+			flags |= PORT_MAC_CFG_REQ_FLAGS_ALL_RX_TS_CAPTURE_DISABLE;
 		break;
 	case HWTSTAMP_FILTER_PTP_V2_EVENT:
 	case HWTSTAMP_FILTER_PTP_V2_SYNC:
@@ -516,6 +534,12 @@ int bnxt_hwtstamp_set(struct net_device *dev, struct ifreq *ifr)
 		ptp->rxctl = 0;
 		ptp->rx_filter = HWTSTAMP_FILTER_NONE;
 		break;
+	case HWTSTAMP_FILTER_ALL:
+		if (bp->fw_cap & BNXT_FW_CAP_RX_ALL_PKT_TS) {
+			ptp->rx_filter = HWTSTAMP_FILTER_ALL;
+			break;
+		}
+		return -EOPNOTSUPP;
 	case HWTSTAMP_FILTER_PTP_V2_EVENT:
 	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
 	case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
-- 
2.18.1


--000000000000c1047d05dedb995b
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEICI5bsn4LMAKsiR0Afo/srfhkBWTv1NB
Rk6luuoSazB0MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDUx
MzAyNDA0MlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQDTfmbW88d9yyIH+Y8hsnG/uktxl1tmdfNUxu1vFHqTaojlYb/v
PWJ56Uq1TqeouroKQrcV8zOeWKe4jTJx7nBHHQ5n9/l30WSUPnH/F2jBD3/laRZv0xU5bqcL8lj7
ZnUFl2Nn/94nuBovEbouDdCxW8RLr1kZwFeWCrz1D4iAGqn+ywp3gBJB3vZVJHQLtL+SqsqWlP6M
o0zX//EUhvl1zHhNcnpvLzxtHSicx/vNY+Jhey6JJKDenEJld6968EmMKvx8Bn8jgpJe4lsniPBP
uS7SXwGDnDpOIHJ0irn3CshfgTWzxYfK2TSknoHEg7F3VnGn6WExeT6Ia3tv2Hl6
--000000000000c1047d05dedb995b--
