Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD573A37DC
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 01:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbhFJXaB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 19:30:01 -0400
Received: from mail-ej1-f48.google.com ([209.85.218.48]:44750 "EHLO
        mail-ej1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231269AbhFJXaA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 19:30:00 -0400
Received: by mail-ej1-f48.google.com with SMTP id c10so1620786eja.11
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 16:27:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+gTZUnVosgobVHSPhlK1YMC8IZT5HvZOpg52duA+dlc=;
        b=NKmRmuxmN+wJERHISTCypVAZkvtC1pE5lghKnYD0Vh52s6TW+nBG0CCOOM/VSnbFt5
         vpb9Yn00ThQGUaI76Zdhku+L7/osGVNVD8MGdCXRlCLlRi/BPT4AMNhWOH8ms6pWO5Mw
         zYTczIP6AihmCEGjiFn3RTsJCIHKZpqNNCYk/HyOkFm8f+fPuezeJYHjm9Pn5XR3dDnl
         kxhrf4zG4CbtupbLBrliZCrk5ONhJrTnkg2ccgE0/ar+wv1VPHhvNW3LrVGpcZrr+VSe
         WeE/tueSezxUK2LE79xF74M6X5l6E/NflGODSXva05YAre9SBqM4J8mtG7PPgk8m/HMl
         C3rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+gTZUnVosgobVHSPhlK1YMC8IZT5HvZOpg52duA+dlc=;
        b=arT8OsT+a2q4L0kJtw4XhqvjVg6hZ7Toqr2uMZxcHNLwuFa9ETJh6EgfSzuNu6cmom
         ATnhhYMjalf2jIKNyI1g1zLOxvT4xrQvSMAHfB9UpL8HSiuMxZp9FjQhIRzeagRlnwl7
         nO4Y6ml+YURu3Wfnzo9PywgQj4m9S5wBaTE7/x/hHFq8joyWAgdsLo6eno3Hb9J/Ngsj
         RJjTb9NKV83ZswYX4XEfDWMqW2y5sMFGzaVXXdEY602JJbuLiw1n8DTnkUIlVlhqWuzD
         GieSgQFou2tkWV/0WQixRhyYlr2XVaXi6TW/EuIf3yBySaKJ3bRsHiAe9xhG1XAx9eH7
         ZR9w==
X-Gm-Message-State: AOAM532LtHxSn1BWkhAYHGhz9RLVufLKCVpT68/n1t58EQXY6FM8IpgA
        Mnzf0hGYs3J06TWvPOBJPiE=
X-Google-Smtp-Source: ABdhPJwnRj8L8oM5Y851ed5QFd8lCCHnk4+cpWnQgSxE84ejAfuOxlyJ+7dsK1ofdorGQ8WKuu0vDg==
X-Received: by 2002:a17:906:b84f:: with SMTP id ga15mr767816ejb.372.1623367609482;
        Thu, 10 Jun 2021 16:26:49 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id j22sm1534187ejt.11.2021.06.10.16.26.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 16:26:49 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 07/10] net: dsa: sja1105: make SJA1105_SKB_CB fit a full timestamp
Date:   Fri, 11 Jun 2021 02:26:26 +0300
Message-Id: <20210610232629.1948053-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210610232629.1948053-1-olteanv@gmail.com>
References: <20210610232629.1948053-1-olteanv@gmail.com>
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

