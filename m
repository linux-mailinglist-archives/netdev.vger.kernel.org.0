Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDA2D2E2EB9
	for <lists+netdev@lfdr.de>; Sat, 26 Dec 2020 18:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbgLZRNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Dec 2020 12:13:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbgLZRNH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Dec 2020 12:13:07 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41D0CC061757
        for <netdev@vger.kernel.org>; Sat, 26 Dec 2020 09:12:27 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id b8so3654801plx.0
        for <netdev@vger.kernel.org>; Sat, 26 Dec 2020 09:12:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=KqZFcqW2oDj+zmhGfW8tx5eW3FwdJZXkV1RKInL+8Fw=;
        b=Uwq9Hi4LNp1JAbZbHl0me2I1MNBJ1K1PmsMtL8wglMCWD07UzQnUnbuNYxKR2oUp8K
         uqkFYToq6lKlU6XrO1jnnoPXtIPJL/4sQIHv7H4QF4qSuRwHcM0DBXVYnU6Sd7TvbY4A
         m+ScgYmRFev0oPnWwSh7Wu+Y5UUWiQTNMFI2tHOie3CyntTWWZPjB5mEclteGr7Tqz7W
         qeMaaf/ydf/fNHN5ufw2pTKGOfcEyfQnxt5EJf1m/uU+DLgy8JUjRynSzeZPITZsLWGi
         VAqBWQwa7o5S8cilmxDDnVKNuG774At6Awgpc9KP3cfKP8idOcHK8+0nH/uk1c+eHlY2
         2Bdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=KqZFcqW2oDj+zmhGfW8tx5eW3FwdJZXkV1RKInL+8Fw=;
        b=IkJhJhpLf9S6qY7zOz4c6BbLBO05wnS2/Xeqw7suYgRKoR2FRuvAbEhRH1kprVHMXE
         738AEWVmbyKbFCWBN9Xtok8TaLTOil51NNzKCjWLIHuKEwJ8krqphQoTc0u7uGvzBIYg
         0obXAYvkKlEzt6P0vs8+8g/SYjIWbPRlSOVs0wG6AcOav5S92u6eUA3SS+gMN8GAXpTr
         mL3WpTQ+tBU5WPgV0z+uXtmjOnTennbPaqCXUjqVpmTS3zBx7gpF6tMDKCXJJfkJih5Z
         iF+U8ehTUOMZJlA7GdRTQwJOjyu0vzrSIt8/5FTWBcvtPUk1Yd5J0PUC1Emtp2ulOXZJ
         OFVA==
X-Gm-Message-State: AOAM530JfvExvqBy9N4oZ0A5hdnxpNz6crY4WTIG89/RpjtOqXu1LWf4
        03DSb5U/qe0tuMqRvWIxeHI=
X-Google-Smtp-Source: ABdhPJw0zkKFlpeqGe8dX5k7MmRsO5DoEFtIpCZAEeaZXt/KKptmbO4C+Uwm9al5HTrq8gFFmy41hw==
X-Received: by 2002:a17:90a:b118:: with SMTP id z24mr13260428pjq.14.1609002746683;
        Sat, 26 Dec 2020 09:12:26 -0800 (PST)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id d203sm31888611pfd.148.2020.12.26.09.12.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Dec 2020 09:12:25 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, martin.varghese@nokia.com
Subject: [PATCH net 0/2] bareudp: fix several issues
Date:   Sat, 26 Dec 2020 17:12:14 +0000
Message-Id: <20201226171214.4108-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset is to fix problems when bareudp is used nestedly.

1. If the NETIF_F_LLTX flag is not set, the lockdep warns about
a possible deadlock scenario when bareudp interfaces are used nestedly.
But, like other tunneling interfaces, bareudp doesn't need xmit lock.
So, it sets NETIF_F_LLTTX.
Lockdep no more warns about a possible deadlock scenario.

2. bareudp interface calculates min_headroom when it sends a packet.
When it calculates min_headroom, it uses the size of struct iphdr even
the ipv6 packet is going to be sent.
It would result in a lack of headroom so eventually occurs kernel panic.

Taehee Yoo (2):
  bareudp: set NETIF_F_LLTX flag
  bareudp: Fix use of incorrect min_headroom size

 drivers/net/bareudp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
2.17.1

