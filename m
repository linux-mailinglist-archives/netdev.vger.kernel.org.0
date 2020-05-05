Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9CA1C61F9
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 22:27:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728969AbgEEU1f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 16:27:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728642AbgEEU1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 16:27:35 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D5E4C061A10
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 13:27:33 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id y73so3727114ybe.22
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 13:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=PVhrx9BtPYdAHT6BLZLnuchbfAzNuP7yXu9J4z3J1SM=;
        b=Uvd9Q+ut87WMXQOKsDCJOvADbYgzrwys/jbAlmmLSk5JcoF4WMJe1YmbzRY9Op0PaP
         bSsmlEFwd0iKk+zCScHOm+bUOHXkS0gnY3ZNNOu2Ac7sp9WZgLaYhOgmjI2O5J7SB25J
         eD0nt96B8BTieQb8Taud+Yst4ap7Nc59UhB384dV28cFRS6DMtN0trMvASlBeElAH4Se
         5w9W7INciryq3r4D/9MjTZ8Wdls7f4I4kZxBCYKghkPStNa0CsqyUAApOsdrbyydjCl0
         v840SR41khPNSUpgqJ2SBVMK1w/4cej/Obuj2Jk4e+2yDBGOE4EG9YzZ8i8LdPHzBrLp
         VbEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=PVhrx9BtPYdAHT6BLZLnuchbfAzNuP7yXu9J4z3J1SM=;
        b=VHcWvhJGrEC7cno0f/6wmcccnGoxPNCG8yX29uqqP5Scw493iGJRqaOBH/cuKCT/V6
         eH9+AgVN/G9Xn850/bDI726leTLiqcBUTii9dElniOUFtwif6G2LV7ROheuTOyvRZJxm
         g8woSWQMIp8nq/ToeSFfG5R9UI5amMD674awbzScbn0e3fhBRye+x/D3qKYMjQZrGa9v
         Jz8P3K1/SjSaK0uyw7/UNSFlvOW/LmEE48vtod2p6iqqAmBaMhcgFAyS2Ykbe21ydlxz
         4obOYYoO2nex4dSF1uJxbmRGQbNtnE7zH04KKrORLg5YLwNee7M0H8cHb2hL8WNy8PkY
         ESBQ==
X-Gm-Message-State: AGi0PuYypnQAHCqapJqYPLE/SCLTdWjcIT4sE/JyO1bVcmXSuRj4KmLT
        7YWn9e0snnkp6U9lep138p7+zGum1mjyMEaOH5ZmeYkVkspix2vRfNDCxRHXjQ+CectlnF/phOq
        FRMjzp8CaElq6XJkeRu5kKFG293HLp+4EjXQs721zqoXRBO63HM0yXw==
X-Google-Smtp-Source: APiQypLKnulzdCCRKvCBKfhqYgaHbWeuVaiazT86sqZ1pt5vtv3euw5xnV/cjwb27/HttibdzaBfxGk=
X-Received: by 2002:a25:cc53:: with SMTP id l80mr8474949ybf.100.1588710452499;
 Tue, 05 May 2020 13:27:32 -0700 (PDT)
Date:   Tue,  5 May 2020 13:27:25 -0700
Message-Id: <20200505202730.70489-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
Subject: [PATCH bpf-next v2 0/5] bpf: allow any port in bpf_bind helper
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Andrey Ignatov <rdna@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We want to have a tighter control on what ports we bind to in
the BPF_CGROUP_INET{4,6}_CONNECT hooks even if it means
connect() becomes slightly more expensive.

The series goes like this:
1. selftests: move existing helpers that make it easy to create
   listener threads into common test_progs part
2. selftests: make sure the helpers above don't get stuck forever
   in case the tests fails
3. do small refactoring of __inet{,6}_bind() flags to make it easy
   to extend them with the additional flags
4. remove the restriction on port being zero in bpf_bind() helper;
   add new bind flag to prevent POST_BIND hook from being called
5. selftests: move some common functionality into network_helpers

Cc: Andrey Ignatov <rdna@fb.com>

Stanislav Fomichev (5):
  selftests/bpf: generalize helpers to control background listener
  selftests/bpf: adopt accept_timeout from sockmap_listen
  net: refactor arguments of inet{,6}_bind
  bpf: allow any port in bpf_bind helper
  selftests/bpf: move existing common networking parts into
    network_helpers

 include/net/inet_common.h                     |   8 +-
 include/net/ipv6_stubs.h                      |   2 +-
 include/uapi/linux/bpf.h                      |   9 +-
 net/core/filter.c                             |  16 +-
 net/ipv4/af_inet.c                            |  20 +-
 net/ipv6/af_inet6.c                           |  22 +-
 tools/include/uapi/linux/bpf.h                |   9 +-
 tools/testing/selftests/bpf/Makefile          |   2 +-
 tools/testing/selftests/bpf/network_helpers.c | 208 ++++++++++++++++++
 tools/testing/selftests/bpf/network_helpers.h |  44 ++++
 .../bpf/prog_tests/connect_force_port.c       | 104 +++++++++
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c  |   1 +
 .../selftests/bpf/prog_tests/flow_dissector.c |   1 +
 .../prog_tests/flow_dissector_load_bytes.c    |   1 +
 .../selftests/bpf/prog_tests/global_data.c    |   1 +
 .../selftests/bpf/prog_tests/kfree_skb.c      |   1 +
 .../selftests/bpf/prog_tests/l4lb_all.c       |   1 +
 .../selftests/bpf/prog_tests/map_lock.c       |  14 ++
 .../selftests/bpf/prog_tests/pkt_access.c     |   1 +
 .../selftests/bpf/prog_tests/pkt_md_access.c  |   1 +
 .../selftests/bpf/prog_tests/prog_run_xattr.c |   1 +
 .../bpf/prog_tests/queue_stack_map.c          |   1 +
 .../selftests/bpf/prog_tests/signal_pending.c |   1 +
 .../selftests/bpf/prog_tests/skb_ctx.c        |   1 +
 .../selftests/bpf/prog_tests/sockmap_listen.c |  35 +--
 .../selftests/bpf/prog_tests/spinlock.c       |  14 ++
 .../selftests/bpf/prog_tests/tcp_rtt.c        | 116 +---------
 tools/testing/selftests/bpf/prog_tests/xdp.c  |   1 +
 .../bpf/prog_tests/xdp_adjust_tail.c          |   1 +
 .../selftests/bpf/prog_tests/xdp_bpf2bpf.c    |   1 +
 .../selftests/bpf/prog_tests/xdp_noinline.c   |   1 +
 .../selftests/bpf/progs/connect_force_port4.c |  28 +++
 .../selftests/bpf/progs/connect_force_port6.c |  28 +++
 tools/testing/selftests/bpf/test_progs.c      |  30 ---
 tools/testing/selftests/bpf/test_progs.h      |  23 --
 35 files changed, 510 insertions(+), 238 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/network_helpers.c
 create mode 100644 tools/testing/selftests/bpf/network_helpers.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/connect_force_port.c
 create mode 100644 tools/testing/selftests/bpf/progs/connect_force_port4.c
 create mode 100644 tools/testing/selftests/bpf/progs/connect_force_port6.c

-- 
2.26.2.526.g744177e7f7-goog
