Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 962321C70E5
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 14:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728616AbgEFMzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 08:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728081AbgEFMzS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 08:55:18 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 954D3C061A41
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 05:55:17 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id u16so2519440wmc.5
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 05:55:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/p5GvhD7Uf18BD3K6cm45jSKRFX3U9VfnrP0BmqRQJc=;
        b=d/OZfCUhJqBGGlzTdHcVznLLDQMfI/iumQImSoktq479tLeafqwpCCj78tTFXiObRT
         xUljXLnO0tPZTOekix/aRFF9e51XqLYCoP8cKO7nloTbuF5vJIPm8xCw527kJXQtWNcb
         CBgOwjX08+Q0b6Cehv9V6kiJhznmLcPsEpWmo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/p5GvhD7Uf18BD3K6cm45jSKRFX3U9VfnrP0BmqRQJc=;
        b=CvusobtRT3wsjbbnrCvSmrwrlAqYcIB8c2mm1kxXRGgiMpUCr2oxWIfKpkQDl+cX+R
         fTL9/mtaapX9Z/aMKz9RlicHkk2PWUcZG2DmuP/J1muBhNWDer+5q42KhCylw6n/iReU
         EE0awhv/Z3f1maCOsTyW70XXZHax+lS9KYz2nn6J4nQPhh5xKEbUeUNwK83C9Pr1BxGf
         ZL6xUr7liExZcXnTkQO5obmpLTG1mN5+7D2rooPeP1VprPRK0gyxSA7UMwD1D/EC90fN
         PwZ2X1kDaEtfXPEDuPX3VIxeWA1F9h/ezs4QQPJLoPo8ShNdsTIDDlqfxvVDY1b3h8eW
         7igQ==
X-Gm-Message-State: AGi0Pubi6PV4o9LQmyuQVqmMrpzyvLwE93KRuh5cXQKWEkAjirwrTfOC
        cOYrkGY3DVmQFKFvk/F+50esVXIPvEU=
X-Google-Smtp-Source: APiQypLlBbpd5g7oDyHaMkQyyM/LrVc0cZSFD+Fxu4FZjQtOBS65mWFlNxqD+JnvegndhIqEO8jKyg==
X-Received: by 2002:a7b:c213:: with SMTP id x19mr4149083wmi.53.1588769715518;
        Wed, 06 May 2020 05:55:15 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id t67sm3155732wmg.40.2020.05.06.05.55.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 05:55:14 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     dccp@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH bpf-next 00/17] Run a BPF program on socket lookup
Date:   Wed,  6 May 2020 14:54:56 +0200
Message-Id: <20200506125514.1020829-1-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Overview
========

This series proposes a new BPF program type named BPF_PROG_TYPE_SK_LOOKUP,
or BPF sk_lookup for short.

BPF sk_lookup program runs when transport layer is looking up a socket for
a received packet. When called, sk_lookup program can select a socket that
will receive the packet.

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

Patches are organized as so:

 1: prepares ground for attaching/detaching programs to netns
 2: introduces sk_lookup program type
 3-5: hook up the program to run on ipv4/tcp socket lookup
 6-7: hook up the program to run on ipv6/tcp socket lookup
 8-10: hook up the program to run on ipv4/udp socket lookup
 11-12: hook up the program to run on ipv4/udp socket lookup
 13-14: add libbpf support for sk_lookup
 15-17: verifier and selftests for sk_lookup

Performance considerations
==========================

Patch set adds new code on receive hot path. This comes with a cost,
especially in a scenario of a SYN flood or small UDP packet flood.

Measuring the performance penalty turned out to be harder than expected
because socket lookup is fast. For CPUs to spend >= 1% of time in socket
lookup we had to modify our setup by unloading iptables and reducing the
number of routes.

The receiver machine is a Cloudflare Gen 9 server covered in detail at [0].
In short:

 - 24 core Intel custom off-roadmap 1.9Ghz 150W (Skylake) CPU
 - dual-port 25G Mellanox ConnectX-4 NIC
 - 256G DDR4 2666Mhz RAM

Flood traffic pattern:

 - source: 1 IP, 10k ports
 - destination: 1 IP, 1 port
 - TCP - SYN packet
 - UDP - Len=0 packet

