Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58DCA29E475
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 08:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbgJ2HYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 03:24:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726957AbgJ2HYh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 03:24:37 -0400
Received: from forwardcorp1p.mail.yandex.net (forwardcorp1p.mail.yandex.net [IPv6:2a02:6b8:0:1472:2741:0:8b6:217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9901FC061787
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 21:24:01 -0700 (PDT)
Received: from myt5-23f0be3aa648.qloud-c.yandex.net (myt5-23f0be3aa648.qloud-c.yandex.net [IPv6:2a02:6b8:c12:3e29:0:640:23f0:be3a])
        by forwardcorp1p.mail.yandex.net (Yandex) with ESMTP id DFB292E097F;
        Thu, 29 Oct 2020 07:23:56 +0300 (MSK)
Received: from myt4-18a966dbd9be.qloud-c.yandex.net (myt4-18a966dbd9be.qloud-c.yandex.net [2a02:6b8:c00:12ad:0:640:18a9:66db])
        by myt5-23f0be3aa648.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id MAJBVvLcI5-Nu0CXqs1;
        Thu, 29 Oct 2020 07:23:56 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1603945436; bh=4rg5j/D1YjETHzKWON2QaTE5wGtuxMBS1PDdN/hFLx4=;
        h=To:Message-Id:References:Date:Subject:Cc:From:In-Reply-To;
        b=Xne6kgH8Uj42GMUn968pLjH4N53gwEaTmMFYO9skyf1jNN92+LZcqKV2ZfrtPM/ze
         RaDWIr0D+7VvG8ZArNYUShSNLdW230ArRMZtBKtIZQhUTE41CKITNJtel4CSTmwomK
         lTy5Nbtcp/qVGGv3LYJ2t7emYN8xFUyX8jPy1qvs=
Authentication-Results: myt5-23f0be3aa648.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from dynamic-vpn.dhcp.yndx.net (dynamic-vpn.dhcp.yndx.net [2a02:6b8:b080:6717::1:1])
        by myt4-18a966dbd9be.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id rWynb4FulW-NumOSvKr;
        Thu, 29 Oct 2020 07:23:56 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH net] ip6_tunnel: set inner ipproto before ip6_tnl_encap.
From:   Alexander Ovechkin <ovov@yandex-team.ru>
In-Reply-To: <CA+FuTSfNZoONM3TZxpC0ND2AsiNw0K-jgjKMe0FWkS9LVG6yNA@mail.gmail.com>
Date:   Thu, 29 Oct 2020 07:23:56 +0300
Cc:     vfedorenko@novek.ru, Network Development <netdev@vger.kernel.org>,
        Tom Herbert <tom@herbertland.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <ABA7FBA9-42F8-4D6E-9D1E-CDEC74966131@yandex-team.ru>
References: <20201016111156.26927-1-ovov@yandex-team.ru>
 <CA+FuTSe5szAPV0qDVU1Qa7e-XH6uO4eWELfzykOvpb0CJ0NbUA@mail.gmail.com>
 <0E7BC212-3BBA-4C68-89B9-C6DA956553AD@yandex-team.ru>
 <CA+FuTSfNZoONM3TZxpC0ND2AsiNw0K-jgjKMe0FWkS9LVG6yNA@mail.gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28 Oct 2020, at 01:53 UTC Willem de Bruijn =
<willemdebruijn.kernel@gmail.com> wrote:
> On Tue, Oct 27, 2020 at 5:52 PM Alexander Ovechkin =
<ovov@yandex-team.ru> wrote:
> >
> > > But it was moved on purpose to avoid setting the inner protocol to =
IPPROTO_MPLS. That needs to use skb->inner_protocol to further segment.
> > And why do we need to avoid setting the inner protocol to =
IPPROTO_MPLS? Currently skb->inner_protocol is used before call of =
ip6_tnl_xmit.
> > Can you please give example when this patch breaks MPLS =
segmentation?
>=20
> mpls_gso_segment calls skb_mac_gso_segment on the inner packet. After
> setting skb->protocol based on skb->inner_protocol.

Yeah, but mpls_gso_segment is called before ip6_tnl_xmit (because tun =
devices don't have NETIF_F_GSO_SOFTWARE in their mpls_features), so it =
does not matter to what value ip6_tnl_xmit sets skb->inner_ipproto.
And even if gso would been called after both mpls_xmit and ip6_tnl_xmit =
it would fail as you have written.

