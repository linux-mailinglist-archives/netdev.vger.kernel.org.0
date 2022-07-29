Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28D5F5851B3
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 16:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237170AbiG2OkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 10:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235911AbiG2Oj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 10:39:57 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B67A7D7A0
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 07:39:54 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id t17so7687351lfk.0
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 07:39:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=F7SbNKAQEXlk/zqoOCWnsvCdh1856YCA2pJnaiCNLaY=;
        b=by4vn/ioO/ZYreTWKKiOC27EsxMcq5Stve7Ecw7Ep4YhOvP53udzXxiKLH4TWPU/ot
         bc5uJ2dXIchNscIwNFf5joUYl/6TUMvpEKCgsJM5GGfuZgqN3nUVJUQBty61yIXkiaMh
         Xf3vbQ/YyNViW4U4/KwldCj/wpegJlNpYVPRo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=F7SbNKAQEXlk/zqoOCWnsvCdh1856YCA2pJnaiCNLaY=;
        b=ozMaTqxKMtkCBxG2qoVjArG6LMr2FRV6/T9ny7g7zAnOcHQunIX5s4lv50NVQa2M2k
         /HN1taPW+an40Aap5JnR02dFOf+PGMBNY5HNp66AbD37lgu1YlSRzTgnVNx/R0vNsWAO
         0xM1ImVrX9ogsyBr8IPCTbTUAdfTMrblrIeLwlxnPKzrw9DRRffz9d+cpNvmpoyZel/v
         QXe1FTUzpWj/vJ4fb+XDSrJyLAMvSWHUYzYdFA9Zz2hDF9ZeaIBKvTgkRUuRM1otWw8S
         sYf02cWIf5XekkWOleQ01vWqNKbZbqRxu1GGRiwKz6jldLbOKLQXnV05kJjJaNjkGaVI
         jr9g==
X-Gm-Message-State: AJIora8CEzjssIqjcR/VeD1Qk9XhZbSS9u3MwJd0a9jbMB1FKbL5BIau
        dMbuSp/NFfcd2D1Wzd+pKkBSxvf3mCgdoA==
X-Google-Smtp-Source: AGRyM1tGNH8skAl+WrpNcdyvHtJiBDQEkkAZ2EV0aqkk5wYtqpD3c45DFhXemRwnkDTv31x7T/1nig==
X-Received: by 2002:a05:6512:150b:b0:48a:6f2a:a6dc with SMTP id bq11-20020a056512150b00b0048a6f2aa6dcmr1321400lfb.563.1659105592472;
        Fri, 29 Jul 2022 07:39:52 -0700 (PDT)
Received: from localhost.localdomain ([2a01:110f:4304:1700:d82f:ac98:7032:476e])
        by smtp.gmail.com with ESMTPSA id i2-20020a196d02000000b0048ab15f2262sm678380lfc.96.2022.07.29.07.39.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 07:39:52 -0700 (PDT)
From:   Marek Majkowski <marek@cloudflare.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, kernel-team@cloudflare.com,
        ivan@cloudflare.com, edumazet@google.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, brakmo@fb.com,
        Marek Majkowski <marek@cloudflare.com>
Subject: [PATCH net-next v2 0/2] RTAX_INITRWND should be able to bring the rcv_ssthresh above 64KiB
Date:   Fri, 29 Jul 2022 16:39:33 +0200
Message-Id: <20220729143935.2432743-1-marek@cloudflare.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Among many route options we support initrwnd/RTAX_INITRWND path
attribute:

 $ ip route change local 127.0.0.0/8 dev lo initrwnd 1024

This sets the initial receive window size (in packets). However, it's
not very useful in practice. For smaller buffers (<128KiB) it can be
used to bring the initial receive window down, but it's hard to
imagine when this is useful. The same effect can be achieved with
TCP_WINDOW_CLAMP / RTAX_WINDOW option.

For larger buffers (>128KiB) the initial receive window is usually
limited by rcv_ssthresh, which starts at 64KiB. The initrwnd option
can't bring the window above it, which limits its usefulness

This patch changes that. Now, by setting RTAX_INITRWND path attribute
we bring up the initial rcv_ssthresh in line with the initrwnd
value. This allows to increase the initial advertised receive window
instantly, after first TCP RTT, above 64KiB.

With this change, the administrator can configure a route (or skops
ebpf program) where the receive window is opened much faster than
usual. This is useful on big BDP connections - large latency, high
throughput - where it takes much time to fully open the receive
window, due to the usual rcv_ssthresh cap.

However, this feature should be used with caution. It only makes sense
to employ it in limited circumstances:

 * When using high-bandwidth TCP transfers over big-latency links.
 * When the truesize of the flow/NIC is sensible and predictable.
 * When the application is ready to send a lot of data immediately
   after flow is established.
 * When the sender has configured larger than usual `initcwnd`.
 * When optimizing for every possible RTT.

This patch is related to previous work by Ivan Babrou:

  https://lore.kernel.org/bpf/CAA93jw5+LjKLcCaNr5wJGPrXhbjvLhts8hqpKPFx7JeWG4g0AA@mail.gmail.com/T/

Please note that due to TCP wscale semantics, the TCP sender will need
to receive first ACK to be informed of the large opened receive
window. That is: the large window is advertised only in the first ACK
from the peer. When the TCP client has large window, it is advertised
in the third-packet (ACK) of the handshake. When the TCP sever has
large window, it is advertised only in the first ACK after some data
has been received.

Syncookie support will be provided in subsequent patchet, since it
requires more changes.

*** BLURB HERE ***

Marek Majkowski (2):
  RTAX_INITRWND should be able to set the rcv_ssthresh above 64KiB
  Tests for RTAX_INITRWND

 include/linux/tcp.h                           |   1 +
 net/ipv4/tcp_minisocks.c                      |   9 +-
 net/ipv4/tcp_output.c                         |   7 +-
 .../selftests/bpf/prog_tests/tcp_initrwnd.c   | 420 ++++++++++++++++++
 .../selftests/bpf/progs/test_tcp_initrwnd.c   |  30 ++
 5 files changed, 463 insertions(+), 4 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/tcp_initrwnd.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_tcp_initrwnd.c

-- 
2.25.1

