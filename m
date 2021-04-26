Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5878B36AAC7
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 04:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbhDZCux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 22:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231502AbhDZCux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 22:50:53 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87537C061574;
        Sun, 25 Apr 2021 19:50:12 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id 8so21507246qkv.8;
        Sun, 25 Apr 2021 19:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AJ3dF91pArmJ3E1d8CGtHfJCvWP+o57MUIRfsQ3HzRc=;
        b=KHjyum/ANu6+os6IkYv+fCho0hAaPbfHDgpjkCDbrrAAmNz0xAxLorTtmIGr8qRJgB
         X9sBgsCUk+zzur+vdn27jFxm7I5lytM+FhqSpEE6yJaMYJ6Sri6x8RlehIWLvMa3aide
         hytRbkwPM24X7nJtoxCFc7cyMh6KKANg3BHMVW0mU1kDfGo/oqfi4Xd4NddKptzWozt6
         G+TtaL3ZccnY4WmtxXMixxGZ/c4xCiwbvNYx3xMPCcdTtxO2swSbG0zVEKjU7ZM4r1Gb
         olLASJwvgojhgtAvFFpVTUeYICxgVgL7vkC9n/4w99P2ee0sxnF5JTCUAZnvRdRN4dTi
         0Lng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AJ3dF91pArmJ3E1d8CGtHfJCvWP+o57MUIRfsQ3HzRc=;
        b=aQptqIjPYvOb8P6hZZVlMD0BMHiJEgUytY5fPhOl9Nl5ww8koeykeOLPqXtsOtMbX+
         34ELvWDF3uxPgVIYGYlnrgkjIDL0oRUFb4B+T8gaIkoppIv3tVsIM8tgnRMFa8dzAeF8
         kVsSwT8y3p/Qmptpgjo22w9IbRkPqFMvzQnerNSwLawQtkOMTofZ5DgxbgiQqGYsgBO5
         XqDMOdf+brwhB0j5PQW6FjONs9EsxkyIheY3a3C1pg2VAzRIljUNkKBUuy4m3w5nNXix
         PZAsb5NRvWLRdokulJHH6653mSXR1hsXeEWb01C82iJ6/Du5xarsKVGAStjoNJnREc8i
         QtwA==
X-Gm-Message-State: AOAM533NNWMIgsvqxtggBF6d+LDIh3ZckCU2SxDuj23K0T1ZFRauIHYT
        oOTwRUVWvdY7qsTUT0Wfidc6UgNjxClcsg==
X-Google-Smtp-Source: ABdhPJybC1Lxz5To6LhGymSeCuFxqv/IhL/zzJyTq4P6g3dPUaNzzEtH6DLPzwCMTVJFj52lK2G6qg==
X-Received: by 2002:a37:7685:: with SMTP id r127mr14834999qkc.359.1619405411520;
        Sun, 25 Apr 2021 19:50:11 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:9050:63f8:875d:8edf])
        by smtp.gmail.com with ESMTPSA id e15sm9632969qkm.129.2021.04.25.19.50.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Apr 2021 19:50:11 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, jiang.wang@bytedance.com,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>
Subject: [Patch bpf-next v3 00/10] sockmap: add sockmap support to Unix datagram socket
Date:   Sun, 25 Apr 2021 19:49:51 -0700
Message-Id: <20210426025001.7899-1-xiyou.wangcong@gmail.com>
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
v3: fix Kconfig dependency
    make unix_read_sock() static
    fix a UAF in unix_release()
    add a missing header unix_bpf.c
    
v2: separate out from the original large patchset
    rebase to the latest bpf-next
    clean up unix_read_sock()
    export sock_map_close()
    factor out some helpers in selftests for code reuse

Cong Wang (10):
  sock_map: relax config dependency to CONFIG_NET
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
 include/linux/bpf.h                           |  38 +-
 include/net/af_unix.h                         |  13 +
 init/Kconfig                                  |   2 +-
 net/core/Makefile                             |   2 -
 net/core/sock_map.c                           |   9 +
 net/unix/Makefile                             |   1 +
 net/unix/af_unix.c                            |  83 +++-
 net/unix/unix_bpf.c                           |  96 +++++
 .../selftests/bpf/prog_tests/sockmap_listen.c | 386 ++++++++++++++----
 10 files changed, 528 insertions(+), 103 deletions(-)
 create mode 100644 net/unix/unix_bpf.c

-- 
2.25.1

