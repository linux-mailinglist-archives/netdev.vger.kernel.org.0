Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 649EA4E1DA8
	for <lists+netdev@lfdr.de>; Sun, 20 Mar 2022 20:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343616AbiCTT7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Mar 2022 15:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241597AbiCTT7s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Mar 2022 15:59:48 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A8F034B82
        for <netdev@vger.kernel.org>; Sun, 20 Mar 2022 12:58:25 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id mr5-20020a17090b238500b001c67366ae93so10219478pjb.4
        for <netdev@vger.kernel.org>; Sun, 20 Mar 2022 12:58:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xupxeyOEVEDhKgImj+YBP0hX9Ushh8A7cl8JeAM5rKU=;
        b=Eo0qWh4qk9Sykr87QPfc5nIrJ7Hi4aZjas5gZPrKGI8RqSpEiORcFYfiMluHm5ydsl
         okEEegre5wV8zdYw2OWQaA1Sk/9Q1m0MkDrXFzj3YachiL/e6o3vYE8YUtwB2DVcm5oR
         8Wpg8a7Reoz9ImkBCBD+36sqmIfzJqfTnW7fo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xupxeyOEVEDhKgImj+YBP0hX9Ushh8A7cl8JeAM5rKU=;
        b=1cqMQVAKJD6y/1oJDjH8os6eJXWdPzctSLfhXEQ6GqjSc7OTXILEkwlqrro9iSuDP/
         nnMuu/wZvTtlMqsMEU6fT+j8kU6zWWrWF0Jn8mZAft3ZEnFIVOE+oSjalptPj9j0w99y
         RLeeTM3yEl6C0NtGcn6L5l5LXjJZP2l6kpoHCmb88zTjJEnp0d+932fcGsj4rhlR0Zg3
         O1lVpra0evoxtiy4rcoe+5zVjBdYqMSTk/B6yZHd6qMcTWo1AShBBcwvcVReUoP+gf1e
         pmpqWYgn/Am0VXn4GDa+Xjb6aHqKKgR2mWaqV/w5xG85LEGN+FXWrj/GUd3aQDoBouUT
         +WLw==
X-Gm-Message-State: AOAM5322Uv7jDpmrXiRugk/kipQjJpoY0AxE5lM1S5dfUZcOm5U8RpN6
        9cgAHY4Z0ELe5xuqd4Izm/gOVQ==
X-Google-Smtp-Source: ABdhPJwB2z30Bw4gVFhbETtQtzSeeGqZ5c0NihP4SLApbXRN8BmDGggCa72KUd1Ya0KVuyAL4pq7zw==
X-Received: by 2002:a17:90a:5a86:b0:1bf:7860:c0f6 with SMTP id n6-20020a17090a5a8600b001bf7860c0f6mr33042861pji.213.1647806304275;
        Sun, 20 Mar 2022 12:58:24 -0700 (PDT)
Received: from localhost.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h10-20020a056a001a4a00b004f7c76f29c3sm16418335pfv.24.2022.03.20.12.58.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 20 Mar 2022 12:58:23 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net-next v2 01/11] bnxt: refactor bnxt_rx_xdp to separate xdp_init_buff/xdp_prepare_buff
Date:   Sun, 20 Mar 2022 15:57:54 -0400
Message-Id: <1647806284-8529-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1647806284-8529-1-git-send-email-michael.chan@broadcom.com>
References: <1647806284-8529-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000074ca7a05daabcd62"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        MIME_HEADER_CTYPE_ONLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,T_TVD_MIME_NO_HEADERS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000074ca7a05daabcd62

From: Andy Gospodarek <gospo@broadcom.com>

Move initialization of xdp_buff outside of bnxt_rx_xdp to prepare
for allowing bnxt_rx_xdp to operate on multibuffer xdp_buffs.

v2: Fix uninitalized variables warning in bnxt_xdp.c.