Receiver setup:

 - ingress traffic spread over 4 RX queues,
 - RX/TX pause and autoneg disabled,
 - Intel Turbo Boost disabled,
 - TCP SYN cookies always on.

For TCP test there is a receiver process with single listening socket
open. Receiver is not accept()'ing connections.

For UDP the receiver process has a single UDP socket with a filter
installed, dropping the packets.

With such setup in place, we record RX pps and cpu-cycles events under
flood for 60 seconds in 3 configurations:

 1. 5.6.3 kernel w/o this patch series (baseline),
 2. 5.6.3 kernel with patches applied, but no SK_LOOKUP program attached,
 3. 5.6.3 kernel with patches applied, and SK_LOOKUP program attached;
    BPF program [1] is doing a lookup in LPM_TRIE map with 200 entries.

RX pps measured with `ifpps -d <dev> -t 1000 --csv --loop` for 60 seconds.

| tcp4 SYN flood               | rx pps (mean ± sstdev) | Δ rx pps |
|------------------------------+------------------------+----------|
| 5.6.3 vanilla (baseline)     | 939,616 ± 0.5%         |        - |
| no SK_LOOKUP prog attached   | 929,275 ± 1.2%         |    -1.1% |
| with SK_LOOKUP prog attached | 918,582 ± 0.4%         |    -2.2% |

| tcp6 SYN flood               | rx pps (mean ± sstdev) | Δ rx pps |
|------------------------------+------------------------+----------|
| 5.6.3 vanilla (baseline)     | 875,838 ± 0.5%         |        - |
| no SK_LOOKUP prog attached   | 872,005 ± 0.3%         |    -0.4% |
| with SK_LOOKUP prog attached | 856,250 ± 0.5%         |    -2.2% |

| udp4 0-len flood             | rx pps (mean ± sstdev) | Δ rx pps |
|------------------------------+------------------------+----------|
| 5.6.3 vanilla (baseline)     | 2,738,662 ± 1.5%       |        - |
| no SK_LOOKUP prog attached   | 2,576,893 ± 1.0%       |    -5.9% |
| with SK_LOOKUP prog attached | 2,530,698 ± 1.0%       |    -7.6% |

| udp6 0-len flood             | rx pps (mean ± sstdev) | Δ rx pps |
|------------------------------+------------------------+----------|
| 5.6.3 vanilla (baseline)     | 2,867,885 ± 1.4%       |        - |
| no SK_LOOKUP prog attached   | 2,646,875 ± 1.0%       |    -7.7% |
| with SK_LOOKUP prog attached | 2,520,474 ± 0.7%       |   -12.1% |

Also visualized on bpf-sk-lookup-v1-rx-pps.png chart [2].

cpu-cycles measured with `perf record -F 999 --cpu 1-4 -g -- sleep 60`.

|                              |      cpu-cycles events |          |
| tcp4 SYN flood               | __inet_lookup_listener | Δ events |
|------------------------------+------------------------+----------|
| 5.6.3 vanilla (baseline)     |                  1.12% |        - |
| no SK_LOOKUP prog attached   |                  1.31% |    0.19% |
| with SK_LOOKUP prog attached |                  3.05% |    1.93% |

|                              |      cpu-cycles events |          |
| tcp6 SYN flood               |  inet6_lookup_listener | Δ events |
|------------------------------+------------------------+----------|
| 5.6.3 vanilla (baseline)     |                  1.05% |        - |
| no SK_LOOKUP prog attached   |                  1.68% |    0.63% |
| with SK_LOOKUP prog attached |                  3.15% |    2.10% |

|                              |      cpu-cycles events |          |
| udp4 0-len flood             |      __udp4_lib_lookup | Δ events |
|------------------------------+------------------------+----------|
| 5.6.3 vanilla (baseline)     |                  3.81% |        - |
| no SK_LOOKUP prog attached   |                  5.22% |    1.41% |
| with SK_LOOKUP prog attached |                  8.20% |    4.39% |

|                              |      cpu-cycles events |          |
| udp6 0-len flood             |      __udp6_lib_lookup | Δ events |
|------------------------------+------------------------+----------|
| 5.6.3 vanilla (baseline)     |                  5.51% |        - |
| no SK_LOOKUP prog attached   |                  6.51% |    1.00% |
| with SK_LOOKUP prog attached |                 10.14% |    4.63% |

