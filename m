Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D90A41010DE
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 02:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbfKSBoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 20:44:06 -0500
Received: from mail-pl1-f202.google.com ([209.85.214.202]:48369 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727004AbfKSBoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 20:44:05 -0500
Received: by mail-pl1-f202.google.com with SMTP id q14so11354997plr.15
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 17:44:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=cGWE/qyVtF0Xm0XRgmS6v65MJoSNg2ouKO2ndi7seNg=;
        b=bY/KO6kxybSTMKllU0VSmuUp+hH40TarSc/VXouqS7EBfHj591iNMpKxkqYuVxFYHx
         RvL8p5NL+w33OCuaho+ZKJsPc4VJZuOx8JnxfZiYvZIu3CDdSIHY8/ep7GUTHBZQPKHv
         N6vRZOcQeGBrbAcztIl7TsIzRJeiQkfdPF3u3dTu2+vMg2A99GH/vkECiIa10i0L124M
         jcTZVaX0jLsElwKI6XDWBJVmHXRlzIYfEGjIkNfrKlU43Ixu4zekvM2oc4M/AGLTMoIn
         cIXJ50FH0992QNNkzwQ64vWbxzxzzaamsnZBqfoRrO0YmEmXORQz6zb/1yXwDM7Il87G
         FUEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=cGWE/qyVtF0Xm0XRgmS6v65MJoSNg2ouKO2ndi7seNg=;
        b=r04FrtiXxA60Y/Jn3fBG57aLoShLat2K/LySum6aM9NKcTI1P9x0vNB3S0TEOoz7ab
         n63B7UIAu+WSalq+NMAzgAiQ9YeAumMF99iQiq8zFoAU/NQMLvTEZu9Pq6D/U6iFLEiq
         MwwG0i0VLtD/uET531BnR2Jz9i3H6hNpsgawrJLZAEdQaRk0NDRLlSzRHF/dez9iZ4oT
         jlkkxtRTbwisLl9Ii5daS7gAzwHszp1FypDVxMw5LkcEjJWS+Jixo+rk1U6GbJOXIl9C
         2UAfv2y8MVV3Q01pfc79zKpMTxq3MvBTa6lbY23C+5oPJquFFZr35tqZ2sbsJ36JTrFc
         A9lg==
X-Gm-Message-State: APjAAAWsU8VhfjicMlTSEIELzKmz9DRKQteBQnG1Ei9eE9eWDbV+KbZ8
        jU6C59TR/PkAiZpMCuWGotZoEOaVUVlC
X-Google-Smtp-Source: APXvYqzp94KW+lXm0LZaQQNGcUtXuvrutP74p5xG+E2LoUBDzNYsDXea2jiZSeUfPgrKOo233sI5FDiQ+9Xu
X-Received: by 2002:a63:e26:: with SMTP id d38mr2621764pgl.44.1574127844187;
 Mon, 18 Nov 2019 17:44:04 -0800 (PST)
Date:   Mon, 18 Nov 2019 17:43:48 -0800
Message-Id: <20191119014357.98465-1-brianvv@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH bpf-next 0/9] add bpf batch ops to process more than 1 elem
From:   Brian Vazquez <brianvv@google.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Yonghong Song <yhs@fb.com>, Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Brian Vazquez <brianvv@google.com>
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

Changelog since RFC:
 - Change batch to in_batch and out_batch to support more flexible opaque
   values to iterate the bpf maps.
 - Remove update/delete specific batch ops for htab and use the generic
   implementations instead.

Brian Vazquez (6):
  bpf: add bpf_map_{value_size,update_value,map_copy_value} functions
  bpf: add generic support for lookup and lookup_and_delete batch ops
  bpf: add generic support for update and delete batch ops
  bpf: add lookup and updated batch ops to arraymap
  tools/bpf: sync uapi header bpf.h
  selftests/bpf: add batch ops testing to array bpf map

Yonghong Song (3):
  bpf: add batch ops to all htab bpf map
  libbpf: add libbpf support to batch ops
  selftests/bpf: add batch ops testing for hmap and hmap_percpu

 include/linux/bpf.h                           |  21 +
 include/uapi/linux/bpf.h                      |  21 +
 kernel/bpf/arraymap.c                         |   2 +
 kernel/bpf/hashtab.c                          | 244 ++++++++
 kernel/bpf/syscall.c                          | 571 ++++++++++++++----
 tools/include/uapi/linux/bpf.h                |  21 +
 tools/lib/bpf/bpf.c                           |  61 ++
 tools/lib/bpf/bpf.h                           |  14 +
 tools/lib/bpf/libbpf.map                      |   4 +
 .../map_lookup_and_delete_batch_array.c       | 119 ++++
 .../map_lookup_and_delete_batch_htab.c        | 257 ++++++++
 11 files changed, 1215 insertions(+), 120 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/map_tests/map_lookup_and_delete_batch_array.c
 create mode 100644 tools/testing/selftests/bpf/map_tests/map_lookup_and_delete_batch_htab.c

-- 
2.24.0.432.g9d3f5f5b63-goog

