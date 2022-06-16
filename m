Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7840754E77A
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 18:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236505AbiFPQmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 12:42:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233404AbiFPQmU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 12:42:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 612D331DD4
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 09:42:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5E89614B9
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 16:42:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C67AAC34114;
        Thu, 16 Jun 2022 16:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655397738;
        bh=5ZgX5XSLx4LI17piqGeL2ETC/NI8C2a9qc9/VELwp70=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IKZsedNXR3zzpjp8WBazltOSiDczefhFVVaEf8IJGcvTmLRjuXZZ2kBAWhOgAMrtZ
         +WnxprLamTGWUb+pHbXe8W+ANgNiWut+9tasYIdVH1RcqzozZx7Yh8je17GdHrlgUG
         fcIfWZytHCDPSMYkUCGJIzdqzuzHfppmbhHTNesmtA+vln/bXQnSpEJgsGZk+5/4qp
         HGbr71psILEk+1sh1ag9Injzs4vmgufn6lDZ0xKroPDYOk3CZWjHrV3fbaKVX48JMO
         0Sxwnjn5txsqLS9abLkIK8Nl1TAaqrHGk1xf7yKkib5ws9BkiOlvcitNAAGwnT617Y
         V1XObLjtDApsw==
Date:   Thu, 16 Jun 2022 09:42:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Maciej =?UTF-8?B?xbtlbmN6eWtvd3NraQ==?= <maze@google.com>
Cc:     "Subash Abhinov Kasiviswanathan (KS)" <quic_subashab@quicinc.com>,
        "David S. Miller" <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Linux NetDev <netdev@vger.kernel.org>,
        Stefano Brivio <sbrivio@redhat.com>,
        Kaustubh Pandey <quic_kapandey@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>
Subject: Re: [PATCH net v2 1/2] ipv6: Honor route mtu if it is within limit
 of dev mtu
Message-ID: <20220616094216.3bc9aef2@kernel.org>
In-Reply-To: <CANP3RGdRD=U7OAwrcdp1XUXFcb5b1zTfoy1fxa8JZUcnxBdsKg@mail.gmail.com>
References: <1655182915-12897-1-git-send-email-quic_subashab@quicinc.com>
        <1655182915-12897-2-git-send-email-quic_subashab@quicinc.com>
        <20220615173516.29c80c96@kernel.org>
        <CANP3RGfGcr25cjnrUOdaH1rG9S9uY8uS80USXeycDBhbsX9CZw@mail.gmail.com>
        <132e514e-bad8-9f73-8f08-1bd5ac8aecd4@quicinc.com>
        <CANP3RGdRD=U7OAwrcdp1XUXFcb5b1zTfoy1fxa8JZUcnxBdsKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Jun 2022 00:33:02 -0700 Maciej =C5=BBenczykowski wrote:
> On Wed, Jun 15, 2022 at 10:36 PM Subash Abhinov Kasiviswanathan (KS) <qui=
c_subashab@quicinc.com> wrote:
> > >> CC maze, please add him if there is v3
> > >>
> > >> I feel like the problem is with the fact that link mtu resets protoc=
ol
> > >> MTUs. Nothing we can do about that, so why not set link MTU to 9k (or
> > >> whatever other quantification of infinity there is) so you don't have
> > >> to touch it as you discover the MTU for v4 and v6? =20
> >
> > That's a good point. =20
>=20
> Because link mtu affects rx mtu which affects nic buffer allocations.
> Somewhere in the vicinity of mtu 1500..2048 your packets stop fitting
> in 2kB of memory and need 4kB (or more)

I was afraid someone would point that out :) Luckily the values Subash
mentioned were both under 2k, and hope fully the device can do scatter?=20
=F0=9F=A4=9E=F0=9F=98=9F (Don't modems do LRO or some other form of aggrega=
tion usually?)

> > >> My worry is that the tweaking of the route MTU update heuristic will
> > >> have no end.
> > >>
> > >> Stefano, does that makes sense or you think the change is good? =20
> >
> > The only concern is that current behavior causes the initial packets
> > after interface MTU increase to get dropped as part of PMTUD if the IPv6
> > PMTU itself didn't increase. I am not sure if that was the intended
> > behavior as part of the original change. Stefano, could you please conf=
irm?
> > =20
> > > I vaguely recall that if you don't want device mtu changes to affect
> > > ipv6 route mtu, then you should set 'mtu lock' on the routes.
> > > (this meaning of 'lock' for v6 is different than for ipv4, where
> > > 'lock' means transmit IPv4/TCP with Don't Frag bit unset) =20
> >
> > I assume 'mtu lock' here refers to setting the PMTU on the IPv6 routes
> > statically. The issue with that approach is that router advertisements
> > can no longer update PMTU once a static route is configured. =20
>=20
> yeah.   Hmm should RA generated routes use locked mtu too?
> I think the only reason an RA generated route would have mtu information
> is for it to stick...

If link MTU is lower than RA MTU do we do min() or ignore the RA MTU?
