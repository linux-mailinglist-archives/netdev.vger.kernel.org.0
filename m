Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06B9D36A8A4
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 19:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbhDYRqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 13:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231204AbhDYRqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 13:46:34 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B9ECC06175F
        for <netdev@vger.kernel.org>; Sun, 25 Apr 2021 10:45:54 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id w10so1189309pgh.5
        for <netdev@vger.kernel.org>; Sun, 25 Apr 2021 10:45:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=wme/HDHW2eypWIqtZjhzgM98dyBQaq4rbPJZ43Ah7Nw=;
        b=cM7GeUS8tVtQhpYT1vVbNiHR7+UPXnaIY32RcxvT8X4mDcdfK3BnXoyR8DjQIpS1F5
         ozg3HSBmSvXvyTeM0eYXw5kpgfolfqVIitcm0kn5K4XYKaJqX21TA0wqw8bVn2pPJAMH
         P8D9oCJmkbxP4xL7T1hhGtnVcmcoiHDVuCTyY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=wme/HDHW2eypWIqtZjhzgM98dyBQaq4rbPJZ43Ah7Nw=;
        b=f5jwBBG1MThaV8/139zAXCGwi2GRi9VBLtaNovvEs84LW21ab33Gru2PiIR28GQ6Oy
         HJyjg7W44z/ypT6kP0eYrfVQ9QczdKS15VC8BmcsbTpo984zPe74TOlL1TRTKv8tHesk
         X5aEK/OYfjvX52I+WgyPxyO0o8pNbWNxs+eYIWVU3/7Ku6MTFOOeMB2WbNjhS/5cqxGX
         mj1tHMC7nmydwZONlLjCXe/T29Xwm9OTrN0Ux6Jntej1LIWO1G3PLjMpBsc+awsRwEqR
         BX/hzyqwRGDJYCKIhktWF+CVJzAFvtnI5eQVV7i2yxeCpUx3P8PznFsVYSRc6vIN3mrl
         sWsQ==
X-Gm-Message-State: AOAM533lth0OWpR3Za0dfiUrmrWqSaeDECV7X3x12eDxLx7DRmD8Ap8S
        i1NV5vILJDn4PBWfhFM3Ui9Msym+9SQTNu2h
X-Google-Smtp-Source: ABdhPJwAkcV9NvCpoHrN/3/K+FspjTPcS+QBb3KD0+fzD1STx564rtfut1gCZ2XIsIfbt2heLweNlg==
X-Received: by 2002:a63:5b5c:: with SMTP id l28mr13153128pgm.363.1619372753821;
        Sun, 25 Apr 2021 10:45:53 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t19sm14733553pjs.1.2021.04.25.10.45.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 25 Apr 2021 10:45:53 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next v2 10/10] bnxt_en: Implement .ndo_features_check().
Date:   Sun, 25 Apr 2021 13:45:27 -0400
Message-Id: <1619372727-19187-11-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1619372727-19187-1-git-send-email-michael.chan@broadcom.com>
References: <1619372727-19187-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000c76b4005c0cf997d"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000c76b4005c0cf997d

For UDP encapsultions, we only support the offloaded Vxlan port and
Geneve port.  All other ports included FOU and GUE are not supported so
we need to turn off TSO and checksum features.

v2: Reverse the check for supported UDP ports to be more straight forward.

Reviewed-by: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 42 +++++++++++++++++++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  2 ++
 2 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 53db073b457c..5d0ab5629aa4 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10781,6 +10781,40 @@ static int bnxt_set_features(struct net_device *dev, netdev_features_t features)
 	return rc;
 }
 
