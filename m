Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C16F221DEFA
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 19:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729835AbgGMRq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 13:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729826AbgGMRq6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 13:46:58 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAD85C061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 10:46:57 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id x9so8970297ljc.5
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 10:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TRpJBauiW+Lt4nWLvereioGpgwaSO8ZbnUOAZytGcbo=;
        b=u/e2ysGa5urdQfsgrlFz+jnEvR3Z+zUzVN6LP1JPwGOCMqsTH0a7NGTR86e+zTigvb
         28Kfy4HpXkyMkdl49aqxxrFajySXmJ+/hCoyZ1csUIvP8Lxh+CWYo/rSKgNQZLrKPlSI
         F4KiI0RoGGcDfeufqCqEiXPAFqMYY4GpuzYdU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TRpJBauiW+Lt4nWLvereioGpgwaSO8ZbnUOAZytGcbo=;
        b=IofvGEpygu6tXH5yipkTfW1ufaBgNWQn5wFThyLEaAqLixzLCEse+rRhJ2+VOM26Y2
         sfo4MKOHnWjiXnqfcPn93Ui9UjkRwoxqxAOmWYsJvdTBeSL5Y8GmGpFy/KjFbfjp8zOX
         4oP3SzzloLu0ni5eC3MHQWqZc1VCz29fA/x9fECmI3z0+a38qzSXFjCJnMmojzxY0wDr
         wxVwW9Ero7Zlaj3QvujNmxowoRF4TCSKkq+bg2593wsg4/8RyNaonGPLhs/gLwmJvwuN
         ynAGgV3bRcH15bUiyUZ1EqAYfTQh8JFrJQhSV4QdMmgeAIpJW0qhj/jLHDc+YVYLUFL6
         O0SA==
X-Gm-Message-State: AOAM532Xpwi62r/35yUScmxKqjAEnW6SCYs+pvBze48eSyjw/hPlNa/D
        r9LQiZV5pj1SBCrnFE+Y0kYPyVVGQFCNZQ==
X-Google-Smtp-Source: ABdhPJwBJhRa5leVwFa0ntdQG5mbh/UHSOPD1I0hInWZVHJD8hzoM9Bpb/pC7nX1EicRmAvkrxnrzg==
X-Received: by 2002:a2e:9957:: with SMTP id r23mr410805ljj.127.1594662415903;
        Mon, 13 Jul 2020 10:46:55 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id v20sm4750040lfe.46.2020.07.13.10.46.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 10:46:55 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>
Subject: [PATCH bpf-next v4 00/16] Run a BPF program on socket lookup
Date:   Mon, 13 Jul 2020 19:46:38 +0200
Message-Id: <20200713174654.642628-1-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dependencies
============

This patch series depends on:

1. 'bpf-multi-prog-prep' series in 'bpf' [0]
   (commit 951f38cf0835 ("Merge branch 'bpf-multi-prog-prep'"))
2. "bpf: Shift and mask loads narrower than context field size" patch
   https://lore.kernel.org/bpf/20200710173123.427983-1-jakub@cloudflare.com/

Changelog
=========

v3 -> v4:
- Reduce BPF prog return codes to SK_DROP/SK_PASS (Lorenz)
- Default to drop on illegal return value from BPF prog (Lorenz)
- Extend bpf_sk_assign to accept NULL socket pointer.
- Switch to saner return values and add docs for new prog_array API (Andrii)
- Add support for narrow loads from BPF context fields (Yonghong)
- Fix broken build when IPv6 is compiled as a module (kernel test robot)
- Fix null/wild-ptr-deref on BPF context access
- Rebase to recent bpf-next (eef8a42d6ce0)
- Other minor changes called out in per-patch changelogs,
  see patches 1-2, 4, 6, 8, 10-12, 14, 16

