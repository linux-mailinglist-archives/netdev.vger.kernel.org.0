Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38D1017DE4E
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 12:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgCILNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 07:13:11 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35585 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbgCILNL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 07:13:11 -0400
Received: by mail-wr1-f66.google.com with SMTP id r7so10552472wro.2
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 04:13:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CYROj5HsRYbnBFzlK0FzkrwDUfzZsnteghLz6nqHevI=;
        b=t6D3f0aQpn8rgusmcwNDPyMX4Ge1CTlojGAW1FhMP3gEWYZRKqAZt4BA17FONeKtds
         Z1N4Wn1IFMIT9GTUDcCH22VQXy9q4nOeNuLfAH5SFuGW8/M7KlonMp0ekhOCEW9IGosy
         KWUNUkrLo7v+MgPV8MV5d1OupI6+HJj5LcRu0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CYROj5HsRYbnBFzlK0FzkrwDUfzZsnteghLz6nqHevI=;
        b=KXvKNGJuTEmjeLmhWvz2Og9M9xhRPYXmieUJk/j0nHEkfQnEHVC1qxD6zHgk2woHOL
         /WssnHrpQYZn4bMlLL6YRFkz7vhMLqN5GHAcun8E//z2FrCy6xqPEll5grB9u6Okoswh
         tVnHEMCjCBSLP/sEhTM1xfnSKjaNVrZOjxq3h3/cZMmuLftLiaXH7R1u2xCtjeYKtJJ2
         4Oj+AUrTcBliEaTqqPVekOhs7Kg0Jt8VyOVCk23oEuLBxlxMg860CWlfYLuxW9lv3lQr
         4SGEh2Rro9Slbhm2/vgSrUpaxkYKZ3KpvTDQ4yupkiUcvrzU+Ce6rnjHMFUNwNNBW3Ip
         6ISQ==
X-Gm-Message-State: ANhLgQ35uKM+6FfouxeQFAuAXvLRVRdRULQt9YDIbDysP7ppJy+JycPG
        cRJZNhcJ4nMdiioPq9fpNxuBNQ==
X-Google-Smtp-Source: ADFU+vuEqABspoMtH2L9hlsNVwAkxs96SFOjG9gFG/lIYA1AV6FZOaFo4wEnzdIyJGKwCALNb1nvAA==
X-Received: by 2002:a05:6000:1187:: with SMTP id g7mr19940280wrx.382.1583752388090;
        Mon, 09 Mar 2020 04:13:08 -0700 (PDT)
Received: from localhost.localdomain ([2a06:98c0:1000:8250:3dcc:c1d:7f05:4873])
        by smtp.gmail.com with ESMTPSA id a5sm25732846wmb.37.2020.03.09.04.13.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 04:13:07 -0700 (PDT)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next v4 00/12] bpf: sockmap, sockhash: support storing UDP sockets
Date:   Mon,  9 Mar 2020 11:12:31 +0000
Message-Id: <20200309111243.6982-1-lmb@cloudflare.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I've adressed John's nit in patch 3, and added the reviews and acks.

Changes since v3:
- Clarify !psock check in sock_map_link_no_progs

Changes since v2:
- Remove sk_psock_hooks based on Jakub's idea
- Fix reference to tcp_bpf_clone in commit message
- Add inet_csk_has_ulp helper

Changes since v1:
- Check newsk->sk_prot in tcp_bpf_clone
- Fix compilation with BPF_STREAM_PARSER disabled
- Use spin_lock_init instead of static initializer
- Elaborate on TCPF_SYN_RECV
- Cosmetic changes to TEST macros, and more tests
- Add Jakub and me as maintainers

Lorenz Bauer (12):
  bpf: sockmap: only check ULP for TCP sockets
  skmsg: update saved hooks only once
  bpf: tcp: move assertions into tcp_bpf_get_proto
  bpf: tcp: guard declarations with CONFIG_NET_SOCK_MSG
  bpf: sockmap: move generic sockmap hooks from BPF TCP
  bpf: sockmap: simplify sock_map_init_proto
  bpf: add sockmap hooks for UDP sockets
  bpf: sockmap: add UDP support
  selftests: bpf: don't listen() on UDP sockets
  selftests: bpf: add tests for UDP sockets in sockmap
  selftests: bpf: enable UDP sockmap reuseport tests
  bpf, doc: update maintainers for L7 BPF

 MAINTAINERS                                   |   3 +
 include/linux/bpf.h                           |   4 +-
 include/linux/skmsg.h                         |  56 ++---
 include/net/inet_connection_sock.h            |   6 +
 include/net/tcp.h                             |  20 +-
 include/net/udp.h                             |   5 +
 net/core/sock_map.c                           | 157 +++++++++++---
 net/ipv4/Makefile                             |   1 +
 net/ipv4/tcp_bpf.c                            | 114 ++--------
 net/ipv4/tcp_ulp.c                            |   7 -
 net/ipv4/udp_bpf.c                            |  53 +++++
 .../bpf/prog_tests/select_reuseport.c         |   6 -
 .../selftests/bpf/prog_tests/sockmap_listen.c | 204 +++++++++++++-----
 13 files changed, 402 insertions(+), 234 deletions(-)
 create mode 100644 net/ipv4/udp_bpf.c

-- 
2.20.1

