Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73F70F617E
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 21:37:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726616AbfKIUhf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 15:37:35 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:34142 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726496AbfKIUhe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 15:37:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573331852;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=JAo1J6Owr+4nF6yobLva4aQytX2bXOXitTPKE7xjZhY=;
        b=hPQASvXJhlaUyjWUmYUDsgoZ780tZOYNTNeNB0eBlaGhuqkO11xndjnggp8D/bm874RZGG
        bH+LwM/Q9LZzjXUiy5eyKmlkgIvNHdAgaZxjJTNTDS7EepUrr3D8tzKJFdYQmbi5BlB/xd
        JuKuDPy+nHOFlIlP+zbfbpQkcukHPRI=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-132-jdgl61uNMBmTXZ5_0xyl4Q-1; Sat, 09 Nov 2019 15:37:29 -0500
Received: by mail-ed1-f72.google.com with SMTP id j3so7330137edt.7
        for <netdev@vger.kernel.org>; Sat, 09 Nov 2019 12:37:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=3vYfTcrwvzSK+vJhB4J00Pl0KQF3aMpRR2i1QTImMts=;
        b=Gq67A1RInhbqmR/grIV4zlZ0xpwmZRMaqDy2zuYkKCLO8lakEAEAk1aNEZAZqngXn9
         AYzXCK+sJ+OdTxNzn9f79wdASRrMSEAM47e/7kP6KxSnMYa2HW7vIuSGBV2G/H0AcDnh
         3BWZNSpepzgBvcWxdQFghY4cwLcgVqsnVV4E7sRQ6WSWldGyE17EfFOx7ICRBG5YUwTx
         Ax+0pz8V3cw6i/CLNJNF4Cmx+d5gP1df22+nC8HOCqRobbAIThwwavdoYTgBxZQhqj3k
         5SHQlziaMVJUbs4tealisuffTZfodABTqs1WkcBMXFUcKJ+crZCWu5MTatiF6NiUrPxG
         PhaQ==
X-Gm-Message-State: APjAAAVStQ7CHIDbbTi5HsvRi7O1gswBSxq4DvvhYaFLuzJtiB7PPL5a
        CYBZXORy3s+sg7b0MSfN86iS1w5ADLwtAXJaRNnx3splXCPuQiVMP0p6Gux4RddUvIhUzSLXCkt
        AmTo/66wciG40lNKI
X-Received: by 2002:a05:6402:138c:: with SMTP id b12mr17903395edv.28.1573331848048;
        Sat, 09 Nov 2019 12:37:28 -0800 (PST)
X-Google-Smtp-Source: APXvYqx1fgfFade0Tq5mHEdcZq9u/a5pVitQtJ9Oy01GxQ81sYxNPdSPl6lw/cQxIJK3D1s1fSowfg==
X-Received: by 2002:a05:6402:138c:: with SMTP id b12mr17903378edv.28.1573331847856;
        Sat, 09 Nov 2019 12:37:27 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id v3sm325216edq.62.2019.11.09.12.37.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Nov 2019 12:37:26 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 4CD731800CC; Sat,  9 Nov 2019 21:37:26 +0100 (CET)
Subject: [PATCH bpf-next v4 0/6] libbpf: Fix pinning and error message bugs
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
Date:   Sat, 09 Nov 2019 21:37:26 +0100
Message-ID: <157333184619.88376.13377736576285554047.stgit@toke.dk>
User-Agent: StGit/0.21
MIME-Version: 1.0
X-MC-Unique: jdgl61uNMBmTXZ5_0xyl4Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes a few bugs in libbpf that I discovered while playing arou=
nd
with the new auto-pinning code, and writing the first utility in xdp-tools[=
0]:

- If object loading fails, libbpf does not clean up the pinnings created by=
 the
  auto-pinning mechanism.
- EPERM is not propagated to the caller on program load
- Netlink functions write error messages directly to stderr

In addition, libbpf currently only has a somewhat limited getter function f=
or
XDP link info, which makes it impossible to discover whether an attached pr=
ogram
is in SKB mode or not. So the last patch in the series adds a new getter fo=
r XDP
link info which returns all the information returned via netlink (and which=
 can
be extended later).

Finally, add a getter for BPF program size, which can be used by the caller=
 to
estimate the amount of locked memory needed to load a program.

A selftest is added for the pinning change, while the other features were t=
ested
in the xdp-filter tool from the xdp-tools repo. The 'new-libbpf-features' b=
ranch
contains the commits that make use of the new XDP getter and the corrected =
EPERM
error code.

[0] https://github.com/xdp-project/xdp-tools

Changelog:

v4:
  - Don't do any size checks on struct xdp_info, just copy (and/or zero)
    whatever size the caller supplied.

v3:
  - Pass through all kernel error codes on program load (instead of just EP=
ERM).
  - No new bpf_object__unload() variant, just do the loop at the caller
  - Don't reject struct xdp_info sizes that are bigger than what we expect.
  - Add a comment noting that bpf_program__size() returns the size in bytes

v2:
  - Keep function names in libbpf.map sorted properly

---

Toke H=C3=B8iland-J=C3=B8rgensen (6):
      libbpf: Unpin auto-pinned maps if loading fails
      selftests/bpf: Add tests for automatic map unpinning on load failure
      libbpf: Propagate EPERM to caller on program load
      libbpf: Use pr_warn() when printing netlink errors
      libbpf: Add bpf_get_link_xdp_info() function to get more XDP informat=
ion
      libbpf: Add getter for program size


 tools/lib/bpf/libbpf.c                           |   41 ++++++----
 tools/lib/bpf/libbpf.h                           |   13 +++
 tools/lib/bpf/libbpf.map                         |    2 +
 tools/lib/bpf/netlink.c                          |   87 +++++++++++++++---=
----
 tools/lib/bpf/nlattr.c                           |   10 +--
 tools/testing/selftests/bpf/prog_tests/pinning.c |   20 ++++-
 tools/testing/selftests/bpf/progs/test_pinning.c |    2 -
 7 files changed, 120 insertions(+), 55 deletions(-)

