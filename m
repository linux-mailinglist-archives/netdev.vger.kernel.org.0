Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 046EC211FB7
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 11:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728007AbgGBJYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 05:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbgGBJYT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 05:24:19 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A04BC08C5C1
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 02:24:19 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id y10so28450688eje.1
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 02:24:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d/9xPYZP4tLOP1W2+YlZxcJGdaiixZnhV8pfC4vwDAA=;
        b=QbS+tkAFAXuQTXOC4fE2+NS+XmgWM2jkwpfoFJvXXVMJ165Zt7/QrcN6zuxFepN8a/
         Z3Tgyg02LyL2/daSiV1lTNV2P98V/DVSiw6RWLoGIpADB4wEjWrXUBbCjOHdvoNOW7sD
         wOfCdPTzR9lPTQWEbIQo5Id7TTPQefXFmUOjQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d/9xPYZP4tLOP1W2+YlZxcJGdaiixZnhV8pfC4vwDAA=;
        b=EMlHMoMQhIIHA9iLIpY9LkooXPmAedhoXVJdsxX5lOCMWnlbUc+OZMOq7axiNFHG6+
         kjMh2Pu1NGPq7fpTLyDjx26CjKHGv+YkZ3U9Gmgykwq4UhxST2EAbvJCynJBzWkl+Etj
         NaSkpNZDx/Jp8/qcsFoDH4hLs0qrD55iyBwg572klDDLl5MzF+7eZHCeiRGpZVtagewj
         mqQN7wr4ul6FLM5o+lhsUdC78DgO8VAMyfDcjzNToXJpm7dqSCMMju/DSWrESxYxg2X7
         QvfnSrUJtIb2bNeJtlZy8n/GK76rIYIJiRFMl7C/uLI/zdZEeSKmMJDULI2grtcU7lOk
         ALbA==
X-Gm-Message-State: AOAM530vRhcYpqFPIPS6mYgdoB9U+6U585C3sD0ZXYFHwzwoltwoq23L
        e11CoQwpkSRNaE2v4QHaMpYsbg==
X-Google-Smtp-Source: ABdhPJxFJaSsmQI2MneR+jGl0ep3G5IO6L+X2SCsAZl8EajIIG0cFNhTPDox/CkBQmO8OmMmXZ6bWQ==
X-Received: by 2002:a17:907:94cf:: with SMTP id dn15mr28754396ejc.457.1593681857991;
        Thu, 02 Jul 2020 02:24:17 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id d26sm6489054ejw.89.2020.07.02.02.24.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 02:24:17 -0700 (PDT)
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
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH bpf-next v3 00/16] Run a BPF program on socket lookup
Date:   Thu,  2 Jul 2020 11:24:00 +0200
Message-Id: <20200702092416.11961-1-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Overview
========