+static netdev_features_t bnxt_features_check(struct sk_buff *skb,
+					     struct net_device *dev,
+					     netdev_features_t features)
+{
+	struct bnxt *bp;
+	__be16 udp_port;
+	u8 l4_proto = 0;
+
+	features = vlan_features_check(skb, features);
+	if (!skb->encapsulation)
+		return features;
+
+	switch (vlan_get_protocol(skb)) {
+	case htons(ETH_P_IP):
+		l4_proto = ip_hdr(skb)->protocol;
+		break;
+	case htons(ETH_P_IPV6):
+		l4_proto = ipv6_hdr(skb)->nexthdr;
+		break;
+	default:
+		return features;
+	}
+
+	if (l4_proto != IPPROTO_UDP)
+		return features;
+
+	bp = netdev_priv(dev);
+	/* For UDP, we can only handle 1 Vxlan port and 1 Geneve port. */
+	udp_port = udp_hdr(skb)->dest;
+	if (udp_port == bp->vxlan_port || udp_port == bp->nge_port)
+		return features;
+	return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+}
+
 int bnxt_dbg_hwrm_rd_reg(struct bnxt *bp, u32 reg_off, u16 num_words,
 			 u32 *reg_buf)
 {
@@ -12288,10 +12322,13 @@ static int bnxt_udp_tunnel_sync(struct net_device *netdev, unsigned int table)
 	unsigned int cmd;
 
 	udp_tunnel_nic_get_port(netdev, table, 0, &ti);
-	if (ti.type == UDP_TUNNEL_TYPE_VXLAN)
+	if (ti.type == UDP_TUNNEL_TYPE_VXLAN) {
+		bp->vxlan_port = ti.port;
 		cmd = TUNNEL_DST_PORT_FREE_REQ_TUNNEL_TYPE_VXLAN;
-	else
+	} else {
+		bp->nge_port = ti.port;
 		cmd = TUNNEL_DST_PORT_FREE_REQ_TUNNEL_TYPE_GENEVE;
+	}
 
 	if (ti.port)
 		return bnxt_hwrm_tunnel_dst_port_alloc(bp, ti.port, cmd);
@@ -12391,6 +12428,7 @@ static const struct net_device_ops bnxt_netdev_ops = {
 	.ndo_change_mtu		= bnxt_change_mtu,
 	.ndo_fix_features	= bnxt_fix_features,
 	.ndo_set_features	= bnxt_set_features,
+	.ndo_features_check	= bnxt_features_check,
 	.ndo_tx_timeout		= bnxt_tx_timeout,
 #ifdef CONFIG_BNXT_SRIOV
 	.ndo_get_vf_config	= bnxt_get_vf_config,
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index a3744247740b..24d2ad6a8740 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1914,6 +1914,8 @@ struct bnxt {
 
 	u16			vxlan_fw_dst_port_id;
 	u16			nge_fw_dst_port_id;
+	__be16			vxlan_port;
+	__be16			nge_port;
 	u8			port_partition_type;
 	u8			port_count;
 	u16			br_mode;
-- 
2.18.1


--000000000000c76b4005c0cf997d
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEINcV8Km/aZOFjheyJH4n+Ky4TNAp3Of5
bt49CgqILBaTMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDQy
NTE3NDU1NFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQDQ/rTeWV0P86Z4qbeeXcVriabbVSNHAYMNx7igo+9zRihZzW6Y
rp80cY9DkLOjVSgTp6mqMwTiafsHQrHuaAFGUCycUzuymkVW6VpCnJ5tzi3u2BijWDbcSwbc1tgF
4Ry2rduGXbSZxFOXo71pAOydQ1qiHyf1k6k5oF7196VLvGA9BTpE7uEVnpD7YWQvKMDG2PgwUc3X
L+uP5Gdd5m7TUNYRlHETjg9OKF4AeiRNdwfjP6ooh9OxWDMfWb9E8dFovzVQpnxfkHPBguZXYRjl
hLaB+U7RKZDol/4w4BEsX0QQ2BiRXt5+hQBHvGR8Uc/60q8jsBpwk1696A7JJz+h
--000000000000c76b4005c0cf997d--
