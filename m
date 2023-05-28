Return-Path: <netdev+bounces-5958-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 50E85713B03
	for <lists+netdev@lfdr.de>; Sun, 28 May 2023 19:09:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 87617280E04
	for <lists+netdev@lfdr.de>; Sun, 28 May 2023 17:09:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68A325677;
	Sun, 28 May 2023 17:09:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C68432F3D
	for <netdev@vger.kernel.org>; Sun, 28 May 2023 17:09:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E930C433D2;
	Sun, 28 May 2023 17:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685293767;
	bh=2HpDsz16RbryZeSwk70hXDJ4gla3IAE1NdBPN6l1aP8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Gr7QOQt2l6vjbf3VM5hswjKooNeJfYxzibw4EBvFMzr6n1/GoC6PpJxvrJ/OSbiyc
	 +mKF1bnLp+ges7WvYmqyL7W2abCU90qn/i9l0fP4xb7qKF6wfRSh7saGoj6JTORp9v
	 5KsEMMULspxFSEltwBYRnArSLyi6T3YXQbVvAbU+6E0Cn1O3mZhj6AOa+Re9io82A0
	 bAL+LUT9h9y7xq1qEBrVNKXVTFEKyN/Ex25o8am3ApyPZLEcER9wLiabH1WIqw3ztq
	 cftIDCy+iZtZOBNoONnZOKsvPH2uQUDTw19nFruZATKPF/sytCKpatxgMXRSmXqHVk
	 gIqRX+UivGbDQ==
Date: Sun, 28 May 2023 18:25:43 +0100
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
Subject: Re: [PATCH v6 1/8] drivers: fwnode: fix fwnode_irq_get[_byname]()
Message-ID: <20230528182543.656da0d1@jic23-huawei>
In-Reply-To: <f457a106929e37638a87775d8d72adaff0f85cb6.1685082026.git.mazziesaccount@gmail.com>
References: <cover.1685082026.git.mazziesaccount@gmail.com>
	<f457a106929e37638a87775d8d72adaff0f85cb6.1685082026.git.mazziesaccount@gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 26 May 2023 09:35:30 +0300
Matti Vaittinen <mazziesaccount@gmail.com> wrote:

> The fwnode_irq_get() and the fwnode_irq_get_byname() return 0 upon
> device-tree IRQ mapping failure. This is contradicting the
> fwnode_irq_get_byname() function documentation and can potentially be a
> source of errors like:
> 
> int probe(...) {
> 	...
> 
> 	irq = fwnode_irq_get_byname();
> 	if (irq <= 0)
> 		return irq;
> 
> 	...
> }
> 
> Here we do correctly check the return value from fwnode_irq_get_byname()
> but the driver probe will now return success. (There was already one
> such user in-tree).
> 
> Change the fwnode_irq_get_byname() to work as documented and make also the
> fwnode_irq_get() follow same common convention returning a negative errno
> upon failure.
> 
> Fixes: ca0acb511c21 ("device property: Add fwnode_irq_get_byname")
> Suggested-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Suggested-by: Jonathan Cameron <jic23@kernel.org>
> Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
> Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> 
This bothers me a little because there may be drivers that haven't been
caught yet that assume the zero value.   Still this is more consistent
with what I'd expect to happen, so fair enough

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>


> ---
> I dropped the existing reviewed-by tags because change to
> fwnode_irq_get() was added.
> 
> Revision history:
> v4 =>:
>  - No Changes
> v3 => v4:
>  - Change also the fwnode_irq_get()
> ---
>  drivers/base/property.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/base/property.c b/drivers/base/property.c
> index f6117ec9805c..8c40abed7852 100644
> --- a/drivers/base/property.c
> +++ b/drivers/base/property.c
> @@ -987,12 +987,18 @@ EXPORT_SYMBOL(fwnode_iomap);
>   * @fwnode:	Pointer to the firmware node
>   * @index:	Zero-based index of the IRQ
>   *
> - * Return: Linux IRQ number on success. Other values are determined
> - * according to acpi_irq_get() or of_irq_get() operation.
> + * Return: Linux IRQ number on success. Negative errno on failure.
>   */
>  int fwnode_irq_get(const struct fwnode_handle *fwnode, unsigned int index)
>  {
> -	return fwnode_call_int_op(fwnode, irq_get, index);
> +	int ret;
> +
> +	ret = fwnode_call_int_op(fwnode, irq_get, index);
> +	/* We treat mapping errors as invalid case */
> +	if (ret == 0)
> +		return -EINVAL;
> +
> +	return ret;
>  }
>  EXPORT_SYMBOL(fwnode_irq_get);
>  


