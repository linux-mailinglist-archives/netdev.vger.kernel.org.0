Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1A12EBC72
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 11:36:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbhAFKfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 05:35:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45297 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726009AbhAFKfb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 05:35:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609929244;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s5T2eBVj732TZ2Xo37ZUASGYTwxSlB0RoMomiGIXTq4=;
        b=CE4sD5tQDO48IJwqSwTI+SL1rJJ4Gvv2kuQGxrEvTQYmD7pKwk03mhlFpJfRQYHuLX7IaU
        /LFV52FKk4ASQF31ItNr365KLVJRdBbHSHlmtKlY6Z1Kyty/1Lak0g5xBEIV/7noILiT8T
        GnBe8/gpqj/vlrXpwt5Sf0wmYN73TTI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-238-tYfjcLvmPpODyWSGTZrYWQ-1; Wed, 06 Jan 2021 05:34:00 -0500
X-MC-Unique: tYfjcLvmPpODyWSGTZrYWQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BAAE9801B1B;
        Wed,  6 Jan 2021 10:33:58 +0000 (UTC)
Received: from carbon (unknown [10.36.110.37])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1F0FD722C0;
        Wed,  6 Jan 2021 10:33:52 +0000 (UTC)
Date:   Wed, 6 Jan 2021 11:33:50 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
Cc:     brouer@redhat.com, Sven Auhagen <sven.auhagen@voleatech.de>,
        netdev@vger.kernel.org, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Matteo Croce <mcroce@microsoft.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCH net-next] net: mvpp2: increase MTU limit when XDP
 enabled
Message-ID: <20210106113350.46d0c659@carbon>
In-Reply-To: <20210105184308.1d2b7253@kernel.org>
References: <20210105171921.8022-1-kabel@kernel.org>
        <20210105172437.5bd2wypkfw775a4v@svensmacbookair.sven.lan>
        <20210105184308.1d2b7253@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 Jan 2021 18:43:08 +0100
Marek Beh=C3=BAn <kabel@kernel.org> wrote:

> On Tue, 5 Jan 2021 18:24:37 +0100
> Sven Auhagen <sven.auhagen@voleatech.de> wrote:
>=20
> > On Tue, Jan 05, 2021 at 06:19:21PM +0100, Marek Beh=C3=BAn wrote: =20
> > > Currently mvpp2_xdp_setup won't allow attaching XDP program if
> > >   mtu > ETH_DATA_LEN (1500).
> > >=20
> > > The mvpp2_change_mtu on the other hand checks whether
> > >   MVPP2_RX_PKT_SIZE(mtu) > MVPP2_BM_LONG_PKT_SIZE.
> > >=20
> > > These two checks are semantically different.
> > >=20
> > > Moreover this limit can be increased to MVPP2_MAX_RX_BUF_SIZE, since =
in
> > > mvpp2_rx we have
> > >   xdp.data =3D data + MVPP2_MH_SIZE + MVPP2_SKB_HEADROOM;
> > >   xdp.frame_sz =3D PAGE_SIZE;
> > >=20
> > > Change the checks to check whether
> > >   mtu > MVPP2_MAX_RX_BUF_SIZE   =20
> >=20
> > Hello Marek,
> >=20
> > in general, XDP is based on the model, that packets are not bigger
> > than 1500.

This is WRONG.

The XDP design/model (with PAGE_SIZE 4096) allows MTU to be 3506 bytes.

This comes from:
 * 4096 =3D frame_sz =3D PAGE_SIZE
 * -256 =3D reserved XDP_PACKET_HEADROOM
 * -320 =3D reserved tailroom with sizeof(skb_shared_info)
 * - 14 =3D Ethernet header size as MTU value is L3

4096-256-320-14 =3D 3506 bytes

Depending on driver memory layout choices this can (of-cause) be lower.

> > I am not sure if that has changed, I don't believe Jumbo Frames are
> > upstreamed yet.

This is unrelated to this patch, but Lorenzo and Eelco is assigned to
work on this.

> > You are correct that the MVPP2 driver can handle bigger packets
> > without a problem but if you do XDP redirect that won't work with
> > other drivers and your packets will disappear. =20
>=20

This statement is too harsh.  The XDP layer will not do (IP-level)
fragmentation for you.  Thus, if you redirect/transmit frames out
another interface with lower MTU than the frame packet size then the
packet will of-cause be dropped (the drop counter is unfortunately not
well defined).  This is pretty standard behavior.

This is why I'm proposing the BPF-helper bpf_check_mtu().  To allow the
BPF-prog to check the MTU before doing the redirect.


> At least 1508 is required when I want to use XDP with a Marvell DSA
> switch: the DSA header is 4 or 8 bytes long there.
>=20
> The DSA driver increases MTU on CPU switch interface by this length
> (on my switches to 1504).
>=20
> So without this I cannot use XDP with mvpp2 with a Marvell switch with
> default settings, which I think is not OK.
>=20
> Since with the mvneta driver it works (mvneta checks for
> MVNETA_MAX_RX_BUF_SIZE rather than ETH_DATA_LEN), I think it should also =
work
> with mvpp2.

I think you patch makes perfect sense.

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

