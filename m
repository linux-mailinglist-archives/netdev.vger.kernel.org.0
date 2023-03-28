Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D76B26CCE34
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 01:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbjC1Xui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 19:50:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjC1Xug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 19:50:36 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C358830F0
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 16:50:34 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id z31-20020a25a122000000b00b38d2b9a2e9so13520663ybh.3
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 16:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680047434;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lI11w/Do13rM5XEs6gwRmGkp9V1Tnl1ahKYH1ibL3JY=;
        b=M5ZS5aDA83E0YJiCbubvDs1tSoehbSW+3Pv12t8qIdZNV62MiWEYiwJ8RsH93rMI5J
         y5/c+I3TibLrXg8nrLLwMW3Oc45BD2FGvIuZct3Suy7Jjct7OuhzDrUM9Vt4v/mVRvdz
         /pBpEa7jLMovGOm6QHDRPt4qyyOIueL2X5OtrrPWakM0wZ8TxIRylA/wSYKCba/16lU3
         VpIysDOeCibwjFC+bLpAIu8ccRK1AzPkNu+2/tjiqbW3TuZCrazArq0A80eQN7W/d2gs
         IqvWppBQ4pMQJkuYni4ZDpLU9uhdDQzsnQxA9WmxGceLMgZWDiaJlnQ7PKS+UacNYmq1
         gIKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680047434;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lI11w/Do13rM5XEs6gwRmGkp9V1Tnl1ahKYH1ibL3JY=;
        b=w/+mN9ZulPasVfZzFwLy3gSmEApTtOD3mfx55fZtz1WgrItt9nebk2XWql4jJJoJUM
         xF5MK6Ds/rlvy5tKJ6OxNCQD/MbG53eyr8qq8mwl3CcquGnkW3IcdW4tKOGKkDjwB2/P
         ny/uGXDDkBvr5Bh4A1D0f6MGy/a8w9e3RArPGIFbK8WJbpMCnXoos75FxnKZROVZ9xhR
         TgX3ULuY8pUOJbpscZ5ou/dUPxQxaDATINJ0vcym6FoVKhQ7+Sc5Z83aVCD3Jgpj0tRJ
         7n9Sf08NlQ96RLkgGrm6tdl6sPqdQfeB9yvLKXmbbbkoI6w6Zqt1mIU+8IPRamkNhom0
         gFMg==
X-Gm-Message-State: AAQBX9eXT+j3H6ej8H7ERbGvSg2bT2ogtdkZqjWFwc9YoJp63Rlduhaa
        yxZkpAtlKUAKT+ylQnTVI3JjjRbFpDwUlg==
X-Google-Smtp-Source: AKy350a10HSZmAbIWMkPwKBEoAY5LdusGuD5taaK76GtdT51J6C9Q+XfWy88/xm62kvq9OuA0eOXkVpGkEUHlw==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:b711:0:b0:545:7143:2940 with SMTP id
 v17-20020a81b711000000b0054571432940mr248679ywh.0.1680047433934; Tue, 28 Mar
 2023 16:50:33 -0700 (PDT)
Date:   Tue, 28 Mar 2023 23:50:19 +0000
In-Reply-To: <20230328235021.1048163-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230328235021.1048163-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230328235021.1048163-3-edumazet@google.com>
Subject: [PATCH net-next 2/4] net: add softnet_data.in_net_rx_action
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Jason Xing <kernelxing@tencent.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We want to make two optimizations in napi_schedule_rps() and
____napi_schedule() which require to know if these helpers are
called from net_rx_action(), instead of being called from
other contexts.

sd.in_net_rx_action is only read/written by the owning cpu.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/netdevice.h | 1 +
 net/core/dev.c            | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 18a5be6ddd0f7c1a7b8169440808bc66c991d8de..c8c634091a65966fee661695d34ba8a7cf2cd8e7 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3188,6 +3188,7 @@ struct softnet_data {
 #ifdef CONFIG_RPS
 	struct softnet_data	*rps_ipi_list;
 #endif
+	bool			in_net_rx_action;
 #ifdef CONFIG_NET_FLOW_LIMIT
 	struct sd_flow_limit __rcu *flow_limit;
 #endif
diff --git a/net/core/dev.c b/net/core/dev.c
index f7050b95d125014d00f4c876175b1569d82525cd..15331edbacf4ca59aa5772c29e95cacd3c106e3f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6646,6 +6646,7 @@ static __latent_entropy void net_rx_action(struct softirq_action *h)
 	LIST_HEAD(list);
 	LIST_HEAD(repoll);
 
+	sd->in_net_rx_action = true;
 	local_irq_disable();
 	list_splice_init(&sd->poll_list, &list);
 	local_irq_enable();
@@ -6656,6 +6657,7 @@ static __latent_entropy void net_rx_action(struct softirq_action *h)
 		skb_defer_free_flush(sd);
 
 		if (list_empty(&list)) {
+			sd->in_net_rx_action = false;
 			if (!sd_has_rps_ipi_waiting(sd) && list_empty(&repoll))
 				goto end;
 			break;
@@ -6682,6 +6684,8 @@ static __latent_entropy void net_rx_action(struct softirq_action *h)
 	list_splice(&list, &sd->poll_list);
 	if (!list_empty(&sd->poll_list))
 		__raise_softirq_irqoff(NET_RX_SOFTIRQ);
+	else
+		sd->in_net_rx_action = false;
 
 	net_rps_action_and_irq_enable(sd);
 end:;
-- 
2.40.0.348.gf938b09366-goog

