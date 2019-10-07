Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4969CCEA73
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 19:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728598AbfJGRUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 13:20:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59626 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728660AbfJGRUj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Oct 2019 13:20:39 -0400
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com [209.85.208.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 12978970DF
        for <netdev@vger.kernel.org>; Mon,  7 Oct 2019 17:20:39 +0000 (UTC)
Received: by mail-lj1-f200.google.com with SMTP id p14so3720124ljh.22
        for <netdev@vger.kernel.org>; Mon, 07 Oct 2019 10:20:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=TV7l4rVSCPuFf6bf0/5mrz7z4gL0/i747x7OYxCnc2s=;
        b=cPLy1c/QCNPQZvYW260rQe0CcpYwj21w/nMpKkisPFZY5Etes25a7f1C5Q7xdlWPY1
         z1AiGb4jIilMzrjOaHVjbHc/+o8Ek/6UoDUX9WieTefXRLJ5axE/t1c8pyLinP0iHLgK
         Fk74tV0kbKek+ieIMCxPbM4to7Caf464bo5s6iv8EA1bBPEGSBXMD7zD6iOCxeL9JOV2
         XvbYUMT03DeMLXUP1P3UL9At7yddWpUN/YvqJaTcfC7OnZYr9QxelA+YefRfaa5PmLzA
         Bo3vGq/TK40qQply1MytntkJ6t1Hq0iWfC3afoDdfCHN+EGxVQIsJeFHEeo8s7gJ1mw5
         K14g==
X-Gm-Message-State: APjAAAWBsmXxgIRY64X3tehELVZQ6ed4CZi6En1cKNEF52t9CN/muD3/
        90R8HyXlmFCcUTrivQND/33FODD2SS40OBEHJDl0Uun3KIQw+ZRthsimlOMTN239LboAVJe/Kb9
        evE3UpQbdb7pdndIS
X-Received: by 2002:ac2:554e:: with SMTP id l14mr1792042lfk.32.1570468837494;
        Mon, 07 Oct 2019 10:20:37 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyesdDW+CfnpzSajvJVOjsSH6iBuq8qinIiQOnNFJVtXvS5GuuPidY4qjRXkOAYaxw+9N1I0Q==
X-Received: by 2002:ac2:554e:: with SMTP id l14mr1792022lfk.32.1570468837240;
        Mon, 07 Oct 2019 10:20:37 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id v7sm2817572lfd.55.2019.10.07.10.20.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2019 10:20:36 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 2989A18063D; Mon,  7 Oct 2019 19:20:35 +0200 (CEST)
Subject: [PATCH bpf-next v3 0/5] xdp: Support multiple programs on a single
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
Date:   Mon, 07 Oct 2019 19:20:35 +0200
Message-ID: <157046883502.2092443.146052429591277809.stgit@alrua-x1>
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

Since Alexei pointed out some issues with trying to rewrite the eBPF byte code,
let's try a third approach: We add the ability to chain call programs into the
eBPF execution core itself, but without rewriting the eBPF byte code.

As in the previous version, the bpf() syscall gets a couple of new commands
which takes a pair of BPF program fds and a return code. It will then attach the
second program to the first one in a structured keyed by return code. When a
program chain is thus established, the former program will tail call to the
latter at the end of its execution.

The actual tail calling is achieved by adding a new flag to struct bpf_prog and
having BPF_PROG_RUN run the chain call logic if that flag is set. This means
that if the feature is *not* used, the overhead is a single conditional branch
(which means I couldn't measure a performance difference, as can be seen in the
results below).

For this version I kept the load-time flag from the previous version, to avoid
having to remove the read-only memory protection from the bpf prog. Only
programs loaded with this flag set can have other programs attached to them for
chain calls.

As before, it shouldn't be necessary to set the flag on program load time, but
rather we should enable the feature when a chain call program is first loaded.
We could conceivably just remove the RO property from the first page of struct
bpf_prog and set the flag as needed.

# PERFORMANCE

I performed a simple performance test to get an initial feel for the overhead of
the chain call mechanism. This test consists of running only two programs in
sequence: One that returns XDP_PASS and another that returns XDP_DROP. I then
measure the drop PPS performance and compare it to a baseline of just a single
program that only returns XDP_DROP.

For comparison, a test case that uses regular eBPF tail calls to sequence two
programs together is also included.

| Test case                        | Perf      | Overhead |
|----------------------------------+-----------+----------|
| Before patch (XDP DROP program)  | 31.5 Mpps |          |
| After patch (XDP DROP program)   | 32.0 Mpps |          |
| XDP chain call (XDP_PASS return) | 28.5 Mpps | 3.8 ns   |
| XDP chain call (wildcard return) | 28.1 Mpps | 4.3 ns   |

I consider the "Before patch" and "After patch" to be identical; the .5 Mpps
difference is within the regular test variance I see between runs. Likewise,
there is probably no significant difference between hooking the XDP_PASS return
code and using the wildcard slot.

# PATCH SET STRUCTURE
This series is structured as follows:

- Patch 1: Adds the call chain looping logic
- Patch 2: Adds the new commands added to the bpf() syscall
- Patch 3-4: Tools/ update and libbpf syscall wrappers
- Patch 5: Selftest  with example user space code (a bit hacky still)

The whole series is also available in my git repo on kernel.org:
https://git.kernel.org/pub/scm/linux/kernel/git/toke/linux.git/log/?h=xdp-multiprog-03

Changelog:

v3:
  - Keep the UAPI from v2, but change the implementation to hook into
    BPF_PROG_RUN instead of trying to inject instructions into the eBPF program
    itself (since that had problems as Alexei pointed out).
v2:
  - Completely new approach that integrates chain calls into the core eBPF
    runtime instead of doing the map XDP-specific thing with a new map from v1.

---

Toke Høiland-Jørgensen (5):
      bpf: Support chain calling multiple BPF programs after each other
      bpf: Add support for setting chain call sequence for programs
      tools: Update bpf.h header for program chain calls
      libbpf: Add syscall wrappers for BPF_PROG_CHAIN_* commands
      selftests: Add tests for XDP chain calls


 include/linux/bpf.h                           |    3 
 include/linux/filter.h                        |   34 +++
 include/uapi/linux/bpf.h                      |   16 +
 kernel/bpf/core.c                             |    6 
 kernel/bpf/syscall.c                          |   82 ++++++-
 tools/include/uapi/linux/bpf.h                |   16 +
 tools/lib/bpf/bpf.c                           |   34 +++
 tools/lib/bpf/bpf.h                           |    4 
 tools/lib/bpf/libbpf.map                      |    3 
 tools/testing/selftests/bpf/.gitignore        |    1 
 tools/testing/selftests/bpf/Makefile          |    3 
 tools/testing/selftests/bpf/progs/xdp_dummy.c |    6 
 tools/testing/selftests/bpf/test_xdp_chain.sh |   77 ++++++
 tools/testing/selftests/bpf/xdp_chain.c       |  313 +++++++++++++++++++++++++
 14 files changed, 594 insertions(+), 4 deletions(-)
 create mode 100755 tools/testing/selftests/bpf/test_xdp_chain.sh
 create mode 100644 tools/testing/selftests/bpf/xdp_chain.c

