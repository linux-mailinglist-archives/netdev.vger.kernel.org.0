Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE86569FFDC
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 01:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231844AbjBWAHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 19:07:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjBWAHR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 19:07:17 -0500
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 761A0234D3
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 16:07:16 -0800 (PST)
Received: by mail-qv1-xf4a.google.com with SMTP id nv18-20020a056214361200b0053547681552so4624950qvb.8
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 16:07:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1KAwdvZp4FL0OO2S/gaQ4UnwhEv9xn9ZeveewiOGaeI=;
        b=dbJVN9ARMXWA7zaQ8cgK9X7jJhO4zdg+Fhy+W4rFYlOghrtoPJk4YXxkCi0/DcGKhB
         ipZFxERl4KfjmbRhYkUPHwfRFjYtqrJow9ntVhKSuCJ8Jo084IllfmswJtJ5oEYRQgbp
         +qJRFjhlR93wYzurblmTyzHxnf82Tc7KjPNd4grPLh1qQFK9Fdfq02OuCvhxS8QsXevs
         VWJ6AnH/a1NdjxUnxRNs19HTup0gAAOQbloZisFacUOEWkBCernLMVH5M8uL6dUrtxGv
         snkk5QPqfiCelOA5YfLn6rVmkWjBUAIYz/8RDigVcpkYqFG1kcsQdesH/xKhgoPljkAk
         NbGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1KAwdvZp4FL0OO2S/gaQ4UnwhEv9xn9ZeveewiOGaeI=;
        b=mqcBzfkQ9H8jrOqNOSSscEUgvTAPlsKyb0+co/BJMmRbZxyYgD8U8MOjaPkt+r1e5M
         ISYvmhLH8A8Zx0rT8ZFJU2oQvrMdRJMr5c0t6Jpqdeic7yzyVvV/52kVNmhxTpEKYkot
         nGUV2iBncAg1fhGkTzGH/6jAnrW5YdtiK1T5E4RNppLtV9NMgj++yB4UyNEteOwpbKTN
         6W4cBLAzT2hg2d1d+hh2jDIDQhZTU00KE5HLqNY8rIfucubfeAoF1kcfl2i6l6P32bzG
         Iii34ggBUENPrfcIFJtTc337+LAskejpVLNUBly+quGuphPAwm5V4Ix9ue6khjyc1Ud0
         I4kw==
X-Gm-Message-State: AO0yUKWFi3eFe4680u9RooYr+G0vOAQSn4N+bJP3YbM59pnSWfEFmewp
        vR5LFttoEoSt9Ovf8lDHZjq2FigtKQAc4Q==
X-Google-Smtp-Source: AK7set+4GLd5EUlgkNHZml76+K4wasc/UWg1eOq1Flx6iR1LXyVcjJobyJQm4eAfB5+pNYah6pJ33IbL2E2TaQ==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:620a:808e:b0:72b:25b4:565d with SMTP
 id ef14-20020a05620a808e00b0072b25b4565dmr2033065qkb.3.1677110835604; Wed, 22
 Feb 2023 16:07:15 -0800 (PST)
Date:   Thu, 23 Feb 2023 00:07:13 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230223000713.1407316-1-edumazet@google.com>
Subject: [PATCH net] net: fix __dev_kfree_skb_any() vs drop monitor
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>
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

Fixes: e6247027e517 ("net: introduce dev_consume_skb_any()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/dev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 18dc8d75ead9795163ace74e8e86fe35cb9b7552..2bf60afde1e2e4be4806070754ae7486705c5237 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3134,8 +3134,10 @@ void __dev_kfree_skb_any(struct sk_buff *skb, enum skb_free_reason reason)
 {
 	if (in_hardirq() || irqs_disabled())
 		__dev_kfree_skb_irq(skb, reason);
+	else if (reason == SKB_REASON_DROPPED)
+		kfree_skb(skb);
 	else
-		dev_kfree_skb(skb);
+		consume_skb(skb);
 }
 EXPORT_SYMBOL(__dev_kfree_skb_any);
 
-- 
2.39.2.637.g21b0678d19-goog

