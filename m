Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1C3142E2E9
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 22:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232153AbhJNU6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 16:58:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231524AbhJNU6y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 16:58:54 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6767C061570;
        Thu, 14 Oct 2021 13:56:48 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id d13-20020a17090ad3cd00b0019e746f7bd4so7860644pjw.0;
        Thu, 14 Oct 2021 13:56:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z0Ydcs+GUaaUaLIdjI7bEWpcMdDhNI4mQM9DybBA8PI=;
        b=cbYjdlCmY6uxV6ewWO5Gzm5zZwPbdgb8FcWAKM1VsiNAurA59rCWUg+VJ1qgmlzNzH
         4hPAfiff5HRyiEEAHBH1UCTiOQLwvYS37v7uqduJ5kE9dei1MNpSY6bZhX2au36qQjEl
         cMSp08VVA8bAHdt3iYOvtb8CbByV7nmPVy6Xb2retrMXQEpJ3aPLpjHlIyFpk0EUib37
         tO+JFCxwWWEsYX70WvldbWnLhlKTegsvsnj45HKs6ErQpBJSsCEolKQGzBZeIdSuHiiM
         Lt5XnSRQeDEQtPmVGQ3UoRhriVnmvU6XPIVeF9sVKkSvd4qW7tyUS2x+EuFF6dEO4OvU
         1asg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z0Ydcs+GUaaUaLIdjI7bEWpcMdDhNI4mQM9DybBA8PI=;
        b=VErlClQV3ve5ucrvzu8d/9ReeLQ/CoKBW612k7/WAtUJ0RsnSwRaOZznP9PiPVZUo0
         c/VMxrf470UzgTrgKoNBHOv1uW+hN0V8DiKYtlpRSt3KGDndj16RAn4csp9mme/x90I6
         SMm2cFinS/wODU3MDFODjYahoQNhuB1BBr/Rn6ndiMs114t7ia8Vlgjt5OYdEbJEHGWE
         ySZt5YSMjaF2hVZd9yWp88ejrpCtAhrgUYrjsWDmxVsPw4aYc5vUW914Xw1QE7yetnBy
         tEuh4lYv2YnrFWhvTlS0zDKeUz5VE4+A3LLqqHfNqr2XxbBEdtyEaEFLkn/J5hZo3Qb6
         to4w==
X-Gm-Message-State: AOAM532HUcU+Y4ibcSwcgtxw9Ec5q23zrns4tPdP3GwYuCwQtC21r2L1
        n4vS3OBp+swuA8lE9x4ygFbRHhaPGbw=
X-Google-Smtp-Source: ABdhPJy3RgrnrkOILu34FM+yA7C8kYGF6BKk1EgjvNVBqDdpmjqR0MZ5arkDwjOfVRVcRvKWozme4A==
X-Received: by 2002:a17:90a:de0d:: with SMTP id m13mr23571984pjv.85.1634245008045;
        Thu, 14 Oct 2021 13:56:48 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id a17sm3462473pfd.54.2021.10.14.13.56.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 13:56:47 -0700 (PDT)
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
Subject: [PATCH bpf-next v3 0/8] Typeless/weak ksym for gen_loader + misc fixups
Date:   Fri, 15 Oct 2021 02:26:36 +0530
Message-Id: <20211014205644.1837280-1-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3317; h=from:subject; bh=txyyaX5ZUImEw0BtaCYf665YmUH8hzlhtob3AwnimKc=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhaJk/zebuseEnB8hm+S7jpVzdYygguImjiCYrk2Al +QgdziCJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYWiZPwAKCRBM4MiGSL8RysPoD/ 9MJmKJc/Y0AAwTueGnLxKCBUwWy4jW9ABMgy6mtY2mmWw5lqBLiceS16NW4RXEv5lVw/dWwMAY56Dw PNGbeKmSYtUvA+94H2sWmOeYDavcnS++8xdYIPQ1rK9vf/1J200SuYtHxnIPLAwJrD033txm74vwKz kw1yxgSksezVmxDe2pcjV7SZovY/Xjvyvh2wJIe2ZMZM3gymi6dZ0pXIO8QwpDy81v1CwJGoAw4p/C UKU1jHTctlturyMEoyrtvSK0IuhyUMT4Q5zK817pE1tMxqDhR44qLpV1epv+smZqLO5iiW1KbwbauI wdcYBhZ4Ai6yfbs3IPUcmlFVbTcDqSjTvaBjqqAo4ZbYmZtdA2vrToHAmu5T+r3h4xRpe1f1sWA2Dr VJBRiH1QLVBTh+I5IOz8CtX2qhJR5a9M68hoH8TpmQSgy7idfp0Ks2zdzrWytJjWvdrHMysD+TQwix lPy3PTONjpIPc7+2+EzrCoN7r5HmUK5sn6z37BhuM1HPzI5jXCJLjaWsFiXOeaZ4o81z09J5SuoVEB fC3mtSbkizKltngLNerXUiu1qmhU+EH381hgZhIBQhIPas60UJyx+v6J+AJ/HZ2pWxVDxajr4pG9l0 clpWNsjB3BB0le5PDjBrj4w/xVkjcAlewycAEgzV/YGlDcm5TiiYb/GTpPHg==
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
v2 -> v3
v2: https://lore.kernel.org/bpf/20211013073348.1611155-1-memxor@gmail.com

 * Address feedback from Song
   * Move ksym logging to separate helper to avoid code duplication
   * Move src_reg mask stuff to separate helper
   * Fix various other nits, add acks
     * __builtin_expect is used instead of likely to as skel_internal.h is
       included in isolation.

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
 include/uapi/linux/bpf.h                      |  14 ++
 kernel/bpf/syscall.c                          |  24 ++++
 tools/include/uapi/linux/bpf.h                |  14 ++
 tools/lib/bpf/bpf.c                           |  28 ++--
 tools/lib/bpf/bpf_gen_internal.h              |  12 +-
 tools/lib/bpf/btf.c                           |   2 +-
 tools/lib/bpf/gen_loader.c                    | 132 ++++++++++++++++--
 tools/lib/bpf/libbpf.c                        |  53 ++++---
 tools/lib/bpf/libbpf_internal.h               |  23 +++
 tools/lib/bpf/libbpf_probes.c                 |   2 +-
 tools/lib/bpf/linker.c                        |   4 +-
 tools/lib/bpf/ringbuf.c                       |   2 +-
 tools/lib/bpf/skel_internal.h                 |  35 ++++-
 tools/lib/bpf/xsk.c                           |   6 +-
 tools/testing/selftests/bpf/Makefile          |   7 +-
 .../selftests/bpf/prog_tests/ksyms_btf.c      |  35 ++++-
 .../selftests/bpf/prog_tests/ksyms_module.c   |  40 +++++-
 .../bpf/prog_tests/ksyms_module_libbpf.c      |  28 ----
 .../selftests/bpf/prog_tests/sk_lookup.c      |  14 +-
 .../selftests/bpf/prog_tests/test_ima.c       |   3 +-
 .../selftests/bpf/progs/test_ksyms_weak.c     |   3 +-
 22 files changed, 367 insertions(+), 115 deletions(-)
 delete mode 100644 tools/testing/selftests/bpf/prog_tests/ksyms_module_libbpf.c

-- 
2.33.0

