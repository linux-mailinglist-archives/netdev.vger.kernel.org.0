Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26C96333549
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 06:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbhCJFdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 00:33:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbhCJFca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 00:32:30 -0500
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A60EC06174A;
        Tue,  9 Mar 2021 21:32:30 -0800 (PST)
Received: by mail-qk1-x72f.google.com with SMTP id f124so15694143qkj.5;
        Tue, 09 Mar 2021 21:32:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xKHJzdE/d0TZd1ph98DAIZmwTdGcHMNXPBg1VLM0FGU=;
        b=I1yfVZSzFZy3RYabvSmrrxtzfclQOjujn1sflSyjvS0NArJbwGHWQfd3ihLygc7EgG
         JtA1pxAqpUKJNrusOTyopM96yOuGqVyj5zuFPJcDUMP1Kbq3VgYustQcqu+ukV57zH3X
         MLIEqn1VQP/1hoJdHDI/8VmFdvS7QI7uG5oipAe2zfBADwgAgYmsleGARnCn20FvxaCd
         FeWVeXeODyAeJXEq9ZGH1pzM7X2w62AjXMeS6sR2EuS2DJsSPJU4qQA2l7dt1NfgyONU
         81Rvu/tM9FedgbGCpiWk5a8iuigv5ghI95UboUQJSteIFl9IuVd5l/vgSW5KtuHczh2E
         S9rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xKHJzdE/d0TZd1ph98DAIZmwTdGcHMNXPBg1VLM0FGU=;
        b=rDvtU2/Q+NC8m38J0Qe5SJwoPkCjVeTNp3G6wKnXJVr2IjTcA1ZiCyAW8h3VdyC1Y3
         b2UMWZJvK6RF8/XNPEvD+jKNowfntyTpStNOcdH+1INFAH79VfzpjSdjhtRd52qYHpCP
         y5TCBcsIbUwexLkVYoic/eveZ9N14SUdILPWkGkGRRvgZMCIEU9nAA9PklKsmbzpWeB1
         iW+q7bJ3lHVNE3LtIgRhJq33b98EryngliP3IpFXtv7J506zXkdbo67aNmX6vvs5T64u
         42yPFmduPTZVw6ZztAIxU6AGtxN+KfVQSqn/71QaVtL4frfcVXgE0Ea6WmTnpCSXx0aC
         Nqkg==
X-Gm-Message-State: AOAM53077emPqVD95mWzCucydZm3rUh3DDBRP/yFDCzn9fTqI+96YN4t
        6McN3O6Y26Fr+t+KqJLA7iL56kbe8OgqMQ==
X-Google-Smtp-Source: ABdhPJxWlPssB3m62dTJ9KjodTMIjsa2IDhA6MzMmUzsMiFKuYjaQsmzcyQfSXwzoWWOcOEbEBbxCA==
X-Received: by 2002:a05:620a:108f:: with SMTP id g15mr1178737qkk.298.1615354349056;
        Tue, 09 Mar 2021 21:32:29 -0800 (PST)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:91f3:e7ef:7f61:a131])
        by smtp.gmail.com with ESMTPSA id g21sm12118739qkk.72.2021.03.09.21.32.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 21:32:28 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>
Subject: [Patch bpf-next v4 00/11] sockmap: introduce BPF_SK_SKB_VERDICT and support UDP
Date:   Tue,  9 Mar 2021 21:32:11 -0800
Message-Id: <20210310053222.41371-1-xiyou.wangcong@gmail.com>
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
 include/linux/skmsg.h                         |  71 +++++++--
 include/net/sock.h                            |   3 +
 include/net/tcp.h                             |   3 +-
 include/net/udp.h                             |   3 +
 include/uapi/linux/bpf.h                      |   1 +
 kernel/bpf/syscall.c                          |   1 +
 net/core/skbuff.c                             |  52 ++++++-
 net/core/skmsg.c                              | 134 +++++++++++++++--
 net/core/sock_map.c                           |  53 ++++---
 net/ipv4/af_inet.c                            |   1 +
 net/ipv4/tcp_bpf.c                            | 130 +++-------------
 net/ipv4/tcp_ipv4.c                           |   3 +
 net/ipv4/udp.c                                |  38 +++++
 net/ipv4/udp_bpf.c                            |  79 +++++++++-
 net/ipv6/af_inet6.c                           |   1 +
 net/ipv6/tcp_ipv6.c                           |   3 +
 net/ipv6/udp.c                                |   3 +
 net/tls/tls_sw.c                              |   4 +-
 tools/bpf/bpftool/common.c                    |   1 +
 tools/bpf/bpftool/prog.c                      |   1 +
 tools/include/uapi/linux/bpf.h                |   1 +
 .../selftests/bpf/prog_tests/sockmap_listen.c | 140 ++++++++++++++++++
 .../selftests/bpf/progs/test_sockmap_listen.c |  22 +++
 24 files changed, 576 insertions(+), 173 deletions(-)

-- 
2.25.1

