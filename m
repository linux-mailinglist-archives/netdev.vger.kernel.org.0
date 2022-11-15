Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88F926293EC
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 10:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237723AbiKOJLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 04:11:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237858AbiKOJLG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 04:11:06 -0500
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6920425D5
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 01:11:04 -0800 (PST)
Received: by mail-qk1-x74a.google.com with SMTP id bq13-20020a05620a468d00b006fa5a75759aso13209890qkb.13
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 01:11:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/6GUTOkkVxk42tT/LShDvXq+HVfLdGNcjJwIBGOOLgg=;
        b=cW8GvdxmWH0G5n5WRyVAEGBF4AyjeWwhQsa5SpxrRDK3M57lQlDe+kYb6Y5k0FytIB
         oKu1zAA6nat/Ue+WF2aP5FomZPYso1ZldgsnAtVLTMh3MvV6nFD0sFiw8PUJLRfAaqKT
         Z28lgX5udLha64DsOc/kCZgOR00dS6R8kEwxulxjJczWeCeNCnLOkidJs0azTg+Dlpug
         6C8nfrvBrwRUKJPHncJYDKbQOh3QYKcO7a0epFETaXW0f5e6U8DE66LOJp33JVS9nXvz
         tf5dukFyAEApmrUCUkTd/T6s/2KFAnJJvzlr30dJDbsfLnCeppnyOqIBWch0RMkTF5Z6
         m48w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/6GUTOkkVxk42tT/LShDvXq+HVfLdGNcjJwIBGOOLgg=;
        b=dkbJUfWWhJcdw2lmIUkeOVgJf+vwN7FjU/oXS9RaCxLJs98+uOBpbpx1XYIh1YWZht
         k3MsB3+EH16QKhhTuxgWXVWhjctdZKwTfl9B54ZF1NjiZDHS0v4snjtedIpig5XAuuB4
         oEOQ//MYuK0E5Ykr2S/BLqfN8XA9TVadt34o6GzEcLZfGJnlqLutdUEscm2nExCArnVJ
         zdx+clMlDcEhAzWyh+FR8Y3X7HLXpXOrGFd+bZGeuaN6AqFfZeINrFuugS3ltaY7Wumv
         wj14Ygvi3h7tkx5vZsYTsl5hfjiKzv36RojClnkHg4eKdMHhNkRTj73jI8h38l656AH4
         OLPA==
X-Gm-Message-State: ANoB5pmPrRWNLdsZTKhs0sPz8wfqmeWwPTZNQGy2z4Jh87d1JukAWBbk
        LV6HHUcUKd+XCPICE3Ay7UOEgBicV6XEgw==
X-Google-Smtp-Source: AA0mqf7OpJ/tMQWcrdRiJS1MUhehLTcTG+PGBr3hkDuXSOpkt2dCYzVCLAcV5hl38Z+WDOTqVE/qN6mFC8b99Q==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:622a:1f86:b0:399:18c3:ee92 with SMTP
 id cb6-20020a05622a1f8600b0039918c3ee92mr15902737qtb.15.1668503463621; Tue,
 15 Nov 2022 01:11:03 -0800 (PST)
Date:   Tue, 15 Nov 2022 09:10:55 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221115091101.2234482-1-edumazet@google.com>
Subject: [PATCH net-next 0/6] net: more try_cmpxchg() conversions
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

Adopt try_cmpxchg() and friends in more places, as this
is preferred nowadays.

Eric Dumazet (6):
  net: mm_account_pinned_pages() optimization
  ipv6: fib6_new_sernum() optimization
  net: net_{enable|disable}_timestamp() optimizations
  net: adopt try_cmpxchg() in napi_schedule_prep() and
    napi_complete_done()
  net: adopt try_cmpxchg() in napi_{enable|disable}()
  net: __sock_gen_cookie() cleanup

 net/core/dev.c       | 42 +++++++++++++++---------------------------
 net/core/skbuff.c    |  5 ++---
 net/core/sock_diag.c | 12 ++++++------
 net/ipv6/ip6_fib.c   |  7 +++----
 4 files changed, 26 insertions(+), 40 deletions(-)

-- 
2.38.1.431.g37b22c650d-goog

