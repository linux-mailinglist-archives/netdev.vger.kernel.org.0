Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF84F29CB8A
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 22:52:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S374498AbgJ0VwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 17:52:04 -0400
Received: from forwardcorp1o.mail.yandex.net ([95.108.205.193]:40014 "EHLO
        forwardcorp1o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2506172AbgJ0VwE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 17:52:04 -0400
X-Greylist: delayed 422 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Oct 2020 17:52:02 EDT
Received: from myt5-23f0be3aa648.qloud-c.yandex.net (myt5-23f0be3aa648.qloud-c.yandex.net [IPv6:2a02:6b8:c12:3e29:0:640:23f0:be3a])
        by forwardcorp1o.mail.yandex.net (Yandex) with ESMTP id 56D322E1597;
        Wed, 28 Oct 2020 00:44:58 +0300 (MSK)
Received: from myt5-70c90f7d6d7d.qloud-c.yandex.net (myt5-70c90f7d6d7d.qloud-c.yandex.net [2a02:6b8:c12:3e2c:0:640:70c9:f7d])
        by myt5-23f0be3aa648.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id lAjLpUvWdF-iwwSuVbd;
        Wed, 28 Oct 2020 00:44:58 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1603835098; bh=JGOrwzGWWytmz4fLb118Q/4ueqJF2zTqJ9G+SCEgHSA=;
        h=To:Message-Id:References:Date:Subject:Cc:From:In-Reply-To;
        b=VD7XGYiIEkc+//t4BbPhbQhLqNpDTDVJyP7AL5MumZgH4fCzhhJM/9NVRA8A6Ha7g
         R/wQ19KIkWEQLEOmXl4Rz3Xw28tr0mqewIdrZdVhUfgrvaYKwR7NLq/8SWvjgzPTio
         jf5podB1tU9jvilhsvjXEl1hl2E8XjDJm10UpFYc=
Authentication-Results: myt5-23f0be3aa648.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from dynamic-vpn.dhcp.yndx.net (dynamic-vpn.dhcp.yndx.net [2a02:6b8:b080:6426::1:4])
        by myt5-70c90f7d6d7d.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id k9vX9l5I7v-ivmGw9gL;
        Wed, 28 Oct 2020 00:44:57 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH net] ip6_tunnel: set inner ipproto before ip6_tnl_encap.
From:   Alexander Ovechkin <ovov@yandex-team.ru>
In-Reply-To: <CA+FuTSe5szAPV0qDVU1Qa7e-XH6uO4eWELfzykOvpb0CJ0NbUA@mail.gmail.com>
Date:   Wed, 28 Oct 2020 00:44:57 +0300
Cc:     netdev@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <0E7BC212-3BBA-4C68-89B9-C6DA956553AD@yandex-team.ru>
References: <20201016111156.26927-1-ovov@yandex-team.ru>
 <CA+FuTSe5szAPV0qDVU1Qa7e-XH6uO4eWELfzykOvpb0CJ0NbUA@mail.gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        vfedorenko@novek.ru
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> But it was moved on purpose to avoid setting the inner protocol to =
IPPROTO_MPLS. That needs to use skb->inner_protocol to further segment.
And why do we need to avoid setting the inner protocol to IPPROTO_MPLS? =
Currently skb->inner_protocol is used before call of ip6_tnl_xmit.
Can you please give example when this patch breaks MPLS segmentation?

> On 16 Oct 2020, at 20:55, Willem de Bruijn =
<willemdebruijn.kernel@gmail.com> wrote:
>=20
> On Fri, Oct 16, 2020 at 7:14 AM Alexander Ovechkin =
<ovov@yandex-team.ru> wrote:
>>=20
>> ip6_tnl_encap assigns to proto transport protocol which
>> encapsulates inner packet, but we must pass to set_inner_ipproto
>> protocol of that inner packet.
>>=20
>> Calling set_inner_ipproto after ip6_tnl_encap might break gso.
>> For example, in case of encapsulating ipv6 packet in fou6 packet, =
inner_ipproto
>> would be set to IPPROTO_UDP instead of IPPROTO_IPV6. This would lead =
to
>> incorrect calling sequence of gso functions:
>> ipv6_gso_segment -> udp6_ufo_fragment -> skb_udp_tunnel_segment -> =
udp6_ufo_fragment
>> instead of:
>> ipv6_gso_segment -> udp6_ufo_fragment -> skb_udp_tunnel_segment -> =
ip6ip6_gso_segment
>>=20
>> Signed-off-by: Alexander Ovechkin <ovov@yandex-team.ru>
>=20
> Commit 6c11fbf97e69 ("ip6_tunnel: add MPLS transmit support") moved
> the call from ip6_tnl_encap's caller to inside ip6_tnl_encap.
>=20
> It makes sense that that likely broke this behavior for UDP (L4) =
tunnels.
>=20
> But it was moved on purpose to avoid setting the inner protocol to
> IPPROTO_MPLS. That needs to use skb->inner_protocol to further
> segment.
>=20
> I suspect we need to set this before or after conditionally to avoid
> breaking that use case.

