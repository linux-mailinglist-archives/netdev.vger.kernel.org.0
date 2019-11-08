Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98213F59ED
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 22:34:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732067AbfKHVdI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 16:33:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52756 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726900AbfKHVdI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 16:33:08 -0500
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com [209.85.208.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2646FC04D2F1
        for <netdev@vger.kernel.org>; Fri,  8 Nov 2019 21:33:08 +0000 (UTC)
Received: by mail-lj1-f200.google.com with SMTP id e17so1544283ljj.12
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 13:33:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=f9G7ifn6IeScMKogPmkF62Xe41eRO8dRYDdQ01G+h9Y=;
        b=BSrSIPwcRfznEmanz+9On55wSZlNtPFMlEHE9NDtyGY3o+NcGMrmMXeXcxdWdb6p9N
         5MVs74NFVMM9HHkEiOXvUNN/g3A9KCwc191lmFRQVi620OS4Kc62+oBXu/UHlYuMX1HO
         3YfIDMa3oeY0OgR+klx1th/eYbwYZNDgp+CXbx+cAHunQGYq6+cyL1hh7C1J2uARBql5
         Sjka3MuIUeUaKpcfz88VEjqwSfbVxc4GicUp9pWGW0AYaOwwFkcnnop8BPerfP3zkjA8
         HGr+1Dzg+r8GPANO8cPpPFIZ5iboG+b6xqRgGuC3oavI7QXM1dGypYVfRbvWMHYzsvBi
         iYtQ==
X-Gm-Message-State: APjAAAWUo2l+cJMGFO0mId7kuvfS4X3bJnWnXimPlbv5Cnc3qQxTuYy2
        C6RCD9DohB1ruDjl0hMQr+c7109uNmNWBmDgLLl6mnY6r96bax6QmD0uaSp8YSIQ829hCzopq5E
        N1saLtm2lcM+n2LHi
X-Received: by 2002:a05:651c:1059:: with SMTP id x25mr3891821ljm.255.1573248786666;
        Fri, 08 Nov 2019 13:33:06 -0800 (PST)
X-Google-Smtp-Source: APXvYqxH5IsNOnALiXwaJmnRtU+9Blz9TfCCMAbWhWiRYR8R/9dp8YTIX1Qic5MPcVqDSyqwCULPKw==
X-Received: by 2002:a05:651c:1059:: with SMTP id x25mr3891810ljm.255.1573248786489;
        Fri, 08 Nov 2019 13:33:06 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id y6sm3504046lfj.75.2019.11.08.13.33.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Nov 2019 13:33:05 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3A4901800BD; Fri,  8 Nov 2019 22:33:05 +0100 (CET)
Subject: [PATCH bpf-next v2 0/6] libbpf: Fix pinning and error message bugs
 and add new getters
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Fri, 08 Nov 2019 22:33:05 +0100
Message-ID: <157324878503.910124.12936814523952521484.stgit@toke.dk>
User-Agent: StGit/0.21
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes a few bugs in libbpf that I discovered while playing around
with the new auto-pinning code, and writing the first utility in xdp-tools[0]:

- If object loading fails, libbpf does not clean up the pinnings created by the
  auto-pinning mechanism.
- EPERM is not propagated to the caller on program load
- Netlink functions write error messages directly to stderr

In addition, libbpf currently only has a somewhat limited getter function for
XDP link info, which makes it impossible to discover whether an attached program
is in SKB mode or not. So the last patch in the series adds a new getter for XDP
link info which returns all the information returned via netlink (and which can
be extended later).

Finally, add a getter for BPF program size, which can be used by the caller to
estimate the amount of locked memory needed to load a program.

A selftest is added for the pinning change, while the other features were tested
in the xdp-filter tool from the xdp-tools repo. The 'new-libbpf-features' branch
contains the commits that make use of the new XDP getter and the corrected EPERM
error code.

[0] https://github.com/xdp-project/xdp-tools

Changelog:

v2:
  - Keep function names in libbpf.map sorted properly

---

Toke Høiland-Jørgensen (6):
      libbpf: Unpin auto-pinned maps if loading fails
      selftests/bpf: Add tests for automatic map unpinning on load failure
      libbpf: Propagate EPERM to caller on program load
      libbpf: Use pr_warn() when printing netlink errors
      libbpf: Add bpf_get_link_xdp_info() function to get more XDP information
      libbpf: Add getter for program size


 tools/lib/bpf/libbpf.c                           |   25 +++++--
 tools/lib/bpf/libbpf.h                           |   11 +++
 tools/lib/bpf/libbpf.map                         |    2 +
 tools/lib/bpf/netlink.c                          |   81 ++++++++++++++--------
 tools/lib/bpf/nlattr.c                           |   10 +--
 tools/testing/selftests/bpf/prog_tests/pinning.c |   20 +++++
 tools/testing/selftests/bpf/progs/test_pinning.c |    2 -
 7 files changed, 109 insertions(+), 42 deletions(-)

