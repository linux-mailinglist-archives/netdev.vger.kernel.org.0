Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1A0401122
	for <lists+netdev@lfdr.de>; Sun,  5 Sep 2021 20:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238126AbhIESMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Sep 2021 14:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238112AbhIESMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Sep 2021 14:12:39 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E2BBC061575
        for <netdev@vger.kernel.org>; Sun,  5 Sep 2021 11:11:36 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id d3-20020a17090ae28300b0019629c96f25so3071201pjz.2
        for <netdev@vger.kernel.org>; Sun, 05 Sep 2021 11:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nikWqps1Cu6hl5mvWTSQn2dFuzKei25t4mc3AjH912w=;
        b=dYBR9rBGXVR7XU7j9AmoCiSUf9zTg0Hl0P3UBVPYkdyduzcZaz+2SIUGp2oMd7Wfmz
         Sr5M9uRlB2jEQ2Mqo5D5xacTkushy2nXfzdHg2/+hk6DHWZVL//cSMvnktdsTmFElhB0
         4Q+LMBoFYyLPKni7xvmbieoj93++y2SaCeFy0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nikWqps1Cu6hl5mvWTSQn2dFuzKei25t4mc3AjH912w=;
        b=XpEZpbR2oPyhL3sELRgw7fnoC2cnyoaxgVwcQzyazDicY2mHd31+oWBaBs3h+YRpvp
         aDnzbdXVAU0z7yMi48QIqonQDWMP1ZfTdLfa1G4onzrk39JrSNU74TnlJyOBCxLWszRO
         bRxIei5RKFLlDnsGFkxz1G7qqx6PMgl8cRZIjgC8vhRP9eISwHB7qShM8CH04C5LNGB7
         lDyonv1VDjVAm0ucx0rGlyOgZGLq0SPCmcJwNwIduwvUpcXKlC/7+FspGCaIhbTTGfAh
         70Ce0RlXXG9KwIa25oAONYVZccsnDdxy0V/u4Z/EyWyE5t0frn/elOy9S5vV0KFCLuOj
         DOpg==
X-Gm-Message-State: AOAM530HLAXSN7V8TYP+TGr1Xb0XhAUamGUmV2S1S7qGes2F6dkQtTLi
        A1xvFAk0Z1tsr2XoqnnvwvzwOw==
X-Google-Smtp-Source: ABdhPJyveefI41DcqL+r3ngU9IFZ7cAFSdA125C66TWkuQ092fd7Qi75ud4VVrzsmagctD2LRCeB7Q==
X-Received: by 2002:a17:903:18d:b0:138:7d06:dbca with SMTP id z13-20020a170903018d00b001387d06dbcamr7684600plg.19.1630865495038;
        Sun, 05 Sep 2021 11:11:35 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d13sm5058115pfn.114.2021.09.05.11.11.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 Sep 2021 11:11:34 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edwin.peer@broadcom.com,
        gospo@broadcom.com
Subject: [PATCH net 4/5] bnxt_en: Fix UDP tunnel logic
Date:   Sun,  5 Sep 2021 14:10:58 -0400
Message-Id: <1630865459-19146-5-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1630865459-19146-1-git-send-email-michael.chan@broadcom.com>
References: <1630865459-19146-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000008e0c6805cb437691"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000008e0c6805cb437691

The current logic assumes that when the driver sends the message to the
firmware to add the VXLAN or Geneve port, the firmware will never fail
the operation.  The UDP ports are always stored and are used to check
the tunnel packets in .ndo_features_check().  These tunnnel packets
will fail to offload on the transmit side if firmware fails the call to
add the UDP ports.

To fix the problem, bp->vxlan_port and bp->nge_port will only be set to
the offloaded ports when the HWRM_TUNNEL_DST_PORT_ALLOC firmware call
succeeds.  When deleting a UDP port, we check that the port was
previously added successfuly first by checking the FW ID.

Fixes: 1698d600b361 ("bnxt_en: Implement .ndo_features_check().")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 28 ++++++++++++++---------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index acaf1e0f049e..40a390652d8d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4641,6 +4641,13 @@ static int bnxt_hwrm_tunnel_dst_port_free(struct bnxt *bp, u8 tunnel_type)
 	struct hwrm_tunnel_dst_port_free_input *req;
 	int rc;
 
+	if (tunnel_type == TUNNEL_DST_PORT_FREE_REQ_TUNNEL_TYPE_VXLAN &&
+	    bp->vxlan_fw_dst_port_id == INVALID_HW_RING_ID)
+		return 0;
+	if (tunnel_type == TUNNEL_DST_PORT_FREE_REQ_TUNNEL_TYPE_GENEVE &&
+	    bp->nge_fw_dst_port_id == INVALID_HW_RING_ID)
+		return 0;
+
 	rc = hwrm_req_init(bp, req, HWRM_TUNNEL_DST_PORT_FREE);
 	if (rc)
 		return rc;
