Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 189EC31C691
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 07:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbhBPGnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 01:43:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbhBPGnf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 01:43:35 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8415DC061574;
        Mon, 15 Feb 2021 22:42:55 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id g84so10252912oib.0;
        Mon, 15 Feb 2021 22:42:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NzIeJj4KJ0DGj+LpI9oVKo67pkp2qeMdNYLyD2W4r7U=;
        b=qIOSPZSMOXTDjWP5W2TU8B0Tvn+vfrtkAhUrUQmrguCMV/wX0+Zop2HUghIqkKRS6f
         9jzz+3B9pt9LuwwAXXKCrN/Gg5hh5G1tMP2t3PAw2KZA1OU7MgSvMfgMws19V4+YRHqS
         6g8y3BkPPJQuZzaXkQgH94lcV+AySlBo5Ii8xPQO6Mn2aDBCgRfSh6qjTVm2GSisrx/u
         cwQjpzcn2Y5dMv6Ubrpuwd3ReBL5r87KfN7G2F61Gezy+T8aJWZ/GDub1ioeAGDLWAVm
         pFpp+apD/qWHMhC9TCNhPaMlHa1diMjQeR/POHeoD76QbF9P7NI8RXLPywyLCWX2t5MD
         91xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NzIeJj4KJ0DGj+LpI9oVKo67pkp2qeMdNYLyD2W4r7U=;
        b=bzTaF6ffNri4MNh5B4szXycw3vxIIg5zzOtfdL0FI/4VlNaw2z3JrSLD/xGV4kBuFq
         5TdAJDZcDOnPJu0sYRzXCuK0izPH9RnBRq67WYo6JTTiV6sLj86C+G+r2dpyUE9vSMi2
         jIQSffsJ0G2xPN7E2K2YvlTNO0JuyINtyiCItKNu7PnohnLGZnMnsXDIvxa8Hyn/nhno
         4vg2ISqfOpbx02HqY5ooeHbXsjYfxQjd4rycNlEgw2smhcY87G5ctjtASu0r6PIHeByR
         UMwr6qNRs+M5IcguwyBm3RNYWnr8HbByaMw361k8ZyHjqUa0seXGM6Bo7LEOi4ftbTrc
         N3PA==
X-Gm-Message-State: AOAM532cVC52uFTknO38nWBvHkyWG3sJ+4JFeFcSTDCQRNQpXE6ycbT7
        mDky1Yi4mhzDk7b541ikxR9L6haC3udkwg==
X-Google-Smtp-Source: ABdhPJykSsPAUZ8WjXSt9yKHjiPWSH/93//l68/9/T7p6rz8444HGzEkUOkq0oRCulXJC7s5kzwTSQ==
X-Received: by 2002:aca:58c5:: with SMTP id m188mr1650977oib.3.1613457774543;
        Mon, 15 Feb 2021 22:42:54 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:1d72:18:7c76:92e4])
        by smtp.gmail.com with ESMTPSA id i23sm4274467oik.10.2021.02.15.22.42.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 22:42:54 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>
Subject: [Patch bpf-next v4 0/5] sock_map: clean up and refactor code for BPF_SK_SKB_VERDICT
Date:   Mon, 15 Feb 2021 22:42:45 -0800
Message-Id: <20210216064250.38331-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

This patchset is the first series of patches separated out from
the original large patchset, to make reviews easier. This patchset
does not add any new feature or change any functionality but merely
cleans up the existing sockmap and skmsg code and refactors it, to
prepare for the patches followed up. This passed all BPF selftests.

To see the big picture, the original whole patchset is available
on github: https://github.com/congwang/linux/tree/sockmap

and this patchset is also available on github:
https://github.com/congwang/linux/tree/sockmap1

---
v4: reuse skb dst instead of skb ext
    fix another Kconfig error

v3: fix a few Kconfig compile errors
    remove an unused variable
    add a comment for bpf_convert_data_end_access()

v2: split the original patchset
    compute data_end with bpf_convert_data_end_access()
    get rid of psock->bpf_running
    reduce the scope of CONFIG_BPF_STREAM_PARSER
    do not add CONFIG_BPF_SOCK_MAP

Cong Wang (5):
  bpf: clean up sockmap related Kconfigs
  skmsg: get rid of struct sk_psock_parser
  bpf: compute data_end dynamically with JIT code
  skmsg: move sk_redir from TCP_SKB_CB to skb
  sock_map: rename skb_parser and skb_verdict

 include/linux/bpf.h                           |  20 +-
 include/linux/bpf_types.h                     |   2 -
 include/linux/skbuff.h                        |   3 +
 include/linux/skmsg.h                         |  80 ++++++--
 include/net/tcp.h                             |  38 +---
 include/net/udp.h                             |   4 +-
 init/Kconfig                                  |   1 +
 net/Kconfig                                   |   6 +-
 net/core/Makefile                             |   2 +-
 net/core/filter.c                             |  48 +++--
 net/core/skmsg.c                              | 191 +++++++++---------
 net/core/sock_map.c                           |  70 ++++---
 net/ipv4/Makefile                             |   2 +-
 net/ipv4/tcp_bpf.c                            |   4 +-
 net/ipv4/udp_bpf.c                            |   2 +
 .../selftests/bpf/prog_tests/sockmap_listen.c |   8 +-
 .../selftests/bpf/progs/test_sockmap_listen.c |   4 +-
 17 files changed, 253 insertions(+), 232 deletions(-)

-- 
2.25.1

