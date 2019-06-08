Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D84A039F84
	for <lists+netdev@lfdr.de>; Sat,  8 Jun 2019 14:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727807AbfFHMFu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 08:05:50 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34451 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727668AbfFHMFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jun 2019 08:05:47 -0400
Received: by mail-wm1-f65.google.com with SMTP id w9so5807183wmd.1;
        Sat, 08 Jun 2019 05:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=4KUBv6AmOpkTkhaSED3t/VLGRmMP5ndUi+p0d9g4l3Y=;
        b=PtI4qpg8GmWgb5URccjmAJZksZjsccTSHnscdmp9fP26gpi81uxhxdvCM9m8Ac3XKf
         SvXVMFYRSq1BLMILxsKFQUvF89C7/OvljaXpcRDrHLy1K5+bYd3XLhdAbtHXJ8hIfKRr
         tIEoxy6RqAbU7tgHPiFM6tvNqU4TxlSkIA8XJln5FhwTPk6eyixTJtCU7F6Ra1WwCiFQ
         WRzr14BvTOfGBzL0H/cDQbBMTVFKptX+3wYbZdbLSfj1W96PDNQSsJGeHFOF5ebpVMwN
         HtYH/fnPMLZeWvo7TnltJXbC76Ps+NjOJV6AbX7AkqK2BnOeVc/ON1Jz6C9mj4ax8/7L
         M7gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4KUBv6AmOpkTkhaSED3t/VLGRmMP5ndUi+p0d9g4l3Y=;
        b=a3cE0k5+bv7tW/xdf6JeteE+KwrSuj6+HxaTPD+HE1Pnz6u3iM3Qfd2h0VmilY5Ffy
         SXcHMAaRXZbiGUbwbljnZHsqKJrkoA5jZb9gSw1OB3kbXbON9eZMM3rN5IMJ72pg2Jif
         RwCbh+AXZ7rzDsocYuTncQkGRfYBtrMItUQ9y3bTONdrh2jzMoqTCZDk8z4tsStm/FHx
         BsZ654shY0WFRv8zHab4MDEqa37OJv1lZBgGhupgSOBEVqpK/Xf2sEGPmih1NXf0ybAi
         b213rx7B61NhlKVInZC68H79ZQL06Pah0F4TmjYdF6x+ive9zsZLMsb+0t7GQj8nS3zX
         0BRQ==
X-Gm-Message-State: APjAAAVkpuAu7sVMsMNZ8fESkKzGV9TA+BIjWU5+yB7s8c5YNnd9f+B2
        kT9b6Z2fU23PMZ1F4lGcM4E=
X-Google-Smtp-Source: APXvYqzrKTJw2e1Wg7jG4734s11YpmAtvVfDMwQDcJ9siB7Z8CjcT505GdckQJcXvqMMcG9KoODCKw==
X-Received: by 2002:a7b:c8d4:: with SMTP id f20mr6807823wml.90.1559995546128;
        Sat, 08 Jun 2019 05:05:46 -0700 (PDT)
Received: from localhost.localdomain ([188.26.252.192])
        by smtp.gmail.com with ESMTPSA id j16sm5440030wre.94.2019.06.08.05.05.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Jun 2019 05:05:45 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, sboyd@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v4 net-next 10/17] net: dsa: sja1105: Build a minimal understanding of meta frames
Date:   Sat,  8 Jun 2019 15:04:36 +0300
Message-Id: <20190608120443.21889-11-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190608120443.21889-1-olteanv@gmail.com>
References: <20190608120443.21889-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Meta frames are sent on the CPU port by the switch if RX timestamping is
enabled. They contain a partial timestamp of the previous frame.

They are Ethernet frames with the Ethernet header constructed out of:

- SJA1105_META_DMAC
- SJA1105_META_SMAC
- ETH_P_SJA1105_META

The Ethernet payload will be decoded in a follow-up patch.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v4:

None.

Changes in v3:

Split from previous 09/10 patch (no functional changes).

Changes in v2:

None.

 include/linux/dsa/sja1105.h | 11 +++++++++++
 net/dsa/tag_sja1105.c       | 15 +++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/include/linux/dsa/sja1105.h b/include/linux/dsa/sja1105.h
index 5a956f335022..cc4a909d1007 100644
--- a/include/linux/dsa/sja1105.h
+++ b/include/linux/dsa/sja1105.h
@@ -12,6 +12,7 @@
 #include <net/dsa.h>
 
 #define ETH_P_SJA1105				ETH_P_DSA_8021Q
+#define ETH_P_SJA1105_META			0x0008
 
 /* IEEE 802.3 Annex 57A: Slow Protocols PDUs (01:80:C2:xx:xx:xx) */
 #define SJA1105_LINKLOCAL_FILTER_A		0x0180C2000000ull
@@ -20,6 +21,16 @@
 #define SJA1105_LINKLOCAL_FILTER_B		0x011B19000000ull
 #define SJA1105_LINKLOCAL_FILTER_B_MASK		0xFFFFFF000000ull
 
+/* Source and Destination MAC of follow-up meta frames.
+ * Whereas the choice of SMAC only affects the unique identification of the
+ * switch as sender of meta frames, the DMAC must be an address that is present
+ * in the DSA master port's multicast MAC filter.
+ * 01-80-C2-00-00-0E is a good choice for this, as all profiles of IEEE 1588
+ * over L2 use this address for some purpose already.
+ */
+#define SJA1105_META_SMAC			0x222222222222ull
+#define SJA1105_META_DMAC			0x0180C200000Eull
+
 struct sja1105_port {
 	struct dsa_port *dp;
 	bool hwts_tx_en;
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index cd8e0bfb5e75..0beb52518d56 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -22,6 +22,21 @@ static inline bool sja1105_is_link_local(const struct sk_buff *skb)
 	return false;
 }
 
+static inline bool sja1105_is_meta_frame(const struct sk_buff *skb)
+{
+	const struct ethhdr *hdr = eth_hdr(skb);
+	u64 smac = ether_addr_to_u64(hdr->h_source);
+	u64 dmac = ether_addr_to_u64(hdr->h_dest);
+
+	if (smac != SJA1105_META_SMAC)
+		return false;
+	if (dmac != SJA1105_META_DMAC)
+		return false;
+	if (ntohs(hdr->h_proto) != ETH_P_SJA1105_META)
+		return false;
+	return true;
+}
+
 /* This is the first time the tagger sees the frame on RX.
  * Figure out if we can decode it, and if we can, annotate skb->cb with how we
  * plan to do that, so we don't need to check again in the rcv function.
-- 
2.17.1