v2 -> v3:
- Switch to link-based program attachment
- Support for multi-prog attachment
- Ability to skip reuseport socket selection
- Code on RX path is guarded by a static key
- struct in6_addr's are no longer copied into BPF prog context
- BPF prog context is initialized as late as possible
- Changes called out in patches 1-2, 4, 6, 8, 10-14, 16
- Patches dropped:
  01/17 flow_dissector: Extract attach/detach/query helpers
  03/17 inet: Store layer 4 protocol in inet_hashinfo
  08/17 udp: Store layer 4 protocol in udp_table

v1 -> v2:
- Changes called out in patches 2, 13-15, 17
- Rebase to recent bpf-next (b4563facdcae)

RFCv2 -> v1:

- Switch to fetching a socket from a map and selecting a socket with
  bpf_sk_assign, instead of having a dedicated helper that does both.
- Run reuseport logic on sockets selected by BPF sk_lookup.
- Allow BPF sk_lookup to fail the lookup with no match.
- Go back to having just 2 hash table lookups in UDP.

RFCv1 -> RFCv2:

- Make socket lookup redirection map-based. BPF program now uses a
  dedicated helper and a SOCKARRAY map to select the socket to redirect to.
  A consequence of this change is that bpf_inet_lookup context is now
  read-only.
- Look for connected UDP sockets before allowing redirection from BPF.
  This makes connected UDP socket work as expected in the presence of
  inet_lookup prog.
- Share the code for BPF_PROG_{ATTACH,DETACH,QUERY} with flow_dissector,
  the only other per-netns BPF prog type.

Overview
========

This series proposes a new BPF program type named BPF_PROG_TYPE_SK_LOOKUP,
or BPF sk_lookup for short.

BPF sk_lookup program runs when transport layer is looking up a listening
socket for a new connection request (TCP), or when looking up an
unconnected socket for a packet (UDP).

This serves as a mechanism to overcome the limits of what bind() API allows
to express. Two use-cases driving this work are:

 (1) steer packets destined to an IP range, fixed port to a single socket

     192.0.2.0/24, port 80 -> NGINX socket

 (2) steer packets destined to an IP address, any port to a single socket

     198.51.100.1, any port -> L7 proxy socket

In its context, program receives information about the packet that
triggered the socket lookup. Namely IP version, L4 protocol identifier, and
address 4-tuple.

To select a socket BPF program fetches it from a map holding socket
references, like SOCKMAP or SOCKHASH, calls bpf_sk_assign(ctx, sk, ...)
helper to record the selection, and returns SK_PASS code. Transport layer
then uses the selected socket as a result of socket lookup.

Alternatively, program can also fail the lookup (SK_DROP), or let the
lookup continue as usual (SK_PASS without selecting a socket).

This lets the user match packets with listening (TCP) or receiving (UDP)
sockets freely at the last possible point on the receive path, where we
know that packets are destined for local delivery after undergoing
policing, filtering, and routing.

Program is attached to a network namespace, similar to BPF flow_dissector.
We add a new attach type, BPF_SK_LOOKUP, for this. Multiple programs can be
attached at the same time, in which case their return values are aggregated
according the rules outlined in patch #4 description.

Series structure
================

Patches are organized as so:

 1: enables multiple link-based prog attachments for bpf-netns
 2: introduces sk_lookup program type
 3-4: hook up the program to run on ipv4/tcp socket lookup
 5-6: hook up the program to run on ipv6/tcp socket lookup
 7-8: hook up the program to run on ipv4/udp socket lookup
 9-10: hook up the program to run on ipv6/udp socket lookup
 11-13: libbpf & bpftool support for sk_lookup
 14-16: verifier and selftests for sk_lookup

Patches are also available on GH:

  https://github.com/jsitnicki/linux/commits/bpf-inet-lookup-v4

Follow-up work
==============

I'll follow up with below items, which IMHO don't block the review:

- benchmark results for udp6 small packet flood scenario,
- user docs for new BPF prog type, Documentation/bpf/prog_sk_lookup.rst,
- timeout for accept() in tests after extending network_helper.[ch].