@@ -4650,10 +4657,12 @@ static int bnxt_hwrm_tunnel_dst_port_free(struct bnxt *bp, u8 tunnel_type)
 	switch (tunnel_type) {
 	case TUNNEL_DST_PORT_FREE_REQ_TUNNEL_TYPE_VXLAN:
 		req->tunnel_dst_port_id = cpu_to_le16(bp->vxlan_fw_dst_port_id);
+		bp->vxlan_port = 0;
 		bp->vxlan_fw_dst_port_id = INVALID_HW_RING_ID;
 		break;
 	case TUNNEL_DST_PORT_FREE_REQ_TUNNEL_TYPE_GENEVE:
 		req->tunnel_dst_port_id = cpu_to_le16(bp->nge_fw_dst_port_id);
+		bp->nge_port = 0;
 		bp->nge_fw_dst_port_id = INVALID_HW_RING_ID;
 		break;
 	default:
@@ -4691,10 +4700,12 @@ static int bnxt_hwrm_tunnel_dst_port_alloc(struct bnxt *bp, __be16 port,
 
 	switch (tunnel_type) {
 	case TUNNEL_DST_PORT_ALLOC_REQ_TUNNEL_TYPE_VXLAN:
+		bp->vxlan_port = port;
 		bp->vxlan_fw_dst_port_id =
 			le16_to_cpu(resp->tunnel_dst_port_id);
 		break;
 	case TUNNEL_DST_PORT_ALLOC_REQ_TUNNEL_TYPE_GENEVE:
+		bp->nge_port = port;
 		bp->nge_fw_dst_port_id = le16_to_cpu(resp->tunnel_dst_port_id);
 		break;
 	default:
@@ -8223,12 +8234,10 @@ static int bnxt_hwrm_port_qstats_ext(struct bnxt *bp, u8 flags)
 
 static void bnxt_hwrm_free_tunnel_ports(struct bnxt *bp)
 {
-	if (bp->vxlan_fw_dst_port_id != INVALID_HW_RING_ID)
-		bnxt_hwrm_tunnel_dst_port_free(
-			bp, TUNNEL_DST_PORT_FREE_REQ_TUNNEL_TYPE_VXLAN);
-	if (bp->nge_fw_dst_port_id != INVALID_HW_RING_ID)
-		bnxt_hwrm_tunnel_dst_port_free(
-			bp, TUNNEL_DST_PORT_FREE_REQ_TUNNEL_TYPE_GENEVE);
+	bnxt_hwrm_tunnel_dst_port_free(bp,
+		TUNNEL_DST_PORT_FREE_REQ_TUNNEL_TYPE_VXLAN);
+	bnxt_hwrm_tunnel_dst_port_free(bp,
+		TUNNEL_DST_PORT_FREE_REQ_TUNNEL_TYPE_GENEVE);
 }
 
 static int bnxt_set_tpa(struct bnxt *bp, bool set_tpa)
@@ -12627,13 +12636,10 @@ static int bnxt_udp_tunnel_sync(struct net_device *netdev, unsigned int table)
 	unsigned int cmd;
 
 	udp_tunnel_nic_get_port(netdev, table, 0, &ti);
-	if (ti.type == UDP_TUNNEL_TYPE_VXLAN) {
-		bp->vxlan_port = ti.port;
+	if (ti.type == UDP_TUNNEL_TYPE_VXLAN)
 		cmd = TUNNEL_DST_PORT_FREE_REQ_TUNNEL_TYPE_VXLAN;
-	} else {
-		bp->nge_port = ti.port;
+	else
 		cmd = TUNNEL_DST_PORT_FREE_REQ_TUNNEL_TYPE_GENEVE;
-	}
 
 	if (ti.port)
 		return bnxt_hwrm_tunnel_dst_port_alloc(bp, ti.port, cmd);
-- 
2.18.1


--0000000000008e0c6805cb437691
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIHPcinspoXQx62oIEQZh2AiX+XqJIEos
693/ka6dizyeMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDkw
NTE4MTEzNVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQDXlWU/nicj2bOoDRwT6f9NEShgoowlzIJqX+J5zrfY3KDR0pvd
/k/XwH+kM2V1zkD3r2723zte0r++ew177SclO4vnDHM2TuwHVkMKhVFs0Czpq5eTcTlY/feJCLdH
tFe5Mgiy1SK4b8XolIiKKMQEU6PPqKvp4S3dTEqMdSFid0eHvTa2JnIMYccxku4EVOUTlS0fLqcs
dX+D2tpk4N3h9ZWjJ4ljLFJ0Z+Fz1yH0JgfStYjB3d3lucYC6/qz+jDP5yFdzHBtSpOzD2UKjCte
Otkfu5EcfGQs1GPQi97TDtWjKlR6GIuO15FwaIKhZdrHPGR/CLZHJRVLJmUY5SKr
--0000000000008e0c6805cb437691--
