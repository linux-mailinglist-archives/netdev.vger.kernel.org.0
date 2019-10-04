Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF0C3CC198
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 19:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388296AbfJDRWp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 13:22:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60416 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387979AbfJDRWo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Oct 2019 13:22:44 -0400
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 840A082BA
        for <netdev@vger.kernel.org>; Fri,  4 Oct 2019 17:22:43 +0000 (UTC)
Received: by mail-ed1-f72.google.com with SMTP id h12so4458814eda.19
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 10:22:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=JaEjuFYN+ScCbMUL9SfWrwdbZf2ALm7M9GzE1SH29jk=;
        b=aCtcA8OkcQUcFYkzX4Wx+ffSE7csLtzn50gSvpocfbWNy1llCQ1wMdCmOQ8x0Rd2xA
         x6muytbdj+VG8AKOnypvp1v76gV6XKBofnpDAFsGZwbvoepo78WQKsozSX+IiV8+pZBU
         OdATkKE2Z3/zb6jxRU66v+3k9VqPVXEzQ/jZCRbrb21ABjFCa0NeLZyWSKa8j5vDhQcV
         3toqLpqm5imhfx6LhgNcdAt2IaZn4/t5jLiwDONpp6jCDIXL3RELsGIvEdZirn+AN1sL
         pT/2aDjTaHIvp3qag+rS7TQb5FCFWXfy5vZX/WccfrpE7xXNu9/Na3a+OMfAMNZ+b033
         nkFw==
X-Gm-Message-State: APjAAAUXQSabcfsVYgQNtipzZBeREHbbTg778IIQTLG4WOs1ICN6BCep
        tw38opvyYBLmXd/MJwQeRspBhRMKOOpVvrB9Bn92uh3rvq/SWxTnu8OQ0J8n9Qj/p6EXwerCJPI
        2rMpkxJoJWh030rQf
X-Received: by 2002:a17:906:7294:: with SMTP id b20mr13126118ejl.216.1570209762135;
        Fri, 04 Oct 2019 10:22:42 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxK2VdZHJbKFfD8txn26btn/slatnhpbU32KkPMXyU9fOjO9JZJ/bAcrLYekByUXdG1Dv++OA==
X-Received: by 2002:a17:906:7294:: with SMTP id b20mr13126100ejl.216.1570209761806;
        Fri, 04 Oct 2019 10:22:41 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id v22sm1250014edm.89.2019.10.04.10.22.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2019 10:22:41 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 6D8CF18063D; Fri,  4 Oct 2019 19:22:40 +0200 (CEST)
Subject: [PATCH bpf-next v2 0/5] xdp: Support multiple programs on a single
 interface through chain calls
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Fri, 04 Oct 2019 19:22:40 +0200
Message-ID: <157020976030.1824887.7191033447861395957.stgit@alrua-x1>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for executing multiple XDP programs on a single
interface in sequence, through the use of chain calls, as discussed at the Linux
Plumbers Conference last month:

https://linuxplumbersconf.org/event/4/contributions/460/

# HIGH-LEVEL IDEA

Since the response to the previous iteration was pretty unanimous that this
should not be XDP-specific, this version takes a different approach: We add the
ability to inject chain call programs into the eBPF execution core itself. This
also turns out to be simpler, so that's good :)

The way this new approach works is the bpf() syscall gets a couple of new
commands which takes a pair of BPF program fds and a return code. It will then
attach the second program to the first one in a structured keyed by return code.
When a program chain is thus established, the former program will tail call to
the latter at the end of its execution.

The actual tail calling is achieved by having the verifier inject instructions
into the program that performs the chain call lookup and tail call before each
BPF_EXIT instruction. Since this rewriting has to be performed at program load
time, a new flag has to be set to trigger the rewriting. Only programs loaded
with this flag set can have other programs attached to them for chain calls.

