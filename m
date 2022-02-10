Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 182764B14BF
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 18:58:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245432AbiBJR5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 12:57:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245426AbiBJR5T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 12:57:19 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65D3A25D1
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 09:57:20 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id y8so8867925pfa.11
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 09:57:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BPLJSUrEN/N+MaTI9DZxGaP3H2W+QXqIrXaMJvnCzAI=;
        b=D0s38nZctv6y3Y6yBFHMMoDyQq3siD/N9GOmtmDbo/amK/gNxJQIUXYbBFlSPBdI29
         ueY/85mTTHPPp8o4ceg1qdlqdW+TW2YAGK2jdduKC8zl6Nbm79dbAUDb3mJJsd1IsAaU
         uOb+g4+fA8Isigr3Nnp3wjtatORQgmAvSHyzCRN6nQRi2b60Ml58wX+q9doP8QDtA3cM
         mShpzVnOhWMjPXrWxBCz4YdnSwj0W9RrPE+SjnUyZe8EscVicvuBi36W7Fjp9Vp/w4w6
         WSO/pIYob/qfx3g4T0e7pWf/2ILVkZKEQar35kJ7941jno3i59KpKTn3kz1hpQPoDdv2
         EGXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BPLJSUrEN/N+MaTI9DZxGaP3H2W+QXqIrXaMJvnCzAI=;
        b=zMhbn7Y203uQVgxW871h6iLB2WqQSDqXdMutnqqFbrwjvPEboywwDVANtqWvmlOTG+
         e6m4rBt41+7n80xJFqPCMQoQ9vo5BOSvvcz8vXfnN5KLUj/EADHvwJlCYdYmkqNafUen
         MSlulL4TRSVxINIQ6T+5LmVEKxP2OR6iWeb2sa0QM7K08r5yEH52/n5e/92kPR5BhzBO
         TrNB0Tl1ZOmHRfL1bsFVkd4nVuneVJnwElaRDJq7wJZooBryXurU+0DgzALa8lVkMEEW
         4HLymEgKU5TbW82wT1pDN4hjQEDpeJYAOSn6tRzcC2uNMewz5tWCZP051KcCxM264ZLQ
         qnsw==
X-Gm-Message-State: AOAM5316aTE14AMumqJuS+lzgmFRFF+lqV78CF914hZBpI5dET1+dhW6
        YMuATnXOTjRss07bf/7BBSE=
X-Google-Smtp-Source: ABdhPJxYWvcZT6SSicN9DO4n8g1xQHUsar6mBQsHCusoN99ornS9SG5sUpdaLbeX0AqRwSUDhDWNmw==
X-Received: by 2002:a63:2b49:: with SMTP id r70mr7092217pgr.111.1644515839856;
        Thu, 10 Feb 2022 09:57:19 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c3d8:67ff:656a:cfd9])
        by smtp.gmail.com with ESMTPSA id t3sm26230634pfg.28.2022.02.10.09.57.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 09:57:19 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 4/4] net: introduce a config option to tweak MAX_SKB_FRAGS
Date:   Thu, 10 Feb 2022 09:55:57 -0800
Message-Id: <20220210175557.1843151-5-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
In-Reply-To: <20220210175557.1843151-1-eric.dumazet@gmail.com>
References: <20220210175557.1843151-1-eric.dumazet@gmail.com>
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

Currently, MAX_SKB_FRAGS value is 17.

For standard tcp sendmsg() traffic, no big deal because tcp_sendmsg()
attempts order-3 allocations, stuffing 32768 bytes per frag.

But with zero copy, we use order-0 pages.

For BIG TCP to show its full potential, we add a config option
to be able to fit up to 45 segments per skb.

This is also needed for BIG TCP rx zerocopy, as zerocopy currently
does not support skbs with frag list.

We have used MAX_SKB_FRAGS=45 value for years at Google before
we deployed 4K MTU, with no adverse effect.

Back then, goal was to be able to receive full size (64KB) GRO
packets without the frag_list overhead.

By default we keep the old/legacy value of 17 until we get
more coverage for the updated values.

Sizes of struct skb_shared_info on 64bit arches

MAX_SKB_FRAGS | sizeof(struct skb_shared_info)
----------------------------------------------
         17     320
         21     320+64  = 384
         25     320+128 = 448
         29     320+192 = 512
         33     320+256 = 576
         37     320+320 = 640
         41     320+384 = 704
         45     320+448 = 768

This inflation might cause problems for drivers assuming they could pack
both the incoming packet and skb_shared_info in half a page, using build_skb().

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/skbuff.h | 14 ++------------
 net/Kconfig            | 12 ++++++++++++
 2 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index a5adbf6b51e86f955b7f4fcd4a65e38adce97601..6bba71532415019d33cd98e172b5469fa7a5c1bd 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -349,18 +349,8 @@ enum skb_drop_reason {
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
+#define MAX_SKB_FRAGS CONFIG_MAX_SKB_FRAGS
+
 extern int sysctl_max_skb_frags;
 
 /* Set skb_shinfo(skb)->gso_size to this in case you want skb_segment to
diff --git a/net/Kconfig b/net/Kconfig
index 8a1f9d0287de3c32040eee03b60114c6e6d150bc..7b96047911ee78bf61e9a290ad430261e4fc91c8 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -253,6 +253,18 @@ config PCPU_DEV_REFCNT
 	  network device refcount are using per cpu variables if this option is set.
 	  This can be forced to N to detect underflows (with a performance drop).
 
+config MAX_SKB_FRAGS
+	int "Maximum number of fragments per skb_shared_info"
+	range 17 45
+	default 17
+	help
+	  Having more fragments per skb_shared_info can help GRO efficiency.
+	  This helps BIG TCP workloads, but might expose bugs in some
+	  legacy drivers.
+	  This also increases memory overhead of small packets,
+	  and in drivers using build_skb().
+	  If unsure, say 17.
+
 config RPS
 	bool
 	depends on SMP && SYSFS
-- 
2.35.1.265.g69c8d7142f-goog

