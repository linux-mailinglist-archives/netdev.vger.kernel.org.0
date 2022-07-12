Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 535F25717BD
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 12:57:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232753AbiGLK53 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 06:57:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232734AbiGLK51 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 06:57:27 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07580AE57B
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 03:57:25 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id q5so6926703plr.11
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 03:57:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=/qC4SU2EkMPX462YLIKDQr6uCQszYdTIz0zuYzbF+6w=;
        b=fOYMv5TycOqnWdMZF6S2412c+9KKamqoHYqkp8GHasGd7S2CFycQmD2Oeq2GlPU9dW
         QtGKJeHhItaPO+D/Icv0kblm9Rl/2q+5qvMVTtvP3+2oN7/zQMpqYjsLemFsdPkg02jW
         qBFWruJFeQH9d0p+shk9KjyuqWgJGJJcBi1xaAbO2a+nzcqR5DmeXspJPwVkv/kmg5v3
         jguoRcsJf1b1HBX7J+OxgipdOKFScu03bNOXNent5Htv9f0YbK3HUsqzQtXtCbl1LYgo
         XW3rJ5Pu+YcYW4g16J0k7nHud5sI9lPBLrDXHxII5iOgn0fUbH4OES6evGl25wFGfcSO
         EKbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=/qC4SU2EkMPX462YLIKDQr6uCQszYdTIz0zuYzbF+6w=;
        b=PeXS6cme0xUYuN2JGSp5ASZ4LCzdLKdGP4vRQeCXV3Sy4bdrjS8ny0tdOY8TZnhEE2
         /OgFqfEnK7+ExhTS3aGogH19hRGGfphNBOKEasbJi0eDKX4/B64bKnT3tH1/YxxfbS6j
         TrIrgnfJp4nznmQuDEUUHJZcBbZ9/ZMLrW3Wk0LmesJlyecEgUJudYeeOMmXOOXJhUH/
         xmxQTC/usCIvYNU15vrtNelZ7rFrMOMUU8Ce7uDSbOUYOgpMnv5WB0od1rC6n0E1JGM7
         eCBnK6sp7jT17hfD0OGPVKockttWBGll2MlYzVtFqWK6B0wengFjTJA0RTYa9nXmdNOg
         b61A==
X-Gm-Message-State: AJIora/SQvPdZ/dfdM1qqlWdgkDT16ob/tYaMa/9/ZbtzUi/8EUAVD4o
        ZRXiPacADD5YES6aqpmRQsM=
X-Google-Smtp-Source: AGRyM1ugG6k/evnrBiP1Jma2OzA5cJ3brkyYvVLS9anydA6CD6zQ/FJMTDxq6o4rshbnuu6RY+yXVw==
X-Received: by 2002:a17:90b:4a08:b0:1ef:f36b:18e1 with SMTP id kk8-20020a17090b4a0800b001eff36b18e1mr3625245pjb.246.1657623444413;
        Tue, 12 Jul 2022 03:57:24 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id im22-20020a170902bb1600b0016c37fe48casm5681714plb.193.2022.07.12.03.57.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 03:57:23 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 0/8] amt: fix validation and synchronization bugs
Date:   Tue, 12 Jul 2022 10:57:06 +0000
Message-Id: <20220712105714.12282-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are some synchronization issues in the amt module.
Especially, an amt gateway doesn't well synchronize its own variables
and status(amt->status).
It tries to use a workqueue for handles in a single thread.
A global lock is also good, but it would occur complex locking complex.

In this patchset, only the gateway uses workqueue.
The reason why only gateway interface uses workqueue is that gateway
should manage its own states and variables a little bit statefully.
But relay doesn't need to manage tunnels statefully, stateless is okay.
So, relay side message handlers are okay to be called concurrently.
But it doesn't mean that no lock is needed.

Only amt multicast data message type will not be processed by the work
queue because It contains actual multicast data.
So, it should be processed immediately.

When any amt gateway events are triggered(sending discovery message by
delayed_work, sending request message by delayed_work and receiving
messages), it stores event and skb into the event queue(amt->events[16]).
Then, workqueue processes these events one by one.

The first patch is to use the work queue.

The second patch is to remove unnecessary lock due to a previous patch.

The third patch is to use READ_ONCE() in the amt module.
Even if the amt module uses a single thread, some variables (ready4,
ready6, amt->status) can be accessed concurrently.

The fourth patch is to add missing nonce generation logic when it sends a
new request message.

The fifth patch is to drop unexpected advertisement messages.
advertisement message should be received only after the gateway sends
a discovery message first.
So, the gateway should drop advertisement messages if it has never
sent a discovery message and it also should drop duplicate advertisement
messages.
Using nonce is good to distinguish whether a received message is an
expected message or not.

The sixth patch is to drop unexpected query messages.
This is the same behavior as the fourth patch.
Query messages should be received only after the gateway sends a request
message first.
The nonce variable is used to distinguish whether it is a reply to a
previous request message or not.
amt->ready4 and amt->ready6 are used to distinguish duplicate messages.

The seventh patch is to drop unexpected multicast data.
AMT gateway should not receive multicast data message type before
establish between gateway and relay.
In order to drop unexpected multicast data messages, it checks amt->status.

The last patch is to fix a locking problem on the relay side.
amt->nr_tunnels variable is protected by amt->lock.
But amt_request_handler() doesn't protect this variable.

Taehee Yoo (8):
  amt: use workqueue for gateway side message handling
  amt: remove unnecessary locks
  amt: use READ_ONCE() in amt module
  amt: add missing regeneration nonce logic in request logic
  amt: drop unexpected advertisement message
  amt: drop unexpected query message
  amt: drop unexpected multicast data
  amt: do not use amt->nr_tunnels outside of lock

 drivers/net/amt.c | 238 ++++++++++++++++++++++++++++++++++++----------
 include/net/amt.h |  20 ++++
 2 files changed, 206 insertions(+), 52 deletions(-)

-- 
2.17.1

