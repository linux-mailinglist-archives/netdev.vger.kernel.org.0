Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D1A942EF94
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 13:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238424AbhJOL0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 07:26:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238345AbhJOL0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 07:26:11 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64050C061762
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 04:24:05 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id t2so25948118wrb.8
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 04:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Yl3ubTqqvSCORYpbSJLsDPywubOvwqa2slfNa+XI/Ic=;
        b=HAwEX30ItqPHF0CLjO4G4uqI0PJFCBhtto27dj3adN0Mr91SwRviFMt7EZnUzSE30y
         MPjHeGy4K3k7cjsFLJ+6TkXoXZdp+pIm3Gf/hKrIdvJdBXTL4K5V4LKvlFcSTbIzvutI
         4Hp7SaLplccH4azg8K64+c6iBjmfm3iE/Rwas=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Yl3ubTqqvSCORYpbSJLsDPywubOvwqa2slfNa+XI/Ic=;
        b=GW2SaMd2E0BrTER1xoTU7m89vVvfK0VR2eosYBajgUNgdS0W2n5MrAoyahlaGTCiYA
         3Hb1931EwOA79OnW7Pj0kseU4TPP/SjGcM1bFsrGt/dq7CBFTmpl42/2GszjSguOYts5
         D+q3b0UOQJqFsqwbGYFgNZiss0orCXg0BMGsefZ51icfqTdRFBBJe+RLIpE0ngrtyhro
         4cJGupTItBSVit0JSWs0y/f4rGUxJJCN1AlWraR9znELCwa7Q918gW9cbIH+T8LMP1f3
         wdlH0AAdBOxBePh8JOW2ECil5GZbfNXNfnX/yU5N7o3MM0Cmk88jwIlc9nfKuPmvMDR8
         GNSA==
X-Gm-Message-State: AOAM5327gS3dMksZLg9kawimSHEG6hGVDceK59BX5SVK9dijFoTDR5mQ
        kmqV6sAGn5fxL0qyuZ0V8U92Gw==
X-Google-Smtp-Source: ABdhPJymrFuVxfhlMW558tpTnPfW3992Omhj9KO1QcgbdBaXEB+hYb1EXxD0gLxBgbgnorYywzyRyQ==
X-Received: by 2002:a5d:5846:: with SMTP id i6mr13923484wrf.294.1634297043872;
        Fri, 15 Oct 2021 04:24:03 -0700 (PDT)
Received: from kharboze.dr-pashinator-m-d.gmail.com.beta.tailscale.net ([2a02:390:85ca:6:be5f:f4ff:fe85:e406])
        by smtp.gmail.com with ESMTPSA id o12sm4631223wrv.78.2021.10.15.04.24.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 04:24:03 -0700 (PDT)
From:   Mark Pashmfouroush <markpash@cloudflare.com>
To:     markpash@cloudflare.com
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Brendan Jackman <jackmanb@google.com>,
        Florent Revest <revest@chromium.org>,
        Joe Stringer <joe@cilium.io>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Luke Nelson <luke.r.nels@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: [PATCH bpf-next 0/2] Get ifindex in BPF_SK_LOOKUP prog type
Date:   Fri, 15 Oct 2021 12:23:28 +0100
Message-Id: <20211015112336.1973229-1-markpash@cloudflare.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BPF_SK_LOOKUP users may want to have access to the ifindex of the skb
which triggered the socket lookup. This may be useful for selectively
applying programmable socket lookup logic to packets that arrive on a
specific interface, or excluding packets from an interface.

Mark Pashmfouroush (2):
  bpf: Add ifindex to bpf_sk_lookup
  selftests/bpf: Add tests for accessing ifindex in bpf_sk_lookup

 include/linux/filter.h                        |  7 ++--
 include/uapi/linux/bpf.h                      |  1 +
 net/core/filter.c                             |  7 ++++
 net/ipv4/inet_hashtables.c                    |  8 ++---
 net/ipv4/udp.c                                |  8 ++---
 net/ipv6/inet6_hashtables.c                   |  8 ++---
 net/ipv6/udp.c                                |  8 ++---
 tools/include/uapi/linux/bpf.h                |  1 +
 .../selftests/bpf/prog_tests/sk_lookup.c      | 31 ++++++++++++++++++
 .../selftests/bpf/progs/test_sk_lookup.c      |  8 +++++
 .../selftests/bpf/verifier/ctx_sk_lookup.c    | 32 +++++++++++++++++++
 11 files changed, 101 insertions(+), 18 deletions(-)

-- 
2.31.1

