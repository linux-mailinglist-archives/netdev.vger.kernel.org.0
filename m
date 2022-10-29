Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12DD0612447
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 17:45:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbiJ2Pp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 11:45:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiJ2PpZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 11:45:25 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3CE662A7C
        for <netdev@vger.kernel.org>; Sat, 29 Oct 2022 08:45:24 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id l188-20020a2525c5000000b006cbcff0ab41so6954166ybl.4
        for <netdev@vger.kernel.org>; Sat, 29 Oct 2022 08:45:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=UglcZHu7XvHG1xW6aCbCNsjo0m8Ksv4zwNhJkAsqnR0=;
        b=Ao/0zJIFgxw0DeB0fQZdm9t2xnpCKYaYjgCUThGUxRIRfe6RJSabKd3KNaSV3U8gnI
         HlJ4P9Lzr38PjIKUxg0PsZJZRSh/x+OwLeqCzD0Q/rsQ6gpcTD7Qg0Z3bpb8HZM5nwmh
         n6eRSCfXLoIXKEnbIzj13+XCwo/IBVM1OEohkqmtUoeMpj8YqNjV7Q/l3ACuhPXShooZ
         c+O4TE2mCZS8k4XzANAo8Nnid5kZGGdQTUxPG+YP+y5J15Prk3fy++2oZ7eDksxlbBdp
         DoXTCMvJ4gUVD1kdR2tgAUjfwZupW2897SijxOn5c0AYMur55UN5uo9QzRBuvz/Wzy0e
         c6ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UglcZHu7XvHG1xW6aCbCNsjo0m8Ksv4zwNhJkAsqnR0=;
        b=3zGIkP5kynVLraQbnJjf3eupLlcCybL/UxHJZ6C/j7WEcChMcqu9mhAzjWP5gGNfC6
         fn78wHMLxyO58Qh7BuhmjxeGR3U80G19zN+7SvXKj0b/qIizKJ50cTPQBHTEZt+dtG9M
         RIyMb2EZafRYx1NIAd5Q/G/iTQ7WQOr9nZN/7eEmpXdqFry+BimvhA0e7gwYdAvU84NN
         9FAYceQmuNzYrgjj4JOihW3pahr8VNZCuQFSJf5pPBOlOQ+x6LS73Sz0p64KwC7iqSZL
         Vpy19fFLyhdVc0AXL6vSy1cDrLb8nmMioNcFbONNrn7EaMBTd6urFKf3ge/Qe1QJlL0W
         5CxQ==
X-Gm-Message-State: ACrzQf11QGB6mDylq6LEzR++VEr8/VARJEkAGRqz1/MR251S18Qxzfhu
        9UZvf+3jkv0odTsSKwAVw9djdvADw1IcYA==
X-Google-Smtp-Source: AMsMyM7TW61XYWcQln57Q4JsXeGe/UQcC5DXBaJ1JXVw7Yo4BrTLGIjNRVns46KgPTVZVfRB0II6A++inL79VA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:23c2:0:b0:6ca:fb5a:eaae with SMTP id
 j185-20020a2523c2000000b006cafb5aeaaemr4257939ybj.103.1667058324227; Sat, 29
 Oct 2022 08:45:24 -0700 (PDT)
Date:   Sat, 29 Oct 2022 15:45:15 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221029154520.2747444-1-edumazet@google.com>
Subject: [PATCH v2 net-next 0/5] inet: add drop monitor support
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I recently tried to analyse flakes in ip_defrag selftest.
This failed miserably.

IPv4 and IPv6 reassembly units are causing false kfree_skb()
notifications. It is time to deal with this issue.

First two patches are changing core networking to better
deal with eventual skb frag_list chains, in respect
of kfree_skb/consume_skb status.

Last three patches are adding three new drop reasons,
and make sure skbs that have been reassembled into
a large datagram are no longer viewed as dropped ones.

After this, understanding why ip_defrag selftest is flaky
is possible using standard drop monitoring tools.

v2: fix kdoc warning (Jakub)

Eric Dumazet (5):
  net: dropreason: add SKB_CONSUMED reason
  net: dropreason: propagate drop_reason to skb_release_data()
  net: dropreason: add SKB_DROP_REASON_DUP_FRAG
  net: dropreason: add SKB_DROP_REASON_FRAG_REASM_TIMEOUT
  net: dropreason: add SKB_DROP_REASON_FRAG_TOO_FAR

 include/net/dropreason.h                | 14 ++++++++++++
 include/net/inet_frag.h                 |  6 ++++-
 include/net/ipv6_frag.h                 |  3 ++-
 net/core/skbuff.c                       | 30 ++++++++++++++-----------
 net/ipv4/inet_fragment.c                | 14 ++++++++----
 net/ipv4/ip_fragment.c                  | 19 +++++++++++-----
 net/ipv6/netfilter/nf_conntrack_reasm.c |  2 +-
 net/ipv6/reassembly.c                   | 13 +++++++----
 8 files changed, 71 insertions(+), 30 deletions(-)

-- 
2.38.1.273.g43a17bfeac-goog

