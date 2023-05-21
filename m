Return-Path: <netdev+bounces-4119-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E61970AF2D
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 19:13:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CC7D6280D8F
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 17:13:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC1F36AD8;
	Sun, 21 May 2023 17:13:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6AC10E8
	for <netdev@vger.kernel.org>; Sun, 21 May 2023 17:13:26 +0000 (UTC)
Received: from fgw20-7.mail.saunalahti.fi (fgw20-7.mail.saunalahti.fi [62.142.5.81])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B81910E
	for <netdev@vger.kernel.org>; Sun, 21 May 2023 10:13:23 -0700 (PDT)
Received: from localhost (88-113-26-95.elisa-laajakaista.fi [88.113.26.95])
	by fgw20.mail.saunalahti.fi (Halon) with ESMTP
	id c6755f98-f7fa-11ed-b3cf-005056bd6ce9;
	Sun, 21 May 2023 20:13:18 +0300 (EEST)
From: andy.shevchenko@gmail.com
Date: Sun, 21 May 2023 20:13:16 +0300
To: Matti Vaittinen <mazziesaccount@gmail.com>
Cc: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Daniel Scally <djrscally@gmail.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Wolfram Sang <wsa@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>,
	Michael Hennerich <Michael.Hennerich@analog.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Andreas Klinger <ak@it-klinger.de>, Marcin Wojtas <mw@semihalf.com>,
	Russell King <linux@armlinux.org.uk>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jonathan =?iso-8859-1?Q?Neusch=E4fer?= <j.neuschaefer@gmx.net>,
	Linus Walleij <linus.walleij@linaro.org>,
	Paul Cercueil <paul@crapouillou.net>,
	Akhil R <akhilrajeev@nvidia.com>, linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
	linux-iio@vger.kernel.org, netdev@vger.kernel.org,
	openbmc@lists.ozlabs.org, linux-gpio@vger.kernel.org,
	linux-mips@vger.kernel.org
Subject: Re: [PATCH v5 1/8] drivers: fwnode: fix fwnode_irq_get[_byname]()
Message-ID: <ZGpRLLy1Snez94NQ@surfacebook>
References: <cover.1684493615.git.mazziesaccount@gmail.com>
 <339cc23ccae4580d5551cc2b6b9b4afdde48f25e.1684493615.git.mazziesaccount@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <339cc23ccae4580d5551cc2b6b9b4afdde48f25e.1684493615.git.mazziesaccount@gmail.com>
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,RCVD_IN_MSPIKE_H2,
	SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Fri, May 19, 2023 at 02:00:54PM +0300, Matti Vaittinen kirjoitti:
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

Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>

> Fixes: ca0acb511c21 ("device property: Add fwnode_irq_get_byname")
> Suggested-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Suggested-by: Jonathan Cameron <jic23@kernel.org>
> Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
> 
> ---
> I dropped the existing reviewed-by tags because change to
> fwnode_irq_get() was added.
> 
> Revision history:
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

Not sure if this is the best choice, perhaps -EEXIST or -ENOENT might be
better, but it's just a spoken up thought.

> +	return ret;
>  }
>  EXPORT_SYMBOL(fwnode_irq_get);

-- 
With Best Regards,
Andy Shevchenko



