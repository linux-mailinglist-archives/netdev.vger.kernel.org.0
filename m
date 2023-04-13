Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41B716E08BF
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 10:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbjDMISt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 04:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbjDMISr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 04:18:47 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E9C898
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 01:18:46 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id q2so19114300pll.7
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 01:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681373926; x=1683965926;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kAmMBdrEG6Lj7SHMBv3orC2G+DezqK0/RHG5IK0uzHQ=;
        b=FX3oRqSSAmDtgoA0va9ZYqU2v7a5/1mDJgF/q2wRc1+/qRo2zejghAi9kccm2ddvO1
         lEy8ngYmvrZDDv4twlH0URtrkO6dyA8sNJl3CelW1PFPowImU6tb2bZ4/MZ4qoe5vNuY
         3vzqoZZKzt988ac/+mPGZ0TlKzTI+7chusyfyq80hnvlbm0lknBGkAi2HNRu0+g5xLR7
         1v4t8okSxMA6BV2PUR4XZ24G3eDcSM8JnIfouNN57guk1Bsk1m3UrNZQ45cE+3wjteYi
         zvDNjrRU11KpEeVrAdbNrBtLyPuxSlTML1AhrDKmM2NMKVnuF6NWv9qWML+NibOn7C22
         wJsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681373926; x=1683965926;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kAmMBdrEG6Lj7SHMBv3orC2G+DezqK0/RHG5IK0uzHQ=;
        b=LmZaqa+cXfHLF7SuepjMvNQWABqGtTw/CuFhxoydXbqeRPftjKUGbd6Y9aKH6gWb4I
         Er71MPuih5Bi45zjC3UkhaUX00UIFYTy4aCN7sXN6K4GeZkgHM77yfE/hlYbBrSsqm52
         OCKpoAHo3jdxocMr8LhXM51goC/Pfw/MVMRCQwwLHfCX0hN5QvmNzHawxJo28N16gj19
         hUf25+Na1Y5K3rQEIsLNFlsZrYjWmQLscIfadk7R8jNSyJlsemekAM1GSPq1XZV96Qc/
         WJoqXlYz4SFaHzNnxhs5yyT/nXmMPZ1/ZNKhJw/FHlk4ktpKN+1yaBv8UFCQLIOuPo3Q
         U4OQ==
X-Gm-Message-State: AAQBX9ctM2FGRH3KZG2W/FF5pQPTZuo96s0WPFkX5lZ4HGcVjaQvWVRK
        gehuoE9qTjr04GddsVU2f9k=
X-Google-Smtp-Source: AKy350avyyecS0c/imlGffEziV8LfOkCRk5DQs3Wa4CPnF8ZzhjtSUk0FweHZrTwoSGARpW3UJ44LA==
X-Received: by 2002:a17:902:e80d:b0:1a5:167e:f482 with SMTP id u13-20020a170902e80d00b001a5167ef482mr1834984plg.20.1681373925829;
        Thu, 13 Apr 2023 01:18:45 -0700 (PDT)
Received: from localhost.localdomain ([23.238.128.118])
        by smtp.googlemail.com with ESMTPSA id w14-20020a1709029a8e00b001a68d613ad9sm410595plp.132.2023.04.13.01.18.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 01:18:44 -0700 (PDT)
From:   Liang Chen <liangchen.linux@gmail.com>
To:     kuba@kernel.org, ilias.apalodimas@linaro.org, edumazet@google.com,
        hawk@kernel.org
Cc:     davem@davemloft.net, pabeni@redhat.com, alexander.duyck@gmail.com,
        linyunsheng@huawei.com, netdev@vger.kernel.org,
        liangchen.linux@gmail.com
Subject: [PATCH v4] skbuff: Fix a race between coalescing and releasing SKBs
Date:   Thu, 13 Apr 2023 16:18:12 +0800
Message-Id: <20230413081812.11768-1-liangchen.linux@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 1effe8ca4e34 ("skbuff: fix coalescing for page_pool fragment
recycling") allowed coalescing to proceed with non page pool page and page
pool page when @from is cloned, i.e.

to->pp_recycle    --> false
from->pp_recycle  --> true
skb_cloned(from)  --> true

However, it actually requires skb_cloned(@from) to hold true until
coalescing finishes in this situation. If the other cloned SKB is
released while the merging is in process, from_shinfo->nr_frags will be
set to 0 toward the end of the function, causing the increment of frag
page _refcount to be unexpectedly skipped resulting in inconsistent
reference counts. Later when SKB(@to) is released, it frees the page
directly even though the page pool page is still in use, leading to
use-after-free or double-free errors. So it should be prohibited.

The double-free error message below prompted us to investigate:
BUG: Bad page state in process swapper/1  pfn:0e0d1
page:00000000c6548b28 refcount:-1 mapcount:0 mapping:0000000000000000
index:0x2 pfn:0xe0d1
flags: 0xfffffc0000000(node=0|zone=1|lastcpupid=0x1fffff)
raw: 000fffffc0000000 0000000000000000 ffffffff00000101 0000000000000000
raw: 0000000000000002 0000000000000000 ffffffffffffffff 0000000000000000
page dumped because: nonzero _refcount

CPU: 1 PID: 0 Comm: swapper/1 Tainted: G            E      6.2.0+
Call Trace:
 <IRQ>
dump_stack_lvl+0x32/0x50
bad_page+0x69/0xf0
free_pcp_prepare+0x260/0x2f0
free_unref_page+0x20/0x1c0
skb_release_data+0x10b/0x1a0
napi_consume_skb+0x56/0x150
net_rx_action+0xf0/0x350
? __napi_schedule+0x79/0x90
__do_softirq+0xc8/0x2b1
__irq_exit_rcu+0xb9/0xf0
common_interrupt+0x82/0xa0
</IRQ>
<TASK>
asm_common_interrupt+0x22/0x40
RIP: 0010:default_idle+0xb/0x20

Fixes: 53e0961da1c7 ("page_pool: add frag page recycling support in page pool")

Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
Changes from v3:
- make the comment more precise and add fixes and reviewed-by tags
---
 net/core/skbuff.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 050a875d09c5..91bac9a6d693 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5597,18 +5597,18 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
 	if (skb_cloned(to))
 		return false;
 
-	/* In general, avoid mixing slab allocated and page_pool allocated
-	 * pages within the same SKB. However when @to is not pp_recycle and
-	 * @from is cloned, we can transition frag pages from page_pool to
-	 * reference counted.
-	 *
-	 * On the other hand, don't allow coalescing two pp_recycle SKBs if
-	 * @from is cloned, in case the SKB is using page_pool fragment
+	/* In general, avoid mixing page_pool and non-page_pool allocated
+	 * pages within the same SKB. Additionally avoid dealing with clones
+	 * containing page_pool pages, in case the SKB is using page_pool fragment
 	 * references (PP_FLAG_PAGE_FRAG). Since we only take full page
 	 * references for cloned SKBs at the moment that would result in
 	 * inconsistent reference counts.
+	 * In theory we could take full references if from is cloned and
+	 * !@to->pp_recycle but its tricky (due to potential race with the clone
+	 * disappearing) and rare, so not worth dealing with.
 	 */
-	if (to->pp_recycle != (from->pp_recycle && !skb_cloned(from)))
+	if (to->pp_recycle != from->pp_recycle ||
+	    (from->pp_recycle && skb_cloned(from)))
 		return false;
 
 	if (len <= skb_tailroom(to)) {
-- 
2.18.2

