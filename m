Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB76A6BBE3E
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 21:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232346AbjCOU56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 16:57:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232285AbjCOU55 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 16:57:57 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F1609DE03
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 13:57:48 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-540e3b152a3so153235627b3.2
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 13:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678913868;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rO20nnJzG8gRbxHKgQGCETJcllrn6HFVROCAI9bEkHQ=;
        b=BsInDrYwLHSsW1BMwM1ck4nPqbtN8M0KFSxU6jJJPb1fzXtRC2LYNkktAlq1iALLSw
         RKkrsBxk2XwIQekfrZm0lngM/6kGbOwP/Sv7aJxszPLAKo76yzVhYebj+ez7sQEdoiiE
         b2M+g06/DqtXProXch/qrRnqdGQdCnnRnKKOoS95C8VucEPAxgNHqp+FH7c25pb/voSL
         r9tp9gn+cbbb1/+7GqcZ8knDJVcEptJgnMU1EJxWSv8CtdXJHfhNXOG/c0OIire9EiFt
         APFNJBegLdvjATEdEHtKqONi0tv8GO1YzYIYvt538aCkeeQ0Ay038CrvoB20gC/SBMCs
         Fbvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678913868;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rO20nnJzG8gRbxHKgQGCETJcllrn6HFVROCAI9bEkHQ=;
        b=oBj/p29yUj+eSQqwMB3QxCMOlq9Ks24jYLKfJ1bWB4SQQdtEfpwqS4Hp7WYGBeCSp4
         3s5eBNZPOXV3oGSvN7AJS9AwVGBqi6MCg39BB5Zu7vUJ1feECWZHJEcCsMD/QsfLFGtr
         UDuvrUu+hjcVNOM3Y8znLRCVUHxogHe2R2NcFlhAUu3JTH8XrMCAfe/aXnhVCzN8o+mq
         YjYqO5RU1VTbR9wWo3KvN8jF7PguAUH9u1XJz9Ler/JJYOsRhgVLcRxkDmTbYbZACslQ
         ciiXKoY00kKglPXGf2xTA5qq6Lq8W5EvGZPQ20YHvFunDzUQVne2RoOBsVOOSwDQyA51
         pVsA==
X-Gm-Message-State: AO0yUKXsCG8op+uDaqFbJQiGYEAeMjuUIh8v+XoLt35Kpudlnj7zhNkn
        i6oLT2BijB11aevwT68Nr+gprHmcCZRKmQ==
X-Google-Smtp-Source: AK7set/1LmwzMc/1F3LgpmhyxIzeMoJ1OSmHzd1sR9FsHNUGLX+79KBB/GKyO4oPyoiq4+oYASTB8gDg4M5FvQ==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:9f84:0:b0:8ac:72e3:c743 with SMTP id
 u4-20020a259f84000000b008ac72e3c743mr14650452ybq.9.1678913867892; Wed, 15 Mar
 2023 13:57:47 -0700 (PDT)
Date:   Wed, 15 Mar 2023 20:57:40 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230315205746.3801038-1-edumazet@google.com>
Subject: [PATCH net-next 0/6] net: annotate lockless accesses to sk_err[_soft]
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

This patch series is inspired by yet another syzbot report.

Most poll() handlers are lockless and read sk->sk_err
while other cpus can change it.

Add READ_ONCE/WRITE_ONCE() to major/usual offenders.

More to come later.

Eric Dumazet (6):
  tcp: annotate lockless accesses to sk->sk_err_soft
  dccp: annotate lockless accesses to sk->sk_err_soft
  net: annotate lockless accesses to sk->sk_err_soft
  tcp: annotate lockless access to sk->sk_err
  mptcp: annotate lockless accesses to sk->sk_err
  af_unix: annotate lockless accesses to sk->sk_err

 fs/dlm/lowcomms.c                |  7 ++++---
 net/atm/signaling.c              |  2 +-
 net/dccp/ipv4.c                  | 12 +++++++-----
 net/dccp/ipv6.c                  | 11 ++++++-----
 net/dccp/timer.c                 |  2 +-
 net/ipv4/af_inet.c               |  2 +-
 net/ipv4/tcp.c                   | 11 ++++++-----
 net/ipv4/tcp_input.c             |  8 ++++----
 net/ipv4/tcp_ipv4.c              | 10 +++++-----
 net/ipv4/tcp_output.c            |  2 +-
 net/ipv4/tcp_timer.c             |  6 +++---
 net/ipv6/af_inet6.c              |  2 +-
 net/ipv6/inet6_connection_sock.c |  2 +-
 net/ipv6/tcp_ipv6.c              | 15 ++++++++-------
 net/mptcp/pm_netlink.c           |  2 +-
 net/mptcp/protocol.c             |  8 ++++----
 net/mptcp/subflow.c              |  4 ++--
 net/sctp/input.c                 |  2 +-
 net/sctp/ipv6.c                  |  2 +-
 net/unix/af_unix.c               |  9 +++++----
 20 files changed, 63 insertions(+), 56 deletions(-)

-- 
2.40.0.rc2.332.ga46443480c-goog

