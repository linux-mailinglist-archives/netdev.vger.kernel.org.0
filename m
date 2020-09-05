Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D00525EA65
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 22:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728563AbgIEU3E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 16:29:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:44216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727875AbgIEU3C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Sep 2020 16:29:02 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 613F62074B;
        Sat,  5 Sep 2020 20:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599337742;
        bh=3wboYHz/3sHbkUIbOoXgqX9eshZcgQ1MZwI9CiM9CBs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Sc+cGqCR5aK9twIg7DvMQOAGM7/mftEfs9PSfKzYojxUWffS0Cbk7bBrPfn7i3Fmu
         6bVCcKFI8jJrSFMlxlxd7VQvPggdq0DcDvlAOAXgphL/3xg4sd1FKdwoozwayPVSjL
         MFrHJI4HgzcDFojBU4jqd9xdXTJwPurSU9cE3am0=
Date:   Sat, 5 Sep 2020 13:29:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Armin Wolf <W_Armin@gmx.de>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH 1/3 v4 net-next] lib8390: Fix coding-style issues and
 remove verion printing
Message-ID: <20200905132900.2ca8ad26@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200905174317.GA6795@mx-linux-amd>
References: <20200905174317.GA6795@mx-linux-amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 5 Sep 2020 19:43:17 +0200 Armin Wolf wrote:
> Fix various checkpatch warnings.
> 
> Remove version printing so modules including lib8390 do not
> have to provide a global version string for successful
> compilation.
> 
> Replace pr_cont() with SMP-safe construct.
> 
> Signed-off-by: Armin Wolf <W_Armin@gmx.de>

> @@ -106,90 +105,86 @@ static void ei_receive(struct net_device *dev);
>  static void ei_rx_overrun(struct net_device *dev);
> 
>  /* Routines generic to NS8390-based boards. */
> -static void NS8390_trigger_send(struct net_device *dev, unsigned int length,
> -								int start_page);
> +static void NS8390_trigger_send(struct net_device *dev,
> +				unsigned int length, int start_page);

Please note that max line length was recently update to 120 (I think),
so the line wrap changes here are not necessary.

>  static void do_set_multicast_list(struct net_device *dev);
>  static void __NS8390_init(struct net_device *dev, int startp);
> 
> -static unsigned version_printed;
>  static u32 msg_enable;
> +
>  module_param(msg_enable, uint, 0444);
>  MODULE_PARM_DESC(msg_enable, "Debug message level (see linux/netdevice.h for bitmap)");
> 
> -/*
> - *	SMP and the 8390 setup.
> +/* SMP and the 8390 setup.
>   *
> - *	The 8390 isn't exactly designed to be multithreaded on RX/TX. There is
> - *	a page register that controls bank and packet buffer access. We guard
> - *	this with ei_local->page_lock. Nobody should assume or set the page other
> - *	than zero when the lock is not held. Lock holders must restore page 0
> - *	before unlocking. Even pure readers must take the lock to protect in
> - *	page 0.
> + * The 8390 isn't exactly designed to be multithreaded on RX/TX. There is
> + * a page register that controls bank and packet buffer access. We guard
> + * this with ei_local->page_lock. Nobody should assume or set the page other
> + * than zero when the lock is not held. Lock holders must restore page 0
> + * before unlocking. Even pure readers must take the lock to protect in
> + * page 0.

Realigning the start of line like this is not worth it, please leave it
be. The kernel is full of indented comments.

> -	/*
> -	 *	Grab the page lock so we own the register set, then call
> -	 *	the init function.
> +	/* Grab the page lock so we own the register set, then call
> +	 * the init function.
>  	 */

This as well, etc..

> @@ -532,30 +529,22 @@ static void ei_tx_err(struct net_device *dev)
>  {
>  	unsigned long e8390_base = dev->base_addr;
>  	/* ei_local is used on some platforms via the EI_SHIFT macro */
> -	struct ei_device *ei_local __maybe_unused = netdev_priv(dev);
> -	unsigned char txsr = ei_inb_p(e8390_base+EN0_TSR);
> -	unsigned char tx_was_aborted = txsr & (ENTSR_ABT+ENTSR_FU);
> -
> -#ifdef VERBOSE_ERROR_DUMP
> -	netdev_dbg(dev, "transmitter error (%#2x):", txsr);
> -	if (txsr & ENTSR_ABT)
> -		pr_cont(" excess-collisions ");
> -	if (txsr & ENTSR_ND)
> -		pr_cont(" non-deferral ");
> -	if (txsr & ENTSR_CRS)
> -		pr_cont(" lost-carrier ");
> -	if (txsr & ENTSR_FU)
> -		pr_cont(" FIFO-underrun ");
> -	if (txsr & ENTSR_CDH)
> -		pr_cont(" lost-heartbeat ");
> -	pr_cont("\n");
> -#endif
> -
> +	struct ei_device *ei_local = netdev_priv(dev);
> +	unsigned char txsr = ei_inb_p(e8390_base + EN0_TSR);
> +	unsigned char tx_was_aborted = txsr & (ENTSR_ABT + ENTSR_FU);
> +
> +	if (netif_msg_tx_err(ei_local)) {
> +		netdev_err(dev, "Transmitter error %#2x ( %s%s%s%s%s)", txsr,
> +			   (txsr & ENTSR_ABT) ? "excess-collisions " : "",
> +			   (txsr & ENTSR_ND) ? "non-deferral " : "",
> +			   (txsr & ENTSR_CRS) ? "lost-carrier " : "",
> +			   (txsr & ENTSR_FU) ? "FIFO-underrun " : "",
> +			   (txsr & ENTSR_CDH) ? "lost-heartbeat " : "");
> +	}

The pr_cont() -> netdev_err() changes should be a separate patch.
