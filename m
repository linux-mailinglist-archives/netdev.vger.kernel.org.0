Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4ADA33E6B4
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 03:23:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbhCQCWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 22:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbhCQCWp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 22:22:45 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C8CCC06174A;
        Tue, 16 Mar 2021 19:22:45 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id v192so32718095oia.5;
        Tue, 16 Mar 2021 19:22:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mTmUCaOfbd5iJ7LaoWiivZKH0AsG4jw/h9U+kEn6lS0=;
        b=Hy7q0SUbLulXy+0Btv2fwXj75v3soadwbMIXAdarvgDA6e6SaUvUKMrKxse7wxTT4u
         qLfYyI1+GSZlKDd3EtaUkZ6aIsobFB+FTuaiJwCSrLZoVwY4i0P54cUDpo6Q483VoH6v
         TKuPAzgOwoHauAoIs+3lM9u8sKmtfimMuIkf3NGirLET/7wtTUkyd3Ss0+tLXjD8EvpK
         Z2LShQyHjfWHVJO+tgJ7JthEHp2G74ssil/TV6CuNFEj8xh6i/tHUWLHMqnvVR/AUktL
         WQt3ytQ3j5HjOeR67YHJw4e3iqmxypa1p/l2zbNCxRig9S0uqN/9On5TE0nWuzsNQJrq
         sQKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mTmUCaOfbd5iJ7LaoWiivZKH0AsG4jw/h9U+kEn6lS0=;
        b=NBZE5kKSkJdhDCxjnpvKaR0gRnTnsAddJTA2RoD4XyaQLeaGc6jZ5jJAUjiYdf+P0M
         8VGGUU2tBX6+vimmaiXR/8aEvA7VFNmIP5SV9NlyRl+Is+Re50A8zFwmPD6lR/W+D6gl
         /I6MxXFj31FjZXeYyK2eyxTCR5uDLHzzVDG8kwmBOuGfGDqTEcEAC8WVf90qZ+j7GM4H
         QOEKbPj1Fc4f4dEc096cpSrxbcw09ZjOjZ3C8k82JCW/29LHuh80vvEVYmOn18POW8oQ
         8XxpEEurG4WGpi4Vqoi1GG33Bhm+XfNscqgbMzmRKgj7/xwxPJ/U5bfpC7DMnxUZgjay
         fmKw==
X-Gm-Message-State: AOAM531XwaStnVL/x8hbxbtgvwSbdUs5INmMi+HBd5aqZEl20ev8Uzqd
        0592WlZudZIvYJtHLANnZnHAqt4Hy37pfw==
X-Google-Smtp-Source: ABdhPJzI4NCmFrqeeQPTytvBtR9jzk7ZB1Ju11eMVX0d+EDrSkUMbPS44ySe+q4mPHECl5RK6w6BJg==
X-Received: by 2002:aca:ac8d:: with SMTP id v135mr1201381oie.2.1615947764108;
        Tue, 16 Mar 2021 19:22:44 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:517b:5634:5d8e:ff09])
        by smtp.gmail.com with ESMTPSA id i3sm8037858oov.2.2021.03.16.19.22.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 19:22:43 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>
Subject: [Patch bpf-next v5 00/11] sockmap: introduce BPF_SK_SKB_VERDICT and support UDP
Date:   Tue, 16 Mar 2021 19:22:08 -0700
Message-Id: <20210317022219.24934-1-xiyou.wangcong@gmail.com>
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
v5: use INDIRECT_CALL_2() for function pointers
    use ingress_lock to close a race condition found by Jacub
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

Cong Wang (11):
  skmsg: lock ingress_skb when purging
  skmsg: introduce a spinlock to protect ingress_msg
  skmsg: introduce skb_send_sock() for sock_map
  skmsg: avoid lock_sock() in sk_psock_backlog()
  sock_map: introduce BPF_SK_SKB_VERDICT
  sock: introduce sk->sk_prot->psock_update_sk_prot()
  udp: implement ->read_sock() for sockmap
  skmsg: extract __tcp_bpf_recvmsg() and tcp_bpf_wait_data()
  udp: implement udp_bpf_recvmsg() for sockmap
  sock_map: update sock type checks for UDP
  selftests/bpf: add a test case for udp sockmap

 include/linux/skbuff.h                        |   1 +
 include/linux/skmsg.h                         |  71 ++++++--
 include/net/sock.h                            |   3 +
 include/net/tcp.h                             |   3 +-
 include/net/udp.h                             |   3 +
 include/uapi/linux/bpf.h                      |   1 +
 kernel/bpf/syscall.c                          |   1 +
 net/core/skbuff.c                             |  55 +++++-
 net/core/skmsg.c                              | 160 +++++++++++++++---
 net/core/sock_map.c                           |  53 +++---
 net/ipv4/af_inet.c                            |   1 +
 net/ipv4/tcp_bpf.c                            | 130 +++-----------
 net/ipv4/tcp_ipv4.c                           |   3 +
 net/ipv4/udp.c                                |  38 +++++
 net/ipv4/udp_bpf.c                            |  79 ++++++++-
 net/ipv6/af_inet6.c                           |   1 +
 net/ipv6/tcp_ipv6.c                           |   3 +
 net/ipv6/udp.c                                |   3 +
 net/tls/tls_sw.c                              |   4 +-
 tools/bpf/bpftool/common.c                    |   1 +
 tools/bpf/bpftool/prog.c                      |   1 +
 tools/include/uapi/linux/bpf.h                |   1 +
 .../selftests/bpf/prog_tests/sockmap_listen.c | 140 +++++++++++++++
 .../selftests/bpf/progs/test_sockmap_listen.c |  22 +++
 24 files changed, 600 insertions(+), 178 deletions(-)

-- 
2.25.1

