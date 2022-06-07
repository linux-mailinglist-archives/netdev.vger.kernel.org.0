Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9226B542026
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 02:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233881AbiFHASA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 20:18:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1588743AbiFGXzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 19:55:00 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 773D31B12F7
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 16:36:24 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id j7so17014955pjn.4
        for <netdev@vger.kernel.org>; Tue, 07 Jun 2022 16:36:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TS4esd8Hy+F+CvYSJzr8az5kPDcg2EO80zkka6TTLbc=;
        b=HQJlGVGjMp/9T1GPOhtuPZk6K5nEZiOqAeFPYarAtwamXTUBguiiuAqXkfj1V9GtCf
         moYxZpByAHQd+qLk/yrMYX5gbPV7XdTHw9H7GYlr4mIrNBC1kqKFHGnsHmrxRae29hpM
         VisNdOduwQcRny8N1PWuQxcV9z/Lg6jnPYd4OhDT3sW48sXtpWgn6TEbiJYSK3rm/qTW
         WJx2g3DgXopYrTuG1XiJr17jMF+OWGgHl02cYiyZrr2tLDQ1IczSXsFxSCpnohuEzhx5
         H2yeGunOyVKc01/3CXQBw0TuTfMXPF9bX/7708H2SznQEoPMOWihRY3CPJQj7KVw1p6d
         JiEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TS4esd8Hy+F+CvYSJzr8az5kPDcg2EO80zkka6TTLbc=;
        b=hmtbt7PvoXQ81IbbWgcmgcNli2kIAcZQnBrpwvAQ2VZx66teyigTRo7FU5phKPtBR4
         jJvwptMRAzbXVywc+D7T/mKT+KOFyFRsXys92QelpN4dPRb40KdRMNZRdUC7Nbyy5obe
         2tkEJ7Q61qOocfpQeHOhg3rM50km8xlWsJrqcI+Ufkzuol8aezwXKqJRjkOHetT4R/TN
         k3KWpYip5aeQX6WbhQmdqcVb6WOZCDizFD2QNuMHSYy//cI8s+VfPwD3WpiDgHdeBtkC
         oMxo0ANLsvkG6JpR+ZOZdOUykDziDN4w876TZp+qRX/GyLuC6lDsq69y6E2gdvlGdWtF
         qSlg==
X-Gm-Message-State: AOAM532NNP59Ioqy3HldWogGSkL9S2bxpX3YYiXVBny7yU2PXXxGR8j6
        jvLyKrvKsTx49UfHayYOEHE=
X-Google-Smtp-Source: ABdhPJxY6/5pXpHwu3fwAZmJPMl2WnkFBG9JZkD0Gqd0So4mliv2cAU/tft9u4hkmHqhQ500q5n7iw==
X-Received: by 2002:a17:903:1205:b0:15e:804c:fab4 with SMTP id l5-20020a170903120500b0015e804cfab4mr31396448plh.112.1654644983977;
        Tue, 07 Jun 2022 16:36:23 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:191a:13a7:b80a:f36e])
        by smtp.gmail.com with ESMTPSA id u79-20020a627952000000b0051ba7515e0dsm13550947pfc.54.2022.06.07.16.36.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 16:36:23 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 2/9] ipvlan: adopt u64_stats_t
Date:   Tue,  7 Jun 2022 16:36:07 -0700
Message-Id: <20220607233614.1133902-3-eric.dumazet@gmail.com>
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

Add READ_ONCE() when reading rx_errs & tx_drps.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 drivers/net/ipvlan/ipvlan.h      | 10 +++++-----
 drivers/net/ipvlan/ipvlan_core.c |  6 +++---
 drivers/net/ipvlan/ipvlan_main.c | 18 +++++++++---------
 3 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ipvlan/ipvlan.h b/drivers/net/ipvlan/ipvlan.h
