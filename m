Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0C8E632FF3
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 23:44:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbiKUWo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 17:44:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbiKUWoZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 17:44:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 189AEFCCB;
        Mon, 21 Nov 2022 14:44:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8015B816F4;
        Mon, 21 Nov 2022 22:44:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A7F0C433C1;
        Mon, 21 Nov 2022 22:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669070661;
        bh=ZXJJECGQ0S99KC2yQ/6jAkf93rwa43g3PrcUpdEzkzk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Re88SonaAaR06WFM54RXViujjgUtvoKBK60zEky7k0/eju0IwfNL1PCwbKs1G0889
         NjG4o+gUMsAjNNHhp6yW55WeXVRQrzla+qDyM4CqWV3bqBQ+psRat0lbgJlp2ZhHkI
         D05O0x3hO+97Y4Hkg6E9vLznDgP7SmbDQZnul3s8iu3W/i9GDys54lxo68+/U7AnDf
         aHaUYObtHY6GWxtnOlmYtjUH51mjIun/al6g63UUN437LhZQ6YEIi6U4TTa8rn9tDw
         3Lb464N/eNKIzGLwf1MBV4tdSh3PnqSNzOhoV9FVb5dmjZjRmND5VUBVRhJ4ZVg7Cm
         UFPgCVWpLZKUw==
Date:   Mon, 21 Nov 2022 14:44:19 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Jamie Bainbridge <jamie.bainbridge@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Chris Down <chris@chrisdown.name>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] tcp: Fix tcp_syn_flood_action() if CONFIG_IPV6=n
Message-ID: <Y3v/Q+ZqEHvzra/k@x130.lan>
References: <d1ecf500f07e063d4e8e34f4045ddca55416c686.1668507036.git.geert+renesas@glider.be>
 <20221116123115.6b49e1b8@kernel.org>
 <CAAvyFNhbsks96=yyWHDCi-u+A1vaEy845_+pytghAscoG0rrTQ@mail.gmail.com>
 <20221116141519.0ef42fa2@kernel.org>
 <CAAvyFNjHp8-iq_A08O_H2VwEBLZRQe+=LzBm45ekgOZ4afnWqA@mail.gmail.com>
 <CAMuHMdVQdax10pAgNBbAVDXgVVTAQC93GR1f_4DuKfdAXngNMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAMuHMdVQdax10pAgNBbAVDXgVVTAQC93GR1f_4DuKfdAXngNMA@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18 Nov 09:29, Geert Uytterhoeven wrote:
>Hi Jamie,
>
>On Fri, Nov 18, 2022 at 2:50 AM Jamie Bainbridge
><jamie.bainbridge@gmail.com> wrote:
>> On Thu, 17 Nov 2022 at 08:15, Jakub Kicinski <kuba@kernel.org> wrote:
>> > On Thu, 17 Nov 2022 08:39:43 +1100 Jamie Bainbridge wrote:
>> > > >         if (v6) {
>> > > > #ifdef v6
>> > > >                 expensive_call6();
>> > > > #endif
>> > > >         } else {
>> > > >                 expensive_call6();
>> > > >         }
>> > >
>> > > These should work, but I expect they cause a comparison which can't be
>> > > optimised out at compile time. This is probably why the first style
>> > > exists.
>> > >
>> > > In this SYN flood codepath optimisation doesn't matter because we're
>> > > doing ratelimited logging anyway. But if we're breaking with existing
>> > > style, then wouldn't the others also have to change to this style? I
>> > > haven't reviewed all the other usage to tell if they're in an oft-used
>> > > fastpath where such a thing might matter.
>> >
>> > I think the word style already implies subjectivity.
>>
>> You are right. Looking further, there are many other ways
>> IF_ENABLED(CONFIG_IPV6) is used, including similar to the ways you
>> have suggested.
>>
>> I don't mind Geert's original patch, but if you want a different
>> style, I like your suggestion with v4 first:
>>
>>         if (v4) {
>>                 expensive_call4();
>> #ifdef v6
>>         } else {
>>                 expensive_call6();
>> #endif
>>         }
>
>IMHO this is worse, as the #ifdef/#endif is spread across the two branches
>of an if-conditional.
>
>Hence this is usually written as:
>
>            if (cond1) {
>                    expensive_call1();
>            }
>    #ifdef cond2_enabled
>           else {
>                    expensive_call1();
>            }
>    #endif
>

I don't think any of this complication is needed, 

there's a macro inet6_rcv_saddr(sk), we can use it instead of directly
referencing &sk->sk_v6_rcv_saddr, it already handles the case where 
CONFIG_IPV6=n

--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6845,7 +6845,7 @@ static bool tcp_syn_flood_action(const struct sock *sk, const char *proto)
             xchg(&queue->synflood_warned, 1) == 0) {
                 if (IS_ENABLED(CONFIG_IPV6) && sk->sk_family == AF_INET6) {
                         net_info_ratelimited("%s: Possible SYN flooding on port [%pI6c]:%u. %s.\n",
-                                       proto, &sk->sk_v6_rcv_saddr,
+                                       proto, inet6_rcv_saddr(sk),

