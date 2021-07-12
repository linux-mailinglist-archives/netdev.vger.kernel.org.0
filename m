Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53B2E3C6456
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 21:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236654AbhGLT6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 15:58:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbhGLT6v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 15:58:51 -0400
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 812E2C0613DD;
        Mon, 12 Jul 2021 12:56:01 -0700 (PDT)
Received: by mail-il1-x12a.google.com with SMTP id b6so11264754iln.12;
        Mon, 12 Jul 2021 12:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=T3+cJDZ/QK+VeA9MoKRarl2ConRFPklz/9pd8tsQRRE=;
        b=YKI581/Sri9grmO8FohZcyDtcHJu++SXEWo1BEvizzsVc2BgMF53Wo9pxi1w6auI23
         6t+4uZcy9f3m0D/NJOxWGc1VZ7ZpBFvsJWHs+iTRN0DUtMB1OVbTOHS455TToK3wCNEO
         3mT8OjIJRtgjdy4ibANy59v9H0Bgrs9BQ5Mq8sCiMMJYN1pBU9THVDpq1MB/1XVfUqu4
         +O+HYSlLjo12iw29Hjrf81qWtax5Qkk/ppjklvWI/df7mg+oVrZzFhSTAglkXDTjdF/Z
         gnmbFABIBNVNk4mbkyiejvBMOIUmgsfjC+uCFf4T8HJj4YxgvJARjOmi0pE95FKP3spI
         0uAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=T3+cJDZ/QK+VeA9MoKRarl2ConRFPklz/9pd8tsQRRE=;
        b=tdZs5WsdJy1Zr2pP7tAVI5jyNPrHBAalzum2++8eKs5SpF4RfvFn3OIL4baOKeWmJJ
         4B8WDNE2qgR0oaaPiHC3eShvFP8VTByZl8Jt7dq/qn0vwgBS5CZ/9PbEIMZYY/eQBLYr
         vcrrgzBbpVnZ1H2j12Gcut2di/oJqipJ/ixysisw1FtY4Xp1j1tdIdcelbuEqZ0E3usY
         yhQZLrHCQhhlq8MiE+knKDRttZJZwoBWkVHXtthgUOaNlvUgDZJBQ6hdh13vrOKGrzjI
         AvflLo+HkrFTUR+psgEQfeb2hQIZWJ7rxGHr4pi6iYyQ/KV71J/mPRGIOSE9/CFsSi7Z
         0VwA==
X-Gm-Message-State: AOAM532h0g+KK05PzC24YtfO1UbBJWjkWgPyVDq15o2c9oHYmitw1gHz
        Hz74sOf9+go9abqAU3SDIUk=
X-Google-Smtp-Source: ABdhPJxsbWYDX6MyIULe1UFWmhMDqOR4Xh3JKPRQIBBxrEfCw6MXu/xigrEz8TmCniSKgSMUmiZWpQ==
X-Received: by 2002:a92:d44b:: with SMTP id r11mr357012ilm.217.1626119761040;
        Mon, 12 Jul 2021 12:56:01 -0700 (PDT)
Received: from john-XPS-13-9370.lan ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id l5sm8389210ion.44.2021.07.12.12.55.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 12:56:00 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     ast@kernel.org, jakub@cloudflare.com, daniel@iogearbox.net,
        andriin@fb.com, xiyou.wangcong@gmail.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        john.fastabend@gmail.com
Subject: [PATCH bpf v4 0/2] bpf, sockmap: fix potential memory leak
Date:   Mon, 12 Jul 2021 12:55:44 -0700
Message-Id: <20210712195546.423990-1-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While investigating a memleak in sockmap I found these two issues. Patch
1 found doing code review, I wasn't able to get KASAN to trigger a
memleak here, but should be necessary. Patch 2 fixes proc stats so when
we use sockstats for debugging we get correct values.

The fix for observered memleak will come after these, but requires some
more discussion and potentially patch revert so I'll try to get the set
here going now.

v4: fix both users of sk_psock_skb_ingress_enqueue and then fix the
    inuse idx by moving init hook later after tcp/udp init calls.
v3: move kfree into same function as kalloc

John Fastabend (2):
  bpf, sockmap: fix potential memory leak on unlikely error case
  bpf, sockmap: sk_prot needs inuse_idx set for proc stats

 net/core/skmsg.c    | 16 +++++++++++-----
 net/core/sock_map.c | 11 ++++++++++-
 2 files changed, 21 insertions(+), 6 deletions(-)

-- 
2.25.1

