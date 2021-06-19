Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6003AD661
	for <lists+netdev@lfdr.de>; Sat, 19 Jun 2021 02:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235310AbhFSA7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 20:59:05 -0400
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:33524 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231819AbhFSA7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 20:59:04 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id 7E45F29FEF;
        Fri, 18 Jun 2021 20:56:50 -0400 (EDT)
Date:   Sat, 19 Jun 2021 10:56:51 +1000 (AEST)
From:   Finn Thain <fthain@linux-m68k.org>
To:     Michael Schmitz <schmitzmic@gmail.com>
cc:     linux-m68k@vger.kernel.org, geert@linux-m68k.org, alex@kazik.de,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v5 2/2] net/8390: apne.c - add 100 Mbit support
 to apne.c driver
In-Reply-To: <1624062891-22762-3-git-send-email-schmitzmic@gmail.com>
Message-ID: <83b0640-459c-6f46-e070-1fc9559bd0be@linux-m68k.org>
References: <1624062891-22762-1-git-send-email-schmitzmic@gmail.com> <1624062891-22762-3-git-send-email-schmitzmic@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 19 Jun 2021, Michael Schmitz wrote:

> Add Kconfig option, module parameter and PCMCIA reset code
> required to support 100 Mbit PCMCIA ethernet cards on Amiga.
> 
> 10 Mbit and 100 Mbit mode are supported by the same module.
> A module parameter switches Amiga ISA IO accessors to word
> access by changing isa_type at runtime. Additional code to
> reset the PCMCIA hardware is also added to the driver probe.
> 
> Patch modified after patch "[PATCH RFC net-next] Amiga PCMCIA
> 100 MBit card support" submitted to netdev 2018/09/16 by Alex
> Kazik <alex@kazik.de>.
> 
> CC: netdev@vger.kernel.org
> Link: https://lore.kernel.org/r/1622958877-2026-1-git-send-email-schmitzmic@gmail.com
> Tested-by: Alex Kazik <alex@kazik.de>
> Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
> 
> --
> Changes from v4:
> 
> Geert Uytterhoeven:
> - remove APNE100MBIT config option, always include 16 bit support
> - change module parameter permissions
> - try autoprobing for 16 bit mode early on in device probe
> 
> Changes from v3:
> 
> - change module parameter name to match Kconfig help
> 
> Finn Thain:
> - fix coding style in new card reset code block
> - allow reset of isa_type by module parameter
> 
> Changes from v1:
> 
> - fix module parameter name in Kconfig help text
> 
> Alex Kazik:
> - change module parameter type to bool, fix module parameter
>   permission
> 
> Changes from RFC:
> 
> Geert Uytterhoeven:
> - change APNE_100MBIT to depend on APNE
> - change '---help---' to 'help' (former no longer supported)
> - fix whitespace errors
> - fix module_param_named() arg count
> - protect all added code by #ifdef CONFIG_APNE_100MBIT
> ---
>  drivers/net/ethernet/8390/Kconfig |  4 ++++
>  drivers/net/ethernet/8390/apne.c  | 33 +++++++++++++++++++++++++++++++++
>  2 files changed, 37 insertions(+)
> 
> diff --git a/drivers/net/ethernet/8390/Kconfig b/drivers/net/ethernet/8390/Kconfig
> index 9f4b302..cf0d8b3 100644
> --- a/drivers/net/ethernet/8390/Kconfig
> +++ b/drivers/net/ethernet/8390/Kconfig
> @@ -143,6 +143,10 @@ config APNE
>  	  To compile this driver as a module, choose M here: the module
>  	  will be called apne.
>  
> +	  The driver also supports 10/100Mbit cards (e.g. Netgear FA411,
> +	  CNet Singlepoint). To activate 100 Mbit support at runtime or
> +	  from the kernel command line, use the apne.100mbit module parameter.
> +
>  config PCMCIA_PCNET
>  	tristate "NE2000 compatible PCMCIA support"
>  	depends on PCMCIA
> diff --git a/drivers/net/ethernet/8390/apne.c b/drivers/net/ethernet/8390/apne.c
> index fe6c834..8223e15 100644
> --- a/drivers/net/ethernet/8390/apne.c
> +++ b/drivers/net/ethernet/8390/apne.c
> @@ -120,6 +120,10 @@ static u32 apne_msg_enable;
>  module_param_named(msg_enable, apne_msg_enable, uint, 0444);
>  MODULE_PARM_DESC(msg_enable, "Debug message level (see linux/netdevice.h for bitmap)");
>  
> +static bool apne_100_mbit;
> +module_param_named(100_mbit, apne_100_mbit, bool, 0644);
> +MODULE_PARM_DESC(100_mbit, "Enable 100 Mbit support");
> +
>  struct net_device * __init apne_probe(int unit)
>  {
>  	struct net_device *dev;
> @@ -139,6 +143,11 @@ struct net_device * __init apne_probe(int unit)
>  	if ( !(AMIGAHW_PRESENT(PCMCIA)) )
>  		return ERR_PTR(-ENODEV);
>  
> +	if (apne_100_mbit)
> +		isa_type = ISA_TYPE_AG16;
> +	else
> +		isa_type = ISA_TYPE_AG;
> +
>  	pr_info("Looking for PCMCIA ethernet card : ");
>  
>  	/* check if a card is inserted */
> @@ -147,6 +156,20 @@ struct net_device * __init apne_probe(int unit)
>  		return ERR_PTR(-ENODEV);
>  	}
>  
> +	/* Reset card. Who knows what dain-bramaged state it was left in. */
> +	{	unsigned long reset_start_time = jiffies;

There's a missing line break here.

> +
> +		outb(inb(IOBASE + NE_RESET), IOBASE + NE_RESET);
> +
> +		while ((inb(IOBASE + NE_EN0_ISR) & ENISR_RESET) == 0)
> +			if (time_after(jiffies, reset_start_time + 2*HZ/100)) {

You could use msecs_to_jiffies(20) here.

> +				pr_info("Card not found (no reset ack).\n");
> +				isa_type=ISA_TYPE_AG16;

Whitespace is needed around the '='.

> +			}

Missing a break statement?

> +
> +		outb(0xff, IOBASE + NE_EN0_ISR);		/* Ack all intr. */
> +	}
> +
>  	dev = alloc_ei_netdev();
>  	if (!dev)
>  		return ERR_PTR(-ENOMEM);
> @@ -590,6 +613,16 @@ static int init_pcmcia(void)
>  #endif
>  	u_long offset;
>  
> +	/* reset card (idea taken from CardReset by Artur Pogoda) */
> +	if (isa_type == ISA_TYPE_AG16) {
> +		u_char  tmp = gayle.intreq;
> +

Extra whitespace.

> +		gayle.intreq = 0xff;
> +		mdelay(1);
> +		gayle.intreq = tmp;
> +		mdelay(300);
> +	}
> +
>  	pcmcia_reset();
>  	pcmcia_program_voltage(PCMCIA_0V);
>  	pcmcia_access_speed(PCMCIA_SPEED_250NS);
> 
