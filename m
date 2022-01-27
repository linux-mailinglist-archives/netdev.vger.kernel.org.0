Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BEEC49E51F
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 15:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234653AbiA0OvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 09:51:16 -0500
Received: from vulcan.natalenko.name ([104.207.131.136]:36798 "EHLO
        vulcan.natalenko.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232186AbiA0OvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 09:51:15 -0500
X-Greylist: delayed 627 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Jan 2022 09:51:15 EST
Received: from spock.localnet (unknown [83.148.33.151])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by vulcan.natalenko.name (Postfix) with ESMTPSA id 38C73D8B248;
        Thu, 27 Jan 2022 15:41:26 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
        s=dkim-20170712; t=1643294486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xRfG6qv9eNrmVk+OrljXkrc5mg43YFh2rdY8MzYAUgM=;
        b=XIOCTcxRxoBYbF1ZVSNa4whYzYj/UVLtiCZawfTGuczIfGj78m+V4SJ5+IBZ+Z8Phvp9A8
        QQ05YD6gW3L+FqdvakRaKsGakD8q5PwvErpFM6qO7KrgkNw237gy9Qx8SUTiS7E9ZN0BAw
        rRcK6E3kv+X1jImpCrFsDULfv+iRfng=
From:   Oleksandr Natalenko <oleksandr@natalenko.name>
To:     greybus-dev@lists.linaro.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alex Elder <elder@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        UNGLinuxDriver@microchip.com, Wolfram Sang <wsa@kernel.org>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Michael Below <below@judiz.de>,
        Salvatore Bonaccorso <carnil@debian.org>
Subject: Re: [PATCH 2/7] i2c: core: Use generic_handle_irq_safe() in i2c_handle_smbus_host_notify().
Date:   Thu, 27 Jan 2022 15:41:24 +0100
Message-ID: <4929165.31r3eYUQgx@natalenko.name>
In-Reply-To: <20220127113303.3012207-3-bigeasy@linutronix.de>
References: <20220127113303.3012207-1-bigeasy@linutronix.de> <20220127113303.3012207-3-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On =C4=8Dtvrtek 27. ledna 2022 12:32:58 CET Sebastian Andrzej Siewior wrote:
> The i2c-i801 driver invokes i2c_handle_smbus_host_notify() from his
> interrupt service routine. On PREEMPT_RT i2c-i801's handler is forced
> threaded with enabled interrupts which leads to a warning by
> handle_irq_event_percpu() assuming that irq_default_primary_handler()
> enabled interrupts.
>=20
> i2c-i801's interrupt handler can't be made non-threaded because the
> interrupt line is shared with other devices.
>=20
> Use generic_handle_irq_safe() which can invoked with disabled and enabled
> interrupts.
>=20
> Reported-by: Michael Below <below@judiz.de>
> Link: https://bugs.debian.org/1002537
> Cc: Salvatore Bonaccorso <carnil@debian.org>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  drivers/i2c/i2c-core-base.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/i2c/i2c-core-base.c b/drivers/i2c/i2c-core-base.c
> index 2c59dd748a49f..3f9e5303b6163 100644
> --- a/drivers/i2c/i2c-core-base.c
> +++ b/drivers/i2c/i2c-core-base.c
> @@ -1424,7 +1424,7 @@ int i2c_handle_smbus_host_notify(struct i2c_adapter=
 *adap, unsigned short addr)
>  	if (irq <=3D 0)
>  		return -ENXIO;
> =20
> -	generic_handle_irq(irq);
> +	generic_handle_irq_safe(irq);
> =20
>  	return 0;
>  }
>=20

Reviewed-by: Oleksandr Natalenko <oleksandr@natalenko.name>

Worth linking [1] [2] and [3] as well maybe?

[1] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1873673
[2] https://bugzilla.kernel.org/show_bug.cgi?id=3D202453
[3] https://lore.kernel.org/lkml/20201204201930.vtvitsq6xcftjj3o@spock.loca=
ldomain/

=2D-=20
Oleksandr Natalenko (post-factum)


