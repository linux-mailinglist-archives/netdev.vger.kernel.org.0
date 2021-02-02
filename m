Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E247E30CE5A
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 23:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234144AbhBBWBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 17:01:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:58462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229542AbhBBWBh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 17:01:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5029864F7C;
        Tue,  2 Feb 2021 22:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612303256;
        bh=bXEM5MFW2v9pOgI/DEe0DI2uchwKjh84Ziu0DZXjpZw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AYzwUHomRi9Mbf6p+SVtG8FuWRytRJFDv0KQKdDfeeS0bagP0uaehHJI7x4hwY+g8
         FKKHyKuCdak6X4K6ThS8vfwuT2aOdjwLviEwbshjxeieTVbWrgSC+Ggtn0F3pgs/fG
         sOT3W5ATWdJ/x3UzsXIYoSBGnvf+g7kZcvzv3SVHrm4sT+Lf5jZ8tfCIHIAXIG5KrT
         B0amDTMQZ6hVQMnnfS3sX7JcB1QKx8pGKu2dXUuc9iNATRsmJ8bla1tKh9OrwuIu1V
         4zb9oQpzRVPVGUpgw1ekeqTBppm+y0zYD0Y5H0HpPTprYlOtOpG4GgpkAG29TQDgX8
         jhUSqTqNB5VBw==
Date:   Tue, 2 Feb 2021 14:00:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonas Bonn <jonas@norrbonn.se>
Cc:     laforge@gnumonks.org, netdev@vger.kernel.org, pablo@netfilter.org
Subject: Re: [PATCH net-next 7/7] gtp: update rx_length_errors for
 abnormally short packets
Message-ID: <20210202140055.125a6b97@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210202065159.227049-8-jonas@norrbonn.se>
References: <20210202065159.227049-1-jonas@norrbonn.se>
        <20210202065159.227049-8-jonas@norrbonn.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  2 Feb 2021 07:51:59 +0100 Jonas Bonn wrote:
> diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
> index a1bb02818977..fa8880c51101 100644
> --- a/drivers/net/gtp.c
> +++ b/drivers/net/gtp.c
> @@ -189,8 +189,10 @@ static int gtp_rx(struct pdp_ctx *pctx, struct sk_bu=
ff *skb,
> =20
>  	/* Get rid of the GTP + UDP headers. */
>  	if (iptunnel_pull_header(skb, hdrlen, skb->protocol,
> -				 !net_eq(sock_net(pctx->sk), dev_net(pctx->dev))))
> -		return -1;
> +			 !net_eq(sock_net(pctx->sk), dev_net(pctx->dev)))) {
> +		gtp->dev->stats.rx_length_errors++;
> +		goto err;
> +	}
> =20
>  	netdev_dbg(pctx->dev, "forwarding packet from GGSN to uplink\n");
> =20
> @@ -206,6 +208,10 @@ static int gtp_rx(struct pdp_ctx *pctx, struct sk_bu=
ff *skb,
> =20
>  	netif_rx(skb);
>  	return 0;
> +
> +err:
> +	gtp->dev->stats.rx_dropped++;
> +	return -1;
>  }
> =20
>  /* 1 means pass up to the stack, -1 means drop and 0 means decapsulated.=
 */

drivers/net/gtp.c: In function =E2=80=98gtp_rx=E2=80=99:
drivers/net/gtp.c:193:3: error: =E2=80=98gtp=E2=80=99 undeclared (first use=
 in this function)
  193 |   gtp->dev->stats.rx_length_errors++;
      |   ^~~
drivers/net/gtp.c:193:3: note: each undeclared identifier is reported only =
once for each function it appears in


Thanks for working on these patches!
