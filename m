Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FAB43A490D
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 21:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231433AbhFKTEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 15:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231417AbhFKTEE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 15:04:04 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32407C0613A2
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 12:01:52 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id h24so6042917ejy.2
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 12:01:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ge6iBBhHkWC6zwLd2OWLu9s4THfv9a39mmSfjfYpreA=;
        b=cuBYR/7JOa4fgV/FWGQvljtlwG280+eYUnCpCdy/L3tWIDACMEkz2sVb0otRsRZ/i+
         YfCVVXo9qjqoF16MCdRRQCKi2MmtyHmzFrWC/RwA16fka6r+ETuw4cfeedM3WxRs8ElN
         gSCRirgpWlyvFzgbDJ44ThkgnHxn7i9irX2hNy2m+hVu/w6zABLdSYSqRMWIrSz3+pp+
         GgycRD/s28FQ20+imkxUDBStA3sXyGU7Np0j8M/DdWf4CFkIeX207kC3WuUYQJAmozuT
         wa+XIu/8TAZQrKLLfQHEBT/odanGZ8ma9MbwG9QBD01ymDwpokaT09+iCHOvpLHU1TOp
         mlFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ge6iBBhHkWC6zwLd2OWLu9s4THfv9a39mmSfjfYpreA=;
        b=qtRW/PcBeiiOUhKVz/vDZxivJ990KswItyScYUNJN1Y99E7GikvYYhFfLu3lC+Sjdk
         Vjg6g/YKHFGAGbdwYo5ZVowLU/ccsROQNSSBcrRpcXsYSweEB0D1T3+keIsus7XgoocQ
         kwLG2sWYEWoMi7LUoloGlmYeOrCalCZkSO4BWJmUh+dc7Pf1UH5Az0GGo4Y0iMBmJUjV
         9FxufpMICUmmzZr+/CP6lCtZkfiqR+eQEFU4ERGCifx+RyDtJjx1nLSrpJOBdOVTpIrG
         m99+obf61fX4U3ryzpmqK4djgzyOLEh25uWa2N7/HtXbrVxaAXWHzVE3vvBYQVXLP/sZ
         yKfQ==
X-Gm-Message-State: AOAM532ABfyRnNT1TDYpZ8YRX2LSTU+pB4QKF/+SjqdJlpOEEJ2STgGR
        xyP/I5C53pyqLHN1jpd+wMM=
X-Google-Smtp-Source: ABdhPJxiWWRoEGzzHKQIDA0k+hheR5ZXUsJWKfjASrSh8IL8Agl2v6fwKd1DSlR7jtUSXeFjD1Ksgw==
X-Received: by 2002:a17:906:9143:: with SMTP id y3mr4832760ejw.465.1623438110686;
        Fri, 11 Jun 2021 12:01:50 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id c19sm2922016edw.10.2021.06.11.12.01.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 12:01:50 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net-next 07/10] net: dsa: sja1105: make SJA1105_SKB_CB fit a full timestamp
Date:   Fri, 11 Jun 2021 22:01:28 +0300
Message-Id: <20210611190131.2362911-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210611190131.2362911-1-olteanv@gmail.com>
References: <20210611190131.2362911-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

In SJA1105, RX timestamps for packets sent to the CPU are transmitted in
separate follow-up packets (metadata frames). These contain partial
timestamps (24 or 32 bits) which are kept in SJA1105_SKB_CB(skb)->meta_tstamp.

Thankfully, SJA1110 improved that, and the RX timestamps are now
transmitted in-band with the actual packet, in the timestamp trailer.
The RX timestamps are now full-width 64 bits.

Because we process the RX DSA tags in the rcv() method in the tagger,
but we would like to preserve the DSA code structure in that we populate
the skb timestamp in the port_rxtstamp() call which only happens later,
the implication is that we must somehow pass the 64-bit timestamp from
the rcv() method all the way to port_rxtstamp(). We can use the skb->cb
for that.

Rename the meta_tstamp from struct sja1105_skb_cb from "meta_tstamp" to
"tstamp", and increase its size to 64 bits.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v2->v3: none
v1->v2: none

 drivers/net/dsa/sja1105/sja1105_ptp.c | 2 +-
 include/linux/dsa/sja1105.h           | 2 +-
 net/dsa/tag_sja1105.c                 | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index 0bc566b9e958..dea82f8a40c4 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -397,7 +397,7 @@ static long sja1105_rxtstamp_work(struct ptp_clock_info *ptp)
 
 		*shwt = (struct skb_shared_hwtstamps) {0};
 
-		ts = SJA1105_SKB_CB(skb)->meta_tstamp;
+		ts = SJA1105_SKB_CB(skb)->tstamp;
 		ts = sja1105_tstamp_reconstruct(ds, ticks, ts);
 
 		shwt->hwtstamp = ns_to_ktime(sja1105_ticks_to_ns(ts));
diff --git a/include/linux/dsa/sja1105.h b/include/linux/dsa/sja1105.h
index 1eb84562b311..865a548a6ef2 100644
--- a/include/linux/dsa/sja1105.h
+++ b/include/linux/dsa/sja1105.h
@@ -48,7 +48,7 @@ struct sja1105_tagger_data {
 
 struct sja1105_skb_cb {
 	struct sk_buff *clone;
-	u32 meta_tstamp;
+	u64 tstamp;
 };
 
 #define SJA1105_SKB_CB(skb) \
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index a70625fe64f7..11f555dd9566 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -147,7 +147,7 @@ static void sja1105_transfer_meta(struct sk_buff *skb,
 
 	hdr->h_dest[3] = meta->dmac_byte_3;
 	hdr->h_dest[4] = meta->dmac_byte_4;
-	SJA1105_SKB_CB(skb)->meta_tstamp = meta->tstamp;
+	SJA1105_SKB_CB(skb)->tstamp = meta->tstamp;
 }
 
 /* This is a simple state machine which follows the hardware mechanism of
-- 
2.25.1

