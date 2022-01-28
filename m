Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32E2C4A03B7
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 23:33:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351706AbiA1Wda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 17:33:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351701AbiA1Wda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 17:33:30 -0500
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 059B4C061714
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 14:33:30 -0800 (PST)
Received: by mail-qk1-x732.google.com with SMTP id 71so6914970qkf.4
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 14:33:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ofa1ZPh7IyV0aVXuAj6kXq/cJHpIUcIeYq4Vw4IfdQ4=;
        b=dBWSOqfS8hAUs6gpy8qLoJ3At8PQjbVR+FabfSJToucq3HsGLW9A50+1k16MEuYkNW
         +UAPsKb+K+9tsfcFutJEcAhhMVZDNuhajaSP8LZQdKLhEeN8E+qBNMMj807VqNLw5Mgl
         A/6jb2693ZdghRrvdIYW9rOiv2/7ydHiil3w0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ofa1ZPh7IyV0aVXuAj6kXq/cJHpIUcIeYq4Vw4IfdQ4=;
        b=XxrqJOhNm0FconQNzuPQ1yjQvTfjuZ93XcExymOXj+pTDpZXRQ30K9wztk7p5rrNvi
         RcpgoxfCnUTBeb1JAWbk/tnd8BfxZQ9fU/Fg11L0cQXX6MBSwA81b8o6m6zM4SGUK61D
         q8DobdHxDJkDstFawN5b3r/7dBXWf4t46emwh0JWaaC2Bkk9q3UBK9OYqhaF3BZHiKmY
         gHV2ADoe35gvZMs1KnzjnR1aQJ8l3vIhbAxvjel8eNfhAci9m6x1+b3hX8XBKL3+TptX
         PrYl8e1TzKWN2ExZyDL1mAa0BkqVHXNcA8UQIKJWaje2afNVaK4YmbQOQQUgpnxSVEOx
         8mBw==
X-Gm-Message-State: AOAM533t3oBuWMnjOvLfeGiwbTCVOXoxufmnLzt64RHhnCVhBN+l1qiU
        KGEyd5oTpxiEGZ7EV9BGgBr9rpn/SSTfi7VU/gqlBuOSCssl1QXMi+clLmk36/CbN4WlgEhSZMJ
        20aQWgbYekzfIlHosCtaEmqUQiWCKNz3RQCrwpyJrd4xsPcW8hsh0bCQKgNOZUEY4ubpRBg==
X-Google-Smtp-Source: ABdhPJxizn+IluGvHGXs3r8vF2wbRy1AA1U01pB5k2a7XWmd6ErNx5hfxPcUm0lRJiUV1zjJt8IoHw==
X-Received: by 2002:a05:620a:4014:: with SMTP id h20mr4982105qko.275.1643409206718;
        Fri, 28 Jan 2022 14:33:26 -0800 (PST)
Received: from localhost.localdomain ([181.136.110.101])
        by smtp.gmail.com with ESMTPSA id i18sm3723972qka.80.2022.01.28.14.33.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 14:33:26 -0800 (PST)
From:   =?UTF-8?q?Mauricio=20V=C3=A1squez?= <mauricio@kinvolk.io>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Subject: [PATCH bpf-next v5 0/9] libbpf: Implement BTFGen
Date:   Fri, 28 Jan 2022 17:33:03 -0500
Message-Id: <20220128223312.1253169-1-mauricio@kinvolk.io>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CO-RE requires to have BTF information describing the kernel types in
order to perform the relocations. This is usually provided by the kernel
itself when it's configured with CONFIG_DEBUG_INFO_BTF. However, this
configuration is not enabled in all the distributions and it's not
available on kernels before 5.12.

It's possible to use CO-RE in kernels without CONFIG_DEBUG_INFO_BTF
support by providing the BTF information from an external source.
BTFHub[0] contains BTF files to each released kernel not supporting BTF,
for the most popular distributions.

Providing this BTF file for a given kernel has some challenges:
1. Each BTF file is a few MBs big, then it's not possible to ship the
eBPF program with all the BTF files needed to run in different kernels.
(The BTF files will be in the order of GBs if you want to support a high
number of kernels)
2. Downloading the BTF file for the current kernel at runtime delays the
start of the program and it's not always possible to reach an external
host to download such a file.

