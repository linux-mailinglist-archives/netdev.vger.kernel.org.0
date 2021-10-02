Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1E441F8BC
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 02:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbhJBAi6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 20:38:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230337AbhJBAi5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 20:38:57 -0400
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6C6CC061775;
        Fri,  1 Oct 2021 17:37:12 -0700 (PDT)
Received: by mail-oo1-xc34.google.com with SMTP id e16-20020a4ad250000000b002b5e1f1bc78so3383565oos.11;
        Fri, 01 Oct 2021 17:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=olY0NS2WMFbOWkMRcPrvr2O519Vsxaq4Tx4IXd3+A8U=;
        b=afHk/wn9qmae7oooWvf0HCXKjXwDjilOoyVh/Hw/NZDTFEPuVHqHarw7pVCgSlrLNB
         hrKwqj7o8IoMmcykxQeKxazw+AYkb8Uuuk3sRg6O3x0bZKpg+g1xSu+oVAJ1xg9T1nn6
         Ud0Bwkn2uxUs+YXv2+SvqhA5pnrsduyRQT9BNhIshZxdV4OFA58TBENtNQfP+aNOzGPV
         PLbNm8vwLowkINZileXkBj8NkkBLBldhG5E2u1Bo8Fd5bEQS47RVpODcDwDoqwNUo8eL
         TZlvZiIM8CjzSoTJi1IvCDwA+3A5uZdHGx3uehMhZQtNPdJa9z5lqSoExyP6m5njLtyw
         iarQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=olY0NS2WMFbOWkMRcPrvr2O519Vsxaq4Tx4IXd3+A8U=;
        b=GXKJLpAgX+wGkil0c3PBxJXsSYH60FF1jafAd+Qgn4oICudHY516U/n8q0O2hkNDmI
         NwPx0vr+GB0tnQgv2imNERmlwA6Hp/csQbkVdnartZH+x2+guw/tjDKwOwGdFFLG23zf
         Lo2MzWcy8RMXDL92AUQlUgUp/Eb7YgBO92SNG4eWWLxyXHJHODxU8fyiatLzUR6xltpp
         l39sGxu1M78lVC4HRVl3rMm2wKeYFtyANvrshFZB9MsVzqSanbdURcU6hiSMLkbHVtW/
         3glCSb7xCR1oxSnRgeJga1GlrUULIgyTeDaI8tU4btV1wiS+IjDPmFH5rabBAyeVYnpb
         bMpQ==
X-Gm-Message-State: AOAM532luVaAMhHgMGd6VXcuJJBJ77n3C3LCvFKl7tmQ25GXkUj2YdDK
        oEnjWC6F+NGyzb2jaJnMSwLVCNgUt98=
X-Google-Smtp-Source: ABdhPJz6b+ZDEIBScLB+myx3p0LjTRYSuJustAyHSxJkIjSobQRyXvxumqQAWDbI6vpmydGCUoHv+w==
X-Received: by 2002:a4a:942:: with SMTP id 63mr772044ooa.25.1633135031740;
        Fri, 01 Oct 2021 17:37:11 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:a62e:a53d:c4bc:b137])
        by smtp.gmail.com with ESMTPSA id p18sm1545017otk.7.2021.10.01.17.37.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 17:37:11 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>
Subject: [Patch bpf v3 0/4] sock_map: fix ->poll() and update selftests
Date:   Fri,  1 Oct 2021 17:37:02 -0700
Message-Id: <20211002003706.11237-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

This patchset fixes ->poll() for sockets in sockmap and updates
selftests accordingly with select(). Please check each patch
for more details.

Fixes: c50524ec4e3a ("Merge branch 'sockmap: add sockmap support for unix datagram socket'")
Fixes: 89d69c5d0fbc ("Merge branch 'sockmap: introduce BPF_SK_SKB_VERDICT and support UDP'")

---
v3: drop sk_psock_get_checked()
    reuse tcp_bpf_sock_is_readable()

v2: rename and reuse ->stream_memory_read()
    fix a compile error in sk_psock_get_checked()

Cong Wang (3):
  net: rename ->stream_memory_read to ->sock_is_readable
  skmsg: extract and reuse sk_msg_is_readable()
  net: implement ->sock_is_readable() for UDP and AF_UNIX

Yucong Sun (1):
  selftests/bpf: use recv_timeout() instead of retries

 include/linux/skmsg.h                         |  1 +
 include/net/sock.h                            |  8 +-
 include/net/tls.h                             |  2 +-
 net/core/skmsg.c                              | 14 ++++
 net/ipv4/tcp.c                                |  5 +-
 net/ipv4/tcp_bpf.c                            | 15 +---
 net/ipv4/udp.c                                |  2 +
 net/ipv4/udp_bpf.c                            |  1 +
 net/tls/tls_main.c                            |  4 +-
 net/tls/tls_sw.c                              |  2 +-
 net/unix/af_unix.c                            |  4 +
 net/unix/unix_bpf.c                           |  2 +
 .../selftests/bpf/prog_tests/sockmap_listen.c | 75 +++++--------------
 13 files changed, 57 insertions(+), 78 deletions(-)

-- 
2.30.2

