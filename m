Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 095EA4234ED
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 02:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236873AbhJFAat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 20:30:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbhJFAas (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 20:30:48 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C86C061749;
        Tue,  5 Oct 2021 17:28:57 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id 133so919558pgb.1;
        Tue, 05 Oct 2021 17:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jTQ+oEdyk26p0JN2ULvFKmMtcKaWw4p7niIGpjmLXpY=;
        b=Sk1Bb9i/WIRRKzvZ/JytsorIVezAtnvT7LvhJABeiyCri5ovgfCvArrMckZMJQJgCv
         ik/jrOXWPkoi3UPB6El2gcJ2bKzdyJ45poWdcd8Vdj2n9QPUKN0HkLYnJl9o8TCRULc1
         EDi8Ca7pbMSwF4NjZSZzG8Nr1r+34DC5i2qCM+Dwllu9tHymRLtmsc5NVhElw6v7+P4a
         V19muywvZdLzdhaT4WC0gpMCb33PtTN6yf6AfXKkNpzqOW/gpw78oQuEQoFhu2Z2dStS
         5+LOgkjySQuXIZVFhESadRgKS/01x2I6bsS8WIYe6VFtApCX4GQ0z97wz1Hui+qEmjFx
         5YOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jTQ+oEdyk26p0JN2ULvFKmMtcKaWw4p7niIGpjmLXpY=;
        b=6yrF+dXI9iaEieIeWzHHL3kefHukwYQ/kPuU1CTn6VsJ3u8YmSoNtm5Fpnhise7mX2
         JRWQo3gD5I9ME0QBoLkMzLObT1w10g37FiNyZWf/qcBb0S3TfJU8LE5opDqsqNp7T2sg
         qnN/6YuxxruiBNE1cJDltC4fB6ZnrwNislbSZV1mV0oYkpzx/fHxE99+xHzrZSp7wB4m
         Aas9YMGuXwEb62rm6mIbebNGKq26GS1sAZfXT4eXx+npgZwAteOGUtPPeVx0LZBwObrl
         Wou1DiPSCFuBZqtYvW9Dfd7AWXPPVapudVLB2CzDv7HjqNb0FOEbye3fyC/HAypz0OWK
         Zu2A==
X-Gm-Message-State: AOAM533lZK8UM76xXqKbt7nybamDlyaK9z4BVNA5NW5V6BBENF3sl5q/
        sth6lkj9Lr4jBZ8pgKC0KR79sCotYBM=
X-Google-Smtp-Source: ABdhPJx84nefinzevSotQahwhHMAPYcGZUt+wR/DLUgFc3R0vhkTdSFlLYdRrMUkqZabuV4w/U9fCg==
X-Received: by 2002:a62:5804:0:b0:44b:b75b:ec8f with SMTP id m4-20020a625804000000b0044bb75bec8fmr33171023pfb.63.1633480136626;
        Tue, 05 Oct 2021 17:28:56 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id k190sm18669691pgc.11.2021.10.05.17.28.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 17:28:56 -0700 (PDT)
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
Subject: [PATCH bpf-next v1 0/6] Typeless/weak ksym for gen_loader + misc fixups
Date:   Wed,  6 Oct 2021 05:58:47 +0530
Message-Id: <20211006002853.308945-1-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1695; h=from:subject; bh=mOayWgTuilibwCrwmhuX7GopPqq3BkJj5BOnoHyRx7A=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhXOxPvODHYffALT7glKrv+6X3pRB9zDRQchSoop0h ryoLbf2JAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYVzsTwAKCRBM4MiGSL8RypskD/ 9St/bp5LSSus7/LzWh+8UDD+4oGUvXS1t3iLyHbwKlsMhAkFS7sYHJj0xE49b+Eu8wUtDXekLbTjfX rq6UvwWPSr9F1l0aMSnJMCladi8r3s9CYM0PQEqeYEg2m+MujxdYq/coJso/gDIcL92YJ7l/zqqyCP 5ZdfzGgKqgqI6zpjS3PJVj/GhgupLySrVixUSoQvYI6Cq8z08EX3QLXfyv/eajYUL9epVxOXpis2zk ajlYFvASgrV52b0Ux7CDj9lXIihNc5x9NL43qsAN63MnkGHmqJwCwE+7ySlr4OIj/+FUPLFoDJYVEq 1bAFHRBlob29dqO+OfjIi0GRRWNhRs/4gjqrvvTCpYJ+eyqYyrymqT3fKp0FD8WTpluqdsmdcFgTIB BnY2zy8JyJXX9Ojflbyr4+vwz+JzePmo8nLIXfBsxilATCNccYKIpiWGQ1L4GXvRqv2TZnNCtebnv1 z5PKBN1Be0iZ1Pm0n01nVI72q3MFIb7TpxoshA6XcZKq9Dnr7az1xqZA2t1LnronSZCalBARMn9gl+ gSu5a9Wyi0qweT88f0lSMld5TL+AyyJAGDWPcrzAt7ICsu2zwIcbASvbu8sjo7Y/L8DsyZkVv/KB8O gZQutOmnlXJUHKlkkiKT2q2+y4Rf0RaS3qwb6/Nx1eKTehagOdDqz0h0GTWg==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patches (1,2,4) add typeless and weak ksym support to gen_loader. It is follow
up for the recent kfunc from modules series.

The later patches (5,6) are misc fixes for selftests, and patch 3 for libbpf
where we try to be careful to not end up with mod_btf->fd set as 0 (as that
leads to a confusing error message about btf_id not being found on load and it
is not clear what went wrong, instead we can just dup fd 0).

Kumar Kartikeya Dwivedi (6):
  bpf: Add bpf_kallsyms_lookup_name helper
  libbpf: Add typeless and weak ksym support to gen_loader
  libbpf: Ensure that module BTF fd is never 0
  bpf: selftests: Move test_ksyms_weak test to lskel, add libbpf test
  bpf: selftests: Fix fd cleanup in sk_lookup test
  bpf: selftests: Fix memory leak in test_ima

 include/linux/bpf.h                           |   1 +
 include/uapi/linux/bpf.h                      |  14 ++
 kernel/bpf/syscall.c                          |  24 ++++
 tools/include/uapi/linux/bpf.h                |  14 ++
 tools/lib/bpf/bpf_gen_internal.h              |  12 +-
 tools/lib/bpf/gen_loader.c                    | 123 ++++++++++++++++--
 tools/lib/bpf/libbpf.c                        |  27 ++--
 tools/testing/selftests/bpf/Makefile          |   2 +-
 .../selftests/bpf/prog_tests/ksyms_btf.c      |   6 +-
 .../bpf/prog_tests/ksyms_weak_libbpf.c        |  31 +++++
 .../selftests/bpf/prog_tests/sk_lookup.c      |  20 ++-
 .../selftests/bpf/prog_tests/test_ima.c       |   3 +-
 .../selftests/bpf/progs/test_ksyms_weak.c     |   3 +-
 13 files changed, 247 insertions(+), 33 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/ksyms_weak_libbpf.c

--
2.33.0

