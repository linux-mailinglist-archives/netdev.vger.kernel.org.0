Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9D534449B8
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 21:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbhKCUub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 16:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbhKCUub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 16:50:31 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 999CCC061714;
        Wed,  3 Nov 2021 13:47:54 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id b203so952615iof.10;
        Wed, 03 Nov 2021 13:47:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s+D5J+j6it2JpPiaH3R8HMv4EBy4UoNJvK16ZPtx1Ek=;
        b=B+IHWJrq5yAOEwcYx/PMqkBtA4of7jWp5FVAGJXe90jxZwBROwKhuFM0MNZzYznL70
         4N58XcmeTr4UTPP3IhbptLSvJsC4MCuOGSV5TAC5NZkZ+SkeMBUHOCyMsNtBgfiCfUyL
         lshhoMOyHtGgYoYK4DgqWpSmbll7Ea3OkIJNdxQQkpNSuN6567PUEj/+6ikFSRBFbzQa
         bhNHD+KHqKQfx8EH3JQ0NySh04lIkobF8fLlZhtzEvnRRY8DxGFJstlJ+jJhEKIkzhsa
         rLGX5GjCfbQeqdcLK1iBtRluo679cAFD34Q80Pltg5vm8arHlXq1eYk3ny1M2XpODWul
         zRyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s+D5J+j6it2JpPiaH3R8HMv4EBy4UoNJvK16ZPtx1Ek=;
        b=Ey0Ni8OueR704NTwUQgYcv86Mi1ZmT3hk4LD6m61dig/dLpbcBjy9mYWf/X5GI9Fff
         PC4CL/b6z9gI5BSHL1+VsbKtL2LkLxp278zwOidlcebKUMeBI5DVqTSMYYcdhZNe75Yn
         K5oDmx1UcuCVCkT2Z0P3fdhjyt0FU1IH7JbbW/3uaKZX1qPyaazl5pSk9UnPArciq10m
         B5+miWUnGtkxwiD4gOmZPAaMSQR2crfWPCrUVEA9LYIpbvDimRkX0PCH4g36/pbOgTC8
         FjI9wUOA4fjSJNbVptreCgwHl4R1NlfFRmHCqO16F29UgjbaltIueVWO2LsYCmfAXPed
         Mi8w==
X-Gm-Message-State: AOAM532kRsNxXg52KiJRuqs0QYUWKnkJ7J1ZDjcHSkEwG4einUf3jLJ0
        bzpPTkqR4tEDHLdU9EFy7whOTrOOZKss7w==
X-Google-Smtp-Source: ABdhPJzhhciojUeY9B3Pef/8/xJYPNQbQB9l7hyZHKgzcFtRsXil1N0HcB0Kxgqq3JgxcW/ttztG1Q==
X-Received: by 2002:a02:270c:: with SMTP id g12mr590064jaa.75.1635972473739;
        Wed, 03 Nov 2021 13:47:53 -0700 (PDT)
Received: from john.lan ([172.243.151.11])
        by smtp.gmail.com with ESMTPSA id y11sm1507612ior.4.2021.11.03.13.47.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 13:47:53 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     daniel@iogearbox.net, joamaki@gmail.com, xiyou.wangcong@gmail.com,
        jakub@cloudflare.com, john.fastabend@gmail.com
Subject: [PATCH bpf v2 0/5] bpf, sockmap: fixes stress testing and regression
Date:   Wed,  3 Nov 2021 13:47:31 -0700
Message-Id: <20211103204736.248403-1-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Attached are 5 patches that fix issues we found by either stress testing
or updating our CI to LTS kernels.

Thanks to Jussi for all the hard work tracking down issues and getting
stress testing/CI running.

First patch was suggested by Jakub to ensure sockets in CLOSE state
were safe from helper side.

Next two patches are issues discovered by Jussi after writing a stess
testing tool.

The last two fix an issue noticed while reviewing patches and xlated
code paths also discovered by Jussi.

v2: Add an initial patch to make sockmap helpers safe with CLOSE
    sockets in sockmap
    Added Jussi's tested-by line he tested the original patch series.

John Fastabend (4):
  bpf, sockmap: Use stricter sk state checks in sk_lookup_assign
  bpf, sockmap: Remove unhash handler for BPF sockmap usage
  bpf, sockmap: Fix race in ingress receive verdict with redirect to
    self
  bpf: sockmap, strparser, and tls are reusing qdisc_skb_cb and
    colliding

Jussi Maki (1):
  bpf, sockmap: sk_skb data_end access incorrect when src_reg = dst_reg

 include/linux/skmsg.h     | 12 ++++++++
 include/net/strparser.h   | 20 +++++++++++-
 net/core/filter.c         | 64 ++++++++++++++++++++++++++++++++++-----
 net/core/sock_map.c       |  6 ----
 net/ipv4/tcp_bpf.c        | 48 ++++++++++++++++++++++++++++-
 net/strparser/strparser.c | 10 +-----
 6 files changed, 135 insertions(+), 25 deletions(-)

-- 
2.33.0

