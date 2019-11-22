Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E61F107934
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 21:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbfKVUIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 15:08:13 -0500
Received: from www62.your-server.de ([213.133.104.62]:37308 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbfKVUIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 15:08:12 -0500
Received: from 30.248.197.178.dynamic.dsl-lte-bonding.zhbmb00p-msn.res.cust.swisscom.ch ([178.197.248.30] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iYFDu-0004YD-Hi; Fri, 22 Nov 2019 21:08:10 +0100
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     john.fastabend@gmail.com, andrii.nakryiko@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf-next v2 0/8] Optimize BPF tail calls for direct jumps
Date:   Fri, 22 Nov 2019 21:07:53 +0100
Message-Id: <cover.1574452833.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25641/Fri Nov 22 11:06:48 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This gets rid of indirect jumps for BPF tail calls whenever possible.
The series adds emission for *direct* jumps for tail call maps in order
to avoid the retpoline overhead from a493a87f38cf ("bpf, x64: implement
retpoline for tail call") for situations that allow for it, meaning,
for known constant keys at verification time which are used as index
into the tail call map. See patch 7/8 for more general details.

Thanks!

v1  -> v2:
  - added more test cases
  - u8 ip_stable -> bool (Andrii)
  - removed bpf_map_poke_{un,}lock and simplified the code (Andrii)
  - added break into prog_array_map_poke_untrack since there's just
    one prog (Andrii)
  - fixed typo: for for in commit msg (Andrii)
  - reworked __bpf_arch_text_poke (Andrii)
  - added subtests, and comment on tests themselves, NULL-NULL
    transistion (Andrii)
  - in constant map key tracking I've moved the map_poke_track callback
    to once we've finished creating the poke tab as otherwise concurrent
    access from tail call map would blow up (since we realloc the table)
rfc -> v1:
  - Applied Alexei's and Andrii's feeback from
    https://lore.kernel.org/bpf/cover.1573779287.git.daniel@iogearbox.net/T/#t

Daniel Borkmann (8):
  bpf, x86: generalize and extend bpf_arch_text_poke for direct jumps
  bpf: move bpf_free_used_maps into sleepable section
  bpf: move owner type,jited info into array auxiliary data
  bpf: add initial poke descriptor table for jit images
  bpf: add poke dependency tracking for prog array maps
  bpf: constant map key tracking for prog array pokes
  bpf, x86: emit patchable direct jump as tail call
  bpf, testing: add various tail call test cases

 arch/x86/net/bpf_jit_comp.c                   | 264 +++++++---
 include/linux/bpf.h                           |  60 ++-
 include/linux/bpf_verifier.h                  |   3 +-
 include/linux/filter.h                        |  10 +
 kernel/bpf/arraymap.c                         | 215 +++++++-
 kernel/bpf/core.c                             |  73 ++-
 kernel/bpf/map_in_map.c                       |   5 +-
 kernel/bpf/syscall.c                          |  56 +-
 kernel/bpf/verifier.c                         | 120 ++++-
 .../selftests/bpf/prog_tests/tailcalls.c      | 487 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/tailcall1.c |  48 ++
 tools/testing/selftests/bpf/progs/tailcall2.c |  59 +++
 tools/testing/selftests/bpf/progs/tailcall3.c |  31 ++
 tools/testing/selftests/bpf/progs/tailcall4.c |  33 ++
 tools/testing/selftests/bpf/progs/tailcall5.c |  40 ++
 15 files changed, 1364 insertions(+), 140 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/tailcalls.c
 create mode 100644 tools/testing/selftests/bpf/progs/tailcall1.c
 create mode 100644 tools/testing/selftests/bpf/progs/tailcall2.c
 create mode 100644 tools/testing/selftests/bpf/progs/tailcall3.c
 create mode 100644 tools/testing/selftests/bpf/progs/tailcall4.c
 create mode 100644 tools/testing/selftests/bpf/progs/tailcall5.c

-- 
2.21.0

