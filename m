Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2F8047FADC
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 09:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbhL0IBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 03:01:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231658AbhL0IA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Dec 2021 03:00:59 -0500
Received: from mail-ua1-x933.google.com (mail-ua1-x933.google.com [IPv6:2607:f8b0:4864:20::933])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F8CC061401
        for <netdev@vger.kernel.org>; Mon, 27 Dec 2021 00:00:58 -0800 (PST)
Received: by mail-ua1-x933.google.com with SMTP id v12so13805714uar.7
        for <netdev@vger.kernel.org>; Mon, 27 Dec 2021 00:00:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WUIm1s+fXtr2DAYShVoLDIsQK5CyUbbl2KG6OIu7XCM=;
        b=WvXQIUoah24r+NjFdkcMr1KyG9fWdJXGaDM8MbCC7GxOSMGL0LERaTi1NX6gjmbF+/
         P+j5vkL6IMURSY0qb1GMZpxJxu7+SxzGiiU7Ko+mRTZ1+J6V2ffKYyQqUyDHX8hEdTQG
         +mDnsEafdE/3SY8IuQHnwc68/U6E1hz97E0eY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WUIm1s+fXtr2DAYShVoLDIsQK5CyUbbl2KG6OIu7XCM=;
        b=Ulglc1NR2w/Rat4XPeaWlcglUh2hL6cqo472lHh1LGSSz1izuJwiCxtoqUtcx4XQ/A
         qIAeyu1o3LFT1l4lyM8898zq8Y9IR3IR+bXD+qLHN3j6GMO5ooWSYKXatsEOdh6EPeaB
         oqSfmxhMevBIxRnXg60wgj68OExQY/+LgHjs/E7VxBsYUTLq/7qsiW585LUKxiJ68nf/
         T1LTpidqDg/5WmIxgkOrwXGdw6EQuH0EdYfhJtexQWhFiSzDfXKDsisHuyVKkr6zQ66D
         501t2nCgaaaeopmJhh+lIna2PSPJiU92xREP5usRE9njmet+7IiZuCTXqFHqK9YYL41+
         1BdQ==
X-Gm-Message-State: AOAM530EFpxFQ0i7eol66kZ6ToMG1mbMFVnHdJoUOG6TYevfAO2B0KWF
        BB8jorKGzr2tJcZOpEUJIRxI+esb7cRBSxZ7
X-Google-Smtp-Source: ABdhPJzlILoh5M+RqeIoOqp4mVx9Kf9CU/9ZEF+QN2S73AWkGQQP9uZTOdGkcFk28sxqo0nJTY/c3Q==
X-Received: by 2002:a05:6102:21c1:: with SMTP id r1mr3902293vsg.61.1640592057164;
        Mon, 27 Dec 2021 00:00:57 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o1sm2907587vkc.35.2021.12.27.00.00.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Dec 2021 00:00:56 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com,
        Vikas Gupta <vikas.gupta@broadcom.com>
Subject: [PATCH net-next 7/7] bnxt_en: Use page frag RX buffers for better software GRO performance
Date:   Mon, 27 Dec 2021 03:00:32 -0500
Message-Id: <1640592032-8927-8-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1640592032-8927-1-git-send-email-michael.chan@broadcom.com>
References: <1640592032-8927-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000d31b3b05d41c1aec"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000d31b3b05d41c1aec

From: Jakub Kicinski <kuba@kernel.org>

If NETIF_F_GRO_HW is disabled, the existing driver code uses kmalloc'ed
data for RX buffers.  This causes inefficient SW GRO performance
because the GRO data is merged using the less efficient frag_list.
Use netdev_alloc_frag() and friends instead so that GRO data can be
merged into skb_shinfo(skb)->frags for better performance.

[Use skb_free_frag() - Vikas Gupta]

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Reviewed-by: Andy Gospodarek <gospo@broadcom.com>
Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 27 +++++++++++++----------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index ea5b072ba292..4d7ea62e24fb 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -741,13 +741,16 @@ static struct page *__bnxt_alloc_rx_page(struct bnxt *bp, dma_addr_t *mapping,
 	return page;
 }
 
