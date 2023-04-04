Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB686D59F3
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 09:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233481AbjDDHsC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 03:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231767AbjDDHsB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 03:48:01 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC49E10FF
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 00:47:55 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id e15-20020a17090ac20f00b0023d1b009f52so35245341pjt.2
        for <netdev@vger.kernel.org>; Tue, 04 Apr 2023 00:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680594475;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lZTFVCdSR9bXY+cqoePnVwnQOir0lilLDbKROgGGxm8=;
        b=WkwJi8QbBxLUYLMYnlvfs9GWd5pIUFGeoSPfi1kVP9v1UsYeLgJKZpjmMc3eigZRXT
         PhwKH3gS5yDZ9mh+PS9lu95mISuVnEmO1vwWfzPKRlwAlWwig6GRfF2GV2T/UeHuFg43
         Y2fp4EmYEq2aAjoDCtIHBudSO57z1Pch0a1TU4Oq2qZmxiSd8nUVWnZnlHSasaDyCBJa
         jpS4KZYNhQMdg59tYT+h20nE+eMS2PgTcJIt2o6l/i2OEo65CdBlUd1ofSO7Jv6ipcdV
         ZLlWHyJn3J0CdQ++wQlGp5xtaYvSPSP5q36Y0WqMgivq8lgiROijCeNPDj7LJ3qbDRyH
         j6Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680594475;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lZTFVCdSR9bXY+cqoePnVwnQOir0lilLDbKROgGGxm8=;
        b=tuVrTweFGEp4uPkt1Jmvp8Flv8mw6xXLvt+foTsGWVXj9EbOEhdg8XFOOqWKZlQLnq
         b6Cm9PmviE6rvJsztiXpz5mzDGMWjpMBwA3Kdxwbt/2mr1xOpnhIlbbaflwsMKmXQg5N
         3eGOpT4u7G/hrQbnYBE8v67Qu2pPg/ReM4hg66e0njCduDmSvRtA29LE7wIwR+MLWOAO
         U6hISfNsa/i+k2Q4sfAMXCZoI5pnt90h3SjeVjQZfaAfIaanvOWgt1q5YLTPbzZSduku
         rkoB/N1OfUPGaN0EnVV2TLm6xr3wSL8cSgi8PrKY4jpzUMzWB+ueG98q0iQviawYpaiQ
         tnmQ==
X-Gm-Message-State: AAQBX9dOGTMrgun6ImWMUU2xyQdRbqkKAdA+xgzArVBs7u6LbvJ2W+p4
        3A2SviT0lsKx6alK//cC22vDYchrUlW4+w==
X-Google-Smtp-Source: AKy350bnInbRHU7YlY8jUa1kZlFALzr/gZ+ll+/9hrvgnUf927KSXARNsgSgnsQd7CM6CzqKguhSBA==
X-Received: by 2002:a17:90b:4b07:b0:23e:cea5:d37e with SMTP id lx7-20020a17090b4b0700b0023ecea5d37emr1663605pjb.46.1680594475289;
        Tue, 04 Apr 2023 00:47:55 -0700 (PDT)
Received: from localhost.localdomain ([204.44.110.111])
        by smtp.gmail.com with ESMTPSA id d6-20020a170902c18600b001a04d37a4acsm7828224pld.9.2023.04.04.00.47.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 00:47:54 -0700 (PDT)
From:   Liang Chen <liangchen.linux@gmail.com>
To:     ilias.apalodimas@linaro.org, hawk@kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        liangchen.linux@gmail.com
Subject: [PATCH] skbuff: Fix a race between coalescing and releasing SKBs
Date:   Tue,  4 Apr 2023 15:47:33 +0800
Message-Id: <20230404074733.22869-1-liangchen.linux@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 1effe8ca4e34 allowed coalescing to proceed with non page pool page
and page pool page when @from is cloned, i.e.

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
use-after-free or double-free errors. So it should be prohibitted.

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

Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
---
 net/core/skbuff.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 050a875d09c5..9be23ece5f03 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5598,17 +5598,14 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
 		return false;
 
 	/* In general, avoid mixing slab allocated and page_pool allocated
-	 * pages within the same SKB. However when @to is not pp_recycle and
-	 * @from is cloned, we can transition frag pages from page_pool to
-	 * reference counted.
-	 *
-	 * On the other hand, don't allow coalescing two pp_recycle SKBs if
-	 * @from is cloned, in case the SKB is using page_pool fragment
-	 * references (PP_FLAG_PAGE_FRAG). Since we only take full page
-	 * references for cloned SKBs at the moment that would result in
-	 * inconsistent reference counts.
+	 * pages within the same SKB. However don't allow coalescing two
+	 * pp_recycle SKBs if @from is cloned, in case the SKB is using
+	 * page_pool fragment references (PP_FLAG_PAGE_FRAG). Since we only
+	 * take full page references for cloned SKBs at the moment that would
+	 * result in inconsistent reference counts.
 	 */
-	if (to->pp_recycle != (from->pp_recycle && !skb_cloned(from)))
+	if ((to->pp_recycle != from->pp_recycle)
+		|| (from->pp_recycle && skb_cloned(from)))
 		return false;
 
 	if (len <= skb_tailroom(to)) {
-- 
2.18.2

