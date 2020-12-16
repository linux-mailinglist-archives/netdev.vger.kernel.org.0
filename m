Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB802DC7E6
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 21:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729041AbgLPUoZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 15:44:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:44924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727521AbgLPUoZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 15:44:25 -0500
Date:   Wed, 16 Dec 2020 12:43:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608151425;
        bh=FJ4FDVrXaSAwyFHX8umFOb8u6Y11U1oW8MZY1CH0WFw=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=T65y8N9l7zwQCwsBCpvstmOYEq+CP7FOTm7VnRq6kdhpAg4mDNh3yydw6Jk5qq5p2
         HJNX7k4ALcYOqRsCPYvRYsDoNNGwZqqJAJmYdcJTS62IWWaH87ExhibLaKlDAbcCAL
         AGxjMNbtkGoYle4+bzqPNAXLJ94ykVIQE9nB6ds1vIDcbSVgztK1BDD4bJPClGk91R
         tww/KuDCzRUOAtpwipLnVPvJjUhl+xtf0VcAEXNf+EdMR9DQ92rfGgKKsy95RJdP+i
         qBQsjCi+jJeKEmrpFeMrnvvR6HltRicbpgdTrCWhPopFvSG2uW+ogUrjp4ekNP4o2D
         9bgrvaeakCMkg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vincent =?UTF-8?B?U3RlaGzDqQ==?= <vincent.stehle@laposte.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Julian Wiedmann <jwi@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH v2] net: korina: fix return value
Message-ID: <20201216124343.2848f0d1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201214220952.19935-1-vincent.stehle@laposte.net>
References: <20201214130832.7bedb230@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201214220952.19935-1-vincent.stehle@laposte.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Dec 2020 23:09:52 +0100 Vincent Stehl=C3=A9 wrote:
> The ndo_start_xmit() method must not attempt to free the skb to transmit
> when returning NETDEV_TX_BUSY. Therefore, make sure the
> korina_send_packet() function returns NETDEV_TX_OK when it frees a packet.
>=20
> Fixes: ef11291bcd5f ("Add support the Korina (IDT RC32434) Ethernet MAC")
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Vincent Stehl=C3=A9 <vincent.stehle@laposte.net>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Florian Fainelli <florian.fainelli@telecomint.eu>

Let me CC Florian's more recent email just in case he wants to review.

> Changes since v1:
> - Keep freeing the packet but return NETDEV_TX_OK, as suggested by Jakub
>=20
>=20
>  drivers/net/ethernet/korina.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/korina.c b/drivers/net/ethernet/korina.c
> index bf48f0ded9c7d..925161959b9ba 100644
> --- a/drivers/net/ethernet/korina.c
> +++ b/drivers/net/ethernet/korina.c
> @@ -219,7 +219,7 @@ static int korina_send_packet(struct sk_buff *skb, st=
ruct net_device *dev)
>  			dev_kfree_skb_any(skb);
>  			spin_unlock_irqrestore(&lp->lock, flags);
> =20
> -			return NETDEV_TX_BUSY;
> +			return NETDEV_TX_OK;
>  		}
>  	}
> =20

