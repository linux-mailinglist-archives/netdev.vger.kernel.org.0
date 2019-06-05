Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB0A36689
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 23:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726859AbfFEVMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 17:12:21 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:41754 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726788AbfFEVMT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 17:12:19 -0400
Received: by mail-qt1-f196.google.com with SMTP id s57so223477qte.8
        for <netdev@vger.kernel.org>; Wed, 05 Jun 2019 14:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nKi3QVx46vMwLCyhP46A6+oWwEaywdjwqRcWLaG3ljo=;
        b=0o2WLjzzCVOmv6CHkZYxyMWh1Fu60IPmV7RcSJxvBTevbi4r6p/SqYeWMeWXOoeKAn
         3FXUAzgxLEaC9ZHJIn5+IN1/7Sdq3ExW+p8REnQIFZlJaz79qLAIZ/9khW4Av1pnzLtK
         u3df3bYFrIx2tYiSzkuyOOMS0qn2KYtcNPk2DqbKUkT41c3O3PgThb7MoxNU+d/wujc8
         kcfiuhcL6+NyfPajlSLFgPwmXoXb94Aka+5sodQV4RAhdcAQUEC8q5cxBCoEtDZEdoqD
         FzzeahZbTvQjBD97Q+WDBE8/UVIGj1IRAeTbwxJzAR8dS75J4n7f1oZQ6j9cZuTcIYI5
         ZNkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nKi3QVx46vMwLCyhP46A6+oWwEaywdjwqRcWLaG3ljo=;
        b=SeDkgszhK3rYjQ8cEdjv4MVWQVkFfiUuLljHZD/FOFF+SdqOfjaOCDD6hXSCTkRlgh
         VkSG3cu97O8nqhPvT3PYbh/smodDR3CNJ92TUjzI0jznQnJ1RUC3F6ik2JFuZ6p+gyDc
         3R9JLL2nyZKs6SHTtOyZG2q4XPutWaKU0xF0eSC1eFzuqIOv0hhyKfgenSO+WHHy7qn2
         fwfn8LjhXepGjKAdi3Hj3JU3XI5YC49+Q4rO5H/Ikv8ZJ4N7GsZQzvu/O+ICbVa6rtjb
         6QTVyVMd2FYq2ZdcrrtyWJBSa6V/tr4qguHicJAESUDf1t42zq5reAHWtlgLE/M+uweO
         tvmQ==
X-Gm-Message-State: APjAAAXGzd/tacO4IpW+ziv3AgrQQFUzcQZsZsl2IclkPlmSND5SgA3e
        jDaTBYXQJgaSITnJRQnx+9LBIg==
X-Google-Smtp-Source: APXvYqzJeQ8SggvkKYxGAG2qXkZ/Kw33BAfYkGdDFRmHZ2EhzuFQBmT1gcRBzLTADNfkACNbbB9T8A==
X-Received: by 2002:ac8:25e7:: with SMTP id f36mr25035783qtf.139.1559769138478;
        Wed, 05 Jun 2019 14:12:18 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id t20sm2933807qtr.7.2019.06.05.14.12.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 05 Jun 2019 14:12:17 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 11/13] nfp: tls: add datapath support for TLS TX
Date:   Wed,  5 Jun 2019 14:11:41 -0700
Message-Id: <20190605211143.29689-12-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190605211143.29689-1-jakub.kicinski@netronome.com>
References: <20190605211143.29689-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dirk van der Merwe <dirk.vandermerwe@netronome.com>

Prepend connection handle to each transmitted TLS packet.

For each connection, the driver tracks the next sequence number
expected. If an out of order packet is observed, the driver calls into
the TLS kernel code to reencrypt that particular skb.

Signed-off-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 .../ethernet/netronome/nfp/crypto/crypto.h    |  7 +++
 drivers/net/ethernet/netronome/nfp/nfp_net.h  |  2 +
 .../ethernet/netronome/nfp/nfp_net_common.c   | 56 +++++++++++++++++++
 3 files changed, 65 insertions(+)

diff --git a/drivers/net/ethernet/netronome/nfp/crypto/crypto.h b/drivers/net/ethernet/netronome/nfp/crypto/crypto.h
index 43aed51a8769..1f97fb443134 100644
--- a/drivers/net/ethernet/netronome/nfp/crypto/crypto.h
+++ b/drivers/net/ethernet/netronome/nfp/crypto/crypto.h
@@ -4,6 +4,13 @@
 #ifndef NFP_CRYPTO_H
 #define NFP_CRYPTO_H 1
 