Signed-off-by: Andy Gospodarek <gospo@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 11 +++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c | 46 ++++++++++++++-----
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h |  7 ++-
 3 files changed, 48 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 92a1a43b3bee..21d5c76b1e70 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1731,6 +1731,7 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 	u8 *data_ptr, agg_bufs, cmp_type;
 	dma_addr_t dma_addr;
 	struct sk_buff *skb;
+	struct xdp_buff xdp;
 	u32 flags, misc;
 	void *data;
 	int rc = 0;
@@ -1839,11 +1840,13 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 	len = flags >> RX_CMP_LEN_SHIFT;
 	dma_addr = rx_buf->mapping;
 
-	if (bnxt_rx_xdp(bp, rxr, cons, data, &data_ptr, &len, event)) {
-		rc = 1;
-		goto next_rx;
+	if (bnxt_xdp_attached(bp, rxr)) {
+		bnxt_xdp_buff_init(bp, rxr, cons, &data_ptr, &len, &xdp);
+		if (bnxt_rx_xdp(bp, rxr, cons, xdp, data, &len, event)) {
+			rc = 1;
+			goto next_rx;
+		}
 	}
-
 	if (len <= bp->rx_copy_thresh) {
 		skb = bnxt_copy_skb(bnapi, data_ptr, len, dma_addr);
 		bnxt_reuse_rx_data(rxr, cons, data);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index 52fad0fdeacf..55bd4b835ce3 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -104,18 +104,44 @@ void bnxt_tx_int_xdp(struct bnxt *bp, struct bnxt_napi *bnapi, int nr_pkts)
 	}
 }
 
+bool bnxt_xdp_attached(struct bnxt *bp, struct bnxt_rx_ring_info *rxr)
+{
+	struct bpf_prog *xdp_prog = READ_ONCE(rxr->xdp_prog);
+
+	return !!xdp_prog;
+}
+
+void bnxt_xdp_buff_init(struct bnxt *bp, struct bnxt_rx_ring_info *rxr,
+			u16 cons, u8 **data_ptr, unsigned int *len,
+			struct xdp_buff *xdp)
+{
+	struct bnxt_sw_rx_bd *rx_buf;
+	struct pci_dev *pdev;
+	dma_addr_t mapping;
+	u32 offset;
+
+	pdev = bp->pdev;
+	rx_buf = &rxr->rx_buf_ring[cons];
+	offset = bp->rx_offset;
+
+	mapping = rx_buf->mapping - bp->rx_dma_offset;
+	dma_sync_single_for_cpu(&pdev->dev, mapping + offset, *len, bp->rx_dir);
+
+	xdp_init_buff(xdp, PAGE_SIZE, &rxr->xdp_rxq);
+	xdp_prepare_buff(xdp, *data_ptr - offset, offset, *len, false);
+}
+
 /* returns the following:
  * true    - packet consumed by XDP and new buffer is allocated.
  * false   - packet should be passed to the stack.
  */
 bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
