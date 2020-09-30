Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6223B27E901
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 14:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729917AbgI3MzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 08:55:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725771AbgI3MzD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 08:55:03 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2144FC061755
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 05:55:03 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 7so1042984pgm.11
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 05:55:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mwENfe8pBHvuN6DKlqQ3MXTHMlyyCw/qFXgwvPaxZl8=;
        b=aPo0BfxNSgmcyMLEmX13njzVNQbfwKWdqrGDJ/98/+K9DC5jovb9f8PKFr/5zbyOoV
         nOFYW6GJacyuA0/n6gcj4bIw7pcBLds760rcgIyX2s/mTb6qupUfiP/V58q1zyS2hROD
         wwv79D00AmlLTtn1AZe8AaaKbp4FFcNjycnz3ApoO6TJM5DJimbeVFte2HcEOZBeNXpI
         TMSVqlHZd/2ylgi4G9vbl5fUnonM+hkpyc8J1YqQdKhwN9XoITMH9sZBvPSFHmusSw1j
         YTr+KuXfqYzJrW1/d0kfD5ol9tUsZCNwmcrl59fIaNwEVHncBp4+vjMjSCwBrT9vLKvC
         UY1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mwENfe8pBHvuN6DKlqQ3MXTHMlyyCw/qFXgwvPaxZl8=;
        b=FRsKEAxSqCjlkVFJtzvAWNBuuTH4D+RgPspevPK1NT5F2ZzcHKz6jLSdGuYbQH2ood
         RGXAYbfg9L50pgptMWVON+pn7mWyAxaYfMgfhb5I2p0/bRV9MwZPXBrAmuScl5KN+/AO
         L6UuzDCwI6bFZ9t/iQ/Xs4+YG0h1D9c2d+uta6Q1ypsoJvFpajiBsfyopgRguX0pYtf6
         akxRIb3F4UGcAbYg0U5qctHYSlMqU7IvN+DGMMZHWlL0jJC63fR4sYedO96g1s+YHvve
         5FLgBd2+HtIjGlZZlVkxnEexnSkw6sKFVU8IRH6nQgvcEtKRrupaBuUC3D5JtcwmJTug
         qFKQ==
X-Gm-Message-State: AOAM532J+XYNQ5Pkt+CpEGOMyNCZwnMHqlDhaLWipGOVz6KotDmdkqKT
        ImLEg/4NpEvvSNNcL5LLlUXWDSx8Ijk=
X-Google-Smtp-Source: ABdhPJxf8Q7DMEzI+z8wNEzq1Hk7lzc7kuR6nQW4M8RFrLIExzPzcN/pn7vJbE/vgb+3zdbR6vKKsQ==
X-Received: by 2002:a05:6a00:1695:b029:142:2501:34e4 with SMTP id k21-20020a056a001695b0290142250134e4mr2140376pfc.61.1601470502651;
        Wed, 30 Sep 2020 05:55:02 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7220:84ff:fe09:1424])
        by smtp.gmail.com with ESMTPSA id e21sm2235235pgi.91.2020.09.30.05.55.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2020 05:55:01 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 0/2] tcp: exponential backoff in tcp_send_ack()
Date:   Wed, 30 Sep 2020 05:54:55 -0700
Message-Id: <20200930125457.1579469-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.28.0.806.g8561365e88-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

We had outages caused by repeated skb allocation failures in tcp_send_ack()

It is time to add exponential backoff to reduce number of attempts.
Before doing so, first patch removes icsk_ack.blocked to make
room for a new field (icsk_ack.retry)

Eric Dumazet (2):
  inet: remove icsk_ack.blocked
  tcp: add exponential backoff in __tcp_send_ack()

 include/net/inet_connection_sock.h |  5 +++--
 net/dccp/timer.c                   |  1 -
 net/ipv4/inet_connection_sock.c    |  2 +-
 net/ipv4/tcp.c                     |  6 ++----
 net/ipv4/tcp_output.c              | 18 ++++++++++--------
 net/ipv4/tcp_timer.c               |  1 -
 6 files changed, 16 insertions(+), 17 deletions(-)

-- 
2.28.0.806.g8561365e88-goog

