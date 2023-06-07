Return-Path: <netdev+bounces-8733-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4CF0725692
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 09:56:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A4191280E86
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 07:56:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E1438BE7;
	Wed,  7 Jun 2023 07:54:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E2308C17
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 07:54:53 +0000 (UTC)
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D582712C
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 00:54:51 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id 6a1803df08f44-6261a25e9b6so54615196d6.0
        for <netdev@vger.kernel.org>; Wed, 07 Jun 2023 00:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1686124491; x=1688716491;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=LRKOglwD3AsGQYSa90njgP9irkgUlrrVJCiqcer2iww=;
        b=LkMrzPLcYOtSYc2qKLgV5jGPl56Nljwu+BX5ile/RTqz1fNytPtryX8hC10sOWYY+x
         OaaUsDk0kvSEeSWKyCevDam3G3dCc7P7hyfH+3JWgI68khe7m1JKQWXjThcynPlbxMxn
         /dDieFWv/9ZrTeO/K8IXrVNeZeYbHp+Z0tW2Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686124491; x=1688716491;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LRKOglwD3AsGQYSa90njgP9irkgUlrrVJCiqcer2iww=;
        b=OPebix8W6veEvkxBmICUMJtjaPeWpKr3XrQ3y1FTISDv+umhgO34k67qDvvi9Ty3Ni
         Q813GRm9ZmDfTjwhTOCGyn7dDbSmVOfuyYkcluuufA/Eon+r7CrCafFr6GBsMR/Npe47
         q+h+C3UYnAE/Lmb9gbr+p2Sge2EUvVSyT8ZnhEX5Wxr6Txx6T/CUHwyB1Fot0XJSPG+y
         GzECkGGkRP+/OUq8Nge/EhZzEfMKCX82Mgu3FQ4xNHZ7iyQln3AtyS7jHRP25EZwJgMD
         Dan/YbdsoOmapoEhxIWI+ctNtQb3Um7pTtBokeNAxMVIC0Ctdp1460RVxl5yuhnOtYRc
         mSaQ==
X-Gm-Message-State: AC+VfDzaeg2dsiMLXIPnH8I2H0p9MoNlpC/zdHDnzV2lS+vlpWrSBWrY
	KesBpvJjT7UaVWA4rHjLeejuUg==
X-Google-Smtp-Source: ACHHUZ7iuEv9G2oIvo94cbRUq+NJJN6H9iBE78rJjerQB22xksBpvH0ZKK0AgM4OhJEk2SnjWvrCJQ==
X-Received: by 2002:a05:6214:258b:b0:628:6879:ee34 with SMTP id fq11-20020a056214258b00b006286879ee34mr2814201qvb.46.1686124490758;
        Wed, 07 Jun 2023 00:54:50 -0700 (PDT)
Received: from lvnvda5233.lvn.broadcom.net ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id cs12-20020ad44c4c000000b00626362f1bf1sm5850817qvb.63.2023.06.07.00.54.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Jun 2023 00:54:50 -0700 (PDT)
From: Michael Chan <michael.chan@broadcom.com>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	gospo@broadcom.com,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Kalesh Anakkur Purayil <kalesh-anakkur.purayil@broadcom.com>
Subject: [PATCH net 6/6] bnxt_en: Implement .set_port / .unset_port UDP tunnel callbacks
Date: Wed,  7 Jun 2023 00:54:09 -0700
Message-Id: <20230607075409.228450-7-michael.chan@broadcom.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20230607075409.228450-1-michael.chan@broadcom.com>
References: <20230607075409.228450-1-michael.chan@broadcom.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000593c4905fd8573bd"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--000000000000593c4905fd8573bd
Content-Transfer-Encoding: 8bit

From: Somnath Kotur <somnath.kotur@broadcom.com>

As per the new udp tunnel framework, drivers which need to know the
details of a port entry (i.e. port type) when it gets deleted should
use the .set_port / .unset_port callbacks.

Implementing the current .udp_tunnel_sync callback would mean that the
deleted tunnel port entry would be all zeros.  This used to work on
older firmware because it would not check the input when deleting a
tunnel port.  With newer firmware, the delete will now fail and
subsequent tunnel port allocation will fail as a result.

Fixes: 442a35a5a7aa ("bnxt: convert to new udp_tunnel_nic infra")
Reviewed-by: Kalesh Anakkur Purayil <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Somnath Kotur <somnath.kotur@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 25 ++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index c0b0423de338..d5dc5ee70a48 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -13036,26 +13036,37 @@ static void bnxt_cfg_ntp_filters(struct bnxt *bp)
 
 #endif /* CONFIG_RFS_ACCEL */
 
