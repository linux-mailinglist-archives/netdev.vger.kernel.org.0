Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0605AF87E
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 01:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbiIFXtF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 19:49:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiIFXtE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 19:49:04 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0963091D10
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 16:49:04 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id l72-20020a63914b000000b00434ac6f8214so1638282pge.13
        for <netdev@vger.kernel.org>; Tue, 06 Sep 2022 16:49:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=5bv4tlC5QLxufffMe5LxcecHwglRquewEHZjwnhCi40=;
        b=ARC6kEwmFV+EVmxz/K1QsgDOhfAO56PVuFsLbonq6w7vwzkzXJ6sUMp8U1CULnhUFV
         bFew4idYujAzo6WmtSqvcQkigYQtYl+uzCGGimJvkYzuO22qpwjuSWM9fovtNXUZ/Ji6
         OzGLZ73S532q+txAYDglI53UQ1UuPFSnEHIlwmtjwapPOAwvRu/b1Vq11d0ur7nuJp8/
         nd6UZqiQV00gAPJK6CN+oydqkvrjuSrnSszxTeiJPjwBlbiah79as58ljOnJDd7i69rj
         B2fCB/ydi44gRkmiIbnCOtx1rZhgE7JvrM4vi30vrCMNQFUyiWi4Edu/6g14Z2ieJfpH
         1V6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=5bv4tlC5QLxufffMe5LxcecHwglRquewEHZjwnhCi40=;
        b=XvAWl+79QzD6rbQijGQ7PeVu0lLBD53KDJvVHCX39MgEHapy7CN/ttj5Ga7L2nXAEA
         oEOtfEUd0lMlnWNZDYFMo9ale1vhD2/rEB7P5nYMAEfdScrokfiLM5a9+z7hl9L8oGVD
         PbklDv3yz0eKe5abn1uWPEVwjNWGEe3+TQZUlJVlmEFgH0+JDWWdi6IRHD6xqpeQyS80
         mkMRc46Hiq9r7Fd6ZenkSoqmKxaUEyFq7qrgeb8o2UNQi2TNyXYK1wWkHdo20xPD82w3
         We/pvjwTg6CPQQcNz/Y3ZX8aNQ5GccB5AlXCp1Vd6UKXy5czawzBWNQf0aTJ9vptzGu0
         aYKA==
X-Gm-Message-State: ACgBeo1KiPKsyG4ivoT9Gg1E4JHD2/FUN9sw4UzGR8VZH/TAUoDSKBjQ
        CUCfzMistL/Sf9tNj3C6lZPay0U/G6XTWQ==
X-Google-Smtp-Source: AA6agR61jqjfrHNaym2iVmc07Ds4/liikxtI6c1fAuI3Hn9w2ViV0H4I0NvGk4xmjL58q3yYNwA17bvjfabKig==
X-Received: from zhuyifei-kvm.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2edc])
 (user=zhuyifei job=sendgmr) by 2002:a17:90b:10a:b0:200:2849:235f with SMTP id
 p10-20020a17090b010a00b002002849235fmr99549pjz.1.1662508143197; Tue, 06 Sep
 2022 16:49:03 -0700 (PDT)
Date:   Tue,  6 Sep 2022 23:48:45 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <cover.1662507638.git.zhuyifei@google.com>
Subject: [PATCH v2 bpf-next 0/3] cgroup/connect{4,6} programs for unprivileged
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

