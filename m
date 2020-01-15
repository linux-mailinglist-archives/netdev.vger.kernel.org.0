Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0913A13CC4C
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 19:43:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729072AbgAOSnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 13:43:22 -0500
Received: from mail-pj1-f73.google.com ([209.85.216.73]:55910 "EHLO
        mail-pj1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbgAOSnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 13:43:22 -0500
Received: by mail-pj1-f73.google.com with SMTP id bg6so418340pjb.5
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 10:43:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=quGuCKW4EISGK4Hy3QkXGiA4O368RfnyVO/5mhv/zy0=;
        b=Y3cA+BWUSe9akT5omGsDbcfs51Z43HYfnbw4ChN9ZtZigtQkZQ6CaDsQx/0x/Ti7ef
         ffcFvdtz4TLUdDR6fzYYWyfV/0qzfWpqkLdV8Qklhpi7O/tagoRRpRntD/HElkizyrRL
         xQYZ3DtH3dtbOElyGa9/poaqWS8Sj+nQsfY1Y2E8juFusIp6HLwPy6F1YNexpBZ+hVdc
         7NQRIkD72A4DNQbUr+UkqSzUke1YeoNNhn4RCfErO8Mdcx9XO931ftK5PyCqF8L4t9JJ
         5lHacg5KeIe3WHBaHrFx3VjN0KSLeTNDcbktb2qwPb4Avk+X+YVNugBjtp0X6LIEwL31
         I+Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=quGuCKW4EISGK4Hy3QkXGiA4O368RfnyVO/5mhv/zy0=;
        b=bBlvMEWnfehHdMLuQCk8aG9vZEYHQNewq0E35ZG5oEwmopWX5nfjPjefY+dMnXwxdk
         Z3qVAdWZCwQNwey7VZnTzf/lCytwY62trHdpSEbat5pUXjw1cgxHiqZ8Zk1ojyfoq6r1
         zcTWmDWqGhOLICpaRRdWHLtH8an3uovC7Au8leyeV/k1HNtdYh10sxoSBbkBFDysDNFg
         JBisYQ6NVRjqM5+OIuDhVt3L0KX6aeQ2k9ebot8qgdlYi462IZU9luJidiF8EW3ETDYk
         DZr57CfCOw6ameCTWiFXU5hcOFERSc+o/kNHDR3Gxg5Nq1oNFTkiWlBav4WyN9GUVI8a
         Vs/Q==
X-Gm-Message-State: APjAAAW25LGFb8vyDXO1qhD5aK/lQomH012DKMfOOd2w0Gd6vWZblLeC
        2i8ycciqp2i/iGhOWPFIg5tSJ9qyI3k1
X-Google-Smtp-Source: APXvYqwnWiWJM3nIWopzaQLOFXUvYOBDJHYtnbHtV4I6g6NTAk1EW1MagpO1ixh0/8tS7jTs6Sfe6SL7vSQ9
X-Received: by 2002:a65:55cc:: with SMTP id k12mr35481833pgs.184.1579113801410;
 Wed, 15 Jan 2020 10:43:21 -0800 (PST)
Date:   Wed, 15 Jan 2020 10:42:59 -0800
Message-Id: <20200115184308.162644-1-brianvv@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.rc1.283.g88dfdc4193-goog
Subject: [PATCH v5 bpf-next 0/9] add bpf batch ops to process more than 1 elem
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

Changelog sinve v4:
 - Remove unnecessary checks from libbpf API (Andrii Nakryiko)
 - Move DECLARE_LIBBPF_OPTS with all var declarations (Andrii Nakryiko)
 - Change bucket internal buffer size to 5 entries (Yonghong Song)
 - Fix some minor bugs in hashtab batch ops implementation (Yonghong Song)

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
 kernel/bpf/hashtab.c                          | 264 +++++++++
 kernel/bpf/syscall.c                          | 554 ++++++++++++++----
 tools/include/uapi/linux/bpf.h                |  21 +
 tools/lib/bpf/bpf.c                           |  58 ++
 tools/lib/bpf/bpf.h                           |  22 +
 tools/lib/bpf/libbpf.map                      |   4 +
 .../bpf/map_tests/array_map_batch_ops.c       | 129 ++++
 .../bpf/map_tests/htab_map_batch_ops.c        | 283 +++++++++
 11 files changed, 1248 insertions(+), 128 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/map_tests/array_map_batch_ops.c
 create mode 100644 tools/testing/selftests/bpf/map_tests/htab_map_batch_ops.c

-- 
2.25.0.rc1.283.g88dfdc4193-goog

