Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC6DB26B591
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 01:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbgIOXrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 19:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727392AbgIOXpt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 19:45:49 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC250C061788
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 16:45:46 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id r8so2805959pgh.1
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 16:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=r8rRmnEAd1NddyGRWap+n0KLz/2/lzgpY3nyndN3gr8=;
        b=HidJpBK7XMBHDarPCeDAPFsUrbiY3AoOAJLZLWS1YYj0NUFV20RZycKBaxn7YLyO0R
         HrtGyhdwKp4cnoShRSDrfDGjNV1ISRIxL7vTXkxqLHgYHVFW2xKcKBpGMyBCJQyPed/G
         75kcxJYO62pfRAPdQqObPmVhr1jZsG9rghgdD7RmjLI6CbLa5UuiMERLb18OGlgWuuxW
         sRROauRDeFCWzfphzT838wbp6ul9RWK8gP89Yaea4pEIyPRSjpTzioac3PgyAW/x2yi4
         aRkVk/sN+sGRoFOFG/eaFtSAvRW65l9mojiIHMkJkX7XWcNiVS4rnelze095Bzd0UWOr
         qwzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc:content-transfer-encoding;
        bh=r8rRmnEAd1NddyGRWap+n0KLz/2/lzgpY3nyndN3gr8=;
        b=kcY0hnvnO3477o1Go1hicoLXva2Ga+vaR9ltnMeffKYz6k/AuTpKmhuNdh3fV4PC/F
         1xN1Lqum+/QCgtFUHtaeIGxSezrtUGsean4MjfDFJ8zIF6nJdw/+2cMEQba2ebaZwXJH
         tN4Ob9UXN6PykxqRP3vaab0Uws1wYQLtSsuJg5MHKirl7rZqBIWbovwJJqSNb37MPIKC
         XKgw3G4nXI9q/81aPYVWeOuooFKK6xgMvP7x/idkfa1NcpVgwHfnINUbYrhPmEGMf57R
         iw8QhKnUMxoZ9Kv0Z8lSMUEod5rr6Pb76CvzXYYGqcrHTB9DjP1HMf9gPd/6lOAqeTuQ
         F6tQ==
X-Gm-Message-State: AOAM5315nTx4SW1lSH1jQHlIfNvN0BwU2ZEyG3uFQLHgfM8EbqHkL1Rs
        cGhbDM+6eTze72K2DNO4eayq0Pxq075TaxnE5v68+MQkkLUkwkPxpnM1XdoRWcPcRVHysIuDdh4
        nVfMt41fc1fL/+SR/pndG3k4vC3yHUI1p+WT60p+/PJ5QXjL81/ZGDw==
X-Google-Smtp-Source: ABdhPJyoi+I1/58iVr2ohQ5vxbNyCkOOiQ3tUtpzo0N3lOezntqxxorre5+fPIx2dxaXF3PZgM/K25Y=
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:7220:84ff:fe09:7732])
 (user=sdf job=sendgmr) by 2002:a17:902:b20d:b029:d0:92cc:a1dd with SMTP id
 t13-20020a170902b20db02900d092cca1ddmr21220341plr.12.1600213545027; Tue, 15
 Sep 2020 16:45:45 -0700 (PDT)
Date:   Tue, 15 Sep 2020 16:45:38 -0700
Message-Id: <20200915234543.3220146-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [PATCH bpf-next v6 0/5] Allow storage of flexible metadata
 information for eBPF programs
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        YiFei Zhu <zhuyifei1999@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, if a user wants to store arbitrary metadata for an eBPF
program, for example, the program build commit hash or version, they
could store it in a map, and conveniently libbpf uses .data section to
populate an internal map. However, if the program does not actually
reference the map, then the map would be de-refcounted and freed.

This patch set introduces a new syscall BPF_PROG_BIND_MAP to add a map
to a program's used_maps, even if the program instructions does not
reference the map.

libbpf is extended to always BPF_PROG_BIND_MAP .rodata section so the
metadata is kept in place.
bpftool is also extended to print metadata in the 'bpftool prog' list.

The variable is considered metadata if it starts with the
magic 'bpf_metadata_' prefix; everything after the prefix is the
metadata name.

An example use of this would be BPF C file declaring:

  volatile const char bpf_metadata_commit_hash[] SEC(".rodata") =3D "abcdef=
123456";

and bpftool would emit:

  $ bpftool prog
  [...]
        metadata:
                commit_hash =3D "abcdef123456"

