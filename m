Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D365E4C85A9
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 08:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233046AbiCAH7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 02:59:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbiCAH7d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 02:59:33 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8044C50B28;
        Mon, 28 Feb 2022 23:58:51 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id s11so3118494pfu.13;
        Mon, 28 Feb 2022 23:58:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=P4+if8GN83/wfWPDcl6lkO0MQCgRlrUm6Ra8zxANWzo=;
        b=jVLcKFPzakyWM+RQb/0ul+4n8tO42mKE1SlgxDi7pH+hDRBIdGh0hyyW2huYd6ECd6
         EJ0LgH897rdvv5s82GclAiSy0qqr6k6aLxDuXhEp3G4VOfMonvEy+T4NObheJizEW8EN
         OZAsMYaVuw+tV3YNY1nleT2qJyAJFKuxlGSOGvK0YJHmZNCvc0lyqci5mj9G2GVqhFqL
         CJ/w9fn5SPl/wlUAjrSbKW81iGp9g5fa8pD97Mj94zRzQ68rpgVBUNzqnL//z0l3kVGE
         WmTWkWAE+t0oY0YuG+24qtW7tre/KBPtPxwokcrVM2RvwBQCBQHMUao2O1w46D/CnkaJ
         rM/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=P4+if8GN83/wfWPDcl6lkO0MQCgRlrUm6Ra8zxANWzo=;
        b=z57VAZEafxz5ruvmy/XhAIWLskWKVJ//SWJFEpssa3bDON7dM5I4Bx/xfw+106AYim
         V8bSt5y0yA63w+b/kiXVZwtl33r3hSXn/UfxaeLbnUt8X1YVzr6uTLBfvpRyE0UffhuN
         Jr6TPpIb86sJPupgFTLUUmSyGku1UmwjMj4olggWfnrwun2DgLx4OiEfeGvyc6yS5WV0
         U4lWQJZb3DIJtFjklialMChKDwZyuhi4MZaCwOGjJ9k1nTr24gdO25s547KT8XhPM4u+
         Z6r5utxzzQOAxS/kOaWhnfFxdgxUh+3xGvR8W0AjXZPT7SWkmXxFMNCjwQb/LQzo2BHa
         zbPA==
X-Gm-Message-State: AOAM5335/ySqipRnEsNAFsaHc18G+pwQMiUys6AzUIa8RYhU6iTbNwRG
        Z3a1/bJb2lh3AdPQY4zd/vk=
X-Google-Smtp-Source: ABdhPJwi5i8FBEj6kIQyujAuuTOa0vFqvdtJ0PdLM8pyS8A9utok6C8uWjitfJaMiC2UqTRVYFXtQA==
X-Received: by 2002:a63:1d65:0:b0:375:3d96:36b4 with SMTP id d37-20020a631d65000000b003753d9636b4mr21050857pgm.165.1646121531026;
        Mon, 28 Feb 2022 23:58:51 -0800 (PST)
Received: from ubuntu.huawei.com ([119.3.119.18])
        by smtp.googlemail.com with ESMTPSA id o12-20020a17090aac0c00b001b9e5286c90sm1662745pjq.0.2022.02.28.23.58.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 23:58:50 -0800 (PST)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     torvalds@linux-foundation.org
Cc:     arnd@arndb.de, jakobkoschel@gmail.com,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        keescook@chromium.org, jannh@google.com,
        linux-kbuild@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, Xiaomeng Tong <xiam0nd.tong@gmail.com>
Subject: [PATCH 0/6] list_for_each_entry*: make iterator invisiable outside the loop
Date:   Tue,  1 Mar 2022 15:58:33 +0800
Message-Id: <20220301075839.4156-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In this discuss[1], linus proposed a idea to solve the use-after-iter
problem caused by the inappropriate iterator variable use of
list_for_each_entry* macros *outside* the loop.

The core of the idea is that make the rule be "you never use the iterator
outside the loop".
The perfect way should be "you are prohibited by the compiler from using
iterator variable outside the loop". Thus, we can declare the iterator
variable inside the loop and any use of iterator outside the loop will
be report as a error by compiler.

"declare the iterator variable inside the *for* loop" needs something
above gnu89 (like -std=gnu11), which is the task of PATCH 1. 

The core patch of this series is PATCH 2, which respectively implements
a new iterator-inside macro for each list_for_each_entry* macro (10
variants). The name of the new macro is suffixed with *_inside*, such as
list_for_each_entry_inside for list_for_each_entry.

The reason for a new macro instead of directly modification on origin
macro is that, there are 15000+ callers of there macros scattered in
the whole kernel code. We cannot change all of these correctly in one
single patch considering that it must be correct for each commit. Thus,
we can define a new macro, and incrementally change these callers until
all these in the kernel are completely updated with *_inside* one. At
that time, we can just remove the implements of origin macros and rename
the *_inside* macro back to the origin name just in one single patch.

The PATCH 3~6 demonstrate how to change list_for_each_entry* callers into
*_inside one. Note all these 4 patch are just to prove the effectiveness
of the scheme for each list_for_each_entry* macro (10 variants). I think
the reasonable way is to kill all these 15000+ callers *on a file basis*,
considering that different macros may be called in the same context and
depend on each other, instead of *on a separate macro basis*.

[1]: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/

Xiaomeng Tong (6):
  Kbuild: compile kernel with gnu11 std
  list: add new MACROs to make iterator invisiable outside the loop
  kernel: remove iterator use outside the loop
  mm: remove iterator use outside the loop
  net/core: remove iterator use outside the loop
  drivers/dma: remove iterator use outside the loop

 Makefile                |   2 +-
 drivers/dma/iop-adma.c  |   9 +--
 include/linux/list.h    | 156 ++++++++++++++++++++++++++++++++++++++++
 kernel/power/snapshot.c |  28 ++++----
 kernel/signal.c         |   6 +-
 mm/list_lru.c           |  10 +--
 mm/slab_common.c        |   7 +-
 mm/vmalloc.c            |   6 +-
 net/core/gro.c          |   3 +-
 9 files changed, 191 insertions(+), 36 deletions(-)

-- 
2.17.1

