Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA444486520
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 14:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239465AbiAFNUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 08:20:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231453AbiAFNUk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 08:20:40 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5237CC061245;
        Thu,  6 Jan 2022 05:20:40 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id t19so2502847pfg.9;
        Thu, 06 Jan 2022 05:20:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=63CBpxumFRhEVIAPbfpLgh370eooZ85aNh2ixBY2LbQ=;
        b=GCNOUXs/f/02VYiLHnUwu4VBqscL8MQyNmeEh0LB2ngtSLJTUm24Ffb20Fn6E6r0E5
         nN3uU0yvtfARlsAz/bQU6GD9X8Cr7FZzFZNzQ4+7mIYP24y6d+isTIvod8HMRnS79t2w
         xVGB2o/CPKCFxY7sk446rT+wWvWDHeT/fnhO0XlVHxFbAZv3vQiJdP5o3866YfEyejNz
         ANBj+XPbSJXLurY7TcLuXd7mI8ZgSTvYAx1NC8h2TfJemAH/lLCwW4j2Gk+4ni3yzkxk
         eKIbzCQJdF76bDIrEpqiTqZyDtNy0hKFDNkAW8VfldgYYAZfsRJ3DDmbMAHYuela0X5Q
         GwPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=63CBpxumFRhEVIAPbfpLgh370eooZ85aNh2ixBY2LbQ=;
        b=rGZmUVS3hv270SYDGa7YKnk4KVULfcVaK75R6GUEBSUQBguHY8B+gbJY4MuNNnLJks
         YAKscpXCF+1tKdRLrdtVyn8ujxdekg/7gbnPcHSB27O4TTRgD6aQmiasXKj2mgricoGu
         5/5F39/zwxZl1SXpLCrfXFrdoSqwDL0VRqs9ewRWtcWWNjIwGUWcZY21g9ZD3YZWRvYw
         ht/KTAAt8YQ+LvOM9gf+OhV2r4dAQmB2EazGOdC0zQsI4xb72G6lm1mdxXGbJLBTWYZ0
         2974397z0cwefSE1/sdfkdGgx9E5m6XN3lF4ddPoVUOhFgqnk7fbO7n15Wsfsupp4azL
         OmeA==
X-Gm-Message-State: AOAM533xmPX3XQehV7FAn3T4JHXMq4d5th/kZfubVQoB+82b7D9+F43V
        SSqIZdbYQQyjbn9Vp/iLUk8=
X-Google-Smtp-Source: ABdhPJwOUo4pcL7A2OXFJjQ8QWyFkutGi8QKRpQHq+/ZxXoKpMcSP2/auCVyD8YFtJ/i+ZBNcuxylw==
X-Received: by 2002:a63:3ece:: with SMTP id l197mr36367239pga.371.1641475239906;
        Thu, 06 Jan 2022 05:20:39 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.9])
        by smtp.gmail.com with ESMTPSA id c11sm2777998pfv.85.2022.01.06.05.20.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 05:20:39 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     kuba@kernel.org, edumazet@google.com
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        shuah@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, bpf@vger.kernel.org,
        Menglong Dong <imagedong@tencent.com>
Subject: [PATCH v5 net-next 0/3] net: bpf: handle return value of post_bind{4,6} and add selftests for it
Date:   Thu,  6 Jan 2022 21:20:19 +0800
Message-Id: <20220106132022.3470772-1-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

The return value of BPF_CGROUP_RUN_PROG_INET{4,6}_POST_BIND() in
__inet_bind() is not handled properly. While the return value
is non-zero, it will set inet_saddr and inet_rcv_saddr to 0 and
exit:
exit:

        err = BPF_CGROUP_RUN_PROG_INET4_POST_BIND(sk);
        if (err) {
                inet->inet_saddr = inet->inet_rcv_saddr = 0;
                goto out_release_sock;
        }

Let's take UDP for example and see what will happen. For UDP
socket, it will be added to 'udp_prot.h.udp_table->hash' and
'udp_prot.h.udp_table->hash2' after the sk->sk_prot->get_port()
called success. If 'inet->inet_rcv_saddr' is specified here,
then 'sk' will be in the 'hslot2' of 'hash2' that it don't belong
to (because inet_saddr is changed to 0), and UDP packet received
will not be passed to this sock. If 'inet->inet_rcv_saddr' is not
specified here, the sock will work fine, as it can receive packet
properly, which is wired, as the 'bind()' is already failed.

To undo the get_port() operation, introduce the 'put_port' field
for 'struct proto'. For TCP proto, it is inet_put_port(); For UDP
proto, it is udp_lib_unhash(); For icmp proto, it is
ping_unhash().

Therefore, after sys_bind() fail caused by
BPF_CGROUP_RUN_PROG_INET4_POST_BIND(), it will be unbinded, which
means that it can try to be binded to another port.

The second patch use C99 initializers in test_sock.c

The third patch is the selftests for this modification.

Changes since v4:
- use C99 initializers in test_sock.c before adding the test case

Changes since v3:
- add the third patch which use C99 initializers in test_sock.c

Changes since v2:
- NULL check for sk->sk_prot->put_port

Changes since v1:
- introduce 'put_port' field for 'struct proto'
- add selftests for it


Menglong Dong (3):
  net: bpf: handle return value of 
    BPF_CGROUP_RUN_PROG_INET{4,6}_POST_BIND()
  bpf: selftests: use C99 initializers in test_sock.c
  bpf: selftests: add bind retry for post_bind{4, 6}

 include/net/sock.h                      |   1 +
 net/ipv4/af_inet.c                      |   2 +
 net/ipv4/ping.c                         |   1 +
 net/ipv4/tcp_ipv4.c                     |   1 +
 net/ipv4/udp.c                          |   1 +
 net/ipv6/af_inet6.c                     |   2 +
 net/ipv6/ping.c                         |   1 +
 net/ipv6/tcp_ipv6.c                     |   1 +
 net/ipv6/udp.c                          |   1 +
 tools/testing/selftests/bpf/test_sock.c | 370 ++++++++++++++----------
 10 files changed, 233 insertions(+), 148 deletions(-)

-- 
2.27.0

