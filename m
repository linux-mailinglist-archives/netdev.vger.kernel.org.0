Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 818484F607F
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 15:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233496AbiDFNd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 09:33:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233670AbiDFNcl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 09:32:41 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE7DC32FDEE
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 19:54:35 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id nt14-20020a17090b248e00b001ca601046a4so4561784pjb.0
        for <netdev@vger.kernel.org>; Tue, 05 Apr 2022 19:54:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=enHpgb3k1YKNc/UuJHLRD/30DriIhCoHjAmqc+kU2Jg=;
        b=G+mg9l/1QY8otwTXRlp9EHBeplVmq8I07itDXZApp34WfVNPIOfagD+IuSvoYgnfx7
         wfYqpKqNuAMtebhW2m+Z4PbnkDEVHpoQkZDxkgXf1Udb1L0b9SpFJt9baL6kXnRKHds/
         p2KndAAx6CRDAdWVshCp7Z3MwLCWb60xqABnY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=enHpgb3k1YKNc/UuJHLRD/30DriIhCoHjAmqc+kU2Jg=;
        b=gTC0KamSFzw6w5oeANf9Ku+VtAHQ6cpDdxRaVxnC+QI7dQAyEFLIYA857pW0nLpj/g
         O5MBcXWgrCHGn1TAGJnajMCNwyTAptX/LyKVBlKd1mfpOgWFXRPWeDGtBcbdr9rajAkD
         2O41vUccUO0I759hjs7K5HIa1HzIPAUMWbw7yzqrHJZ7IGuVyEEbzsSHP8dqoQJPHdhm
         cUzt5TpDL2TeBu8SPIFe3nJIk0gLSGi8k0j1M1YIhty1cCQyXJD8GTLfl7FU3HxDHEB9
         TJuN4ejc7pHaEiwljke48B3dftjNDdAbwiQxMKL4pul2c8Pg3yCujdkTWWhcRsBiWRIX
         jdag==
X-Gm-Message-State: AOAM531i8yqW8hiIsFJA5jpbb9/YHr+V3pkahSj9Zam9h13K7DTJWRvK
        A3fG37mAkdZ7jHKa4jnIUWYCLA==
X-Google-Smtp-Source: ABdhPJwys51AJvFEd9g1XwyVMeggj4LMrOiR5z5ea/n1N6zJPfcQDbp+eU8KUWmLiSExdoc0vZyUEw==
X-Received: by 2002:a17:90b:1a89:b0:1c6:4398:673 with SMTP id ng9-20020a17090b1a8900b001c643980673mr7638044pjb.40.1649213669206;
        Tue, 05 Apr 2022 19:54:29 -0700 (PDT)
Received: from localhost.swdvt.lab.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x9-20020a17090a970900b001ca6c59b350sm3395111pjo.2.2022.04.05.19.54.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Apr 2022 19:54:28 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com,
        bpf@vger.kernel.org, john.fastabend@gmail.com, toke@redhat.com,
        lorenzo@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        echaudro@redhat.com, pabeni@redhat.com
Subject: [PATCH net-next v3 09/11] bnxt: adding bnxt_xdp_build_skb to build skb from multibuffer xdp_buff
Date:   Tue,  5 Apr 2022 22:53:51 -0400
Message-Id: <1649213633-7662-10-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1649213633-7662-1-git-send-email-michael.chan@broadcom.com>
References: <1649213633-7662-1-git-send-email-michael.chan@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000f29f2105dbf37a66"
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

--000000000000f29f2105dbf37a66

From: Andy Gospodarek <gospo@broadcom.com>

Since we have an xdp_buff with frags there needs to be a way to
convert that into a valid sk_buff in the event that XDP_PASS is
the resulting operation.  This adds a new rx_skb_func when the
netdev has an MTU that prevents the packets from sitting in a
single page.

This also make sure that GRO/LRO stay disabled even when using
the aggregation ring for large buffers.

v3: Use BNXT_PAGE_MODE_BUF_SIZE for build_skb

Signed-off-by: Andy Gospodarek <gospo@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 65 +++++++++++++++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c | 23 +++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h |  4 ++
 3 files changed, 85 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index f89a45042f38..f96f41c7927e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -971,6 +971,39 @@ static void bnxt_reuse_rx_agg_bufs(struct bnxt_cp_ring_info *cpr, u16 idx,
 	rxr->rx_sw_agg_prod = sw_prod;
 }
 
