Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE354A1094
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 06:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725883AbfH2Ev1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 00:51:27 -0400
Received: from mail.nic.cz ([217.31.204.67]:37846 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725826AbfH2Ev1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 00:51:27 -0400
Received: from localhost (unknown [172.20.6.135])
        by mail.nic.cz (Postfix) with ESMTPSA id 30DA8140BBE;
        Thu, 29 Aug 2019 06:51:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1567054285; bh=YMjy7kH1nsLZEyiKQ5+z83kSeANyTN1DBhV/zU8lvuQ=;
        h=Date:From:To;
        b=KTEi+3Lb1YW68Zn7XAqPscncYSuKdAfq4pwtKsv3QcmOYuE7KqBBgStkniIdA/oZc
         Rbu7Oww6UfTTs9AskSBS4fRVnD4r8LYEpTP1rnPoZi/XrAzTjJjvZozbDsCzQ2UJ7h
         chtF1Rrb7R+9JqXjTPnp+ANvghtV0gK5O8IDzTzY=
Date:   Thu, 29 Aug 2019 06:51:24 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, f.fainelli@gmail.com,
        andrew@lunn.ch
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: fix freeing unused SERDES
 IRQ
Message-ID: <20190829065124.1e234e7a@nic.cz>
In-Reply-To: <20190828185511.21956-1-vivien.didelot@gmail.com>
References: <20190828185511.21956-1-vivien.didelot@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Virus-Scanned: clamav-milter 0.100.3 at mail.nic.cz
X-Virus-Status: Clean
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,SHORTCIRCUIT
        shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Aug 2019 14:55:11 -0400
Vivien Didelot <vivien.didelot@gmail.com> wrote:

> Now mv88e6xxx does not enable its ports at setup itself and let
> the DSA core handle this, unused ports are disabled without being
> powered on first. While that is expected, the SERDES powering code
> was assuming that a port was already set up before powering it down,
> resulting in freeing an unused IRQ. The patch fixes this assumption.
>=20
> Fixes: b759f528ca3d ("net: dsa: mv88e6xxx: enable SERDES after setup")
> Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx=
/chip.c
> index 6525075f6bd3..c648f9fbfa59 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -2070,7 +2070,8 @@ static int mv88e6xxx_serdes_power(struct mv88e6xxx_=
chip *chip, int port,
>  		if (chip->info->ops->serdes_irq_setup)
>  			err =3D chip->info->ops->serdes_irq_setup(chip, port);
>  	} else {
> -		if (chip->info->ops->serdes_irq_free)
> +		if (chip->info->ops->serdes_irq_free &&
> +		    chip->ports[port].serdes_irq)
>  			chip->info->ops->serdes_irq_free(chip, port);
> =20
>  		err =3D chip->info->ops->serdes_power(chip, port, false);

Reviewed-by: Marek Beh=C3=BAn <marek.behun@nic.cz>
