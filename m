Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2C64499C0A
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 23:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380406AbiAXV7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 16:59:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1456553AbiAXVjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 16:39:31 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32C52C0417CB
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 12:25:05 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id h23so16374087pgk.11
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 12:25:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gN3Tly1dxs6y7HLNyoII0+pzanW8dVYCE9floK57R/w=;
        b=pDU7h1xT5qH/0VjD+Ue9jC5gJEVtaY13eGsYU9yYfZY+9/uVZsS1+ufbpoPQrnOvtQ
         vI6ElAuuK0bGFc9tHUy3SqNtlOkXDi7ChOoO8rkWeZ7kFcY1xJL3Oep0emOomsoN82m/
         7bM5XoksC6HjYbLoyPIwcv3ecKalnJQYbELWHKrduL1hZvWqo8sAxkVYGHNoQIr+Hs2Z
         1lnDTFNVHYDW5+8u1Xz01TgSbtoZbX3GqWzE/hB97OrVHeMlHX3cxhfWrDBLofQE9RhA
         HYdIz8yAi+Qq5VXGv01xUPJrfWTjDKoqbkNUzFRTiJUi/sUDhI27NliQ1msyaGH4OGI0
         HEgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gN3Tly1dxs6y7HLNyoII0+pzanW8dVYCE9floK57R/w=;
        b=b6QSz7d+fJsIIRPhX1LQWcifcCbBdDCCw5xLA5ENVWmJ9CbIEVc/YU7VB5/7RW+fy4
         4eXme6fL+TGByWyPcHBpUkjMLVLJ27OpJBhXDpd/2YhqRD90wJQUgVvggca5+uBvqiCk
         9AqbAgB74V7eFJUlNnD55AjhhH6v6Fbvhtm2Qh6H9cIzKr6Ukx83DPNuV23g64EIBelN
         lqZO+5uHMiZY374k10nm0W4ABQHnEhydTyPKkMORfn4uWNSUON+7LPKWFJGAfvO5dSLo
         7AAk1jkt4GmQmciI9gAfA81utKdT4QWxsb/aepkHGV8yvl7KTjr2UfnqKMNpb1UuiLpq
         Qe7g==
X-Gm-Message-State: AOAM530HJ/NxprlLmi12oJBOvBXdEjc8B3Pf0rS6vcOawKTqglJXi5qv
        0D4eU6qVjORTpsyQqguU0sseWfY6Aa0=
X-Google-Smtp-Source: ABdhPJwMKAfbWtaQJilDzn5BKDQa6gPpeB2+aOzuJXDE7ghk+CsvEez/1FGLVNchYr/+Q8sUBIXkpg==
X-Received: by 2002:a63:81c3:: with SMTP id t186mr8515344pgd.462.1643055904693;
        Mon, 24 Jan 2022 12:25:04 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:e903:2adf:9289:9a45])
        by smtp.gmail.com with ESMTPSA id c19sm17871115pfv.76.2022.01.24.12.25.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 12:25:04 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 0/6] netns: speedup netns dismantles
Date:   Mon, 24 Jan 2022 12:24:51 -0800
Message-Id: <20220124202457.3450198-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

netns are dismantled by a single thread, from cleanup_net()

On hosts with many TCP sockets, and/or many cpus, this thread
is spending too many cpu cycles, and can not keep up with some
workloads.

- Removing 3*num_possible_cpus() sockets per netns, for icmp and tcp protocols.
- Iterating over all TCP sockets to remove stale timewait sockets.

This patch series removes ~50% of cleanup_net() cpu costs on
hosts with 256 cpus. It also reduces per netns memory footprint.

Eric Dumazet (6):
  tcp/dccp: add tw->tw_bslot
  tcp/dccp: no longer use twsk_net(tw) from tw_timer_handler()
  tcp/dccp: get rid of inet_twsk_purge()
  ipv4: do not use per netns icmp sockets
  ipv6: do not use per netns icmp sockets
  ipv4/tcp: do not use per netns ctl sockets

 include/net/inet_timewait_sock.h |  8 ++-
 include/net/netns/ipv4.h         |  2 -
 include/net/netns/ipv6.h         |  1 -
 net/dccp/ipv4.c                  |  6 ---
 net/dccp/ipv6.c                  |  6 ---
 net/ipv4/icmp.c                  | 91 +++++++++++---------------------
 net/ipv4/inet_timewait_sock.c    | 67 ++++-------------------
 net/ipv4/tcp_ipv4.c              | 63 ++++++++++------------
 net/ipv6/icmp.c                  | 62 ++++------------------
 net/ipv6/tcp_ipv6.c              |  6 ---
 10 files changed, 82 insertions(+), 230 deletions(-)

-- 
2.35.0.rc0.227.g00780c9af4-goog

