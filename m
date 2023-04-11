Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8957A6DCFB1
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 04:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbjDKC1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 22:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbjDKC1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 22:27:07 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EACFE2690
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 19:27:06 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id ik20so6321903plb.3
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 19:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681180026;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=W9zI/PthP91ZKovdIKM5UpujKTHaQJnBlKGOFgWnEmQ=;
        b=NQgB486PcjsVGmMnlz6gvXW4SJmof/MJw8mNloMSPBZPN9Q65O1dfEodf6zhKfdd1z
         mhD0ok2uFxd4Ty01w2gD+bQZFPfxutdPmoizhYNn7pXtoecf7MlAOWNx6Lh4rR4FccZ6
         0gwx61JKGQ6I8/fNKsr8R5u42BWLJOIF+NUcObb+dh9rBywPollCA3N+OoEuEuYNiMto
         zOXgowEM4yyNhCeMMObMaQmj5NPgdAUTlQ+4c+WGPZnw34+Jg3Kp2XnXZ/zF8J79xuG4
         1tJDAvCvbGR5h8y2STIcsbCwDiPHIf2Tmu6oESKIaCTTSYyxBeVV1KaTpXhjBqWLCciY
         pvCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681180026;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W9zI/PthP91ZKovdIKM5UpujKTHaQJnBlKGOFgWnEmQ=;
        b=6RUc8xDIHE5hvgLHORosmQ3CgzeSvWEkNErkH+ZSaa8jzUQ1BENJCqgHyu0DbHHPhl
         mkMLzFvNFX6UOjbt4vLboFfhKP37qlRlGvxk9XfK93yYusc6TYFGRI8tXz8eFqJCSStf
         d0cqUDXUR8jzi2hbiQQe5H1fkpcm60c3urGudIZ+2y5l+BeLFntxi/9R9metcMgr2QA1
         YcIotS6stNrswOqhpoWuHY6wdD+NALjSwQTTshgrtdIE1T7Fp8MvuIHTZxWZOMzVQ8xS
         5pHJxVR6aemg9Z2XKbsSiwwDniWZwpi4RKjFWHo+HzZ5IurDY+wYv08Bh+vQWh5jQthL
         Ov4Q==
X-Gm-Message-State: AAQBX9fywPIhdRFLHA06FCzzkhIgLTu5AicWJ5FUYAEj1sC46bujFsTQ
        PJloM4M6ccXrYimQga5bVzU=
X-Google-Smtp-Source: AKy350aKakRB+zEsVf2LFS3BtQMtqjwkHXrV2Vi8BNKJxlFanuX8aEYyiOelJoCOLtE66qk869rtgA==
X-Received: by 2002:a05:6a20:4d83:b0:d9:27f7:8c4a with SMTP id gj3-20020a056a204d8300b000d927f78c4amr11166861pzb.0.1681180026363;
        Mon, 10 Apr 2023 19:27:06 -0700 (PDT)
Received: from localhost.localdomain ([23.104.213.5])
        by smtp.gmail.com with ESMTPSA id m6-20020aa78a06000000b006251e1fdd1fsm2221479pfa.200.2023.04.10.19.26.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 19:27:05 -0700 (PDT)
From:   Liang Chen <liangchen.linux@gmail.com>
To:     kuba@kernel.org, ilias.apalodimas@linaro.org, edumazet@google.com,
        hawk@kernel.org
Cc:     davem@davemloft.net, pabeni@redhat.com, netdev@vger.kernel.org,
        alexander.duyck@gmail.com, linyunsheng@huawei.com,
        liangchen.linux@gmail.com
Subject: [PATCH v3] skbuff: Fix a race between coalescing and releasing SKBs
Date:   Tue, 11 Apr 2023 10:26:40 +0800
Message-Id: <20230411022640.8453-1-liangchen.linux@gmail.com>
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

Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
---
Changes from v2:
- switch back to the way v1 works and fix some style issues.
---
 net/core/skbuff.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 050a875d09c5..24a8223f8853 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5597,17 +5598,14 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
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
+	if (to->pp_recycle != from->pp_recycle ||
+	    (from->pp_recycle && skb_cloned(from)))
 		return false;
 
 	if (len <= skb_tailroom(to)) {
-- 
2.31.1

