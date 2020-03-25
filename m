Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71CC81920CF
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 06:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726065AbgCYF56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 01:57:58 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:35771 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgCYF56 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 01:57:58 -0400
Received: by mail-pf1-f195.google.com with SMTP id u68so531905pfb.2;
        Tue, 24 Mar 2020 22:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DhgMxg9/d4jZxJK2gCTztL66Uqlfg5HkLq6v1FdFCg0=;
        b=Id/LMMY8Fb/MCPGxuZORARzbvPiuoa20rDbwXLZyJwdpHUNneG3se8PsL49Xhq9xHC
         3tT59SoKrcIC5UtxCYfnQIpadjHePY7anjlh8kgiKzRZWLVlM0/4AcTHGZchILyizQWO
         ck8G+YrJ1aJKZ+jips/RXApHkt23RpkmYPzB6OqyuYDGHLgaKWrYTdxjAoVWNBNmf7Mt
         SJzpyMmiIY5oRT5C3uFXQFdVwavUIQYObhsSF3xkVIokWvVHkXvjf9vLWkut2WNXQ+zP
         H+wppSdOHP7ctWFnyjocNGlVb+26yr8TZJuHLtRoy+2vMKVjFHdRKTHD/5vmaJPgko/C
         ddCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=DhgMxg9/d4jZxJK2gCTztL66Uqlfg5HkLq6v1FdFCg0=;
        b=AM/LLG7eM3v+/THAT6yaxNr9m/zSl1Q3XpA7WbowL/Y3y/gG3G0vj5kVgPxDA3xEo2
         KtEg7ua03cRnfmAin6Wa8jGUYcBwvNeUnqQNbmL5zEtzEecPgkTBLONNOc7i1aeg7hQa
         4Q/zpzdVuAqXWynGkBgqtrXd6Fg3s/8Ruon/z8g/E85T8Mx/usnSpXIwBTakPjlTeRU1
         SjvCLjNmYFmy0y5qbu0UJGp3bGaaKgGx4ndcF1XI64DJanoUpUSfdl7qgRCIqsaUqmtd
         58v3MUQZFFCjTvbca7sLKnIhVwBgmqFV0tySdX4OvG5d2AHUDv5Ec7Q5Yv4TP+LPzwWC
         jcCg==
X-Gm-Message-State: ANhLgQ0Hs0+znL7RcNPzikIw1eotk2mzzYtF+x0qtG0EV4llMkci4DDZ
        A4DwGbKXvM9zqlibnlk1B5wNHBaZ
X-Google-Smtp-Source: ADFU+vsYiM5pgnux73ARBjtr2cw3neM89imDuCw7sixRF3E3UzoO7RO5/V5B/bvMSpfrwCU9U5Cf/g==
X-Received: by 2002:a63:b648:: with SMTP id v8mr1398589pgt.397.1585115876472;
        Tue, 24 Mar 2020 22:57:56 -0700 (PDT)
Received: from localhost.localdomain (c-73-93-5-123.hsd1.ca.comcast.net. [73.93.5.123])
        by smtp.gmail.com with ESMTPSA id e10sm17605716pfm.121.2020.03.24.22.57.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 22:57:55 -0700 (PDT)
From:   Joe Stringer <joe@wand.net.nz>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, ast@kernel.org,
        eric.dumazet@gmail.com, lmb@cloudflare.com, kafai@fb.com
Subject: [PATCHv2 bpf-next 0/5] Add bpf_sk_assign eBPF helper
Date:   Tue, 24 Mar 2020 22:57:40 -0700
Message-Id: <20200325055745.10710-1-joe@wand.net.nz>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce a new helper that allows assigning a previously-found socket
to the skb as the packet is received towards the stack, to cause the
stack to guide the packet towards that socket subject to local routing
configuration.

This series the successor to previous discussions on-list[0], in-person
at LPC2019[1], and the previous version[2] to support TProxy use cases
more directly from eBPF programs attached at TC ingress, to simplify and
streamline Linux stack configuration in scale environments with Cilium.

Normally in ip{,6}_rcv_core(), the skb will be orphaned, dropping any
existing socket reference associated with the skb. Existing tproxy
implementations in netfilter get around this restriction by running the
tproxy logic after ip_rcv_core() in the PREROUTING table. However, this
is not an option for TC-based logic (including eBPF programs attached at
TC ingress).

This series introduces the BPF helper bpf_sk_assign() to associate the
socket with the skb on the ingress path as the packet is passed up the
stack. The initial patch in the series simply takes a reference on the
socket to ensure safety, but later patches relax this for listen
sockets.

To ensure delivery to the relevant socket, we still consult the routing
table, for full examples of how to configure see the tests in patch #5;
the simplest form of the route would look like this:

  $ ip route add local default dev lo

This series is laid out as follows:
* Patch 1 extends the eBPF API to add sk_assign() and defines a new
  socket free function to allow the later paths to understand when the
  socket associated with the skb should be kept through receive.
* Patches 2-4 optimizate the receive path to prefetch the socket
  destination and avoid taking a reference on listener sockets during
  receive.
* Patches 5 extends the selftests with examples of the new
  functionality and validation of correct behaviour.

Changes since v1:
* Replace the metadata_dst approach with using the skb->destructor to
  determine whether the socket has been prefetched. This is much
  simpler.
* Avoid taking a reference on listener sockets during receive
* Restrict assigning sockets across namespaces
* Restrict assigning SO_REUSEPORT sockets
* Fix cookie usage for socket dst check
* Rebase the tests against test_progs infrastructure
* Tidy up commit messages

[0] https://www.mail-archive.com/netdev@vger.kernel.org/msg303645.html
[1] https://linuxplumbersconf.org/event/4/contributions/464/
[2] https://lore.kernel.org/netdev/20200312233648.1767-1-joe@wand.net.nz/T/#m4028efa9381856049ae5633986ec562d6b94a146


Joe Stringer (4):
  bpf: Add socket assign support
  bpf: Prefetch established socket destinations
  net: Track socket refcounts in skb_steal_sock()
  bpf: Don't refcount LISTEN sockets in sk_assign()

Lorenz Bauer (1):
  selftests: bpf: add test for sk_assign

 include/net/inet6_hashtables.h                |   3 +-
 include/net/inet_hashtables.h                 |   3 +-
 include/net/sock.h                            |  42 ++-
 include/uapi/linux/bpf.h                      |  25 +-
 net/core/filter.c                             |  50 +++-
 net/core/sock.c                               |  10 +
 net/ipv4/ip_input.c                           |   3 +-
 net/ipv4/udp.c                                |   6 +-
 net/ipv6/ip6_input.c                          |   3 +-
 net/ipv6/udp.c                                |   9 +-
 net/sched/act_bpf.c                           |   2 +
 tools/include/uapi/linux/bpf.h                |  25 +-
 tools/testing/selftests/bpf/Makefile          |   2 +-
 .../selftests/bpf/prog_tests/sk_assign.c      | 244 ++++++++++++++++++
 .../selftests/bpf/progs/test_sk_assign.c      | 127 +++++++++
 15 files changed, 529 insertions(+), 25 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/sk_assign.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_sk_assign.c

-- 
2.20.1

