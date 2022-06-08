Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F10ED5437DA
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 17:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244797AbiFHPq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 11:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244770AbiFHPqt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 11:46:49 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3044F2C671
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 08:46:48 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id r1so732258plo.10
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 08:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TS4esd8Hy+F+CvYSJzr8az5kPDcg2EO80zkka6TTLbc=;
        b=D4/pYCOkoNH9RpxuRXPFw/gzXXRmef2abmUelR+jZeJRz6bexsdnqbivqrAyJmScBg
         vsJvoB++RQx6+2V04BxUZj8AkcsLXkisc+gl+mMyrn9LzGouSrijdcPjeuJtGt4oXFqk
         6tJzMf/fyFUfavX+TnP2ivUnUwig4Cn5n/bjFx7rgyFboxrefPUFAkvatSRXlCW/U5Oj
         M6vL2vsLutlNlQ/CkdXSBLP2UnDb3aXoBd2ymBSkA7VaX/+woXIlHcJGm394jBqTf4fj
         LGpQRlBL5t7zROKuzF+bU2agXU+/nx2KLVVN3U/gm0V9TNjP+R0u8mrsu33HFH5RKTHZ
         Mruw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TS4esd8Hy+F+CvYSJzr8az5kPDcg2EO80zkka6TTLbc=;
        b=Mh2N5wqKuHNmrLF5X3mxfVGZKKFHX7PRgfFwRNcUsr/4ezfjIehPEhpTfby6MsHF18
         EgqERJ59LDpGMyFZsLnSWFrzIa/fzWdERLlV31CcuyfAdb5YPFUbZ9xlVNeXCKQDpkNX
         +j4VgGP2qeDFJsi9ali6+4OzPelk0rS4vhKN4S4Et1cG//wepi/CSBo0vjdNCTyHLewT
         vY3+sSR5i0dm8wVe9VWKcCAkEICGkTOiV5p75meo43azNmQeXaJwZp6u+NpHzWOvqWbS
         ZTH0pvrnrexOpZWrBtlAh7bjX/kAGIZKJHrY9DHvSO9CMNqWBHZ5jNw4dAOzt02xQrbz
         zFmw==
X-Gm-Message-State: AOAM531VNq3vJvi1Yd0lr8mioNacm9iY9asuv/XbbY4VMLmSHXgbM6Kt
        ZgHTtyXVnY24hc5qRhFHL4Y=
X-Google-Smtp-Source: ABdhPJxvDz82xhYbQY251dlG6y7ELkC+pmR2UV+3cUQNrdMGbb025OrRrBUPmyUytPpkavgD813p0Q==
X-Received: by 2002:a17:902:bd8e:b0:167:6f86:7862 with SMTP id q14-20020a170902bd8e00b001676f867862mr19662047pls.15.1654703207648;
        Wed, 08 Jun 2022 08:46:47 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:f579:a14f:f943:9d9a])
        by smtp.gmail.com with ESMTPSA id a10-20020a056a001d0a00b0051be2ae1fb5sm10885973pfx.61.2022.06.08.08.46.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 08:46:47 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 2/9] ipvlan: adopt u64_stats_t
Date:   Wed,  8 Jun 2022 08:46:33 -0700
Message-Id: <20220608154640.1235958-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
In-Reply-To: <20220608154640.1235958-1-eric.dumazet@gmail.com>
References: <20220608154640.1235958-1-eric.dumazet@gmail.com>
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