Providing the BTF file with the information about all the data types of
the kernel for running an eBPF program is an overkill in many of the
cases. Usually the eBPF programs access only some kernel fields.

This series implements BTFGen support in bpftool. This idea was
discussed during the "Towards truly portable eBPF"[1] presentation at
Linux Plumbers 2021.

There is a good example[2] on how to use BTFGen and BTFHub together
to generate multiple BTF files, to each existing/supported kernel,
tailored to one application. For example: a complex bpf object might
support nearly 400 kernels by having BTF files summing only 1.5 MB.

[0]: https://github.com/aquasecurity/btfhub/
[1]: https://www.youtube.com/watch?v=igJLKyP1lFk&t=2418s
[2]: https://github.com/aquasecurity/btfhub/tree/main/tools

Changelog:
v4 > v5:
- move some checks before invoking prog->obj->gen_loader
- use p_info() instead of printf()
- improve command output
- fix issue with record_relo_core()
- implement bash completion
- write man page
- implement some tests

v3 > v4:
- parse BTF and BTF.ext sections in bpftool and use
  bpf_core_calc_relo_insn() directly
- expose less internal details from libbpf to bpftool
- implement support for enum-based relocations
- split commits in a more granular way

v2 > v3:
- expose internal libbpf APIs to bpftool instead
- implement btfgen in bpftool
- drop btf__raw_data() from libbpf

v1 > v2:
- introduce bpf_object__prepare() and ‘record_core_relos’ to expose
  CO-RE relocations instead of bpf_object__reloc_info_gen()
- rename btf__save_to_file() to btf__raw_data()

v1: https://lore.kernel.org/bpf/20211027203727.208847-1-mauricio@kinvolk.io/
v2: https://lore.kernel.org/bpf/20211116164208.164245-1-mauricio@kinvolk.io/
v3: https://lore.kernel.org/bpf/20211217185654.311609-1-mauricio@kinvolk.io/
v4: https://lore.kernel.org/bpf/20220112142709.102423-1-mauricio@kinvolk.io/

Mauricio Vásquez (8):
  libbpf: Implement changes needed for BTFGen in bpftool
  bpftool: Add gen min_core_btf command
  bpftool: Implement btf_save_raw()
  bpftool: Add struct definitions and helpers for BTFGen
  bpftool: Implement btfgen()
  bpftool: Implement relocations recording for BTFGen
  bpftool: Implement btfgen_get_btf()
  selftest/bpf: Implement tests for bpftool gen min_core_btf

Rafael David Tinoco (1):
  bpftool: gen min_core_btf explanation and examples

 .../bpf/bpftool/Documentation/bpftool-gen.rst |  85 ++
 tools/bpf/bpftool/Makefile                    |   8 +-
 tools/bpf/bpftool/bash-completion/bpftool     |   6 +-
 tools/bpf/bpftool/gen.c                       | 836 +++++++++++++++++-
 tools/lib/bpf/libbpf.c                        |  44 +-
 tools/lib/bpf/libbpf_internal.h               |  12 +
 tools/testing/selftests/bpf/.gitignore        |   1 +
 tools/testing/selftests/bpf/Makefile          |   4 +-
 .../selftests/bpf/progs/btfgen_btf_source.c   |  12 +
 .../bpf/progs/btfgen_primitives_array.c       |  39 +
 .../bpf/progs/btfgen_primitives_struct.c      |  40 +
 .../bpf/progs/btfgen_primitives_struct2.c     |  44 +
 .../bpf/progs/btfgen_primitives_union.c       |  32 +
 tools/testing/selftests/bpf/test_bpftool.c    | 228 +++++
 14 files changed, 1367 insertions(+), 24 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/btfgen_btf_source.c
 create mode 100644 tools/testing/selftests/bpf/progs/btfgen_primitives_array.c
 create mode 100644 tools/testing/selftests/bpf/progs/btfgen_primitives_struct.c
 create mode 100644 tools/testing/selftests/bpf/progs/btfgen_primitives_struct2.c
 create mode 100644 tools/testing/selftests/bpf/progs/btfgen_primitives_union.c
 create mode 100644 tools/testing/selftests/bpf/test_bpftool.c

-- 
2.25.1

