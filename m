Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF38481A9E
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 09:03:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237259AbhL3ID3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 03:03:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231345AbhL3ID2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 03:03:28 -0500
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F147C061574;
        Thu, 30 Dec 2021 00:03:28 -0800 (PST)
Received: by mail-pj1-x1043.google.com with SMTP id a11-20020a17090a854b00b001b11aae38d6so22448456pjw.2;
        Thu, 30 Dec 2021 00:03:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Bw8QPyeMNO0bT9eJ6U67Ytz/lRIpuevXgnltLrWQ09A=;
        b=qJDEbmOdqd0Usp82bPsUMAjRiBYW1kS7js4TrkkWUqYEUE89Mn5syio4yqk3cS2cqY
         Nps7Z7ha5A5V0/bSMxpzHFGot1BSA0F5yQOlnFEzy16Klcl7LoC/TgX4Lc2GlKdQzAdb
         q3wgmpArR+KsSkBQE2DWjFcAq2aRt5ypLBJPa/VgGu8hMvmycnH4pxwbKQlMQc6VzwxN
         WThlqKDl6fmH719Z/lQls5ffvMHd5TqZmwfR1MiQEaNgMPhKI8POEkQp4GnewBAw/93R
         ZQzOfOoPdy80E7+Vhy7DlS4CFyAzQoLMbuTFmQTchbtGdvwdOvBDSAt5Gwy0j0fQAnMD
         /pNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Bw8QPyeMNO0bT9eJ6U67Ytz/lRIpuevXgnltLrWQ09A=;
        b=ia8F6KqLZM5vB3AdD/23hulSESArmstl/WTVGG6c4SxVV30dRxB4b/E26bwy0nbssW
         X8eno7ejY8UywkTcrDGGCF+2j7XH7TZyzuNi+MKP9+B7AcOHzZL5TqZXx2SuPYASt5VY
         WxURBjEuQ6x6RSGQJ3z5rIfVltSIDFUKEKMZaVNKy2JsRkGnxj1CHCUovp5zO90Pekfe
         17ncUbgbozH6HG0tMmXEfzRC8DCEMUYe3rfT0ykVXn8ufCpeQ8X1eVtmnGjxYfD/Y+GB
         rrJ59dEx7lfR3w49npAeAysj+bEYqOaJzXmp4938ZKHOgq2gedLkOcOQQM/V6sNnzi5T
         eojA==
X-Gm-Message-State: AOAM5317VIF8BTJ2LSVZ/Bd11pofrk0sVQMr6b3BI2+FUUa5nR1jbyHW
        w6PnpCDmtR1AIN1ctpvwnQI=
X-Google-Smtp-Source: ABdhPJzHWc1941Wuram8IQMOmxvPuxtOruQV3EE9d6RBVEi8+69k158wpZ97bUn+WpR1VFNxuJroIw==
X-Received: by 2002:a17:90b:88e:: with SMTP id bj14mr36598592pjb.183.1640851408069;
        Thu, 30 Dec 2021 00:03:28 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.9])
        by smtp.gmail.com with ESMTPSA id 13sm26606987pfm.161.2021.12.30.00.03.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Dec 2021 00:03:27 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     kuba@kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, Menglong Dong <imagedong@tencent.com>
Subject: [PATCH v2 net-next 0/2] net: bpf: handle return value of post_bind{4,6} and add selftests for it
Date:   Thu, 30 Dec 2021 16:03:03 +0800
Message-Id: <20211230080305.1068950-1-imagedong@tencent.com>
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

The second patch is the selftests for this modification.

Changes since v1:
- introduce 'put_port' field for 'struct proto'
- add selftests for it


Menglong Dong (2):
  net: bpf: handle return value of 
    BPF_CGROUP_RUN_PROG_INET{4,6}_POST_BIND()
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
 tools/testing/selftests/bpf/test_sock.c | 166 +++++++++++++++++++++---
 10 files changed, 157 insertions(+), 20 deletions(-)

-- 
2.27.0

