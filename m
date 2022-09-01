Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B00C5A9FB8
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 21:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233817AbiIATQG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 15:16:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233806AbiIATQE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 15:16:04 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FFD06FA2E
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 12:15:59 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id i1-20020a170902cf0100b001730caeec78so12211855plg.7
        for <netdev@vger.kernel.org>; Thu, 01 Sep 2022 12:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=MXJtNOBxN7ObTMTXcoi2Dvdqm4buArxE+p1YwI5SP88=;
        b=Uu86W21Hf1pPgtqtqJYj4eY0W17tv6bo+qdEYI2+NrtPkjPloPtuUhX1ZLGfMNt5Hk
         rwI81fCGmz502ljEzzSrJGiwbKObfe0CXsFf4K+MtC16AmeJcZU2vxd/flTQRfjKUOb4
         rioleX3fB86uctffU66o3ZttR20KmLAjRDMSaB9f/QQZ3eMYybg95Hwv8lOnA2njkrlQ
         6dZMJ3HHd/Ghp8T7SRj4l7yR+/YqgALiQQvF/KSM+W1Ks0W5vnZPM6XffT/NuGsBqk5k
         fhOi/vVzo0M95btYOoBIwBfqvA6PtEn6dbIqGNZGxDk5jB4W1Yb7uJEVMvYnZXAiJkSh
         vezA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=MXJtNOBxN7ObTMTXcoi2Dvdqm4buArxE+p1YwI5SP88=;
        b=Yfbae2HQQ5ZT4Vt0zJNrGFpVKDGX109pxfo/2gl/57uIK3qogRzfdwrsMOrGrlM2Iu
         molejm/fib55S3hfIW9YnC9C9SQBZguo93tP56WUMUgQs6TWUacPRqPAjpVF9J/AR+xb
         Bo9WjRYiLQdAGH9nzqmScdz0yRoW33X2u85JTisbf6Q6N3tdlLi4WoWDx94jSnUyf+/5
         qZj5RGE2ppkPknWcgSRdJ0tigpeaCWx8RcKBNmQvSte/1zv/p3mL2P0gUeeDsj3QP86G
         NQD+G7GYrQyVLqo3s9+KyQb3Y+XOmnMSdWQQLHyk2G+vm+9WQ0WOUdPDYoRpWgUHXDn3
         W+mg==
X-Gm-Message-State: ACgBeo1Ne3fM/p6P9JakYzP8q4090BpDrcYi0ubOr7DQTv7Y2j9UYAGw
        0Jlps2pDQhkoPHYE70NMqycbbUd3ZmLMDQ==
X-Google-Smtp-Source: AA6agR49C94amGl4RQdAlkgw5H7Z9ghZI3Rw5i1DOGrsrbpDnsnpeIHRYNC8MSKZveu24Ew53BCj+Z+EDCwROg==
X-Received: from zhuyifei-kvm.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2edc])
 (user=zhuyifei job=sendgmr) by 2002:a17:90b:278a:b0:1fd:c2bf:81f5 with SMTP
 id pw10-20020a17090b278a00b001fdc2bf81f5mr636149pjb.81.1662059758905; Thu, 01
 Sep 2022 12:15:58 -0700 (PDT)
Date:   Thu,  1 Sep 2022 19:15:08 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <cover.1662058674.git.zhuyifei@google.com>
Subject: [PATCH bpf-next 0/2] cgroup/connect{4,6} programs for unprivileged
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
        autolearn=unavailable autolearn_force=no version=3.4.6
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

Patch 1 adds the invocation of the hook. Patch 2 adds the tests.

YiFei Zhu (2):
  bpf: Invoke cgroup/connect{4,6} programs for unprivileged ICMP ping
  selftests/bpf: Ensure cgroup/connect{4,6} programs can bind unpriv
    ICMP ping

 net/ipv4/ping.c                               |  15 +
 net/ipv6/ping.c                               |  16 +
 .../selftests/bpf/prog_tests/connect_ping.c   | 318 ++++++++++++++++++
 .../selftests/bpf/progs/connect_ping.c        |  53 +++
 4 files changed, 402 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/connect_ping.c
 create mode 100644 tools/testing/selftests/bpf/progs/connect_ping.c

-- 
2.37.2.789.g6183377224-goog

