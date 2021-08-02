Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 836863DDB8F
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 16:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234581AbhHBOxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 10:53:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233925AbhHBOxN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 10:53:13 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AF0AC06175F
        for <netdev@vger.kernel.org>; Mon,  2 Aug 2021 07:53:04 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id e2-20020a17090a4a02b029016f3020d867so323359pjh.3
        for <netdev@vger.kernel.org>; Mon, 02 Aug 2021 07:53:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Unw/1dUOkFV+Y+5MwzCtczBIhLH6tSY0cbgzIrt1FCw=;
        b=NEuM+YOnqmZC90S/TZDDtGFrP1+WNVQiuEIMgisbceX7qU8mlvY86QbwaTacUe68Xa
         x2K0RmJ7NMv7b80qZyzzixNHd1RZZ+9cBUZej8Bvxt7/wMvHRQhGtmgoOq/1CcYTO/qK
         2eSIs7VmouwPxCfovF1852W/BXSI8PsIQFrHg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Unw/1dUOkFV+Y+5MwzCtczBIhLH6tSY0cbgzIrt1FCw=;
        b=U2lf+eIUU2sGw/RwQCHuBZzkzO6whJc94ZosDz8TKo/zT7SReSaO2Mf1ogKC8XnAUu
         K3L2Lvb+6F7/ctotYkDcWTtk/uYv85IE7XgvSBuP7RaOn395n0VQWelA6JOITyXaOGtD
         M24rzcgX+kgyw1OlwytC3N/rgGrd5v98YB6KD943PpPHC9Zmhh+1yGuWJiheu1ftVFgA
         mmNaC1TRkCyNrk2yV8OXq4GB3sGqDG2X/Y2jRbUp26hdsVP2eNRg5RH3A89E/imqrJ99
         prPaHh4rb/5jSPUnNwxkH44jF2aVVqOXs8sJ2EViJWbEX8HDXsVlkgWZfNM/z9jPRl4h
         yH3Q==
X-Gm-Message-State: AOAM533axEajeDoE/oUDxmQobw6CqjQSIDMbLGEWd/64DteBKulPahNn
        XtJIDc1+EbDV14BPAmhiOMOZMA==
X-Google-Smtp-Source: ABdhPJwMt0xCD4IszOS8db51tPh9PIQLgIGHVkopPYi0xAtIEmdrfB77r8g9rar7qaFwoQUFjhxk5A==
X-Received: by 2002:a05:6a00:1786:b029:32c:c315:7348 with SMTP id s6-20020a056a001786b029032cc3157348mr17475647pfg.42.1627915983034;
        Mon, 02 Aug 2021 07:53:03 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j5sm13201832pgg.41.2021.08.02.07.53.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Aug 2021 07:53:02 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next 1/2] bnxt_en: Don't use static arrays for completion ring pages
Date:   Mon,  2 Aug 2021 10:52:38 -0400
Message-Id: <1627915959-1648-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1627915959-1648-1-git-send-email-michael.chan@broadcom.com>
References: <1627915959-1648-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000f0071405c894b9b5"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000f0071405c894b9b5

We currently store these page addresses and DMA addreses in static
arrays.  On systems with 4K pages, we support up to 64 pages per
completion ring.  The actual number of pages for each completion ring
may be much less than 64.  For example, when the RX ring size is set
to the default 511 entries, only 16 completion ring pages are needed
per ring.

In the next patch, we'll be doubling the maximum number of completion
pages.  So we convert to allocate these arrays as needed instead of
declaring them statically.

Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 65 +++++++++++++++++++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  6 +--
 2 files changed, 68 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 03b821897cf3..cc758a66fac0 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -3163,6 +3163,58 @@ static int bnxt_alloc_tx_rings(struct bnxt *bp)
 	return 0;
 }
 
