Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A43730D26C
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 05:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232640AbhBCERo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 23:17:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbhBCERe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 23:17:34 -0500
Received: from mail-oo1-xc32.google.com (mail-oo1-xc32.google.com [IPv6:2607:f8b0:4864:20::c32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59B5DC061573;
        Tue,  2 Feb 2021 20:16:54 -0800 (PST)
Received: by mail-oo1-xc32.google.com with SMTP id u7so5723972ooq.0;
        Tue, 02 Feb 2021 20:16:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=P0WJE/Xng3z47I7XKy7SH+sVHTxrFTJNjgm9MGAH3oI=;
        b=DMKLXeFFEEzQuwAXmg5zel1W3vk6R3xkMaeqgj4mo/kswXwEjGCzxCZQIV+CRnk2qU
         92pCA5qZuZVwewuqQPT8bt83to5ldqaW97+g8mUe/SqtSEQy5f54vdq83GFM4TNvSjlj
         Yn4D6i1zEAoYcYNbVaY/pbMeyc3BZbkqBC9l+Ekfx0JZ3Tj3pSWTw8z6siZyOTrBB8CQ
         yMaoDaEzKi2QHXLyTuu3QKcqMpSHkkcJq8q8rNnDpcRvKo4oOjFWi2++BxN2lTl1WC+s
         aXTo73sF4p03LMNSwks9corFhvCmIaadSh4L1OcM/U64Yymg9eDOaImtV5LZW24xRjr+
         LJwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=P0WJE/Xng3z47I7XKy7SH+sVHTxrFTJNjgm9MGAH3oI=;
        b=oIVQ7jqWMyaGbp3BS230+9yd6sIKEUESed6lsVrZKY1utZrrd0AIed25Fp6IjvFaGV
         mT2DEkZZ4TtT8cSJ5IGJlvtDvVOnPYxZgK47cX5mul2AW8pTB6IhwQbcLGPw4mUHwoiJ
         G4MvCxlv6E+lc6qT8L8WnqlIYf5UKWH7Nz44FDVjJr4uQhhDwlcrFW6uPWgguEjn0ggh
         2Jc2wtnfVa2XSN2+UomQ88iQMjd6qn+/FKPLA6lI7CjixPkcr6TYOFlGdmh4M/Picok5
         Awe5pHzylJUBlng1GvWaJLtHt9ptvXbbK6M53r2pcxtsxRF4rSBmE1fAGr7oElK2QfAq
         wXtA==
X-Gm-Message-State: AOAM530ONdlzKF4NMhUWL4JDVUz1x5rC7PqpsG3SXvUVdmg7Zom2R+dD
        LNlj8AByLb7V8YHEh8QJNsQ4JpTCkkG9iw==
X-Google-Smtp-Source: ABdhPJz/P+JCElXV3OOAo714kLdmhiDqhdtFuuxmSiWMRopuNzCV3kuGGjTQSmujeEwBEhFlK/9P1g==
X-Received: by 2002:a4a:de94:: with SMTP id v20mr805375oou.90.1612325813512;
        Tue, 02 Feb 2021 20:16:53 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:90c4:ffea:6079:8a0c])
        by smtp.gmail.com with ESMTPSA id s10sm209978ool.35.2021.02.02.20.16.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 20:16:52 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>
Subject: [Patch bpf-next 00/19] sock_map: add non-TCP and cross-protocol support
Date:   Tue,  2 Feb 2021 20:16:17 -0800
Message-Id: <20210203041636.38555-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

Currently sockmap only fully supports TCP, UDP is partially supported
as it is only allowed to add into sockmap. This patch extends sockmap
with: 1) full UDP support; 2) full AF_UNIX dgram support; 3) cross
protocol support. Our goal is to allow socket splice between AF_UNIX
dgram and UDP.

On the high level, ->sendmsg_locked() and ->read_sock() are required
for each protocol to support sockmap redirection, and in order to do
sock proto update, a new ops ->update_proto() is introduced, which is
also required to implement. It is slightly harder for AF_UNIX, as it
does not have a full struct proto implementation and redirection.

