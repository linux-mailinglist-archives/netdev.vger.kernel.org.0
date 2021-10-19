Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3C3433F1B
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 21:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232959AbhJSTTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 15:19:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230432AbhJSTTo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 15:19:44 -0400
Received: from dvalin.narfation.org (dvalin.narfation.org [IPv6:2a00:17d8:100::8b1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFBF3C06161C
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 12:17:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1634671048;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E7eqfB6w1+VQVdPzSe++v0RvibO3QFgghLbnTLPE8TI=;
        b=VMtezAjB0I+Lwvr0/VCi+v/chdMKjOgcvxTht2AVIcxif2xu6ALqKgBOrz4Baq/T03pQUG
        UKuMJeh8ewoaCzxrHjRpgCyVUE/rbReyDix7xBOwqpocc0V8WAz4Tq88gHP79mq6SzYjVr
        d3spqR5rQ3UU/pNII36GPGH09BpEDi4=
From:   Sven Eckelmann <sven@narfation.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, mareklindner@neomailbox.ch,
        b.a.t.m.a.n@lists.open-mesh.org, a@unstable.cc,
        sw@simonwunderlich.de
Subject: Re: [PATCH] batman-adv: use eth_hw_addr_set() instead of ether_addr_copy()
Date:   Tue, 19 Oct 2021 21:17:19 +0200
Message-ID: <7316475.UB4K6AP8Nz@sven-desktop>
In-Reply-To: <20211019120654.6dee21b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211019163927.1386289-1-kuba@kernel.org> <20211019120654.6dee21b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart5046241.tqPkAQLKZY"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart5046241.tqPkAQLKZY
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Sven Eckelmann <sven@narfation.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, mareklindner@neomailbox.ch, b.a.t.m.a.n@lists.open-mesh.org, a@unstable.cc, sw@simonwunderlich.de
Subject: Re: [PATCH] batman-adv: use eth_hw_addr_set() instead of ether_addr_copy()
Date: Tue, 19 Oct 2021 21:17:19 +0200
Message-ID: <7316475.UB4K6AP8Nz@sven-desktop>
In-Reply-To: <20211019120654.6dee21b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211019163927.1386289-1-kuba@kernel.org> <20211019120654.6dee21b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>

On Tuesday, 19 October 2021 21:06:54 CEST Jakub Kicinski wrote:
> On Tue, 19 Oct 2021 09:39:27 -0700 Jakub Kicinski wrote:
> > Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
> > of VLANs...") introduced a rbtree for faster Ethernet address look
> > up. To maintain netdev->dev_addr in this tree we need to make all
> > the writes to it got through appropriate helpers.
> > 
> > Convert batman from ether_addr_copy() to eth_hw_addr_set():
> > 
> >   @@
> >   expression dev, np;
> >   @@
> >   - ether_addr_copy(dev->dev_addr, np)
> >   + eth_hw_addr_set(dev, np)
> > 
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> Extending CC list.

Acked-by: Sven Eckelmann <sven@narfation.org>

> > diff --git a/net/batman-adv/soft-interface.c b/net/batman-adv/soft-interface.c
> > index 0604b0279573..7ee09337fc40 100644
> > --- a/net/batman-adv/soft-interface.c
> > +++ b/net/batman-adv/soft-interface.c
> > @@ -134,7 +134,7 @@ static int batadv_interface_set_mac_addr(struct net_device *dev, void *p)
> >  		return -EADDRNOTAVAIL;
> >  
> >  	ether_addr_copy(old_addr, dev->dev_addr);
> > -	ether_addr_copy(dev->dev_addr, addr->sa_data);
> > +	eth_hw_addr_set(dev, addr->sa_data);
> >  
> >  	/* only modify transtable if it has been initialized before */
> >  	if (atomic_read(&bat_priv->mesh_state) != BATADV_MESH_ACTIVE)
> 
> 


--nextPart5046241.tqPkAQLKZY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAmFvGb8ACgkQXYcKB8Em
e0aURg//aEp766WsED+6U/3B01ao9GxBHcxnYarz0tW5AcolUdJsuZ6iCu9K/9+a
1EbupcqCZDnEO94R3RZUsW9g3Vo6yHpBGr7a30JmYgrhLDCZdIbFeKoTR1dnlUXd
CxWlzRWgiJg5qcmlF6v7GU71hiXJ1DkgtatfL7mrmkUZm/1sMBmjZVnkeQlJMex+
eVRAGiZHFKZzKY7GTc0F5TUWao5bLvbpX7naIR0h2pwn59z5bCUF25W7AvSsKIEL
6RF/wEaawyzP62qjxr5WEOCT/WLxFDs/669as0K4C46W8CHZc042+ajtl6T5Cv/n
qRv7CTX21iIDHf0qHsTXd0n9m9zNPl7rLE+0oVyAz7LOYXvJy43Sgi+Yfyz6S76D
6iUDOVmEKrEuGH1Or5XYbg+Drvf0E3UFBwF+s9krMjw+0AWssvkx8Taa+l88ZkKm
snmnrLuDhCJfTLVxjaPiLLhzTUe3wnztMZ2MInWemyJ5S2AeUluyUjUXv+DLzxKI
E4rvstQZpmFNYd9BQ8dL7nJeA8gq07U0Lkdt/RTA35/ipBF+zCtRjTD7PTKA8X8A
A6+5/79rHp2El/Mz2MBslHVn8g/m1TB8ORAJ374kw01ANCxgBH0nVPD25QRmGubQ
r1H585SgiL8yYAmhpDcvfJTKRYI+d25yppF9LVzGR077xk3C054=
=E0wZ
-----END PGP SIGNATURE-----

--nextPart5046241.tqPkAQLKZY--



