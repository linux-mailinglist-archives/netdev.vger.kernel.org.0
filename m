Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36674837A3
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 19:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733174AbfHFRJF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 13:09:05 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:38952 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732615AbfHFRJE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 13:09:04 -0400
Received: by mail-pf1-f202.google.com with SMTP id 6so56324462pfi.6
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 10:09:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=fodY2dzKWC74TgSsGgftnxUr1VYkPfXdI8RTegnFuRk=;
        b=r84moShAnq8ZODRu8Ppxe/AnbMkG6A8qz/leBCVE8PK3BELVVmv3/6ur3KoD3hhP9i
         N5iqxTEHdVEiHnkXgznyKOabDQij28vvebQB5XK6yKso1QIAXAvM3Jk3Nr15xBUjStSO
         1hVzIm3jL+TCjTDNczpzfqQinOqBLYBpb88Zbbf5sutplQ3EHCv056Tu0yo9M74LXk4/
         L0xNzWeyabdasFWz0fUxa++z5XNK1+rzU1L0JVA+iWYorwTfvichhe0y2BkGiqlqv4+F
         kv0ihungc7Snj/GCianP0/JxsF6YZl5DesFSLef3TYq34uxEdZvN27ParvTd7vO6BZNO
         MaKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=fodY2dzKWC74TgSsGgftnxUr1VYkPfXdI8RTegnFuRk=;
        b=QtoWIAgN9CtX5b3S8ADbaB99RZ4w5D4+wXAbJOQuQjpgPxFa9I2UfKUwpDPNoNpJfa
         ViIuegw+o6W1qnt7tLCUNqwqxKbek53HM51s5WwZlQwZapnyZY5ROZwadp1WpA5I0LQI
         XswbjjrzY6j92QdZQWyv3LZoeQTZb2rcG6nLEP9nqRA9SLLjqrcNnSRfMSAWR0UogMDL
         86LukN2+DjvRm0GNxB3TV4b7U3qVlAFl07jSQ+zlUiFbee7LbS94JkD6Uchka0LyK2Xu
         10sY/2yfiECPCHwnUceqrIx1rfyQ1fcTCmFQJKE4evFgp192F0M0eIbfVOME/PgITaqw
         l6Jg==
X-Gm-Message-State: APjAAAWq3H/FJ3xo4Rjep7Ilr1/oemJIujD8+BQ+oY3GZTkBh8C2+vU3
        lF8GpDecz59vlQqbZfgiuqMjnzfiEIfGpKTFPgjEFD6fzNlLYYPxTPobGZbKTvCO1rxY1ZXX6k7
        k2Jp4XABCbBydwoKmnOVSxi25r/dfG3F3IYISsQjaLp/oLbuui/Z0Qg==
X-Google-Smtp-Source: APXvYqzQmePQDeTVqOz77ZYRh3icQhQSGh7PuEYW6YpTXDzp5x3sKCoa0cM1bamIxFUrr5ks8khn8Us=
X-Received: by 2002:a65:5144:: with SMTP id g4mr3963306pgq.202.1565111343589;
 Tue, 06 Aug 2019 10:09:03 -0700 (PDT)
Date:   Tue,  6 Aug 2019 10:08:58 -0700
Message-Id: <20190806170901.142264-1-sdf@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.770.g0f2c4a37fd-goog
Subject: [PATCH bpf-next v4 0/3] selftests/bpf: switch test_progs back to stdio
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I was looking into converting test_sockops* to test_progs framework
and that requires using cgroup_helpers.c which rely on stdio/stderr.
Let's use open_memstream to override stdout into buffer during
subtests instead of custom test_{v,}printf wrappers. That lets
us continue to use stdio in the subtests and dump it on failure
if required.

That would also fix bpf_find_map which currently uses printf to
signal failure (missed during test_printf conversion).

Cc: Andrii Nakryiko <andriin@fb.com>

Stanislav Fomichev (3):
  selftests/bpf: test_progs: switch to open_memstream
  selftests/bpf: test_progs: test__printf -> printf
  selftests/bpf: test_progs: drop extra trailing tab

 .../bpf/prog_tests/bpf_verif_scale.c          |   4 +-
 .../selftests/bpf/prog_tests/l4lb_all.c       |   2 +-
 .../selftests/bpf/prog_tests/map_lock.c       |  10 +-
 .../selftests/bpf/prog_tests/send_signal.c    |   4 +-
 .../selftests/bpf/prog_tests/spinlock.c       |   2 +-
 .../bpf/prog_tests/stacktrace_build_id.c      |   4 +-
 .../bpf/prog_tests/stacktrace_build_id_nmi.c  |   4 +-
 .../selftests/bpf/prog_tests/xdp_noinline.c   |   4 +-
 tools/testing/selftests/bpf/test_progs.c      | 131 ++++++++----------
 tools/testing/selftests/bpf/test_progs.h      |  13 +-
 10 files changed, 84 insertions(+), 94 deletions(-)

-- 
2.22.0.770.g0f2c4a37fd-goog
