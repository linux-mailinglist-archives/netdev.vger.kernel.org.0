Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3FFF350A
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 17:52:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389109AbfKGQwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 11:52:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58558 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729846AbfKGQwW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 11:52:22 -0500
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com [209.85.167.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3E19585542
        for <netdev@vger.kernel.org>; Thu,  7 Nov 2019 16:52:21 +0000 (UTC)
Received: by mail-lf1-f71.google.com with SMTP id v204so618261lfa.0
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 08:52:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=0BBAmTpKYKtRa4E0s0gZNYrlDfe81XFkwTQZ3QzuVV4=;
        b=LeXuGX3T30zDdZqgAZ8RD9sakBjQzPJAMTHIEQUFijCjRXxIqsnqxmoA117pxNpLQE
         x2P+pwdOPFq/6arja7XW9InmFE/9+6+JFrDA08pLzEij2ZFRC3Oge7jtgan2p2gP/gfs
         9JMNtl5IZK+vJGMg2/eePsNi9c83KgTbi7Dw6RF2n7R7hxyg//PZFFFKyA+oZS41AOsv
         B+mVZqUCp5r3atJp/jz6MqHwvti6ra77SA05fLDGjnF6oU7BlG0q2N5Hgr4NzH+Iyxcy
         +ORWHkUTHCqeb1DYmZ/V8OLzkEwVMU5rvQXnf4nucvOolxi5S7E8nlvpQOluqvhm7q3u
         8iUQ==
X-Gm-Message-State: APjAAAUIfAz4I9WMVuNt6qktiRP8RhhryrmddrdJpEdgnYqW3rvE3ONV
        slG+LC9JBmHrcqLY8qDAm2gaCaFHqQl6QZ4ObKJ1fuDsendEiJYAtOWXZuqP26Wn6WhgqrflZ6Z
        G39JBFt5lUPwgOmnk
X-Received: by 2002:a05:651c:119b:: with SMTP id w27mr2911704ljo.221.1573145539758;
        Thu, 07 Nov 2019 08:52:19 -0800 (PST)
X-Google-Smtp-Source: APXvYqyvh6SnIcvtmdcSrZ44czQIeqN1mbj8fe/RtNaif4GTsvB+66jflHvNikk8DxnRiiDWnRBQ2Q==
X-Received: by 2002:a05:651c:119b:: with SMTP id w27mr2911691ljo.221.1573145539595;
        Thu, 07 Nov 2019 08:52:19 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id a11sm1342086ljp.97.2019.11.07.08.52.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Nov 2019 08:52:19 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 2714D1818B5; Thu,  7 Nov 2019 17:52:18 +0100 (CET)
Subject: [PATCH bpf-next 0/6] libbpf: Fix pinning and error message bugs and
 add new getters
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Thu, 07 Nov 2019 17:52:18 +0100
Message-ID: <157314553801.693412.15522462897300280861.stgit@toke.dk>
User-Agent: StGit/0.20
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

