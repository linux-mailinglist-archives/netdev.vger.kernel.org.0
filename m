Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 250B734E66
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 19:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728318AbfFDRJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 13:09:04 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50241 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728102AbfFDRIP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 13:08:15 -0400
Received: by mail-wm1-f67.google.com with SMTP id f204so870444wme.0;
        Tue, 04 Jun 2019 10:08:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=KO2S7xnb0/HBFM+JPBCTU5HcP00Bqo8EscwdwXu3zQg=;
        b=DDYMC6l6FKAfFKB9VCG3M6wBkI3XF2uUhSr6O2cpyqaeU0f31hhvdk5k5xR62MMWi5
         dz/7FaJS3+oPaiQG339wmbnDu8D28jsT/LTt5nmF7Igt7k27oMRlW9kCOZoJvI3ke4nU
         xy7c/2Cq3yi/gWL+QpMv7zaqv63iVTW+ho8tCpVUZsO3iWjtSeqHtnFaqjjK0K5jdVu+
         ZIDJFn7LixkpF5SSNYq1gMUWfNB6cCdWj8VT3NRb/p/OW56Vlt4Fkjqxj23fIP1za/qI
         RFLUGbtS03S7SMSuNUP5R2CWkkNlnydTqzEH24aRfWSu/elvfMx9dt63Icrl6tFcsXgV
         a/Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=KO2S7xnb0/HBFM+JPBCTU5HcP00Bqo8EscwdwXu3zQg=;
        b=V2lUr0eR8m0cpXPyjTmqWhsNgV+P6T/KThlcCXJIfd7IvTTXuNR+flxGVJWSBDFJkq
         zKG9ArcLVvNguO9z7KBuB2NgF8rH3oIhFEaB+4TPFywOYijj4wt7LArVjDuRC9HqiJe5
         ASny04mqJ3dgRvf9X8A332SRziJBCJgdCxRvHLgA7nt/tOjJNkamweJe+lVOkMJ5NvmT
         GkZYWselBAprF274//P5iL9uV9jLNVfg5HVf6MtJ57rPFnf693P3LFHggXcFytISPX/+
         Xl2UHN9Qr+1nPHxVv3Pa2bkKd0rhB0+OqjpQX32W+FuBdkYe2sXwcgTSik6bteSSZoAi
         /cHw==
X-Gm-Message-State: APjAAAWmagDGBNuGU2pQRAKv+K0QIsTon/siiUlysjjtALJBOh04K6JG
        3hwMaKT92YldcThL2CRLEJQ=
X-Google-Smtp-Source: APXvYqyj5ihuP2fMRnX8cNuYKxjAe//erEDDhaYk7dKGMVy+xIyYF407vlY715kJQu0BUDXd+UXf8g==
X-Received: by 2002:a05:600c:2149:: with SMTP id v9mr4430627wml.141.1559668094258;
        Tue, 04 Jun 2019 10:08:14 -0700 (PDT)
Received: from localhost.localdomain ([86.121.27.188])
        by smtp.gmail.com with ESMTPSA id f2sm19692218wme.12.2019.06.04.10.08.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 10:08:13 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, sboyd@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v3 net-next 10/17] net: dsa: sja1105: Build a minimal understanding of meta frames
Date:   Tue,  4 Jun 2019 20:07:49 +0300
Message-Id: <20190604170756.14338-11-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190604170756.14338-1-olteanv@gmail.com>
References: <20190604170756.14338-1-olteanv@gmail.com>
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
---
Changes in v3:

Split from previous 09/10 patch (no functional changes).

Changes in v2:

None.

 include/linux/dsa/sja1105.h | 11 +++++++++++
 net/dsa/tag_sja1105.c       | 15 +++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/include/linux/dsa/sja1105.h b/include/linux/dsa/sja1105.h
index f5d5f7823da6..4f09743b4713 100644
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
index 7a56a27a1fd2..9ff7cfa6ea20 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -7,6 +7,21 @@
 #include <linux/packing.h>
 #include "dsa_priv.h"
 
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

