Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2AC334BEC5
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 22:21:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231476AbhC1UUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 16:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbhC1UUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 16:20:22 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 320A0C061756;
        Sun, 28 Mar 2021 13:20:19 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id i81so11233542oif.6;
        Sun, 28 Mar 2021 13:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Lfgq2FzXpwyYqVknIeRLqJvMxrXxduAoYW347IpXSzg=;
        b=Q2ot+RICAj43G8uIle0EV6jS9VTd0bt4Z62bGEOmq9gTcsz8N7hq4hj1tl13uIA2L2
         JyRGyul71++gtdzzLIehkVrx7QH+SzkhqH3yT+Me9HQJcRTN9uD/LGRNvR4PXRfrnSn+
         sa5vsKYLIzUVzpTZ+DKzcrNKFypjuSHhAIfR1hCXcxBXPRCi6GrHcbPmvc8zSe7qcYGo
         yFycu2oM4dx/X2NOCiovs2k43ocm5kMCcLOMbafRjCrZRXsk3uKsRXWIF+qWMKdFEzjJ
         gZFqmylfuRrmbYEbxmI0rys9X0IuY4RYMsElTKets/oRYQx0E0/mw7g10yoh8umZyOUa
         RHiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Lfgq2FzXpwyYqVknIeRLqJvMxrXxduAoYW347IpXSzg=;
        b=aIYDfzKoouglE3Rtk3+mQfQb0NrXdxls4CjW2Wq4NJxTu+B/ph6ZAvC9O5P5UNGo4H
         LU3QfDvgnxiWTcAOVBpZdszABWxSwFlsCel6+EG8RB0ppBEFlVngZat+qJRz51EbrNY5
         +tbxls+R5u1Net7Ooygd9dSEy+eE/iU3PKptVsegN+8jngc87Yuh2cTRApVJDVha+rLX
         yJs4+X0AGIE7XgsE4EtauO8H5xyjicPevzrK7+0U74u+QlJlA0xeDX9OXgEgD6EwRvY2
         j1xTUKT6N/ph4KY90P1m7+K1pzkxyIxkCODLmVmpr/SptSR6EfItoB07Wk6AgSAbbYTa
         v+tw==
X-Gm-Message-State: AOAM532MrZz8IrH/OnFOmYayZGPoOKKVxqea3b4lGw7sJ2YiMgHYzns4
        oraZM3Gkk9muveaM+24WdEN84nFim3L/cg==
X-Google-Smtp-Source: ABdhPJwLf5eqM5FIAz5sazLpIcFRM/P+2ZmXW2t/4diNEc3rhfGjBw4oid6JkHRAbHA1yuiSvmbTTQ==
X-Received: by 2002:a54:4e08:: with SMTP id a8mr16751069oiy.135.1616962818187;
        Sun, 28 Mar 2021 13:20:18 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:bca7:4b69:be8f:21bb])
        by smtp.gmail.com with ESMTPSA id v30sm3898240otb.23.2021.03.28.13.20.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Mar 2021 13:20:17 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>
Subject: [Patch bpf-next v7 00/13] sockmap: introduce BPF_SK_SKB_VERDICT and support UDP
Date:   Sun, 28 Mar 2021 13:20:00 -0700
Message-Id: <20210328202013.29223-1-xiyou.wangcong@gmail.com>
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

On the high level, ->read_sock() is required for each protocol to support
sockmap redirection, and in order to do sock proto update, a new ops
->psock_update_sk_prot() is introduced, which is also required. And the
BPF ->recvmsg() is also needed to replace the original ->recvmsg() to
retrieve skmsg. To make life easier, we have to get rid of lock_sock()
in sk_psock_handle_skb(), otherwise we would have to implement
->sendmsg_locked() on top of ->sendmsg(), which is ugly.

Please see each patch for more details.

To see the big picture, the original patchset is available here:
https://github.com/congwang/linux/tree/sockmap
this patchset is also available:
https://github.com/congwang/linux/tree/sockmap2

---
v7: use work_mutex to protect psock->work
    return err in udp_read_sock()
    add patch 6/13
    clean up test case

v6: get rid of sk_psock_zap_ingress()
    add rcu work patch

v5: use INDIRECT_CALL_2() for function pointers
    use ingress_lock to fix a race condition found by Jacub
    rename two helper functions

v4: get rid of lock_sock() in sk_psock_handle_skb()
    get rid of udp_sendmsg_locked()
    remove an empty line
    update cover letter

v3: export tcp/udp_update_proto()
    rename sk->sk_prot->psock_update_sk_prot()
    improve changelogs

v2: separate from the original large patchset
    rebase to the latest bpf-next
    split UDP test case
    move inet_csk_has_ulp() check to tcp_bpf.c
    clean up udp_read_sock()

Cong Wang (13):
  skmsg: lock ingress_skb when purging
  skmsg: introduce a spinlock to protect ingress_msg
  net: introduce skb_send_sock() for sock_map
  skmsg: avoid lock_sock() in sk_psock_backlog()
  skmsg: use rcu work for destroying psock
  skmsg: use GFP_KERNEL in sk_psock_create_ingress_msg()
  sock_map: introduce BPF_SK_SKB_VERDICT
  sock: introduce sk->sk_prot->psock_update_sk_prot()
  udp: implement ->read_sock() for sockmap
  skmsg: extract __tcp_bpf_recvmsg() and tcp_bpf_wait_data()
  udp: implement udp_bpf_recvmsg() for sockmap
  sock_map: update sock type checks for UDP
  selftests/bpf: add a test case for udp sockmap

 include/linux/skbuff.h                        |   1 +
 include/linux/skmsg.h                         |  77 ++++++--
 include/net/sock.h                            |   3 +
 include/net/tcp.h                             |   3 +-
 include/net/udp.h                             |   3 +
 include/uapi/linux/bpf.h                      |   1 +
 kernel/bpf/syscall.c                          |   1 +
 net/core/skbuff.c                             |  55 +++++-
 net/core/skmsg.c                              | 177 ++++++++++++++----
 net/core/sock_map.c                           |  53 +++---
 net/ipv4/af_inet.c                            |   1 +
 net/ipv4/tcp_bpf.c                            | 130 +++----------
 net/ipv4/tcp_ipv4.c                           |   3 +
 net/ipv4/udp.c                                |  38 ++++
 net/ipv4/udp_bpf.c                            |  79 +++++++-
 net/ipv6/af_inet6.c                           |   1 +
 net/ipv6/tcp_ipv6.c                           |   3 +
 net/ipv6/udp.c                                |   3 +
 net/tls/tls_sw.c                              |   4 +-
 tools/bpf/bpftool/common.c                    |   1 +
 tools/bpf/bpftool/prog.c                      |   1 +
 tools/include/uapi/linux/bpf.h                |   1 +
 .../selftests/bpf/prog_tests/sockmap_listen.c | 136 ++++++++++++++
 .../selftests/bpf/progs/test_sockmap_listen.c |  22 +++
 24 files changed, 601 insertions(+), 196 deletions(-)

-- 
2.25.1

