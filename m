Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2965453702E
	for <lists+netdev@lfdr.de>; Sun, 29 May 2022 09:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbiE2HcT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 29 May 2022 03:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiE2HcR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 May 2022 03:32:17 -0400
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3E156C0EB
        for <netdev@vger.kernel.org>; Sun, 29 May 2022 00:32:14 -0700 (PDT)
Received: (Authenticated sender: pbl@bestov.io)
        by mail.gandi.net (Postfix) with ESMTPSA id 28B2E240004;
        Sun, 29 May 2022 07:32:11 +0000 (UTC)
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=UTF-8
Date:   Sun, 29 May 2022 09:32:08 +0200
Message-Id: <CKC2JT09MKR2.32I3TC5GHHJC9@enhorning>
From:   "Riccardo Paolo Bestetti" <pbl@bestov.io>
To:     =?utf-8?q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Cc:     "David Ahern" <dsahern@kernel.org>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Lorenzo Colitti" <lorenzo@google.com>,
        "Linux NetDev" <netdev@vger.kernel.org>
Subject: Re: REGRESSION?? ping ipv4 sockets and binding to 255.255.255.255
 without IP_TRANSPARENT
X-Mailer: aerc 0.9.0
References: <CANP3RGdkAcDyAZoT1h8Gtuu0saq+eOrrTiWbxnOs+5zn+cpyKg@mail.gmail.com> <CKBUCV5XNA5W.1WFEM5DTPSCHV@enhorning> <CANP3RGcBjYL0hpd-J_GvXCJsbOg3ztS5yhXr4S8M5G5_F1ZwLQ@mail.gmail.com>
In-Reply-To: <CANP3RGcBjYL0hpd-J_GvXCJsbOg3ztS5yhXr4S8M5G5_F1ZwLQ@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun May 29, 2022 at 8:14 AM CEST, Maciej Żenczykowski wrote:
> On Sat, May 28, 2022 at 6:07 PM Riccardo Paolo Bestetti <pbl@bestov.io> wrote:
> > I confirm that, indeed, it was unintended.
>
> Good to hear this.
>
> > Nothing about the behaviour of broadcast and multicast bind addresses is
> > mentioned in the commit message or linked Mac OS X documentation
> > (although it would be interesting to test how Mac OS X behaves - anyone
> > with a Mac around here that can do that?)
>
> I think sending with ping multicast/broadcast source is unlikely to get replies
> due to valid worries that it is an attempt at a multiplication DoS attack.
> (send one unicast packet to target, get target to reply with broadcast 'storm')

I agree. I find it likely that other implementation also would disallow
to bind on such addresses. I'll see if I can find out more this week.

>
> > I agree, it doesn't make sense to be able to do that. That's probably
> > why the check was done that way in the first place. I think the previous
> > behaviour should be restored. Not by reverting (part of) the patch,
> > because honestly the original code sucked, but by rewriting it properly.
>
> I'm failing to see a way to write it in a more obvious way...
>
> ipv4_is_zeroaddr() should probably be tree-wide renamed to ipv4_addr_any()
> to match ipv6_addr_any() which now saves the same purpose.
> [since it's just a check for 0.0.0.0/32 now after Dave Taht's commit]
>
> Then the following:
>
> if (ipv4_is_zeronet(addr) || ipv4_is_lbcast(addr))
> return RTN_BROADCAST;
>
> is more immediately weird.
>
> Why do we classify INADDR_ANY as broadcast?

That's what I was also wondering. But inet_addr_type() is not only
referenced 8 times inside the kernel, but also exported. So ultimately
the reason for returning RTN_BROADCAST is irrelevant as it's here to
stay. That's probably why the original code was "correcting" its
semantics on the fly by explicitly checking for 0.0.0.0 and remarketing
it as RTN_LOCAL.

As for ipv4_is_zeronet() vs ipv4_addr_any(), I do agree ipv4_addr_any()
is more consistent with other stuff and a better name by itself.

> It should either be classified as a new RTN_ADDR_ANY or as RTN_LOCAL,
> with the understanding that in practice 0.0.0.0/32 just means "don't care
> assign something for me".

Again, inet_addr_type() is exported...

>
> I guess one could do:
>
>  if (!ipv4_addr_any() && (!inet_can_nonlocal_bind(net, isk) &&
>                     chk_addr_ret != RTN_LOCAL) ||
>                    chk_addr_ret == RTN_MULTICAST
>                    chk_addr_ret == RTN_BROADCAST))
>                         return -EADDRNOTAVAIL;
>
> But that's not really any more meaningfully readable than the old code.

I think this is already significantly better than checking for 0.0.0.0
separately and changing chk_addr_ret depending on that. I also feel that
a comment, in this case, might go a long way. And all the
nonlocal-is-allowed-or-address-is-local logic could go in one line.
Maybe along the lines of:

/* never accept multicast and broadcast addresses */
if (!ipv4_addr_any() &&
    (chk_addr_ret != RTN_LOCAL && !inet_can_nonlocal_bind(...)) ||
    chk_addr_ret == RTN_MULTICAST || chk_addr_ret == RTN_BROADCAST))
                         return -EADDRNOTAVAIL;

This, to me, is loads more readable than the pre-5.17 code.

Riccardo P. Bestetti

>
> > And more importantly I think that test cases for that should be added in
> > the kernel (this has been in two released minor versions before even
> > being caught...)
> >
> > I should be able to roll up a patch inside a few days, if this sounds
> > like a good approach to everyone.