In order to support cross protocol, we have to make skb independent
of protocols, which is extremely hard given how creatively UDP uses
dev_scratch. Fortunately, we can pass skmsg instead of skb when
redirecting to ingress, the only thing needs to add is a new
->recvmsg() to retrieve skmsg. On the egress side, a new skb is
allocated behind skb_send_sock_locked(), it comes for free.
Another big barrier is skb CB, which was hard-coded as TCP_CB(),
I switch it to skb ext to solve this problem. Please see patch 3 for
more details.

This patchset passed all tests, the existing ones and the new ones I
add within this patchset.

---

Cong Wang (19):
  bpf: rename BPF_STREAM_PARSER to BPF_SOCK_MAP
  skmsg: get rid of struct sk_psock_parser
  skmsg: use skb ext instead of TCP_SKB_CB
  sock_map: rename skb_parser and skb_verdict
  sock_map: introduce BPF_SK_SKB_VERDICT
  sock: introduce sk_prot->update_proto()
  udp: implement ->sendmsg_locked()
  udp: implement ->read_sock() for sockmap
  udp: add ->read_sock() and ->sendmsg_locked() to ipv6
  af_unix: implement ->sendmsg_locked for dgram socket
  af_unix: implement ->read_sock() for sockmap
  af_unix: implement ->update_proto()
  af_unix: set TCP_ESTABLISHED for datagram sockets too
  skmsg: extract __tcp_bpf_recvmsg() and tcp_bpf_wait_data()
  udp: implement udp_bpf_recvmsg() for sockmap
  af_unix: implement unix_dgram_bpf_recvmsg()
  sock_map: update sock type checks
  selftests/bpf: add test cases for unix and udp sockmap
  selftests/bpf: add test case for redirection between udp and unix

 MAINTAINERS                                   |   1 +
 include/linux/bpf.h                           |   4 +-
 include/linux/bpf_types.h                     |   2 +-
 include/linux/skbuff.h                        |   4 +
 include/linux/skmsg.h                         |  90 +++-
 include/net/af_unix.h                         |  13 +
 include/net/ipv6.h                            |   1 +
 include/net/sock.h                            |   3 +
 include/net/tcp.h                             |  33 +-
 include/net/udp.h                             |   9 +-
 include/uapi/linux/bpf.h                      |   1 +
 kernel/bpf/syscall.c                          |   1 +
 net/Kconfig                                   |  14 +-
 net/core/Makefile                             |   2 +-
 net/core/filter.c                             |   3 +-
 net/core/skbuff.c                             |   7 +
 net/core/skmsg.c                              | 223 +++++---
 net/core/sock_map.c                           | 128 ++---
 net/ipv4/Makefile                             |   2 +-
 net/ipv4/af_inet.c                            |   2 +
 net/ipv4/tcp_bpf.c                            | 130 +----
 net/ipv4/tcp_ipv4.c                           |   3 +
 net/ipv4/udp.c                                |  68 ++-
 net/ipv4/udp_bpf.c                            |  78 ++-
 net/ipv6/af_inet6.c                           |   2 +
 net/ipv6/tcp_ipv6.c                           |   3 +
 net/ipv6/udp.c                                |  30 +-
 net/tls/tls_sw.c                              |   4 +-
 net/unix/Makefile                             |   1 +
 net/unix/af_unix.c                            | 105 +++-
 net/unix/unix_bpf.c                           |  99 ++++
 tools/bpf/bpftool/common.c                    |   1 +
 tools/bpf/bpftool/prog.c                      |   1 +
 tools/include/uapi/linux/bpf.h                |   1 +
 .../selftests/bpf/prog_tests/sockmap_listen.c | 475 +++++++++++++++++-
 .../selftests/bpf/progs/test_sockmap_listen.c |  24 +-
 36 files changed, 1233 insertions(+), 335 deletions(-)
 create mode 100644 net/unix/unix_bpf.c

-- 
2.25.1

