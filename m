Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59EB662FA08
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 17:19:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241212AbiKRQTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 11:19:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235414AbiKRQTJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 11:19:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1183261772;
        Fri, 18 Nov 2022 08:19:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A01AE625F2;
        Fri, 18 Nov 2022 16:19:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81E04C433C1;
        Fri, 18 Nov 2022 16:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668788348;
        bh=kB9TuL6/LlQULZYXATksegAy1GgdZD16NhQ1mIwxfrY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LQyhq+EyzCEp2r3JW5wEyYbn0KX06RmU7BQtp3QlSUd8c39dmuutcak3xErZx5Ilh
         V1Yw/c+tdCRf/R7s6aWhQPWlq8lRMFQdsn2f3UyXs2MLsWkcpxu+ODWlyiRwklMlVJ
         oYZ01yNpDJJmPtoMv+UsRv8/5U8PRd8KHPKvdFAcspIj/eIDHE369TyMT0ghSbLvQS
         lmVCHnXqkXZFQymEYZdMtKkS9Ka56axWkl2XbJms9sfCe20i8Ybv9ZznGaqLBuCWZ8
         ra+0OUM/Y0NGKGSfFZcCGplt7q43oVZSWYrcyWrphWP6uNGWoa1EGV+Mk+qSeWzuqU
         vegCgvhmTCdcQ==
Date:   Fri, 18 Nov 2022 08:19:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Jamie Bainbridge <jamie.bainbridge@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Chris Down <chris@chrisdown.name>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] tcp: Fix tcp_syn_flood_action() if
 CONFIG_IPV6=n
Message-ID: <20221118081906.053d5231@kernel.org>
In-Reply-To: <CAMuHMdVQdax10pAgNBbAVDXgVVTAQC93GR1f_4DuKfdAXngNMA@mail.gmail.com>
References: <d1ecf500f07e063d4e8e34f4045ddca55416c686.1668507036.git.geert+renesas@glider.be>
        <20221116123115.6b49e1b8@kernel.org>
        <CAAvyFNhbsks96=yyWHDCi-u+A1vaEy845_+pytghAscoG0rrTQ@mail.gmail.com>
        <20221116141519.0ef42fa2@kernel.org>
        <CAAvyFNjHp8-iq_A08O_H2VwEBLZRQe+=LzBm45ekgOZ4afnWqA@mail.gmail.com>
        <CAMuHMdVQdax10pAgNBbAVDXgVVTAQC93GR1f_4DuKfdAXngNMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Nov 2022 09:29:13 +0100 Geert Uytterhoeven wrote:
> IMHO this is worse, as the #ifdef/#endif is spread across the two branches
> of an if-conditional.
> 
> Hence this is usually written as:
> 
>             if (cond1) {
>                     expensive_call1();
>             }
>     #ifdef cond2_enabled
>            else {
>                     expensive_call1();
>             }
>     #endif

Alright, good enough for me.
