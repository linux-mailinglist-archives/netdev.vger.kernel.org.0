Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1569529984A
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 21:56:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728490AbgJZU43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 16:56:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:50588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728475AbgJZU41 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 16:56:27 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3BA520829;
        Mon, 26 Oct 2020 20:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603745787;
        bh=ZYeixSLM+benaF4FJhIFA37rxWkwbIvYFJ7dhA/TjKs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=e4B54e/dRblvYvejjbAXIypWnsIEbi2EGS39I8MpjR+bpfvDyXLZXGWVNuc+eeKvS
         HobGm7yWZCS9aZ2gQlNJatUCxcidKYO7TRBELGevhCN/Nixs9If6YP1ZGPTBnisjWj
         JGbqCOvHIV8MO1WeEV2u4ExAWyVBfG3A4Hg6ZFv0=
Date:   Mon, 26 Oct 2020 13:56:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     wenxu <wenxu@ucloud.cn>
Cc:     netdev@vger.kernel.org, Stefano Brivio <sbrivio@redhat.com>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH net] ip_tunnel: fix over-mtu packet send fail without
 TUNNEL_DONT_FRAGMENT flags
Message-ID: <20201026135626.23684484@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <c4dae63c-6a99-922e-5bd0-03ac355779ae@ucloud.cn>
References: <1603272115-25351-1-git-send-email-wenxu@ucloud.cn>
        <20201023141254.7102795d@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <c4dae63c-6a99-922e-5bd0-03ac355779ae@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Oct 2020 16:23:29 +0800 wenxu wrote:
> On 10/24/2020 5:12 AM, Jakub Kicinski wrote:
> > On Wed, 21 Oct 2020 17:21:55 +0800 wenxu@ucloud.cn wrote: =20
> >> From: wenxu <wenxu@ucloud.cn>
> >>
> >> The TUNNEL_DONT_FRAGMENT flags specific the tunnel outer ip can do
> >> fragment or not in the md mode. Without the TUNNEL_DONT_FRAGMENT
> >> should always do fragment. So it should not care the frag_off in
> >> inner ip. =20
> > Can you describe the use case better? My understanding is that we
> > should propagate DF in normally functioning networks, and let PMTU=20
> > do its job. =20
>=20
> Sorry for relying so late.=C2=A0 ip_md_tunnel_xmit send packet in the col=
lect_md mode.
>=20
> For OpenVswitch example, ovs set the gre port with flags df_default=3Dfal=
se which will not
>=20
> set TUNNEL_DONT_FRAGMENT for tun_flags.
>=20
> And the mtu of virtual machine is 1500 with default. And the tunnel under=
lay device mtu
>=20
> is 1500 default too. So if the size of packet send from vm +=C2=A0 underl=
ay length > underlay device mtu.
>=20
> The packet always be dropped if the ip header of=C2=A0 packet set flags w=
ith DF.
>=20
> In the collect_md the outer packet can fragment or not should depends on =
the tun_flags but not inner
>=20
> ip header like vxlan device did.

Is this another incarnation of 4cb47a8644cc ("tunnels: PMTU discovery
support for directly bridged IP packets")? Sounds like non-UDP tunnels
need the same treatment to make PMTUD work.

RFC2003 seems to clearly forbid ignoring the inner DF:

      Identification, Flags, Fragment Offset

         These three fields are set as specified in [10].  However, if
         the "Don't Fragment" bit is set in the inner IP header, it MUST
         be set in the outer IP header; if the "Don't Fragment" bit is
         not set in the inner IP header, it MAY be set in the outer IP
         header, as described in Section 5.1.

and:

   [..] In
   particular, use of IP options is allowed, and use of fragmentation is
   allowed unless the "Don't Fragment" bit is set in the inner IP
   header.  This restriction on fragmentation is required so that nodes
   employing Path MTU Discovery [7] can obtain the information they
   seek.
