Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B37A6CCE36
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 01:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbjC1Xus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 19:50:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbjC1Xuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 19:50:39 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B1872D56
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 16:50:38 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id g5-20020a25a485000000b009419f64f6afso13614390ybi.2
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 16:50:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680047437;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qle7EcJhf9wAvmLeKsJIiO0NykPAV/M6lmpdlkwPDaA=;
        b=JaVncsTjZC6LsM1SWAOAc0+VCjISzXqV5E3f189Higv+Mz6LNyT9iBubdlcY18IYg/
         hrHfResoviJN7SiIRhyIADwRA6nv79fqvD/awfEE8DFlC9FunY1OD/d13AcZ9b/9nWRy
         htDwX8yYkgWXwQCG/GMRM4z/0mTGMFM2MB4XygvckMQkVYgd6MxoUBu+DfIsgqsldYFo
         SrEWLwKKZuW/Ywr7A8rjY1Eug7v3MVtUlfPAnlxKzSKB2tmo7V/WzL2yJLfZ9XS/zgIj
         U9ciUnK1auPXDhOZ21mwk+R+WPWMpNhsRCKniwEAp2TU+0RJ+YYwFegI9yMwlFKUaF/H
         yH3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680047437;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qle7EcJhf9wAvmLeKsJIiO0NykPAV/M6lmpdlkwPDaA=;
        b=kZuFjeWjw4IizFfteud12Uo4BG3tStl4IzcqD9SIByoLRiCqGVLKIlOG7eOcZ1O+98
         LCHTqpjAhERBUqT0WRbD4cltruPBxKfgtbVRcBpXwcq7N0ZsrxOLUsQmrWX/yAdn4SoX
         mUr6SvdIXdrZdHuqI+kIqERLu05InUUwhGy0wN0NZXRjiU4XSSbY40qXyj1T3h0NQbXG
         j2kQQw1BE/BDKMvZkzUN1yupIdD/+DHagbpckwKAKKh33OKSmsSvAZ2LFSq9GlSm5uJL
         GnOZONZhk7S7See2HHK7qYlmRAjN+64oEYHR8cmdK0smPml3iiOA0Aa7p7uMhSOEo1hK
         qb+A==
X-Gm-Message-State: AAQBX9cO0UhMBpPS+yaeX71C39mTG0oKziLn0OEB5LDv4q0gPJWo5q8F
        oEda9AmKE02lA7jihxBY/SUlIVGHMdvxMw==
X-Google-Smtp-Source: AKy350ZlHrzzFO4pkgqfBwW5balbdpBlI25mUJIW0gVrD5YnxAwy574J0zqZ8aMVJZYo3znoql9BqlwT7T0KBg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:1586:b0:b33:531b:3dd4 with SMTP
 id k6-20020a056902158600b00b33531b3dd4mr8750260ybu.1.1680047437700; Tue, 28
 Mar 2023 16:50:37 -0700 (PDT)
Date:   Tue, 28 Mar 2023 23:50:21 +0000
In-Reply-To: <20230328235021.1048163-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230328235021.1048163-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230328235021.1048163-5-edumazet@google.com>
Subject: [PATCH net-next 4/4] net: optimize ____napi_schedule() to avoid extra NET_RX_SOFTIRQ
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

____napi_schedule() adds a napi into current cpu softnet_data poll_list,
then raises NET_RX_SOFTIRQ to make sure net_rx_action() will process it.

Idea of this patch is to not raise NET_RX_SOFTIRQ when being called indirectly
from net_rx_action(), because we can process poll_list from this point,
without going to full softirq loop.

This needs a change in net_rx_action() to make sure we restart
its main loop if sd->poll_list was updated without NET_RX_SOFTIRQ
being raised.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Jason Xing <kernelxing@tencent.com>
---
 net/core/dev.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index f34ce93f2f02e7ec71f5e84d449fa99b7a882f0c..0c4b21291348d4558f036fb05842dab023f65dc3 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4360,7 +4360,11 @@ static inline void ____napi_schedule(struct softnet_data *sd,
 	}
 
 	list_add_tail(&napi->poll_list, &sd->poll_list);
-	__raise_softirq_irqoff(NET_RX_SOFTIRQ);
+	/* If not called from net_rx_action()
+	 * we have to raise NET_RX_SOFTIRQ.
+	 */
+	if (!sd->in_net_rx_action)
+		__raise_softirq_irqoff(NET_RX_SOFTIRQ);
 }
 
 #ifdef CONFIG_RPS
@@ -6648,6 +6652,7 @@ static __latent_entropy void net_rx_action(struct softirq_action *h)
 	LIST_HEAD(list);
 	LIST_HEAD(repoll);
 
+start:
 	sd->in_net_rx_action = true;
 	local_irq_disable();
 	list_splice_init(&sd->poll_list, &list);
@@ -6659,9 +6664,18 @@ static __latent_entropy void net_rx_action(struct softirq_action *h)
 		skb_defer_free_flush(sd);
 
 		if (list_empty(&list)) {
-			sd->in_net_rx_action = false;
-			if (!sd_has_rps_ipi_waiting(sd) && list_empty(&repoll))
-				goto end;
+			if (list_empty(&repoll)) {
+				sd->in_net_rx_action = false;
+				barrier();
+				/* We need to check if ____napi_schedule()
+				 * had refilled poll_list while
+				 * sd->in_net_rx_action was true.
+				 */
+				if (!list_empty(&sd->poll_list))
+					goto start;
+				if (!sd_has_rps_ipi_waiting(sd))
+					goto end;
+			}
 			break;
 		}
 
-- 
2.40.0.348.gf938b09366-goog

