Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07606633437
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 04:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232308AbiKVDwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 22:52:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231939AbiKVDwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 22:52:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4BCD2B182;
        Mon, 21 Nov 2022 19:52:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6950861544;
        Tue, 22 Nov 2022 03:52:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36AABC433D6;
        Tue, 22 Nov 2022 03:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669089132;
        bh=RWB002zku9jkNyjRHnzm0iJ7hwXFfwF1xY7ksmp3tHs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Lf7MNtUeFCS9dZFnuqzVpzrMrmjaBTjmaab8OC9AnwhZX4Hu07u6Mjjq29HArIYqM
         m4FHPWEn+yLWz2l9nXsswaQuT01GT1FMWl4x8UperUKBrwhVrHaNlKgG4fVAiQDioh
         zOVo6C+7aKP9wa3AoU+Vq264OgVanBIjaYg6w7ZHLRf1oZyGS5Y/1xsFQC6hVVPAxK
         jCpef2lQ5pHAojOz5A/HQtEfgAqkuL07cppR0Qvbriv/UjLwoLNrWgDSgeMpzcOo16
         j/FvoAbkNtefSsNycTYuL3KHOgyjZLM0a/D5d3aOrtrH/9tfyKwPYszJvOHAgYr9xZ
         Mol2IdfEgGlfw==
Date:   Mon, 21 Nov 2022 19:52:11 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Jamie Bainbridge <jamie.bainbridge@gmail.com>,
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
Message-ID: <20221121195211.57748b1f@kernel.org>
In-Reply-To: <Y3v/Q+ZqEHvzra/k@x130.lan>
References: <d1ecf500f07e063d4e8e34f4045ddca55416c686.1668507036.git.geert+renesas@glider.be>
        <20221116123115.6b49e1b8@kernel.org>
        <CAAvyFNhbsks96=yyWHDCi-u+A1vaEy845_+pytghAscoG0rrTQ@mail.gmail.com>
        <20221116141519.0ef42fa2@kernel.org>
        <CAAvyFNjHp8-iq_A08O_H2VwEBLZRQe+=LzBm45ekgOZ4afnWqA@mail.gmail.com>
        <CAMuHMdVQdax10pAgNBbAVDXgVVTAQC93GR1f_4DuKfdAXngNMA@mail.gmail.com>
        <Y3v/Q+ZqEHvzra/k@x130.lan>
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

On Mon, 21 Nov 2022 14:44:19 -0800 Saeed Mahameed wrote:
> there's a macro inet6_rcv_saddr(sk), we can use it instead of directly
> referencing &sk->sk_v6_rcv_saddr, it already handles the case where 
> CONFIG_IPV6=n
> 
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -6845,7 +6845,7 @@ static bool tcp_syn_flood_action(const struct sock *sk, const char *proto)
>              xchg(&queue->synflood_warned, 1) == 0) {
>                  if (IS_ENABLED(CONFIG_IPV6) && sk->sk_family == AF_INET6) {
>                          net_info_ratelimited("%s: Possible SYN flooding on port [%pI6c]:%u. %s.\n",
> -                                       proto, &sk->sk_v6_rcv_saddr,
> +                                       proto, inet6_rcv_saddr(sk),

Great, could you post a full patch? I haven't seen v2, now it's almost
Thanksgiving..
