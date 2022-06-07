Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88132542033
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 02:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383715AbiFHATQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 20:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1588731AbiFGXy7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 19:54:59 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FCAB1B12CD
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 16:36:22 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id r71so17350438pgr.0
        for <netdev@vger.kernel.org>; Tue, 07 Jun 2022 16:36:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e+CTXDa29EBcBYDxxlVubSwYC9Qw99hAapvr513hnSw=;
        b=Oq51IJqIt5x1AxdRbmPdD/3gr7kUSjTfxsTUP4X6LjwyGWOJwJWpUraRCDVYE/gOEV
         qchL7yMKeQMuGWKNVfBvEtinQcBYxvY1ummn0Nifb8rKWLHDPyaHi1zncubWSYm/AhfU
         yS5USb1gnKTOHDSfN1Dc5/3pF4N7Iij9sZPwNI5WN7AIK2kPMkzOY8+0URPAqJMcyGFF
         ranhnUOWv/6zIdYNitmWLcmXfLSVCvfXL7Su05LQYu8Q7C0iCQ4GgvYR5yanJoUT18x3
         d/r7l9v+t04+B9LLGO2vhe3IV5IxLWPeuqNDqBFy26+gs5mgdCJ+DjhRKwKpP/YREbpw
         fETQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e+CTXDa29EBcBYDxxlVubSwYC9Qw99hAapvr513hnSw=;
        b=MkIiphD0KgOcHNmgRErPtyHrjmBTBIGBR6nrIZNsSH1J2e/5w6rt0mo3RiaNI7ps6F
         AculZAixqjM16Y0Bkt0Xmy+x4RuodXALmjb9vL6tZnBF752KDGC17ZwOdeSssIwMpDYY
         twp5y4F2InJEF9VNSja4GlUdQqEy4rL6RKGu4UjmioC2sEs637yt0AnNltsJY3sdcnsl
         iyK6SrmoGNc2BcmI0Kt6Tv7RkKV1IEszDsBXA1bs++vZ449vxrXrNG+mtbBEG40esDFz
         cu6aCmJImGdIkndANrv4qN5rEDBWsZAvAtfB4ZPE/eAP+uNJZPl7N4HaPxLt6IscLfGn
         dRmw==
X-Gm-Message-State: AOAM532E6YCKr4/q+OHPPH+z2mMWwMN5Pcqos6Uz5ov0yN2w3x5Ck/DH
        y6uWidfGqSPO/mLpPbJA5+c=
X-Google-Smtp-Source: ABdhPJwL2ZJ/y4beF63JwDiMO9GaLZ7pppHhRTG0RM+BR9fF5dG/KU82kykE0Q9VQYDed/rfRY0uhg==
X-Received: by 2002:a65:6d16:0:b0:3c1:b056:5f5a with SMTP id bf22-20020a656d16000000b003c1b0565f5amr27294477pgb.469.1654644982113;
        Tue, 07 Jun 2022 16:36:22 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:191a:13a7:b80a:f36e])
        by smtp.gmail.com with ESMTPSA id u79-20020a627952000000b0051ba7515e0dsm13550947pfc.54.2022.06.07.16.36.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 16:36:21 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 1/9] vlan: adopt u64_stats_t
Date:   Tue,  7 Jun 2022 16:36:06 -0700
Message-Id: <20220607233614.1133902-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
In-Reply-To: <20220607233614.1133902-1-eric.dumazet@gmail.com>
References: <20220607233614.1133902-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

As explained in commit 316580b69d0a ("u64_stats: provide u64_stats_t type")
we should use u64_stats_t and related accessors to avoid load/store tearing.

