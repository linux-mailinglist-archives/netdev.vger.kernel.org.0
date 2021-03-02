Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2F032A2E3
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 15:59:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377865AbhCBIiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:38:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443985AbhCBCil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 21:38:41 -0500
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 309CAC06178A;
        Mon,  1 Mar 2021 18:37:54 -0800 (PST)
Received: by mail-oi1-x233.google.com with SMTP id i21so18170464oii.2;
        Mon, 01 Mar 2021 18:37:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=D4V4eLWu2UkQ+c7wqrKmtOTumsn7flUm0gCXzVVvLyk=;
        b=lDpD7anq3HjHNzZ1BFBpFFAwZ7BNj4l/GNrXGkFUnn7kmr3c1CRUFBE8Q4rOIgF0VO
         uNkoLVlc5gNXm7IdFZZbfCIZF6GDtotmGVXXt9Z4R0whkS9I+23gUgx129W8J1HoT1st
         BMySToEz2ATqNh6LJXLRHzTBknMELQcrj0yoItmXoZGDow2LBC1wKyigKrxJRpFFE/wc
         dcaEKsTmIE3RJgVNdGMwquAGDhV8Qz5ZfKK5KU2Bfx7AxGSOcPVrBssHplKRyFJoMRyd
         tNZQd1e9sxK9jBq8HUhhvpEmBUb05u6xzvsjc+qPmFfCZkJlObWdlstBNohxf0zXdgQa
         L5qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=D4V4eLWu2UkQ+c7wqrKmtOTumsn7flUm0gCXzVVvLyk=;
        b=XJduF2oCgbtjPmtQc2fSTpqOmBlf88SM2ZHqbkdeJUCH8DyWu3auuC/G4mMSohPhrB
         cALxTT3+/a0IKGR7UKUfg/i/Lz2V7bzwNHZSXjkTKU3A9FZbBtJUf8vHgeJk8geSjZFi
         fJRbmGNhQMiaBvhK9Cj6OLwhxYAkwTm5VtRZDI65D48VZjGAD0YJp5PoDgwZ4LDQBmLO
         1snKRCFwSNoL41INIT/d3FAAw9MeUjBYB+Gcr1L+xfz9Q5kNWZzgDh2NcS9b1EZrMUEU
         aM2SW1MIYCzHKPo7sAnYMnLSTQewzHcndUvyDE0GtabxCschOgXLUlv8QpBoVjG/lRqO
         HIvQ==
X-Gm-Message-State: AOAM5310p7pyje4OHA+tSzaDKpMSSc8bMaVpO+C7jKZ/dyPbjGfqxBwt
        M200pOxRdCZ0eaFsKGoXxiO4ld9lHS4qSQ==
X-Google-Smtp-Source: ABdhPJzxaB5/lQEkyWdgYRirD7N8j85V9D1j3n69sshCdmQ31r6q+EOzCaqGBVVvhCPGBMmJQBFCvw==
X-Received: by 2002:aca:4486:: with SMTP id r128mr1612055oia.171.1614652673103;
        Mon, 01 Mar 2021 18:37:53 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:1bb:8d29:39ef:5fe5])
        by smtp.gmail.com with ESMTPSA id a30sm100058oiy.42.2021.03.01.18.37.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 18:37:52 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>
Subject: [Patch bpf-next v2 0/9] sockmap: introduce BPF_SK_SKB_VERDICT and support UDP
Date:   Mon,  1 Mar 2021 18:37:34 -0800
Message-Id: <20210302023743.24123-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

We have thousands of services connected to a daemon on every host
via AF_UNIX dgram sockets, after they are moved into VM, we have to
add a proxy to forward these communications from VM to host, because
rewriting thousands of them is not practical. This proxy uses an
AF_UNIX socket connected to services and a UDP socket to connect to
the host. It is inefficient because data is copied between kernel
space and user space twice, and we can not use splice() which only
supports TCP. Therefore, we want to use sockmap to do the splicing
without going to user-space at all (after the initial setup).

Currently sockmap only fully supports TCP, UDP is partially supported
as it is only allowed to add into sockmap. This patchset, as the second
part of the original large patchset, extends sockmap with:
1) cross-protocol support with BPF_SK_SKB_VERDICT; 2) full UDP support.

On the high level, ->sendmsg_locked() and ->read_sock() are required
for each protocol to support sockmap redirection, and in order to do
sock proto update, a new ops ->update_proto() is introduced, which is
also required to implement. A BPF ->recvmsg() is also needed to replace
the original ->recvmsg() to retrieve skmsg. Please see each patch for
more details.

To see the big picture, the original patchset is available here:
https://github.com/congwang/linux/tree/sockmap
this patchset is also available:
https://github.com/congwang/linux/tree/sockmap2

---
v2: separate from the original large patchset
    rebase to the latest bpf-next
    split UDP test case
    move inet_csk_has_ulp() check to tcp_bpf.c
    clean up udp_read_sock()

Cong Wang (9):
  sock_map: introduce BPF_SK_SKB_VERDICT
  sock: introduce sk_prot->update_proto()
  udp: implement ->sendmsg_locked()
  udp: implement ->read_sock() for sockmap
  udp: add ->read_sock() and ->sendmsg_locked() to ipv6
  skmsg: extract __tcp_bpf_recvmsg() and tcp_bpf_wait_data()
  udp: implement udp_bpf_recvmsg() for sockmap
  sock_map: update sock type checks for UDP
  selftests/bpf: add a test case for udp sockmap

 include/linux/skmsg.h                         |  25 ++--
 include/net/ipv6.h                            |   1 +
 include/net/sock.h                            |   3 +
 include/net/tcp.h                             |   3 +-
 include/net/udp.h                             |   4 +
 include/uapi/linux/bpf.h                      |   1 +
 kernel/bpf/syscall.c                          |   1 +
 net/core/skmsg.c                              | 113 +++++++++++++-
 net/core/sock_map.c                           |  52 ++++---
 net/ipv4/af_inet.c                            |   2 +
 net/ipv4/tcp_bpf.c                            | 129 +++-------------
 net/ipv4/tcp_ipv4.c                           |   3 +
 net/ipv4/udp.c                                |  68 ++++++++-
 net/ipv4/udp_bpf.c                            |  78 +++++++++-
 net/ipv6/af_inet6.c                           |   2 +
 net/ipv6/tcp_ipv6.c                           |   3 +
 net/ipv6/udp.c                                |  30 +++-
 net/tls/tls_sw.c                              |   4 +-
 tools/bpf/bpftool/common.c                    |   1 +
 tools/bpf/bpftool/prog.c                      |   1 +
 tools/include/uapi/linux/bpf.h                |   1 +
 .../selftests/bpf/prog_tests/sockmap_listen.c | 140 ++++++++++++++++++
 .../selftests/bpf/progs/test_sockmap_listen.c |  22 +++
 23 files changed, 517 insertions(+), 170 deletions(-)

-- 
2.25.1

