Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABEE0559D1E
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 17:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232580AbiFXPPh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 11:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232203AbiFXPPc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 11:15:32 -0400
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::224])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCF514E387;
        Fri, 24 Jun 2022 08:15:26 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 47228E0009;
        Fri, 24 Jun 2022 15:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1656083725;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8C1pYPeFG6ewoGUkNiTOuEAm3DxzdUPHi8Qj0Tqk/sM=;
        b=DvGenKFMhPmLrsjN/4lRuwa151q5eEmmuBYO/YlESIIvmrtefVJItOgrnQDS+iU2BKt9LN
        8TxwPU7dgQgm7StQ9uAR3Mn+pgHEiyfrg7LJbXhKOPDDeVsiurUn18Gp8nbCVAMOe+1lVX
        2MwITdLVMlW4yU2s3B9z28NmcHThvPRXkTqwfNoLWcYKaSG2aQOW6egmjhAwa1Njmv1Ukv
        U8gXcgXKZWY9MulZQ4r70lrOpqQkfaFXjTH6AZCAsUWDPAWl8Ql+DUc6ENGyuT6aF2KqYH
        f12IIi1ngS7mh63e3Y5Wuh1R5ORkRM946df11OucAv/0mdry1A8c0jKMsJin7g==
Date:   Fri, 24 Jun 2022 17:14:29 +0200
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] net: ocelot: fix wrong time_after usage
Message-ID: <20220624171429.4b3f7c0a@fixe.home>
In-Reply-To: <20220521162108.bact3sn4z2yuysdt@skbuf>
References: <YoeMW+/KGk8VpbED@lunn.ch>
        <20220520213115.7832-1-paskripkin@gmail.com>
        <YojvUsJ090H/wfEk@lunn.ch>
        <20220521162108.bact3sn4z2yuysdt@skbuf>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Sat, 21 May 2022 16:21:09 +0000,
Vladimir Oltean <vladimir.oltean@nxp.com> a =C3=A9crit :

> On Sat, May 21, 2022 at 03:55:30PM +0200, Andrew Lunn wrote:
> > On Sat, May 21, 2022 at 12:31:15AM +0300, Pavel Skripkin wrote: =20
> > > Accidentally noticed, that this driver is the only user of
> > > while (time_after(jiffies...)).
> > >=20
> > > It looks like typo, because likely this while loop will finish after =
1st
> > > iteration, because time_after() returns true when 1st argument _is af=
ter_
> > > 2nd one.
> > >=20
> > > There is one possible problem with this poll loop: the scheduler coul=
d put
> > > the thread to sleep, and it does not get woken up for
> > > OCELOT_FDMA_CH_SAFE_TIMEOUT_US. During that time, the hardware has do=
ne
> > > its thing, but you exit the while loop and return -ETIMEDOUT.
> > >=20
> > > Fix it by using sane poll API that avoids all problems described above
> > >=20
> > > Fixes: 753a026cfec1 ("net: ocelot: add FDMA support")
> > > Suggested-by: Andrew Lunn <andrew@lunn.ch>
> > > Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> > > ---
> > >=20
> > > I can't say if 0 is a good choise for 5th readx_poll_timeout() argume=
nt,
> > > so this patch is build-tested only. =20
> >  =20
> > > Testing and suggestions are welcomed! =20
> >=20
> > If you had the hardware, i would suggest you profile how often it does
> > complete on the first iteration. And when it does not complete on the
> > first iteration, how many more iterations it needs.
> >=20
> > Tobias made an interesting observation with the mv88e6xxx switch. He
> > found that two tight polls was enough 99% of the time. Putting a sleep
> > in there doubles the time it took to setup the switch. So he ended up
> > with a hybrid of open coded polling twice, followed by iopoll with a
> > timer value set.
> >=20
> > That was with a heavily used poll function. How often is this function
> > used? No point in overly optimising this if it is not used much. =20
>=20
> If you're looking at me, I don't have the hardware to test, sorry.
> Frame DMA is one of the components NXP removed when building their DSA
> variants of these switches. But the function is called once or twice per
> NAPI poll cycle, so it's worth optimizing as much as possible.
>=20
> Clement, could you please do some testing? The patch that Andrew is
> talking about is 35da1dfd9484 ("net: dsa: mv88e6xxx: Improve performance
> of busy bit polling").

So I actually tested and added logging to see if the CH_SAFE
register bits are set for the channel on the first iteration. From
what I could test (iperf3 with huge/non huge packets, TCP/UDP), it
always return true on the first try. So since I think Pavel solution
is ok to go with.

However, since ocelot_fdma_wait_chan_safe() is also called in the napi
poll function of this driver, I don't think sleeping is allowed (softirq
context) and thus I would suggest using the readx_poll_timeout_atomic()
function instead.

Regarding the delay to wait between each read, I don't have any
information about that possible value, the datasheet only says "wait
for the bit to be set" so I guess we'll have to live with an
approximate value.

Thanks,

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com
