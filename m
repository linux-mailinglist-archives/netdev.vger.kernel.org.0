Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06AE21968B9
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 19:55:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbgC1SzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 14:55:18 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:42897 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbgC1SzS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Mar 2020 14:55:18 -0400
Received: by mail-pf1-f196.google.com with SMTP id 22so6321635pfa.9;
        Sat, 28 Mar 2020 11:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GdehM0GhlRJiWnbNdIu2FAv6B4zmzhBITibgs44j0QQ=;
        b=HNbOeP1CGzT+C1ASFMVblZytSsxi8Aypov6PuX3fmJOZRBCSmR0PJWWqiqprUDk8HG
         NI7lddUmy4nf9rKfz4r2ERs5K58UhAeOWG0SxE5eCBQnM+fNFaQiJd2tOYskMa4yIzN1
         m0+xETMgFnOq/oqZJoGPtyYw7+ImeL3RMsoWfqXOhdJoDlg2eohgIquOY2YSeicrq/zB
         tEVrErtaI4J0oiMgO68JMwORAF9of0O9m4uyDsfqQ+rjfaQDvlRRRc2Kvg5J2mCw4x6X
         sHzNBUfdWR8DyuhWlnHiwYrPykTpQFCtU3iFIQmyOMQYXNAu9aQ7bfGJVNYDtrWFfVkp
         PSRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=GdehM0GhlRJiWnbNdIu2FAv6B4zmzhBITibgs44j0QQ=;
        b=uEojmG6hdW7m0rPcYBu2lzUFwD6N9eJBBBa9xAlkoPYE69KNXKkPMtlbuthsLP0C6V
         q20DgPufTYx7nleTc1fDRWOm0KaR0uO4JrkdPUq21godIhP8ZIfxG991gcwcAfqffgZo
         Wj7p4efqIMe+vVwgwGE8puMWANcIBzIArh14Cr4feEsbgTercsVYZXIbtUkFR1LKwxTO
         lGFyhJOMwEOBhNweReBnYXLhPyToYsR/7YScgcGh9GtAEfmj+aRS/IKo/ZRF9uBcoM/m
         hJI/tKOIHqZrUH1CCAcAZ+E9uUE49DOuMu2kbFxW1V6QrFRxyWrtG8rvdONf3DE5O2ja
         rvdg==
X-Gm-Message-State: ANhLgQ0VByzbQCeBaxkPXw2bUUw1SaOiqxhFbJfqJDWy4CsmEpI1roR3
        TG90Cf4v9tINmga8IBmQBL06rDGK
X-Google-Smtp-Source: ADFU+vtzFOTNFyQyIdPO/EQbFS9Mo6bnKDLVjCGFpiPA3+zJRsh7qu4nH+Byq1SAfTQvxxmquMvXhg==
X-Received: by 2002:aa7:8bdc:: with SMTP id s28mr5632140pfd.110.1585421715737;
        Sat, 28 Mar 2020 11:55:15 -0700 (PDT)
Received: from localhost.localdomain (c-73-93-5-123.hsd1.ca.comcast.net. [73.93.5.123])
        by smtp.gmail.com with ESMTPSA id d7sm6682022pfo.86.2020.03.28.11.55.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Mar 2020 11:55:14 -0700 (PDT)
From:   Joe Stringer <joe@wand.net.nz>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, ast@kernel.org,
        eric.dumazet@gmail.com, lmb@cloudflare.com, kafai@fb.com
Subject: [PATCHv4 bpf-next 0/5] Add bpf_sk_assign eBPF helper
Date:   Sat, 28 Mar 2020 11:55:03 -0700
Message-Id: <20200328185509.20892-1-joe@wand.net.nz>
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
configuration. The intention is to support TProxy use cases more
directly from eBPF programs attached at TC ingress, to simplify and
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
* Patches 2-3 optimize the receive path to avoid taking a reference on
  listener sockets during receive.
* Patches 4-5 extends the selftests with examples of the new
  functionality and validation of correct behaviour.

Changes since v3:
* Use sock_gen_put() directly instead of sock_edemux() from sock_pfree()
* Commit message wording fixups
* Add acks from Martin, Lorenz
* Rebase

Changes since v2:
* Add selftests for UDP socket redirection
* Drop the early demux optimization patch (defer for more testing)
* Fix check for orphaning after TC act return
* Tidy up the tests to clean up properly and be less noisy.

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

Joe Stringer (4):
  bpf: Add socket assign support
  net: Track socket refcounts in skb_steal_sock()
  bpf: Don't refcount LISTEN sockets in sk_assign()
  selftests: bpf: Extend sk_assign tests for UDP

Lorenz Bauer (1):
  selftests: bpf: add test for sk_assign

 include/net/inet6_hashtables.h                |   3 +-
 include/net/inet_hashtables.h                 |   3 +-
 include/net/sock.h                            |  42 ++-
 include/uapi/linux/bpf.h                      |  25 +-
 net/core/filter.c                             |  35 +-
 net/core/sock.c                               |  10 +
 net/ipv4/ip_input.c                           |   3 +-
 net/ipv4/udp.c                                |   6 +-
 net/ipv6/ip6_input.c                          |   3 +-
 net/ipv6/udp.c                                |   9 +-
 net/sched/act_bpf.c                           |   3 +
 tools/include/uapi/linux/bpf.h                |  25 +-
 .../selftests/bpf/prog_tests/sk_assign.c      | 309 ++++++++++++++++++
 .../selftests/bpf/progs/test_sk_assign.c      | 204 ++++++++++++
 14 files changed, 656 insertions(+), 24 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/sk_assign.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_sk_assign.c

-- 
2.20.1

