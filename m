Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1ECD32DF4D
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 02:57:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbhCEB5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 20:57:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbhCEB5G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 20:57:06 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 241C8C061574;
        Thu,  4 Mar 2021 17:57:06 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id t16so328595ott.3;
        Thu, 04 Mar 2021 17:57:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vYSdfJ/C4li2o4E+JLnjsIQ0l/gOSKQKbq78ghA839g=;
        b=KbzOjjFQIAjFLi1Q6NrL4J7UFI0doWmyauMSC52PgmPw8EZuFjMN7XSstJIhWHdBvu
         2ZUQhdmmPnDjEF9joUMR8vvrdFsLiK/dS/rj8VgJleb0DJh5Aad7QKdL1KN64DbYDTpx
         xbwFtI32UY0l7uXF9RlOAt4myHUr+3Fo/G/x9wCMpGkBzcBtW6iWflaaBDShDKGXA36O
         D2LMCmqoN0G3KMdJEUdGEB0dMJYDhED6j90fnpQF4qNupDOyNqX9ws4f8eKCRFNMASPG
         f6d1qnGBr3XQTQstnmVCY2jHKI8/1NyW0SwGk5HkNo/jsHEnnL+cnmJxWGFtIfjO+IKE
         lcEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vYSdfJ/C4li2o4E+JLnjsIQ0l/gOSKQKbq78ghA839g=;
        b=hkz1vytcPaWdV4GMhANJLMcyAJO3OtlT6P/WTBTl+M01UKp7w4XteVMIpqPdAizpV3
         D0zLmL+VrnkZ7Eu1FA1ThA9h5oJJU+uKZI/L9K/zItrue7ikpnECwA/zUkFR8nLruleD
         i4gX4gv/ZFgjtqx3Sazr3tbpv3b4ZWUw3kphyBhkJAFhgtry+8p3Cwm8xDHwkoWPII5t
         1fiwIcBYDhTS1mD+W+/jxJfq1dR0miDDP4rRfpUo1Hn7YDPU/qKHrq1CnMOjw3k5er19
         dF3kLl1pnDO5RqrMW3ICWRSEmKCOsXA9/andmPT50Q5U+HkBcFe/6ar+daSF9g+bAqmb
         xocg==
X-Gm-Message-State: AOAM530khLZwxIC3LdKFJQeptDXOXhf+qhajGQYhNBle/L4G7XLJUBqa
        0O99ZjDrO0QIt3Pob3oDtdk2w50POD3TJw==
X-Google-Smtp-Source: ABdhPJwgryOPJRVJjyMESUaZWocR4utgqqgKnxAsCIf0ohPHmvxZNEn4V8431wFhgJawwf3NjYgo3Q==
X-Received: by 2002:a9d:63d1:: with SMTP id e17mr6066907otl.183.1614909425306;
        Thu, 04 Mar 2021 17:57:05 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:95de:1d5:1b36:946a])
        by smtp.gmail.com with ESMTPSA id r3sm224126oif.5.2021.03.04.17.57.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 17:57:04 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>
Subject: [Patch bpf-next v3 0/9] sockmap: introduce BPF_SK_SKB_VERDICT and support UDP
Date:   Thu,  4 Mar 2021 17:56:46 -0800
Message-Id: <20210305015655.14249-1-xiyou.wangcong@gmail.com>
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
v3: export tcp/udp_update_proto()
    rename sk->sk_prot->psock_update_sk_prot()
    improve changelogs

v2: separate from the original large patchset
    rebase to the latest bpf-next
    split UDP test case
    move inet_csk_has_ulp() check to tcp_bpf.c
    clean up udp_read_sock()

Cong Wang (9):
  sock_map: introduce BPF_SK_SKB_VERDICT
  sock: introduce sk->sk_prot->psock_update_sk_prot()
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
 net/ipv4/tcp_bpf.c                            | 130 +++-------------
 net/ipv4/tcp_ipv4.c                           |   3 +
 net/ipv4/udp.c                                |  68 ++++++++-
 net/ipv4/udp_bpf.c                            |  79 +++++++++-
 net/ipv6/af_inet6.c                           |   2 +
 net/ipv6/tcp_ipv6.c                           |   3 +
 net/ipv6/udp.c                                |  30 +++-
 net/tls/tls_sw.c                              |   4 +-
 tools/bpf/bpftool/common.c                    |   1 +
 tools/bpf/bpftool/prog.c                      |   1 +
 tools/include/uapi/linux/bpf.h                |   1 +
 .../selftests/bpf/prog_tests/sockmap_listen.c | 140 ++++++++++++++++++
 .../selftests/bpf/progs/test_sockmap_listen.c |  22 +++
 23 files changed, 519 insertions(+), 170 deletions(-)

-- 
2.25.1

