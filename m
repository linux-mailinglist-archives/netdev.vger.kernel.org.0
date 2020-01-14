Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D086313AFE9
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 17:47:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728890AbgANQqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 11:46:36 -0500
Received: from mail-pl1-f202.google.com ([209.85.214.202]:54232 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728874AbgANQqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 11:46:35 -0500
Received: by mail-pl1-f202.google.com with SMTP id m4so5367863pls.20
        for <netdev@vger.kernel.org>; Tue, 14 Jan 2020 08:46:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Y5paa4AX/DtiLn+XUHqwYVRo7c1ie192vd9rP9qKaQo=;
        b=N9fADKpD0r9H67g2GPg3lDqgyoOfXJ8fqkefx5tT9gD6k1n1ANE1BcES4cW6eSVSL9
         m+mHNzJRVgEZS2iHDBajZL7jTWuBsnomJVrGNzqSjNAcbpbfc28gOJiWeOuf8v+RpdyC
         YEbKbD3B6s6a6emwyWBU+a2sAg273K8jbVDUaju/k9cIhXGUMurcMo4RmOW0pskS8Tvv
         mzKHKBn/LykPk70TiHrKaxE7pkc60BF+jRKWehBV9fd7ewxx1sv3NGEgGumWizqgmBeQ
         v4rYFbMsfGhSJUubHXCdH8TgiilWkeiptjsmMBhOxcQoq0uEwWs7Nwhyt2Fui2hoAiHG
         eBKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Y5paa4AX/DtiLn+XUHqwYVRo7c1ie192vd9rP9qKaQo=;
        b=UkwNzkaevD46PkC9pulyTzGSwvlbUivuTYrKg3+gGfa5YnvugdP+qWPxOXV7FUixtp
         xz4qqNTZxKnWCUU3giVccuHceFncrZKq8MthJKb49wHuD9+Gq3qEc15H4KhvXr+lYbTE
         sxeLUcPAgobb+Xh7H+L0ciNz1g9uTpMTTIa/9qeEI22FU2keaQ42Lk9WIr1iQffwyOv8
         WAY+Ka4FXrvtAxzfDl/jRAZW2h90G98VfHARYGtNV+jmPJ/enpKfV1vAoeuMdetYNsF4
         E7gU3ztgpuFR2dCTx8gjyTbEhpRzkaQUKkGrdehLpUYE52Fk22pP1rscKOoMTqE2ezMs
         amOQ==
X-Gm-Message-State: APjAAAVKjcbUY08E8YwYZsIbKYLgJ7VcUaze/1GygFBOMzz3VeyD9Kzi
        g/mt9vHJ3g5PWUzVZ0qqKqvY69YiLRqc
X-Google-Smtp-Source: APXvYqzONT7nLLWPpiU9vD9Wp+N2yEKNO5DIOd5gU9RA8R5M3Deo/90nrxFN27n0MUo+5JWiD7QC2wZsDKqu
X-Received: by 2002:a63:303:: with SMTP id 3mr27857755pgd.372.1579020394568;
 Tue, 14 Jan 2020 08:46:34 -0800 (PST)
Date:   Tue, 14 Jan 2020 08:46:04 -0800
Message-Id: <20200114164614.47029-1-brianvv@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.rc1.283.g88dfdc4193-goog
Subject: [PATCH v4 bpf-next 0/9] add bpf batch ops to process more than 1 elem
From:   Brian Vazquez <brianvv@google.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Brian Vazquez <brianvv@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series introduce batch ops that can be added to bpf maps to
lookup/lookup_and_delete/update/delete more than 1 element at the time,
this is specially useful when syscall overhead is a problem and in case
of hmap it will provide a reliable way of traversing them.

The implementation inclues a generic approach that could potentially be
used by any bpf map and adds it to arraymap, it also includes the specific
implementation of hashmaps which are traversed using buckets instead
of keys.

The bpf syscall subcommands introduced are:

  BPF_MAP_LOOKUP_BATCH
  BPF_MAP_LOOKUP_AND_DELETE_BATCH
  BPF_MAP_UPDATE_BATCH
  BPF_MAP_DELETE_BATCH

The UAPI attribute is:

  struct { /* struct used by BPF_MAP_*_BATCH commands */
         __aligned_u64   in_batch;       /* start batch,
                                          * NULL to start from beginning
                                          */
         __aligned_u64   out_batch;      /* output: next start batch */
         __aligned_u64   keys;
         __aligned_u64   values;
         __u32           count;          /* input/output:
                                          * input: # of key/value
                                          * elements
                                          * output: # of filled elements
                                          */
         __u32           map_fd;
         __u64           elem_flags;
         __u64           flags;
  } batch;


in_batch and out_batch are only used for lookup and lookup_and_delete since
those are the only two operations that attempt to traverse the map.

update/delete batch ops should provide the keys/values that user wants
to modify.

Here are the previous discussions on the batch processing:
 - https://lore.kernel.org/bpf/20190724165803.87470-1-brianvv@google.com/
 - https://lore.kernel.org/bpf/20190829064502.2750303-1-yhs@fb.com/
 - https://lore.kernel.org/bpf/20190906225434.3635421-1-yhs@fb.com/

Changelog sinve v3:
 - Do not use copy_to_user inside atomic region (Yonghong Song)
 - Use _opts approach on libbpf APIs (Andrii Nakryiko)
 - Drop generic_map_lookup_and_delete_batch support
 - Free malloc-ed memory in tests (Yonghong Song)
 - Reverse christmas tree (Yonghong Song)
 - Add acked labels

Changelog sinve v2:
 - Add generic batch support for lpm_trie and test it (Yonghong Song)
 - Use define MAP_LOOKUP_RETRIES for retries (John Fastabend)
 - Return errors directly and remove labels (Yonghong Song)
 - Insert new API functions into libbpf alphabetically (Yonghong Song)
 - Change hlist_nulls_for_each_entry_rcu to
   hlist_nulls_for_each_entry_safe in htab batch ops (Yonghong Song)

Changelog since v1:
 - Fix SOB ordering and remove Co-authored-by tag (Alexei Starovoitov)

Changelog since RFC:
 - Change batch to in_batch and out_batch to support more flexible opaque
   values to iterate the bpf maps.
 - Remove update/delete specific batch ops for htab and use the generic
   implementations instead.

Brian Vazquez (5):
  bpf: add bpf_map_{value_size,update_value,map_copy_value} functions
  bpf: add generic support for lookup batch op
  bpf: add generic support for update and delete batch ops
  bpf: add lookup and update batch ops to arraymap
  selftests/bpf: add batch ops testing to array bpf map

Yonghong Song (4):
  bpf: add batch ops to all htab bpf map
  tools/bpf: sync uapi header bpf.h
  libbpf: add libbpf support to batch ops
  selftests/bpf: add batch ops testing for htab and htab_percpu map

 include/linux/bpf.h                           |  18 +
 include/uapi/linux/bpf.h                      |  21 +
 kernel/bpf/arraymap.c                         |   2 +
 kernel/bpf/hashtab.c                          | 258 +++++++++
 kernel/bpf/syscall.c                          | 548 ++++++++++++++----
 tools/include/uapi/linux/bpf.h                |  21 +
 tools/lib/bpf/bpf.c                           |  60 ++
 tools/lib/bpf/bpf.h                           |  22 +
 tools/lib/bpf/libbpf.map                      |   4 +
 .../bpf/map_tests/array_map_batch_ops.c       | 131 +++++
 .../bpf/map_tests/htab_map_batch_ops.c        | 285 +++++++++
 11 files changed, 1242 insertions(+), 128 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/map_tests/array_map_batch_ops.c
 create mode 100644 tools/testing/selftests/bpf/map_tests/htab_map_batch_ops.c

-- 
2.25.0.rc1.283.g88dfdc4193-goog

