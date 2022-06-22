Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E189C554225
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 07:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356602AbiFVFNK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 01:13:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356580AbiFVFND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 01:13:03 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A539634677
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 22:13:02 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id m68-20020a253f47000000b006683bd91962so13762599yba.0
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 22:13:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=wwSFzfJ2SWCyUmQ5lfdkSc585bMTz54WWciPG1drR9k=;
        b=iiIkdUb0DjlyAlcyjfNGEe3jXtSi0qOd68fEW2hV/j9y6UCnAZOzQSpQg4fRb+jyRp
         AIAPvS5VOE+VvNLr3oeopI09vHEhMFFqMMrU6mRILMQfXFG61NelWVOGa+bgHa5l9pOw
         wghHxxXjFoZclu3tog/zBsBWbOb+E3k85v2ec7SulVTZagM0sniHZLdLdqFHf4r8Mlto
         MZyOO3DY2jQBsXzp6MPEm0ESubH0b86aTHseKEbm/RBdq+CBCzy4ZqfD1q8KLjjkKCkA
         X0jP0reRy3eb+hi+AO2SRYUzy6dI6gAQkMwGIuI9hMRaTExSrnXmKyDd6fU8IKN3f+JR
         QmvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wwSFzfJ2SWCyUmQ5lfdkSc585bMTz54WWciPG1drR9k=;
        b=V1CS00byh2Mstfq7GhPjvOkKzSR1SgG7IyspehJGmdBmjICxUEbf/bUV6mQ1/IfEyc
         bmD1grEUpUn3OpBu87IPjl+19KG9SbKorvQQuPs1ikahhGIiwNoqAs9AdGP1qBKGoH9S
         05kjfgCypjfiMYq81ZwNkNRiUmFXjKSsth4PvLb0Dy8+hHaUh0JYevO72JP5DelkEP2a
         JqDp/SsTbU6Ss+/smagWW0JB6buL5H3zrEPPfKdoDyU9OZXRcvDcZmyE/zhxfgh7buh5
         dCtkpN55BeVAVlPiFmwyVtzot9cjKSz7z1ZlAEdJ6nBQTGho4oRuoSAfUK+2yBLnDdqj
         bR+A==
X-Gm-Message-State: AJIora9uQJGFQfFrPWAhiG3Zmg86+oo6Vpzdph5S2fIWxe6NXgKuvczQ
        Bs2Hu09/2bLEHefBSqMu9kJln1SZJsMLDw==
X-Google-Smtp-Source: AGRyM1ubtKpqhlhItj0Unnk9R7vs+4xKuFGW8Rr8Ho+wPiw64C4lzwFUstwu9FU1x0/IagbhGx6Y6H8xgxd7fw==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a0d:d9cb:0:b0:317:760e:991e with SMTP id
 b194-20020a0dd9cb000000b00317760e991emr2167503ywe.6.1655874781834; Tue, 21
 Jun 2022 22:13:01 -0700 (PDT)
Date:   Wed, 22 Jun 2022 05:12:37 +0000
In-Reply-To: <20220622051255.700309-1-edumazet@google.com>
Message-Id: <20220622051255.700309-2-edumazet@google.com>
Mime-Version: 1.0
References: <20220622051255.700309-1-edumazet@google.com>
X-Mailer: git-send-email 2.37.0.rc0.104.g0611611a94-goog
Subject: [PATCH net-next 01/19] ip6mr: do not get a device reference in pim6_rcv()
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

pim6_rcv() is called under rcu_read_lock(), there is
no need to use dev_hold()/dev_put() pair.

IPv4 side was handled in commit 55747a0a73ea
("ipmr: __pim_rcv() is called under rcu_read_lock")

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv6/ip6mr.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index d4aad41c9849f977e395e9e07a4442dbfec07b1b..aa66c032ba979e7a14e5e296b68c55bc73d98398 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -554,7 +554,6 @@ static int pim6_rcv(struct sk_buff *skb)
 	read_lock(&mrt_lock);
 	if (reg_vif_num >= 0)
 		reg_dev = mrt->vif_table[reg_vif_num].dev;
-	dev_hold(reg_dev);
 	read_unlock(&mrt_lock);
 
 	if (!reg_dev)
@@ -570,7 +569,6 @@ static int pim6_rcv(struct sk_buff *skb)
 
 	netif_rx(skb);
 
-	dev_put(reg_dev);
 	return 0;
  drop:
 	kfree_skb(skb);
-- 
2.37.0.rc0.104.g0611611a94-goog

