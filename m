Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8416A542041
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 02:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384699AbiFHAUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 20:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1588649AbiFGXyx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 19:54:53 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94FC71B184D
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 16:36:33 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id g205so16823866pfb.11
        for <netdev@vger.kernel.org>; Tue, 07 Jun 2022 16:36:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wcDYmTC7D1WoG3L634icWQ9nQjK/Mpq74OFhq4Q9p9w=;
        b=NrAQNkk8keYySNwTYX/B0XE7cPjL13yTQtIsbrXbx/twn1G25e/Hj3VFxYkXpCDoss
         ngXoY41Jldb/MnFOSCj3iZo2hMrz84zXtviwVwUNky0s9K5rXpJX77HV0lPpM1MzvWpd
         3E+znEGUL8Ir/pqdRphHO0H69M1pSy7H47R3JgxsCc3ZDI3kzEstycix+kW3nHbTRlun
         Vw5MLt/TXMXEC95k144JgswCTv19VrotJ8fH+NXv5akO8RwPLf9PXxcL//Bj5yfEInpY
         4ZrspsC44Vkkt8BlOMXuJF3gIB/u6/MXUunIHP9beIK0hPayoJvWUfQojatuSZ5Nylfy
         eESw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wcDYmTC7D1WoG3L634icWQ9nQjK/Mpq74OFhq4Q9p9w=;
        b=NfAqxwk0oJ4IIvs/IaJFd3KYdGppkUgKnvOtY1BG6TlWdkZnlLCmIo0aK77B6ZV2rQ
         jwvB/yNKdPXYvLHDWQd1n2DvyWKs01aGUoIpfTf2loi8BKDPF0x3b1SXrwwWgQIzjHa8
         J3d55Ggc5LfCZLRIUjkNnS3E5zBQs57XC3JaDXaGHjLjXDjGfBYZ0ozXHUZNcNgE3Tb+
         taJm1C7zVhljErb1RX3AcCAZk98zg3cDda35GJT2vV4Zw8ApEajaulzq8E55z80WNxLr
         VZvEhQTrb/68xrE3TkZE/sbOh2fnWZOWGsjSZd+jl1H4w0YdWWtPS70oPpaN78XFnm4F
         h35w==
X-Gm-Message-State: AOAM532vEutxHbAc30NLMQSGC3os/QOCL5cQo6Z8lEDwhTGPDz3Eyc5N
        0QDGh9d4qcaOhsbeJhd/HRU=
X-Google-Smtp-Source: ABdhPJyXEULYqbchZR5cAoeTkVpp/BUNxBl/fudcql2ACmzFyoqIjs73G1SMXj8o86sfl9vsfDm7VQ==
X-Received: by 2002:aa7:8d0f:0:b0:518:d867:bae8 with SMTP id j15-20020aa78d0f000000b00518d867bae8mr30988612pfe.13.1654644993157;
        Tue, 07 Jun 2022 16:36:33 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:191a:13a7:b80a:f36e])
        by smtp.gmail.com with ESMTPSA id u79-20020a627952000000b0051ba7515e0dsm13550947pfc.54.2022.06.07.16.36.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 16:36:32 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 7/9] devlink: adopt u64_stats_t
Date:   Tue,  7 Jun 2022 16:36:12 -0700
Message-Id: <20220607233614.1133902-8-eric.dumazet@gmail.com>
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

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/devlink.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 5cc88490f18fd24329df0a83a425ed680b7a10fb..db61f3a341cb24b4de79198db7ae11b5e3132d42 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -7946,8 +7946,8 @@ static int devlink_nl_cmd_health_reporter_test_doit(struct sk_buff *skb,
 }
 
 struct devlink_stats {
-	u64 rx_bytes;
-	u64 rx_packets;
+	u64_stats_t rx_bytes;
+	u64_stats_t rx_packets;
 	struct u64_stats_sync syncp;
 };
 
@@ -8104,12 +8104,12 @@ static void devlink_trap_stats_read(struct devlink_stats __percpu *trap_stats,
 		cpu_stats = per_cpu_ptr(trap_stats, i);
 		do {
 			start = u64_stats_fetch_begin_irq(&cpu_stats->syncp);
-			rx_packets = cpu_stats->rx_packets;
-			rx_bytes = cpu_stats->rx_bytes;
+			rx_packets = u64_stats_read(&cpu_stats->rx_packets);
+			rx_bytes = u64_stats_read(&cpu_stats->rx_bytes);
 		} while (u64_stats_fetch_retry_irq(&cpu_stats->syncp, start));
 
-		stats->rx_packets += rx_packets;
-		stats->rx_bytes += rx_bytes;
+		u64_stats_add(&stats->rx_packets, rx_packets);
+		u64_stats_add(&stats->rx_bytes, rx_bytes);
 	}
 }
 
@@ -8127,11 +8127,13 @@ devlink_trap_group_stats_put(struct sk_buff *msg,
 		return -EMSGSIZE;
 
 	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_STATS_RX_PACKETS,
-			      stats.rx_packets, DEVLINK_ATTR_PAD))
+			      u64_stats_read(&stats.rx_packets),
+			      DEVLINK_ATTR_PAD))
 		goto nla_put_failure;
 
 	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_STATS_RX_BYTES,
-			      stats.rx_bytes, DEVLINK_ATTR_PAD))
+			      u64_stats_read(&stats.rx_bytes),
+			      DEVLINK_ATTR_PAD))
 		goto nla_put_failure;
 
 	nla_nest_end(msg, attr);
@@ -8171,11 +8173,13 @@ static int devlink_trap_stats_put(struct sk_buff *msg, struct devlink *devlink,
 		goto nla_put_failure;
 
 	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_STATS_RX_PACKETS,
-			      stats.rx_packets, DEVLINK_ATTR_PAD))
+			      u64_stats_read(&stats.rx_packets),
+			      DEVLINK_ATTR_PAD))
 		goto nla_put_failure;
 
 	if (nla_put_u64_64bit(msg, DEVLINK_ATTR_STATS_RX_BYTES,
-			      stats.rx_bytes, DEVLINK_ATTR_PAD))
+			      u64_stats_read(&stats.rx_bytes),
+			      DEVLINK_ATTR_PAD))
 		goto nla_put_failure;
 
 	nla_nest_end(msg, attr);
@@ -11641,8 +11645,8 @@ devlink_trap_stats_update(struct devlink_stats __percpu *trap_stats,
 
 	stats = this_cpu_ptr(trap_stats);
 	u64_stats_update_begin(&stats->syncp);
-	stats->rx_bytes += skb_len;
-	stats->rx_packets++;
+	u64_stats_add(&stats->rx_bytes, skb_len);
+	u64_stats_inc(&stats->rx_packets);
 	u64_stats_update_end(&stats->syncp);
 }
 
-- 
2.36.1.255.ge46751e96f-goog

