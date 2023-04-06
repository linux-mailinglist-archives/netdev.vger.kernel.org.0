Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32B136D965F
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 13:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237308AbjDFLxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 07:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237174AbjDFLwv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 07:52:51 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF0E5CA05
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 04:49:25 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id q20so14446026pfs.2
        for <netdev@vger.kernel.org>; Thu, 06 Apr 2023 04:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680781729;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UqUdWcIc9KSCHCHXJ8GC3elQeDVWFp/Z+QbNbi6Nyag=;
        b=aR/R13ai1AiVhyWTBhytZjSZDeRATzoRuYARLGrrUvl6hsRK9KD8w6g+C9dCsDKq3v
         IAMVb5i+l3/38biq7+Ev68o+Sb+8EcQz7R2hdhkUNnOVHFb8cbDN4v0GWcKaNW2lzVsB
         MODbm33ZPeVwyt5ptnVHYEAYX+mCdPx0IdrI2qAmbFMNbJLAut3Ymz3Sf5vSxU0SrtQV
         rEGZITMSifUtDY1VmVndKnp5CTPleUC/TV2n1MSaYgfkKOhVanG3YG/MrSfIUznh28r0
         DylfonkRyB/nY2+bw7FK9SlwqWuYY4XN1rteJMShXc6Jj4qFBWqBy4PQA168J1Ji/T/I
         ateQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680781729;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UqUdWcIc9KSCHCHXJ8GC3elQeDVWFp/Z+QbNbi6Nyag=;
        b=eYalceCHqkr8mXI3rVo6r/laH6gw4WAqtxw3LmIivb11KJhu/FlDluotTo1c7SGJr8
         yq5xCNPYTZ9gTxE9rWLkk5BEjrdrFyz2GJX2c1z7aFujnhcJGRyo8dajwl6QBg2gGvIP
         HUy1zefc125VBuyI3Yt3eLbxHHhwdJ4w2jdfisZVYr3DETb97bb2LtA615IDt4C1mRei
         Ouwv9MYsBgFknN3VvZERgjazl8Y3J+Za5sKwHEQTdAAfSSbsGabgOj21hnKkjan6K5we
         RosC5Tyn5GkPxSCnmYSrLXFOMvxPHDbKkXWgLMbV7SjqWXEnLmFn13CvO5uwyy1zZWKW
         zOUg==
X-Gm-Message-State: AAQBX9ff2OXOWCPGOtpWeOrnfjcFczQP6DlNDVs/wEP97PkcgAm02mWC
        kM9LzlciI3PmUUdB0qlh9dM=
X-Google-Smtp-Source: AKy350ZedNhOaa4J+OnYSq9MhGcSFGMoguZhS7Y1cmBfEgfB+DQSLp5asqYMU/PTciZOCEsrcRAoyw==
X-Received: by 2002:a62:84d6:0:b0:62e:11:6bd with SMTP id k205-20020a6284d6000000b0062e001106bdmr9568511pfd.25.1680781728797;
        Thu, 06 Apr 2023 04:48:48 -0700 (PDT)
Received: from localhost.localdomain ([155.94.207.39])
        by smtp.gmail.com with ESMTPSA id bm1-20020a056a00320100b0062dd993fdfcsm1214712pfb.105.2023.04.06.04.48.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 04:48:47 -0700 (PDT)
From:   Liang Chen <liangchen.linux@gmail.com>
To:     kuba@kernel.org, alexander.duyck@gmail.com,
        ilias.apalodimas@linaro.org, hawk@kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, liangchen.linux@gmail.com
Subject: [PATCH v2] skbuff: Fix a race between coalescing and releasing SKBs
Date:   Thu,  6 Apr 2023 19:48:25 +0800
Message-Id: <20230406114825.18597-1-liangchen.linux@gmail.com>
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
recycling") allowed coalescing to proceed with non page pool page and
page pool page when @from is cloned, i.e.

to->pp_recycle    --> false
from->pp_recycle  --> true
skb_cloned(from)  --> true

However, it actually requires skb_cloned(@from) to hold true until
coalescing finishes in this situation. If the other cloned SKB is
released while the merging is in process, from_shinfo->nr_frags will be
set to 0 towards the end of the function, causing the increment of frag
page _refcount to be unexpectedly skipped resulting in inconsistent
reference counts. Later when SKB(@to) is released, it frees the page
directly even though the page pool page is still in use, leading to
use-after-free or double-free errors.

So it needs to be specially handled at where the ref count may get lost.

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
Changes from v1:
- deal with the ref count problem instead of return back to give more opportunities to coalesce skbs.
---
 net/core/skbuff.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 050a875d09c5..77da8ce74a1e 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5643,7 +5643,19 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
 
 		skb_fill_page_desc(to, to_shinfo->nr_frags,
 				   page, offset, skb_headlen(from));
-		*fragstolen = true;
+
+		/* When @from is pp_recycle and @to isn't, coalescing is
+		 * allowed to proceed if @from is cloned. However if the
+		 * execution reaches this point, @from is already transitioned
+		 * into non-cloned because the other cloned skb is released
+		 * somewhere else concurrently. In this case, we need to make
+		 * sure the ref count is incremented, not directly stealing
+		 * from page pool.
+		 */
+		if (to->pp_recycle != from->pp_recycle)
+			get_page(page);
+		else
+			*fragstolen = true;
 	} else {
 		if (to_shinfo->nr_frags +
 		    from_shinfo->nr_frags > MAX_SKB_FRAGS)
@@ -5659,7 +5671,13 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
 	       from_shinfo->nr_frags * sizeof(skb_frag_t));
 	to_shinfo->nr_frags += from_shinfo->nr_frags;
 
-	if (!skb_cloned(from))
+	/* Same situation as above where head data presents. When @from is
+	 * pp_recycle and @to isn't, coalescing is allowed to proceed if @from
+	 * is cloned. However @from can be transitioned into non-cloned
+	 * concurrently by this point. If it does happen, we need to make sure
+	 * the ref count is properly incremented.
+	 */
+	if (to->pp_recycle == from->pp_recycle && !skb_cloned(from))
 		from_shinfo->nr_frags = 0;
 
 	/* if the skb is not cloned this does nothing
-- 
2.18.2

