Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 140CA41D03B
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 01:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347386AbhI3ABP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 20:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346558AbhI3ABO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 20:01:14 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A5F8C06161C;
        Wed, 29 Sep 2021 16:59:33 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id s75so4406387pgs.5;
        Wed, 29 Sep 2021 16:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hL8gxvjPugkIyQjl2cCtkwFpYGKtGQ6MrGzRcJhYVFs=;
        b=qulhclDo5OV/JOvac8jpihuXFjoTzUsHGCKWBon7ukZ+K1TvjrCKGDBKOyTPVoe7vI
         simvJFlNO95bx8WYXFNojckp3GD4ppWXo5Z29kd30nKYsJpvBRuORRBtpd9pqDLoVkIx
         pTENQa11kY1irVnUqjdkzBapDbgIb7PzHvxI1RpfmokZCl+2DHUMdt9L4PkfCDoC2BOW
         MgJj0r3kgcKlv3KZB1PcI85G5H1S1LOCOGA3nRvgN4hk6z4qRp/jG5ci80G4koVwf0ON
         KGsw6E1Qur6TG2HFODQWP5ehaRPlJoXZx9GxfW6f2/fDsNIPgLzXjFkNyU9CJx+GTNW2
         ePhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hL8gxvjPugkIyQjl2cCtkwFpYGKtGQ6MrGzRcJhYVFs=;
        b=VESmWRgW3ZYTR8gJXULZaermC+eoqxa2mOlc041j2nzGoRVGS7nk1spdewaOPrFXI9
         krofqLa1xqMdgZF0f5iGy2G2Ot5I1Pl+HSliTmPTfDd0w2oK5kSUq1j13ju3/LKDlN/D
         a1qbejFmwDxN2OnhfBz396u+c+erh4jwTTp02dll1eiOnmXrML0ebHAI78nJSB339hTk
         64NbJMCKXdjjmfud0SuyEOLCl9Y5iweqkXu7zK+vCI17+YmIB79kS40nvofn9zeHb77z
         YO8fz47wxFjTgqLziAUGLe63ucP84fUhX1ePNN1/a7+GEzJK8fOulQw4Oabu49+I8kkU
         1XoA==
X-Gm-Message-State: AOAM532dWm6oILluNcMzx9om+W/EtykmZSuityZylPc2PlsWAFxKz9gS
        AGwXZHtLcxCY2aUdiy8iRGQ7gz85Efcc
X-Google-Smtp-Source: ABdhPJzWjdFgXSc3yY0W4BrvyBg/ytK8zTY3SltreXF1QPDew9L32Ty/UG3fU7V6O0pzt7Ovi30XDQ==
X-Received: by 2002:a63:b505:: with SMTP id y5mr2274597pge.91.1632959972634;
        Wed, 29 Sep 2021 16:59:32 -0700 (PDT)
Received: from jevburton2.c.googlers.com.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id mr18sm681907pjb.17.2021.09.29.16.59.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 16:59:32 -0700 (PDT)
From:   Joe Burton <jevburton.kernel@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
Cc:     Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Petar Penkov <ppenkov@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Joe Burton <jevburton@google.com>
Subject: [RFC PATCH v2 00/13] Introduce BPF map tracing capability
Date:   Wed, 29 Sep 2021 23:58:57 +0000
Message-Id: <20210929235910.1765396-1-jevburton.kernel@gmail.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Burton <jevburton@google.com>

This patch introduces 'map tracing': the capability to execute a
tracing program after updating a map.

Map tracing enables upgrades of stateful programs with fewer race
conditions than otherwise possible. We use a tracing program to
imbue a map with copy-on-write semantics, then use an iterator to
perform a bulk copy of data in the map. After bulk copying concludes,
updates to that map automatically propagate via the tracing
program, avoiding a class of race conditions. This use case is
demonstrated in the new 'real_world_example' selftest.

Extend BPF_PROG_TYPE_TRACING with a new attach type, BPF_TRACE_MAP,
and allow linking these programs to arbitrary maps.

Extend the verifier to invoke helper calls directly after
bpf_map_update_elem() and bpf_map_delete_elem(). The helpers have the
exact same signature as the functions they trace, and simply pass those
arguments to the list of tracing programs attached to the map.

struct bpf_map gets a single additional pointer, which points to a
structure containing lists of tracing programs. This pointer is
populated when the first tracing program is attached to a map, to
minimize memory overhead for the majority of maps which are not
traced. I use an atomic cmpxchg() to avoid the need for a mutex
when accessing the pointer. Once populated, the pointer is never
freed until the map itself is freed.