Ideally, it shouldn't be necessary to set the flag on program load time,
but rather inject the calls when a chain call program is first loaded.
However, rewriting the program reallocates the bpf_prog struct, which is
obviously not possible after the program has been attached to something.

One way around this could be a sysctl to force the flag one (for enforcing
system-wide support). Another could be to have the chain call support
itself built into the interpreter and JIT, which could conceivably be
re-run each time we attach a new chain call program. This would also allow
the JIT to inject direct calls to the next program instead of using the
tail call infrastructure, which presumably would be a performance win. The
drawback is, of course, that it would require modifying all the JITs.


# PERFORMANCE

I performed a simple performance test to get an initial feel for the overhead of
the chain call mechanism. This test consists of running only two programs in
sequence: One that returns XDP_PASS and another that returns XDP_DROP. I then
measure the drop PPS performance and compare it to a baseline of just a single
program that only returns XDP_DROP.

For comparison, a test case that uses regular eBPF tail calls to sequence two
programs together is also included. I did not re-run the baseline tests from
before, so the two top values are the same

| Test case                        | Perf      | Overhead |
|----------------------------------+-----------+----------|
| Before patch (XDP DROP program)  | 31.0 Mpps |          |
| XDP tail call                    | 26.6 Mpps | 5.3 ns   |
|----------------------------------+-----------+----------|
| After patch (XDP DROP program)   | 31.2 Mpps |          |
| XDP chain call (wildcard return) | 26.8 Mpps | 5.3 ns   |
| XDP chain call (XDP_PASS return) | 27.2 Mpps | 4.7 ns   |

The difference between the wildcard and XDP_PASS cases for chain calls, is that
using the wildcard mode needs two tail call attempts where the first one fails,
(see the injected BPF code in patch 1) while XDP_PASS matches on the first tail
call.

# PATCH SET STRUCTURE
This series is structured as follows:

- Patch 1: Adds the code that injects the instructions into the programs
- Patch 2: Adds the new commands added to the bpf() syscall
- Patch 3-4: Tools/ update and libbpf syscall wrappers
- Patch 5: Selftest  with example user space code (a bit hacky still)

The whole series is also available in my git repo on kernel.org:
https://git.kernel.org/pub/scm/linux/kernel/git/toke/linux.git/log/?h=xdp-multiprog-02

Changelog:

v2:
  - Completely new approach that integrates chain calls into the core eBPF
    runtime instead of doing the map XDP-specific thing with a new map from v1.

---

Alan Maguire (1):
      bpf: Add support for setting chain call sequence for programs

Toke Høiland-Jørgensen (4):
      bpf: Support injecting chain calls into BPF programs on load
      tools: Update bpf.h header for program chain calls
      libbpf: Add syscall wrappers for BPF_PROG_CHAIN_* commands
      selftests: Add tests for XDP chain calls


 include/linux/bpf.h                           |    2 
 include/uapi/linux/bpf.h                      |   16 +
 kernel/bpf/core.c                             |   10 +
 kernel/bpf/syscall.c                          |   81 ++++++
 kernel/bpf/verifier.c                         |   76 ++++++
 tools/include/uapi/linux/bpf.h                |   16 +
 tools/lib/bpf/bpf.c                           |   34 +++
 tools/lib/bpf/bpf.h                           |    4 
 tools/lib/bpf/libbpf.map                      |    3 
 tools/testing/selftests/bpf/.gitignore        |    1 
 tools/testing/selftests/bpf/Makefile          |    3 
 tools/testing/selftests/bpf/progs/xdp_dummy.c |    6 
 tools/testing/selftests/bpf/test_xdp_chain.sh |   77 ++++++
 tools/testing/selftests/bpf/xdp_chain.c       |  313 +++++++++++++++++++++++++
 14 files changed, 640 insertions(+), 2 deletions(-)
 create mode 100755 tools/testing/selftests/bpf/test_xdp_chain.sh
 create mode 100644 tools/testing/selftests/bpf/xdp_chain.c

