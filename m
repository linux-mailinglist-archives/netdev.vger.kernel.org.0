Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACD95287B0D
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 19:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732123AbgJHReN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 13:34:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:44860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731239AbgJHReN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Oct 2020 13:34:13 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15F9422200;
        Thu,  8 Oct 2020 17:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602178453;
        bh=63DTW0twuIItvb7O3xebhv72lILnFJnpspI5gSKhfRI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Dxvxi6pcuMOLkGek/f4uGNd4GEMI/9i9CouD6eyoUuBYSXHGPAEKF9Cip6+fPBcUo
         Qmp7PEa5W1GWHuOyo8CpYQt6ZyNzbmp2GqgSSp82IUEC0aFYboZK5PBLUstqiEYq/2
         dHu57bCmf6UyjEv81vtqTz9xbeLTkaupke9qgfGA=
Date:   Thu, 8 Oct 2020 10:34:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org,
        syzbot+3f3837e61a48d32b495f@syzkaller.appspotmail.com,
        Robin van der Gracht <robin@protonic.nl>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: Re: [Patch net] can: initialize skbcnt in j1939_tp_tx_dat_new()
Message-ID: <20201008103410.4fea97a5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201008061821.24663-1-xiyou.wangcong@gmail.com>
References: <20201008061821.24663-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  7 Oct 2020 23:18:21 -0700 Cong Wang wrote:
> This fixes an uninit-value warning:
> BUG: KMSAN: uninit-value in can_receive+0x26b/0x630 net/can/af_can.c:650
> 
> Reported-and-tested-by: syzbot+3f3837e61a48d32b495f@syzkaller.appspotmail.com
> Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
> Cc: Robin van der Gracht <robin@protonic.nl>
> Cc: Oleksij Rempel <linux@rempel-privat.de>
> Cc: Pengutronix Kernel Team <kernel@pengutronix.de>
> Cc: Oliver Hartkopp <socketcan@hartkopp.net>
> Cc: Marc Kleine-Budde <mkl@pengutronix.de>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> ---
>  net/can/j1939/transport.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
> index 0cec4152f979..88cf1062e1e9 100644
> --- a/net/can/j1939/transport.c
> +++ b/net/can/j1939/transport.c
> @@ -580,6 +580,7 @@ sk_buff *j1939_tp_tx_dat_new(struct j1939_priv *priv,
>  	skb->dev = priv->ndev;
>  	can_skb_reserve(skb);
>  	can_skb_prv(skb)->ifindex = priv->ndev->ifindex;
> +	can_skb_prv(skb)->skbcnt = 0;
>  	/* reserve CAN header */
>  	skb_reserve(skb, offsetof(struct can_frame, data));

Thanks! Looks like there is another can_skb_reserve(skb) on line 1489,
is that one fine?

Marc - should I take this directly into net, in case there is a last
minute PR to Linus for 5.9?
