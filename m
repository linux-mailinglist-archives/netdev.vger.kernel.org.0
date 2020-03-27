Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 297F0195002
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 05:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbgC0E0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 00:26:01 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43488 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbgC0E0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 00:26:00 -0400
Received: by mail-pf1-f194.google.com with SMTP id f206so3892329pfa.10;
        Thu, 26 Mar 2020 21:25:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TsKBx3wOdnN/Qyf6INTx0C/vLa7l7648ufKCRtBivuU=;
        b=R/PCAUsbaPdpfyfYjwsj6ks5ueUlVlfiot1iGbNKGyDja/2SfMJjXtohbk0Mvj18CQ
         TaqfM29gMwbqhCSlBxg0LUUfdCERTL0GIQmRl9votI7ll0Y0kz9cS0I3VfobskL5tc2T
         BwrriHX9+psvG4gPnAym/jYgqMkZ8zPZ1hY2CccreyM5bZrqGtIPLNUbEjl51MKzRuQV
         jWcajDeXzeffL7NJubRbkSGuN7Cszzp3IYV2clnRQ7LOfvYTbDB3SPTZkdWLWrktxQ7X
         oBLOEYO0O3qRKZGWlHknD7G+a4TeNGwfDU+bPOOfSB9QUMaswj4xOhibaiNmZcxrqAyy
         E6OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=TsKBx3wOdnN/Qyf6INTx0C/vLa7l7648ufKCRtBivuU=;
        b=sDQJGkYIEMDvu2rWD41+5AR31oSsNt3wj/6xVob5zxB3IjUwC23vI5byW4ni+FJxF5
         G1WbqqsAAIOSY9PKGMvorVuR0+u/ewkeNOMb9Is6f0z0kCdLEsFNvAZ5yZGB5o2WEVI7
         rijxNdpEwIyKAxwcFhKZXgJRiJBgfjsTeCIf6kRvLWnHouATPkoOEEEFgFH064aqWvbU
         fbmM13YIU4yJ22WPie0tHmmX3VL6JbBGGA77andB/A2N9axUPJcdoRO7YY9l860HsxEh
         vVwS1NMHUKYa9In2H3pCnRPu+BTAro2ctIg65qIET2y+rfB/3LO5+TU/h3lxoB8w0bBV
         An4Q==
X-Gm-Message-State: ANhLgQ2jVKgjTf/q6zsZWIThjEceVZOaIXcxYj6WYnKFlsoM4AI4XTS9
        l1sUYH9IuJf33JSNJffMln2PNXI9
X-Google-Smtp-Source: ADFU+vsA3EUQ4yymDecSJyLZqcUyz4Nvs6Mn0AhhB0tXSSKlvzVPr1zE6KknIkj8L3qBTGQVt3+fXg==
X-Received: by 2002:a63:2166:: with SMTP id s38mr11474613pgm.83.1585283158765;
        Thu, 26 Mar 2020 21:25:58 -0700 (PDT)
Received: from localhost.localdomain (c-73-93-5-123.hsd1.ca.comcast.net. [73.93.5.123])
        by smtp.gmail.com with ESMTPSA id y17sm3004647pfl.104.2020.03.26.21.25.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 21:25:58 -0700 (PDT)
From:   Joe Stringer <joe@wand.net.nz>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, ast@kernel.org,
        eric.dumazet@gmail.com, lmb@cloudflare.com, kafai@fb.com
Subject: [PATCHv3 bpf-next 0/5] Add bpf_sk_assign eBPF helper
Date:   Thu, 26 Mar 2020 21:25:51 -0700
Message-Id: <20200327042556.11560-1-joe@wand.net.nz>
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

