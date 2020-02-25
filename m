Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 130D316C2DE
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 14:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730239AbgBYN4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 08:56:42 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45035 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730288AbgBYN4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 08:56:41 -0500
Received: by mail-wr1-f68.google.com with SMTP id m16so14807220wrx.11
        for <netdev@vger.kernel.org>; Tue, 25 Feb 2020 05:56:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9/rZVRq3oZ0W7BzNj94xpIoWfP/7u6xg69Nv3Bppllg=;
        b=wOFTH2yZse6pP0WzriAtRFMTdx7C4TZvmgu1uUYj7WuCrrCgZSUaKySQKea3PknDew
         uAheOKVTWfzRfBWsb8sJC1MLwTBCjMxc3F54P73wHMEriyA6Uqrnb8ZuZUwwr6QgoYVQ
         xicdPuGamZqAFzmW+zLxETr3jWw/3C7N5afsM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9/rZVRq3oZ0W7BzNj94xpIoWfP/7u6xg69Nv3Bppllg=;
        b=hkXt+U5AzY0d0cO3OhzTsuyVOyVFZWH9wRJsmA/pJynF+kMsf1PL6NMWZpaXXv08SR
         usiXVhVDaq6QuVNwkNhc8pqpQeg7Z+SVmR+Rk5dR6uW2tp5cNa1IwJCDowTIBSCdYN7R
         XDUlxNdRmz6YQhocpOHny+a00ZRn5Kum1cDqxf2CnMHoEUHD3F0YNFnXToa2uY9PGfXa
         PjjZF4r3+ULvTVeL6DyKDOAMaeErQdUKG5PZTVxzbn3ilrE+2DvFv8vsWUsh9Bycu09u
         wNEu/88vjwGSXlw60S4i3oZK49pvVqEdha2Otaf05DwYSluRW2+7z/PE47uVPMMTL5RP
         YjYQ==
X-Gm-Message-State: APjAAAX9HKnZxhX6WorKdiFWgTlY8ePHJ2dK6gBa2P/A9+zUmmRL3yDI
        9fzmbBE4widqpMEEPZys9aqH9A==
X-Google-Smtp-Source: APXvYqw3+i4pQCVary5mN2g/LIm9u9Tyez9cNYCJLlATQN7DE6LPwiytdLf5TK4hO9P0a2h+q2S48w==
X-Received: by 2002:adf:df0f:: with SMTP id y15mr71979666wrl.26.1582638999543;
        Tue, 25 Feb 2020 05:56:39 -0800 (PST)
Received: from localhost.localdomain ([2a06:98c0:1000:8800:3dea:15ba:1870:8e94])
        by smtp.gmail.com with ESMTPSA id t128sm4463580wmf.28.2020.02.25.05.56.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 05:56:38 -0800 (PST)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     ast@kernel.org, daniel@iogearbox.net, john.fastabend@gmail.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf-next 0/7] bpf: sockmap, sockhash: support storing UDP sockets
Date:   Tue, 25 Feb 2020 13:56:29 +0000
Message-Id: <20200225135636.5768-1-lmb@cloudflare.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for storing UDP sockets in sockmap and sockhash. This
allows using these maps in reuseport programs on UDP sockets, instead of
reuseport sockarrays. We want to use this in our work for BPF based
socket dispatch.

The first two patches make the sockmap code more generic: anything related to
ULP must only be called on TCP sockets, and some of the tcp_bpf hooks can be
re-used for UDP.

The third patch introduces a new struct psock_hooks, which encapsulates some
fiddly state handling required to support IPv6-as-a-module. I'm not
particularly fond of it, and would be happy for suggestions on how to make
it less obtrusive.

The fourth patch adds udp_bpf modeled on tcp_bpf, using struct psock_hooks,
and relaxes sockmap update checks.

The final patches enable tests.

Lorenz Bauer (7):
  bpf: sockmap: only check ULP for TCP sockets
  bpf: sockmap: move generic sockmap hooks from BPF TCP
  skmsg: introduce sk_psock_hooks
  bpf: sockmap: allow UDP sockets
  selftests: bpf: don't listen() on UDP sockets
  selftests: bpf: add tests for UDP sockets in sockmap
  selftests: bpf: enable UDP sockmap reuseport tests

 MAINTAINERS                                   |   1 +
 include/linux/bpf.h                           |   4 +-
 include/linux/skmsg.h                         |  72 ++++----
 include/linux/udp.h                           |   4 +
 include/net/tcp.h                             |   1 -
 net/core/skmsg.c                              |  52 ++++++
 net/core/sock_map.c                           | 155 +++++++++++-----
 net/ipv4/Makefile                             |   1 +
 net/ipv4/tcp_bpf.c                            | 169 ++++--------------
 net/ipv4/udp_bpf.c                            |  53 ++++++
 .../bpf/prog_tests/select_reuseport.c         |   7 -
 .../selftests/bpf/prog_tests/sockmap_listen.c | 139 ++++++++------
 12 files changed, 381 insertions(+), 277 deletions(-)
 create mode 100644 net/ipv4/udp_bpf.c

-- 
2.20.1

