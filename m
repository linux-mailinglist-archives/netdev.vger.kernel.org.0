Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE2557CEA6
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 17:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbiGUPKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 11:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbiGUPKr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 11:10:47 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF6E7326EE
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 08:10:45 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id u14so2219337lju.0
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 08:10:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MptTJbb61Fbfpy5+RhSNj+g4b3J/jacWr4hKToGbOk8=;
        b=us8DxT3nz0ZqUlB58qFSvjLeXOQQQepxWfDCNMP7QiFneIkTXvPsKni5dYLfyKtTLc
         s27bukBpoZ1Fqg1jP5wJq5xcwbqIPUMu3aiErTIoaUfI4VikjJgj5FtDaHQYzhqGak7s
         6Y5EExcE564cMEtK9iZQezPkO9HGPC7CIP/Ns=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MptTJbb61Fbfpy5+RhSNj+g4b3J/jacWr4hKToGbOk8=;
        b=JwyM8Lyt0hpj31Vtl8dHQiIQPvnELELVk5p70tfyClSAK6Tzi1JI3HxKfl5zEwl+3y
         4TAF+bIQ6wqWeA6E9zh6ElO3HTlW31Qx1XN8VjNugCFi8lMOw0LeDFl7+U3gcdKjknx4
         XVPYi3rY8Dp1tWiyrRhdaoQPlF2R+HERv79Hb/N9iBAUhNqzUGMC3pmEifQd2a+bSJWj
         n7AkuVYDOB9JQ/tt3WPIK5ETLf0rz2pqNYuKl2hHzbMmEYq9d0zNZ4si1iNuLZf+Faho
         vr9ZfZBKZAUgFi9scCbF7pBsNWO1gvF/3e4JvDgZW3XYNWrmM4rLlI+oBFm+KZyh0z4d
         AEGA==
X-Gm-Message-State: AJIora/A4agP91JymTywvNo1XIw1MOKu3gNHDivUPdFYZkrGu7HQWTyB
        y+YE73Diz+UkGUeV/OIAbdECwXE2WbUY5A==
X-Google-Smtp-Source: AGRyM1uEDVKqNBIwyKgaUoEshrA+hJwcG8aikkToYrA+fo3HUYapg+YC17QzBErP/0LRJbLP66reLw==
X-Received: by 2002:a2e:9787:0:b0:25d:6d00:eef4 with SMTP id y7-20020a2e9787000000b0025d6d00eef4mr18332779lji.14.1658416243824;
        Thu, 21 Jul 2022 08:10:43 -0700 (PDT)
Received: from mrprec.home (2a01-110f-4304-1700-37e6-7a9a-2637-d666.aa.ipv6.supernova.orange.pl. [2a01:110f:4304:1700:37e6:7a9a:2637:d666])
        by smtp.gmail.com with ESMTPSA id f3-20020a056512228300b00489dbecbd0csm205508lfu.189.2022.07.21.08.10.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 08:10:43 -0700 (PDT)
From:   Marek Majkowski <marek@cloudflare.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, kernel-team@cloudflare.com,
        ivan@cloudflare.com, edumazet@google.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org,
        Marek Majkowski <marek@cloudflare.com>
Subject: [PATCH net-next 0/2] RTAX_INITRWND should be able to bring the rcv_ssthresh above 64KiB
Date:   Thu, 21 Jul 2022 17:10:39 +0200
Message-Id: <20220721151041.1215017-1-marek@cloudflare.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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

Signed-off-by: Marek Majkowski <marek@cloudflare.com>

Marek Majkowski (2):
  RTAX_INITRWND should be able to bring the rcv_ssthresh above 64KiB
  Tests for RTAX_INITRWND

 include/net/inet_sock.h                       |   1 +
 net/ipv4/tcp_minisocks.c                      |   8 +-
 net/ipv4/tcp_output.c                         |  10 +-
 .../selftests/bpf/prog_tests/tcp_initrwnd.c   | 398 ++++++++++++++++++
 .../selftests/bpf/progs/test_tcp_initrwnd.c   |  30 ++
 5 files changed, 443 insertions(+), 4 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/tcp_initrwnd.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_tcp_initrwnd.c

-- 
2.25.1

