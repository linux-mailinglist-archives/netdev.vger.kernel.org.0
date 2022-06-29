Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97DCD5604E3
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 17:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234031AbiF2Ps7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 11:48:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229885AbiF2Ps6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 11:48:58 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8599E26560;
        Wed, 29 Jun 2022 08:48:57 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id l2so14897489pjf.1;
        Wed, 29 Jun 2022 08:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D73YEhNsNUdQBC8mfGvv+Hmre0Iw7EBd3yOy99mT1KI=;
        b=SZtOghqZoPkR0k5j6eMsY0boIxrZLZQ+wf+nhJHDVAanRv3mQD0Yc8nbWGDFK0cyu3
         LApJOCgHefZWl174x6M0D4X0XVzd4rZ5DtRWJTA1p93tE3IK0DQlw+C9N0QXUi/NJlBs
         OlNcKB5oWrQ3FKddFXdvNBiR0kdauuQW6KoPYNKkwl5t66RGubZr1OfwngtMb4sLE4nd
         6kaK3mb5vybH9ebV5yeKeZSvBac37rwyg9Y7TtpUg6im78j6TsDLUUFVWcuGNjWf0oNK
         vuGlfzoscWBH1B/4bSq1UsvRlt5lWyhaQwRfHZYIzBMvIGxFmhd23XVjvfDicbvU+0Lq
         KHVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D73YEhNsNUdQBC8mfGvv+Hmre0Iw7EBd3yOy99mT1KI=;
        b=4oVOThhFlT5e1Tu5cOUVVVecdlyrh0GRgufbAte3myOYEcb87/lbK4fDB7V4hj5yaT
         F1Wt02eL0VkmsXyX9Ngrmch3toutu7cAo0ekPvcIj6YTeSDxy/9V8aQ9xwujxoFPP1z5
         b0AHlFt5GpyRfVSDleUPfN+9O0aK/6hNJpCKSKIG06mBFekL3F0fJ79B2eAvqG8T4Z7i
         JHkeiPh0AD8aKKSyOowLOOsywLxvBkj89zLiB75RrHLliw1CLfYTWJWIw3zGNCOv0I9v
         sIvrpppK+xrpX8If+L0Z9q3RO+pyc+LfoeLrZIuhtHTyWSREAaBqaCXI0n2UKYtPqiFl
         45hg==
X-Gm-Message-State: AJIora9d3+T5l/IoHJCueU9bTyr13TQ/0dX+Q3Ns5je9ZIxO7HDIyJGG
        uD1Bs+R2xxMjClPhG7akNiE=
X-Google-Smtp-Source: AGRyM1srd/upNDgXbkDCnNQedE+NFOFi5sB16OTqnqsxmLwl9/rvL4SE7YvjUU/7lJhJ2ewtKV3lpQ==
X-Received: by 2002:a17:90a:cb84:b0:1ea:ffd2:3075 with SMTP id a4-20020a17090acb8400b001eaffd23075mr4640427pju.106.1656517737050;
        Wed, 29 Jun 2022 08:48:57 -0700 (PDT)
Received: from vultr.guest ([45.32.72.20])
        by smtp.gmail.com with ESMTPSA id 1-20020a620501000000b00527d84dfa42sm2661329pff.167.2022.06.29.08.48.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 08:48:55 -0700 (PDT)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, quentin@isovalent.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yafang Shao <laoar.shao@gmail.com>,
        Roman Gushchin <roman.gushchin@linux.dev>
Subject: [PATCH bpf-next 1/4] bpf: Make non-preallocated allocation low priority
Date:   Wed, 29 Jun 2022 15:48:29 +0000
Message-Id: <20220629154832.56986-2-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220629154832.56986-1-laoar.shao@gmail.com>
References: <20220629154832.56986-1-laoar.shao@gmail.com>
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

GFP_ATOMIC doesn't cooperate well with memcg pressure so far, especially
if we allocate too much GFP_ATOMIC memory. For example, when we set the
memcg limit to limit a non-preallocated bpf memory, the GFP_ATOMIC can
easily break the memcg limit by force charge. So it is very dangerous to
use GFP_ATOMIC in non-preallocated case. One way to make it safe is to
remove __GFP_HIGH from GFP_ATOMIC, IOW, use (__GFP_ATOMIC |
__GFP_KSWAPD_RECLAIM) instead, then it will be limited if we allocate
too much memory.

We introduced BPF_F_NO_PREALLOC is because full map pre-allocation is
too memory expensive for some cases. That means removing __GFP_HIGH
doesn't break the rule of BPF_F_NO_PREALLOC, but has the same goal with
it-avoiding issues caused by too much memory. So let's remove it.

__GFP_KSWAPD_RECLAIM doesn't cooperate well with memcg pressure neither
currently. But the memcg code can be improved to make
__GFP_KSWAPD_RECLAIM work well under memcg pressure.

It also fixes a typo in the comment.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
---
 kernel/bpf/hashtab.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 17fb69c0e0dc..9d4559a1c032 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -61,7 +61,7 @@
  *
  * As regular device interrupt handlers and soft interrupts are forced into
  * thread context, the existing code which does
- *   spin_lock*(); alloc(GPF_ATOMIC); spin_unlock*();
+ *   spin_lock*(); alloc(GFP_ATOMIC); spin_unlock*();
  * just works.
  *
  * In theory the BPF locks could be converted to regular spinlocks as well,
@@ -978,7 +978,8 @@ static struct htab_elem *alloc_htab_elem(struct bpf_htab *htab, void *key,
 				goto dec_count;
 			}
 		l_new = bpf_map_kmalloc_node(&htab->map, htab->elem_size,
-					     GFP_ATOMIC | __GFP_NOWARN,
+					     __GFP_ATOMIC | __GFP_NOWARN |
+					     __GFP_KSWAPD_RECLAIM,
 					     htab->map.numa_node);
 		if (!l_new) {
 			l_new = ERR_PTR(-ENOMEM);
@@ -996,7 +997,8 @@ static struct htab_elem *alloc_htab_elem(struct bpf_htab *htab, void *key,
 		} else {
 			/* alloc_percpu zero-fills */
 			pptr = bpf_map_alloc_percpu(&htab->map, size, 8,
-						    GFP_ATOMIC | __GFP_NOWARN);
+						    __GFP_ATOMIC | __GFP_NOWARN |
+						    __GFP_KSWAPD_RECLAIM);
 			if (!pptr) {
 				kfree(l_new);
 				l_new = ERR_PTR(-ENOMEM);
-- 
2.17.1

