Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CEE865FF0A
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 11:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbjAFKhx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 05:37:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjAFKho (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 05:37:44 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B99016C2A5
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 02:37:42 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id fc4so2536343ejc.12
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 02:37:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gQnlpKgwe0xqLhj+MTVc/9g2kyjsM2ur4M2Y+9pYfEk=;
        b=hUcb1qds4iVXpS5xpGp9+kqZtcGLgUKUXzxsCHoPp21+inyvuVIQW15dSwnHK0Qe2d
         vIon3IN688mxIuIM5NK1xu+ZwhMdJ+ER1/9UqlK0d0so6Wo/f6BSCKfmEx9rsgEUKgKP
         3wcfthFgmwAxy8vM5O3hDpgkwBcrd3eHedmSo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gQnlpKgwe0xqLhj+MTVc/9g2kyjsM2ur4M2Y+9pYfEk=;
        b=EGO0b35a0VDEnUYi7Qafje7DMapyoWuMJw3fyZD2o6eqo5g4SWwIS+wBvafpHcLlnK
         ux2OMuTKDHv9Lc4HMWWcElRINA0wugoRALJmC/h/7/rFPhFoAM2B38QOM//zOt8pagUG
         bLJwPjJwNxqTYld0Czs7P2Y/QsfvrTODifqFcJZEt+G4jaoMxD1bT10s0JRs1N/6a7QY
         R/E9IbHlisoF2co4/xtSbK3gOFQIT6xN7nqcLS0jEtLt7rP7PJDCVoMoGm3FwpA8udp7
         BbE6dRfYlWGwmIgbTq0zKIo+ndy8oiwo8gYMi4q9Y7f+/p5kc+k1CicNPMeuvN4SLZut
         qpVA==
X-Gm-Message-State: AFqh2kp5KD+hCUCPbTQGzbr579Zs7DcpBUdSlZ0DIytSLLvo8E0MuRZ/
        MkXiH8shGWnoK3l6WvFjDrFdXrl3osoCAUca
X-Google-Smtp-Source: AMrXdXvUweYjpe0RGwLD7nyR838+Uhz7gsLetOq47n7oc3atX0Z8DDV3DSZokLW6DblJ0gJRij9I3g==
X-Received: by 2002:a17:906:9f07:b0:7c1:6f0a:a2cf with SMTP id fy7-20020a1709069f0700b007c16f0aa2cfmr48899470ejc.32.1673001460498;
        Fri, 06 Jan 2023 02:37:40 -0800 (PST)
Received: from cloudflare.com (79.184.146.66.ipv4.supernova.orange.pl. [79.184.146.66])
        by smtp.gmail.com with ESMTPSA id 17-20020a170906059100b007933047f923sm278807ejn.118.2023.01.06.02.37.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 02:37:39 -0800 (PST)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     kernel-team@cloudflare.com
Subject: [PATCH net-next 0/2] Add IP_LOCAL_PORT_RANGE socket option
Date:   Fri,  6 Jan 2023 11:37:36 +0100
Message-Id: <20221221-sockopt-port-range-v1-0-e2b094b60ffd@cloudflare.com>
X-Mailer: git-send-email 2.38.1
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

If the changes were to be accepted, here is the proposed update to the ip(7)
man-page:

  IP_LOCAL_PORT_RANGE (since Linux X.Y)
         Set  or get the per-socket default local port range. This option
         can be used to clamp down the global local port  range,  defined
         by  the ip_local_port_range /proc interface described below, for
         a socket. The option takes a uint32_t value  with  the  high  16
         bits  set  to  the upper range bound, and the low 16 bits set to
         the lower range bound. Range bounds are inclusive. If the speci‐
         fied  high  or  low  bound  is  outside of the global local port
         range, or is set to zero, the set bound has no effect.

Changelog:
---------
RFC -> v1
RFC: https://lore.kernel.org/netdev/20220912225308.93659-1-jakub@cloudflare.com/

 * Allow either the high bound or the low bound, or both, to be zero
 * Add getsockopt support
 * Add selftests

Links:
------
[1]: https://lpc.events/event/16/contributions/1349/

To: netdev@vger.kernel.org
To: "David S. Miller" <davem@davemloft.net>
To: Eric Dumazet <edumazet@google.com>
To: Jakub Kicinski <kuba@kernel.org>
To: Paolo Abeni <pabeni@redhat.com>
Cc: kernel-team@cloudflare.com
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>

---
Jakub Sitnicki (2):
      inet: Add IP_LOCAL_PORT_RANGE socket option
      selftests/net: Cover the IP_LOCAL_PORT_RANGE socket option

 include/net/inet_sock.h                            |   4 +
 include/net/ip.h                                   |   3 +-
 include/uapi/linux/in.h                            |   1 +
 net/ipv4/inet_connection_sock.c                    |  22 +-
 net/ipv4/inet_hashtables.c                         |   2 +-
 net/ipv4/ip_sockglue.c                             |  18 +
 net/ipv4/udp.c                                     |   2 +-
 tools/testing/selftests/net/Makefile               |   2 +
 tools/testing/selftests/net/ip_local_port_range.c  | 439 +++++++++++++++++++++
 tools/testing/selftests/net/ip_local_port_range.sh |   5 +
 10 files changed, 493 insertions(+), 5 deletions(-)
---
base-commit: 3d759e9e24c38758abc19a4f5e1872a6460d5745
change-id: 20221221-sockopt-port-range-e142de700f4d

Best regards,
-- 
Jakub Sitnicki <jakub@cloudflare.com>
