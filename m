Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 097A5612448
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 17:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbiJ2Pp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 11:45:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiJ2Pp1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 11:45:27 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84B5362A8F
        for <netdev@vger.kernel.org>; Sat, 29 Oct 2022 08:45:26 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id h9-20020a25e209000000b006cbc4084f2eso6954956ybe.23
        for <netdev@vger.kernel.org>; Sat, 29 Oct 2022 08:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mAhikDCYsTVoykDfFXufN3qfUUCZU6VugouuIlfHJYM=;
        b=mI56OTqtJ6BYMK8ASTZDj9XQcqo67qGoByoUPLpbCYy0b+Juu2WHZRlBKfIP/OR9VG
         FfmdxNfa8upy9d9J2Nfv0wtU+sPq2vmwlhTQx0p0gKVwROoxwViwNECapOGpn8Io0YoL
         +hZkePOfQOE15/rHYloPvwlM2NsXlX+kherqYX+BOv3KcpHrKKdz8R7n5/MKVU4jfNrw
         Kiu9f4qLDdHVr6OPh1kfSq37qbgyyzXn3tex/+fkNanp9EOFD7pGxhMR9kvcRV/yAc0j
         j3ax9YgAADUt9xvJyjcvQG48kxF/je+zGWdZCBEMrCdZbRHjtc7sYsLQQZET5GLlaez9
         PzUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mAhikDCYsTVoykDfFXufN3qfUUCZU6VugouuIlfHJYM=;
        b=0MkvFLtM/WajbPQawHHBdK4qOk4X9HZD2MPftKAznrYVa1FPDTmNRsAm122awJRtvK
         glwnsg/BxCTm7yEa975wRG9p0OkfZirfrwo7VlqUjkIVcHzjQ7ydZEHjuaJW1g6BVBrM
         YtbkfSD790lQx6d2FpIqSyZ5ueOUfErL+Nj4emKO+FjEHSBqe2uICXcgiVYwqlRWul9T
         rFzsd4Ce5x/SMmIChWtlYh3bYIYlGP1h3jmP5GOFZqnNtPhyhh45VujI7DjDvEepyPpu
         5mN7JYRZAzIA99AfXUT5lQOwZh0DGYteeklh4S6EmIQILC58PPot5BB4obLGl5VhL27L
         fPpA==
X-Gm-Message-State: ACrzQf1wtZ5Zz/GEY0IoiCOsn1UDPI1H16p7SG2NSW/aDlhq38pxbIOz
        QEieYXa0OC5jCz6AzkKmV4WF9FcpbcZ5hQ==
X-Google-Smtp-Source: AMsMyM7iO3/YkFWasJ6QqFeDF8dw5lxy/jvrKkRYkYX9bimpJdO8JKUlYYYBthZ39xr77j7AIxfe1wzjgqdstA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:8309:0:b0:36a:6aa5:bfbd with SMTP id
 t9-20020a818309000000b0036a6aa5bfbdmr8ywf.15.1667058325350; Sat, 29 Oct 2022
 08:45:25 -0700 (PDT)
Date:   Sat, 29 Oct 2022 15:45:16 +0000
In-Reply-To: <20221029154520.2747444-1-edumazet@google.com>
Mime-Version: 1.0
References: <20221029154520.2747444-1-edumazet@google.com>
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221029154520.2747444-2-edumazet@google.com>
Subject: [PATCH v2 net-next 1/5] net: dropreason: add SKB_CONSUMED reason
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

This will allow to simply use in the future:

	kfree_skb_reason(skb, reason);

Instead of repeating sequences like:

	if (dropped)
	    kfree_skb_reason(skb, reason);
	else
	    consume_skb(skb);

For instance, following patch in the series is adding
@reason to skb_release_data() and skb_release_all(),
so that we can propagate a meaningful @reason whenever
consume_skb()/kfree_skb() have to take care of a potential frag_list.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/dropreason.h | 2 ++
 net/core/skbuff.c        | 6 +++++-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/net/dropreason.h b/include/net/dropreason.h
index c1cbcdbaf1492c6bd5a18b9af0a0e0beb071c674..0bd18c14dae0a570a150c31eeea99fe85bc734b0 100644
--- a/include/net/dropreason.h
+++ b/include/net/dropreason.h
@@ -80,6 +80,8 @@ enum skb_drop_reason {
 	 * @SKB_NOT_DROPPED_YET: skb is not dropped yet (used for no-drop case)
 	 */
 	SKB_NOT_DROPPED_YET = 0,
+	/** @SKB_CONSUMED: packet has been consumed */
+	SKB_CONSUMED,
 	/** @SKB_DROP_REASON_NOT_SPECIFIED: drop reason is not specified */
 	SKB_DROP_REASON_NOT_SPECIFIED,
 	/** @SKB_DROP_REASON_NO_SOCKET: socket not found */
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 1d84a17eada502cf0f650d261cc7de5f020afb63..7ce797cd121f395062b61b33371fb638f51e8c99 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -94,6 +94,7 @@ EXPORT_SYMBOL(sysctl_max_skb_frags);
 #undef FN
 #define FN(reason) [SKB_DROP_REASON_##reason] = #reason,
 const char * const drop_reasons[] = {
+	[SKB_CONSUMED] = "CONSUMED",
 	DEFINE_DROP_REASON(FN, FN)
 };
 EXPORT_SYMBOL(drop_reasons);
@@ -894,7 +895,10 @@ kfree_skb_reason(struct sk_buff *skb, enum skb_drop_reason reason)
 
 	DEBUG_NET_WARN_ON_ONCE(reason <= 0 || reason >= SKB_DROP_REASON_MAX);
 
-	trace_kfree_skb(skb, __builtin_return_address(0), reason);
+	if (reason == SKB_CONSUMED)
+		trace_consume_skb(skb);
+	else
+		trace_kfree_skb(skb, __builtin_return_address(0), reason);
 	__kfree_skb(skb);
 }
 EXPORT_SYMBOL(kfree_skb_reason);
-- 
2.38.1.273.g43a17bfeac-goog

