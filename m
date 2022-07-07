Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA7F356ABB7
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 21:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236767AbiGGTSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 15:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236766AbiGGTSu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 15:18:50 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B291F63CA
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 12:18:48 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id m68-20020a253f47000000b006683bd91962so14109787yba.0
        for <netdev@vger.kernel.org>; Thu, 07 Jul 2022 12:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=OUEpf12GvEG1UX3ooAg7eqO9HwGv1M8Ax2i+UarG1LM=;
        b=lXpb7v7bya8eRc/6MdU8JU/+aF0vRDhyWUvuqcSJ+2cLPk3Fk+uKpjKn5fNNJDZHAv
         7Cwi5wbnnbh+wveyLqR94J/8yGlbI33b3PGpaO1SCHghECYiJhJIb9qjcmPoHHne8rcY
         dYugEOHp+3DA2Lym8/cYe9m8RiYC/gppVTMsRI5Oa/2/8Ra1xytWQyEF8MegUW3koV8z
         7ZAjNsIJ0mW5I8nR/2c3cmmHsPpyQ8r/Yjx631px205EBIuRylsB/g44Kvy74uQr3rRE
         FNvkQg38OwMv5RdKPnHxLfmJdV6D46tY7ShQdiO//huAYX5xdUTYXs1kNSXvIT9PvuPr
         5bIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=OUEpf12GvEG1UX3ooAg7eqO9HwGv1M8Ax2i+UarG1LM=;
        b=Uzapq//W/WAIEq/QvmaUeJQyu41Ltuo5svdATTSNXS7ne9CeytKRVOPtnw9l9nd14K
         3EZGEb+8tpQPCtw4juW7vTioM9SP2fK4gLV3kkgGEltHOv8dh2uFIcg+k8Rh4onuCil5
         udKOA1F/M7Nav7yEgshcfL+nHsrHgiO9qgPQhCEbDSqWubSjAOra3f/E4AUEORrqjSPl
         2a9gHecZ18Jqb8WRPU+hDgCh7okMFSC/PiCOx3on7JwF+i+7a6bv57kwUwGa29AD5TYG
         i9prnrsuwy3RXZd7el0kZ7N5TjdByMb6KW0tjniRnoWbpSiBchPlYVIr3cxgBWV4uM8J
         eicQ==
X-Gm-Message-State: AJIora/q4hJuV82wqnr5ZUyCOQws8YNZbF/1Q5RxYbY5AwNgyJB/wq4g
        y5P5a/hYDqAwB99nM5uBm85VLgrkmo6d6Q==
X-Google-Smtp-Source: AGRyM1thJZNMq3d6lPhgJL/8ac6qmiuDvqasjkp+LCsLZAL0whDCQam7N1jpqqrHv+dtsBhKtdOcg8Sa8zRspA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:880b:0:b0:66e:3d9e:7dfd with SMTP id
 c11-20020a25880b000000b0066e3d9e7dfdmr25945624ybl.600.1657221528002; Thu, 07
 Jul 2022 12:18:48 -0700 (PDT)
Date:   Thu,  7 Jul 2022 19:18:46 +0000
Message-Id: <20220707191846.1020689-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH net-next] net: minor optimization in __alloc_skb()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TCP allocates 'fast clones' skbs for packets in tx queues.

Currently, __alloc_skb() initializes the companion fclone
field to SKB_FCLONE_CLONE, and leaves other fields untouched.

It makes sense to defer this init much later in skb_clone(),
because all fclone fields are copied and hot in cpu caches
at that time.

This removes one cache line miss in __alloc_skb(), cost seen
on an host with 256 cpus all competing on memory accesses.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/skbuff.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index c62e42d0c5310caaa03298a779974050b8e58658..c4a7517815815d136dab5576d6b8fa52057002b1 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -454,8 +454,6 @@ struct sk_buff *__alloc_skb(unsigned int size, gfp_t gfp_mask,
 
 		skb->fclone = SKB_FCLONE_ORIG;
 		refcount_set(&fclones->fclone_ref, 1);
-
-		fclones->skb2.fclone = SKB_FCLONE_CLONE;
 	}
 
 	return skb;
@@ -1513,6 +1511,7 @@ struct sk_buff *skb_clone(struct sk_buff *skb, gfp_t gfp_mask)
 	    refcount_read(&fclones->fclone_ref) == 1) {
 		n = &fclones->skb2;
 		refcount_set(&fclones->fclone_ref, 2);
+		n->fclone = SKB_FCLONE_CLONE;
 	} else {
 		if (skb_pfmemalloc(skb))
 			gfp_mask |= __GFP_MEMALLOC;
-- 
2.37.0.rc0.161.g10f37bed90-goog