+struct nfp_net_tls_offload_ctx {
+	__be32 fw_handle[2];
+
+	u32 next_seq;
+	bool out_of_sync;
+};
+
 #ifdef CONFIG_TLS_DEVICE
 int nfp_net_tls_init(struct nfp_net *nn);
 #else
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net.h b/drivers/net/ethernet/netronome/nfp/nfp_net.h
index 7010c9f1e676..689e9e1938c8 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net.h
@@ -459,6 +459,7 @@ struct nfp_stat_pair {
  * @netdev:		Backpointer to net_device structure
  * @is_vf:		Is the driver attached to a VF?
  * @chained_metadata_format:  Firemware will use new metadata format
+ * @ktls_tx:		Is kTLS TX enabled?
  * @rx_dma_dir:		Mapping direction for RX buffers
  * @rx_dma_off:		Offset at which DMA packets (for XDP headroom)
  * @rx_offset:		Offset in the RX buffers where packet data starts
@@ -483,6 +484,7 @@ struct nfp_net_dp {
 
 	u8 is_vf:1;
 	u8 chained_metadata_format:1;
+	u8 ktls_tx:1;
 
 	u8 rx_dma_dir;
 	u8 rx_offset;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index df21effec320..52f20f191eed 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -36,6 +36,7 @@
 #include <linux/vmalloc.h>
 #include <linux/ktime.h>
 
+#include <net/tls.h>
 #include <net/vxlan.h>
 
 #include "nfpcore/nfp_nsp.h"
@@ -801,6 +802,55 @@ static void nfp_net_tx_csum(struct nfp_net_dp *dp,
 	u64_stats_update_end(&r_vec->tx_sync);
 }
 
+#ifdef CONFIG_TLS_DEVICE
+static struct sk_buff *
+nfp_net_tls_tx(struct nfp_net_dp *dp, struct sk_buff *skb, u64 *tls_handle,
+	       int *nr_frags)
+{
+	struct nfp_net_tls_offload_ctx *ntls;
+	struct sk_buff *nskb;
+	u32 datalen, seq;
+
+	if (likely(!dp->ktls_tx))
+		return skb;
+	if (!skb->sk || !tls_is_sk_tx_device_offloaded(skb->sk))
+		return skb;
+
+	datalen = skb->len - (skb_transport_offset(skb) + tcp_hdrlen(skb));
+	seq = ntohl(tcp_hdr(skb)->seq);
+	ntls = tls_driver_ctx(skb->sk, TLS_OFFLOAD_CTX_DIR_TX);
+	if (unlikely(ntls->next_seq != seq || ntls->out_of_sync)) {
+		/* Pure ACK out of order already */
+		if (!datalen)
+			return skb;
+
+		nskb = tls_encrypt_skb(skb);
+		if (!nskb)
+			return NULL;
+		/* encryption wasn't necessary */
+		if (nskb == skb)
+			return skb;
+		/* we don't re-check ring space */
+		if (unlikely(skb_is_nonlinear(nskb))) {
+			nn_dp_warn(dp, "tls_encrypt_skb() produced fragmented frame\n");
+			dev_kfree_skb_any(nskb);
+			return NULL;
+		}
+
+		/* jump forward, a TX may have gotten lost, need to sync TX */
+		if (!ntls->out_of_sync && seq - ntls->next_seq < U32_MAX / 4)
+			ntls->out_of_sync = true;
+
+		*nr_frags = 0;
+		return nskb;
+	}
+
+	memcpy(tls_handle, ntls->fw_handle, sizeof(ntls->fw_handle));
+	ntls->next_seq += datalen;
+	return skb;
+}
+#endif
+
 static void nfp_net_tx_xmit_more_flush(struct nfp_net_tx_ring *tx_ring)
 {
 	wmb();
@@ -893,6 +943,12 @@ static int nfp_net_tx(struct sk_buff *skb, struct net_device *netdev)
 		return NETDEV_TX_BUSY;
 	}
 
+#ifdef CONFIG_TLS_DEVICE
+	skb = nfp_net_tls_tx(dp, skb, &tls_handle, &nr_frags);
+	if (unlikely(!skb))
+		goto err_flush;
+#endif
+
 	md_bytes = nfp_net_prep_tx_meta(skb, tls_handle);
 	if (unlikely(md_bytes < 0))
 		goto err_flush;
-- 
2.21.0

