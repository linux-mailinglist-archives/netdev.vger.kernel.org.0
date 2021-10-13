Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7B742B928
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 09:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238457AbhJMHfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 03:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbhJMHfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 03:35:55 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F54C061570;
        Wed, 13 Oct 2021 00:33:52 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id t184so827304pfd.0;
        Wed, 13 Oct 2021 00:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+nmwqOnl5+n/Jt725RguUvYKQAV/3aBUyiXl2CRcip0=;
        b=jKcl69Tvdmh+6c8qgpNUy/ZJIt18V3Mc+rF/tMSPi+HdWyYDlsAgf1TAsCkEL0l3lp
         CUduRY7yqhbt7+z4xAY4OfeMyiVOI9COpfYIRlwvUbSs2haAQ5+Tr9GXMko7R5zuL84Y
         E6zkiPEIoiZlMoySmBZh6J3ZDEZPjkpirunDnCXspcZ3SizQ2VvazZxNGoghPw/2nvjh
         TWA0yGXIshvqv5z7EYtopaHQE2D/YAll6AXktDI1XkkFY1PBAtFJiQgjzj4cw80FOhIC
         tCjK7qbrJhAVlNrz/RDtC0Pf5Mo91yRNp3/rqk5h/4jkvlQPSUXeGR94ewS3/w09+4bM
         PXug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+nmwqOnl5+n/Jt725RguUvYKQAV/3aBUyiXl2CRcip0=;
        b=RyB+oTzvkJBk592T78eP4U7luWDkdr4V7tDIZTXugR2HlOpsTmRl8I8SrLGK85evaF
         a3WBo6Ed1BXoNtcd3XXVydP/VHxjFAAxJwFoxqD7RpKK4jISliEh3nZvbimlmcrTvUV0
         WlnnNazFg6VRpF1BU3Ql4eDUlHrYwxWcAdVClG5U+8+yVquSTeoMKztvC5LnaYGVCOqO
         oVrly5c9Ndga9g1nZqBZMd0IuYyQzHVt+asrsukxwv7fJWSRfxc2z1Evb7DlegCG7ePU
         uV+1mgMgLG6nwMTifR261ZyUH/4Mu+x6yhSzIYcLm1W1Qnynsyidy5h1CNFrb85kUeGB
         4FnQ==
X-Gm-Message-State: AOAM533uRPflQlMkJEZqJfOtx2YykS/AzfRmwsR/CenOxtqRRlEEnaS1
        qKERInmam5ZrRHQfHBGZutfP7v5B9J4=
X-Google-Smtp-Source: ABdhPJy6yeFo/pgRsTHO4qvmL4vZ621HO9Hk6Iv5fNHpoJVmE9iZJtpTJTxFkV3HRrxsy8Y5ggcz+Q==
X-Received: by 2002:a63:7456:: with SMTP id e22mr26533204pgn.324.1634110431489;
        Wed, 13 Oct 2021 00:33:51 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id r14sm13504111pgf.49.2021.10.13.00.33.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 00:33:51 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v2 0/8] Typeless/weak ksym for gen_loader + misc fixups
Date:   Wed, 13 Oct 2021 13:03:40 +0530
Message-Id: <20211013073348.1611155-1-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2941; h=from:subject; bh=icU/t9Ad7MttpuWi1i1voQsY1arWzPr+QVVZHBwOcyA=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhZovRgB4zT9lnp2BsptxDrvy4DOvpdWp8jgoX87Fj 6t9gHvGJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYWaL0QAKCRBM4MiGSL8RyvSsD/ 4qz5+/PQH01V5wSi+ZBvRuB4EUUBvFR1qbcvFzy+9jodACNeUwSZKykNom8yjskvinl6c7Aml6r8Ko dRwdOSjbV+WdJMZGjT8Krcrq3fKj+//m/5rKrjpHwQF9qJLdDZMi/9qxUF1m2wn94YPbFpoA8ty76b kq5eulPnfqzp9/ng9o8L+y84aFfDbf7L6xbT/DYW8iewsPIiLZVxIjugHT8zWmEKec7z1zDm8ZpXGE zTIk7A5OzCe0maTjapcpb3AJv7bGmpmOZ3JrdL3dIVgo2fHbUewzrCODYxtAYQu+xp3aE6jcoQl5Z1 T6+xMxpBc9pXITpVezY11mN6Qe1/Mm9vsQ7VLlc4SQrpwjgNB5qOmgL7wxvHGZQyqfGyJ+F5WTgU1L TqbTi4n8rOPySmJI+tJj7+1Ff7Boh35HN7cxvSRlbnfRdJHr9fn7tNHFgEPUYbxUjrsxgEmZpljGcG mWW8pnQWB+FGRT05rSOE5zleKuKOH0QiSqO0oFrG5C7g/hQ3gN7BsCjUCoUKnIhVk/7VPc0+24PtnN kHut+qCy89HsXGS2gbNLbCFfg/fjz75lSPTlZXlrIn0KINZJjYGzuoNb/JgVBnqKZlqoiKCCR2CFy6 uRlP9yjQB/eJcsYuQvuWHIzPmmIPvKeVPD0eHk2txJVRKI2BKec2YrPxhQIQ==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patches (1,2,3,6) add typeless and weak ksym support to gen_loader. It is follow
up for the recent kfunc from modules series.

