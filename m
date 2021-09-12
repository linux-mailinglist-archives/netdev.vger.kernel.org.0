Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7856D407EA6
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 18:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234846AbhILQgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 12:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbhILQgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Sep 2021 12:36:20 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33DF4C061574
        for <netdev@vger.kernel.org>; Sun, 12 Sep 2021 09:35:06 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id k24so7077531pgh.8
        for <netdev@vger.kernel.org>; Sun, 12 Sep 2021 09:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=YzrjhKXCaBWyEpJ6sywR8jtuAA7scEM4o6bsAn/2oKM=;
        b=FHatnFni0R4lmx1SCd4roSJw5uqWGoMEtMkjtpms9Z1bqnZ6V46M5O0EZwTLuhQrd6
         rwYtDrzQ/pJTYk5QJfsarjtLnZ6YOf/m8U9E1urx6ST1ycLWTfwv6ec2RU0iW7EUfn8u
         npjqo7Vy/L3FKHk/EBdDCFi6PD0fOoBHb1jeQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=YzrjhKXCaBWyEpJ6sywR8jtuAA7scEM4o6bsAn/2oKM=;
        b=YtMeE4AdH6MnbEftFJNhb7poYgh3n3eOFYRPDtz2IQVJwHviuh7CGDNj+ee3PM7T65
         cuows9hIRJ78Q01a9TuQ3VUTWLKdjKryMfBe7Oy/Kei1DxT40qTfryNCdNQwRDUv5C2u
         TqOP47g5IKBoFOZgQxTmG4753a3/LrwSpo74tfxwT15i/psRjqBdcqbMdrB6ptud1VxR
         QVhDMDHGLhpT5gQXxfuRwe+LRTpO/LhBsUI6xYJKohXgo9AaHzu059ksBsNslorAX99j
         W8bYLTFS7vEFbLp3kNUaoc4mSD0zRd9j2xx8gEl8HXuG24GsfCK9Pdzu5al19ED5mdKw
         jKCQ==
X-Gm-Message-State: AOAM532CHPYmMVrTvCHYxqe0OvDQD/u20lOwMEUWqQoACjwDEVXHbrAe
        7wHkosMl8t29glt5IE9h6A+hrw==
X-Google-Smtp-Source: ABdhPJwR5flhl1OO6rSfGBQvr5Xn3PdSsNiPXNT//Sc62mNalDRE8YZxkloum+ONaxOW8kh5rbUqtQ==
X-Received: by 2002:a63:e613:: with SMTP id g19mr7340376pgh.12.1631464505393;
        Sun, 12 Sep 2021 09:35:05 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l22sm5444224pgo.45.2021.09.12.09.35.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 12 Sep 2021 09:35:04 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, edwin.peer@broadcom.com,
        gospo@broadcom.com
Subject: [PATCH net 2/3] bnxt_en: make bnxt_free_skbs() safe to call after bnxt_free_mem()
Date:   Sun, 12 Sep 2021 12:34:48 -0400
Message-Id: <1631464489-8046-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1631464489-8046-1-git-send-email-michael.chan@broadcom.com>
References: <1631464489-8046-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000056d80a05cbceee08"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000056d80a05cbceee08

From: Edwin Peer <edwin.peer@broadcom.com>

The call to bnxt_free_mem(..., false) in the bnxt_half_open_nic() error
path will deallocate ring descriptor memory via bnxt_free_?x_rings(),
but because irq_re_init is false, the ring info itself is not freed.

To simplify error paths, deallocation functions have generally been
written to be safe when called on unallocated memory. It should always
be safe to call dev_close(), which calls bnxt_free_skbs() a second time,
even in this semi- allocated ring state.

Calling bnxt_free_skbs() a second time with the rings already freed will
cause NULL pointer dereference.  Fix it by checking the rings are valid
before proceeding in bnxt_free_tx_skbs() and
bnxt_free_one_rx_ring_skbs().

Fixes: 975bc99a4a39 ("bnxt_en: Refactor bnxt_free_rx_skbs().")
Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 8b0a2ae1367c..9f9806f1c0fc 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -2729,6 +2729,9 @@ static void bnxt_free_tx_skbs(struct bnxt *bp)
 		struct bnxt_tx_ring_info *txr = &bp->tx_ring[i];
 		int j;
 
+		if (!txr->tx_buf_ring)
+			continue;
+
 		for (j = 0; j < max_idx;) {
 			struct bnxt_sw_tx_bd *tx_buf = &txr->tx_buf_ring[j];
 			struct sk_buff *skb;
@@ -2813,6 +2816,9 @@ static void bnxt_free_one_rx_ring_skbs(struct bnxt *bp, int ring_nr)
 	}
 
 skip_rx_tpa_free:
+	if (!rxr->rx_buf_ring)
+		goto skip_rx_buf_free;
+
 	for (i = 0; i < max_idx; i++) {
 		struct bnxt_sw_rx_bd *rx_buf = &rxr->rx_buf_ring[i];
 		dma_addr_t mapping = rx_buf->mapping;
@@ -2835,6 +2841,11 @@ static void bnxt_free_one_rx_ring_skbs(struct bnxt *bp, int ring_nr)
 			kfree(data);
 		}
 	}
+
+skip_rx_buf_free:
+	if (!rxr->rx_agg_ring)
+		goto skip_rx_agg_free;
+
 	for (i = 0; i < max_agg_idx; i++) {
 		struct bnxt_sw_rx_agg_bd *rx_agg_buf = &rxr->rx_agg_ring[i];
 		struct page *page = rx_agg_buf->page;
@@ -2851,6 +2862,8 @@ static void bnxt_free_one_rx_ring_skbs(struct bnxt *bp, int ring_nr)
 
 		__free_page(page);
 	}
+
+skip_rx_agg_free:
 	if (rxr->rx_page) {
 		__free_page(rxr->rx_page);
 		rxr->rx_page = NULL;
-- 
2.18.1


--00000000000056d80a05cbceee08
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIJOgmiiE1lj+ljEftmZq/0ur9kMIQbgA
rRrjMhFL3oziMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDkx
MjE2MzUwNVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQB9rhXPqMBsSWsVwadFJ/fb3lzl8YYKjlWocYZ+Cpt6koaEw5E/
lmOBj8w3L1jtzf4ZY87CedYedkr1+OjnAGvLOj3UCKzDuyTWYvmenmWq8+zrH5W2V+LPbU4QK47F
JIpUwixd7wD51K2LKyRAuwcomnqhQsNjxWEA/s4Eh20S0LlDwk3YcN/XYr4LZxW1jzB6AKWJ+4T+
8Ah9/cjeOKpZJEhr+rJinQRN2YODhVHmkKHwAFa/iJ7Hd2JRe7lgr9RetpmWu4YCPvb/Gz5r3uSf
dG1HKlyKyiIczOIzxSsPDCHotmpWNVWimyJ7O+upxjMItiWtbvrdOAvmUxGTdNxX
--00000000000056d80a05cbceee08--
