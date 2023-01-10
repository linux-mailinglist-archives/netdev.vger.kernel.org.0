Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 548E566420F
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 14:38:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbjAJNiT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 08:38:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233423AbjAJNhu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 08:37:50 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4884463D0C
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 05:37:34 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id c34so17648675edf.0
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 05:37:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ApiMzkUYlEVgABehh96Rp2PgM+rBFqxlX1OkniJnIk0=;
        b=KHXakhjhLvEgaDbpPHEtgRPu5NluHgmJrMH8/Yfb5G3X23xzECuGtbymJuYCgjg4qG
         NfAXLHf7Y6kQNM8ttmrzXyEfjcBt7EEfDdrFy2FwFEB7yskj0hOuVROpJZ2DDEiHA6Wc
         +PM37yny2SRiQKOntxhS2txcnfFufEsmPyaSM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ApiMzkUYlEVgABehh96Rp2PgM+rBFqxlX1OkniJnIk0=;
        b=xNFfM9aV87YjpG7Ub+R7sRt1kg2R1WNtVe44p8QApXnXhIFd9BOdkrbANJqFsRYqkW
         EyHwQ30x6hceS2X1VJbf8242fRle6gFtznQfHuvBXvvAFOXSnWHoJWqjSdfUx3+rwRwZ
         vv5fCPU8ykVGV/vaUWC1O50tcqepJahdmwEPAQk62upOQPub2stf430GTYwMtCfXq6cD
         ceJSUbnDto7kqR3zUf0Iqwnqne4W3uJ785KZpCI4H9hXUAULUqnOUjhcKTGeThKY7jK4
         yj7IULmdOfVaFn9FlTzlfqp3oXnAek1VqOdZkg73+URaTlNbzSSG7X7LPqkLuNu9eDDg
         f4PA==
X-Gm-Message-State: AFqh2kqIbp6X6BjO3OsIfpJncHd6ROZ9xBgGE2Agwczuktd635BNMUre
        1mY9IgxHPAw3jbdb5H0IY3fGdNDBLRL2Sc6y
X-Google-Smtp-Source: AMrXdXubJWBsl24QxgDfYLIYf0aTClwpplT6lLZXVikpVjFqy2nSr6nqSpGgATwn4H0UPgSLSqiLUg==
X-Received: by 2002:a05:6402:150b:b0:493:a6eb:874e with SMTP id f11-20020a056402150b00b00493a6eb874emr19057567edw.5.1673357852302;
        Tue, 10 Jan 2023 05:37:32 -0800 (PST)
Received: from cloudflare.com (79.184.151.107.ipv4.supernova.orange.pl. [79.184.151.107])
        by smtp.gmail.com with ESMTPSA id n10-20020aa7d04a000000b0048eba29c3a0sm4939762edo.51.2023.01.10.05.37.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 05:37:31 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        kernel-team@cloudflare.com
Subject: [PATCH net-next v2 0/2] Add IP_LOCAL_PORT_RANGE socket option
Date:   Tue, 10 Jan 2023 14:37:28 +0100
Message-Id: <20221221-sockopt-port-range-v2-0-1d5f114bf627@cloudflare.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set is a follow up to the "How to share IPv4 addresses by
partitioning the port space" talk given at LPC 2022 [1].

Please see patch #1 for the motivation & the use case description.
Patch #2 adds tests exercising the new option in various scenarios.

Documentation
-------------

Proposed update to the ip(7) man-page:

       IP_LOCAL_PORT_RANGE (since Linux X.Y)
              Set or get the per-socket default local port range. This
              option  can  be used to clamp down the global local port
              range, defined by the ip_local_port_range  /proc  inter‐
              face described below, for a given socket.

              The option takes an uint32_t value with the high 16 bits
              set to the upper range bound, and the low 16 bits set to
              the lower range bound. Range bounds are inclusive.

              The lower bound has to be less than the upper bound when
              both bounds are not zero. Otherwise, setting the  option
              fails with EINVAL.

              If  either  bound  is  outside  of the global local port
              range, or is zero, then that bound has no effect.

              To reset the setting, pass zero as both  the  upper  and
              the lower bound.

Changelog:
---------

v1 -> v2:
v1: https://lore.kernel.org/netdev/20221221-sockopt-port-range-v1-0-e2b094b60ffd@cloudflare.com/

 * Fix the corner case when the per-socket range doesn't overlap with the
   per-netns range. Fallback correctly to the per-netns range. (Kuniyuki)

 * selftests: Instead of iterating over socket families (ip4, ip6) and types
   (tcp, udp), generate tests for each combo from a template. This keeps the
   code indentation level down and makes tests more granular.

 * Rewrite man-page prose:
   - explain how to unset the option,
   - document when EINVAL is returned.

RFC -> v1
RFC: https://lore.kernel.org/netdev/20220912225308.93659-1-jakub@cloudflare.com/

 * Allow either the high bound or the low bound, or both, to be zero
 * Add getsockopt support
 * Add selftests

Links:
------

[1]: https://lpc.events/event/16/contributions/1349/

To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: kernel-team@cloudflare.com
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>

---
Jakub Sitnicki (2):
      inet: Add IP_LOCAL_PORT_RANGE socket option
      selftests/net: Cover the IP_LOCAL_PORT_RANGE socket option

 include/net/inet_sock.h                            |   4 +
 include/net/ip.h                                   |   3 +-
 include/uapi/linux/in.h                            |   1 +
 net/ipv4/inet_connection_sock.c                    |  25 +-
 net/ipv4/inet_hashtables.c                         |   2 +-
 net/ipv4/ip_sockglue.c                             |  18 +
 net/ipv4/udp.c                                     |   2 +-
 tools/testing/selftests/net/Makefile               |   2 +
 tools/testing/selftests/net/ip_local_port_range.c  | 439 +++++++++++++++++++++
 tools/testing/selftests/net/ip_local_port_range.sh |   5 +
 10 files changed, 496 insertions(+), 5 deletions(-)
---
base-commit: a3ae16030a0320229df10cedfeff1f80df26ee76
change-id: 20221221-sockopt-port-range-e142de700f4d

Best regards,
-- 
Jakub Sitnicki <jakub@cloudflare.com>
