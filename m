Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17546A07D0
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 18:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbfH1QtC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 12:49:02 -0400
Received: from mail.nic.cz ([217.31.204.67]:33584 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726428AbfH1QtC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 12:49:02 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTPSA id 11BB01407C6;
        Wed, 28 Aug 2019 18:49:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1567010940; bh=zzLdoLIxA5rjqSLOB3C8SN8ZQc1NQ8pafoImHXefv0c=;
        h=Date:From:To;
        b=KsWO9Yqn9S5o6Y9c8FfDitlPr4dDKaNvCe20LPkTZhgSth+2Gm3tmAeVAGVqG+L93
         dTmp+iH6ya5Fe404PJ3pgOCi0vqnDi4pDIXo9WhpNSbHyWz7OgNbygoH/yjmka36t1
         NSZeBoMfAUBoVrrrIHaiDUwTrqHk3Q9aZZx8z38s=
Date:   Wed, 28 Aug 2019 18:48:59 +0200
From:   Marek =?ISO-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, f.fainelli@gmail.com,
        andrew@lunn.ch
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: get serdes lane after
 lock
Message-ID: <20190828184859.3712bed8@dellmb.labs.office.nic.cz>
In-Reply-To: <20190828162611.10064-1-vivien.didelot@gmail.com>
References: <20190828162611.10064-1-vivien.didelot@gmail.com>
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

On Wed, 28 Aug 2019 12:26:11 -0400
Vivien Didelot <vivien.didelot@gmail.com> wrote:

> This is a follow-up patch for commit 17deaf5cb37a ("net: dsa:
> mv88e6xxx: create serdes_get_lane chip operation").
>=20
> The .serdes_get_lane implementations access the CMODE of a port,
> even though it is cached at the moment, it is safer to call them
> after the mutex is locked, not before.
>=20
> At the same time, check for an eventual error and return IRQ_DONE,
> instead of blindly ignoring it.
>=20
> Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
> ---
>  drivers/net/dsa/mv88e6xxx/serdes.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c
> b/drivers/net/dsa/mv88e6xxx/serdes.c index 9424e401dbc7..38c0da2492c0
> 100644 --- a/drivers/net/dsa/mv88e6xxx/serdes.c
> +++ b/drivers/net/dsa/mv88e6xxx/serdes.c
> @@ -646,10 +646,12 @@ static irqreturn_t
> mv88e6390_serdes_thread_fn(int irq, void *dev_id) int err;
>  	u8 lane;
> =20
> -	mv88e6xxx_serdes_get_lane(chip, port->port, &lane);
> -
>  	mv88e6xxx_reg_lock(chip);
> =20
> +	err =3D mv88e6xxx_serdes_get_lane(chip, port->port, &lane);
> +	if (err)
> +		goto out;
> +
>  	switch (cmode) {
>  	case MV88E6XXX_PORT_STS_CMODE_SGMII:
>  	case MV88E6XXX_PORT_STS_CMODE_1000BASEX:

Reviewed-by: Marek Beh=C3=BAn <marek.behun@nic.cz>