-static inline u8 *__bnxt_alloc_rx_data(struct bnxt *bp, dma_addr_t *mapping,
+static inline u8 *__bnxt_alloc_rx_frag(struct bnxt *bp, dma_addr_t *mapping,
 				       gfp_t gfp)
 {
 	u8 *data;
 	struct pci_dev *pdev = bp->pdev;
 
-	data = kmalloc(bp->rx_buf_size, gfp);
+	if (gfp == GFP_ATOMIC)
+		data = napi_alloc_frag(bp->rx_buf_size);
+	else
+		data = netdev_alloc_frag(bp->rx_buf_size);
 	if (!data)
 		return NULL;
 
@@ -756,7 +759,7 @@ static inline u8 *__bnxt_alloc_rx_data(struct bnxt *bp, dma_addr_t *mapping,
 					DMA_ATTR_WEAK_ORDERING);
 
 	if (dma_mapping_error(&pdev->dev, *mapping)) {
-		kfree(data);
+		skb_free_frag(data);
 		data = NULL;
 	}
 	return data;
@@ -779,7 +782,7 @@ int bnxt_alloc_rx_data(struct bnxt *bp, struct bnxt_rx_ring_info *rxr,
 		rx_buf->data = page;
 		rx_buf->data_ptr = page_address(page) + bp->rx_offset;
 	} else {
-		u8 *data = __bnxt_alloc_rx_data(bp, &mapping, gfp);
+		u8 *data = __bnxt_alloc_rx_frag(bp, &mapping, gfp);
 
 		if (!data)
 			return -ENOMEM;
@@ -1021,11 +1024,11 @@ static struct sk_buff *bnxt_rx_skb(struct bnxt *bp,
 		return NULL;
 	}
 
-	skb = build_skb(data, 0);
+	skb = build_skb(data, bp->rx_buf_size);
 	dma_unmap_single_attrs(&bp->pdev->dev, dma_addr, bp->rx_buf_use_size,
 			       bp->rx_dir, DMA_ATTR_WEAK_ORDERING);
 	if (!skb) {
-		kfree(data);
+		skb_free_frag(data);
 		return NULL;
 	}
 
@@ -1613,7 +1616,7 @@ static inline struct sk_buff *bnxt_tpa_end(struct bnxt *bp,
 		u8 *new_data;
 		dma_addr_t new_mapping;
 
-		new_data = __bnxt_alloc_rx_data(bp, &new_mapping, GFP_ATOMIC);
+		new_data = __bnxt_alloc_rx_frag(bp, &new_mapping, GFP_ATOMIC);
 		if (!new_data) {
 			bnxt_abort_tpa(cpr, idx, agg_bufs);
 			cpr->sw_stats.rx.rx_oom_discards += 1;
@@ -1624,13 +1627,13 @@ static inline struct sk_buff *bnxt_tpa_end(struct bnxt *bp,
 		tpa_info->data_ptr = new_data + bp->rx_offset;
 		tpa_info->mapping = new_mapping;
 
-		skb = build_skb(data, 0);
+		skb = build_skb(data, bp->rx_buf_size);
 		dma_unmap_single_attrs(&bp->pdev->dev, mapping,
 				       bp->rx_buf_use_size, bp->rx_dir,
 				       DMA_ATTR_WEAK_ORDERING);
 
 		if (!skb) {
-			kfree(data);
+			skb_free_frag(data);
 			bnxt_abort_tpa(cpr, idx, agg_bufs);
 			cpr->sw_stats.rx.rx_oom_discards += 1;
 			return NULL;
@@ -2796,7 +2799,7 @@ static void bnxt_free_one_rx_ring_skbs(struct bnxt *bp, int ring_nr)
 
 		tpa_info->data = NULL;
 
-		kfree(data);
+		skb_free_frag(data);
 	}
 
 skip_rx_tpa_free:
@@ -2822,7 +2825,7 @@ static void bnxt_free_one_rx_ring_skbs(struct bnxt *bp, int ring_nr)
 			dma_unmap_single_attrs(&pdev->dev, mapping,
 					       bp->rx_buf_use_size, bp->rx_dir,
 					       DMA_ATTR_WEAK_ORDERING);
-			kfree(data);
+			skb_free_frag(data);
 		}
 	}
 
@@ -3526,7 +3529,7 @@ static int bnxt_alloc_one_rx_ring(struct bnxt *bp, int ring_nr)
 		u8 *data;
 
 		for (i = 0; i < bp->max_tpa; i++) {
-			data = __bnxt_alloc_rx_data(bp, &mapping, GFP_KERNEL);
+			data = __bnxt_alloc_rx_frag(bp, &mapping, GFP_KERNEL);
 			if (!data)
 				return -ENOMEM;
 
-- 
2.18.1


--000000000000d31b3b05d41c1aec
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIMKB93XMyiNbs0q1EiRx5ErFg43FLWfp
d51ayZ4u6km0MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIxMTIy
NzA4MDA1N1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQC+WGod/gHmvumb3yazducTgCNO04SN07FlU0nfIFIHIKpKuN8F
pIJZYOHwW2oHc4gmwYUGDSZJooyrmtdG9xKUYfZnTqsQikJe/ltc3Zg4D/5tHFGQrbZ0E/NoheVn
Fck8ygCu1AfYU2UhKK7xpp0zfw5v8WEZWrvjFHMNdP0f36FPgAv8iQTwOYihOsRd7UFV/eb7Ph4/
YSk12sIsWbljW0I4xkqFZVDPO0vHh+ca/ruyEOpzWvfbgsL/A+HBt+cRRTEZ/8OClatE9TrllslD
tcD7a2jUKBmG61isrwybQQrTCmgRiLTv2fppyP6ZQXej+qYxi7y88Qc6GEnOXr/j
--000000000000d31b3b05d41c1aec--
