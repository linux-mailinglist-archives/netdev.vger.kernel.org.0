Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 421872CB24A
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 02:26:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbgLBBZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 20:25:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:42606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727154AbgLBBZY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 20:25:24 -0500
Date:   Tue, 1 Dec 2020 17:24:42 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606872284;
        bh=BZcs/C1Kh/EFqtjfbt3NSNJpyXpewNsaXwk3fqrthrc=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=ObQzob+OVv/fyq/ePncZrysLYvmo1GfcqStDdrS/2ae5Jwn5CzQdYLlPQKxgFpmhp
         HoAw4hE8+nmnx4MDAfyrskDrtO8GpaQp1t7YLJz1P4SdhiccZDtBXZ/uzYab6SWHG+
         vlit+mWbc6Sh8s2cZPVAkFUWKoOX/Sa4tDBFrsBA=
From:   Jakub Kicinski <kuba@kernel.org>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jonathan Morton <chromatix99@gmail.com>,
        Pete Heist <pete@heistp.net>
Subject: Re: [PATCH net] inet_ecn: Fix endianness of checksum update when
 setting ECT(1)
Message-ID: <20201201172442.2d8dca75@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201130183705.17540-1-toke@redhat.com>
References: <20201130183705.17540-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Nov 2020 19:37:05 +0100 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> When adding support for propagating ECT(1) marking in IP headers it seems=
 I
> suffered from endianness-confusion in the checksum update calculation: In
> fact the ECN field is in the *lower* bits of the first 16-bit word of the
> IP header when calculating in network byte order. This means that the
> addition performed to update the checksum field was wrong; let's fix that.
>=20
> Fixes: b723748750ec ("tunnel: Propagate ECT(1) when decapsulating as reco=
mmended by RFC6040")
> Reported-by: Jonathan Morton <chromatix99@gmail.com>
> Tested-by: Pete Heist <pete@heistp.net>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

Applied and queued, thanks!

> diff --git a/include/net/inet_ecn.h b/include/net/inet_ecn.h
> index e1eaf1780288..563457fec557 100644
> --- a/include/net/inet_ecn.h
> +++ b/include/net/inet_ecn.h
> @@ -107,7 +107,7 @@ static inline int IP_ECN_set_ect1(struct iphdr *iph)
>  	if ((iph->tos & INET_ECN_MASK) !=3D INET_ECN_ECT_0)
>  		return 0;
> =20
> -	check +=3D (__force u16)htons(0x100);
> +	check +=3D (__force u16)htons(0x1);
> =20
>  	iph->check =3D (__force __sum16)(check + (check>=3D0xFFFF));
>  	iph->tos ^=3D INET_ECN_MASK;

This seems to be open coding csum16_add() - is there a reason and if
not perhaps worth following up in net-next?
