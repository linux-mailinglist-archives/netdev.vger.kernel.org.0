Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0B2A4E1A93
	for <lists+netdev@lfdr.de>; Sun, 20 Mar 2022 07:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244931AbiCTG75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Mar 2022 02:59:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244895AbiCTG7s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Mar 2022 02:59:48 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 264342E097
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 23:58:24 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id mr5-20020a17090b238500b001c67366ae93so9386040pjb.4
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 23:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=y+n2GvNPfrqxMgK+C7l53BKTE/2bPWWRrxT59S4J3Q8=;
        b=Af9IefCAJB95QDIoYBbuxZmhYy+Pnj2iZ/O0KrzCc2q3Y1o8xOUJopDykfrCiYBU+S
         Kxg9taBgaKiijOxYpd9LxJxxsOSSnaBKGQ/ZhNwcKHvBAf8mo2vCj8tE4D7NUDy5Gr8K
         36fXQH/rcqZjQ8fAfXhR4WIumIagK0I/dahF4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=y+n2GvNPfrqxMgK+C7l53BKTE/2bPWWRrxT59S4J3Q8=;
        b=ZuLMhcMzth5+SKbAYnjaWs/KQBEopBFcOpnAMqyvzSNjdsT2FKiJ5lwptIQy6Mdv6z
         69Jl3aEyK1hO7KX5/AfZnXEze3FnAEXqXu/ENLfFzdisVbyXj43G5BtR5r9oHJIJR3kw
         BUPtQNqMc3W+WA6aPugN7ctjX8w0/PRWHbAAv4P/yKv2yncTUYySJAYX8CKp3EgEACuT
         +uDJu1vgzDTpCLxFvwwOA/4YDEigIa6oCEsado+JnuNDSUoz13IqTWGCoDk1UPtEN28/
         YJCG7dACGfN5ytvMll8V7CHEAAsTKoR23ahrQppnjVRh/ywRyuL8LKeAskFI/IPcELs+
         xEtA==
X-Gm-Message-State: AOAM533UesdJuMDgB09iGEDykO3tf5VfB0LVXtr3whmdBrsCMDNuD+mA
        N9o/QDUmd5yfYSKjgXCoXF1U5GKQB1hduQ==
X-Google-Smtp-Source: ABdhPJzbV55N5Lqe5z1MedTYuAYRiilwICIEFUDsOvsIb6jI7TwgR+WfxlYlhBFx0oAXR8QMoLwXCA==
X-Received: by 2002:a17:90a:a795:b0:1b9:2f9a:c049 with SMTP id f21-20020a17090aa79500b001b92f9ac049mr19765032pjq.240.1647759503464;
        Sat, 19 Mar 2022 23:58:23 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q4-20020a056a00150400b004f78d4821a0sm15359334pfu.204.2022.03.19.23.58.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 19 Mar 2022 23:58:22 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 06/11] bnxt: set xdp_buff pfmemalloc flag if needed
Date:   Sun, 20 Mar 2022 02:57:48 -0400
Message-Id: <1647759473-2414-7-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1647759473-2414-1-git-send-email-michael.chan@broadcom.com>
References: <1647759473-2414-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000e7ef3805daa0e77e"
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        MIME_HEADER_CTYPE_ONLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,T_TVD_MIME_NO_HEADERS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000e7ef3805daa0e77e

From: Andy Gospodarek <gospo@broadcom.com>

Set the pfmemaloc flag in the xdp buff so that this can be
copied to the skb if needed for an XDP_PASS action.

Signed-off-by: Andy Gospodarek <gospo@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 4f42efeddb32..05f4b3fbf2e3 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1041,7 +1041,8 @@ static struct sk_buff *bnxt_rx_skb(struct bnxt *bp,
 static u32 __bnxt_rx_agg_pages(struct bnxt *bp,
 			       struct bnxt_cp_ring_info *cpr,
 			       struct skb_shared_info *shinfo,
-			       u16 idx, u32 agg_bufs, bool tpa)
+			       u16 idx, u32 agg_bufs, bool tpa,
+			       struct xdp_buff *xdp)
 {
 	struct bnxt_napi *bnapi = cpr->bnapi;
 	struct pci_dev *pdev = bp->pdev;
@@ -1084,6 +1085,9 @@ static u32 __bnxt_rx_agg_pages(struct bnxt *bp,
 		page = cons_rx_buf->page;
 		cons_rx_buf->page = NULL;
 
+		if (xdp && page_is_pfmemalloc(page))
+			xdp_buff_set_frag_pfmemalloc(xdp);
+
 		if (bnxt_alloc_rx_page(bp, rxr, prod, GFP_ATOMIC) != 0) {
 			unsigned int nr_frags;
 
@@ -1118,8 +1122,8 @@ static struct sk_buff *bnxt_rx_agg_pages_skb(struct bnxt *bp,
 	struct skb_shared_info *shinfo = skb_shinfo(skb);
 	u32 total_frag_len = 0;
 
-	total_frag_len = __bnxt_rx_agg_pages(bp, cpr, shinfo, idx, agg_bufs, tpa);
-
+	total_frag_len = __bnxt_rx_agg_pages(bp, cpr, shinfo, idx,
+					     agg_bufs, tpa, NULL);
 	if (!total_frag_len) {
 		dev_kfree_skb(skb);
 		return NULL;
@@ -1142,8 +1146,8 @@ static u32 bnxt_rx_agg_pages_xdp(struct bnxt *bp,
 	if (!xdp_buff_has_frags(xdp))
 		shinfo->nr_frags = 0;
 
-	total_frag_len = __bnxt_rx_agg_pages(bp, cpr, shinfo, idx, agg_bufs, tpa);
-
+	total_frag_len = __bnxt_rx_agg_pages(bp, cpr, shinfo,
+					     idx, agg_bufs, tpa, xdp);
 	if (total_frag_len) {
 		xdp_buff_set_frags_flag(xdp);
 		shinfo->nr_frags = agg_bufs;
-- 
2.18.1


--000000000000e7ef3805daa0e77e
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIGn8XP9yupHJfYyhuDJa+c/gzEm+e1Ud
jlLaM2x78J4LMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDMy
MDA2NTgyM1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQAosflhl7Y4EdzUxm+1nw7KqqiEptk9PUmhx5Eu22NZcKTiYtFc
kj1gPgI7HydWdbr7Pye8bMo7szgEkvxx4YKWklopdb7vfhf5QjO1gDzdaDl1y8bfe3+gVaA8sYOP
3ig/Aj66dfiR9FNuskhPG2lnvRq/klG3SVX1vbPZpomUTPYSS7v5jarsWS/ovqZRnnc7cZgdhLoK
xgPZ3aATsRxhsAmaSt9vN7t9ZaTzxIjPIICjfQxMYj7zt5x95XbV3mJhGObvK0l3bVZerRiR7tuF
rZSDjUwoOSyuKowGC/P97upeXduHfYuBjFz23rxOqQNuFM14Na5dR8v8LLNfkR9l
--000000000000e7ef3805daa0e77e--