Add READ_ONCE() when reading rx_errors & tx_dropped.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 drivers/net/macvlan.c      | 18 +++++++++---------
 include/linux/if_macvlan.h |  6 +++---
 include/linux/if_vlan.h    | 10 +++++-----
 net/8021q/vlan_core.c      |  6 +++---
 net/8021q/vlan_dev.c       | 18 +++++++++---------
 5 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index eff75beb13957b81f8949922d0ffa29b68ebb3f6..0540a53250be2a8d991ef0e2fd18bea481ebf373 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -575,8 +575,8 @@ static netdev_tx_t macvlan_start_xmit(struct sk_buff *skb,
 
 		pcpu_stats = this_cpu_ptr(vlan->pcpu_stats);
 		u64_stats_update_begin(&pcpu_stats->syncp);
-		pcpu_stats->tx_packets++;
-		pcpu_stats->tx_bytes += len;
+		u64_stats_inc(&pcpu_stats->tx_packets);
+		u64_stats_add(&pcpu_stats->tx_bytes, len);
 		u64_stats_update_end(&pcpu_stats->syncp);
 	} else {
 		this_cpu_inc(vlan->pcpu_stats->tx_dropped);
@@ -949,11 +949,11 @@ static void macvlan_dev_get_stats64(struct net_device *dev,
 			p = per_cpu_ptr(vlan->pcpu_stats, i);
 			do {
 				start = u64_stats_fetch_begin_irq(&p->syncp);
-				rx_packets	= p->rx_packets;
-				rx_bytes	= p->rx_bytes;
-				rx_multicast	= p->rx_multicast;
-				tx_packets	= p->tx_packets;
-				tx_bytes	= p->tx_bytes;
+				rx_packets	= u64_stats_read(&p->rx_packets);
+				rx_bytes	= u64_stats_read(&p->rx_bytes);
+				rx_multicast	= u64_stats_read(&p->rx_multicast);
+				tx_packets	= u64_stats_read(&p->tx_packets);
+				tx_bytes	= u64_stats_read(&p->tx_bytes);
 			} while (u64_stats_fetch_retry_irq(&p->syncp, start));
 
 			stats->rx_packets	+= rx_packets;
@@ -964,8 +964,8 @@ static void macvlan_dev_get_stats64(struct net_device *dev,
 			/* rx_errors & tx_dropped are u32, updated
 			 * without syncp protection.
 			 */
-			rx_errors	+= p->rx_errors;
-			tx_dropped	+= p->tx_dropped;
+			rx_errors	+= READ_ONCE(p->rx_errors);
+			tx_dropped	+= READ_ONCE(p->tx_dropped);
 		}
 		stats->rx_errors	= rx_errors;
 		stats->rx_dropped	= rx_errors;
diff --git a/include/linux/if_macvlan.h b/include/linux/if_macvlan.h
index b422947390638a59a9a7e6b23c7d0e0c2eb84b12..523025106a643eebc2d3f948f8fe380bce376bbd 100644
--- a/include/linux/if_macvlan.h
+++ b/include/linux/if_macvlan.h
@@ -46,10 +46,10 @@ static inline void macvlan_count_rx(const struct macvlan_dev *vlan,
 
 		pcpu_stats = get_cpu_ptr(vlan->pcpu_stats);
 		u64_stats_update_begin(&pcpu_stats->syncp);
-		pcpu_stats->rx_packets++;
-		pcpu_stats->rx_bytes += len;
+		u64_stats_inc(&pcpu_stats->rx_packets);
+		u64_stats_add(&pcpu_stats->rx_bytes, len);
 		if (multicast)
-			pcpu_stats->rx_multicast++;
+			u64_stats_inc(&pcpu_stats->rx_multicast);
 		u64_stats_update_end(&pcpu_stats->syncp);
 		put_cpu_ptr(vlan->pcpu_stats);
 	} else {
diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
index 2be4dd7e90a943785fe51d14ffd2d1ff9e0de8ee..e00c4ee81ff7f82e4343fe45c14d8e5d81d80e95 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -118,11 +118,11 @@ static inline void vlan_drop_rx_stag_filter_info(struct net_device *dev)
  *	@tx_dropped: number of tx drops
  */
 struct vlan_pcpu_stats {
-	u64			rx_packets;
-	u64			rx_bytes;
-	u64			rx_multicast;
-	u64			tx_packets;
-	u64			tx_bytes;
+	u64_stats_t		rx_packets;
+	u64_stats_t		rx_bytes;
+	u64_stats_t		rx_multicast;
+	u64_stats_t		tx_packets;
+	u64_stats_t		tx_bytes;
 	struct u64_stats_sync	syncp;
 	u32			rx_errors;
 	u32			tx_dropped;
diff --git a/net/8021q/vlan_core.c b/net/8021q/vlan_core.c
index acf8c791f3207bc86fc3d61bfde53e1857d43a28..5aa8144101dc6c82b6251ac9e2b25cc6eeda8fb4 100644
--- a/net/8021q/vlan_core.c
+++ b/net/8021q/vlan_core.c
@@ -63,10 +63,10 @@ bool vlan_do_receive(struct sk_buff **skbp)
 	rx_stats = this_cpu_ptr(vlan_dev_priv(vlan_dev)->vlan_pcpu_stats);
 
 	u64_stats_update_begin(&rx_stats->syncp);
-	rx_stats->rx_packets++;
-	rx_stats->rx_bytes += skb->len;
+	u64_stats_inc(&rx_stats->rx_packets);
+	u64_stats_add(&rx_stats->rx_bytes, skb->len);
 	if (skb->pkt_type == PACKET_MULTICAST)
-		rx_stats->rx_multicast++;
+		u64_stats_inc(&rx_stats->rx_multicast);
 	u64_stats_update_end(&rx_stats->syncp);
 
 	return true;
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 839f2020b015ecaed897bd6672d85b187f982765..968bcfcc16edfab38f45b655402f6543a8db9489 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -128,8 +128,8 @@ static netdev_tx_t vlan_dev_hard_start_xmit(struct sk_buff *skb,
 
 		stats = this_cpu_ptr(vlan->vlan_pcpu_stats);
 		u64_stats_update_begin(&stats->syncp);
-		stats->tx_packets++;
-		stats->tx_bytes += len;
+		u64_stats_inc(&stats->tx_packets);
+		u64_stats_add(&stats->tx_bytes, len);
 		u64_stats_update_end(&stats->syncp);
 	} else {
 		this_cpu_inc(vlan->vlan_pcpu_stats->tx_dropped);
@@ -713,11 +713,11 @@ static void vlan_dev_get_stats64(struct net_device *dev,
 		p = per_cpu_ptr(vlan_dev_priv(dev)->vlan_pcpu_stats, i);
 		do {
 			start = u64_stats_fetch_begin_irq(&p->syncp);
-			rxpackets	= p->rx_packets;
-			rxbytes		= p->rx_bytes;
-			rxmulticast	= p->rx_multicast;
-			txpackets	= p->tx_packets;
-			txbytes		= p->tx_bytes;
+			rxpackets	= u64_stats_read(&p->rx_packets);
+			rxbytes		= u64_stats_read(&p->rx_bytes);
+			rxmulticast	= u64_stats_read(&p->rx_multicast);
+			txpackets	= u64_stats_read(&p->tx_packets);
+			txbytes		= u64_stats_read(&p->tx_bytes);
 		} while (u64_stats_fetch_retry_irq(&p->syncp, start));
 
 		stats->rx_packets	+= rxpackets;
@@ -726,8 +726,8 @@ static void vlan_dev_get_stats64(struct net_device *dev,
 		stats->tx_packets	+= txpackets;
 		stats->tx_bytes		+= txbytes;
 		/* rx_errors & tx_dropped are u32 */
-		rx_errors	+= p->rx_errors;
-		tx_dropped	+= p->tx_dropped;
+		rx_errors	+= READ_ONCE(p->rx_errors);
+		tx_dropped	+= READ_ONCE(p->tx_dropped);
 	}
 	stats->rx_errors  = rx_errors;
 	stats->tx_dropped = tx_dropped;
-- 
2.36.1.255.ge46751e96f-goog

