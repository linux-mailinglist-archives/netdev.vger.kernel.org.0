Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1AF3C271
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 06:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391119AbfFKElB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 00:41:01 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:38348 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391097AbfFKEk6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 00:40:58 -0400
Received: by mail-qt1-f196.google.com with SMTP id n11so10886583qtl.5
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 21:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x3PEPlQFtgWt1tWETsWNiGDwvToNs5Y3jA4BPjMW08M=;
        b=dblg7uoCA4RwlwWSKWoyajjM+mGq9qIgvWed5TTAqvRXxWcuDhIRdyEYejIhiOGQL0
         vfGVrNI6pNE5doV20QZyjukd77wvHXvxQsGLT3jjuwtOeDf5p2CX5wpIezEHiufqV0CH
         w0Gb0nvd6cZKUQSr2BNRs37wHAfRqUSpSwc3YqRtWkbpoIBZvmwnRY6Pu6g6yr8QGIdj
         mktzGjEnfhrlk5TzVhxU3xruHYFZTlTczR2ep20Fhg7hYNEmihLQlfuTTidZQIopGSNj
         aJ2nDwIFmKSFF542uXmMj00Iiujd2awxeWLPvXRwiKlH575aN91t3uJbOmtfeHFf+HeL
         iOeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x3PEPlQFtgWt1tWETsWNiGDwvToNs5Y3jA4BPjMW08M=;
        b=e6xK6PCYaX2+xF7aZekfYB64DUV1wwIje60v+rNqxKM98vSykngOICYIz3k0wXTmYT
         NY80Y1WWyRjOy2wAfsODNkpvqYVSVDN4oIEcBWgyXkEkom4JaiGZMxAO5q83W3KsfFod
         fD4RB+fgVhyD5PHMNl2P9/7EJ0LTwIXSTGHHUTm1XQLu6pZRX6Gk3/2+nFOnYqyy8lRw
         3JuV30kF88TY940+NZmePHH3KjHDH51ll/4I2E+mo7n/YXHGuAlQBWg+aJwd2xk/02ZU
         EivFkTwqNjY04dxNSXR2EPgB9VyIueB9gM952yC2cKQtOEbnraprR/tolVBfS2mZFvBw
         Y3Pg==
X-Gm-Message-State: APjAAAWWG2x6nkOXKFHi3LYzyfnv6elFFdWD1mfa6Wji13NrMfPfsygR
        Vm2kO+EXSKq76g2WK79uYeSHGg==
X-Google-Smtp-Source: APXvYqxrqX7DBWml/6yXi6jLYYWjtnzqjeHXargZ6oFGhR3dN0SN+oiimzQWDW5hAX+LcpvCb9//aw==
X-Received: by 2002:ac8:373b:: with SMTP id o56mr64195114qtb.133.1560228057013;
        Mon, 10 Jun 2019 21:40:57 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y3sm2463375qtj.46.2019.06.10.21.40.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Jun 2019 21:40:56 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com, davejwatson@fb.com,
        borisp@mellanox.com,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 05/12] nfp: tls: set skb decrypted flag
Date:   Mon, 10 Jun 2019 21:40:03 -0700
Message-Id: <20190611044010.29161-6-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190611044010.29161-1-jakub.kicinski@netronome.com>
References: <20190611044010.29161-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dirk van der Merwe <dirk.vandermerwe@netronome.com>

Firmware indicates when a packet has been decrypted by reusing the
currently unused BPF flag.  Transfer this information into the skb
and provide a statistic of all decrypted segments.

Signed-off-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 drivers/net/ethernet/netronome/nfp/nfp_net.h   |  4 +++-
 .../ethernet/netronome/nfp/nfp_net_common.c    |  9 +++++++++
 .../ethernet/netronome/nfp/nfp_net_ethtool.c   | 18 ++++++++++--------
 3 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net.h b/drivers/net/ethernet/netronome/nfp/nfp_net.h
