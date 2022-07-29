Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44BF5585226
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 17:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232563AbiG2PNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 11:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbiG2PNL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 11:13:11 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC8792018C
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 08:13:10 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id w15so7731455lft.11
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 08:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nxmFT/vaZUMHWtUOuVktys2wX6Ce4r3JShjpg8XXvBU=;
        b=eoOabj0CwTFrjnWgXvDFEgFyXT/Vyp6Cf1I/55kQulH6t1veSZ6oqE/cGI8O68kviB
         TUYhAUFso59jooRJJAPT+/emnmxdH5TPrA9Xf77AUyZkDTccr2pmT1HPYVVqryIAiRKE
         xM63SsavxzT2FIIPExVpbM9NIU9BFNJdk+BLA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nxmFT/vaZUMHWtUOuVktys2wX6Ce4r3JShjpg8XXvBU=;
        b=J4veK+WTpikKyyitibSEYmrI28N9isUT4vnH5ZslAERxv9sAZy12Af6YsuC0eKo9jF
         JZbuJ/0Onr/wYoCJIDDP5BXyJQ+QS41zda3ywalWJybUiaX/e6grVQK1b/W09QQ5pdWf
         0p77GoXnHU49plv89g4EtvQ7mLq4I0QhmAW/zEl4LhCfQjbjCVDAF/BS8DqyZ81BtgwA
         SDM9Bs4ICVI4lktmwmLzXE8igh0OD4/cFnxlQ0lSVQr2ya79zACP/VUmaO/BdGlrh8oE
         YLr/NmE3Qu1vsy0zuwabBsFl8X2ZLwjPWYrCMIbCLUxK9O6GoAJsT4d1ccnM2U43g1gV
         +iZA==
X-Gm-Message-State: AJIora85OfFHSMXU11G3iDRBsl6snQ1USp7yFTc8lRjUHji32IhPNrYq
        WucsOVqfRZu+gn5gapaCmWweDgTDdvztNkV4pFEju6IZHVuGhQ==
X-Google-Smtp-Source: AA6agR5Mi6m32+Ue6siqyPLGXwmn2uVA0xZTRcfpkSTu9yuuh7xEYbIrn7D9LPEVD8gnt412hdISWZTSkO6wJjd/YqM=
X-Received: by 2002:a05:6512:3047:b0:48a:888a:4ba7 with SMTP id
 b7-20020a056512304700b0048a888a4ba7mr1598196lfb.642.1659107588521; Fri, 29
 Jul 2022 08:13:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220729143935.2432743-1-marek@cloudflare.com>
In-Reply-To: <20220729143935.2432743-1-marek@cloudflare.com>
From:   Marek Majkowski <marek@cloudflare.com>
Date:   Fri, 29 Jul 2022 17:12:57 +0200
Message-ID: <CAJPywTKe4yScX_brgZmMjsxX0G-6kV1NLVRzf8mwViuUDcNJkw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 0/2] RTAX_INITRWND should be able to bring the
 rcv_ssthresh above 64KiB
To:     network dev <netdev@vger.kernel.org>
Cc:     bpf <bpf@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Ivan Babrou <ivan@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, brakmo@fb.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 29, 2022 at 4:39 PM Marek Majkowski <marek@cloudflare.com> wrote:
>
> Among many route options we support initrwnd/RTAX_INITRWND path
> attribute:
>
>  $ ip route change local 127.0.0.0/8 dev lo initrwnd 1024
>
> This sets the initial receive window size (in packets). However, it's
> not very useful in practice. For smaller buffers (<128KiB) it can be
> used to bring the initial receive window down, but it's hard to
> imagine when this is useful. The same effect can be achieved with
> TCP_WINDOW_CLAMP / RTAX_WINDOW option.
>
> For larger buffers (>128KiB) the initial receive window is usually
> limited by rcv_ssthresh, which starts at 64KiB. The initrwnd option
> can't bring the window above it, which limits its usefulness
>
> This patch changes that. Now, by setting RTAX_INITRWND path attribute
> we bring up the initial rcv_ssthresh in line with the initrwnd
> value. This allows to increase the initial advertised receive window
> instantly, after first TCP RTT, above 64KiB.
>
> With this change, the administrator can configure a route (or skops
> ebpf program) where the receive window is opened much faster than
> usual. This is useful on big BDP connections - large latency, high
> throughput - where it takes much time to fully open the receive
> window, due to the usual rcv_ssthresh cap.
>
> However, this feature should be used with caution. It only makes sense
> to employ it in limited circumstances:
>
>  * When using high-bandwidth TCP transfers over big-latency links.
>  * When the truesize of the flow/NIC is sensible and predictable.
>  * When the application is ready to send a lot of data immediately
>    after flow is established.
>  * When the sender has configured larger than usual `initcwnd`.
>  * When optimizing for every possible RTT.
>
> This patch is related to previous work by Ivan Babrou:
>
>   https://lore.kernel.org/bpf/CAA93jw5+LjKLcCaNr5wJGPrXhbjvLhts8hqpKPFx7JeWG4g0AA@mail.gmail.com/T/
>
> Please note that due to TCP wscale semantics, the TCP sender will need
> to receive first ACK to be informed of the large opened receive
> window. That is: the large window is advertised only in the first ACK
> from the peer. When the TCP client has large window, it is advertised
> in the third-packet (ACK) of the handshake. When the TCP sever has
> large window, it is advertised only in the first ACK after some data
> has been received.
>
> Syncookie support will be provided in subsequent patchet, since it
> requires more changes.
>
> *** BLURB HERE ***
>
> Marek Majkowski (2):
>   RTAX_INITRWND should be able to set the rcv_ssthresh above 64KiB
>   Tests for RTAX_INITRWND
>
>  include/linux/tcp.h                           |   1 +
>  net/ipv4/tcp_minisocks.c                      |   9 +-
>  net/ipv4/tcp_output.c                         |   7 +-
>  .../selftests/bpf/prog_tests/tcp_initrwnd.c   | 420 ++++++++++++++++++
>  .../selftests/bpf/progs/test_tcp_initrwnd.c   |  30 ++
>  5 files changed, 463 insertions(+), 4 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/tcp_initrwnd.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_tcp_initrwnd.c

Changelog:
 - moved proposed rcv_ssthresh from `struct inet_request_soct` into
`struct tcp_request_sock` as per Eric's suggestion
 - extended tests to be more explicit about syncookies
