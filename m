Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A40B66EA76B
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 11:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231959AbjDUJom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 05:44:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232021AbjDUJob (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 05:44:31 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 831C2B761
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 02:44:10 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-b8f53c7683fso2481485276.0
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 02:44:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682070249; x=1684662249;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kSmVunaujXkgtLmcclqS5Ly4hFKCHl7gI/mH+YJFHrw=;
        b=orlw76PuumWof7QMQp8z9RVFWP+cub3jQq8xYcUKL9r6sLcOjpZbH7W6dDjpNgSFSV
         C3ojxOgJvX298xpzn0UWLGNyEUzw9x37jjwzo+qZCxKsq12TO9+rUjdcUsgWZVbBnYqf
         TuM7+Uu6jw9PtVfSrIBo60xlsAikyLGCsXBvwXy6WrDfaeazn0ateanF9rYdULTQuGOg
         MKFZnM52h2wgRcXGS6A/1oCC98ZXsEvmztiDEV3unZKWHnIWmCAC9PS+0qmo0VgTP0ml
         82IiPTh6p2kb1EFOheD13Gl2Z1L41wO5xlfGsWuOQufvNFfQb3l/YWRlT3URU23tR+A4
         c6gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682070249; x=1684662249;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kSmVunaujXkgtLmcclqS5Ly4hFKCHl7gI/mH+YJFHrw=;
        b=LfVx26wGhF6lNfskxVkeiLG4qIVJmUTOxhh2Gy9xTBfegeSm8aKzXUKnZbqtIyGp7r
         JJfN80HJ2jLdnehbFJQr2QOGGuwQFXgiEcrffmCK7u7bW7/5iIERAK/UK0lYZnsIRoXk
         hQzLP31yTL0av/+uj0hWaebfosWg9TUrKq1gPp1HZdy1z26O3Nbj4zdpr1YagPHp1jeW
         fOsBEdocrFtTuT8Ma+jyd5XPAOVoCuZfZR1w8XkoFdX4syetPEMQZX3u3WjcN5WhqOaF
         0QWkD+BSBPWp4Cdq9+MH+5mN0tpsrcZkl1I/OYGyCrF8/0tIko/NrqM62ZAii0q5LcWq
         i/JQ==
X-Gm-Message-State: AAQBX9fD//NyRmbvKUcINja2T0qNIHmKT7eNa5QtVvDHfpzKhT1rlpn3
        HUirTPJwbyrXnqtRhy9CfSnw6Y6x9GGt8Q==
X-Google-Smtp-Source: AKy350bspsOcBgT8CFMzjARPtIxzWqP6Q1C3HOBSozVZy+p2+nBYlGXWJxkrgH1ee7jlLUs7P8VsfFL+o3QvxA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:d1d0:0:b0:b98:6352:be19 with SMTP id
 i199-20020a25d1d0000000b00b986352be19mr960984ybg.9.1682070249761; Fri, 21 Apr
 2023 02:44:09 -0700 (PDT)
Date:   Fri, 21 Apr 2023 09:43:57 +0000
In-Reply-To: <20230421094357.1693410-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230421094357.1693410-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230421094357.1693410-6-edumazet@google.com>
Subject: [PATCH net-next 5/5] net: optimize napi_threaded_poll() vs RPS/RFS
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We use napi_threaded_poll() in order to reduce our softirq dependency.

We can add a followup of 821eba962d95 ("net: optimize napi_schedule_rps()")
to further remove the need of firing NET_RX_SOFTIRQ whenever
RPS/RFS are used.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/netdevice.h |  3 +++
 net/core/dev.c            | 12 ++++++++++--
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index a6a3e9457d6cbc9fcbbde96b43b4b21878495403..08fbd4622ccf731daaee34ad99773d6dc2e82fa6 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3194,7 +3194,10 @@ struct softnet_data {
 #ifdef CONFIG_RPS
 	struct softnet_data	*rps_ipi_list;
 #endif
+
 	bool			in_net_rx_action;
+	bool			in_napi_threaded_poll;
+
 #ifdef CONFIG_NET_FLOW_LIMIT
 	struct sd_flow_limit __rcu *flow_limit;
 #endif
diff --git a/net/core/dev.c b/net/core/dev.c
index 7d9ec23f97c6ec80ec9f971f740a9da747f78ceb..735096d42c1d13999597a882370ca439e9389e24 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4603,10 +4603,10 @@ static void napi_schedule_rps(struct softnet_data *sd)
 		sd->rps_ipi_next = mysd->rps_ipi_list;
 		mysd->rps_ipi_list = sd;
 
-		/* If not called from net_rx_action()
+		/* If not called from net_rx_action() or napi_threaded_poll()
 		 * we have to raise NET_RX_SOFTIRQ.
 		 */
-		if (!mysd->in_net_rx_action)
+		if (!mysd->in_net_rx_action && !mysd->in_napi_threaded_poll)
 			__raise_softirq_irqoff(NET_RX_SOFTIRQ);
 		return;
 	}
@@ -6631,11 +6631,19 @@ static int napi_threaded_poll(void *data)
 
 			local_bh_disable();
 			sd = this_cpu_ptr(&softnet_data);
+			sd->in_napi_threaded_poll = true;
 
 			have = netpoll_poll_lock(napi);
 			__napi_poll(napi, &repoll);
 			netpoll_poll_unlock(have);
 
+			sd->in_napi_threaded_poll = false;
+			barrier();
+
+			if (sd_has_rps_ipi_waiting(sd)) {
+				local_irq_disable();
+				net_rps_action_and_irq_enable(sd);
+			}
 			skb_defer_free_flush(sd);
 			local_bh_enable();
 
-- 
2.40.0.634.g4ca3ef3211-goog

