Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CF2FE6568
	for <lists+netdev@lfdr.de>; Sun, 27 Oct 2019 21:53:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728028AbfJ0UxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Oct 2019 16:53:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36536 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727802AbfJ0UxT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Oct 2019 16:53:19 -0400
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com [209.85.167.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B848E81F0C
        for <netdev@vger.kernel.org>; Sun, 27 Oct 2019 20:53:18 +0000 (UTC)
Received: by mail-lf1-f70.google.com with SMTP id h3so182584lfp.17
        for <netdev@vger.kernel.org>; Sun, 27 Oct 2019 13:53:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=4385h0aE6YYlkbn2h+au6Kq0Vs1gd0PAkbkl/xT+QW8=;
        b=b8zjopewNglQuXyJWbtvi/dlDKw0bZfsZH1kzL1lDbEXFLTiFkjy9nIEsB8kgk9RHS
         yTxGhUPFs3e1IpLghrmVnaRSicbn7sYuBqw9TRNLBDToV8GEyokwfJFSJlwCOQVOQN19
         nvK7qMoBSt/W8L1eVZ2TanPqQ6LtKMqWPrQn1DJWXOBXQoUO1OYmq15rj6mo2qOiINCu
         9t9gW5PVS8arX6e+FgKgb4sDbrfBrthyJlcnd9xmyPs48GdlHEfiBLAcoZIqfnlfS+IQ
         CUF203wOvlAQ8yYD9H6zUSzvUGjdgnDlKaf4P0DAlARPhGB8LWBYBrhegho2Q8p5qh8s
         11JQ==
X-Gm-Message-State: APjAAAVMsp21WB3PGOYYdMP1dlEKWiWAhOZmlK2WjzQpvwyLFgULw3dd
        VSzJvKEYFi23VwrcCg+j8MGILq/U2AR5SYW3uAzqI4qGHUHSym4qAXq3IcvMp2RMnzfQEvaohNN
        4fPENuYuwyHsr+hcy
X-Received: by 2002:a19:d7:: with SMTP id 206mr9129203lfa.22.1572209597291;
        Sun, 27 Oct 2019 13:53:17 -0700 (PDT)
X-Google-Smtp-Source: APXvYqylhQEQG9x69HS75ewg9WsRX7kWexDwSSlXmLy2FL2fLiJNjMY2pDMnXyqfvVq3TP/Cxnr+ZA==
X-Received: by 2002:a19:d7:: with SMTP id 206mr9129193lfa.22.1572209597126;
        Sun, 27 Oct 2019 13:53:17 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id z63sm5136608ljb.4.2019.10.27.13.53.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Oct 2019 13:53:16 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 91FAA1818B6; Sun, 27 Oct 2019 21:53:15 +0100 (CET)
Subject: [PATCH bpf-next v3 0/4] libbpf: Support automatic pinning of maps
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
Date:   Sun, 27 Oct 2019 21:53:15 +0100
Message-ID: <157220959547.48922.6623938299823744715.stgit@toke.dk>
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

Toke Høiland-Jørgensen (4):
      libbpf: Fix error handling in bpf_map__reuse_fd()
      libbpf: Store map pin path and status in struct bpf_map
      libbpf: Add auto-pinning of maps when loading BPF objects
      selftests: Add tests for automatic map pinning


 tools/lib/bpf/bpf_helpers.h                      |    6 
 tools/lib/bpf/libbpf.c                           |  271 +++++++++++++++++++---
 tools/lib/bpf/libbpf.h                           |   14 +
 tools/lib/bpf/libbpf.map                         |    3 
 tools/testing/selftests/bpf/prog_tests/pinning.c |   91 +++++++
 tools/testing/selftests/bpf/progs/test_pinning.c |   29 ++
 6 files changed, 381 insertions(+), 33 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/pinning.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_pinning.c