-static int bnxt_udp_tunnel_sync(struct net_device *netdev, unsigned int table)
+static int bnxt_udp_tunnel_set_port(struct net_device *netdev, unsigned int table,
+				    unsigned int entry, struct udp_tunnel_info *ti)
 {
 	struct bnxt *bp = netdev_priv(netdev);
-	struct udp_tunnel_info ti;
 	unsigned int cmd;
 
-	udp_tunnel_nic_get_port(netdev, table, 0, &ti);
-	if (ti.type == UDP_TUNNEL_TYPE_VXLAN)
+	if (ti->type == UDP_TUNNEL_TYPE_VXLAN)
 		cmd = TUNNEL_DST_PORT_FREE_REQ_TUNNEL_TYPE_VXLAN;
 	else
 		cmd = TUNNEL_DST_PORT_FREE_REQ_TUNNEL_TYPE_GENEVE;
 
-	if (ti.port)
-		return bnxt_hwrm_tunnel_dst_port_alloc(bp, ti.port, cmd);
+	return bnxt_hwrm_tunnel_dst_port_alloc(bp, ti->port, cmd);
+}
+
+static int bnxt_udp_tunnel_unset_port(struct net_device *netdev, unsigned int table,
+				      unsigned int entry, struct udp_tunnel_info *ti)
+{
+	struct bnxt *bp = netdev_priv(netdev);
+	unsigned int cmd;
+
+	if (ti->type == UDP_TUNNEL_TYPE_VXLAN)
+		cmd = TUNNEL_DST_PORT_FREE_REQ_TUNNEL_TYPE_VXLAN;
+	else
+		cmd = TUNNEL_DST_PORT_FREE_REQ_TUNNEL_TYPE_GENEVE;
 
 	return bnxt_hwrm_tunnel_dst_port_free(bp, cmd);
 }
 
 static const struct udp_tunnel_nic_info bnxt_udp_tunnels = {
-	.sync_table	= bnxt_udp_tunnel_sync,
+	.set_port	= bnxt_udp_tunnel_set_port,
+	.unset_port	= bnxt_udp_tunnel_unset_port,
 	.flags		= UDP_TUNNEL_NIC_INFO_MAY_SLEEP |
 			  UDP_TUNNEL_NIC_INFO_OPEN_ONLY,
 	.tables		= {
-- 
2.30.1


--000000000000593c4905fd8573bd
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
OnaLEot1MoQO7BIe5S9H4AcCEXXcrJJiAtMCl47ARpyHmvQFQFFTrHgUYEd9V+9bOzY7MBIGSV1N
/JfsT1sZw6HT0lJkSQefhPGpBniAob62DJP3qr11tu8CAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQU31rAyTdZweIF0tJTFYwfOv2w
L4QwDQYJKoZIhvcNAQELBQADggEBACcuyaGmk0NSZ7Kio7O7WSZ0j0f9xXcBnLbJvQXFYM7JI5uS
kw5ozATEN5gfmNIe0AHzqwoYjAf3x8Dv2w7HgyrxWdpjTKQFv5jojxa3A5LVuM8mhPGZfR/L5jSk
5xc3llsKqrWI4ov4JyW79p0E99gfPA6Waixoavxvv1CZBQ4Stu7N660kTu9sJrACf20E+hdKLoiU
hd5wiQXo9B2ncm5P3jFLYLBmPltIn/uzdiYpFj+E9kS9XYDd+boBZhN1Vh0296zLQZobLfKFzClo
E6IFyTTANonrXvCRgodKS+QJEH8Syu2jSKe023aVemkuZjzvPK7o9iU7BKkPG2pzLPgxggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgxeQGjDntHGb2iaQkIw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIK23Nd6Qk8jt2GmlierGUfosc8oTAj9e
kqUTVTUFYHRBMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIzMDYw
NzA3NTQ1MVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQCeDpnswrqW+0ix+xpOX2+ICABLJ9XNqzOZ1nZ09GENHVG0Q2/w
YWxUDBDD3w9uNknOEZTLI8c5PwrHKPcBA8gQqPOvTIP/4leomKmbc/035KJLcck2wZZU2omXBNGM
wXsuKXGak2bnp56TPR0Pzw037dV8aDBMyyeVBmBdWc11hJT+mSeRyMjzTMVbrIdD99powKHCf5DZ
UX+MjfYXINNM528pbE71VFwJ1IWfYC4HBICKiS8Vk1oMQwQ0x88cLjon2G/4+JtzAVI9N6Nj9dJk
XQ8tLnscoo2qLQmngrmJcyMTHLq8ijBroZhm644E6DxzI4QGQKQ1bdwUuxUOcoRY
--000000000000593c4905fd8573bd--

