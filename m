Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 395166B828E
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 21:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbjCMUS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 16:18:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230243AbjCMUST (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 16:18:19 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF9319682
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 13:17:34 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-54161af1984so78853407b3.3
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 13:17:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678738654;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3pfz1vJ3T+M++rKXP/h902VkRcxZDJ6y45ghxMGxtCY=;
        b=O59sixANgGy7YtGF/sR8sH472ePNNIwZAoRgKGeZA/+jpSpi5i8wwe6RV4ZgbdLusG
         fwkXnAdYb/04+YAturUek1H0MPmLKkr7kgy1Z0kG4tmrvZL84Vm4uHgjrMMHK5csRaOb
         m8oLKrJaFOgnSpjQ7yqHdUWD6E6Xzeh/Z7fEbFuPxFAgCHSxW/mznFF0FvhitDiM9KPx
         zU+UL6XA8YMAPE+5cDTqxnldQVcTO9uHTa4YgcK8k1czq55wsfjP3FuMicxWqWseGAra
         Y3I+c/NYpzEgKkre2UyY+em9pvHOPa3vCehWEe9yeRL+PumqLhMQzdzz72b5Q5iwhTre
         A+YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678738654;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3pfz1vJ3T+M++rKXP/h902VkRcxZDJ6y45ghxMGxtCY=;
        b=Shyr4o4tdZqV7Bzenf/USmkwpaN2q26WbLZRfmVjxbD3YuI2Lw5PuvUMqTB+QWBV13
         soaVZ0rnOwYF8+X7b/UxCyYp9k1hY2k7ayLE4OtiyYctQwAV8pNj41jI5vmQJCoizHuI
         TtQk1MYOu8gXYlbe3O+4qD054Kn7FfiUxFEvs46XO5y/U+zn5cgvnlQpUqNWegBuydL/
         DeCifDSFWfd9bq5fTwPMFSoIGRHLQ3DnNryPctuVEXaK/dJzL9LO09Afr5t7drsYeUFR
         FpLujeztOMplgKIXRQO6nwGEYRSkH5OjaRCQXQcEBY5bscvAj39QMsznZ+h2go/rWoA9
         jf2g==
X-Gm-Message-State: AO0yUKWkD3ag0KqaVf6p0I1UVDldRDSh10uH2JyykDdfvmITQ9/WqQFr
        QvxXwIR4BozrGqKfxH+vZk/qfeQCwEzVBg==
X-Google-Smtp-Source: AK7set+qSf7Ru/AciVsUSND2Mxo9sINVQjqzj6wQRziz0GejDfnCZSKtuGHLm7VGTEexFWmhB6/X9GvGt1aW2w==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a5b:2cc:0:b0:a02:a3a6:78fa with SMTP id
 h12-20020a5b02cc000000b00a02a3a678famr17197774ybp.12.1678738653972; Mon, 13
 Mar 2023 13:17:33 -0700 (PDT)
Date:   Mon, 13 Mar 2023 20:17:30 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230313201732.887488-1-edumazet@google.com>
Subject: [PATCH net-next 0/2] ipv6: optimize rt6_score_route()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>
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

This patch series remove an expensive rwlock acquisition
in rt6_check_neigh()/rt6_score_route().

First patch adds missing annotations, and second patch implements
the optimization.

Eric Dumazet (2):
  neighbour: annotate lockless accesses to n->nud_state
  ipv6: remove one read_lock()/read_unlock() pair in rt6_check_neigh()

 drivers/net/vxlan/vxlan_core.c  |  4 ++--
 include/net/neighbour.h         |  2 +-
 net/bridge/br_arp_nd_proxy.c    |  4 ++--
 net/bridge/br_netfilter_hooks.c |  3 ++-
 net/core/filter.c               |  4 ++--
 net/core/neighbour.c            | 28 ++++++++++++++--------------
 net/ipv4/arp.c                  |  8 ++++----
 net/ipv4/fib_semantics.c        |  4 ++--
 net/ipv4/nexthop.c              |  4 ++--
 net/ipv4/route.c                |  2 +-
 net/ipv6/ip6_output.c           |  2 +-
 net/ipv6/ndisc.c                |  4 ++--
 net/ipv6/route.c                | 10 +++++-----
 13 files changed, 40 insertions(+), 39 deletions(-)

-- 
2.40.0.rc1.284.g88254d51c5-goog

