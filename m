Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FF9448141C
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 15:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240242AbhL2OcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 09:32:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236856AbhL2OcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 09:32:19 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A7B2C061574;
        Wed, 29 Dec 2021 06:32:19 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id h1so12790065pls.11;
        Wed, 29 Dec 2021 06:32:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Gd6eG/aXNgmPombBKtxfrdMpftZzEzC1rsLXap94Ro4=;
        b=dVJEY8pCznDl6apT2thYt9zK8WhQX+JqRXdjRs4powghiZOuAUNpqZLOFnszsennNv
         XZNf/aQ/dlyobZ9O+xIR6rpp5f7K3AfACBt92ky4GzZn48Z74PnSTKuS9wUFFcrGID45
         43z3wOBzpKOgTg5zYsAZkg2rQs0aMQMNswJpKYGUPPNUctiXBoxaw/4ESHNat92iCrLh
         EuicYTinHVD4LEVI9HvnsFMFJjB7sls/KMv7YBK1nWxPZY51uEqBjrH1xOT6G+8qPn7Q
         +0MEWADCVkMbrx0GxBY+OIQMnwzRVgklWtUxbLiQpotZMTMK4rGcYcwOu79+6sLK8zli
         sXOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Gd6eG/aXNgmPombBKtxfrdMpftZzEzC1rsLXap94Ro4=;
        b=Xa+gYLAcz8ecPsVhBJfdbPLkHGx0tCO/HTna3zGfgPLSr7YCNUEoABV262K22k+YEI
         /c1B7tMdHtwenYGt/yLnhz9K8ATSyQIEtE/cLw3wt1HTp2Kf35gqZKpjkwhw6tNvvexn
         g8yUrdEADXx/unKENISiGcirQ1t4PFSlsTaDqaFPnhnxBQUE8fg1HcZu8bIhjkN0jxm8
         BXStE+w00lPyc7WM6tUpTwkTKjREgS4XzLkFXj5LGVAeB7LoPWRVU6Gw1X/xptvl8oeu
         vDhaghlDzN5RxsI24QyNf4Vq+jROeoYeX0EmH/vR+bNOdo3dwctu8zC4R0Qsjg/XRz0v
         b8Hw==
X-Gm-Message-State: AOAM530dBnNX4y9eyMrzi0QBcsh31hLZZnPIEG+XV62JjTQjyi1S3Iph
        uA8aNKJQhWPjvaQwVtLGRDs=
X-Google-Smtp-Source: ABdhPJyz3rQz0lgZiKGndS9I87Wz6ksek7W94LtsqgLxYMwbsKYj43tDm6s/WS3tBgNju4ORylfCIw==
X-Received: by 2002:a17:90b:3614:: with SMTP id ml20mr32813002pjb.177.1640788339224;
        Wed, 29 Dec 2021 06:32:19 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.9])
        by smtp.gmail.com with ESMTPSA id v16sm24860393pfu.131.2021.12.29.06.32.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 06:32:18 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     rostedt@goodmis.org, dsahern@kernel.org
Cc:     mingo@redhat.com, davem@davemloft.net, kuba@kernel.org,
        nhorman@tuxdriver.com, edumazet@google.com,
        yoshfuji@linux-ipv6.org, jonathan.lemon@gmail.com, alobakin@pm.me,
        cong.wang@bytedance.com, pabeni@redhat.com, talalahmad@google.com,
        haokexin@gmail.com, keescook@chromium.org, imagedong@tencent.com,
        atenart@kernel.org, bigeasy@linutronix.de, weiwan@google.com,
        arnd@arndb.de, vvs@virtuozzo.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next 0/2] net: skb: introduce kfree_skb_with_reason()
Date:   Wed, 29 Dec 2021 22:32:03 +0800
Message-Id: <20211229143205.410731-1-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

In this series patch, the interface kfree_skb_with_reason() is
introduced(), which is used to collect skb drop reason, and pass
it to 'kfree_skb' tracepoint. Therefor, 'drop_monitor' or eBPF is
able to monitor abnormal skb with detail reason.

In fact, this series patches are out of the intelligence of David
and Steve, I'm just a truck man :/

Previous discussion is here:

https://lore.kernel.org/netdev/20211118105752.1d46e990@gandalf.local.home/
https://lore.kernel.org/netdev/67b36bd8-2477-88ac-83a0-35a1eeaf40c9@gmail.com/

In the first patch, kfree_skb_with_reason() is introduced and
the 'reason' field is added to 'kfree_skb' tracepoint. In the
second patch, 'kfree_skb()' in replaced with 'kfree_skb_with_reason()'
in tcp_v4_rcv().


Menglong Dong (2):
  net: skb: introduce kfree_skb_with_reason()
  net: skb: use kfree_skb_with_reason() in tcp_v4_rcv()

 include/linux/skbuff.h     | 16 ++++++++++++++++
 include/trace/events/skb.h | 39 +++++++++++++++++++++++++++++++-------
 net/core/dev.c             |  3 ++-
 net/core/drop_monitor.c    | 10 +++++++---
 net/core/skbuff.c          | 22 ++++++++++++++++++++-
 net/ipv4/tcp_ipv4.c        | 10 ++++++++--
 6 files changed, 86 insertions(+), 14 deletions(-)

-- 
2.27.0

