Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9374173683
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 12:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbgB1LyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 06:54:13 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40439 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbgB1LyM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 06:54:12 -0500
Received: by mail-wr1-f65.google.com with SMTP id r17so2622564wrj.7
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 03:54:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xpjrQ+LxOVHd1ZZyUTMl/hx4W9QL+WGffgL18INpcgw=;
        b=LT1AO+SHbhwm8y8CyZxKEBUWiC1xbLYiEThPU5K84U+SPw6e1iQ90CA8C3HjcrtuXe
         kNFIRHUGuYd3WSu5C19Qccr8K91UTF6C0jejXu0dQhF5+44/dnyvEAQQHklz5+F/88SO
         DRuM0gluZjdBDBs2nc7gPC+xiDmqMsdKwIiO8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xpjrQ+LxOVHd1ZZyUTMl/hx4W9QL+WGffgL18INpcgw=;
        b=CfGN7oGdHbCqZBe/wywLF4+ATroFPthzAzxLw/dhi8z/VVm5h+QUIRehoHtxDAxiop
         x1H3poWWxUvcz/jvo2ncOxzDrjxYQqh8L07N+aTk3yMuDLs0TIr2c+tG+x/GVS5P3PZF
         Ysk+VP4mNaMTfDLuXifVEXGum8B0tZWH7dzdL+Vv7VCaFfBgHRZOSfhZZNoTau5R5ZQB
         R36Y/iF0tIlATZ2ya8yYJvN4hXvxviDHQzWmyfYfds7rAsunUMl/CWpqxrh+fUKq0fwj
         ernT6yyO8HSqOnuceQh+C09l1+c3E69dzNOAhxCxowr9orWKUuelXF5NzEiK25vSLdQF
         77Ag==
X-Gm-Message-State: APjAAAUYK727AHpsHQwm22wYToYn39jdAJFDLGuzLv5g19LhFG2QM/Yn
        KpR9yp25xqCuhzNbt0K2yKOpDQ==
X-Google-Smtp-Source: APXvYqxU0Y6ni6VdUIwPkEzDvFIWfkFyfX7cfN07CZxam4m/XMQtJJk018kFuTU7i1SYB2rXYPwFUQ==
X-Received: by 2002:adf:de85:: with SMTP id w5mr4264936wrl.323.1582890849435;
        Fri, 28 Feb 2020 03:54:09 -0800 (PST)
Received: from antares.lan (b.2.d.a.1.b.1.b.2.c.5.e.0.3.d.4.f.f.6.2.a.5.a.7.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:7a5a:26ff:4d30:e5c2:b1b1:ad2b])
        by smtp.gmail.com with ESMTPSA id q125sm2044284wme.19.2020.02.28.03.54.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 03:54:08 -0800 (PST)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     john.fastabend@gmail.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next v2 0/9] bpf: sockmap, sockhash: support storing UDP sockets
Date:   Fri, 28 Feb 2020 11:53:35 +0000
Message-Id: <20200228115344.17742-1-lmb@cloudflare.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for all the reviews so far! I've fixed the identified bug and addressed
feedback as much as possible.

I've not taken up Jakub's suggestion to get rid of sk_psock_hooks_init. My
intention is to encapsulate initializing both v4 and v6 protos. Really, it's
down to personal preference, and I'm happy to remove it if others prefer
Jakub's approach. I'm also still eager for a solution that requires less
machinery.

Changes since v1:
- Check newsk->sk_prot in tcp_bpf_clone
- Fix compilation with BPF_STREAM_PARSER disabled
- Use spin_lock_init instead of static initializer
- Elaborate on TCPF_SYN_RECV
- Cosmetic changes to TEST macros, and more tests
- Add Jakub and me as maintainers

Lorenz Bauer (9):
  bpf: sockmap: only check ULP for TCP sockets
  bpf: tcp: guard declarations with CONFIG_NET_SOCK_MSG
  bpf: sockmap: move generic sockmap hooks from BPF TCP
  skmsg: introduce sk_psock_hooks
  bpf: sockmap: allow UDP sockets
  selftests: bpf: don't listen() on UDP sockets
  selftests: bpf: add tests for UDP sockets in sockmap
  selftests: bpf: enable UDP sockmap reuseport tests
  bpf, doc: update maintainers for L7 BPF

 MAINTAINERS                                   |   3 +
 include/linux/bpf.h                           |   4 +-
 include/linux/skmsg.h                         |  72 +++----
 include/linux/udp.h                           |   4 +
 include/net/tcp.h                             |  18 +-
 net/core/skmsg.c                              |  55 +++++
 net/core/sock_map.c                           | 160 ++++++++++----
 net/ipv4/Makefile                             |   1 +
 net/ipv4/tcp_bpf.c                            | 169 +++------------
 net/ipv4/udp_bpf.c                            |  53 +++++
 .../bpf/prog_tests/select_reuseport.c         |   6 -
 .../selftests/bpf/prog_tests/sockmap_listen.c | 204 +++++++++++++-----
 12 files changed, 465 insertions(+), 284 deletions(-)
 create mode 100644 net/ipv4/udp_bpf.c

-- 
2.20.1

