Return-Path: <netdev+bounces-4074-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C80970A8BA
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 17:14:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EF6351C209D7
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 15:14:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF6156AD7;
	Sat, 20 May 2023 15:14:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 958D66AB4
	for <netdev@vger.kernel.org>; Sat, 20 May 2023 15:14:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49422C433EF;
	Sat, 20 May 2023 15:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684595683;
	bh=nb87eHnSrLM+miw1D/xmByQKBJTG9jxqONUG12aAE/A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=YJiWLEfcf3avvzKkf0/4oJxV8pWWGzRVuLM4f/x2+OR+4JArle8ElxEOn19FJo5sc
	 ANNF8hS9HDrk/UIXhGTRcRiOeCeXEEG+emMIgpLYYGXCgh2Lt/FKtW0mq+BPA12C2L
	 60QXtylPkn1Jr269Kwb77s4gQXP1IOslbuUbp7bRmON1Fam9/7JDSjuCYSi82v5CxA
	 ihARPaGg6Z1UFsSyxpUFnNiQHKaPPSHMqRu6dboJ4GU+qc8EyNdsB8si09biiS5dA2
	 KTxTabR7ik77KLxFQaJZf41e4S0c8W2/LRPjz4mcayc28X1FOFxy7V75DI34aCFHFq
	 Z27rwwrsBG6TA==
Date: Sat, 20 May 2023 16:30:49 +0100
From: Jonathan Cameron <jic23@kernel.org>
To: Matti Vaittinen <mazziesaccount@gmail.com>
Cc: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>, Andy Shevchenko
 <andriy.shevchenko@linux.intel.com>, Daniel Scally <djrscally@gmail.com>,
 Heikki Krogerus <heikki.krogerus@linux.intel.com>, Sakari Ailus
 <sakari.ailus@linux.intel.com>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>,
 Wolfram Sang <wsa@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>,
 Michael Hennerich <Michael.Hennerich@analog.com>, Andreas Klinger
 <ak@it-klinger.de>, Marcin Wojtas <mw@semihalf.com>, Russell King
 <linux@armlinux.org.uk>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo
 Abeni <pabeni@redhat.com>, Jonathan =?UTF-8?B?TmV1c2Now6RmZXI=?=
 <j.neuschaefer@gmx.net>, Linus Walleij <linus.walleij@linaro.org>, Paul
 Cercueil <paul@crapouillou.net>, Akhil R <akhilrajeev@nvidia.com>,
 linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-i2c@vger.kernel.org, linux-iio@vger.kernel.org,
 netdev@vger.kernel.org, openbmc@lists.ozlabs.org,
 linux-gpio@vger.kernel.org, linux-mips@vger.kernel.org
Subject: Re: [PATCH v5 7/8] iio: cdc: ad7150: relax return value check for
 IRQ get
Message-ID: <20230520163049.3204f31b@jic23-huawei>
In-Reply-To: <73c633ccab80bdfaa1adf6ae099cfc9d365be6a2.1684493615.git.mazziesaccount@gmail.com>
References: <cover.1684493615.git.mazziesaccount@gmail.com>
	<73c633ccab80bdfaa1adf6ae099cfc9d365be6a2.1684493615.git.mazziesaccount@gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.37; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 19 May 2023 14:04:32 +0300
Matti Vaittinen <mazziesaccount@gmail.com> wrote:

> fwnode_irq_get[_byname]() were changed to not return 0 anymore. The
> special error case where device-tree based IRQ mapping fails can't no
> longer be reliably detected from this return value. This yields a
> functional change in the driver where the mapping failure is treated as
> an error.
> 
> The mapping failure can occur for example when the device-tree IRQ
> information translation call-back(s) (xlate) fail, IRQ domain is not
> found, IRQ type conflicts, etc. In most cases this indicates an error in
> the device-tree and special handling is not really required.
> 
> One more thing to note is that ACPI APIs do not return zero for any
> failures so this special handling did only apply on device-tree based
> systems.
> 
> Drop the special handling for DT mapping failures as these can no longer
> be separated from other errors at driver side.
> 
> Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
> 
> ---
> 
> Please note that I don't have the hardware to test this change.
> Furthermore, testing this type of device-tree error cases is not
> trivial, as the question we probably dive in is "what happens with the
> existing users who have errors in the device-tree". Answering to this
> question is not simple.
> 
> I did this patch with minimal code changes - but a question is if we
> should really jump into the else branch below on all IRQ getting errors?
> 
>         } else {
>                 indio_dev->info = &ad7150_info_no_irq;
>                 switch (id->driver_data) {
>                 case AD7150:
>                         indio_dev->channels = ad7150_channels_no_irq;
>                         indio_dev->num_channels =
>                                 ARRAY_SIZE(ad7150_channels_no_irq);
>                         break;
>                 case AD7151:
>                         indio_dev->channels = ad7151_channels_no_irq;
>                         indio_dev->num_channels =
>                                 ARRAY_SIZE(ad7151_channels_no_irq);
>                         break;
>                 default:
>                         return -EINVAL;
>                 }
> 
> Why do we have special handling for !chip->interrupts[0] while other
> errors on getting the fwnode_irq_get(dev_fwnode(&client->dev), 0); will
> abort the probe?

Gut feeling is that this was a rework of board file code where 0 meant not
provided. We should look to do the same here.  I'm not sure we have a consistent
return for no irq though across the various fw types.

The driver looks like it should support either no interrupts or all the
ones for a given device.

Currrently it definitely doesn't handle the no irqs provided case right.
Its not elegant, but if we have to have all failures to get irqs result
in carrying on without them then that's better than now.

Jonathan


> 
> The first patch of the series changes the fwnode_irq_get() so this depends
> on the first patch of the series and should not be applied alone.
> ---
>  drivers/iio/cdc/ad7150.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/iio/cdc/ad7150.c b/drivers/iio/cdc/ad7150.c
> index 79aeb0aaea67..d7ba50b9780d 100644
> --- a/drivers/iio/cdc/ad7150.c
> +++ b/drivers/iio/cdc/ad7150.c
> @@ -567,8 +567,7 @@ static int ad7150_probe(struct i2c_client *client)
>  		if (chip->interrupts[1] < 0)
>  			return chip->interrupts[1];
>  	}
> -	if (chip->interrupts[0] &&
> -	    (id->driver_data == AD7151 || chip->interrupts[1])) {
> +	if (id->driver_data == AD7151 || chip->interrupts[1]) {
>  		irq_set_status_flags(chip->interrupts[0], IRQ_NOAUTOEN);
>  		ret = devm_request_threaded_irq(&client->dev,
>  						chip->interrupts[0],