+static struct sk_buff *bnxt_rx_multi_page_skb(struct bnxt *bp,
+					      struct bnxt_rx_ring_info *rxr,
+					      u16 cons, void *data, u8 *data_ptr,
+					      dma_addr_t dma_addr,
+					      unsigned int offset_and_len)
+{
+	unsigned int len = offset_and_len & 0xffff;
+	struct page *page = data;
+	u16 prod = rxr->rx_prod;
+	struct sk_buff *skb;
+	int err;
+
+	err = bnxt_alloc_rx_data(bp, rxr, prod, GFP_ATOMIC);
+	if (unlikely(err)) {
+		bnxt_reuse_rx_data(rxr, cons, data);
+		return NULL;
+	}
+	dma_addr -= bp->rx_dma_offset;
+	dma_unmap_page_attrs(&bp->pdev->dev, dma_addr, PAGE_SIZE, bp->rx_dir,
+			     DMA_ATTR_WEAK_ORDERING);
+	skb = build_skb(page_address(page), BNXT_PAGE_MODE_BUF_SIZE +
+					    bp->rx_dma_offset);
+	if (!skb) {
+		__free_page(page);
+		return NULL;
+	}
+	skb_mark_for_recycle(skb);
+	skb_reserve(skb, bp->rx_dma_offset);
+	__skb_put(skb, len);
+
+	return skb;
+}
+
 static struct sk_buff *bnxt_rx_page_skb(struct bnxt *bp,
 					struct bnxt_rx_ring_info *rxr,
 					u16 cons, void *data, u8 *data_ptr,
@@ -993,7 +1026,6 @@ static struct sk_buff *bnxt_rx_page_skb(struct bnxt *bp,
 	dma_addr -= bp->rx_dma_offset;
 	dma_unmap_page_attrs(&bp->pdev->dev, dma_addr, PAGE_SIZE, bp->rx_dir,
 			     DMA_ATTR_WEAK_ORDERING);
-	page_pool_release_page(rxr->page_pool, page);
 
 	if (unlikely(!payload))
 		payload = eth_get_headlen(bp->dev, data_ptr, len);
@@ -1004,6 +1036,7 @@ static struct sk_buff *bnxt_rx_page_skb(struct bnxt *bp,
 		return NULL;
 	}
 
+	skb_mark_for_recycle(skb);
 	off = (void *)data_ptr - page_address(page);
 	skb_add_rx_frag(skb, 0, page, off, len, PAGE_SIZE);
 	memcpy(skb->data - NET_IP_ALIGN, data_ptr - NET_IP_ALIGN,
@@ -1949,6 +1982,14 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 				rc = -ENOMEM;
 				goto next_rx;
 			}
+		} else {
+			skb = bnxt_xdp_build_skb(bp, skb, agg_bufs, rxr->page_pool, &xdp, rxcmp1);
+			if (!skb) {
+				/* we should be able to free the old skb here */
+				cpr->sw_stats.rx.rx_oom_discards += 1;
+				rc = -ENOMEM;
+				goto next_rx;
+			}
 		}
 	}
 
