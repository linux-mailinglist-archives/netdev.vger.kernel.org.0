Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 592E562669
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 18:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388248AbfGHQc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 12:32:57 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41678 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388152AbfGHQbt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 12:31:49 -0400
Received: by mail-wr1-f66.google.com with SMTP id c2so17832596wrm.8
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 09:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3v7kORJZf9psv+vA5sP8DDz4yEImqLDpanBLVAEtpNU=;
        b=h+vDB2GhO2QOH0ZIG4dCQmb5vRQ9v6u24r5+jkrep/I+SiggmwNdaTIVIz3NzF9zl7
         FsijVoW+As30PTmh3MEDhrWRipHg2nqc7cnPc+bilJDRsdyBubyYW9eS3A0zbnJmqp7s
         tGv3zVBa7/+8fJYPnzcxoqEoZ9OJRRINNVzC8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3v7kORJZf9psv+vA5sP8DDz4yEImqLDpanBLVAEtpNU=;
        b=sjRCIa+FPZK3XgUDo8vnEw8rb5mgMJMlLqOSMAAOc+gVJKpbmfRmmHV0tJuhrajw9i
         v7M+cGfa9BKGJPvQ3vyaCNhVJLhBfAUFsM0VryENBQXf7YOF6/gMQDggqpwqZd1rRrMu
         M2KYFZknZllQLGledY9LLuJc0Ps1p6c4XFy8UxPz69KE2YILuUfxl8X6Tjtu2Icpi3ea
         KqCFxOP6cZFh+BMfijIBY1/E+B6naRze+5PoFiHKZTW5YkogjiOLjAdoKAfM7mwWunnk
         IOrEL3+pu3SkMfceL43jgGdBQHTxzDI7+JZZkZs72T1u3CuQVBTAnmrUW8FPYc653pP+
         JnZw==
X-Gm-Message-State: APjAAAVC1NNGhYnhQjecgiKj6AnWq17NqJ4Fqxvt/y9foGhmV57tiuQS
        2eBBAP4ie6zJcuny7pgvmshb/A==
X-Google-Smtp-Source: APXvYqwP59KT50EM58K8Q4RqceI+LJyhV6rCtNfYHeHIqZFRu9Qe+ZURKr4E35fmQBJc7F8zSo4sQA==
X-Received: by 2002:a5d:53c2:: with SMTP id a2mr18587648wrw.8.1562603506249;
        Mon, 08 Jul 2019 09:31:46 -0700 (PDT)
Received: from localhost.localdomain (ip5f5aedbe.dynamic.kabel-deutschland.de. [95.90.237.190])
        by smtp.gmail.com with ESMTPSA id e6sm18255086wrw.23.2019.07.08.09.31.44
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 09:31:45 -0700 (PDT)
From:   Krzesimir Nowak <krzesimir@kinvolk.io>
To:     linux-kernel@vger.kernel.org
Cc:     Alban Crequy <alban@kinvolk.io>,
        =?UTF-8?q?Iago=20L=C3=B3pez=20Galeiras?= <iago@kinvolk.io>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, xdp-newbies@vger.kernel.org,
        Krzesimir Nowak <krzesimir@kinvolk.io>
Subject: [bpf-next v3 00/12] Test the 32bit narrow reads
Date:   Mon,  8 Jul 2019 18:31:09 +0200
Message-Id: <20190708163121.18477-1-krzesimir@kinvolk.io>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These patches try to test the fix made in commit e2f7fc0ac695 ("bpf:
fix undefined behavior in narrow load handling"). The problem existed
in the generated BPF bytecode that was doing a 32bit narrow read of a
64bit field, so to test it the code would need to be executed.
Currently the only such field exists in BPF_PROG_TYPE_PERF_EVENT,
which was not supported by bpf_prog_test_run().

I'm sending these patches to bpf-next now as they introduce a new
feature. But maybe some of those patches could go to the bpf branch?


There is a bit of yak shaving to do for the test to be run:

1. Print why the program could not be run (patch 1).

2. Some fixes for errno clobbering (patches 2 and 3).

3. Using bpf_prog_test_run_xattr, so I can pass ctx_in stuff too
   (patch 4).

4. Adding ctx stuff and data out size override to struct bpf_test, and
   use them for the perf event tests (patches 5 and 6).

5. Some tools headers syncing (patches 7 and 8).

6. Split out some useful functions for bpf_prog_test_run
   implementation out of the net/bpf/test_run.c (patch 9)

7. Implement bpf_prog_test_run for perf event programs and test it
   (patches 10 and 11).


The last point is where I'm least sure how things should be done
properly:

1. There is a bunch of stuff to prepare for the
   bpf_perf_prog_read_value to work, and that stuff is very hacky. I
   would welcome some hints about how to set up the perf_event and
   perf_sample_data structs in a way that is a bit more future-proof
   than just setting some fields in a specific way, so some other code
   won't use some other fields (like setting event.oncpu to -1 to
   avoid event.pmu to be used for reading the value of the event).

2. The tests try to see if the test run for perf event sets up the
   context properly, so they verify the struct pt_regs contents. They
   way it is currently written Works For Me, but surely it won't work
   on other arch. So what would be the way forward? Just put the test
   case inside #ifdef __x86_64__?

3. Another thing in tests - I'm trying to make sure that the
   bpf_perf_prog_read_value helper works as it seems to be the only
   bpf perf helper that takes the ctx as a parameter. Is that enough
   or I should test other helpers too?


About the test itself - I'm not sure if it will work on a big endian
machine. I think it should, but I don't have anything handy here to
verify it.

Krzesimir Nowak (12):
  selftests/bpf: Print a message when tester could not run a program
  selftests/bpf: Avoid a clobbering of errno
  selftests/bpf: Avoid another case of errno clobbering
  selftests/bpf: Use bpf_prog_test_run_xattr
  selftests/bpf: Allow passing more information to BPF prog test run
  selftests/bpf: Make sure that preexisting tests for perf event work
  tools headers: Adopt compiletime_assert from kernel sources
  tools headers: Sync struct bpf_perf_event_data
  bpf: Split out some helper functions
  bpf: Implement bpf_prog_test_run for perf event programs
  selftests/bpf: Add tests for bpf_prog_test_run for perf events progs
  selftests/bpf: Test correctness of narrow 32bit read on 64bit field

 include/linux/bpf.h                           |  28 ++
 kernel/bpf/Makefile                           |   1 +
 kernel/bpf/test_run.c                         | 212 ++++++++++++++
 kernel/trace/bpf_trace.c                      |  60 ++++
 net/bpf/test_run.c                            | 263 +++++-------------
 tools/include/linux/compiler.h                |  28 ++
 tools/include/uapi/linux/bpf_perf_event.h     |   1 +
 tools/testing/selftests/bpf/test_verifier.c   | 197 ++++++++++++-
 .../selftests/bpf/verifier/perf_event_run.c   |  96 +++++++
 .../bpf/verifier/perf_event_sample_period.c   |   4 +
 .../testing/selftests/bpf/verifier/var_off.c  |  21 ++
 11 files changed, 700 insertions(+), 211 deletions(-)
 create mode 100644 kernel/bpf/test_run.c
 create mode 100644 tools/testing/selftests/bpf/verifier/perf_event_run.c

-- 
2.20.1