+static void bnxt_free_cp_arrays(struct bnxt_cp_ring_info *cpr)
+{
+	kfree(cpr->cp_desc_ring);
+	cpr->cp_desc_ring = NULL;
+	kfree(cpr->cp_desc_mapping);
+	cpr->cp_desc_mapping = NULL;
+}
+
+static int bnxt_alloc_cp_arrays(struct bnxt_cp_ring_info *cpr, int n)
+{
+	cpr->cp_desc_ring = kcalloc(n, sizeof(*cpr->cp_desc_ring), GFP_KERNEL);
+	if (!cpr->cp_desc_ring)
+		return -ENOMEM;
+	cpr->cp_desc_mapping = kcalloc(n, sizeof(*cpr->cp_desc_mapping),
+				       GFP_KERNEL);
+	if (!cpr->cp_desc_mapping)
+		return -ENOMEM;
+	return 0;
+}
+
+static void bnxt_free_all_cp_arrays(struct bnxt *bp)
+{
+	int i;
+
+	if (!bp->bnapi)
+		return;
+	for (i = 0; i < bp->cp_nr_rings; i++) {
+		struct bnxt_napi *bnapi = bp->bnapi[i];
+
+		if (!bnapi)
+			continue;
+		bnxt_free_cp_arrays(&bnapi->cp_ring);
+	}
+}
+
+static int bnxt_alloc_all_cp_arrays(struct bnxt *bp)
+{
+	int i, n = bp->cp_nr_pages;
+
+	for (i = 0; i < bp->cp_nr_rings; i++) {
+		struct bnxt_napi *bnapi = bp->bnapi[i];
+		int rc;
+
+		if (!bnapi)
+			continue;
+		rc = bnxt_alloc_cp_arrays(&bnapi->cp_ring, n);
+		if (rc)
+			return rc;
+	}
+	return 0;
+}
+
 static void bnxt_free_cp_rings(struct bnxt *bp)
 {
 	int i;
@@ -3190,6 +3242,7 @@ static void bnxt_free_cp_rings(struct bnxt *bp)
 			if (cpr2) {
 				ring = &cpr2->cp_ring_struct;
 				bnxt_free_ring(bp, &ring->ring_mem);
+				bnxt_free_cp_arrays(cpr2);
 				kfree(cpr2);
 				cpr->cp_ring_arr[j] = NULL;
 			}
@@ -3208,6 +3261,12 @@ static struct bnxt_cp_ring_info *bnxt_alloc_cp_sub_ring(struct bnxt *bp)
 	if (!cpr)
 		return NULL;
 
+	rc = bnxt_alloc_cp_arrays(cpr, bp->cp_nr_pages);
+	if (rc) {
+		bnxt_free_cp_arrays(cpr);
+		kfree(cpr);
+		return NULL;
+	}
 	ring = &cpr->cp_ring_struct;
 	rmem = &ring->ring_mem;
 	rmem->nr_pages = bp->cp_nr_pages;
@@ -3218,6 +3277,7 @@ static struct bnxt_cp_ring_info *bnxt_alloc_cp_sub_ring(struct bnxt *bp)
 	rc = bnxt_alloc_ring(bp, rmem);
 	if (rc) {
 		bnxt_free_ring(bp, rmem);
+		bnxt_free_cp_arrays(cpr);
 		kfree(cpr);
 		cpr = NULL;
 	}
@@ -4253,6 +4313,7 @@ static void bnxt_free_mem(struct bnxt *bp, bool irq_re_init)
 	bnxt_free_tx_rings(bp);
 	bnxt_free_rx_rings(bp);
 	bnxt_free_cp_rings(bp);
+	bnxt_free_all_cp_arrays(bp);
 	bnxt_free_ntp_fltrs(bp, irq_re_init);
 	if (irq_re_init) {
 		bnxt_free_ring_stats(bp);
@@ -4373,6 +4434,10 @@ static int bnxt_alloc_mem(struct bnxt *bp, bool irq_re_init)
 			goto alloc_mem_err;
 	}
 
+	rc = bnxt_alloc_all_cp_arrays(bp);
+	if (rc)
+		goto alloc_mem_err;
+
 	bnxt_init_ring_struct(bp);
 
 	rc = bnxt_alloc_rx_rings(bp);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index e379c48c1df9..eba8d8f0ac81 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -972,11 +972,11 @@ struct bnxt_cp_ring_info {
 	struct dim		dim;
 
 	union {
-		struct tx_cmp	*cp_desc_ring[MAX_CP_PAGES];
-		struct nqe_cn	*nq_desc_ring[MAX_CP_PAGES];
+		struct tx_cmp	**cp_desc_ring;
+		struct nqe_cn	**nq_desc_ring;
 	};
 
-	dma_addr_t		cp_desc_mapping[MAX_CP_PAGES];
+	dma_addr_t		*cp_desc_mapping;
 
 	struct bnxt_stats_mem	stats;
 	u32			hw_stats_ctx_id;
-- 
2.18.1


--000000000000f0071405c894b9b5
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIKqP6osPj9g+mkdaiN1/qiRPOpgqt0W3
FQMffcrNjgCrMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMDgw
MjE0NTMwM1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQCHsPkjfN57cIILU2e7oYacGMWVQIiwQx+Mg5gWKMZOED4adDzt
3j/4wPc05iGmYXq2u1Ule3+oFUN7HeSV4Bsu9e8oikRhMhdzVgpV9DqQ06V3qEVVKPsm1D/1Dbk/
xxBtet5/9gVTRJkXHgKI5TRE0FjIBjB2ClzIgRqCkkAP+EAERvPipIyJvfK5KafbIi9QVQIh3Vfj
h2cZAhfeJCr/XmYOw4jdzAN7OK6foFncR0BvW88XN4iVXr1Ek/fIsCoe9JabKUslaTdBMXqVMzEB
4uTM5odYKKqycWLWgjwo4AwNt7MH66ydkmAIW7z6oWOO3rpCdMtZnYJ+FSi16le5
--000000000000f0071405c894b9b5--
