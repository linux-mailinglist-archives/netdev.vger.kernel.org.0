Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FEAEECE40
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 12:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbfKBLJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Nov 2019 07:09:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47418 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726163AbfKBLJk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 2 Nov 2019 07:09:40 -0400
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com [209.85.208.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 07AF5A89F
        for <netdev@vger.kernel.org>; Sat,  2 Nov 2019 11:09:40 +0000 (UTC)
Received: by mail-lj1-f197.google.com with SMTP id q185so2331343ljb.20
        for <netdev@vger.kernel.org>; Sat, 02 Nov 2019 04:09:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=crMhP7Ubg42UXySn4m+6qCpOvj5+QATWbBPSLyYWZS0=;
        b=DNO5czIhkr2bi1HZpFewrLNaRdaNOiYQEPoeyNvWTBNBEpqwPNvjzdhbk5P6r8/WD+
         dyWSflULptQh4SuyPYzRWCtYIzwgV9vInVip3xIzihr0WTRM06OeghF0l64QCVzzgtx5
         YVqG5FqfvMKymbusG3fRzVoCRpbvNajQatO2DnAJAMsQYKxoC4sLm/JLDWtHpfLVHB0n
         Zgo8KNsoDAddNiXuM82ZZCNNqQY3/GfjwjqpNW+tJ/UC7y/kwwgj+onlz8oh5LS0LVow
         fC4NBh1bENoITBNQWps0k3OqpAiCpy2AJdeJVeh/jl5UfuZ1Wq7JDkDyosJ6RrLd33Zi
         p2og==
X-Gm-Message-State: APjAAAUOx7DOvy7O8ck30SADxq62FMljITnLGT5V61m0OkTQDTDK8/xF
        oikVJ5lMjsn910xFS6RqX9XbsBJSjSN5IaqVNUrry92jpnHRZQuO+QFCLQGzh87oTWRp9Zw0IcZ
        xHWKVWDS8aJ2L4CRH
X-Received: by 2002:a05:651c:1024:: with SMTP id w4mr11149131ljm.206.1572692978493;
        Sat, 02 Nov 2019 04:09:38 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzdNpE3eUgWA1SpBx5NjgReltnZVZePJJ/K7Fflr7KoyhqZanBOxtTD8ptuVGN/8yp0l4tMdg==
X-Received: by 2002:a05:651c:1024:: with SMTP id w4mr11149116ljm.206.1572692978287;
        Sat, 02 Nov 2019 04:09:38 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id y3sm3685050lfh.97.2019.11.02.04.09.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Nov 2019 04:09:37 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id AAF671818B5; Sat,  2 Nov 2019 12:09:36 +0100 (CET)
Subject: [PATCH bpf-next v6 0/5] libbpf: Support automatic pinning of maps
 using 'pinning' BTF attribute
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Sat, 02 Nov 2019 12:09:36 +0100
Message-ID: <157269297658.394725.10672376245672095901.stgit@toke.dk>
User-Agent: StGit/0.20
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support to libbpf for reading 'pinning' settings from BTF-based
map definitions. It introduces a new open option which can set the pinning path;
if no path is set, /sys/fs/bpf is used as the default. Callers can customise the
pinning between open and load by setting the pin path per map, and still get the
automatic reuse feature.

The semantics of the pinning is similar to the iproute2 "PIN_GLOBAL" setting,
and the eventual goal is to move the iproute2 implementation to be based on
libbpf and the functions introduced in this series.

Changelog:

v6:
  - Fix leak of struct bpf_object in selftest
  - Make struct bpf_map arg const in bpf_map__is_pinned() and bpf_map__get_pin_path()

v5:
  - Don't pin maps with pinning set, but with a value of LIBBPF_PIN_NONE
  - Add a few more selftests:
    - Should not pin map with pinning set, but value LIBBPF_PIN_NONE
    - Should fail to load a map with an invalid pinning value
    - Should fail to re-use maps with parameter mismatch
  - Alphabetise libbpf.map
  - Whitespace and typo fixes

v4:
  - Don't check key_type_id and value_type_id when checking for map reuse
    compatibility.
  - Move building of map->pin_path into init_user_btf_map()
  - Get rid of 'pinning' attribute in struct bpf_map
  - Make sure we also create parent directory on auto-pin (new patch 3).
  - Abort the selftest on error instead of attempting to continue.
  - Support unpinning all pinned maps with bpf_object__unpin_maps(obj, NULL)
  - Support pinning at map->pin_path with bpf_object__pin_maps(obj, NULL)
  - Make re-pinning a map at the same path a noop
  - Rename the open option to pin_root_path
  - Add a bunch more self-tests for pin_maps(NULL) and unpin_maps(NULL)
  - Fix a couple of smaller nits

v3:
  - Drop bpf_object__pin_maps_opts() and just use an open option to customise
    the pin path; also don't touch bpf_object__{un,}pin_maps()
  - Integrate pinning and reuse into bpf_object__create_maps() instead of having
    multiple loops though the map structure
  - Make errors in map reuse and pinning fatal to the load procedure
  - Add selftest to exercise pinning feature
  - Rebase series to latest bpf-next

v2:
  - Drop patch that adds mounting of bpffs
  - Only support a single value of the pinning attribute
  - Add patch to fixup error handling in reuse_fd()
  - Implement the full automatic pinning and map reuse logic on load

---

Toke Høiland-Jørgensen (5):
      libbpf: Fix error handling in bpf_map__reuse_fd()
      libbpf: Store map pin path and status in struct bpf_map
      libbpf: Move directory creation into _pin() functions
      libbpf: Add auto-pinning of maps when loading BPF objects
      selftests: Add tests for automatic map pinning


 tools/lib/bpf/bpf_helpers.h                        |    6 
 tools/lib/bpf/libbpf.c                             |  385 ++++++++++++++++----
 tools/lib/bpf/libbpf.h                             |   21 +
 tools/lib/bpf/libbpf.map                           |    3 
 tools/testing/selftests/bpf/prog_tests/pinning.c   |  210 +++++++++++
 tools/testing/selftests/bpf/progs/test_pinning.c   |   31 ++
 .../selftests/bpf/progs/test_pinning_invalid.c     |   16 +
 7 files changed, 591 insertions(+), 81 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/pinning.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_pinning.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_pinning_invalid.c

