Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E70AD3453F3
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 01:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231234AbhCWAiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 20:38:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbhCWAiR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 20:38:17 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B09FDC061574;
        Mon, 22 Mar 2021 17:38:16 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id g15so12735351qkl.4;
        Mon, 22 Mar 2021 17:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j0l3UDDtGFHNkD6IYRkDjJ0krZ8dRBWc03AIt+HCrGg=;
        b=Z2UT0Nlb713SEneo0E52pmZ+CwiL+dgyhxEKvdnI1mvfPNEz1499mwWv9yz4APBCj/
         0daGzLxgdCGZV2XL2N8P+JK9j7ML1BhYLmrr2JQLm4S+3YzGeYkQmT8vX0jhwyGymvQZ
         63B24pOrxvN7CWeJz0pLiJAp74ToNhbipwaczOs929qyldLeYn1j7h/EE3dET1HcQ7e3
         1gqFrfmQaIzLZxuosIHOW7T/TEFmtcWDzgOyQw6l5nzPTHcd9ivB/Jt+04El/LXFBx1V
         VCcI/E9lOc4Z1ATqyykwJm2r9xUzxhKArWOiDMbGK8Qdinidy0liS+rfiRB1UhKqM4Ze
         Ez5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j0l3UDDtGFHNkD6IYRkDjJ0krZ8dRBWc03AIt+HCrGg=;
        b=kNyTlX7fc3fLih65grJ5y96JpAoqUZiSO8Xa+MNGCENu11oH8AQoChA+GFwboCVKaL
         sUuJZGneDKla//7sKIceKnKk1wrAYrA1WAi9gFc4hbfI9ghayfnonNLuK8JJP5OCTl2k
         eFUFZ1TLxDkvuqYwPPYKCBEikSsESXKr1meewR60BIZBp/Dyk++1l8nguBpZhF9tbGyP
         5FfpA8e2/VWWMTuFCpKNRLQQheS7ef0bvUJMop6kbrNa/bob6LPnoYTgJHbhN0HKBX+3
         g3x/U+ukKavZBcv/4+1DDV8qyVxI6IGvLTl8+uD15aeOm/Lejw4Zd9tFqqxDY79//Xdp
         5a8w==
X-Gm-Message-State: AOAM530XbeXiKaKH93J1RX8ONZAwvOXnvS5dqJC8vSgVu2Oowz7+CKMY
        uJ9b1gUaSD6ZV75OSKan/9lX/hVMImBgkQ==
X-Google-Smtp-Source: ABdhPJxiI6BquXuD+S9HX4QGMaRg7b3keb3+x+i2eyWzrswRsL/lsKFUiLH+VeTvu+5w82YFPLENgA==
X-Received: by 2002:a05:620a:22b5:: with SMTP id p21mr3026178qkh.196.1616459895730;
        Mon, 22 Mar 2021 17:38:15 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:fda6:6522:f108:7bd8])
        by smtp.gmail.com with ESMTPSA id 184sm12356403qki.97.2021.03.22.17.38.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 17:38:15 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>
Subject: [Patch bpf-next v6 00/12] sockmap: introduce BPF_SK_SKB_VERDICT and support UDP
Date:   Mon, 22 Mar 2021 17:37:56 -0700
Message-Id: <20210323003808.16074-1-xiyou.wangcong@gmail.com>
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

Cong Wang (12):
  skmsg: lock ingress_skb when purging
  skmsg: introduce a spinlock to protect ingress_msg
  skmsg: introduce skb_send_sock() for sock_map
  skmsg: avoid lock_sock() in sk_psock_backlog()
  skmsg: use rcu work for destroying psock
  sock_map: introduce BPF_SK_SKB_VERDICT
  sock: introduce sk->sk_prot->psock_update_sk_prot()
  udp: implement ->read_sock() for sockmap
  skmsg: extract __tcp_bpf_recvmsg() and tcp_bpf_wait_data()
  udp: implement udp_bpf_recvmsg() for sockmap
  sock_map: update sock type checks for UDP
  selftests/bpf: add a test case for udp sockmap

 include/linux/skbuff.h                        |   1 +
 include/linux/skmsg.h                         |  76 ++++++--
 include/net/sock.h                            |   3 +
 include/net/tcp.h                             |   3 +-
 include/net/udp.h                             |   3 +
 include/uapi/linux/bpf.h                      |   1 +
 kernel/bpf/syscall.c                          |   1 +
 net/core/skbuff.c                             |  55 +++++-
 net/core/skmsg.c                              | 176 ++++++++++++++----
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
 .../selftests/bpf/prog_tests/sockmap_listen.c | 140 ++++++++++++++
 .../selftests/bpf/progs/test_sockmap_listen.c |  22 +++
 24 files changed, 601 insertions(+), 198 deletions(-)

-- 
2.25.1

