Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D07204F613D
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 16:15:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234110AbiDFN4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 09:56:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233802AbiDFN42 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 09:56:28 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D547826FEA2
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 19:54:18 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id z16so1264734pfh.3
        for <netdev@vger.kernel.org>; Tue, 05 Apr 2022 19:54:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=GH+USzk7fE5bm3Eo7XOh9RjtwU7QF0Elno8kZBb2f2Y=;
        b=bgbzl+g0wzaWzL0Cockuo6yEm/4HwnZK4Qr7n+b/QisqrBCSycfhgVKlC+g/6B85c4
         60snBrhlEANH3/RfZ3XlhjNPKVLZevYUpPOuZ+6zv/f8Ii8GEgFyxiLa4l0cku1UeIIA
         xaS7islHGOmmEHrZ6IGFApsRQE3XkryvmDBZY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=GH+USzk7fE5bm3Eo7XOh9RjtwU7QF0Elno8kZBb2f2Y=;
        b=hwGMm25pWY3gdoYshyGbdL6rZdJeIniwwgfJur1HgwqzMIs39hMG73AofqaqH4k6VC
         rRcZ6cSR2diPHbBswjnVogJ84tuevIVO+gDM5pC4Qscc4s4HPbJvWC42GiQHtDBksdkG
         chCv8iRvPMz2vxOBIN+JA0FUvtnO/mAv4yJ6GegtNp+92I/C5CCVBtOJmfWygMBLrEnJ
         8RI0j3JsxUmEYrFal+GJ3+eSS/9CgrulVM/z/Fb8DwfVBLt2389/wUMTBhfvhcLcFw9N
         1zsNjS1EWoPWcETKuCdtMp2B/WwyTovI+ZszZJAiICY1h8vd04CNnpaKqZBaj35QjiO5
         jiHw==
X-Gm-Message-State: AOAM5326kQ6w4k4foPr/8WDszEkt+NN1OMPqLGOTUWXisQe6AFTgHW4n
        khAAPkSWspcL+lbjRatLFnKOiA==
X-Google-Smtp-Source: ABdhPJxl1M41tRYlvXoIaduDHNpQeuF9bNF1jiwxAwEpgRKYaK7UI2WX32+PMP1t4iSfuHlM8DB+iw==
X-Received: by 2002:a63:f113:0:b0:399:370e:c1d5 with SMTP id f19-20020a63f113000000b00399370ec1d5mr5405793pgi.450.1649213657475;
        Tue, 05 Apr 2022 19:54:17 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x9-20020a17090a970900b001ca6c59b350sm3395111pjo.2.2022.04.05.19.54.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Apr 2022 19:54:17 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com,
        bpf@vger.kernel.org, john.fastabend@gmail.com, toke@redhat.com,
        lorenzo@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        echaudro@redhat.com, pabeni@redhat.com
Subject: [PATCH net-next v3 01/11] bnxt: refactor bnxt_rx_xdp to separate xdp_init_buff/xdp_prepare_buff
Date:   Tue,  5 Apr 2022 22:53:43 -0400
Message-Id: <1649213633-7662-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1649213633-7662-1-git-send-email-michael.chan@broadcom.com>
References: <1649213633-7662-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000004216e405dbf37ae1"
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        MIME_HEADER_CTYPE_ONLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,T_TVD_MIME_NO_HEADERS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--0000000000004216e405dbf37ae1

From: Andy Gospodarek <gospo@broadcom.com>

Move initialization of xdp_buff outside of bnxt_rx_xdp to prepare
for allowing bnxt_rx_xdp to operate on multibuffer xdp_buffs.

v2: Fix uninitalized variables warning in bnxt_xdp.c.
v3: Add new define BNXT_PAGE_MODE_BUF_SIZE

Signed-off-by: Andy Gospodarek <gospo@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 11 +++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  8 ++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c | 46 ++++++++++++++-----
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h |  7 ++-
 4 files changed, 53 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 874fad0a5cf8..826d94c49d26 100644
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
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 98453a78cbd0..0f35459d5206 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -591,10 +591,12 @@ struct nqe_cn {
 #define BNXT_RX_PAGE_SIZE (1 << BNXT_RX_PAGE_SHIFT)
 
 #define BNXT_MAX_MTU		9500
-#define BNXT_MAX_PAGE_MODE_MTU	\
+#define BNXT_PAGE_MODE_BUF_SIZE \
 	((unsigned int)PAGE_SIZE - VLAN_ETH_HLEN - NET_IP_ALIGN -	\
-	 XDP_PACKET_HEADROOM - \
-	 SKB_DATA_ALIGN((unsigned int)sizeof(struct skb_shared_info)))
+	 XDP_PACKET_HEADROOM)
+#define BNXT_MAX_PAGE_MODE_MTU	\
+	BNXT_PAGE_MODE_BUF_SIZE - \
+	SKB_DATA_ALIGN((unsigned int)sizeof(struct skb_shared_info))
 
 #define BNXT_MIN_PKT_SIZE	52
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index 03b1d6c04504..a3924e6030fe 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -106,18 +106,44 @@ void bnxt_tx_int_xdp(struct bnxt *bp, struct bnxt_napi *bnapi, int nr_pkts)
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
+	xdp_init_buff(xdp, BNXT_PAGE_MODE_BUF_SIZE + offset, &rxr->xdp_rxq);
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
@@ -128,16 +154,10 @@ bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
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
@@ -150,15 +170,17 @@ bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
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
@@ -177,6 +199,8 @@ bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
 		 * redirect is coming from a frame received by the
 		 * bnxt_en driver.
 		 */
+		rx_buf = &rxr->rx_buf_ring[cons];
+		mapping = rx_buf->mapping - bp->rx_dma_offset;
 		dma_unmap_page_attrs(&pdev->dev, mapping,
 				     PAGE_SIZE, bp->rx_dir,
 				     DMA_ATTR_WEAK_ORDERING);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h
index 067bb5e821f5..97e7905dbb20 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h
@@ -17,10 +17,15 @@ struct bnxt_sw_tx_bd *bnxt_xmit_bd(struct bnxt *bp,
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


--0000000000004216e405dbf37ae1
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIAeBFZ/+pleLo+vqXZe5EBAPD2IkbkPn
XNNfZ2WM75jAMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDQw
NjAyNTQxOFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQBE3N4AAykrn+AgLTWbLrMgUc/flp6JEeAnJT7sOSeRif6BAzuk
IAmn/yX4d6PDgK85+Gxn6ybk69vO0qBxmZkTp389Lm+AKfgzhRX7Mal5RHn6tUvogafMNeNkpEIl
TwZHUVMovCaHiRm5R21kcEr6jg81iaI8oihIEBXIRsnbEkJAsJyv9/OvWJg4pR7H2R49F2R9r9he
d6VhMCNIGoTI6QJ8A4X+PGWsikH8QG93OJw9l+9XfL2Y+ZIW5MFGycbAAS0OwM3NSnmcWWeOdYjn
gbD+na/9jL8YvOsNkEXzsJphWHCCOViQgx7hj9uhvKTDtiaRndYAxgglsMlAoDUI
--0000000000004216e405dbf37ae1--