@@ -3964,14 +4005,21 @@ void bnxt_set_ring_params(struct bnxt *bp)
 int bnxt_set_rx_skb_mode(struct bnxt *bp, bool page_mode)
 {
 	if (page_mode) {
-		if (bp->dev->mtu > BNXT_MAX_PAGE_MODE_MTU)
-			return -EOPNOTSUPP;
-		bp->dev->max_mtu =
-			min_t(u16, bp->max_mtu, BNXT_MAX_PAGE_MODE_MTU);
 		bp->flags &= ~BNXT_FLAG_AGG_RINGS;
-		bp->flags |= BNXT_FLAG_NO_AGG_RINGS | BNXT_FLAG_RX_PAGE_MODE;
+		bp->flags |= BNXT_FLAG_RX_PAGE_MODE;
+
+		if (bp->dev->mtu > BNXT_MAX_PAGE_MODE_MTU) {
+			bp->flags |= BNXT_FLAG_JUMBO;
+			bp->rx_skb_func = bnxt_rx_multi_page_skb;
+			bp->dev->max_mtu =
+				min_t(u16, bp->max_mtu, BNXT_MAX_MTU);
+		} else {
+			bp->flags |= BNXT_FLAG_NO_AGG_RINGS;
+			bp->rx_skb_func = bnxt_rx_page_skb;
+			bp->dev->max_mtu =
+				min_t(u16, bp->max_mtu, BNXT_MAX_PAGE_MODE_MTU);
+		}
 		bp->rx_dir = DMA_BIDIRECTIONAL;
-		bp->rx_skb_func = bnxt_rx_page_skb;
 		/* Disable LRO or GRO_HW */
 		netdev_update_features(bp->dev);
 	} else {
@@ -11121,6 +11169,9 @@ static netdev_features_t bnxt_fix_features(struct net_device *dev,
 	if (bp->flags & BNXT_FLAG_NO_AGG_RINGS)
 		features &= ~(NETIF_F_LRO | NETIF_F_GRO_HW);
 
+	if (!(bp->flags & BNXT_FLAG_TPA))
+		features &= ~(NETIF_F_LRO | NETIF_F_GRO_HW);
+
 	if (!(features & NETIF_F_GRO))
 		features &= ~NETIF_F_GRO_HW;
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index a3924e6030fe..5183357ca11c 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -361,3 +361,26 @@ int bnxt_xdp(struct net_device *dev, struct netdev_bpf *xdp)
 	}
 	return rc;
 }
+
+struct sk_buff *
+bnxt_xdp_build_skb(struct bnxt *bp, struct sk_buff *skb, u8 num_frags,
+		   struct page_pool *pool, struct xdp_buff *xdp,
+		   struct rx_cmp_ext *rxcmp1)
+{
+	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
+
+	if (!skb)
+		return NULL;
+	skb_checksum_none_assert(skb);
+	if (RX_CMP_L4_CS_OK(rxcmp1)) {
+		if (bp->dev->features & NETIF_F_RXCSUM) {
+			skb->ip_summed = CHECKSUM_UNNECESSARY;
+			skb->csum_level = RX_CMP_ENCAP(rxcmp1);
+		}
+	}
+	xdp_update_skb_shared_info(skb, num_frags,
+				   sinfo->xdp_frags_size,
+				   PAGE_SIZE * sinfo->nr_frags,
+				   xdp_buff_is_frag_pfmemalloc(xdp));
+	return skb;
+}
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h
index 97e7905dbb20..27290f649be3 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h
@@ -28,4 +28,8 @@ bool bnxt_xdp_attached(struct bnxt *bp, struct bnxt_rx_ring_info *rxr);
 void bnxt_xdp_buff_init(struct bnxt *bp, struct bnxt_rx_ring_info *rxr,
 			u16 cons, u8 **data_ptr, unsigned int *len,
 			struct xdp_buff *xdp);
+struct sk_buff *bnxt_xdp_build_skb(struct bnxt *bp, struct sk_buff *skb,
+				   u8 num_frags, struct page_pool *pool,
+				   struct xdp_buff *xdp,
+				   struct rx_cmp_ext *rxcmp1);
 #endif
-- 
2.18.1


--000000000000f29f2105dbf37a66
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
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIPdDKxZ0sF61yRSXz9KtxNCdG3mJNITy
k4aykZ9oQ+y/MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDQw
NjAyNTQyOVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQAjisrWKg0EDUyqzfBBGVQTnLkprT9AF1FaQv6gql+ksI3RjltV
6IUEQyFNmD/Fo1zdJe0sEyCSSJa+9GbDcEnkJ+79zlX77q5UVH5yWDZmQ0kU7G+s9HlQwFAZ9H33
QVIwn/MG0N4EC9PWyEwykWwCxJJAaRjhvODFBQPG6Jpa0nM4IeFvSBfqseFzmkMbeHNCWBvkLaSQ
MfvqmLq5UWIbh7bD+UjaJFkS5w2fEc0TjToXBwhkDqmDY/4tn/cTjYIingo1kNiVj9uieIsWVSWH
FO61XWB6e7hqwSycK/zolyRgUwnx9DX3/6R81ZUi04f2ZZVjdD37mOoDiutqUirB
--000000000000f29f2105dbf37a66--
