Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00A8473458
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 18:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728321AbfGXQ6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 12:58:19 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:42980 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbfGXQ6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 12:58:19 -0400
Received: by mail-pg1-f202.google.com with SMTP id q10so5500096pgi.9
        for <netdev@vger.kernel.org>; Wed, 24 Jul 2019 09:58:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=6m5pZYRwQ/VLImDzwYssdUybUrVH4MZ+xdF6UGNAnzQ=;
        b=FQTT+XyX/59gFXT1uGFwGXtgUyjKf4iPsM32Sk9G7dinmYGnLj5i3YxJQtU8tzbl3K
         fwhzXeFXWn0VIXqHMCinq/2BuSH08UCWzLV1RhNs2sLV3K6hH4jBQs/6fNwFi/g+EKXR
         edlGI5m6uMpv4ChVdLz3GNY/yAFrgF63w7bCSpQpduHIbJ8i4GKo67HwDYWtHVc30uH2
         cHuLWQEAtdudgD5RySbzOO2htsNdMFjzNb5sD0lRZwmVsGSKHhc+cjH/B0sFOU6XO4MB
         0uVmd0DQzCI7Nlg93wUgjZRchVV0sPjtemJxHS6WjwuQVp1T4K0c/o2K1wYsWPyE4XZD
         OPxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=6m5pZYRwQ/VLImDzwYssdUybUrVH4MZ+xdF6UGNAnzQ=;
        b=ozccNynn+hI6qGzChh3uidagLbpojxDxB3fILvm4hQeNVc1T6dy6dxXd6RRpGqB3DI
         pLerh4/jtJaSuS4ZkddRGPmncldgs2C/dAkDMEI7igxYudD0mwBHpBGlyUDSvIyvIvKu
         /thnpuVxyUAxCsKNxAsAQtEB0zluXXBqUOmT1P1P2az3CrPPYnEig9O/LX1nUAHGi4E5
         EJ79A2sfoxjp/lb0T3rIRT6qSb2/63fGClW331hJDbkxsDPqPWo0WeA7XV1JFgoexDbk
         U90GpRk9yt7n8zEqqgQsb96pOv8QcolHSvgTues3nqQXMrMIxdv2QDIIiefZQ7S5pUyv
         3VCQ==
X-Gm-Message-State: APjAAAXXy/t3fGaxtkRuxkDdsHK/B1DHzJGKdyJtNc8AA+82klRpahT1
        nslTQHMY4O3+Nurl5rg85toZYb/a7TdW
X-Google-Smtp-Source: APXvYqz+p+xcj+020H6PKH7tPE0RHUStQ5VIaTQ18W/SgvXCVq97XWVBm/0xcPcAITrs8Or7z49zx7jJypgy
X-Received: by 2002:a63:a35e:: with SMTP id v30mr23431447pgn.129.1563987497938;
 Wed, 24 Jul 2019 09:58:17 -0700 (PDT)
Date:   Wed, 24 Jul 2019 09:57:57 -0700
Message-Id: <20190724165803.87470-1-brianvv@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.657.g960e92d24f-goog
Subject: [PATCH bpf-next 0/6] bpf: add BPF_MAP_DUMP command to dump more than
 one entry per call
From:   Brian Vazquez <brianvv@google.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Brian Vazquez <brianvv@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This introduces a new command to retrieve multiple number of entries
from a bpf map.

This new command can be executed from the existing BPF syscall as
follows:

err =  bpf(BPF_MAP_DUMP, union bpf_attr *attr, u32 size)
using attr->dump.map_fd, attr->dump.prev_key, attr->dump.buf,
attr->dump.buf_len
returns zero or negative error, and populates buf and buf_len on
succees

This implementation is wrapping the existing bpf methods:
map_get_next_key and map_lookup_elem

Note that this implementation can be extended later to do dump and
delete by extending map_lookup_and_delete_elem (currently it only works
for bpf queue/stack maps) and either use a new flag in map_dump or a new
command map_dump_and_delete. 

Results show that even with a 1-elem_size buffer, it runs ~40 faster
than the current implementation, improvements of ~85% are reported when
the buffer size is increased, although, after the buffer size is around
5% of the total number of entries there's no huge difference in
increasing it.

Tested:
Tried different size buffers to handle case where the bulk is bigger, or
the elements to retrieve are less than the existing ones, all runs read
a map of 100K entries. Below are the results(in ns) from the different
runs:

buf_len_1:       69038725 entry-by-entry: 112384424 improvement
38.569134
buf_len_2:       40897447 entry-by-entry: 111030546 improvement
63.165590
buf_len_230:     13652714 entry-by-entry: 111694058 improvement
87.776687
buf_len_5000:    13576271 entry-by-entry: 111101169 improvement
87.780263
buf_len_73000:   14694343 entry-by-entry: 111740162 improvement
86.849542
buf_len_100000:  13745969 entry-by-entry: 114151991 improvement
87.958187
buf_len_234567:  14329834 entry-by-entry: 114427589 improvement
87.476941

The series of patches are split as follows:

- First patch move some map_lookup_elem logic into 2 fucntions to
deduplicate code: bpf_map_value_size and bpf_map_copy_value
- Second patch introduce map_dump function
- Third patch syncs tools linux headers
- Fourth patch adds libbpf support
- Last two patches adds tests

RFC Changelog:

- remove wrong usage of attr.flags
- move map_fd to remove hole after it

v3:
- add explanation of the API in the commit message
- fix masked errors and return them to user
- copy last_key from return buf into prev_key if it was provided
- run perf test with kpti and retpoline mitigations

v2:
- use proper bpf-next tag

Brian Vazquez (6):
  bpf: add bpf_map_value_size and bp_map_copy_value helper functions
  bpf: add BPF_MAP_DUMP command to dump more than one entry per call
  bpf: keep bpf.h in sync with tools/
  libbpf: support BPF_MAP_DUMP command
  selftests/bpf: test BPF_MAP_DUMP command on a bpf hashmap
  selftests/bpf: add test to measure performance of BPF_MAP_DUMP

 include/uapi/linux/bpf.h                |   9 +
 kernel/bpf/syscall.c                    | 251 ++++++++++++++++++------
 tools/include/uapi/linux/bpf.h          |   9 +
 tools/lib/bpf/bpf.c                     |  28 +++
 tools/lib/bpf/bpf.h                     |   4 +
 tools/lib/bpf/libbpf.map                |   2 +
 tools/testing/selftests/bpf/test_maps.c | 148 +++++++++++++-
 7 files changed, 388 insertions(+), 63 deletions(-)

-- 
2.22.0.657.g960e92d24f-goog