-		 struct page *page, u8 **data_ptr, unsigned int *len, u8 *event)
+		 struct xdp_buff xdp, struct page *page, unsigned int *len, u8 *event)
 {
 	struct bpf_prog *xdp_prog = READ_ONCE(rxr->xdp_prog);
 	struct bnxt_tx_ring_info *txr;
 	struct bnxt_sw_rx_bd *rx_buf;
 	struct pci_dev *pdev;
-	struct xdp_buff xdp;
 	dma_addr_t mapping;
 	void *orig_data;
 	u32 tx_avail;
@@ -126,16 +152,10 @@ bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
 		return false;
 
 	pdev = bp->pdev;
-	rx_buf = &rxr->rx_buf_ring[cons];
 	offset = bp->rx_offset;
 
-	mapping = rx_buf->mapping - bp->rx_dma_offset;
-	dma_sync_single_for_cpu(&pdev->dev, mapping + offset, *len, bp->rx_dir);
-
 	txr = rxr->bnapi->tx_ring;
 	/* BNXT_RX_PAGE_MODE(bp) when XDP enabled */
-	xdp_init_buff(&xdp, PAGE_SIZE, &rxr->xdp_rxq);
-	xdp_prepare_buff(&xdp, *data_ptr - offset, offset, *len, false);
 	orig_data = xdp.data;
 
 	act = bpf_prog_run_xdp(xdp_prog, &xdp);
@@ -148,15 +168,17 @@ bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
 		*event &= ~BNXT_RX_EVENT;
 
 	*len = xdp.data_end - xdp.data;
-	if (orig_data != xdp.data) {
+	if (orig_data != xdp.data)
 		offset = xdp.data - xdp.data_hard_start;
-		*data_ptr = xdp.data_hard_start + offset;
-	}
+
 	switch (act) {
 	case XDP_PASS:
 		return false;
 
 	case XDP_TX:
+		rx_buf = &rxr->rx_buf_ring[cons];
+		mapping = rx_buf->mapping - bp->rx_dma_offset;
+
 		if (tx_avail < 1) {
 			trace_xdp_exception(bp->dev, xdp_prog, act);
 			bnxt_reuse_rx_data(rxr, cons, page);
@@ -175,6 +197,8 @@ bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
 		 * redirect is coming from a frame received by the
 		 * bnxt_en driver.
 		 */
+		rx_buf = &rxr->rx_buf_ring[cons];
+		mapping = rx_buf->mapping - bp->rx_dma_offset;
 		dma_unmap_page_attrs(&pdev->dev, mapping,
 				     PAGE_SIZE, bp->rx_dir,
 				     DMA_ATTR_WEAK_ORDERING);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h
index 0df40c3beb05..39690bdb5526 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h
@@ -15,10 +15,15 @@ struct bnxt_sw_tx_bd *bnxt_xmit_bd(struct bnxt *bp,
 				   dma_addr_t mapping, u32 len);
 void bnxt_tx_int_xdp(struct bnxt *bp, struct bnxt_napi *bnapi, int nr_pkts);
 bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
-		 struct page *page, u8 **data_ptr, unsigned int *len,
+		 struct xdp_buff xdp, struct page *page, unsigned int *len,
 		 u8 *event);
 int bnxt_xdp(struct net_device *dev, struct netdev_bpf *xdp);
 int bnxt_xdp_xmit(struct net_device *dev, int num_frames,
 		  struct xdp_frame **frames, u32 flags);
 
+bool bnxt_xdp_attached(struct bnxt *bp, struct bnxt_rx_ring_info *rxr);
+
+void bnxt_xdp_buff_init(struct bnxt *bp, struct bnxt_rx_ring_info *rxr,
+			u16 cons, u8 **data_ptr, unsigned int *len,
+			struct xdp_buff *xdp);
 #endif
-- 
2.18.1


--00000000000074ca7a05daabcd62
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIJkucJuJVneT5CfO6ocBxyAaso3etNeu
UV8V7Szx8VmnMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDMy
MDE5NTgyNFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQBn9zafr1E0YBBgYbZlPx20XzhNXboP9xcmuO3gk+isKmx7vlD8
nrAFRIG9B2acmuyRStZtSWJPDiLkcFOmvUmQUpSpBMsRE4RQdXQEc87ekvt6UEdckF5KREZNhck9
JYFg3JRSJBPsMGkGOeVI6pKXk8q2xOLnPK7YEdF4KmVKUa9/Kk2HUJbQjE2cfdXvf5ABgGDG5rby
0GmHFZYSv7G4S4/gFS7HzID7VEA++tvy3puHVWD7tfNnupoEU2aBkESTlWcnPkzlqWPe9ApZcbol
n+3aQi2IIyN3WSJnox8ccyvs8DhxIo8zlUGQHq4mHZL7NWkaQVYNo57W1ry6RSpq
--00000000000074ca7a05daabcd62--
