Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4BC43CE3E
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 18:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242904AbhJ0QHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 12:07:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:46900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237998AbhJ0QHh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 12:07:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B52F561040;
        Wed, 27 Oct 2021 16:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635350712;
        bh=eb/MnptaHTjM9ul5Y31XvQtx6PthOdQdZbfOv3k+ZGg=;
        h=In-Reply-To:References:From:To:Subject:Cc:Date:From;
        b=aPWImfBP+lTzdY+oLDPSDdgI8VSmqAwF5V8IS4IDIh1fNBc8bwJE6v5tzu4cfYULk
         iBWFkhRPrF1EBE/E51NGpRJIRQXpgG8jE6EYmxKtJ77mKvyFUMAHK8wrMq3inlHHMN
         fK/hg3kKA18GQB3PAHL9TJuoFqlu78TqqxB9jyBzrbc7qSjoOdr/Jp5biJ6qhjT/XC
         SXcbLOK2VncMCotn6J1FCOWTctmgd+8q9trprs3Kp2Ybcc9DCUxjjk54rzVDPYaYBC
         SC0jPc5baKF6fYeVDiAmvC19KWnhzChMN2ms8il8T1A+dOJIPfwXKVRmYgw2X6xxbj
         ljrU0GB3pZEXw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20211027131953.9270-1-maxime.chevallier@bootlin.com>
References: <20211027131953.9270-1-maxime.chevallier@bootlin.com>
From:   Antoine Tenart <atenart@kernel.org>
To:     David Ahern <dsahern@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Russell King <linux@armlinux.org.uk>, davem@davemloft.net
Subject: Re: [RFC PATCH net] net: ipconfig: Release the rtnl_lock while waiting for carrier
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com
Message-ID: <163535070902.935735.6368176213562383450@kwain>
Date:   Wed, 27 Oct 2021 18:05:09 +0200
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Maxime,

Quoting Maxime Chevallier (2021-10-27 15:19:53)
> While waiting for a carrier to come on one of the netdevices, some
> devices will require to take the rtnl lock at some point to fully
> initialize all parts of the link.
>=20
> That's the case for SFP, where the rtnl is taken when a module gets
> detected. This prevents mounting an NFS rootfs over an SFP link.
>=20
> This means that while ipconfig waits for carriers to be detected, no SFP
> modules can be detected in the meantime, it's only detected after
> ipconfig times out.
>=20
> This commit releases the rtnl_lock while waiting for the carrier to come
> up, and re-takes it to check the for the init device and carrier status.
>=20
> At that point, the rtnl_lock seems to be only protecting
> ic_is_init_dev().
>=20
> Fixes: 73970055450e ("sfp: add SFP module support")

Was this working with SFP modules before?

> diff --git a/net/ipv4/ipconfig.c b/net/ipv4/ipconfig.c
> index 816d8aad5a68..069ae05bd0a5 100644
> --- a/net/ipv4/ipconfig.c
> +++ b/net/ipv4/ipconfig.c
> @@ -278,7 +278,12 @@ static int __init ic_open_devs(void)
>                         if (ic_is_init_dev(dev) && netif_carrier_ok(dev))
>                                 goto have_carrier;
> =20
> +               /* Give a chance to do complex initialization that
> +                * would require to take the rtnl lock.
> +                */
> +               rtnl_unlock();
>                 msleep(1);
> +               rtnl_lock();
> =20
>                 if (time_before(jiffies, next_msg))
>                         continue;

The rtnl lock is protecting 'for_each_netdev' and 'dev_change_flags' in
this function. What could happen in theory is a device gets removed from
the list or has its flags changed. I don't think that's an issue here.

Instead of releasing the lock while sleeping, you could drop the lock
before the carrier waiting loop (with a similar comment) and only
protect the above 'for_each_netdev' loop.

Antoine