index 3837c897832eaf6c325f06f86f16edf18775956a..de94921cbef9f2beb2b7e4f5ecde06eb4e5cff9c 100644
--- a/drivers/net/ipvlan/ipvlan.h
+++ b/drivers/net/ipvlan/ipvlan.h
@@ -47,11 +47,11 @@ typedef enum {
 } ipvl_hdr_type;
 
 struct ipvl_pcpu_stats {
-	u64			rx_pkts;
-	u64			rx_bytes;
-	u64			rx_mcast;
-	u64			tx_pkts;
-	u64			tx_bytes;
+	u64_stats_t		rx_pkts;
+	u64_stats_t		rx_bytes;
+	u64_stats_t		rx_mcast;
+	u64_stats_t		tx_pkts;
+	u64_stats_t		tx_bytes;
 	struct u64_stats_sync	syncp;
 	u32			rx_errs;
 	u32			tx_drps;
diff --git a/drivers/net/ipvlan/ipvlan_core.c b/drivers/net/ipvlan/ipvlan_core.c
index 6ffb27419e64b36666d395da924304a943343640..dfeb5b392e642885c3897018337f94fb41d10eab 100644
--- a/drivers/net/ipvlan/ipvlan_core.c
+++ b/drivers/net/ipvlan/ipvlan_core.c
@@ -19,10 +19,10 @@ void ipvlan_count_rx(const struct ipvl_dev *ipvlan,
 
 		pcptr = this_cpu_ptr(ipvlan->pcpu_stats);
 		u64_stats_update_begin(&pcptr->syncp);
-		pcptr->rx_pkts++;
-		pcptr->rx_bytes += len;
+		u64_stats_inc(&pcptr->rx_pkts);
+		u64_stats_add(&pcptr->rx_bytes, len);
 		if (mcast)
-			pcptr->rx_mcast++;
+			u64_stats_inc(&pcptr->rx_mcast);
 		u64_stats_update_end(&pcptr->syncp);
 	} else {
 		this_cpu_inc(ipvlan->pcpu_stats->rx_errs);
diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
index aa28a29e228c0f3337b6c32d89d525e55a2c2021..49ba8a50dfb1e169beb137296fb3d3c1cfde4c19 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -224,8 +224,8 @@ static netdev_tx_t ipvlan_start_xmit(struct sk_buff *skb,
 		pcptr = this_cpu_ptr(ipvlan->pcpu_stats);
 
 		u64_stats_update_begin(&pcptr->syncp);
-		pcptr->tx_pkts++;
-		pcptr->tx_bytes += skblen;
+		u64_stats_inc(&pcptr->tx_pkts);
+		u64_stats_add(&pcptr->tx_bytes, skblen);
 		u64_stats_update_end(&pcptr->syncp);
 	} else {
 		this_cpu_inc(ipvlan->pcpu_stats->tx_drps);
@@ -300,11 +300,11 @@ static void ipvlan_get_stats64(struct net_device *dev,
 			pcptr = per_cpu_ptr(ipvlan->pcpu_stats, idx);
 			do {
 				strt= u64_stats_fetch_begin_irq(&pcptr->syncp);
-				rx_pkts = pcptr->rx_pkts;
-				rx_bytes = pcptr->rx_bytes;
-				rx_mcast = pcptr->rx_mcast;
-				tx_pkts = pcptr->tx_pkts;
-				tx_bytes = pcptr->tx_bytes;
+				rx_pkts = u64_stats_read(&pcptr->rx_pkts);
+				rx_bytes = u64_stats_read(&pcptr->rx_bytes);
+				rx_mcast = u64_stats_read(&pcptr->rx_mcast);
+				tx_pkts = u64_stats_read(&pcptr->tx_pkts);
+				tx_bytes = u64_stats_read(&pcptr->tx_bytes);
 			} while (u64_stats_fetch_retry_irq(&pcptr->syncp,
 							   strt));
 
@@ -315,8 +315,8 @@ static void ipvlan_get_stats64(struct net_device *dev,
 			s->tx_bytes += tx_bytes;
 
 			/* u32 values are updated without syncp protection. */
-			rx_errs += pcptr->rx_errs;
-			tx_drps += pcptr->tx_drps;
+			rx_errs += READ_ONCE(pcptr->rx_errs);
+			tx_drps += READ_ONCE(pcptr->tx_drps);
 		}
 		s->rx_errors = rx_errs;
 		s->rx_dropped = rx_errs;
-- 
2.36.1.255.ge46751e96f-goog

