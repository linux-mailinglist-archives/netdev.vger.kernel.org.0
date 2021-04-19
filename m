Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2456F36494A
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 19:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240302AbhDSR5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 13:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240241AbhDSR5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 13:57:11 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23EE6C061763;
        Mon, 19 Apr 2021 10:56:41 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id g16so10413481pfq.5;
        Mon, 19 Apr 2021 10:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=knBeKW9XWBCty1i1NBiydoVwzMYO0cMwhU2E7BjBd3Y=;
        b=NtRwajU/nc1Bhk2tkuti0JxoXybHen2vwlon0ngdGfd8xlQFnhkAFej5fwRnMl/CJ7
         QE3aCxwmFyT0KK9VPTE1VuZduzYSnE94EyYpi5Ktl6tQCGnCSmGuCg3hq1AWYSGE1mqm
         MIlQpTLT27bpGRppWOysx6gFTwPSXMDhtU6fX4+N6JKzuDS8O2s4JvvF2PsjOjBiARIg
         pRm9O0YnaLYTf9AAPTSHc1A8wE38vorLj14lS+ej6CwR4B9Dh0XkNYRtRNeSI6ReAmhn
         gJnecmxl/AYAzpM9i0gYg2DxooabXbA0D7+E3ux2+gG1xU8YnSsf7AZ3vDKNyrrQiFvh
         0DDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=knBeKW9XWBCty1i1NBiydoVwzMYO0cMwhU2E7BjBd3Y=;
        b=CSacg3GDMvQBF5ZCK+JSbNbclCOYRJaFRDq8yJuYlhM+voAaNxGwKUf2W098coL9y2
         PMyswDpubp3h4qpdttEET/noVCFLnudncskBn6cm3NOpeRnPziLYi+hZXSebm9U82FS1
         ypOTD3uFLe8eEXD7xhJqc/w7wRgioRnS08ZqynRu30adDlPgz/LzAamvGOH2eCrvEgiU
         UewadQx4xiTgHnvP9w7lOM+Z9grizBnq+4sK2bXQW7zmGqMwmleekOCavVxLhwcoCjE8
         wHE1+n/GpxRQbIzgtR/5lMvEtsCucjuVqPuPjqNhjineVVHSGEwOg0NtP1oPpoYewezF
         9hug==
X-Gm-Message-State: AOAM530HAB4p7Fa+92PLiKQP+gWvkN7GMjFtRnNX5gylurN0To6tyxSb
        XX22uOuLMDT5TiiwR+W6W0K1vTvrizCT7g==
X-Google-Smtp-Source: ABdhPJywY0KFRgCywLjxuoYABaWZHpxZ5bEMDPXGDtFTQ7thsbs/uoPORWCTgFVh9wJuoEvUOFuNSA==
X-Received: by 2002:a65:4382:: with SMTP id m2mr12999258pgp.354.1618854999748;
        Mon, 19 Apr 2021 10:56:39 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:e9c9:f92c:88fa:755e])
        by smtp.gmail.com with ESMTPSA id g2sm119660pju.18.2021.04.19.10.56.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 10:56:39 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, jiang.wang@bytedance.com,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>
Subject: [Patch bpf-next v2 0/9] sockmap: add sockmap support to Unix datagram socket
Date:   Mon, 19 Apr 2021 10:55:54 -0700
Message-Id: <20210419175603.19378-1-xiyou.wangcong@gmail.com>
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

To see the big picture, the previous patchsets are available:
https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/commit/?id=1e0ab70778bd86a90de438cc5e1535c115a7c396
https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/commit/?id=89d69c5d0fbcabd8656459bc8b1a476d6f1efee4
this patchset is also available:
https://github.com/congwang/linux/tree/sockmap3

---
v2: separate out from the original large patchset
    rebase to the latest bpf-next
    clean up unix_read_sock()
    export sock_map_close()
    factor out some helpers in selftests for code reuse

Cong Wang (9):
  af_unix: implement ->read_sock() for sockmap
  af_unix: implement ->psock_update_sk_prot()
  af_unix: set TCP_ESTABLISHED for datagram sockets too
  af_unix: implement unix_dgram_bpf_recvmsg()
  sock_map: update sock type checks for AF_UNIX
  selftests/bpf: factor out udp_socketpair()
  selftests/bpf: factor out add_to_sockmap()
  selftests/bpf: add a test case for unix sockmap
  selftests/bpf: add test cases for redirection between udp and unix

 MAINTAINERS                                   |   1 +
 include/net/af_unix.h                         |  13 +
 net/core/sock_map.c                           |   9 +
 net/unix/Makefile                             |   1 +
 net/unix/af_unix.c                            |  82 +++-
 net/unix/unix_bpf.c                           |  95 +++++
 .../selftests/bpf/prog_tests/sockmap_listen.c | 386 ++++++++++++++----
 7 files changed, 505 insertions(+), 82 deletions(-)
 create mode 100644 net/unix/unix_bpf.c

-- 
2.25.1

