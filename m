Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35B746A03F9
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 09:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233619AbjBWIi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 03:38:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233563AbjBWIiz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 03:38:55 -0500
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90B07126FD
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 00:38:47 -0800 (PST)
Received: by mail-qv1-xf4a.google.com with SMTP id l13-20020ad44d0d000000b004c74bbb0affso4817529qvl.21
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 00:38:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1yTiKg63eFS2aK0tMGVjSqCE80+k14/jMKl3Ks+3fYQ=;
        b=Xl0z4DJWd0vwYJg8jDQmSQHP0SHBvISdqIa8OY7qLs7AdD4rws+UaSOZFm9P/Htifu
         LUsjJGTJzOC0QruOWBFlwDIppK1k3YMpPVOuURTamLLabEdMeM/ZPHLZR8ydgJ4VQofv
         ZMHW7Q+bKSCA3OLaBLn0zsSTf8TPU/MPiOTiR9gALdRXDXF9t1sx//TxMjK8Z6HOKwAv
         2Ol9hEI4d6642eMhr1dpanzjKWdmJSasC7XiLK32o/S3kKmNtzux9E1F27HsmjbbN7LO
         vpqF8wKUDRMihpt2vsFzU0qVOmUvsvagdzwA/abDEVssREkPNAw7t0m7sz+fBbfPzAjp
         zc4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1yTiKg63eFS2aK0tMGVjSqCE80+k14/jMKl3Ks+3fYQ=;
        b=XRYB9GBexX1Qu4Z9XryjJlDox0gXg1NtLmzEowCmAmOkP9kQ5Sav4RR5Cto5mEZGFO
         zjKcghvNFeocfr/XIFIwileYGd970+QO9mcgNL9SzIoZzAU3O9l/gHh+/s9b+x8SJ0D7
         wV0h/Hw5lkSG3FbwuNiaqnDGKJ3ZUUYyC9envj4eWIqr0fqzlFWr25kuSwa+btHdHiZ3
         j7kXNoU7UwHt76FTokQSUqD+sqrqm0VAhf0BXHjsI8fzDedtiiptWN55Ltq4zY3uOOMK
         mgtdh7wAVxvY+xnYp1Y1bTttneNsjbgr3hP0ApofcmynZkxrdko/6qGRSBp/m1WtgaKi
         wHdA==
X-Gm-Message-State: AO0yUKX/AWSDuvBXZHZnnyWlJ6uh4RRqTUYztktEDZPHO7bacEUYU/y7
        YyYqCXk08z3DpxXlWKUtuSxcDDRww51jJA==
X-Google-Smtp-Source: AK7set9yBpWL4mWohW35pGitEXAVNxAKbHkr1K8s19SBv2EpVZ6QcAoyYG5sB0fgjrhwChFv7Bnyk6myxgBdNQ==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:ad4:4b30:0:b0:56e:9339:a0c9 with SMTP id
 s16-20020ad44b30000000b0056e9339a0c9mr1513535qvw.1.1677141526725; Thu, 23 Feb
 2023 00:38:46 -0800 (PST)
Date:   Thu, 23 Feb 2023 08:38:45 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230223083845.1555914-1-edumazet@google.com>
Subject: [PATCH v2 net] net: fix __dev_kfree_skb_any() vs drop monitor
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        Yunsheng Lin <linyunsheng@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dev_kfree_skb() is aliased to consume_skb().

When a driver is dropping a packet by calling dev_kfree_skb_any()
we should propagate the drop reason instead of pretending
the packet was consumed.

Note: Now we have enum skb_drop_reason we could remove
enum skb_free_reason (for linux-6.4)

v2: added an unlikely(), suggested by Yunsheng Lin.

Fixes: e6247027e517 ("net: introduce dev_consume_skb_any()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Yunsheng Lin <linyunsheng@huawei.com>
---
 net/core/dev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 18dc8d75ead9795163ace74e8e86fe35cb9b7552..253584777101f2e6af3fc30107516f1e1197f8d3 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3134,8 +3134,10 @@ void __dev_kfree_skb_any(struct sk_buff *skb, enum skb_free_reason reason)
 {
 	if (in_hardirq() || irqs_disabled())
 		__dev_kfree_skb_irq(skb, reason);
+	else if (unlikely(reason == SKB_REASON_DROPPED))
+		kfree_skb(skb);
 	else
-		dev_kfree_skb(skb);
+		consume_skb(skb);
 }
 EXPORT_SYMBOL(__dev_kfree_skb_any);
 
-- 
2.39.2.637.g21b0678d19-goog

