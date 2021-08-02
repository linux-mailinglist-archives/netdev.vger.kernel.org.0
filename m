Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB5B3DDB90
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 16:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234573AbhHBOxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 10:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234582AbhHBOxQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 10:53:16 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ACCAC061796
        for <netdev@vger.kernel.org>; Mon,  2 Aug 2021 07:53:07 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id i10so19913828pla.3
        for <netdev@vger.kernel.org>; Mon, 02 Aug 2021 07:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QX2vSjul1Os022k30HUEn6xO1OUU3ULB8nfaxZXxWrc=;
        b=BwTWcbouozvDKQ/LXTDf7Wd/eD+9xcPgA9KgjVwaoiEaMceDxG+gmDcWeKm/S44WTu
         UOx70rneMi2RQPpgCf6ICgJDd/ExhuOqE9JaNU+OTgMYHIZCCSoyudVvYuKnb9jEo3T/
         1zRt7fowk2+QmlyXtoUBsDVPdS+whN6EPVcLQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QX2vSjul1Os022k30HUEn6xO1OUU3ULB8nfaxZXxWrc=;
        b=O590sZmut/uiXs2ZGZtvIe5a+xSjDUQDer4VDaT5qQkdw2pHHvvNOStROEmrrozZbX
         B6zfv4sG/ruehMw+7wavWvOPrPxSuOwqWmNuu+aNalMc4pcGP5EMXLGbA2dnwuQcmAIJ
         F/5nldOdpdnCJLJ7KaWI1nRKWRvxImNPMQ+n6lEw9guiXvMWkKGhiHeqZs9UhpEpe0qK
         0oEVHc5aXyUQFSqUfiOJXH4efnzZIqNxzn/8Y78UdQTYn1MqHs8oxxcqjEavY5tB0X6o
         PRv1JqGl8tm7vdOIlcO0kZnCfUKSgtYFbV7ddCvM66vD+RzUlEciQm0YOFHcZI7p1kSV
         oPnQ==
X-Gm-Message-State: AOAM530ucmEMvLvhIX+Rdm81yrQULiVfKYiURxUPs1YdoKVGtYSFVukv
        sPYNBYxBlr3gLGM29v/mDhfwIug9fWT9rQ==
X-Google-Smtp-Source: ABdhPJxjQs1c928faZnKD31l0WvZz65h8C7y2LbZB60iBe08Xk/8NDaq8NkpnwvtojCR5/L8pTVaxA==
X-Received: by 2002:a65:6a09:: with SMTP id m9mr2044915pgu.149.1627915986129;
        Mon, 02 Aug 2021 07:53:06 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j5sm13201832pgg.41.2021.08.02.07.53.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Aug 2021 07:53:05 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 2/2] bnxt_en: Increase maximum RX ring size if jumbo ring is not used
Date:   Mon,  2 Aug 2021 10:52:39 -0400
Message-Id: <1627915959-1648-3-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1627915959-1648-1-git-send-email-michael.chan@broadcom.com>
References: <1627915959-1648-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000001f15bf05c894ba51"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000001f15bf05c894ba51

The current maximum RX ring size is defined assuming the RX jumbo ring
(aka aggregation ring) is used.  The RX jumbo ring is automicatically used
when the MTU exceeds a threshold or when rx-gro-hw/lro is enabled.  The RX
jumbo ring is automatically sized up to 4 times the size of the RX ring
size.

The BNXT_MAX_RX_DESC_CNT constant is the upper limit on the size of the
RX ring whether or not the RX jumbo ring is used.  Obviously, the
maximum amount of RX buffer space is significantly less when the RX jumbo
ring is not used.

To increase flexibility for the user who does not use the RX jumbo ring,
we now define a bigger maximum RX ring size when the RX jumbo ring is not
used.  The maximum RX ring size is now up to 8K when the RX jumbo ring
is not used.  The maximum completion ring size also needs to be scaled
up to accomodate the larger maximum RX ring size.

Note that when the RX jumbo ring is re-enabled, the RX ring size will
automatically drop if it exceeds the maximum.

Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 10 ++++++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h         | 11 +++++++----
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  9 +++++++--
 3 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index cc758a66fac0..865fcb8cf29f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -3710,9 +3710,15 @@ void bnxt_set_ring_params(struct bnxt *bp)
 		if (jumbo_factor > agg_factor)
 			agg_factor = jumbo_factor;
 	}
