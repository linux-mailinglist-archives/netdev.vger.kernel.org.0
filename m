Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 336443A322D
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 19:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbhFJRhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 13:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230313AbhFJRhE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 13:37:04 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA56C061760
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 10:35:07 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id u24so33980216edy.11
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 10:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UX3ZOrFKc9XEXKUTaY+3jPa4ybC8BGt76memUh2Ajo0=;
        b=qD8bYhwGbsVOJLHllI61Z/+438zCY1PGFp3E5YOjou7Mv95LlSlpqrrUjonildcASd
         YgAvFN4t5uIs6phhBxNC1G2y2vBJhy60rS/n78eS09MTigdPVq45NgqMMyAb0g3tAJ8A
         KuOz15urr7bcq2LwPnLIUW/yYMFAI12/1wK0s35B0zcYf23jSAQ5Yb+9B26vbRZPgAXJ
         nhIMqD5H/S8LcdLxistth5QgUQIt186VrnzJ1FBgccIupa/+ohEcGzC2giuG8ryqCQS/
         UFlSEUgqJvWr3LmwEWY3KUZ07pQ//zeFjtLEQCOMIhJ/uDfkpaK4fj7myQ3eoJh5AJ0I
         iUGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UX3ZOrFKc9XEXKUTaY+3jPa4ybC8BGt76memUh2Ajo0=;
        b=fqDskRzQ2wQ4IPFJpdRte2qWg3Lp3L6OnGD80cG9huaafnNa9nPbAGrwYqRq2mbamE
         nDYzo/L9jLVDSWV2B24bkHu9l4dePAluYUFWlg3jMppFEEEv09AgpXWp6fPMl0BpmYhP
         j8Cz/oBkxbQieHfusMMsJsbgrPC5DYrZptop2Yo0HCmlWS5VZalp/2HK0meYhRH4cklH
         wclVRUDdb482N+xSs+uByk9PlFnmHZZtm0BvzDJxKZ7bOldoNZh87yUHsOl/CB6vbPTf
         41qrG1Tt/QdW+BjABESwlgmA1b3fDZeWdPic0fqFtbl6ynsnsR0IVj6KmT3QhqJ81h4x
         9w5Q==
X-Gm-Message-State: AOAM531EmLbc+1Cdh8vQHZ5NdEv35sdQWh+7heB06yaKv3RBaU4KdVT9
        26guulsQ/nHRgmCjnOL7W9I=
X-Google-Smtp-Source: ABdhPJz3l+/ZnxxefdhyUdu2wyG/fu2qHBFFxcysq/viaXhXZdFprel1iNTIgC50VHzhCYWqtgdErw==
X-Received: by 2002:a05:6402:13d7:: with SMTP id a23mr632027edx.120.1623346505710;
        Thu, 10 Jun 2021 10:35:05 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id g17sm1789595edp.14.2021.06.10.10.35.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 10:35:05 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 07/10] net: dsa: sja1105: make SJA1105_SKB_CB fit a full timestamp
Date:   Thu, 10 Jun 2021 20:34:22 +0300
Message-Id: <20210610173425.1791379-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210610173425.1791379-1-olteanv@gmail.com>
References: <20210610173425.1791379-1-olteanv@gmail.com>
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

