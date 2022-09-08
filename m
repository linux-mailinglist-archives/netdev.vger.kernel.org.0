Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 212E35B2A04
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 01:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbiIHXQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 19:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbiIHXQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 19:16:19 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCDCFB9F83
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 16:16:18 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id g63-20020a636b42000000b004305794e112so9968815pgc.20
        for <netdev@vger.kernel.org>; Thu, 08 Sep 2022 16:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=iHS2kH9GIhQyTrzXAC4JM2mZSat2l8dW4Ph0P8ewe24=;
        b=NWec8YrX1deaWua+9TotWZsoY5U9On+hr9CKq6WdhiyPwiSZt9WJMljWXLaFoGjAcn
         5RxcGYRyWD8Qf3p5I+7tTfudE/KObEKYWRoBXaT7IdYXXFPKu9BLgT2Wp4rIyLyA5wet
         eP1embT41Xi7VLa5hRKprVWc/UoE7jDuAnd4TuppOYJaiBi5PgB0LsIoPLy1ovb4jmyS
         itCdoAnNDFchhgwAABtcrgRwrDWEkKUP0F/5Bc6CrHGJxB+MkkulbkIYmDMC63rDUqIj
         XhIUPxrqQ/lxrjFWB8acJz1jHDkZyMPVhGGcWX4u4q0kBEB1S1Z2AZfaIIK4pLFrlRtX
         gxmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=iHS2kH9GIhQyTrzXAC4JM2mZSat2l8dW4Ph0P8ewe24=;
        b=oSWrHTYf0px1A/BIw6TcoRHPq4f4cFryG7Btv/PpaQYUtLmFOQcIi7w0JA3UQUAYHH
         4ZT+q7QXKTougpxwfxSz3dRQorrsna4H9wyOTDDswBW74GV5lneL1R0qFB8ndpbojFGG
         BZB9t5jCasZV0elUHn7bPyNxTX6Cy1IT/t4zitDfXRELd3v9VSHQG0GdDFyD6yeuw9mQ
         CGnqYxavLZIms4BdYG6jXYIehWDx4Am1qeO973n0+nXfW5aEom4KhJo9aQQR0nTy/AKZ
         ASs5Fw/oBjaEoTATZbUG0afbsSDi/o39mtTprvVS6SYZuFAU3GUrGZ1RQMg6lBUmFVYT
         n7jw==
X-Gm-Message-State: ACgBeo3msfU85zeo3k9pRpM0K7tlkvRaeX0xzKKDkicmFvKRnEmF6H6r
        FlYwsX/uldPlmxejjYiI8Wq1Z0hlLRZ/oQ==
X-Google-Smtp-Source: AA6agR43ns+TDQgH9hXv6Z5piOKiw7Cq7kfd3C/yP+AnQsEj803mnGL9EUEuA3JCuNpwncMuVrGygXZ5SUNRFQ==
X-Received: from zhuyifei-kvm.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2edc])
 (user=zhuyifei job=sendgmr) by 2002:a17:903:41c3:b0:176:b990:6c28 with SMTP
 id u3-20020a17090341c300b00176b9906c28mr10816405ple.94.1662678978373; Thu, 08
 Sep 2022 16:16:18 -0700 (PDT)
Date:   Thu,  8 Sep 2022 23:16:12 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <cover.1662678623.git.zhuyifei@google.com>
Subject: [PATCH v3 bpf-next 0/3] cgroup/connect{4,6} programs for unprivileged
 ICMP ping
From:   YiFei Zhu <zhuyifei@google.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Usually when a TCP/UDP connection is initiated, we can bind the socket
to a specific IP attached to an interface in a cgroup/connect hook.
But for pings, this is impossible, as the hook is not being called.

This series adds the invocation for cgroup/connect{4,6} programs to
unprivileged ICMP ping (i.e. ping sockets created with SOCK_DGRAM
IPPROTO_ICMP(V6) as opposed to SOCK_RAW). This also adds a test to
verify that the hooks are being called and invoking bpf_bind() from
within the hook actually binds the socket.

Patch 1 adds the invocation of the hook.
Patch 2 deduplicates write_sysctl in BPF test_progs.
Patch 3 adds the tests for this hook.

v1 -> v2:
* Added static to bindaddr_v6 in prog_tests/connect_ping.c
* Deduplicated much of the test logic in prog_tests/connect_ping.c
* Deduplicated write_sysctl() to test_progs.c

v2 -> v3:
* Renamed variable "obj" to "skel" for the BPF skeleton object in
  prog_tests/connect_ping.c

YiFei Zhu (3):
  bpf: Invoke cgroup/connect{4,6} programs for unprivileged ICMP ping
  selftests/bpf: Deduplicate write_sysctl() to test_progs.c
  selftests/bpf: Ensure cgroup/connect{4,6} programs can bind unpriv
    ICMP ping

 net/ipv4/ping.c                               |  15 ++
 net/ipv6/ping.c                               |  16 ++
 .../bpf/prog_tests/btf_skc_cls_ingress.c      |  20 --
 .../selftests/bpf/prog_tests/connect_ping.c   | 177 ++++++++++++++++++
 .../bpf/prog_tests/tcp_hdr_options.c          |  20 --
 .../selftests/bpf/progs/connect_ping.c        |  53 ++++++
 tools/testing/selftests/bpf/test_progs.c      |  17 ++
 tools/testing/selftests/bpf/test_progs.h      |   1 +
 8 files changed, 279 insertions(+), 40 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/connect_ping.c
 create mode 100644 tools/testing/selftests/bpf/progs/connect_ping.c

-- 
2.37.2.789.g6183377224-goog

