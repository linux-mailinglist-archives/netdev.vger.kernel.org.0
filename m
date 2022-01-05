Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7900C48536C
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 14:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240212AbiAENU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 08:20:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240097AbiAENUx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 08:20:53 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87680C061761;
        Wed,  5 Jan 2022 05:20:52 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id jw3so33853387pjb.4;
        Wed, 05 Jan 2022 05:20:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7Kq4c8juE/76qRYRMXs2lRmxlZAz+IUatIP4ilaj/U8=;
        b=FhEushG+NbzS34uQM16aiw4qNHSQsgJc+WpJovQnanI/MvACDqdr+BWjtvvppqjqe+
         kwgtqtF9BBpcNWbqqM9v5kYt0j17yWeG0FApC/jDwTiN9sMwAHSM4y0tRRPOQy37r1G+
         GgcmwRmPU8QXWVkAN7Zcfc5yIfoeKEqh8L3DUe5GtjAHp3q1g0H0mR2XokX5sM7HAcnZ
         p+iAXqhEehKEZiOfS3bPDkyPNjur9bq+5rGs2Cqqbu/b2llDvxnU0FaqruCs4SzQolOM
         CIB+raF4YvzVlW75MoTQWKbZB735wHcUpoazJKJQUM2dVvbASvkw286JOZ57LA1Mxfg1
         eMQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7Kq4c8juE/76qRYRMXs2lRmxlZAz+IUatIP4ilaj/U8=;
        b=JuPUI/0pMI29JI9NFdpn92fWPdcd5Gygxw3aN4k437rhjcZPAmx1+fCe0Oaze1JVaK
         R3K2Uxd3Jf0zR05Dk2kPjsl8K1jgP9wT/Ag+lCOTMZqqy1fTPDLSsUXMQb4Q0oT2HiuL
         UTh+uznesCV7DKJ8+zO6qJKxRNF+sRg1bPVTxYpJVwwkkTlkcZk+qsLE9eILelq+hhk4
         067kuUPhToLcqtqq1lqTWEvS38Y8ZpW45DRfyg6FeMwyShsHsLLdkmJjA1i/KpDXQKDL
         nrA0ffTJ10Mipx7y71Gnl41hUI3Ecd9K+tHfYOWIPFhnFDiAnqtFqW8B43DeMQOI6gC3
         frFA==
X-Gm-Message-State: AOAM533fEZrEp5cPETgZdy2HEjHzIyWpNDj4HpOUi1N9K1uV+99MOhn2
        evEhrdmd1RGZpzoBnSgg++o=
X-Google-Smtp-Source: ABdhPJwU8Ch1WwInyAZUimpDw3jwMVHk8mF/C0YBiVKcpXMPw5GRtTJnQofqROE+SKZktisEtbHajg==
X-Received: by 2002:a17:90a:fa6:: with SMTP id 35mr3984087pjz.165.1641388852020;
        Wed, 05 Jan 2022 05:20:52 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.9])
        by smtp.gmail.com with ESMTPSA id q17sm16227771pfj.119.2022.01.05.05.20.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 05:20:51 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     kuba@kernel.org, daniel@iogearbox.net
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, shuah@kernel.org, ast@kernel.org,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, bpf@vger.kernel.org,
        Menglong Dong <imagedong@tencent.com>
Subject: [PATCH v3 net-next 0/2] net: bpf: handle return value of post_bind{4,6} and add selftests for it
Date:   Wed,  5 Jan 2022 21:18:47 +0800
Message-Id: <20220105131849.2559506-1-imagedong@tencent.com>
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

Changes since v2:
- NULL check for sk->sk_prot->put_port

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

