Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A363249E4F3
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 15:46:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242628AbiA0OqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 09:46:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234948AbiA0OqQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 09:46:16 -0500
X-Greylist: delayed 330 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 27 Jan 2022 06:46:16 PST
Received: from vulcan.natalenko.name (vulcan.natalenko.name [IPv6:2001:19f0:6c00:8846:5400:ff:fe0c:dfa0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17950C06173B;
        Thu, 27 Jan 2022 06:46:16 -0800 (PST)
Received: from spock.localnet (unknown [83.148.33.151])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by vulcan.natalenko.name (Postfix) with ESMTPSA id 4BEBCD8B22F;
        Thu, 27 Jan 2022 15:40:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=natalenko.name;
        s=dkim-20170712; t=1643294441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OkaYBUaQDMs19i4HXWrJsJm9o280IUe9ric8r65dz6o=;
        b=b3G9grRz8fhqkUesaxFiZYnVSzSaACXLpHjBzkwG+iE6FOB6Cmuw+Oy3MuAw6tkBb6NOsL
        wUO74jv79omeTLK4hbzu5aKyLqYQkvwFVJ1iC3lvAQGuk4t6AjRP5yPPjznvIcg+h89tMJ
        HGbRVAy8T9dtZ1WaUSRHpoK6niUcv1U=
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
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH 1/7] genirq: Provide generic_handle_irq_safe().
Date:   Thu, 27 Jan 2022 15:40:39 +0100
Message-ID: <5753562.DvuYhMxLoT@natalenko.name>
In-Reply-To: <20220127113303.3012207-2-bigeasy@linutronix.de>
References: <20220127113303.3012207-1-bigeasy@linutronix.de> <20220127113303.3012207-2-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On =C4=8Dtvrtek 27. ledna 2022 12:32:57 CET Sebastian Andrzej Siewior wrote:
> Provide generic_handle_irq_safe() which can be used can used from any
> context.
>=20
> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  include/linux/irqdesc.h |  1 +
>  kernel/irq/irqdesc.c    | 21 +++++++++++++++++++++
>  2 files changed, 22 insertions(+)
>=20
> diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
> index 93d270ca0c567..a77584593f7d1 100644
> --- a/include/linux/irqdesc.h
> +++ b/include/linux/irqdesc.h
> @@ -160,6 +160,7 @@ static inline void generic_handle_irq_desc(struct irq=
_desc *desc)
> =20
>  int handle_irq_desc(struct irq_desc *desc);
>  int generic_handle_irq(unsigned int irq);
> +int generic_handle_irq_safe(unsigned int irq);
> =20
>  #ifdef CONFIG_IRQ_DOMAIN
>  /*
> diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
> index 2267e6527db3c..97223df2f460e 100644
> --- a/kernel/irq/irqdesc.c
> +++ b/kernel/irq/irqdesc.c
> @@ -662,6 +662,27 @@ int generic_handle_irq(unsigned int irq)
>  }
>  EXPORT_SYMBOL_GPL(generic_handle_irq);
> =20
> +/**
> + * generic_handle_irq_safe - Invoke the handler for a particular irq
> + * @irq:	The irq number to handle
> + *
> + * Returns:	0 on success, or -EINVAL if conversion has failed
> + *
> + * This function must be called either from an IRQ context with irq regs
> + * initialized or with care from any context.
> + */
> +int generic_handle_irq_safe(unsigned int irq)
> +{
> +	unsigned long flags;
> +	int ret;
> +
> +	local_irq_save(flags);
> +	ret =3D handle_irq_desc(irq_to_desc(irq));
> +	local_irq_restore(flags);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(generic_handle_irq_safe);
> +
>  #ifdef CONFIG_IRQ_DOMAIN
>  /**
>   * generic_handle_domain_irq - Invoke the handler for a HW irq belonging
>=20

Reviewed-by: Oleksandr Natalenko <oleksandr@natalenko.name>

Thank you.

=2D-=20
Oleksandr Natalenko (post-factum)