v6 changes:
* libbpf: drop FEAT_GLOBAL_DATA from probe_prog_bind_map (Andrii Nakryiko)
* bpftool: combine find_metadata_map_id & find_metadata;
  drops extra bpf_map_get_fd_by_id and bpf_map_get_fd_by_id (Andrii Nakryik=
o)
* bpftool: use strncmp instead of strstr (Andrii Nakryiko)
* bpftool: memset(map_info) and extra empty line (Andrii Nakryiko)

v5 changes:
* selftest: verify that prog holds rodata (Andrii Nakryiko)
* selftest: use volatile for metadata (Andrii Nakryiko)
* bpftool: use sizeof in BPF_METADATA_PREFIX_LEN (Andrii Nakryiko)
* bpftool: new find_metadata that does map lookup (Andrii Nakryiko)
* libbpf: don't generalize probe_create_global_data (Andrii Nakryiko)
* libbpf: use OPTS_VALID in bpf_prog_bind_map (Andrii Nakryiko)
* libbpf: keep LIBBPF_0.2.0 sorted (Andrii Nakryiko)

v4 changes:
* Don't return EEXIST from syscall if already bound (Andrii Nakryiko)
* Removed --metadata argument (Andrii Nakryiko)
* Removed custom .metadata section (Alexei Starovoitov)
* Addressed Andrii's suggestions about btf helpers and vsi (Andrii Nakryiko=
)
* Moved bpf_prog_find_metadata into bpftool (Alexei Starovoitov)

v3 changes:
* API changes for bpf_prog_find_metadata (Toke H=C3=B8iland-J=C3=B8rgensen)

v2 changes:
* Made struct bpf_prog_bind_opts in libbpf so flags is optional.
* Deduped probe_kern_global_data and probe_prog_bind_map into a common
  helper.
* Added comment regarding why EEXIST is ignored in libbpf bind map.
* Froze all LIBBPF_MAP_METADATA internal maps.
* Moved bpf_prog_bind_map into new LIBBPF_0.1.1 in libbpf.map.
* Added p_err() calls on error cases in bpftool show_prog_metadata.
* Reverse christmas tree coding style in bpftool show_prog_metadata.
* Made bpftool gen skeleton recognize .metadata as an internal map and
  generate datasec definition in skeleton.
* Added C test using skeleton to see asset that the metadata is what we
  expect and rebinding causes EEXIST.

v1 changes:
* Fixed a few missing unlocks, and missing close while iterating map fds.
* Move mutex initialization to right after prog aux allocation, and mutex
  destroy to right after prog aux free.
* s/ADD_MAP/BIND_MAP/
* Use mutex only instead of RCU to protect the used_map array & count.

Cc: YiFei Zhu <zhuyifei1999@gmail.com>

YiFei Zhu (5):
  bpf: Mutex protect used_maps array and count
  bpf: Add BPF_PROG_BIND_MAP syscall
  libbpf: Add BPF_PROG_BIND_MAP syscall and use it on .rodata section
  bpftool: support dumping metadata
  selftests/bpf: Test load and dump metadata with btftool and skel

 .../net/ethernet/netronome/nfp/bpf/offload.c  |  18 +-
 include/linux/bpf.h                           |   1 +
 include/uapi/linux/bpf.h                      |   7 +
 kernel/bpf/core.c                             |  15 +-
 kernel/bpf/syscall.c                          |  79 ++++++-
 net/core/dev.c                                |  11 +-
 tools/bpf/bpftool/json_writer.c               |   6 +
 tools/bpf/bpftool/json_writer.h               |   3 +
 tools/bpf/bpftool/prog.c                      | 199 ++++++++++++++++++
 tools/include/uapi/linux/bpf.h                |   7 +
 tools/lib/bpf/bpf.c                           |  16 ++
 tools/lib/bpf/bpf.h                           |   8 +
 tools/lib/bpf/libbpf.c                        |  69 ++++++
 tools/lib/bpf/libbpf.map                      |   1 +
 tools/testing/selftests/bpf/Makefile          |   3 +-
 .../selftests/bpf/prog_tests/metadata.c       | 141 +++++++++++++
 .../selftests/bpf/progs/metadata_unused.c     |  15 ++
 .../selftests/bpf/progs/metadata_used.c       |  15 ++
 .../selftests/bpf/test_bpftool_metadata.sh    |  82 ++++++++
 19 files changed, 678 insertions(+), 18 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/metadata.c
 create mode 100644 tools/testing/selftests/bpf/progs/metadata_unused.c
 create mode 100644 tools/testing/selftests/bpf/progs/metadata_used.c
 create mode 100755 tools/testing/selftests/bpf/test_bpftool_metadata.sh

--=20
2.28.0.618.gf4bc123cb7-goog

