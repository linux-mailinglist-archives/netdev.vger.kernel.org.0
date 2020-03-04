Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57174178E17
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 11:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729248AbgCDKNi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 05:13:38 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:35322 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbgCDKNh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 05:13:37 -0500
Received: by mail-lj1-f194.google.com with SMTP id a12so1364327ljj.2
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 02:13:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=l5VLUtAhfgBsOg4rLlIPQN68IyjJbYsnM/8jmzkLZnQ=;
        b=RIInD9Rl9eoyZ0sJ0STDuAF22JibGvVr3aRcUtVhDkdBnSbVOmtRAX9+5echD6mm63
         BnMTtLnvWMZ5nvEaAcOHY0ztXNuETcLi3xcKEr/Rr4X6c9a2XveXcTG4bdsEyJPaaKRr
         kucRLSIfDPte4frBdgzDikLSyUI2mmKdbWQaw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=l5VLUtAhfgBsOg4rLlIPQN68IyjJbYsnM/8jmzkLZnQ=;
        b=gTrqlxN90Ka8ty6YXPwUA2AZjGpHRzYbBO0sHGfbx9ozno5QMnmUq11h+FtsJ/95JB
         zsf7m0QtHxZ/+7aQBtKg8uhsKhMbwAVfpnw2xWkTIwF33vJtno2NcE1s0GS/KpUZ+rgp
         r+ayfEKNirh8KAKaBI9osP+DvgvztzTrYC9BCEoJEXcfLOii5SZG2M7MSdkwxnsd54nM
         +KvnAaXusM592dVXVkHPifcFUjWSQZWUqOGAPdEFK4Sk0EGAFEmtU35CbrtbzAdfL0JP
         s70XRClK8aaHjyQXjugk54NSFkexbmxXglWsC88HjhSQFRSnqPB1opb2jSdXBCP01p2Y
         /joA==
X-Gm-Message-State: ANhLgQ0y9Hfgm7kQBvHctoreYSW4ZWC9dHoSL7Fvv7GSEemucwvTj5OL
        UsqonuxnLCub+grWMVHlZyVyqw==
X-Google-Smtp-Source: ADFU+vuLnv++HnjkYrEVdCsFq4UJneukNpbkIfLrDxxcsvSJgk5pm6VKCjO5OpHJYP4UubwzN/Y1IQ==
X-Received: by 2002:a2e:3812:: with SMTP id f18mr1511119lja.129.1583316815678;
        Wed, 04 Mar 2020 02:13:35 -0800 (PST)
Received: from localhost.localdomain ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id l7sm341777lfk.65.2020.03.04.02.13.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 02:13:35 -0800 (PST)
From:   Lorenz Bauer <lmb@cloudflare.com>
To:     john.fastabend@gmail.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf-next v3 00/12] bpf: sockmap, sockhash: support storing UDP sockets
Date:   Wed,  4 Mar 2020 11:13:05 +0100
Message-Id: <20200304101318.5225-1-lmb@cloudflare.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks to Jakub's suggestion I was able to eliminate sk_psock_hooks!
Now TCP and UDP only need to export a single function get_proto,
which is called from the sockmap code. This reduced the amount of
boilerplate a bit. The downside is that the IPv6 proto rebuild is
copied and pasted from TCP, but I think I can live with that.

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

Jakub Sitnicki (2):
  bpf: add sockmap hooks for UDP sockets
  bpf: sockmap: add UDP support

Lorenz Bauer (10):
  bpf: sockmap: only check ULP for TCP sockets
  skmsg: update saved hooks only once
  bpf: tcp: move assertions into tcp_bpf_get_proto
  bpf: tcp: guard declarations with CONFIG_NET_SOCK_MSG
  bpf: sockmap: move generic sockmap hooks from BPF TCP
  bpf: sockmap: simplify sock_map_init_proto
  selftests: bpf: don't listen() on UDP sockets
  selftests: bpf: add tests for UDP sockets in sockmap
  selftests: bpf: enable UDP sockmap reuseport tests
  bpf, doc: update maintainers for L7 BPF

 MAINTAINERS                                   |   3 +
 include/linux/bpf.h                           |   4 +-
 include/linux/skmsg.h                         |  56 ++---
 include/net/tcp.h                             |  20 +-
 include/net/udp.h                             |   5 +
 net/core/sock_map.c                           | 158 +++++++++++---
 net/ipv4/Makefile                             |   1 +
 net/ipv4/tcp_bpf.c                            | 114 ++--------
 net/ipv4/udp_bpf.c                            |  53 +++++
 .../bpf/prog_tests/select_reuseport.c         |   6 -
 .../selftests/bpf/prog_tests/sockmap_listen.c | 204 +++++++++++++-----
 11 files changed, 399 insertions(+), 225 deletions(-)
 create mode 100644 net/ipv4/udp_bpf.c

-- 
2.20.1

