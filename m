Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9F91B49F4
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 18:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726503AbgDVQNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 12:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726303AbgDVQNk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 12:13:40 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0F9DC03C1A9
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 09:13:38 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id i21so2078283pgl.19
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 09:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=MYCyzq8RIog5OhFPbD8lVQLa9Y7exGeqAG2eT+QKWY8=;
        b=fdpS2PTB2OWNR+qXJgjHl4MqtVRPdy5pBqfjiUNC4kKjMjBhlfwAZFoCgXqFKTnxKQ
         CXuFRJYldkJOuSreBbt4IhPiMZViapXRHmO31Lx+IvOmpfbFUKUW8ANRDhuu1W1Vo2P7
         mX97No8eZg0MHLbPIe4xPQMq7B8GV+IcShcrYO/oMb6yzbWU2dJIctriGECtDyxxZ2FH
         rpsM+FiPAmacpURMO8J5j1oFmlW5xGdcLWl7ocnvggOe1UketZHYjBVJAtYWzA2HLslF
         1dcZtKmzcTLikfI1enlKvtPkxniRplAaqhPecUCEoZmDEJWpr4++0YbYdBSm6AppQGH1
         EWGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=MYCyzq8RIog5OhFPbD8lVQLa9Y7exGeqAG2eT+QKWY8=;
        b=bK2ndJRDYiIYLYHN7lPGYj67VSlrVsXILqvkJq7muh3n+NtQlfx4qMOIN1yRV8iMZU
         VcmxqAOi1rScSYJW8TIU1wFlaO0rXE+HaaE4Gh6Jccp5/7yE1w+E5CldkY2rJcP07EN4
         fXxAUyCr8ydN6hW6hP8qXR1wPA/Ndn/hEwxvcV6zovzXDRj9VHNTCzOgHnpdb/F3PTPI
         Om3OZAUOxN5ev5SN4Bu6blzxtj6G76TrFHtTcoNPytOOV1SwP8QCpbSi5WIV73WjSEYF
         mn7/6Rfc9rjApUCpA6KVrDaMbHqy2Az//N9QZz3BEk7jDbtndFjCH0T4gkcJPR3IwyMw
         xYHw==
X-Gm-Message-State: AGi0PuZfHHLMwQXrLXfQu8aDMURLk6e8MM9lWfmwigomQ2mnbN8WBWUU
        v7k2dt/haLov8haBUQpC1Ft/LrD+/0gklg==
X-Google-Smtp-Source: APiQypLS1Zjm2eUCGVWTqVm6iSSr+wrlNqAtJIPbwiXYrnUcgds51h2YBxLoiJLoacglDuzc+vWeKpYTeJgMdg==
X-Received: by 2002:a17:90a:8a14:: with SMTP id w20mr12980593pjn.176.1587572018176;
 Wed, 22 Apr 2020 09:13:38 -0700 (PDT)
Date:   Wed, 22 Apr 2020 09:13:26 -0700
Message-Id: <20200422161329.56026-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
Subject: [PATCH net-next 0/3] net: napi: addition of napi_defer_hard_irqs
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Luigi Rizzo <lrizzo@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series augments gro_glush_timeout feature with napi_defer_hard_irqs

As extensively described in first patch changelog, this can suppresss
the chit-chat traffic between NIC and host to signal interrupts and re-arming
them, since this can be an issue on high speed NIC with many queues.

The last patch in this series converts mlx4 TX completion to
napi_complete_done(), to enable this new mechanism.

Eric Dumazet (3):
  net: napi: add hard irqs deferral feature
  net: napi: use READ_ONCE()/WRITE_ONCE()
  net/mlx4_en: use napi_complete_done() in TX completion

 drivers/net/ethernet/mellanox/mlx4/en_rx.c   |  2 +-
 drivers/net/ethernet/mellanox/mlx4/en_tx.c   | 20 +++++++-------
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h |  4 +--
 include/linux/netdevice.h                    |  2 ++
 net/core/dev.c                               | 29 ++++++++++++--------
 net/core/net-sysfs.c                         | 20 +++++++++++++-
 6 files changed, 52 insertions(+), 25 deletions(-)

-- 
2.26.1.301.g55bc3eb7cb9-goog

