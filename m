Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A48F4702A6
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 15:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241946AbhLJOY2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 09:24:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41217 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241925AbhLJOY0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 09:24:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639146051;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=inldrrFWMBfx9w9N+cfMF1H6SahHY5P4j07Q73Gy3mY=;
        b=Bpe/ztMOQ9PjnzFXP6yB4x4VuCRs4p9yh8RGn9M4Cy3myYsLSBHSfi63QNGRojLBkON/rU
        Xd3mf6u/bUY6cWzNMKk+lNotu2z47LjOk5FWemvg85Ga9f1OvUqtmRgn/8WaKu0m5+/MEy
        KCpZoJJ50WTQ3CaTP8oEgCFd9YIZLpI=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-22-OXy9Vt9LPzK1ZXNOAGg2Bg-1; Fri, 10 Dec 2021 09:20:50 -0500
X-MC-Unique: OXy9Vt9LPzK1ZXNOAGg2Bg-1
Received: by mail-ed1-f70.google.com with SMTP id m12-20020a056402430c00b003e9f10bbb7dso8271393edc.18
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 06:20:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=inldrrFWMBfx9w9N+cfMF1H6SahHY5P4j07Q73Gy3mY=;
        b=mQowUF6wX/bI714ETViv6jk2hnmw7kT7u8np2XNlIPhJsUkBGVmuahOtRtjt1B0cc9
         DgFW+J9nb8EbNheNPz1mpukua4X+qcZ4SmvNxJTualHJ7H0OgFqdCmkbk4WRuSk54D8H
         rQa1dKCgh/aY4PW9prtwAeCQPd9MtoZ4rvi6RUev4c4NGgQP2duiMz5qXjP+HcixTMi2
         XjN3sfcBVGlEpyRLOQJhd7mWubsk/6cTZE7U5jd63SOhCY2SHERZcngmoTBNWPBolhV7
         +6CD7uamcyf6Dlc+FYylHt1gdg7Z1wVQ+smwshjzCjNvo68m9otruqtFry9QpiVLK4uY
         6UJg==
X-Gm-Message-State: AOAM533Mh5R8aVV+gcuDXEusT26cT/Kyw5HHdKO5/cf5nzOfMnoBGCu7
        T4w+B9KI0kwX75Z9A+E/uwTN3KPQMGCXJx5kc/8usDScjjsKWr4YwgtfN0N89wt2qIrLtQ0yzxl
        T2I512eOEgFxGuiNV
X-Received: by 2002:a05:6402:3590:: with SMTP id y16mr37782032edc.343.1639146047542;
        Fri, 10 Dec 2021 06:20:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwFzY/2j3WiPlnRWoTpp6uz7oWK/Lpvfu/BI23ciXeezCU/cjvU3njcgaIPU5f2TT2CakyrTg==
X-Received: by 2002:a05:6402:3590:: with SMTP id y16mr37781917edc.343.1639146046602;
        Fri, 10 Dec 2021 06:20:46 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id f17sm1582816edq.39.2021.12.10.06.20.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 06:20:45 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 48C6D180450; Fri, 10 Dec 2021 15:20:45 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next v2 0/8] Add support for transmitting packets using XDP in bpf_prog_run()
Date:   Fri, 10 Dec 2021 15:20:00 +0100
Message-Id: <20211210142008.76981-1-toke@redhat.com>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for transmitting packets using XDP in
bpf_prog_run(), by enabling the xdp_do_redirect() callback so XDP programs
can perform "real" redirects to devices or maps, using an opt-in flag when
executing the program.

The primary use case for this is testing the redirect map types and the
ndo_xdp_xmit driver operation without generating external traffic. But it
turns out to also be useful for creating a programmable traffic generator.
The last patch adds a sample traffic generator to bpf/samples, which
can transmit up to 11.5 Mpps/core on my test machine.

To transmit the frames, the new mode instantiates a page_pool structure in
bpf_prog_run() and initialises the pages with the data passed in by
userspace. These pages can then be redirected using the normal redirection
mechanism, and the existing page_pool code takes care of returning and
recycling them. The setup is optimised for high performance with a high
number of repetitions to support stress testing and the traffic generator
use case; see patch 6 for details.

The series is structured as follows: Patches 1-2 adds a few features to
page_pool that are needed for the usage in bpf_prog_run(). Similarly,
patches 3-5 performs a couple of preparatory refactorings of the XDP
redirect and memory management code. Patch 6 adds the support to
bpf_prog_run() itself, patch 7 adds a selftest, and patch 8 adds the
traffic generator example to samples/bpf.

v2:
- Split up up __xdp_do_redirect to avoid passing two pointers to it (John)
- Always reset context pointers before each test run (John)
- Use get_mac_addr() from xdp_sample_user.h instead of rolling our own (Kumar)
- Fix wrong offset for metadata pointer

Toke Høiland-Jørgensen (8):
  page_pool: Add callback to init pages when they are allocated
  page_pool: Store the XDP mem id
  xdp: Allow registering memory model without rxq reference
  xdp: Move conversion to xdp_frame out of map functions
  xdp: add xdp_do_redirect_frame() for pre-computed xdp_frames
  bpf: Add XDP_REDIRECT support to XDP for bpf_prog_run()
  selftests/bpf: Add selftest for XDP_REDIRECT in bpf_prog_run()
  samples/bpf: Add xdp_trafficgen sample

 include/linux/bpf.h                           |  20 +-
 include/linux/filter.h                        |   4 +
 include/net/page_pool.h                       |  11 +-
 include/net/xdp.h                             |   3 +
 include/uapi/linux/bpf.h                      |   2 +
 kernel/bpf/Kconfig                            |   1 +
 kernel/bpf/cpumap.c                           |   8 +-
 kernel/bpf/devmap.c                           |  32 +-
 net/bpf/test_run.c                            | 218 ++++++++-
 net/core/filter.c                             |  73 ++-
 net/core/page_pool.c                          |   6 +-
 net/core/xdp.c                                |  94 ++--
 samples/bpf/.gitignore                        |   1 +
 samples/bpf/Makefile                          |   4 +
 samples/bpf/xdp_redirect.bpf.c                |  34 ++
 samples/bpf/xdp_trafficgen_user.c             | 421 ++++++++++++++++++
 tools/include/uapi/linux/bpf.h                |   2 +
 .../bpf/prog_tests/xdp_do_redirect.c          |  74 +++
 .../bpf/progs/test_xdp_do_redirect.c          |  34 ++
 19 files changed, 948 insertions(+), 94 deletions(-)
 create mode 100644 samples/bpf/xdp_trafficgen_user.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/xdp_do_redirect.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_do_redirect.c

-- 
2.34.0

