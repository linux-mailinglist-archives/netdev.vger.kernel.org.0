Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B21411BFD0
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 23:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbfLKWeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 17:34:09 -0500
Received: from mail-pl1-f201.google.com ([209.85.214.201]:40636 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726404AbfLKWeI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 17:34:08 -0500
Received: by mail-pl1-f201.google.com with SMTP id o12so203775pll.7
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 14:34:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=7ijxfaNlMj4qkP2wK7qiyfpUIttfUVcdL6s+H3bAfgM=;
        b=C4dXYq2UNwyTBGI4U0bauSxXbOpRXVhlUzgmFzgmbB/SZMRQg54x4GGbJIg492KUnE
         p1SkuqlWe20pcwLxJgZ0gL1pRg9iiwuy/C+J5GiCUgxJlS8VZIH/3e5UMEETC4uZbn6N
         c0JA36BU0apkX763JG6qu8wEjJnTxGeWixDJE+bPh4DQjD51AK5WtzAN/bRGYy6r+PZ5
         63eI83o1skB3e/+Cb/tOJ/RBq4xDz6W9iErwjv9xgzArErCxpO/s5FQD0K1aoUQywtzc
         f0Cias4Jw/lOhjS1iY/VrsTeLS9NWBMwl+LxfyVqvYpcZ4lrTCpgIAgO6NjO0RUxUpyC
         LsUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=7ijxfaNlMj4qkP2wK7qiyfpUIttfUVcdL6s+H3bAfgM=;
        b=HhMeMavUeBvW4sXiqr3BllxEWZoeZnDHh3kuupGPkQKLhqaE+3d6OPl0jrni+0KK7g
         1ZolFpY3EWTiiGVtZf7jKj2ygwxFNX7yxPPZpykm0NhPivJWvmP+9yaVURNYfGHEWqNF
         NPUlsa459md8qdvPlKkQv3i6HIejWh14PY7M3GieYhGzAjO0UNAqvcrqI3aQm2UF6tAo
         S0AeRpwAeu9Mxsi5OQGo7b8pEW7el5bEOmozi0SIaoaDRpxY1Ywg1pWiBzJy/mMdqYfe
         A/oRsZZAAlSfr/OlWL/6m1ZoGLfoCw7pcvh9wqTplwHKta07TLh4/Q6G0XXHxugw0fAt
         T6GA==
X-Gm-Message-State: APjAAAWAWQHYIeB2xKTYHrVumk8Yyza4ptszCelbTZRxzKi+pk32sfxX
        4jt4eZGTpij1qDTdMRfyfzczhd0DHZO7
X-Google-Smtp-Source: APXvYqy2U/Fr/JiD6HSj0oj5vwPWZMh+kH9t1DkKuuAONvQ53YQ1ZpoAIDRUQsdQ6FFTDDWQu5BQF5rBSMq6
X-Received: by 2002:a63:1c1f:: with SMTP id c31mr6745147pgc.292.1576103647800;
 Wed, 11 Dec 2019 14:34:07 -0800 (PST)
Date:   Wed, 11 Dec 2019 14:33:33 -0800
Message-Id: <20191211223344.165549-1-brianvv@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
Subject: [PATCH v3 bpf-next 00/11] add bpf batch ops to process more than 1 elem
From:   Brian Vazquez <brianvv@google.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Brian Vazquez <brianvv@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Yonghong Song <yhs@fb.com>, Stanislav Fomichev <sdf@google.com>,
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

Brian Vazquez (7):
  bpf: add bpf_map_{value_size,update_value,map_copy_value} functions
  bpf: add generic support for lookup and lookup_and_delete batch ops
  bpf: add generic support for update and delete batch ops
  bpf: add lookup and updated batch ops to arraymap
  bpf: add generic_batch_ops to lpm_trie map
  selftests/bpf: add batch ops testing to array bpf map
  selftests/bpf: add batch ops testing to lpm_trie bpf map

Yonghong Song (4):
  bpf: add batch ops to all htab bpf map
  tools/bpf: sync uapi header bpf.h
  libbpf: add libbpf support to batch ops
  selftests/bpf: add batch ops testing for htab and htab_percpu map

 include/linux/bpf.h                           |  21 +
 include/uapi/linux/bpf.h                      |  21 +
 kernel/bpf/arraymap.c                         |   2 +
 kernel/bpf/hashtab.c                          | 242 ++++++++
 kernel/bpf/lpm_trie.c                         |   4 +
 kernel/bpf/syscall.c                          | 562 ++++++++++++++----
 tools/include/uapi/linux/bpf.h                |  21 +
 tools/lib/bpf/bpf.c                           |  61 ++
 tools/lib/bpf/bpf.h                           |  14 +
 tools/lib/bpf/libbpf.map                      |   4 +
 .../bpf/map_tests/array_map_batch_ops.c       | 119 ++++
 .../bpf/map_tests/htab_map_batch_ops.c        | 269 +++++++++
 .../bpf/map_tests/trie_map_batch_ops.c        | 235 ++++++++
 13 files changed, 1451 insertions(+), 124 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/map_tests/array_map_batch_ops.c
 create mode 100644 tools/testing/selftests/bpf/map_tests/htab_map_batch_ops.c
 create mode 100644 tools/testing/selftests/bpf/map_tests/trie_map_batch_ops.c

-- 
2.24.1.735.g03f4e72817-goog

