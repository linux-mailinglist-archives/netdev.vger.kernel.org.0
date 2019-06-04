Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5956534E6D
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 19:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728332AbfFDRJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 13:09:18 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50235 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728091AbfFDRIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 13:08:14 -0400
Received: by mail-wm1-f65.google.com with SMTP id f204so870329wme.0;
        Tue, 04 Jun 2019 10:08:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=I7F8A4F3GCNLWkONMi1ifvSYkMOBHZ4lwKL9cvhHEw8=;
        b=tALmAq+DjXb7vH7ImS10tIyELwFv9qL2ll9R4EtBxthKG0V3p9VcnJH4EoCYTjkceD
         56tPkG71bl4r0HrxJkds9RMX9naZ2B7JLt0RvL9qXwZRRjIQ3AP7EKPIBfmoasDzbFRQ
         HedIVs9lOo/xdv7O+U4r5eTADgXYPXAESU2auvKenp3KVgbob8/J/tmvfihtpy5k+Q8y
         Ofkz8Y021Hl1Hem6GxJpaAQnofDvLLqdRengY9vLxe7C9qwS8TpkjrgUEHdkZT1nVUuQ
         YTeNRqsi5KEh1hzn2wgf9Cyu/7wIcVH6lJuKvFGRyMFAFYFV8Qa5a2ixv5GcRVY1YjLY
         5iZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=I7F8A4F3GCNLWkONMi1ifvSYkMOBHZ4lwKL9cvhHEw8=;
        b=n6inQy+KoLhWuGlVK+Mlt1uTeGqfiF+m/ir1afuMpGjg4gbkBbigMAqrKP0c/Cxz9/
         J3Dzn0HgD0lmF2JvI5c8iYXoW/VQD0EDgtYfrq2ZT9IIoBNn+wRJLPmQdbovkMuMqmmI
         EUaWjFJo5gG9gImKHQ/nsCplZyIhiPChXie0uZ+n74rRDenQgeiq3s425n1U8FZvnefC
         apxEHTqFNaDJNDSKgHXTvLvWMAPx8bJN7rtu3Mrc7XC7bE/YCJZpKfIztKJaXP7BPmkK
         0y4FUtSfmaEkU6O3u6jXpLAlMaohBUsJl9LomK/L/CCzdJBPJtOuTSWTGW68fEERyoMr
         YQQA==
X-Gm-Message-State: APjAAAUkZArMWy1qE6amYZqtlSCJ37pV8NetG5OjDsKiT7inM/k+orXC
        6Hb/NzYEzfI3kOJZkizj7ps=
X-Google-Smtp-Source: APXvYqx6tfaOhAbsLyKfhNuCq0c36bG05yIEXEgJCYvDB65jyzU2q+jWLbiQva9Q2uEWqiOxiFakFg==
X-Received: by 2002:a05:600c:254b:: with SMTP id e11mr17497299wma.171.1559668092041;
        Tue, 04 Jun 2019 10:08:12 -0700 (PDT)
Received: from localhost.localdomain ([86.121.27.188])
        by smtp.gmail.com with ESMTPSA id f2sm19692218wme.12.2019.06.04.10.08.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 10:08:11 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, sboyd@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v3 net-next 08/17] net: dsa: sja1105: Move sja1105_is_link_local to include/linux
Date:   Tue,  4 Jun 2019 20:07:47 +0300
Message-Id: <20190604170756.14338-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190604170756.14338-1-olteanv@gmail.com>
References: <20190604170756.14338-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This function will be reused from the .port_rxtstamp callback to see if
the received SKB can be timestamped by the switch.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes in v3:

None.

Changes in v2:

Patch is new.

 include/linux/dsa/sja1105.h | 15 +++++++++++++++
 net/dsa/tag_sja1105.c       | 15 ---------------
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/include/linux/dsa/sja1105.h b/include/linux/dsa/sja1105.h
index e46e18c47d41..f3237afed35a 100644
--- a/include/linux/dsa/sja1105.h
+++ b/include/linux/dsa/sja1105.h
@@ -25,4 +25,19 @@ struct sja1105_port {
 	int mgmt_slot;
 };
 
+/* Similar to is_link_local_ether_addr(hdr->h_dest) but also covers PTP */
+static inline bool sja1105_is_link_local(const struct sk_buff *skb)
+{
+	const struct ethhdr *hdr = eth_hdr(skb);
+	u64 dmac = ether_addr_to_u64(hdr->h_dest);
+
+	if ((dmac & SJA1105_LINKLOCAL_FILTER_A_MASK) ==
+		    SJA1105_LINKLOCAL_FILTER_A)
+		return true;
+	if ((dmac & SJA1105_LINKLOCAL_FILTER_B_MASK) ==
+		    SJA1105_LINKLOCAL_FILTER_B)
+		return true;
+	return false;
+}
+
 #endif /* _NET_DSA_SJA1105_H */
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index b35cf5c2d01c..7a56a27a1fd2 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -7,21 +7,6 @@
 #include <linux/packing.h>
 #include "dsa_priv.h"
 
-/* Similar to is_link_local_ether_addr(hdr->h_dest) but also covers PTP */
-static inline bool sja1105_is_link_local(const struct sk_buff *skb)
-{
-	const struct ethhdr *hdr = eth_hdr(skb);
-	u64 dmac = ether_addr_to_u64(hdr->h_dest);
-
-	if ((dmac & SJA1105_LINKLOCAL_FILTER_A_MASK) ==
-		    SJA1105_LINKLOCAL_FILTER_A)
-		return true;
-	if ((dmac & SJA1105_LINKLOCAL_FILTER_B_MASK) ==
-		    SJA1105_LINKLOCAL_FILTER_B)
-		return true;
-	return false;
-}
-
 /* This is the first time the tagger sees the frame on RX.
  * Figure out if we can decode it, and if we can, annotate skb->cb with how we
  * plan to do that, so we don't need to check again in the rcv function.
-- 
2.17.1