(Same as in v2. Please skip to next section if you've read it.)

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
helper to record the selection, and returns BPF_REDIRECT code. Transport
layer then uses the selected socket as a result of socket lookup.

Alternatively, program can also fail the lookup (BPF_DROP), or let the
lookup continue as usual (BPF_OK).

This lets the user match packets with listening (TCP) or receiving (UDP)
sockets freely at the last possible point on the receive path, where we
know that packets are destined for local delivery after undergoing
policing, filtering, and routing.

Program is attached to a network namespace, similar to BPF flow_dissector.
We add a new attach type, BPF_SK_LOOKUP, for this.

Series structure
================

Patches are organized as so:

 1: enabled multiple link-based prog attachments for bpf-netns
 2: introduces sk_lookup program type
 3-4: hook up the program to run on ipv4/tcp socket lookup
 5-6: hook up the program to run on ipv6/tcp socket lookup
 7-8: hook up the program to run on ipv4/udp socket lookup
 9-10: hook up the program to run on ipv6/udp socket lookup
 11-13: libbpf & bpftool support for sk_lookup
 14-16: verifier and selftests for sk_lookup

Patches are also available on GH:

  https://github.com/jsitnicki/linux/commits/bpf-inet-lookup-v3

Performance considerations
==========================

I'm re-running udp6 small packet flood test, the scenario for which we had
performance concerns in [v2], to measure pps hit after the changes called
out in change log below.

Will follow up with results. But I'm posting the patches early for review
since there is a fair amount of code changes.

Further work
============

- user docs for new prog type, Documentation/bpf/prog_sk_lookup.rst
  I'm looking for consensus on multi-prog semantics outlined in patch #4
  description before drafting the document.

- timeout on accept() in tests
  I need to extract a helper for it into network_helpers in
  selftests/bpf/. Didn't want to make this series any longer.

Note to maintainers
===================

This patch series depends on bpf-netns multi-prog changes that went
recently into 'bpf' [0]. It won't apply onto 'bpf-next' until 'bpf' gets
merged into 'bpf-next'.

Changelog
=========

v3 brings the following changes based on feedback:

1. switch to link-based program attachment,
2. support for multi-prog attachment,
3. ability to skip reuseport socket selection,
4. code on RX path is guarded by a static key,
5. struct in6_addr's are no longer copied into BPF prog context,
6. BPF prog context is initialized as late as possible.

v2 -> v3:
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

[RFCv1] https://lore.kernel.org/bpf/20190618130050.8344-1-jakub@cloudflare.com/
[RFCv2] https://lore.kernel.org/bpf/20190828072250.29828-1-jakub@cloudflare.com/
[v1] https://lore.kernel.org/bpf/20200511185218.1422406-18-jakub@cloudflare.com/
[v2] https://lore.kernel.org/bpf/20200506125514.1020829-1-jakub@cloudflare.com/
[0] https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git/commit/?id=951f38cf08350884e72e0936adf147a8d764cc5d

Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrii Nakryiko <andriin@fb.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Cc: Marek Majkowski <marek@cloudflare.com>
Cc: Martin KaFai Lau <kafai@fb.com>

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
 include/linux/bpf.h                           |   33 +
 include/linux/bpf_types.h                     |    2 +
 include/linux/filter.h                        |   99 ++
 include/uapi/linux/bpf.h                      |   74 +
 kernel/bpf/core.c                             |   22 +
 kernel/bpf/net_namespace.c                    |  125 +-
 kernel/bpf/syscall.c                          |    9 +
 net/core/filter.c                             |  188 +++
 net/ipv4/inet_hashtables.c                    |   60 +-
 net/ipv4/udp.c                                |   93 +-
 net/ipv6/inet6_hashtables.c                   |   66 +-
 net/ipv6/udp.c                                |   97 +-
 scripts/bpf_helpers_doc.py                    |    9 +-
 tools/bpf/bpftool/common.c                    |    1 +
 tools/bpf/bpftool/prog.c                      |    3 +-
 tools/include/uapi/linux/bpf.h                |   74 +
 tools/lib/bpf/libbpf.c                        |    3 +
 tools/lib/bpf/libbpf.h                        |    2 +
 tools/lib/bpf/libbpf.map                      |    2 +
 tools/lib/bpf/libbpf_probes.c                 |    3 +
 .../bpf/prog_tests/reference_tracking.c       |    2 +-
 .../selftests/bpf/prog_tests/sk_lookup.c      | 1353 +++++++++++++++++
 .../selftests/bpf/progs/test_ref_track_kern.c |  181 +++
 .../selftests/bpf/progs/test_sk_lookup_kern.c |  462 ++++--
 .../selftests/bpf/verifier/ctx_sk_lookup.c    |  219 +++
 26 files changed, 2995 insertions(+), 190 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/sk_lookup.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_ref_track_kern.c
 create mode 100644 tools/testing/selftests/bpf/verifier/ctx_sk_lookup.c

-- 
2.25.4

