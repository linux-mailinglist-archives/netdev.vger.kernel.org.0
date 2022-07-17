Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFBBC577737
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 18:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbiGQQMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 12:12:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiGQQMU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 12:12:20 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA24112D39
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 09:12:19 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id w185so8750602pfb.4
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 09:12:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=g3pk4SG7k29YdHCKZLixz/uw022qKyovlbcpaVHGxRg=;
        b=pO+pKsr/h741Rt2Vs0ONx5vHCtoJJVuOEk3vuhi+VyowlDTmtM+JFvgcqGdTUoTVlf
         zQMTBvGUQTK61x1wVdgcS30yO9oWDMHE4IGr5DobqbcM6Jm5+SJfIzBzElsaPXfHUz7g
         /pDSofUZl+ZtcPuq3vYXtLZdnTaxiJw/kCvtDsy2wPDr56PX2XcjdCuZLGIQ28F+QKud
         xcJBBokWLRjA3p+0hBdwal1OsTzlhxgdR190RTJP94+MC32F3txuChj2s2v4GXLcYvzI
         bRYKMfR1kCGNz5Ja07f78kpJve9M6M3sO8iZdKQr/7PwNHn/Xz2OG3nvDZ1nJoDvRn0S
         eG6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=g3pk4SG7k29YdHCKZLixz/uw022qKyovlbcpaVHGxRg=;
        b=x7szYjg8/OsXtWj8tYa2B+Il/ipbKgaAvJkeeMjrzCn2+ohiMUihyeD7CPTNBkumXd
         IGvahvyybY6SMnWSCKwdF6/gJ1ecoKTRLURUJ3p8N3I0lpBWkA17oZla9WeHDzALX4wx
         eCfjNZDHnDaAlkGHirg+JfnVA1Dq3syvRT9UU5x+0sFN9/+WwZ3z1+kCenfoFo2i4dBB
         0uNky4faK8enPDrOmpSY3knkV/vz6DxfO0N2DpJSSO9nj8jKcHwwlQgSuhQ3rHKlSoEi
         7HhluEpli3iZbMpjY0rlVgILMIO+Ei7cFF8khSXaMIhvpJNxrdDM8YUXWE9x9ey0KzEo
         D6og==
X-Gm-Message-State: AJIora8wIDpa8g1DlP8Yi40ymguec9Z2HZLuYOYuFVnG7af01gxeicwn
        N/Imtr7RFeCNhzvs3ns2mnk=
X-Google-Smtp-Source: AGRyM1urwpzuC+17mrW0CV3JLOh2Uwo0cn0w9/yzlGfWmx1Hwkn/nWXanFrMxGFCfWCgCNA8VD+ZRA==
X-Received: by 2002:aa7:88c3:0:b0:52a:d6ee:eb5d with SMTP id k3-20020aa788c3000000b0052ad6eeeb5dmr24174529pff.63.1658074339127;
        Sun, 17 Jul 2022 09:12:19 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id x10-20020a170902ec8a00b0016bde5edfb1sm7443026plg.171.2022.07.17.09.12.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jul 2022 09:12:18 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net v2 0/8] amt: fix validation and synchronization bugs
Date:   Sun, 17 Jul 2022 16:09:02 +0000
Message-Id: <20220717160910.19156-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

v2:
 - Use local_bh_disable() instead of rcu_read_lock_bh() in
   amt_membership_query_handler.
 - Fix using uninitialized variables.
 - Fix unexpectedly start the event_wq after stopping.
 - Fix possible deadlock in amt_event_work().
 - Add a limit variable in amt_event_work() to prevent infinite working.
 - Rename amt_queue_events() to amt_queue_event().

Taehee Yoo (8):
  amt: use workqueue for gateway side message handling
  amt: remove unnecessary locks
  amt: use READ_ONCE() in amt module
  amt: add missing regeneration nonce logic in request logic
  amt: drop unexpected advertisement message
  amt: drop unexpected query message
  amt: drop unexpected multicast data
  amt: do not use amt->nr_tunnels outside of lock

 drivers/net/amt.c | 239 ++++++++++++++++++++++++++++++++++++----------
 include/net/amt.h |  20 ++++
 2 files changed, 207 insertions(+), 52 deletions(-)

-- 
2.17.1