Also visualized on bpf-sk-lookup-v1-cpu-cycles.png chart [3].

Further work
============

To be done, either in next iteration, or as a follow up:

 - document the new program type under Documentation/bpf/,
 - timeout on accept() in tests once accept_timeout is in a common place.

Changelog
=========

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

[0] https://blog.cloudflare.com/a-tour-inside-cloudflares-g9-servers/
[1] https://github.com/majek/inet-tool/blob/master/ebpf/inet-kern.c
[2] https://drive.google.com/file/d/1HrrjWhQoVlqiqT73_eLtWMPhuGPKhGFX/
[3] https://drive.google.com/file/d/1cYPPOlGg7M-bkzI4RW1SOm49goI4LYbb/
[RFCv1] https://lore.kernel.org/bpf/20190618130050.8344-1-jakub@cloudflare.com/
[RFCv2] https://lore.kernel.org/bpf/20190828072250.29828-1-jakub@cloudflare.com/

Jakub Sitnicki (17):
  flow_dissector: Extract attach/detach/query helpers
  bpf: Introduce SK_LOOKUP program type with a dedicated attach point
  inet: Store layer 4 protocol in inet_hashinfo
  inet: Extract helper for selecting socket from reuseport group
  inet: Run SK_LOOKUP BPF program on socket lookup
  inet6: Extract helper for selecting socket from reuseport group
  inet6: Run SK_LOOKUP BPF program on socket lookup
  udp: Store layer 4 protocol in udp_table
  udp: Extract helper for selecting socket from reuseport group
  udp: Run SK_LOOKUP BPF program on socket lookup
  udp6: Extract helper for selecting socket from reuseport group
  udp6: Run SK_LOOKUP BPF program on socket lookup
  bpf: Sync linux/bpf.h to tools/
  libbpf: Add support for SK_LOOKUP program type
  selftests/bpf: Add verifier tests for bpf_sk_lookup context access
  selftests/bpf: Rename test_sk_lookup_kern.c to test_ref_track_kern.c
  selftests/bpf: Tests for BPF_SK_LOOKUP attach point

 include/linux/bpf.h                           |   8 +
 include/linux/bpf_types.h                     |   2 +
 include/linux/filter.h                        |  23 +
 include/net/inet6_hashtables.h                |  20 +
 include/net/inet_hashtables.h                 |  39 +
 include/net/net_namespace.h                   |   1 +
 include/net/udp.h                             |  10 +-
 include/uapi/linux/bpf.h                      |  53 +
 kernel/bpf/syscall.c                          |   9 +
 net/core/filter.c                             | 315 ++++++
 net/core/flow_dissector.c                     |  61 +-
 net/dccp/proto.c                              |   2 +-
 net/ipv4/inet_hashtables.c                    |  44 +-
 net/ipv4/tcp_ipv4.c                           |   2 +-
 net/ipv4/udp.c                                |  85 +-
 net/ipv4/udp_impl.h                           |   2 +-
 net/ipv4/udplite.c                            |   4 +-
 net/ipv6/inet6_hashtables.c                   |  46 +-
 net/ipv6/udp.c                                |  86 +-
 net/ipv6/udp_impl.h                           |   2 +-
 net/ipv6/udplite.c                            |   2 +-
 scripts/bpf_helpers_doc.py                    |   9 +-
 tools/include/uapi/linux/bpf.h                |  53 +
 tools/lib/bpf/libbpf.c                        |   3 +
 tools/lib/bpf/libbpf.h                        |   2 +
 tools/lib/bpf/libbpf.map                      |   2 +
 tools/lib/bpf/libbpf_probes.c                 |   1 +
 .../bpf/prog_tests/reference_tracking.c       |   2 +-
 .../selftests/bpf/prog_tests/sk_lookup.c      | 999 ++++++++++++++++++
 .../selftests/bpf/progs/test_ref_track_kern.c | 180 ++++
 .../selftests/bpf/progs/test_sk_lookup_kern.c | 258 +++--
 .../selftests/bpf/verifier/ctx_sk_lookup.c    | 696 ++++++++++++
 32 files changed, 2749 insertions(+), 272 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/sk_lookup.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_ref_track_kern.c
 create mode 100644 tools/testing/selftests/bpf/verifier/ctx_sk_lookup.c

-- 
2.25.3