index 661fa5941b91..7bfc819d1e85 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net.h
@@ -240,7 +240,7 @@ struct nfp_net_tx_ring {
 #define PCIE_DESC_RX_I_TCP_CSUM_OK	cpu_to_le16(BIT(11))
 #define PCIE_DESC_RX_I_UDP_CSUM		cpu_to_le16(BIT(10))
 #define PCIE_DESC_RX_I_UDP_CSUM_OK	cpu_to_le16(BIT(9))
-#define PCIE_DESC_RX_BPF		cpu_to_le16(BIT(8))
+#define PCIE_DESC_RX_DECRYPTED		cpu_to_le16(BIT(8))
 #define PCIE_DESC_RX_EOP		cpu_to_le16(BIT(7))
 #define PCIE_DESC_RX_IP4_CSUM		cpu_to_le16(BIT(6))
 #define PCIE_DESC_RX_IP4_CSUM_OK	cpu_to_le16(BIT(5))
@@ -367,6 +367,7 @@ struct nfp_net_rx_ring {
  * @hw_csum_rx_inner_ok: Counter of packets where the inner HW checksum was OK
  * @hw_csum_rx_complete: Counter of packets with CHECKSUM_COMPLETE reported
  * @hw_csum_rx_error:	 Counter of packets with bad checksums
+ * @hw_tls_rx:	    Number of packets with TLS decrypted by hardware
  * @tx_sync:	    Seqlock for atomic updates of TX stats
  * @tx_pkts:	    Number of Transmitted packets
  * @tx_bytes:	    Number of Transmitted bytes
@@ -415,6 +416,7 @@ struct nfp_net_r_vector {
 	u64 hw_csum_rx_ok;
 	u64 hw_csum_rx_inner_ok;
 	u64 hw_csum_rx_complete;
+	u64 hw_tls_rx;
 
 	u64 hw_csum_rx_error;
 	u64 rx_replace_buf_alloc_fail;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index e221847d9a3e..349678425aed 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1951,6 +1951,15 @@ static int nfp_net_rx(struct nfp_net_rx_ring *rx_ring, int budget)
 
 		nfp_net_rx_csum(dp, r_vec, rxd, &meta, skb);
 
+#ifdef CONFIG_TLS_DEVICE
+		if (rxd->rxd.flags & PCIE_DESC_RX_DECRYPTED) {
+			skb->decrypted = true;
+			u64_stats_update_begin(&r_vec->rx_sync);
+			r_vec->hw_tls_rx++;
+			u64_stats_update_end(&r_vec->rx_sync);
+		}
+#endif
+
 		if (rxd->rxd.flags & PCIE_DESC_RX_VLAN)
 			__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q),
 					       le16_to_cpu(rxd->rxd.vlan));
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index 3a8e1af7042d..d9cbe84ac6ad 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -150,7 +150,7 @@ static const struct nfp_et_stat nfp_mac_et_stats[] = {
 
 #define NN_ET_GLOBAL_STATS_LEN ARRAY_SIZE(nfp_net_et_stats)
 #define NN_ET_SWITCH_STATS_LEN 9
-#define NN_RVEC_GATHER_STATS	12
+#define NN_RVEC_GATHER_STATS	13
 #define NN_RVEC_PER_Q_STATS	3
 #define NN_CTRL_PATH_STATS	1
 
@@ -444,6 +444,7 @@ static u8 *nfp_vnic_get_sw_stats_strings(struct net_device *netdev, u8 *data)
 	data = nfp_pr_et(data, "hw_rx_csum_complete");
 	data = nfp_pr_et(data, "hw_rx_csum_err");
 	data = nfp_pr_et(data, "rx_replace_buf_alloc_fail");
+	data = nfp_pr_et(data, "rx_tls_decrypted");
 	data = nfp_pr_et(data, "hw_tx_csum");
 	data = nfp_pr_et(data, "hw_tx_inner_csum");
 	data = nfp_pr_et(data, "tx_gather");
@@ -475,19 +476,20 @@ static u64 *nfp_vnic_get_sw_stats(struct net_device *netdev, u64 *data)
 			tmp[2] = nn->r_vecs[i].hw_csum_rx_complete;
 			tmp[3] = nn->r_vecs[i].hw_csum_rx_error;
 			tmp[4] = nn->r_vecs[i].rx_replace_buf_alloc_fail;
+			tmp[5] = nn->r_vecs[i].hw_tls_rx;
 		} while (u64_stats_fetch_retry(&nn->r_vecs[i].rx_sync, start));
 
 		do {
 			start = u64_stats_fetch_begin(&nn->r_vecs[i].tx_sync);
 			data[1] = nn->r_vecs[i].tx_pkts;
 			data[2] = nn->r_vecs[i].tx_busy;
-			tmp[5] = nn->r_vecs[i].hw_csum_tx;
-			tmp[6] = nn->r_vecs[i].hw_csum_tx_inner;
-			tmp[7] = nn->r_vecs[i].tx_gather;
-			tmp[8] = nn->r_vecs[i].tx_lso;
-			tmp[9] = nn->r_vecs[i].hw_tls_tx;
-			tmp[10] = nn->r_vecs[i].tls_tx_fallback;
-			tmp[11] = nn->r_vecs[i].tls_tx_no_fallback;
+			tmp[6] = nn->r_vecs[i].hw_csum_tx;
+			tmp[7] = nn->r_vecs[i].hw_csum_tx_inner;
+			tmp[8] = nn->r_vecs[i].tx_gather;
+			tmp[9] = nn->r_vecs[i].tx_lso;
+			tmp[10] = nn->r_vecs[i].hw_tls_tx;
+			tmp[11] = nn->r_vecs[i].tls_tx_fallback;
+			tmp[12] = nn->r_vecs[i].tls_tx_no_fallback;
 		} while (u64_stats_fetch_retry(&nn->r_vecs[i].tx_sync, start));
 
 		data += NN_RVEC_PER_Q_STATS;
-- 
2.21.0

