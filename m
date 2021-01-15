Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 433352F80E4
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 17:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727283AbhAOQfq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 11:35:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726475AbhAOQfp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 11:35:45 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CBA1C0613C1
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 08:35:05 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id w4so6745928pgc.7
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 08:35:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=UVuejRKOnr+f9MGTQYmLtw9R9/mHub6yL4Mcq5LLFwk=;
        b=UqKMacVBM2r1wYgXrwukghNSggw+5IHEhqURSdS97UFCH/RQXb7TgAS8+kwOT7budF
         C3Dzi1fvCaFFoudekZMZqdnOvzb1WFrOcWmgLBcEDbWIJQUkCrPI8CmMpJeneIOOQqN7
         Mu5S8F7xh6Tf91cnyU9D6F2QVaK4+pW0Xyr7Vw6IiEYZ90sf7jE4VDo4GcTHIODIBour
         IpKXBOQV38I6p9udidguOI29URD+c1aN1gqCiV8xoirkMiol0D9945sGiFaaThX1RSRO
         maw8T9gT8SFFZBC5R78Vu03fpdnuL61SwcnPmMZnXCX09vyb5K7H2A1zOZxy34SSeGbH
         uIkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=UVuejRKOnr+f9MGTQYmLtw9R9/mHub6yL4Mcq5LLFwk=;
        b=d/WEZ1sbi8tB3tnXHrmPb1lnB8sOU1xdfsdfg2yH16ZtHWpbFlvcXtLyfg9GE7kR0l
         rl+piDukGpOckwG/nNNheHeknWI0pwL8tk6LDGBfz66lqAHQ7DJlOMAhSaRFwj8GZhSr
         +H2ARFGb1iBzWggHBGCq8k7Xg6FV8SF5mFqRsJt0eH4e7i9Qr63ttBqtaXzPct+J0Z9W
         eBT1lBwqIr/MuBBuqRg0/QcVZ6RDypwSv+3bGOFS7QVVv5tDlvTBkF6B1f4sws6bQ36w
         wgsGe7cnHb0BpecMwyXEdnNPdEaCkW5IbCt1fFsyJepS9EQDbuqwz9K7TAczL4FNHr4O
         c1Fw==
X-Gm-Message-State: AOAM532oVQM8A/acuhMWi02KCD2dzt+ySEniaVOLvEjkK0646QPzXnu+
        fi73c3XMc+ujkVPturwAXDh/YGfCOVBYrIvgxpTuiL0X4fBVJLrQMleE+txODKSm3fYnAlz/x6I
        /I+C6L1qoQOX6pzPrz00Nz33bYLFL7buONSrPsA17EC2+Psc4+jw8mQ==
X-Google-Smtp-Source: ABdhPJyHAmOqau2JsS5jcbLmv0USrjCeZ6eIIGEZHOH0keuscGLbN/z1oimNAYXREAcTmvI97oGl9iI=
Sender: "sdf via sendgmr" <sdf@sdf2.svl.corp.google.com>
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a17:902:b58f:b029:dc:8e14:95b4 with SMTP id
 a15-20020a170902b58fb02900dc8e1495b4mr13405232pls.24.1610728504672; Fri, 15
 Jan 2021 08:35:04 -0800 (PST)
Date:   Fri, 15 Jan 2021 08:34:58 -0800
Message-Id: <20210115163501.805133-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH bpf-next v9 0/3] bpf: misc performance improvements for cgroup hooks
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

v9:
- include linux/tcp.h instead of netinet/tcp.h in sockopt_sk.c
- note that v9 depends on the commit 4be34f3d0731 ("bpf: Don't leak
  memory in bpf getsockopt when optlen == 0") from bpf tree

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
 .../selftests/bpf/prog_tests/bpf_tcp_ca.c     |   1 +
 .../selftests/bpf/prog_tests/cls_redirect.c   |   1 +
 .../selftests/bpf/prog_tests/sockmap_basic.c  |   1 +
 .../selftests/bpf/prog_tests/sockopt_sk.c     |  28 ++
 .../testing/selftests/bpf/progs/sockopt_sk.c  |  23 +-
 tools/testing/selftests/bpf/test_progs.h      |   1 -
 21 files changed, 597 insertions(+), 55 deletions(-)
 create mode 100644 tools/include/uapi/linux/tcp.h

-- 
2.30.0.284.gd98b1dd5eaa7-goog

