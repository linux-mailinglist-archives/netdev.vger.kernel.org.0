Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC6A4A7D91
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 02:52:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348904AbiBCBwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 20:52:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348908AbiBCBwK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 20:52:10 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F871C061748
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 17:52:09 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id p12-20020a17090a2d8c00b001b833dec394so1443920pjd.0
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 17:52:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=d/B0d3cGtclr+pLkrCyge6p5gEccpZdBGmC47ldZYSc=;
        b=kq8P73474SO0VbumbnofY4G5ocZu+s2760zWjGKmjwexSZeC0bEfFLuvfhyWLTo8E6
         +VWjA3px8xU85iU8uKeXSTDJkdHiFToTTQlZlu/s9sQdmlUUmRsqdYg1S1yznlbd1L+Q
         fY0+Odifq47dHJCJgMK5ZgYYwnqN+ahr9UxCjt6TSet3tuqj+RPPlpgcyd5BK+p1GOlr
         EDC8JE8tXCsLB0IY/QJ0dbYRyf3jdVtfxhYrLji1SPmxvSfFH0bN8wwafOCv6gKj8Oe+
         dEGxHok8iusMrQ9cbqK10cyGcpmJKOInNRQkBWErku+veY/TJwJQSpZYn9v8PIavfZhn
         3ZcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d/B0d3cGtclr+pLkrCyge6p5gEccpZdBGmC47ldZYSc=;
        b=DrI04tEIGjxMRcf0CnDtjdi5Imv368/ccs9c16TA5yymtGOFpydeolB7F4JQX5AK7w
         s7gMDP3c4bvt6B8kh7VdSwRJT/Uy+NNl2ih9OJQDhBRJIbPup/zS0mDlNEtqDNtbidPW
         ZGP/ZPefy05tpqsTG+kR+byWGCD2ZK6sVVK6s5ynPrQ5jweYsutZulcU7LUGpxyxSpyT
         wrVCjv+70g/x/GlTsewl8ruyxptDX0AIaIVW5Ykd5gLV2DE1d7W6PCOfvZ7HrEA4BT0H
         fbp4DxMzm4EjNIMHISToLuUFYNDc064Vbw/9Dwb29SNK4BzgM5YD8Vay3DhiU3UgO6Xi
         dMlw==
X-Gm-Message-State: AOAM530f2nPiihdZlgTi+Em8Bnj75YuleaWA7v0GFtBNAk0RzC0X/D2e
        21Y6SlARBvuXmsVRv4DHrvQ=
X-Google-Smtp-Source: ABdhPJwbVljup/k4R/MRGAoU0NBZUOYBt+oNwgyfbn3DZMLy2yWQmgIQkE7Ql4VpN7r9v/xrmkC6rA==
X-Received: by 2002:a17:902:ce81:: with SMTP id f1mr1715163plg.86.1643853128946;
        Wed, 02 Feb 2022 17:52:08 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:697a:fa00:b793:ed3a])
        by smtp.gmail.com with ESMTPSA id qe16sm509611pjb.22.2022.02.02.17.52.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 17:52:08 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 09/15] net: increase MAX_SKB_FRAGS
Date:   Wed,  2 Feb 2022 17:51:34 -0800
Message-Id: <20220203015140.3022854-10-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
In-Reply-To: <20220203015140.3022854-1-eric.dumazet@gmail.com>
References: <20220203015140.3022854-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Currently, MAX_SKB_FRAGS value is 17.

For standard tcp sendmsg() traffic, no big deal because tcp_sendmsg()
attempts order-3 allocations, stuffing 32768 bytes per frag.

But with zero copy, we use order-0 pages.

For BIG TCP to show its full potential, we increase MAX_SKB_FRAGS
to be able to fit 45 segments per skb.

This is also needed for BIG TCP rx zerocopy, as zerocopy currently
does not support skbs with frag list.

We have used this MAX_SKB_FRAGS value for years at Google before
we deployed 4K MTU, with no adverse effect.
Back then, goal was to be able to receive full size (64KB) GRO
packets without the frag_list overhead.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/skbuff.h | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index a27bcc4f7e9a92ea4f4f4f6e5f454bb4f8099f66..08c12c41c5a5907dccc7389f396394d8132d962e 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -323,18 +323,8 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_MAX,
 };
 
-/* To allow 64K frame to be packed as single skb without frag_list we
- * require 64K/PAGE_SIZE pages plus 1 additional page to allow for
- * buffers which do not start on a page boundary.
- *
- * Since GRO uses frags we allocate at least 16 regardless of page
- * size.
- */
-#if (65536/PAGE_SIZE + 1) < 16
-#define MAX_SKB_FRAGS 16UL
-#else
-#define MAX_SKB_FRAGS (65536/PAGE_SIZE + 1)
-#endif
+#define MAX_SKB_FRAGS 45UL
+
 extern int sysctl_max_skb_frags;
 
 /* Set skb_shinfo(skb)->gso_size to this in case you want skb_segment to
-- 
2.35.0.rc2.247.g8bbb082509-goog

