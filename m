Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BFC22F5819
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 04:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727918AbhANCOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 21:14:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729140AbhAMVeI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 16:34:08 -0500
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9BEBC061795
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 13:33:24 -0800 (PST)
Received: by mail-qk1-x749.google.com with SMTP id l138so2596116qke.4
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 13:33:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=K48oJlen0n6WIvLrA/Z3Ysoz2NBrGKhtUXgG1tZJl40=;
        b=P7sYvSDZa15h6GzbS5MaqnqdjnaPCA8EWHSxeYCCYOrYFWOZYp31TFzxFTJuCtVF2c
         qq8c3Iw5o+20qxU8dnALOA+jJDN1npKGmnWG1JfRqP1wE83NgCP6eRetlQT+6zP5d6kV
         0ilQMokBlwlhchJlUzsqJ2EqSvBkwIV39mUQ5UYZatmAunuxYYU/wUv0D1k7wVZvB+Sn
         hNHE52IJZFKIC+wFXG2SGgGrBKuDmKQFrz4XTWaebBVA7CCFXRgrWN28RuJc7GC7YIQ6
         GcW6CcW8UmVdD/n9ZxsewodXQafkicQkDYE5u8z8ta3pCqDqpKM2bRQMalTtSWA02Mwt
         pgoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=K48oJlen0n6WIvLrA/Z3Ysoz2NBrGKhtUXgG1tZJl40=;
        b=cqNvGnluMZhZOu08cXUVlLD4Jn1+mKirlhjlFZb3ZsGEWIiJ/1QQCpjnpPWW3u3xO9
         elDi4PnwTZqMdiS0rCyb5UPoO2yAIVwMQlHdeInI99u+KhP1bbRtOGRFiTRS9RTpWrUp
         4+43Y6oPcbdGHt2oa4nA94El86wNFEVcw+qlAjW5K6vTqygOqyjKIg+nNidUR2Tr+TR0
         yqrIpjzyYh/L/QjHGsPK6WopbvG1ISJ58tdFQ2UaLAPGUpO5vk71wgiPNOfS3W6Rpzbw
         tCJYpgxU3QfsNlAYv+g9jvj5dVaNEzD5OAzSYPudxdxkbSX/z7d3CBRY0jd1GOKd3rKE
         Nh7g==
X-Gm-Message-State: AOAM531YymVHi3bkXcbuAJYR+JAIHSDthc3qllEittUXPwhGryXXv4ih
        C/mJSLc44Y3OQvKklQFuBNbgynFkAn6gIuf3ZtPoRyc1a/FPua0DPCRI8IdCLT36LnSNlv8R1Lf
        I6Jna3Z3R8ERW0FvWPx6rTLkyme+6FeEfFrxv3mq9pSknBKJIipq/mQ==
X-Google-Smtp-Source: ABdhPJxWsIxDEWmcqe6jKX/XjKZ59+8qQ4jHSMNCvVb1cAQy4mRC56W5tPNxJb6py8c96u11zNCkoyY=
Sender: "sdf via sendgmr" <sdf@sdf2.svl.corp.google.com>
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a05:6214:10e7:: with SMTP id
 q7mr4486452qvt.28.1610573603623; Wed, 13 Jan 2021 13:33:23 -0800 (PST)
Date:   Wed, 13 Jan 2021 13:33:18 -0800
Message-Id: <20210113213321.2832906-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH bpf-next v8 0/3] bpf: misc performance improvements for cgroup hooks
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

First patch adds custom getsockopt for TCP_ZEROCOPY_RECEIVE
to remove kmalloc and lock_sock overhead from the dat path.

Second patch removes kzalloc/kfree from getsockopt for the common cases.

Third patch switches cgroup_bpf_enabled to be per-attach to
to add only overhead for the cgroup attach types used on the system.

No visible user-side changes.

v8:
- add bpi.h to tools/include/uapi in the same patch (Martin KaFai Lau)
- kmalloc instead of kzalloc when exporting buffer (Martin KaFai Lau)
- note that v8 depends on the commit 4be34f3d0731 ("bpf: Don't leak
  memory in bpf getsockopt when optlen == 0") from bpf tree

v7:
- add comment about buffer contents for retval != 0 (Martin KaFai Lau)
- export tcp.h into tools/include/uapi (Martin KaFai Lau)
- note that v7 depends on the commit 4be34f3d0731 ("bpf: Don't leak
  memory in bpf getsockopt when optlen == 0") from bpf tree

v6:
- avoid indirect cost for new bpf_bypass_getsockopt (Eric Dumazet)

v5:
- reorder patches to reduce the churn (Martin KaFai Lau)

v4:
- update performance numbers
- bypass_bpf_getsockopt (Martin KaFai Lau)

v3:
- remove extra newline, add comment about sizeof tcp_zerocopy_receive
  (Martin KaFai Lau)
- add another patch to remove lock_sock overhead from
  TCP_ZEROCOPY_RECEIVE; technically, this makes patch #1 obsolete,
  but I'd still prefer to keep it to help with other socket
  options

v2:
- perf numbers for getsockopt kmalloc reduction (Song Liu)
- (sk) in BPF_CGROUP_PRE_CONNECT_ENABLED (Song Liu)
- 128 -> 64 buffer size, BUILD_BUG_ON (Martin KaFai Lau)

Stanislav Fomichev (3):
  bpf: remove extra lock_sock for TCP_ZEROCOPY_RECEIVE
  bpf: try to avoid kzalloc in cgroup/{s,g}etsockopt
  bpf: split cgroup_bpf_enabled per attach type

 include/linux/bpf-cgroup.h                    |  63 ++--
 include/linux/filter.h                        |   5 +
 include/linux/indirect_call_wrapper.h         |   6 +
 include/net/sock.h                            |   2 +
 include/net/tcp.h                             |   1 +
 kernel/bpf/cgroup.c                           | 112 +++++-
 net/ipv4/af_inet.c                            |   9 +-
 net/ipv4/tcp.c                                |  14 +
 net/ipv4/tcp_ipv4.c                           |   1 +
 net/ipv4/udp.c                                |   7 +-
 net/ipv6/af_inet6.c                           |   9 +-
 net/ipv6/tcp_ipv6.c                           |   1 +
 net/ipv6/udp.c                                |   7 +-
 net/socket.c                                  |   3 +
 tools/include/uapi/linux/tcp.h                | 357 ++++++++++++++++++
 .../selftests/bpf/prog_tests/sockopt_sk.c     |  22 ++
 .../testing/selftests/bpf/progs/sockopt_sk.c  |  15 +
 17 files changed, 582 insertions(+), 52 deletions(-)
 create mode 100644 tools/include/uapi/linux/tcp.h

-- 
2.30.0.284.gd98b1dd5eaa7-goog