The later patches (7,8) are misc fixes for selftests, and patch 4 for libbpf
where we try to be careful to not end up with fds == 0, as libbpf assumes in
various places that they are greater than 0. Patch 5 fixes up missing O_CLOEXEC
in libbpf.

Please look at patch 4 and 5 closely and whether I missed any other places that
need a change.

Changelog:
----------
v1 -> v2
v1: https://lore.kernel.org/bpf/20211006002853.308945-1-memxor@gmail.com

 * Remove redundant OOM checks in emit_bpf_kallsyms_lookup_name
 * Use designated initializer for sk_lookup fd array (Jakub)
 * Do fd check for all fd returning low level APIs (Andrii, Alexei)
 * Make Fixes: tag quote commit message, use selftests/bpf prefix (Song, Andrii)
 * Split typeless and weak ksym support into separate patches, expand commit
   message (Song)
 * Fix duplication in selftests stemming from use of LSKELS_EXTRA (Song)

Kumar Kartikeya Dwivedi (8):
  bpf: Add bpf_kallsyms_lookup_name helper
  libbpf: Add typeless ksym support to gen_loader
  libbpf: Add weak ksym support to gen_loader
  libbpf: Ensure that BPF syscall fds are never 0, 1, or 2
  libbpf: Use O_CLOEXEC uniformly when opening fds
  selftests/bpf: Add weak/typeless ksym test for light skeleton
  selftests/bpf: Fix fd cleanup in sk_lookup test
  selftests/bpf: Fix memory leak in test_ima

 include/linux/bpf.h                           |   1 +
 include/uapi/linux/bpf.h                      |  14 +++
 kernel/bpf/syscall.c                          |  24 ++++
 tools/include/uapi/linux/bpf.h                |  14 +++
 tools/lib/bpf/bpf.c                           |  28 ++---
 tools/lib/bpf/bpf_gen_internal.h              |  12 +-
 tools/lib/bpf/btf.c                           |   2 +-
 tools/lib/bpf/gen_loader.c                    | 119 ++++++++++++++++--
 tools/lib/bpf/libbpf.c                        |  53 ++++----
 tools/lib/bpf/libbpf_internal.h               |  23 ++++
 tools/lib/bpf/libbpf_probes.c                 |   2 +-
 tools/lib/bpf/linker.c                        |   4 +-
 tools/lib/bpf/ringbuf.c                       |   2 +-
 tools/lib/bpf/skel_internal.h                 |  34 ++++-
 tools/lib/bpf/xsk.c                           |   6 +-
 tools/testing/selftests/bpf/Makefile          |   7 +-
 .../selftests/bpf/prog_tests/ksyms_btf.c      |  35 +++++-
 .../selftests/bpf/prog_tests/ksyms_module.c   |  40 +++++-
 .../bpf/prog_tests/ksyms_module_libbpf.c      |  28 -----
 .../selftests/bpf/prog_tests/sk_lookup.c      |  14 ++-
 .../selftests/bpf/prog_tests/test_ima.c       |   3 +-
 .../selftests/bpf/progs/test_ksyms_weak.c     |   3 +-
 22 files changed, 359 insertions(+), 109 deletions(-)
 delete mode 100644 tools/testing/selftests/bpf/prog_tests/ksyms_module_libbpf.c

-- 
2.33.0

