Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8E1315D34
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 03:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235442AbhBJCZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 21:25:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234612AbhBJCWo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 21:22:44 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6F4DC061574;
        Tue,  9 Feb 2021 18:21:56 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id 18so405202oiz.7;
        Tue, 09 Feb 2021 18:21:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AADBsxCjQTEzuZlF5SRkW1qSAc0//NAD9pZiQfkqUg4=;
        b=SVUPCuc7R16vCK/wpC+Ftop0Is3tTWMa1PP8dHP5lDgYNSquR6Jf+7XSDOSfjgYFhW
         2dMuQJo3fUjg3Hd1NgA74geKZMi0HovVgkyh3KE/UEHhBckLePl8lJXF8cGGbHHVABtG
         i8XnmYsvtZ6DbysDyhaAVGq3sMm+8qU58KB5kZbeUsGXafpKeOIQLkhm3R3gYy9Q0K56
         TVjYnXKsAMAXg15qYFYdCjI/LarTRCD4Kqpo2S56pzIgFej95f5Z9Ngq6nolDYZUF1U3
         ZGgjwQMHh8gr6zMzE0EWnR3BADN9vwLwm5jpmUo2H9q+gy0vewUque0ryaau87qzTi11
         juxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AADBsxCjQTEzuZlF5SRkW1qSAc0//NAD9pZiQfkqUg4=;
        b=QeE2SAGg+nCCm8dbzBWYXIPiZY1GCYdoxsMm9KqqVLXm6gLRtO5WyNXBeqYTRhWJ12
         2FOiOjcdy/O3BjpPa/V1C96UAiSiiYwQmNM2bkmgN5CKXCUamdathD0ZoK26hBzk8+T2
         LcaomKsh7rI2tACrRmGcx3jxbNE3sbMRqKfAtdzrVG4G5GGbftIpTGXpVCqyNnzAiPFM
         d0481+zGsldiGHV2IzkuFxHXB26ncGgB/BsG1Vvbgu/iWtHSiYm3GqME9MEW9qIpx63w
         +bxt7bqDr7A02B8hp4YYUITBOig5L94ZQGCkWTBW4dYjncglESHNeht8aHtWsD1zP7/g
         o+Tw==
X-Gm-Message-State: AOAM533eyBvJuWkiIhOC6tl5tb9SLj/6ws924IVlaYdPYBn6Hu08rJNz
        BvogtvdDbAq67e4taCjncJ1rNzY0tN4g6w==
X-Google-Smtp-Source: ABdhPJxzyQfy0VzD8pOu3f9wcTueInn9qZ2HmQIR3SmzEdLAvs0eudDM8g3jutj44ZpfpXDRw1vAqQ==
X-Received: by 2002:a05:6808:1315:: with SMTP id y21mr585199oiv.112.1612923715907;
        Tue, 09 Feb 2021 18:21:55 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:58b0:eb39:33aa:5355])
        by smtp.gmail.com with ESMTPSA id z20sm101051oth.55.2021.02.09.18.21.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 18:21:55 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>
Subject: [Patch bpf-next v2 0/5] sock_map: clean up and refactor code for BPF_SK_SKB_VERDICT
Date:   Tue,  9 Feb 2021 18:21:31 -0800
Message-Id: <20210210022136.146528-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

This patchset is the first series of patches separated out from
the original large patchset, to make reviews easier. This patchset
does not add any new feature but merely cleans up the existing
sockmap and skmsg code and refactors it, to prepare for the patches
followed up. This passed all BPF selftests.

The original whole patchset is available on github:
https://github.com/congwang/linux/tree/sockmap

and this patchset is also available on github:
https://github.com/congwang/linux/tree/sockmap1

---
v2: split the original patchset
    compute data_end with bpf_convert_data_end_access()
    get rid of psock->bpf_running
    reduce the scope of CONFIG_BPF_STREAM_PARSER
    do not add CONFIG_BPF_SOCK_MAP

Cong Wang (5):
  bpf: clean up sockmap related Kconfigs
  skmsg: get rid of struct sk_psock_parser
  bpf: compute data_end dynamically with JIT code
  skmsg: use skb ext instead of TCP_SKB_CB
  sock_map: rename skb_parser and skb_verdict

 include/linux/bpf.h                           |  20 +-
 include/linux/bpf_types.h                     |   2 -
 include/linux/skbuff.h                        |   3 +
 include/linux/skmsg.h                         |  78 ++++++--
 include/net/tcp.h                             |  29 +--
 include/net/udp.h                             |   4 +-
 init/Kconfig                                  |   1 +
 net/Kconfig                                   |   7 +-
 net/core/Makefile                             |   2 +-
 net/core/filter.c                             |  46 +++--
 net/core/skbuff.c                             |   7 +
 net/core/skmsg.c                              | 187 +++++++++---------
 net/core/sock_map.c                           |  74 +++----
 net/ipv4/Makefile                             |   2 +-
 net/ipv4/tcp_bpf.c                            |   2 -
 .../selftests/bpf/prog_tests/sockmap_listen.c |   8 +-
 .../selftests/bpf/progs/test_sockmap_listen.c |   4 +-
 17 files changed, 252 insertions(+), 224 deletions(-)

-- 
2.25.1

