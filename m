Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 248516E09AA
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 11:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbjDMJFL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 05:05:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230347AbjDMJEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 05:04:43 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95CE693D6
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 02:04:23 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id 98e67ed59e1d1-246fa478d45so328557a91.3
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 02:04:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681376663; x=1683968663;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7uiHOGv9t61CatrbFHgK+e8+ya0qvDc3tC0b4XYay80=;
        b=QHt88NZOQ+WkEgvbveLkliZgqpzLj3EcsAEFuy2CouTbXGiup1AtjJqh8VBfzqe2z7
         lAtYnpQw1H+RNPju2nAeIEL876Of++CVt2tLU7Y31c+xWH8GMksCwrX83ejf+/lhySJ7
         XR/nuiGuMziq95nBHBwaMQ1Pa7+Jt4fqTGgdWLuq5rSwERXwOBgAM2JEvcQpv0SzNSJC
         JVvgZnVP4KrX4hDCek+SCvwFG5x4ffRWD/czpP5C0jEzVHgxn93gEQ0jPf7YVeUiBvqU
         0k1R68VQSiC2O0gYUsHj2dXMl2oYP7ht2I5heiTlK+XAvmdLuN93o1P3gS0EB13Z1oBU
         KCZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681376663; x=1683968663;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7uiHOGv9t61CatrbFHgK+e8+ya0qvDc3tC0b4XYay80=;
        b=TjWS5zQS0p5IqiAGDg/Av7LFQ2VnldbT4ptpFHBN9keK+0sCC6TgRqH0kGu1m3pC1o
         aV6J3W0+x73xzDguue6wpLSM6nV5fdSYBU816P3oLsAvZJ5ShY5gLXPg1K3rMbtQ/tHB
         V2/tkLLhxkXD9bSe0mci7PorD5qyH+JkPFGdDH21tCGEloQGuuEClixvpIDkLn3PzeIf
         erElYYnETGU9hxs/5pkY8rG/sypLeFX/5NxWSpjHIt60BvpAC0VQESZSoeQv+Ehfcn30
         JuO2jDBqQWsr621mwrg5V76FvxUtxoQ7XgiHgXXuVK3SxorBs31HQlGH3cnN7NsvZlky
         Y3mw==
X-Gm-Message-State: AAQBX9c4EiDHZ1sue65hWg2dMoHKW0f1cXpyIUCziHwJxS+K3hprdyq+
        nwWg3LlD6AaDKZTZCLt1nGg=
X-Google-Smtp-Source: AKy350YBxSpotiZg4lYVvbzfZihuG2pYEeOkER5YHpSbDNqrQZHgA77wyc2gveYxx4bkmj59QMz64Q==
X-Received: by 2002:a05:6a00:10d5:b0:63a:33d5:9224 with SMTP id d21-20020a056a0010d500b0063a33d59224mr2445711pfu.18.1681376662869;
        Thu, 13 Apr 2023 02:04:22 -0700 (PDT)
Received: from localhost.localdomain ([23.238.128.118])
        by smtp.googlemail.com with ESMTPSA id n4-20020a63ee44000000b005136b93f8e9sm927572pgk.14.2023.04.13.02.04.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 02:04:21 -0700 (PDT)
From:   Liang Chen <liangchen.linux@gmail.com>
To:     kuba@kernel.org, ilias.apalodimas@linaro.org, edumazet@google.com,
        hawk@kernel.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        alexander.duyck@gmail.com, linyunsheng@huawei.com,
        liangchen.linux@gmail.com
Subject: [PATCH v5] skbuff: Fix a race between coalescing and releasing SKBs
Date:   Thu, 13 Apr 2023 17:03:53 +0800
Message-Id: <20230413090353.14448-1-liangchen.linux@gmail.com>
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
Changes from v4:
- fixes some style issues
---
 net/core/skbuff.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 050a875d09c5..7b83410bbaae 100644
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
-	 * references (PP_FLAG_PAGE_FRAG). Since we only take full page
-	 * references for cloned SKBs at the moment that would result in
+	/* In general, avoid mixing page_pool and non-page_pool allocated
+	 * pages within the same SKB. Additionally avoid dealing with clones
+	 * containing page_pool pages, in case the SKB is using page_pool
+	 * fragment references (PP_FLAG_PAGE_FRAG). Since we only take full
+	 * page references for cloned SKBs at the moment that would result in
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

