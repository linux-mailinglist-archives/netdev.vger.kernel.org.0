Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A15904A0337
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 22:51:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351666AbiA1Vvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 16:51:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235428AbiA1Vvm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 16:51:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93472C061714;
        Fri, 28 Jan 2022 13:51:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F8E1B82702;
        Fri, 28 Jan 2022 21:51:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0622C340E7;
        Fri, 28 Jan 2022 21:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643406700;
        bh=BhjBnaefvrqQGjN3w8CLYiLwh+6lqBXAa40bwRHOO5g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=h0BL30ZjjTUe25ztKCsmfY1HlIYr2jyKtxlw4WVVcgf3F8oVZxGDNcLfRaYIP+Pj1
         UEbKbnKw7JfWcUWy9OrP1DJRep7Zdbe1yKzPwhr+YtVPUv9skGRrWsEzwzItQ6UGBD
         3mcFLP0ffABSom88dhwz7teMWecMmliCxyWofKaHNCTQ0SsiPareBheTunZkHqFBtR
         LjDPAQoW6tSnznZRb36poVAkeJ6jKFtCSnn2C87J8cUbwRHnl5rz9PlVK4XmF2pb1l
         tLIKoLUszQYAltnSIt4Hhd6sapg+TG6cGTBW+Z1Xv8xudr8no0gJpEkTJWOZyU/KN4
         31xpR4us4YAVQ==
Date:   Fri, 28 Jan 2022 13:51:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>
Cc:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-renesas-soc@vger.kernel.org>
Subject: Re: [PATCH 1/2] ravb: ravb_close() always returns 0
Message-ID: <20220128135139.292aab45@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220128203838.17423-2-s.shtylyov@omp.ru>
References: <20220128203838.17423-1-s.shtylyov@omp.ru>
        <20220128203838.17423-2-s.shtylyov@omp.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Jan 2022 23:38:37 +0300 Sergey Shtylyov wrote:
> ravb_close() always returns 0, hence the check in ravb_wol_restore() is
> pointless (however, we cannot change the prototype of ravb_close() as it
> implements the driver's ndo_stop() method).
>=20
> Found by Linux Verification Center (linuxtesting.org) with the SVACE stat=
ic
> analysis tool.
>=20
> Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
> ---
>  drivers/net/ethernet/renesas/ravb_main.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ether=
net/renesas/ravb_main.c
> index b215cde68e10..02fa8cfc2b7b 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> @@ -2863,9 +2863,7 @@ static int ravb_wol_restore(struct net_device *ndev)
>  	/* Disable MagicPacket */
>  	ravb_modify(ndev, ECMR, ECMR_MPDE, 0);
> =20
> -	ret =3D ravb_close(ndev);
> -	if (ret < 0)
> -		return ret;
> +	ravb_close(ndev);
> =20
>  	return disable_irq_wake(priv->emac_irq);
>  }

drivers/net/ethernet/renesas/ravb_main.c:2857:13: warning: unused variable =
=E2=80=98ret=E2=80=99 [-Wunused-variable]
 2857 |         int ret;
      |             ^~~
