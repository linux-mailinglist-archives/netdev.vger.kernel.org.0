Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0517655807
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 21:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728743AbfFYTmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 15:42:47 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45213 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728025AbfFYTmq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 15:42:46 -0400
Received: by mail-wr1-f66.google.com with SMTP id f9so19187323wre.12
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 12:42:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3+Aquffi6xxyr2CyeenmJhaPhlacoKT7JNxgCsVZjdM=;
        b=BSQDQqMm8sb1BTXcXTrqwQh+SMGC7m9pXyV3wQvB5Gjrb5n/ktfkOIsdMmAwQwTisI
         qCWqRtzXPzxb09UZDgNJ2FypL0hPXXtLG0tOZs+VoKPqa+Gp8fes0G7m1mVrK3tYDJpo
         ppgBuAxTKofatCFe3a++O2OxF8RREYOk0oP80=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3+Aquffi6xxyr2CyeenmJhaPhlacoKT7JNxgCsVZjdM=;
        b=oaNdcZAnmw7xkM6Zlqj93fGPqiS722Ad1ieRNrZBVWKIY6SYRf6dik2RMGMQ5HXg9q
         E/JeKjzrcNLRoMgI8oP7rffrQXNDtan04luCuLRqW59AVmLDbFNW4VqKx3asVHKX8Alb
         3vymDPD7sxhk8n0cfsNd7IueQUu8qG6ecCU3tqdO5tWyefpcIXXQw8x9Ixp9HeEkVZJf
         6iKChSkrNnJqCqTVLP0hX1zWIbFkzayUO0jQlX6gq1vwFhys7qdZCA9pTqSBMf4azdJ/
         hIkcY+yv4Zn+ITYitP05Q3doTJDmQV86YMtELDGfxxvSvaFqqoBesPkeW8+xIygz9yKp
         2X0A==
X-Gm-Message-State: APjAAAVk858ysoWI/sfv53C3WJiKn9CQ7kIPW0CleHTGMPk9XKwQmh1P
        cj3fP9bq65tbYdk0FhLrPScE0NqH3zcZag==
X-Google-Smtp-Source: APXvYqxHguYSUA9u++NldJHYoA2g0cCl4GyrVhK5+i2Xaz1jraP699TP344NGZb/QSYRFXoxIhce2g==
X-Received: by 2002:a5d:5283:: with SMTP id c3mr1196405wrv.268.1561491764769;
        Tue, 25 Jun 2019 12:42:44 -0700 (PDT)
Received: from localhost.localdomain (ip5f5aedb6.dynamic.kabel-deutschland.de. [95.90.237.182])
        by smtp.gmail.com with ESMTPSA id q193sm84991wme.8.2019.06.25.12.42.43
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 12:42:43 -0700 (PDT)
From:   Krzesimir Nowak <krzesimir@kinvolk.io>
To:     netdev@vger.kernel.org
Cc:     Alban Crequy <alban@kinvolk.io>,
        =?UTF-8?q?Iago=20L=C3=B3pez=20Galeiras?= <iago@kinvolk.io>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Krzesimir Nowak <krzesimir@kinvolk.io>
Subject: [bpf-next v2 00/10] Test the 32bit narrow reads
Date:   Tue, 25 Jun 2019 21:42:05 +0200
Message-Id: <20190625194215.14927-1-krzesimir@kinvolk.io>
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

4. Adding ctx stuff to struct bpf_test (patch 5).

5. Some tools headers syncing (patches 6 and 7).

6. Implement bpf_prog_test_run for perf event programs and test it
   (patches 8 and 9).


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

Krzesimir Nowak (10):
  selftests/bpf: Print a message when tester could not run a program
  selftests/bpf: Avoid a clobbering of errno
  selftests/bpf: Avoid another case of errno clobbering
  selftests/bpf: Use bpf_prog_test_run_xattr
  selftests/bpf: Allow passing more information to BPF prog test run
  tools headers: Adopt compiletime_assert from kernel sources
  tools headers: sync struct bpf_perf_event_data
  bpf: Implement bpf_prog_test_run for perf event programs
  selftests/bpf: Add tests for bpf_prog_test_run for perf events progs
  selftests/bpf: Test correctness of narrow 32bit read on 64bit field

 kernel/trace/bpf_trace.c                      | 107 +++++++++++
 tools/include/linux/compiler.h                |  28 +++
 tools/include/uapi/linux/bpf_perf_event.h     |   1 +
 tools/testing/selftests/bpf/test_verifier.c   | 172 ++++++++++++++++--
 .../selftests/bpf/verifier/perf_event_run.c   |  93 ++++++++++
 .../bpf/verifier/perf_event_sample_period.c   |   8 +
 .../testing/selftests/bpf/verifier/var_off.c  |  20 ++
 7 files changed, 414 insertions(+), 15 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/verifier/perf_event_run.c

-- 
2.20.1

