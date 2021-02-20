Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23B5C3203F8
	for <lists+netdev@lfdr.de>; Sat, 20 Feb 2021 06:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbhBTFaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Feb 2021 00:30:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbhBTFaK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Feb 2021 00:30:10 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C133C061574;
        Fri, 19 Feb 2021 21:29:30 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id b8so7130594oti.7;
        Fri, 19 Feb 2021 21:29:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qfVvtGmYkqRKXOHwQvpOxY7ojIiFVMhGm6NjJuT5yzE=;
        b=AN5lTixUfGd8/dpqc/qrFCPs4VJHO77P0GR29C+pexUspOVv47xMQUbmSONTZW9lvp
         3F6QJi8AuDEAxDQi/DEDj7C7W8vmsTvmpEMXYqHGtrL71/uJ2xqHNCbdHFiSege8/RWt
         fURLVR4K0jkvaKOWRij7A089CJjkCMKJ92DcTHD7j83GVMBYtSNUUew3/4Ue7aUtLCNJ
         RvARXJAUrYFQ7ENyEqMDmnZwVZus64D2ZKE+TJ8OvGm/iWMJw8+rByvV1OgCL6MxjObk
         HwJudH8Kj1FEvp+ja0/9OeJVBwxET6m0yl2ljb997InjlvKoBXvmQUPjsZMVeHT1kWvN
         scdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qfVvtGmYkqRKXOHwQvpOxY7ojIiFVMhGm6NjJuT5yzE=;
        b=BYlID8CNTj1pXoq59Dl5hIN2+MFS49ln+WMtLoJQpOZGBzdymHT/LK4fX/dhyv2Hn9
         lYYTA2OqGmkoRvuztT3vaNu0s04kmZcjGemk5EIuzHniQ4I3Poak/gWiUSUNBY8uDHgx
         LjNoU78B3jn6SEIplCf31OuzFKbdasDXR7go04YcwBObfWe+Ld3NsUE13DHUWK3g/WYS
         bGfGpRD5vtXzRJQlvAik89VPsreoftwr9jH+hoDhRq9sxDO1++5SDtLJ6ymGEqbT2DK0
         CgJsvmQdqLgHB5datxOGH26NUlILQuThIHnLR7Cvhb9dMvl7qWMlDBoHOSuNJMhtYumh
         uMuA==
X-Gm-Message-State: AOAM530qVqetvMqL4WqfrIMVJKVSWosawGA5d3spP4aqacQX2agbZ3lf
        GFg7mvNBrAFJMRgq7mg7wmF3hzkQDYV63g==
X-Google-Smtp-Source: ABdhPJwXMoW6ol08F0HFyWdfswyxqFXMXm32GKHQZ4tKWPgxyH6NeyoGpO78ivfK0Lrg0h2G2gdFiA==
X-Received: by 2002:a9d:6283:: with SMTP id x3mr9504337otk.136.1613798969446;
        Fri, 19 Feb 2021 21:29:29 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:1d72:18:7c76:92e4])
        by smtp.gmail.com with ESMTPSA id v20sm945955oie.2.2021.02.19.21.29.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 21:29:29 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>
Subject: [Patch bpf-next v6 0/8] sock_map: clean up and refactor code for BPF_SK_SKB_VERDICT
Date:   Fri, 19 Feb 2021 21:29:16 -0800
Message-Id: <20210220052924.106599-1-xiyou.wangcong@gmail.com>
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
v6: fix !CONFIG_INET case

v5: improve CONFIG_BPF_SYSCALL dependency
    add 3 trivial clean up patches

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

Cong Wang (8):
  bpf: clean up sockmap related Kconfigs
  skmsg: get rid of struct sk_psock_parser
  bpf: compute data_end dynamically with JIT code
  skmsg: move sk_redir from TCP_SKB_CB to skb
  sock_map: rename skb_parser and skb_verdict
  sock_map: make sock_map_prog_update() static
  skmsg: make __sk_psock_purge_ingress_msg() static
  skmsg: get rid of sk_psock_bpf_run()

 include/linux/bpf.h                           |  29 +--
 include/linux/bpf_types.h                     |   6 +-
 include/linux/skbuff.h                        |   3 +
 include/linux/skmsg.h                         |  82 +++++--
 include/net/tcp.h                             |  41 +---
 include/net/udp.h                             |   4 +-
 init/Kconfig                                  |   1 +
 net/Kconfig                                   |   6 +-
 net/core/Makefile                             |   6 +-
 net/core/filter.c                             |  48 ++--
 net/core/skmsg.c                              | 207 ++++++++----------
 net/core/sock_map.c                           |  77 +++----
 net/ipv4/Makefile                             |   2 +-
 net/ipv4/tcp_bpf.c                            |   4 +-
 .../selftests/bpf/prog_tests/sockmap_listen.c |   8 +-
 .../selftests/bpf/progs/test_sockmap_listen.c |   4 +-
 16 files changed, 270 insertions(+), 258 deletions(-)

-- 
2.25.1