Thanks to the reviewers for their feedback to this patch series:

Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrii Nakryiko <andriin@fb.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Cc: Marek Majkowski <marek@cloudflare.com>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Yonghong Song <yhs@fb.com>

-jkbs

[RFCv1] https://lore.kernel.org/bpf/20190618130050.8344-1-jakub@cloudflare.com/
[RFCv2] https://lore.kernel.org/bpf/20190828072250.29828-1-jakub@cloudflare.com/
[v1] https://lore.kernel.org/bpf/20200511185218.1422406-18-jakub@cloudflare.com/
[v2] https://lore.kernel.org/bpf/20200506125514.1020829-1-jakub@cloudflare.com/
[0] https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git/commit/?id=951f38cf08350884e72e0936adf147a8d764cc5d

Jakub Sitnicki (16):
  bpf, netns: Handle multiple link attachments
  bpf: Introduce SK_LOOKUP program type with a dedicated attach point
  inet: Extract helper for selecting socket from reuseport group
  inet: Run SK_LOOKUP BPF program on socket lookup
  inet6: Extract helper for selecting socket from reuseport group
  inet6: Run SK_LOOKUP BPF program on socket lookup
  udp: Extract helper for selecting socket from reuseport group
  udp: Run SK_LOOKUP BPF program on socket lookup
  udp6: Extract helper for selecting socket from reuseport group
  udp6: Run SK_LOOKUP BPF program on socket lookup
  bpf: Sync linux/bpf.h to tools/
  libbpf: Add support for SK_LOOKUP program type
  tools/bpftool: Add name mappings for SK_LOOKUP prog and attach type
  selftests/bpf: Add verifier tests for bpf_sk_lookup context access
  selftests/bpf: Rename test_sk_lookup_kern.c to test_ref_track_kern.c
  selftests/bpf: Tests for BPF_SK_LOOKUP attach point

 include/linux/bpf-netns.h                     |    3 +
 include/linux/bpf.h                           |    4 +
 include/linux/bpf_types.h                     |    2 +
 include/linux/filter.h                        |  163 +++
 include/uapi/linux/bpf.h                      |   77 +
 kernel/bpf/core.c                             |   55 +
 kernel/bpf/net_namespace.c                    |  127 +-
 kernel/bpf/syscall.c                          |    9 +
 kernel/bpf/verifier.c                         |   10 +-
 net/core/filter.c                             |  182 +++
 net/ipv4/inet_hashtables.c                    |   60 +-
 net/ipv4/udp.c                                |   93 +-
 net/ipv6/inet6_hashtables.c                   |   66 +-
 net/ipv6/udp.c                                |   97 +-
 scripts/bpf_helpers_doc.py                    |    9 +-
 tools/bpf/bpftool/common.c                    |    1 +
 tools/bpf/bpftool/prog.c                      |    3 +-
 tools/include/uapi/linux/bpf.h                |   77 +
 tools/lib/bpf/libbpf.c                        |    3 +
 tools/lib/bpf/libbpf.h                        |    2 +
 tools/lib/bpf/libbpf.map                      |    2 +
 tools/lib/bpf/libbpf_probes.c                 |    3 +
 tools/testing/selftests/bpf/network_helpers.c |   58 +-
 tools/testing/selftests/bpf/network_helpers.h |    2 +
 .../bpf/prog_tests/reference_tracking.c       |    2 +-
 .../selftests/bpf/prog_tests/sk_lookup.c      | 1282 +++++++++++++++++
 .../selftests/bpf/progs/test_ref_track_kern.c |  181 +++
 .../selftests/bpf/progs/test_sk_lookup_kern.c |  688 +++++++--
 .../selftests/bpf/verifier/ctx_sk_lookup.c    |  471 ++++++
 29 files changed, 3521 insertions(+), 211 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/sk_lookup.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_ref_track_kern.c
 create mode 100644 tools/testing/selftests/bpf/verifier/ctx_sk_lookup.c

-- 
2.25.4