One open question is how to handle pointer-based map updates. For
example:
  int *x = bpf_map_lookup_elem(...);
  if (...) *x++;
  if (...) *x--;
We can't just call a helper function right after the
bpf_map_lookup_elem(), since the updates occur later on. We also can't
determine where the last modification to the pointer occurs, due to
branch instructions. I would therefore consider a pattern where we
'flush' pointers at the end of a BPF program:
  int *x = bpf_map_lookup_elem(...);
  ...
  /* Execute tracing programs for this cell in this map. */
  bpf_map_trace_pointer_update(x);
  return 0;
We can't necessarily do this in the verifier, since 'x' may no
longer be in a register or on the stack. Thus we might introduce a
helper to save pointers that should be flushed, then flush all
registered pointers at every exit point:
  int *x = bpf_map_lookup_elem(...);
  /*
   * Saves 'x' somewhere in kernel memory. Does nothing if no
   * corresponding tracing progs are attached to the map.
   */
  bpf_map_trace_register_pointer(x);
  ...
  /* flush all registered pointers */
  bpf_map_trace_pointer_update();
  return 0;
This should be easy to implement in the verifier.

In addition, we use the verifier to instrument certain map update
calls. This requires saving arguments onto the stack, which means that
a program using MAX_BPF_STACK bytes of stack could exceed the limit.
I don't know whether this actually causes any problems.

Linux Plumbers Conference slides on this topic:
https://linuxplumbersconf.org/event/11/contributions/942/attachments/
814/1533/joe_burton_lpc_2021_slides.pdf

Joe Burton (13):
  bpf: Add machinery to register map tracing hooks
  bpf: Allow loading BPF_TRACE_MAP programs
  bpf: Add list of tracing programs to struct bpf_map
  bpf: Define a few bpf_link_ops for BPF_TRACE_MAP
  bpf: Enable creation of BPF_LINK_TYPE_MAP_TRACE
  bpf: Add APIs to invoke tracing programs
  bpf: Register BPF_MAP_TRACE_{UPDATE,DELETE}_ELEM hooks
  libbpf: Support BPF_TRACE_MAP
  bpf: Add infinite loop check on map tracers
  Add bpf_map_trace_{update,delete}_elem() helper functions
  bpf: verifier inserts map tracing helper call
  bpf: Add selftests for map tracing
  bpf: Add real world example for map tracing

 include/linux/bpf.h                           |  48 ++-
 include/linux/bpf_types.h                     |   1 +
 include/uapi/linux/bpf.h                      |  22 +
 kernel/bpf/Makefile                           |   1 +
 kernel/bpf/helpers.c                          |  29 ++
 kernel/bpf/map_trace.c                        | 406 ++++++++++++++++++
 kernel/bpf/syscall.c                          |   7 +
 kernel/bpf/verifier.c                         |  81 +++-
 tools/include/uapi/linux/bpf.h                |  22 +
 tools/lib/bpf/bpf.c                           |  13 +-
 tools/lib/bpf/bpf.h                           |   4 +-
 tools/lib/bpf/libbpf.c                        | 118 +++++
 tools/lib/bpf/libbpf.h                        |  11 +
 tools/lib/bpf/libbpf.map                      |   1 +
 .../selftests/bpf/prog_tests/bpf_map_trace.c  | 401 +++++++++++++++++
 .../bpf/progs/bpf_map_trace_delete_elem.c     |  49 +++
 .../selftests/bpf/progs/bpf_map_trace_loop0.c |  26 ++
 .../selftests/bpf/progs/bpf_map_trace_loop1.c |  43 ++
 .../progs/bpf_map_trace_real_world_common.h   | 125 ++++++
 .../bpf_map_trace_real_world_migration.c      |  96 +++++
 .../bpf/progs/bpf_map_trace_real_world_new.c  |   4 +
 .../bpf/progs/bpf_map_trace_real_world_old.c  |   5 +
 .../bpf/progs/bpf_map_trace_update_elem.c     |  51 +++
 .../selftests/bpf/verifier/map_trace.c        |  40 ++
 24 files changed, 1592 insertions(+), 12 deletions(-)
 create mode 100644 kernel/bpf/map_trace.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_map_trace.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_map_trace_delete_elem.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_map_trace_loop0.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_map_trace_loop1.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_map_trace_real_world_common.h
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_map_trace_real_world_migration.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_map_trace_real_world_new.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_map_trace_real_world_old.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_map_trace_update_elem.c
 create mode 100644 tools/testing/selftests/bpf/verifier/map_trace.c

-- 
2.33.0.685.g46640cef36-goog

