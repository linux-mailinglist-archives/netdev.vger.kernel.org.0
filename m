Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40324377439
	for <lists+netdev@lfdr.de>; Sun,  9 May 2021 00:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbhEHWKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 18:10:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbhEHWKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 18:10:11 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D75A9C061574;
        Sat,  8 May 2021 15:09:07 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id v4so504655qtp.1;
        Sat, 08 May 2021 15:09:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZPbyAUxbIzN91k5DP/vjyxY8nxR3wFAzw6zVf4qaeG8=;
        b=pmaqPKjoGfT4GAFxP1zypJtE6Vqe2TcxFrfDzkaxy22Z/i2pbBfwizjLr8NyiAt6pR
         Q47rarkunI1pSQFLP1H8dFH9svUdlQx61ow4Kw9qiKUuCYi6CfKd1maCZcMExNWJQlwr
         s1lODpg4P++4bxVgDuekJ69yzsjzrQEaNrc/Xglq20hj0vpZeRTXc9QAZPQuyNfBcS12
         NkIx2Y3oMS0Kzs8mUxymi4o1uVPm/PtESPVU69ArG1qPZs5vPNZA258YmOPE72IN00cs
         qUr5eJxH1atS8ELgA0pRbGjT51EW6t7ZK/LH+e9Rd6m4Qj7jBlJ6H1DWvBwVInuEVzsD
         DrWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZPbyAUxbIzN91k5DP/vjyxY8nxR3wFAzw6zVf4qaeG8=;
        b=iE28kzXECmtkoxlPlRNi0g+2hg9EIWztR48LyIKMeaofYJFodq+bi9chuQINy2LFGd
         Gg9f10fJZNKVEuiiiL/y/GPpE3Jmqlek64llMgBpTtvcCZbTB2tcs7P1zJ/9avB1qMsB
         8CYEwgHYr5xwZQTzJ5kWiCtlH7XCHIDXldfacTPnjMdNsC0weoNM1tYlpTZWWIDZGlu0
         1dUyLiu589P+jU2WCwUJX9cuqFfJ6Ych37BS3nNNCSfatKBkvgZJK6h0HOPCsjwYtrZG
         yGW6U0dMhNA9fR6DQWpTS/lNz+AbTOqd802uc1Y9sybFA+PEe4TjObEl8wegVkJM8y/w
         lRXQ==
X-Gm-Message-State: AOAM531z5tGJ50M6GkUZgBdVoMf0gmh3s/X7E1JVFhbKD9Q9KGqVmY5+
        cRCornuaqiFyXzxSgPeWEtbC6UdMC8GIBA==
X-Google-Smtp-Source: ABdhPJwpgB7ca9ZuwzhCaQIehkYBlciFvdw+zxybPt+WNwa2nAUSp39ZRTjykQevFOgOdvXhiBYCxg==
X-Received: by 2002:ac8:7d95:: with SMTP id c21mr15242440qtd.11.1620511746386;
        Sat, 08 May 2021 15:09:06 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:65fe:be14:6eed:46f])
        by smtp.gmail.com with ESMTPSA id 189sm8080797qkd.51.2021.05.08.15.09.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 May 2021 15:09:06 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, jiang.wang@bytedance.com,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>
Subject: [Patch bpf-next v4 00/12] sockmap: add sockmap support for unix datagram socket
Date:   Sat,  8 May 2021 15:08:23 -0700
Message-Id: <20210508220835.53801-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

This is the last patchset of the original large patchset. In the
previous patchset, a new BPF sockmap program BPF_SK_SKB_VERDICT
was introduced and UDP began to support it too. In this patchset,
we add BPF_SK_SKB_VERDICT support to Unix datagram socket, so that
we can finally splice Unix datagram socket and UDP socket. Please
check each patch description for more details.

To see the big picture, the previous patchsets are available here:
https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/commit/?id=1e0ab70778bd86a90de438cc5e1535c115a7c396
https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/commit/?id=89d69c5d0fbcabd8656459bc8b1a476d6f1efee4

and this patchset is available here:
https://github.com/congwang/linux/tree/sockmap3

---
v4: fix af_unix disconnect case
    add unix_unhash()
    split out two small patches
    reduce u->iolock critical section
    remove an unused parameter of __unix_dgram_recvmsg()

v3: fix Kconfig dependency
    make unix_read_sock() static
    fix a UAF in unix_release()
    add a missing header unix_bpf.c

v2: separate out from the original large patchset
    rebase to the latest bpf-next
    clean up unix_read_sock()
    export sock_map_close()
    factor out some helpers in selftests for code reuse

Cong Wang (12):
  sock_map: relax config dependency to CONFIG_NET
  af_unix: implement ->read_sock() for sockmap
  af_unix: set TCP_ESTABLISHED for datagram sockets too
  sock_map: export symbols for af_unix module
  af_unix: prepare for sockmap support
  af_unix: implement ->psock_update_sk_prot()
  af_unix: implement unix_dgram_bpf_recvmsg()
  sock_map: update sock type checks for AF_UNIX
  selftests/bpf: factor out udp_socketpair()
  selftests/bpf: factor out add_to_sockmap()
  selftests/bpf: add a test case for unix sockmap
  selftests/bpf: add test cases for redirection between udp and unix

 MAINTAINERS                                   |   1 +
 include/linux/bpf.h                           |  38 +-
 include/net/af_unix.h                         |  13 +
 init/Kconfig                                  |   2 +-
 net/core/Makefile                             |   2 -
 net/core/sock_map.c                           |  10 +
 net/unix/Makefile                             |   1 +
 net/unix/af_unix.c                            |  90 +++-
 net/unix/unix_bpf.c                           |  95 +++++
 .../selftests/bpf/prog_tests/sockmap_listen.c | 386 ++++++++++++++----
 10 files changed, 535 insertions(+), 103 deletions(-)
 create mode 100644 net/unix/unix_bpf.c

-- 
2.25.1

