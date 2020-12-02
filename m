Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53FD02D0D84
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 10:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbgLGJ4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 04:56:11 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:49402 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726044AbgLGJ4K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 04:56:10 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 66100201C7;
        Mon,  7 Dec 2020 10:55:27 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id eXP1DVgCMtk0; Mon,  7 Dec 2020 10:55:26 +0100 (CET)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id EAB1F20270;
        Mon,  7 Dec 2020 10:55:26 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 7 Dec 2020 10:55:26 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Mon, 7 Dec 2020
 10:55:26 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id DDD3D31807D9; Wed,  2 Dec 2020 10:37:47 +0100 (CET)
Date:   Wed, 2 Dec 2020 10:37:47 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Eyal Birger <eyal.birger@gmail.com>
CC:     <herbert@gondor.apana.org.au>, David Miller <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [PATCH ipsec-next] xfrm: interface: support collect metadata mode
Message-ID: <20201202093747.GA85961@gauss3.secunet.de>
References: <20201121142823.3629805-1-eyal.birger@gmail.com>
 <20201127094414.GC9390@gauss3.secunet.de>
 <CAHsH6Gtgui7fbv1sPYUoOj_dZR5yajEd7+tLKwsv5FvQZCFOow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAHsH6Gtgui7fbv1sPYUoOj_dZR5yajEd7+tLKwsv5FvQZCFOow@mail.gmail.com>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 27, 2020 at 02:32:44PM +0200, Eyal Birger wrote:
> Hi Steffen,
> 
> On Fri, Nov 27, 2020 at 11:44 AM Steffen Klassert
> <steffen.klassert@secunet.com> wrote:
> >
> > On Sat, Nov 21, 2020 at 04:28:23PM +0200, Eyal Birger wrote:
> > > This commit adds support for 'collect_md' mode on xfrm interfaces.
> > >
> > > Each net can have one collect_md device, created by providing the
> > > IFLA_XFRM_COLLECT_METADATA flag at creation. This device cannot be
> > > altered and has no if_id or link device attributes.
> > >
> > > On transmit to this device, the if_id is fetched from the attached dst
> > > metadata on the skb. The dst metadata type used is METADATA_IP_TUNNEL
> > > since the only needed property is the if_id stored in the tun_id member
> > > of the ip_tunnel_info->key.
> >
> > Can we please have a separate metadata type for xfrm interfaces?
> >
> > Sharing such structures turned already out to be a bad idea
> > on vti interfaces, let's try to avoid that misstake with
> > xfrm interfaces.
> 
> My initial thought was to do that, but it looks like most of the constructs
> surrounding this facility - tc, nft, ovs, ebpf, ip routing - are built around
> struct ip_tunnel_info and don't regard other possible metadata types.

That is likely because most objects that have a collect_md mode are
tunnels. We have already a second metadata type, and I don't see
why we can't have a third one. Maybe we can create something more
generic so that it can have other users too.

> For xfrm interfaces, the only metadata used is the if_id, which is stored
> in the metadata tun_id, so I think other than naming consideration, the use
> of struct ip_tunnel_info does not imply tunneling and does not limit the
> use of xfrmi to a specific mode of operation.

I agree that this can work, but it is a first step into a wrong direction.
Using a __be64 field of a completely unrelated structure as an u32 if_id
is bad style IMO.

> On the other hand, adding a new metadata type would require changing all
> other places to regard the new metadata type, with a large number of
> userspace visible changes.

I admit that this might have some disadvantages too, but I'm not convinced
that this justifies the 'ip_tunnel_info' hack.

