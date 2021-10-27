Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 343F343D2B8
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 22:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237028AbhJ0UVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 16:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231551AbhJ0UVw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 16:21:52 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43798C061570
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 13:19:27 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id gn3so2988491pjb.0
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 13:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1EPIWJsHVsYcYSlPSbrXJW+AkNV8CZyPe+OUZ8rIdoI=;
        b=djVYOIdzEWyU1Ixp0wxpRPWVbQFSQrs42gUZJ4HMRyoLg+zDobzlc9ar8BqA/uUTB2
         ijdJlHKsg81RHh7UlbypMGVLC5KRl5Mmw6BdUq3+24W9zcdgLMuPBW25HkFOQzRTNUnP
         WHZxEdbvZ57CFdP7CP38KEYOq2jWxR/c7PZ7wCVXUa/wsXgb+OcwgJaC+hjyGEpxqDB5
         +fCBL4Ieg3iKKV6UQyYN4aYwswYD5bjFnmgEA5DAJVRSoj+RyokASiwxgPTb4NONrTFU
         epa7HJa7ICo2IGHZsiWNxVD0/GWFqisd3J42A5t4KIjSgBJv0DyS/L7vOyttNm5BxpoK
         PH2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1EPIWJsHVsYcYSlPSbrXJW+AkNV8CZyPe+OUZ8rIdoI=;
        b=kUq4yMYFL7IhetPlEC961VTEO/VLKtiRFy5uoc6mclr5VrRjcfI1zeAk3Ig+9EPNdv
         C+tbVhJggFVvkt1AT7K/1AAKytL2dcpdP0bedswQXYCixSl56+dkgBzMUpv/i3I9qBqz
         O6FFIuBGs4ASsx2zMbAfWUuAUiQsxeqkmjZ+qX9e9YH7BZe6HKE2wa4uZSs9o6nQg177
         TQC8kJJT+d1MLUAYJkvv7EXQQQdV+ppxWd5RwS7i8QZdCfMduXcwRTAqdY0H/RCj9S5I
         8EoC0UIlpaYjRNUMJI5W7sEQacA0ASZ/ZborGbwmo1K8CuEm9XAgtNHTzefSyb/seE0q
         Sp7g==
X-Gm-Message-State: AOAM530he3g1PyZTAIhse9pw9NzenuRCa3HA5eS5xiGKZwTVvsW9gdlJ
        9/eR9ZjPQmUBufjaWbBL7yM=
X-Google-Smtp-Source: ABdhPJwGK+0z0mqmSUhZJWAhQ8oYomiArQPhmBf+v2RR4fVzetHMPOtYvWSWgd3k8AzEE4fRtQ/TMg==
X-Received: by 2002:a17:90b:1e09:: with SMTP id pg9mr8255701pjb.59.1635365966888;
        Wed, 27 Oct 2021 13:19:26 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:19fb:5287:bbfe:fc2a])
        by smtp.gmail.com with ESMTPSA id fr12sm5338295pjb.36.2021.10.27.13.19.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 13:19:26 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 0/7] tcp: tx side cleanups
Date:   Wed, 27 Oct 2021 13:19:16 -0700
Message-Id: <20211027201923.4162520-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

We no longer need to set skb->reserved_tailroom because
TCP sendmsg() do not put payload in skb->head anymore.

Also do some cleanups around skb->ip_summed/csum,
and CP_SKB_CB(skb)->sacked for fresh skbs.

Eric Dumazet (7):
  tcp: remove dead code from tcp_sendmsg_locked()
  tcp: cleanup tcp_remove_empty_skb() use
  tcp: remove dead code from tcp_collapse_retrans()
  tcp: no longer set skb->reserved_tailroom
  tcp: factorize ip_summed setting
  tcp: do not clear skb->csum if already zero
  tcp: do not clear TCP_SKB_CB(skb)->sacked if already zero

 include/net/tcp.h     |  2 +-
 net/ipv4/tcp.c        | 29 +++++++----------------------
 net/ipv4/tcp_output.c | 22 +++-------------------
 net/ipv6/tcp_ipv6.c   |  1 -
 net/mptcp/protocol.c  |  7 +++----
 5 files changed, 14 insertions(+), 47 deletions(-)

-- 
2.33.0.1079.g6e70778dc9-goog

