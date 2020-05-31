Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63D2C1E963F
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 10:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbgEaI2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 04:28:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726803AbgEaI2y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 04:28:54 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50494C05BD43
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 01:28:52 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id z5so6300492ejb.3
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 01:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lyKdqtHAyK3H7PTAzCmZqa2UZG8wjtFVxrsw78yo4FE=;
        b=W6i083ZvXivc33WrNqzis7vToHx1IDoOP3F/tqd3FQlqYhBc/fQax4scp8XiB3BjW/
         mQX0EFWY1hZnLUwLerZbJ7vGk2lYZ9TCj/INprVNA5eRxpuBbKvw45/RrteWqps+YmTo
         aUatq4wCGZ67c2iXc+Nex2aMcJ3xJDprCj6JE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lyKdqtHAyK3H7PTAzCmZqa2UZG8wjtFVxrsw78yo4FE=;
        b=SqtYXmPfOl9IWoxT6EgBLjNudF2oxsNqRXDkw4g3PDNClkxRIdItW+SlBpeCXnNoVD
         SpXY41IMzdMGsUdnPum94DdgMG1yME02HsvXZOKvQJATOMdpWJ0FAxPzjuZIXSRQJaNG
         pLaJ5AO4OEdNB+FiJM56E3uDKOumLgxPVYbDqKCBu+wOv7Kozl8yEA6tzX5gVVmFAgx+
         cWXGd51RNPPTrEcjr8RAsfOiL8Q+pMXGRGEh4fH6pH8C5KxAjpwKD/rMjzohZMSdPA35
         mpk5U8MqqWIYzzq5p+NAgBYrRbIyi3vbFQ2OC/Kwnq81pCwhklIQil9yFdj3qxjkFrDv
         tPpQ==
X-Gm-Message-State: AOAM532PybAsnFY0snKc2gZmHIKuyLi7AvUSUMvUdfI84COx3Ydj8WQ/
        ub0DMV6m3ztJYOsK6rACAsPBIQ==
X-Google-Smtp-Source: ABdhPJxcj9HHxn/s7V+lPEQdHCUxWbLnOy0uXFxVt9NNOelMNnW6fSN90xhPd2bPgPIDBxdt8TFh6Q==
X-Received: by 2002:a17:906:2b14:: with SMTP id a20mr15607184ejg.387.1590913729182;
        Sun, 31 May 2020 01:28:49 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id dm1sm748689ejc.99.2020.05.31.01.28.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 01:28:48 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Stanislav Fomichev <sdf@google.com>
Subject: [PATCH bpf-next v2 00/12] Link-based program attachment to network namespaces
Date:   Sun, 31 May 2020 10:28:34 +0200
Message-Id: <20200531082846.2117903-1-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

One of the pieces of feedback from recent review of BPF hooks for socket
lookup [0] was that new program types should use bpf_link-based
attachment.

This series introduces new bpf_link type for attaching to network
namespace. All link operations are supported. Errors returned from ops
follow cgroup example. Patch 4 description goes into error semantics.

The major change in v2 is a switch away from RCU to mutex-only
synchronization. Andrii pointed out that it is not needed, and it makes
sense to keep locking straightforward.

Also, there were a couple of bugs in update_prog and fill_info initial
implementation, one picked up by kbuild. Those are now fixed. Tests have
been extended to cover them. Full changelog below.

Series is organized as so:

Patches 1-3 prepare a space in struct net to keep state for attached BPF
programs, and massage the code in flow_dissector to make it attach type
agnostic, to finally move it under kernel/bpf/.

Patch 4, the most important one, introduces new bpf_link link type for
attaching to network namespace.

Patch 5 unifies the update error (ENOLINK) between BPF cgroup and netns.

Patches 6-8 make libbpf and bpftool aware of the new link type.

Patches 9-12 Add and extend tests to check that link low- and high-level
API for operating on links to netns works as intended.

Thanks to Alexei, Andrii, Lorenz, Marek, and Stanislav for feedback.

-jkbs

[0] https://lore.kernel.org/bpf/20200511185218.1422406-1-jakub@cloudflare.com/

Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Cc: Marek Majkowski <marek@cloudflare.com>
Cc: Stanislav Fomichev <sdf@google.com>

