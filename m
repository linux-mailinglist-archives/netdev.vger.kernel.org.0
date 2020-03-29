Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 236461970E5
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 00:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729279AbgC2Wxt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 18:53:49 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:34014 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727591AbgC2Wxt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 18:53:49 -0400
Received: by mail-pl1-f195.google.com with SMTP id a23so5982710plm.1;
        Sun, 29 Mar 2020 15:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DM56iIrBCBD4CelEsv2HBuyOyiIMEMjGpg4gM8/gS8g=;
        b=hfzlt378JM0GeBFSV+x5rl0Ez9cMKrUcVLuvfGbiFLkvqYkKvnqsNbUM6vfnpnawLc
         y7PQVe81W+CavtLwuo0Sqj1QAsjV+otonenS//ADxUlMDS/KHKSAFnP8p/H6TsO3Lx5k
         fp6KBZC09soRdGe8uOGX4OXMmzKFTDxL7MgJpPoUqdDwh9JyPwbgn/vVpy4R4XIhNbIP
         +Lz6kjBQPadkAwWJ9EEOQ1mgzxU1yJvETNfxGFKfafKdrBsZpM4hSFS1PoP7S2eNhaep
         IEcXX4ceyM2kgn1y3nadlLRsUuEya1KOSSZo4JXwUtF29vbxyuWv0IPhZEf/DGX1//X6
         ov7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=DM56iIrBCBD4CelEsv2HBuyOyiIMEMjGpg4gM8/gS8g=;
        b=rqC9oMcDvgW/gHA9pz2X0EY9Bo/m922OeSDI+NrHPlSQCXKuKXK2UPjmoXY3/5oiF+
         4NSpuaU6S6pa0H+y93BunVJXlv6TAtcJEyPSJ869UC4Mz9LNJDiZthUNBciEVV0pWjXF
         KwN3ZQu6L+ZNmT1uwM6javiMzj3uUIoTzLS81W2JHMZ6shLeQKoF24zv4luxi94RWENl
         3DZUq5vuZeCnBWiYAypBHxULcUpfDr1U6Oa9NQLDoCzOBTKEC7SBmusEg2cyI3z+v2jx
         0kSUKcOZiqC7t4ujEJ/6ILQdkfOURp1R6FsGAPUdE5xuftFoY1cSWTTs5NrEia1Rek8N
         OTYg==
X-Gm-Message-State: ANhLgQ1vJwdsIREMutNaESLIZnSdtivqC3LR3/icz2sfIuu8A/SqA6w3
        utazZbXM1BZt9Wgd+DjpnUO7HRgj
X-Google-Smtp-Source: ADFU+vuirSlrn/1k8/fxFpDgslY4XNfwmd6JLtKydcwsxdV0G42iqA1PFpMVwFndkHPlK2VgoL24+Q==
X-Received: by 2002:a17:90a:2147:: with SMTP id a65mr12303616pje.176.1585522427495;
        Sun, 29 Mar 2020 15:53:47 -0700 (PDT)
Received: from localhost.localdomain (c-73-93-5-123.hsd1.ca.comcast.net. [73.93.5.123])
        by smtp.gmail.com with ESMTPSA id i187sm8710386pfg.33.2020.03.29.15.53.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Mar 2020 15:53:46 -0700 (PDT)
From:   Joe Stringer <joe@wand.net.nz>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, ast@kernel.org,
        eric.dumazet@gmail.com, lmb@cloudflare.com, kafai@fb.com
Subject: [PATCHv5 bpf-next 0/5] Add bpf_sk_assign eBPF helper
Date:   Sun, 29 Mar 2020 15:53:37 -0700
Message-Id: <20200329225342.16317-1-joe@wand.net.nz>
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

Changes since v4:
* Fix build with CONFIG_INET disabled
* Rebase

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
 include/net/sock.h                            |  46 ++-
 include/uapi/linux/bpf.h                      |  25 +-
 net/core/filter.c                             |  35 +-
 net/core/sock.c                               |  12 +
 net/ipv4/ip_input.c                           |   3 +-
 net/ipv4/udp.c                                |   6 +-
 net/ipv6/ip6_input.c                          |   3 +-
 net/ipv6/udp.c                                |   9 +-
 net/sched/act_bpf.c                           |   3 +
 tools/include/uapi/linux/bpf.h                |  25 +-
 .../selftests/bpf/prog_tests/sk_assign.c      | 309 ++++++++++++++++++
 .../selftests/bpf/progs/test_sk_assign.c      | 204 ++++++++++++
 14 files changed, 662 insertions(+), 24 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/sk_assign.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_sk_assign.c

-- 
2.20.1

