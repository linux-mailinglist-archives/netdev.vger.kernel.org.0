Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B63A5437DC
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 17:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244786AbiFHPrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 11:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244790AbiFHPq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 11:46:57 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A040C3D4AC
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 08:46:54 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id w13-20020a17090a780d00b001e8961b355dso6978815pjk.5
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 08:46:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wcDYmTC7D1WoG3L634icWQ9nQjK/Mpq74OFhq4Q9p9w=;
        b=XoBLOXqX4mp+Npdwv0m9TsaalsLlVRH/6E+k020rUO+T+SoSJAYyglRBki+63pU+G/
         CyS2bjIGYcUzrNB7BhDSmLO6zA7vkRjrHPWZj9nm78tJSMgLEqj5REj2peoB2lgCeSHH
         x38N89Qfycs/sRkt5u7B+l3mgw+zxCcwa3HRZHqD4FVCrz42NZtCmgrpyStOTAgcp1/3
         p7Eg8no1Bd9DlFF2zRa4CmI1XeJc49w6Tv2H68Mg0jZGyQJoUAEfj4X9O2KLs1IvbTTL
         CQnx854VKUzp63q8tTyD3x2SCvfxwqfLHyukG3LmQFwBee4DT3qoMyhdWj27bxIxBYZ2
         JTXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wcDYmTC7D1WoG3L634icWQ9nQjK/Mpq74OFhq4Q9p9w=;
        b=UzJPoBfwKTCZPSlL+8bLQMHAw2flEyiJu93Txh0/tdqm3DGIEpZ+oms6EbkCDZgjGz
         CvyAdTXTXznrfMEEycIv4eOeOEl2BPsrNfN9qb70xuQpa8/zAakOMWwkZu91IzX4Uy7D
         cimhTJeCqFajmyw/eA96GrSl0xTGa/xxhwZuHt94m550WtbdOiBfEnU5jvm1O+bu4I7a
         BH797cAmfdyH/DTXC2Mu3kpPy1dBH76FreXPv5RZBVudhXTHpQx6ie03c3XgWmANannQ
         AMi1oWtiA7VevUGMgIkjFdkdIEav4+qk6MNNHUZAvmIZ/QxsQAdIMjrhfxydfs2cvG1S
         3LcQ==
X-Gm-Message-State: AOAM532LcgFORL7qWYcSbV0fFraW9e9KoDp8MLOJX27sF5Z0AA0fWJDt
        La2A2EHh12IVhwwcN1v/g4Y=
X-Google-Smtp-Source: ABdhPJydSDXXf+WArKNtDdl2c1iSV0kYe8MIseBxhDLDPqGwrqovakUR/uErlcqK3sNlvygpD6QwXw==
X-Received: by 2002:a17:903:4049:b0:167:515b:3efa with SMTP id n9-20020a170903404900b00167515b3efamr25483849pla.41.1654703214116;
        Wed, 08 Jun 2022 08:46:54 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:f579:a14f:f943:9d9a])
        by smtp.gmail.com with ESMTPSA id a10-20020a056a001d0a00b0051be2ae1fb5sm10885973pfx.61.2022.06.08.08.46.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 08:46:53 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 7/9] devlink: adopt u64_stats_t
Date:   Wed,  8 Jun 2022 08:46:38 -0700
Message-Id: <20220608154640.1235958-8-eric.dumazet@gmail.com>
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