v1 -> v2:

- Switch to mutex-only synchronization. Don't rely on RCU grace period
  guarantee when accessing struct net from link release / update /
  fill_info, and when accessing bpf_link from pernet pre_exit
  callback. (Andrii)
- Drop patch 1, no longer needed with mutex-only synchronization.
- Don't leak uninitialized variable contents from fill_info callback
  when link is in defunct state. (kbuild)
- Make fill_info treat the link as defunct (i.e. no attached netns) when
  struct net refcount is 0, but link has not been yet auto-detached.
- Add missing BPF_LINK_TYPE define in bpf_types.h for new link type.
- Fix link update_prog callback to update the prog that will run, and
  not just the link itself.
- Return EEXIST on prog attach when link already exists, and on link
  create when prog is already attached directly. (Andrii)
- Return EINVAL on prog detach when link is attached. (Andrii)
- Fold __netns_bpf_link_attach into its only caller. (Stanislav)
- Get rid of a wrapper around container_of() (Andrii)
- Use rcu_dereference_protected instead of rcu_access_pointer on
  update-side. (Stanislav)
- Make return-on-success from netns_bpf_link_create less
  confusing. (Andrii)
- Adapt bpf_link for cgroup to return ENOLINK when updating a defunct
  link. (Andrii, Alexei)
- Order new exported symbols in libbpf.map alphabetically (Andrii)
- Keep libbpf's "failed to attach link" warning message clear as to what
  we failed to attach to (cgroup vs netns). (Andrii)
- Extract helpers for printing link attach type. (bpftool, Andrii)
- Switch flow_dissector tests to BPF skeleton and extend them to
  exercise link-based flow dissector attachment. (Andrii)
- Harden flow dissector attachment tests with prog query checks after
  prog attach/detach, or link create/update/close.
- Extend flow dissector tests to cover fill_info for defunct links.
- Rebase onto recent bpf-next

Jakub Sitnicki (12):
  flow_dissector: Pull locking up from prog attach callback
  net: Introduce netns_bpf for BPF programs attached to netns
  flow_dissector: Move out netns_bpf prog callbacks
  bpf: Add link-based BPF program attachment to network namespace
  bpf, cgroup: Return ENOLINK for auto-detached links on update
  libbpf: Add support for bpf_link-based netns attachment
  bpftool: Extract helpers for showing link attach type
  bpftool: Support link show for netns-attached links
  selftests/bpf: Add tests for attaching bpf_link to netns
  selftests/bpf, flow_dissector: Close TAP device FD after the test
  selftests/bpf: Convert test_flow_dissector to use BPF skeleton
  selftests/bpf: Extend test_flow_dissector to cover link creation

 include/linux/bpf-netns.h                     |  64 ++
 include/linux/bpf_types.h                     |   3 +
 include/linux/skbuff.h                        |  26 -
 include/net/flow_dissector.h                  |   6 +
 include/net/net_namespace.h                   |   4 +-
 include/net/netns/bpf.h                       |  18 +
 include/uapi/linux/bpf.h                      |   5 +
 kernel/bpf/Makefile                           |   1 +
 kernel/bpf/cgroup.c                           |   2 +-
 kernel/bpf/net_namespace.c                    | 373 +++++++++++
 kernel/bpf/syscall.c                          |  10 +-
 net/core/flow_dissector.c                     | 124 +---
 tools/bpf/bpftool/link.c                      |  54 +-
 tools/include/uapi/linux/bpf.h                |   5 +
 tools/lib/bpf/libbpf.c                        |  23 +-
 tools/lib/bpf/libbpf.h                        |   2 +
 tools/lib/bpf/libbpf.map                      |   1 +
 .../selftests/bpf/prog_tests/flow_dissector.c | 166 +++--
 .../bpf/prog_tests/flow_dissector_reattach.c  | 588 ++++++++++++++++--
 tools/testing/selftests/bpf/progs/bpf_flow.c  |  20 +-
 20 files changed, 1248 insertions(+), 247 deletions(-)
 create mode 100644 include/linux/bpf-netns.h
 create mode 100644 include/net/netns/bpf.h
 create mode 100644 kernel/bpf/net_namespace.c

-- 
2.25.4

