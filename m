Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E42B2A05FD
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 13:54:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgJ3MyY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 08:54:24 -0400
Received: from forwardcorp1o.mail.yandex.net ([95.108.205.193]:53206 "EHLO
        forwardcorp1o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726531AbgJ3MyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 08:54:23 -0400
Received: from myt5-23f0be3aa648.qloud-c.yandex.net (myt5-23f0be3aa648.qloud-c.yandex.net [IPv6:2a02:6b8:c12:3e29:0:640:23f0:be3a])
        by forwardcorp1o.mail.yandex.net (Yandex) with ESMTP id 6FDF52E14E5;
        Fri, 30 Oct 2020 15:54:20 +0300 (MSK)
Received: from myt5-70c90f7d6d7d.qloud-c.yandex.net (myt5-70c90f7d6d7d.qloud-c.yandex.net [2a02:6b8:c12:3e2c:0:640:70c9:f7d])
        by myt5-23f0be3aa648.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id 07XLD03vIa-sK0q6hW4;
        Fri, 30 Oct 2020 15:54:20 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1604062460; bh=+Twee2elVIojNkL5OH2SmfPhN6Uz7UYHLkV5WWrr2Cg=;
        h=To:Message-Id:References:Date:Subject:Cc:From:In-Reply-To;
        b=YdiLQYgc0cevClzEd2AELhkMHUCb24WQHnTiJVlvkgLi5Dz+Sxi6jyP53GWIGWTJd
         Xr/uxjOk4Dr04s7ZARBa3kBmJdsgmfIGml5AKXZzRPnx6LC88jCrlKcz4p5baYkpeu
         WyEQLulHBMDGvdzKlPPw4QIw7i5ZuXgCjozQo6sQ=
Authentication-Results: myt5-23f0be3aa648.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from dynamic-vpn.dhcp.yndx.net (dynamic-vpn.dhcp.yndx.net [2a02:6b8:b081:17::1:14])
        by myt5-70c90f7d6d7d.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id YLSm5UCKYW-rPnWtvgU;
        Fri, 30 Oct 2020 15:54:20 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.4\))
Subject: Re: [PATCH net] ip6_tunnel: set inner ipproto before ip6_tnl_encap.
From:   Alexander Ovechkin <ovov@yandex-team.ru>
In-Reply-To: <93a65f76-3052-6162-a2f4-00091cd78927@novek.ru>
Date:   Fri, 30 Oct 2020 15:54:19 +0300
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Tom Herbert <tom@herbertland.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <E9B679B3-58CA-4BB7-A9B9-1A28A6148D75@yandex-team.ru>
References: <20201016111156.26927-1-ovov@yandex-team.ru>
 <CA+FuTSe5szAPV0qDVU1Qa7e-XH6uO4eWELfzykOvpb0CJ0NbUA@mail.gmail.com>
 <0E7BC212-3BBA-4C68-89B9-C6DA956553AD@yandex-team.ru>
 <CA+FuTSfNZoONM3TZxpC0ND2AsiNw0K-jgjKMe0FWkS9LVG6yNA@mail.gmail.com>
 <ABA7FBA9-42F8-4D6E-9D1E-CDEC74966131@yandex-team.ru>
 <CA+FuTSeejYh2eu80bB8MikUMb7KevQN-ka-+anfTfQATPSrKHA@mail.gmail.com>
 <93a65f76-3052-6162-a2f4-00091cd78927@novek.ru>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
X-Mailer: Apple Mail (2.3608.120.23.2.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30 Oct 2020, at 14:01, Vadim Fedorenko <vfedorenko@novek.ru> wrote:
> Could not reproduce the bug. Could you please provide a test scenario?

It can be reproduced if your net device doesn=E2=80=99t support udp =
tunnel segmentation (i.e its features do not have SKB_GSO_UDP_TUNNEL).
If you try to send packet larger than the MTU fou6-only tunnel (without =
any other encap) it will be dropped, because of invalid =
skb->inner_ipproto (that will be equal to IPPROTO_UDP =E2=80=94 outer =
protocol, instead of IPPROTO_IPV6).
skb->inner_ipproto is used here:
=
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/tree/net/ip=
v4/udp_offload.c?id=3D07e0887302450a62f51dba72df6afb5fabb23d1c#n168=
