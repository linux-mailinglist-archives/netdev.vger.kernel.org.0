Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6791C1BB085
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 23:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbgD0Vbs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 17:31:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:39870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726275AbgD0Vbs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 17:31:48 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82DE92070B;
        Mon, 27 Apr 2020 21:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588023107;
        bh=VB1xn9K9KLA5v953nUF6UQvO8dSaJRFT1PreInCA4NU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uSlgWWZzF6MFmwFr3G8gGFlYu5eYAwflcCPGvkS+ajnbQDVep57GJxwNPedQxSPas
         Yp6kSf1gHW2+oGmaMcuLuV4l6R6Ze9UsiFoshGzPXjSyoper7lJ20FjjW9pTh/A5GZ
         nVRRhnPaYbw4yCovXQGalcYUC2dxcUh3+goy9A40=
Date:   Mon, 27 Apr 2020 14:31:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, netdev@vger.kernel.org,
        Adhipati Blambangan <adhipati@tuta.io>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net v3] net: xdp: account for layer 3 packets in generic
 skb handler
Message-ID: <20200427143145.19008d7d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <877dy0y6le.fsf@toke.dk>
References: <CAHmME9oN0JueLJxvS48-o9CWAhkaMQYACG3m8TRixxTo6+Oh-A@mail.gmail.com>
 <20200427204208.2501-1-Jason@zx2c4.com>
 <20200427135254.3ab8628d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200427140039.16df08f5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <877dy0y6le.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Apr 2020 23:14:05 +0200 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> Jakub Kicinski <kuba@kernel.org> writes:
> > On Mon, 27 Apr 2020 13:52:54 -0700 Jakub Kicinski wrote: =20
> >> On Mon, 27 Apr 2020 14:42:08 -0600 Jason A. Donenfeld wrote: =20
> >> > A user reported that packets from wireguard were possibly ignored by=
 XDP
> >> > [1]. Apparently, the generic skb xdp handler path seems to assume th=
at
> >> > packets will always have an ethernet header, which really isn't alwa=
ys
> >> > the case for layer 3 packets, which are produced by multiple drivers.
> >> > This patch fixes the oversight. If the mac_len is 0, then we assume
> >> > that it's a layer 3 packet, and in that case prepend a pseudo ethhdr=
 to
> >> > the packet whose h_proto is copied from skb->protocol, which will ha=
ve
> >> > the appropriate v4 or v6 ethertype. This allows us to keep XDP progr=
ams'
> >> > assumption correct about packets always having that ethernet header,=
 so
> >> > that existing code doesn't break, while still allowing layer 3 devic=
es
> >> > to use the generic XDP handler. =20
> >>=20
> >> Is this going to work correctly with XDP_TX? presumably wireguard
> >> doesn't want the ethernet L2 on egress, either? And what about
> >> redirects?
> >>=20
> >> I'm not sure we can paper over the L2 differences between interfaces.
> >> Isn't user supposed to know what interface the program is attached to?
> >> I believe that's the case for cls_bpf ingress, right? =20
> >
> > In general we should also ask ourselves if supporting XDPgeneric on
> > software interfaces isn't just pointless code bloat, and it wouldn't
> > be better to let XDP remain clearly tied to the in-driver native use
> > case. =20
>=20
> I was mostly ignoring generic XDP for a long time for this reason. But
> it seems to me that people find generic XDP quite useful, so I'm no
> longer so sure this is the right thing to do...

I wonder, maybe our documentation is not clear. IOW we were saying that
XDP is a faster cls_bpf, which leaves out the part that XDP only makes
sense for HW/virt devices.

Kinda same story as XDP egress, folks may be asking for it but that
doesn't mean it makes sense.

Perhaps the original reporter realized this and that's why they
disappeared?

My understanding is that XDP generic is aimed at testing and stop gap
for drivers which don't implement native. Defining behavior based on
XDP generic's needs seems a little backwards, and risky.

That said, I don't feel particularly strongly about this.
