Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A73FA4AAA89
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 18:27:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380697AbiBER1R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 12:27:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242204AbiBER1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Feb 2022 12:27:16 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DCB6C061348
        for <netdev@vger.kernel.org>; Sat,  5 Feb 2022 09:27:15 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id u130so7933918pfc.2
        for <netdev@vger.kernel.org>; Sat, 05 Feb 2022 09:27:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KlLfYxFaL2DMllwh2ZMZKJDTu0Hxy3jMMIr74/EJNwo=;
        b=RsPLThoGbvnVpnTGztS7pInkL+PdVvLWOTlUaUGd9xOtm6pRYWRHgs0cU2kQuw+d4s
         MV481yf9pSss1ADZJwzDGPgxhc9o6/d4kDBHlL+3aNL/VJq0bgHjCrVUG95E97rIS4cC
         LXIUfjui4CrcbF8pwV/ez1SxTBiMOTm0D7BfmMa1vWw4H9tYNYcRINaqWs5UUPRDavo+
         +T9CB17eokArVlI0mVEZVQZbzDLk1PCGJ0fvHgljPqVvikW7qPlZKs+koR/skT2yilx3
         ariiq6z8EqRuqAWc5nKNbzUvOSa/Ic/NgunmCpEg6q9MDtS62CjE0qeyyoVYcHeW9g2e
         /OdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KlLfYxFaL2DMllwh2ZMZKJDTu0Hxy3jMMIr74/EJNwo=;
        b=WReqWImDPwM9muJtYOThTfAK1S/Z5MHHct8KoPVXALhLQ3Rjx7KYyFc3Z9VpzDBmPE
         GePJBQfOKIiDjspUT4SxIYAKAudsRMsgf8pH+2uwanyXEvs+TsWGYP1sNZOJVHt6eWqb
         UpWBk5gX6Agz1N8agHl3jdYuKHdvwMbh+AMd/rSyc3GDsIkBCAlbcDHqjAohzmGZO5Fb
         rUQ2nXSkCKKbeC/vBfWqpZyn09vebhhLcqMb4GFJjTBE+8ek5uBdbR5kaE2BqWjcN0kA
         SHyyuRczG9DA8m/YzLMVsuhvsxOJv422+vaiTo5tqqXSJKWtb6Xw373VB8AvUOuMwgA0
         bA+Q==
X-Gm-Message-State: AOAM5319bCQ8900NC5/YhtSEHodWNv65zE80Nb4RqbTO1LUGSC3zeRCm
        DLopwXGKZPvSSoWhffUpZ9Ivdu710rM=
X-Google-Smtp-Source: ABdhPJxW89uhH4rwLwc9pAmyay4lzzhrG34Gxm/3ismFn5kJrgkIF2igVMcLjIp5BtWbOOa+DSke1Q==
X-Received: by 2002:a63:4f4f:: with SMTP id p15mr3599783pgl.452.1644082035155;
        Sat, 05 Feb 2022 09:27:15 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:8eb:b7ed:dbe7:a81f])
        by smtp.gmail.com with ESMTPSA id z13sm6769589pfe.20.2022.02.05.09.27.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Feb 2022 09:27:14 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Marco Elver <elver@google.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: [PATCH net-next] ref_tracker: remove filter_irq_stacks() call
Date:   Sat,  5 Feb 2022 09:27:11 -0800
Message-Id: <20220205172711.3775171-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
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

After commit e94006608949 ("lib/stackdepot: always do filter_irq_stacks()
in stack_depot_save()") it became unnecessary to filter the stack
before calling stack_depot_save().

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
---
 lib/ref_tracker.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/lib/ref_tracker.c b/lib/ref_tracker.c
index 9c0c2e09df666d19aba441f568762afbd1cad4d0..dc7b14aa3431e2bf7a97a7e78220f04da144563d 100644
--- a/lib/ref_tracker.c
+++ b/lib/ref_tracker.c
@@ -89,7 +89,6 @@ int ref_tracker_alloc(struct ref_tracker_dir *dir,
 		return -ENOMEM;
 	}
 	nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 1);
-	nr_entries = filter_irq_stacks(entries, nr_entries);
 	tracker->alloc_stack_handle = stack_depot_save(entries, nr_entries, gfp);
 
 	spin_lock_irqsave(&dir->lock, flags);
@@ -120,7 +119,6 @@ int ref_tracker_free(struct ref_tracker_dir *dir,
 		return -EEXIST;
 	}
 	nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 1);
-	nr_entries = filter_irq_stacks(entries, nr_entries);
 	stack_handle = stack_depot_save(entries, nr_entries, GFP_ATOMIC);
 
 	spin_lock_irqsave(&dir->lock, flags);
-- 
2.35.0.263.gb82422642f-goog