-	agg_ring_size = ring_size * agg_factor;
+	if (agg_factor) {
+		if (ring_size > BNXT_MAX_RX_DESC_CNT_JUM_ENA) {
+			ring_size = BNXT_MAX_RX_DESC_CNT_JUM_ENA;
+			netdev_warn(bp->dev, "RX ring size reduced from %d to %d because the jumbo ring is now enabled\n",
+				    bp->rx_ring_size, ring_size);
+			bp->rx_ring_size = ring_size;
+		}
+		agg_ring_size = ring_size * agg_factor;
 
-	if (agg_ring_size) {
 		bp->rx_agg_nr_pages = bnxt_calc_nr_ring_pages(agg_ring_size,
 							RX_DESC_CNT);
 		if (bp->rx_agg_nr_pages > MAX_RX_AGG_PAGES) {
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index eba8d8f0ac81..9c3324e76ff7 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -596,15 +596,17 @@ struct nqe_cn {
 #define MAX_TPA_SEGS_P5	0x3f
 
 #if (BNXT_PAGE_SHIFT == 16)
-#define MAX_RX_PAGES	1
+#define MAX_RX_PAGES_AGG_ENA	1
+#define MAX_RX_PAGES	4
 #define MAX_RX_AGG_PAGES	4
 #define MAX_TX_PAGES	1
-#define MAX_CP_PAGES	8
+#define MAX_CP_PAGES	16
 #else
-#define MAX_RX_PAGES	8
+#define MAX_RX_PAGES_AGG_ENA	8
+#define MAX_RX_PAGES	32
 #define MAX_RX_AGG_PAGES	32
 #define MAX_TX_PAGES	8
-#define MAX_CP_PAGES	64
+#define MAX_CP_PAGES	128
 #endif
 
 #define RX_DESC_CNT (BNXT_PAGE_SIZE / sizeof(struct rx_bd))
@@ -622,6 +624,7 @@ struct nqe_cn {
 #define HW_CMPD_RING_SIZE (sizeof(struct tx_cmp) * CP_DESC_CNT)
 
 #define BNXT_MAX_RX_DESC_CNT		(RX_DESC_CNT * MAX_RX_PAGES - 1)
+#define BNXT_MAX_RX_DESC_CNT_JUM_ENA	(RX_DESC_CNT * MAX_RX_PAGES_AGG_ENA - 1)
 #define BNXT_MAX_RX_JUM_DESC_CNT	(RX_DESC_CNT * MAX_RX_AGG_PAGES - 1)
 #define BNXT_MAX_TX_DESC_CNT		(TX_DESC_CNT * MAX_TX_PAGES - 1)
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 786ca51e669b..485252d12245 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -768,8 +768,13 @@ static void bnxt_get_ringparam(struct net_device *dev,
 {
 	struct bnxt *bp = netdev_priv(dev);
 
-	ering->rx_max_pending = BNXT_MAX_RX_DESC_CNT;
-	ering->rx_jumbo_max_pending = BNXT_MAX_RX_JUM_DESC_CNT;
+	if (bp->flags & BNXT_FLAG_AGG_RINGS) {
+		ering->rx_max_pending = BNXT_MAX_RX_DESC_CNT_JUM_ENA;
+		ering->rx_jumbo_max_pending = BNXT_MAX_RX_JUM_DESC_CNT;
+	} else {
+		ering->rx_max_pending = BNXT_MAX_RX_DESC_CNT;
+		ering->rx_jumbo_max_pending = 0;
+	}
 	ering->tx_max_pending = BNXT_MAX_TX_DESC_CNT;
 
 	ering->rx_pending = bp->rx_ring_size;
-- 
2.18.1


--0000000000001f15bf05c894ba51
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIEuzeU+NxPlFnfcEoe/9FI0b2yslFppF
Fa84Yb6y7/5tMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDgw
MjE0NTMwNlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQC9nOr7PUP5cQtVWJtRxTQJg68ADNG4E/FunwBX7YHPzc64ET5l
/6vgf4y6d0hT7F+JfTLgDrk4tRVC6/dlGAMXVjbRh0b9hU4IQgUMWaYrBfhQfNkuGZ4YHeUD9SUr
gS+r6laz1+pgwsGrpPDvaDfE3oG2TlV+CZg7US2JWOgjxzr+cwhxLi6I5Iqz6jYvwVr/pw+PwnWn
tFfirNTu1cNl9OrmR2O/Q4ueeWO5izIbOzFGyGNnGTaKbzP1jzmRpN0+F3zFmNuuwrraydapm379
GDrkQCtaRZv5LBVIRwPuQhk9dSDWSazn4tqZO+RZyaTop0YZkq0ZsiQ/WX2N7k/J
--0000000000001f15bf05c894ba51--
