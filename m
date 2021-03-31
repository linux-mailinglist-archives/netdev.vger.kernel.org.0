Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C32C34F6B0
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 04:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233374AbhCaCdK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 22:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233393AbhCaCcr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 22:32:47 -0400
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E29EC061574;
        Tue, 30 Mar 2021 19:32:47 -0700 (PDT)
Received: by mail-oo1-xc29.google.com with SMTP id s1-20020a4ac1010000b02901cfd9170ce2so2367131oop.12;
        Tue, 30 Mar 2021 19:32:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MAiYUoSHASu1cIWXXI2lJLlJRc+xqN2+n1Mzd3grv9s=;
        b=U3uMIekt7a4nEuDqTc9clCQDRFyKZ3LLvRHEvBR/VEjWUNiADX0QwFPKOoQUbfZY/W
         mf8VVlaJyqu7ErglBaHPuwULsVEf0jWNleB9tO3l0wbe7rp37qZdf0Kj5+Fc/VdUtzEd
         iReQI2uJlmNNxv75o2K35Qw6v/sJVJvidv+GqF9pa0KjKlc45FKuqzQ8rWkxytX96TG4
         zPNlvL5wjEMEscWyoapAY64TpUo+7XXw8217LG5kg6w7V9sG+IOSnvsdw76+WIiOkx85
         Jn1QgIOoKnvMlrq2l0jeoRFgpAHLahdJP4vcsCtXVRoVPBhGauQnguSvCXuM87cUZGhQ
         Sqxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MAiYUoSHASu1cIWXXI2lJLlJRc+xqN2+n1Mzd3grv9s=;
        b=Zkl4V1/nTi1o+53pIzE9w4hFviZRU35rr7YvEW3cOawNKwOJUVvIw3+4A7Icyxn/Qs
         TjgXzZrVIeEfowAEb9nsBNdcx5s+RAMFFpg6kr8LiOGplaPuArLExx6MSByLcqOsGKgg
         I1cj0sAEHZ3eG6zbY99UYHU8cjzrp5sQD3S/dL6S9C8xkQWYYPVy4y6ZQDr/j2Ug0a1W
         D0Svua9GQz4QvxIC/PtmzmtmFGFhIx0ExKOf8lDl4BgiiT77lyoQhhy4O7IcAOoWqZpO
         0tkMCyHcmoIgRit4BaBILFMCVVWttjxCqsR7yhbxL/KEX6cXN8c3ZxIGjvAZDRuKppVT
         1KqQ==
X-Gm-Message-State: AOAM5301KedG3d/1UwXmb/dDbAz9IzgS5Jcg+xGmgj46RQ2fWUGZvWxG
        Pxg1KRhvfwjDOxZWz6AF0plrlowJUwz4SA==
X-Google-Smtp-Source: ABdhPJwRsd0guE3iUB8SwuJ+SSA+yu8qqr3jxyTxQDCPi3w4oQ2oWFXqKZDb5xBFVw/e9UBTfN3xDw==
X-Received: by 2002:a4a:d10f:: with SMTP id k15mr858072oor.82.1617157966739;
        Tue, 30 Mar 2021 19:32:46 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:a099:767b:2b62:48df])
        by smtp.gmail.com with ESMTPSA id 7sm188125ois.20.2021.03.30.19.32.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Mar 2021 19:32:46 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>
Subject: [Patch bpf-next v8 00/16] sockmap: introduce BPF_SK_SKB_VERDICT and support UDP
Date:   Tue, 30 Mar 2021 19:32:21 -0700
Message-Id: <20210331023237.41094-1-xiyou.wangcong@gmail.com>
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
v8: get rid of 'offset' in udp_read_sock()
    add checks for skb_verdict/stream_verdict conflict
    add two cleanup patches for sock_map_link()
    add a new test case

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

Cong Wang (16):
  skmsg: lock ingress_skb when purging
  skmsg: introduce a spinlock to protect ingress_msg
  net: introduce skb_send_sock() for sock_map
  skmsg: avoid lock_sock() in sk_psock_backlog()
  skmsg: use rcu work for destroying psock
  skmsg: use GFP_KERNEL in sk_psock_create_ingress_msg()
  sock_map: simplify sock_map_link() a bit
  sock_map: kill sock_map_link_no_progs()
  sock_map: introduce BPF_SK_SKB_VERDICT
  sock: introduce sk->sk_prot->psock_update_sk_prot()
  udp: implement ->read_sock() for sockmap
  skmsg: extract __tcp_bpf_recvmsg() and tcp_bpf_wait_data()
  udp: implement udp_bpf_recvmsg() for sockmap
  sock_map: update sock type checks for UDP
  selftests/bpf: add a test case for udp sockmap
  selftests/bpf: add a test case for loading BPF_SK_SKB_VERDICT

 include/linux/skbuff.h                        |   1 +
 include/linux/skmsg.h                         |  77 ++++++--
 include/net/sock.h                            |   3 +
 include/net/tcp.h                             |   3 +-
 include/net/udp.h                             |   3 +
 include/uapi/linux/bpf.h                      |   1 +
 kernel/bpf/syscall.c                          |   1 +
 net/core/skbuff.c                             |  55 +++++-
 net/core/skmsg.c                              | 177 ++++++++++++++----
 net/core/sock_map.c                           | 118 ++++++------
 net/ipv4/af_inet.c                            |   1 +
 net/ipv4/tcp_bpf.c                            | 130 +++----------
 net/ipv4/tcp_ipv4.c                           |   3 +
 net/ipv4/udp.c                                |  32 ++++
 net/ipv4/udp_bpf.c                            |  79 +++++++-
 net/ipv6/af_inet6.c                           |   1 +
 net/ipv6/tcp_ipv6.c                           |   3 +
 net/ipv6/udp.c                                |   3 +
 net/tls/tls_sw.c                              |   4 +-
 tools/bpf/bpftool/common.c                    |   1 +
 tools/bpf/bpftool/prog.c                      |   1 +
 tools/include/uapi/linux/bpf.h                |   1 +
 .../selftests/bpf/prog_tests/sockmap_basic.c  |  40 ++++
 .../selftests/bpf/prog_tests/sockmap_listen.c | 136 ++++++++++++++
 .../selftests/bpf/progs/test_sockmap_listen.c |  22 +++
 .../progs/test_sockmap_skb_verdict_attach.c   |  18 ++
 26 files changed, 677 insertions(+), 237 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_sockmap_skb_verdict_attach.c

-- 
2.25.1

