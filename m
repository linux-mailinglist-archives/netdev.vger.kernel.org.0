Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA35920FAA0
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 19:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387785AbgF3Rdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 13:33:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:47632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729737AbgF3Rdh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 13:33:37 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6D0E206C0;
        Tue, 30 Jun 2020 17:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593538417;
        bh=PTVQwDhqBogVrxNM1m/WH0c9T7IaWZ0jHbdd3KIyCeU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SX1tRtlZP88m3MA2I/H3vRKncp43ZQkHu3hxRiQ3l5I+ZZ4OU0WfSp+UHuWAaQsRJ
         R4ZHAoN1cUk5dK94sCm+NCvWqxflUskOomeh9ZsQpt5jyEXLGwx/+Sk0k0gRBORuTk
         aQnTjxHc+FQdmllLZrdS2+9HmXJcpKOIapcujehI=
Date:   Tue, 30 Jun 2020 10:33:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     Oliver Herms <oliver.peter.herms@gmail.com>,
        netdev@vger.kernel.org, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org
Subject: Re: [PATCH v3] IPv4: Tunnel: Fix effective path mtu calculation
Message-ID: <20200630103335.63de7098@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <99564f5c-07e4-df0d-893d-40757a0f2167@6wind.com>
References: <20200625224435.GA2325089@tws>
        <20200629232235.6047a9c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <99564f5c-07e4-df0d-893d-40757a0f2167@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Jun 2020 17:51:41 +0200 Nicolas Dichtel wrote:
> Le 30/06/2020 =C3=A0 08:22, Jakub Kicinski a =C3=A9crit=C2=A0:
> [snip]
> > My understanding is that for a while now tunnels are not supposed to use
> > dev->hard_header_len to reserve skb space, and use dev->needed_headroom=
,=20
> > instead. sit uses hard_header_len and doesn't even copy needed_headroom
> > of the lower device. =20
>=20
> I missed this. I was wondering why IPv6 tunnels uses hard_header_len, if =
there
> was a "good" reason:
>=20
> $ git grep "hard_header_len.*=3D" net/ipv6/
> net/ipv6/ip6_tunnel.c:                  dev->hard_header_len =3D
> tdev->hard_header_len + t_hlen;
> net/ipv6/ip6_tunnel.c:  dev->hard_header_len =3D LL_MAX_HEADER + t_hlen;
> net/ipv6/sit.c:         dev->hard_header_len =3D tdev->hard_header_len +
> sizeof(struct iphdr);
> net/ipv6/sit.c: dev->hard_header_len    =3D LL_MAX_HEADER + t_hlen;
>=20
> A cleanup would be nice ;-)

I did some archaeological investigatin' yesterday, and I saw
c95b819ad75b ("gre: Use needed_headroom") which converted GRE.
Then I think Pravin used GRE as a base for better ip_tunnel infra=20
and the no-hard_header_len-abuse gospel has spread to other IPv4
tunnels. AFAICT IPv6 tunnels were not as lucky, and SIT just got
missed in the IPV4 conversion..
