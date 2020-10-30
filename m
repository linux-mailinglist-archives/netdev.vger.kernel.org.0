Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A21B129FA64
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 02:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbgJ3BOW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 21:14:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:44926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725771AbgJ3BOW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 21:14:22 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C24AD2072C;
        Fri, 30 Oct 2020 01:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604020461;
        bh=6XlX9VjXcc098sFei0ZaIwKaKUlm12fGSh08Mypgy/8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uWeClCRt4l/cIeS2dgM4D3VHedAYPH7NaXU8FdU3epCLoQyqhQYD4Jallv1vhtaiu
         uN20HQKwY9xsCKh/mh1T/I03IVP+QVpTUeDPSCBKjp9r4eX0kFRnfua83KSmNlaYPo
         1Vb+KnFNFvjpsxshr5bWKO8NyhUIv3sgexjPcIhU=
Date:   Thu, 29 Oct 2020 18:14:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     wenxu <wenxu@ucloud.cn>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        Stefano Brivio <sbrivio@redhat.com>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH net] ip_tunnel: fix over-mtu packet send fail without
 TUNNEL_DONT_FRAGMENT flags
Message-ID: <20201029181419.0931f7ab@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <057f100e-2b80-f831-0a22-8d2dfe5529bd@ucloud.cn>
References: <1603272115-25351-1-git-send-email-wenxu@ucloud.cn>
        <20201023141254.7102795d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <c4dae63c-6a99-922e-5bd0-03ac355779ae@ucloud.cn>
        <20201026135626.23684484@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <8e24e490-b3bf-5268-4bd5-98b598b36b36@gmail.com>
        <20201027085548.05b39e0d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <057f100e-2b80-f831-0a22-8d2dfe5529bd@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Oct 2020 10:30:50 +0800 wenxu wrote:
> On 10/27/2020 11:55 PM, Jakub Kicinski wrote:
> > On Tue, 27 Oct 2020 08:51:07 -0600 David Ahern wrote: =20
> >>> Is this another incarnation of 4cb47a8644cc ("tunnels: PMTU discovery
> >>> support for directly bridged IP packets")? Sounds like non-UDP tunnels
> >>> need the same treatment to make PMTUD work.
> >>>
> >>> RFC2003 seems to clearly forbid ignoring the inner DF:   =20
> >> I was looking at this patch Sunday night. To me it seems odd that
> >> packets flowing through the overlay affect decisions in the underlay
> >> which meant I agree with the proposed change. =20
> > The RFC was probably written before we invented terms like underlay=20
> > and overlay, and still considered tunneling to be an inefficient hack ;)
> > =20
> >> ip_md_tunnel_xmit is inconsistent right now. tnl_update_pmtu is called
> >> based on the TUNNEL_DONT_FRAGMENT flag, so why let it be changed later
> >> based on the inner header? Or, if you agree with RFC 2003 and the DF
> >> should be propagated outer to inner, then it seems like the df reset
> >> needs to be moved up before the call to tnl_update_pmtu =20
> > Looks like TUNNEL_DONT_FRAGMENT is intended to switch between using
> > PMTU inside the tunnel or just the tunnel dev MTU. ICMP PTB is still
> > generated based on the inner headers.
> >
> > We should be okay to add something like IFLA_GRE_IGNORE_DF to lwt,=20
> > but IMHO the default should not be violating the RFC. =20
>=20
> If we add=C2=A0 TUNNEL_IGNORE_DF to lwt,=C2=A0 the two IGNORE_DF and DONT=
_FRAGMENT
>=20
> flags should not coexist ?=C2=A0=C2=A0 Or DONT_FRAGMENT is prior to the I=
GNORE_DF?
>=20
>=20
> Also there is inconsistent in the kernel for the tunnel device. For genev=
e and
>=20
> vxlan tunnel (don't send tunnel with ip_md_tunnel_xmit) in the lwt mode s=
et
>=20
> the outer df only based=C2=A0 TUNNEL_DONT_FRAGMENT .
>=20
> And this is also the some behavior for gre device before switching to use=
=20
> ip_md_tunnel_xmit as the following patch.
>=20
> 962924f ip_gre: Refactor collect metatdata mode tunnel xmit to ip_md_tunn=
el_xmit

Ah, that's a lot more convincing, I was looking at the Fixes tag you
provided, but it seems like Fixes should really point at the commit you
mention here.

Please mention the change in GRE behavior and the discrepancy between
handling of DF by different tunnels in the commit message and repost.
