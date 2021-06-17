Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A41173AACBB
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 08:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbhFQGxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 02:53:54 -0400
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:33314 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbhFQGxx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 02:53:53 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id BED3E2BF26;
        Thu, 17 Jun 2021 02:51:34 -0400 (EDT)
Date:   Thu, 17 Jun 2021 16:51:33 +1000 (AEST)
From:   Finn Thain <fthain@linux-m68k.org>
To:     Michael Schmitz <schmitzmic@gmail.com>
cc:     linux-m68k@vger.kernel.org, geert@linux-m68k.org, alex@kazik.de,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3 2/2] net/8390: apne.c - add 100 Mbit support
 to apne.c driver
In-Reply-To: <1623907712-29366-3-git-send-email-schmitzmic@gmail.com>
Message-ID: <d661fb8-274d-6731-75f4-685bb2311c41@linux-m68k.org>
References: <1623907712-29366-1-git-send-email-schmitzmic@gmail.com> <1623907712-29366-3-git-send-email-schmitzmic@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Jun 2021, Michael Schmitz wrote:

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
> Tested-by: Alex Kazik <alex@kazik.de>
> Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
> 
> --
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
>  drivers/net/ethernet/8390/Kconfig | 12 ++++++++++++
>  drivers/net/ethernet/8390/apne.c  | 21 +++++++++++++++++++++
>  2 files changed, 33 insertions(+)
> 
> diff --git a/drivers/net/ethernet/8390/Kconfig b/drivers/net/ethernet/8390/Kconfig
> index 9f4b302..6e4db63 100644
> --- a/drivers/net/ethernet/8390/Kconfig
> +++ b/drivers/net/ethernet/8390/Kconfig
> @@ -143,6 +143,18 @@ config APNE
>  	  To compile this driver as a module, choose M here: the module
>  	  will be called apne.
>  
> +config APNE100MBIT
> +	bool "PCMCIA NE2000 100MBit support"
> +	depends on APNE
> +	default n
> +	help
> +	  This changes the driver to support 10/100Mbit cards (e.g. Netgear
> +	  FA411, CNet Singlepoint). 10 MBit cards and 100 MBit cards are
> +	  supported by the same driver.
> +
> +	  To activate 100 Mbit support at runtime or from the kernel
> +	  command line, use the apne.100mbit module parameter.
> +
>  config PCMCIA_PCNET
>  	tristate "NE2000 compatible PCMCIA support"
>  	depends on PCMCIA
> diff --git a/drivers/net/ethernet/8390/apne.c b/drivers/net/ethernet/8390/apne.c
> index fe6c834..59e41ad 100644
> --- a/drivers/net/ethernet/8390/apne.c
> +++ b/drivers/net/ethernet/8390/apne.c
> @@ -120,6 +120,12 @@ static u32 apne_msg_enable;
>  module_param_named(msg_enable, apne_msg_enable, uint, 0444);
>  MODULE_PARM_DESC(msg_enable, "Debug message level (see linux/netdevice.h for bitmap)");
>  
> +#ifdef CONFIG_APNE100MBIT
> +static bool apne_100_mbit;
> +module_param_named(apne_100_mbit_msg, apne_100_mbit, bool, 0444);
> +MODULE_PARM_DESC(apne_100_mbit_msg, "Enable 100 Mbit support");
> +#endif
> +
>  struct net_device * __init apne_probe(int unit)
>  {
>  	struct net_device *dev;
> @@ -139,6 +145,11 @@ struct net_device * __init apne_probe(int unit)
>  	if ( !(AMIGAHW_PRESENT(PCMCIA)) )
>  		return ERR_PTR(-ENODEV);
>  
> +#ifdef CONFIG_APNE100MBIT
> +	if (apne_100_mbit)
> +		isa_type = ISA_TYPE_AG16;
> +#endif
> +

I think isa_type has to be assigned unconditionally otherwise it can't be 
reset for 10 mbit cards. Therefore, the AMIGAHW_PRESENT(PCMCIA) logic in 
arch/m68k/kernel/setup_mm.c probably should move here.

>  	pr_info("Looking for PCMCIA ethernet card : ");
>  
>  	/* check if a card is inserted */
> @@ -590,6 +601,16 @@ static int init_pcmcia(void)
>  #endif
>  	u_long offset;
>  
> +#ifdef CONFIG_APNE100MBIT
> +	/* reset card (idea taken from CardReset by Artur Pogoda) */
> +	{
> +		u_char  tmp = gayle.intreq;
> +
> +		gayle.intreq = 0xff;    mdelay(1);
> +		gayle.intreq = tmp;     mdelay(300);
> +	}
> +#endif
> +

The indentation/alignment here doesn't conform to the kernel coding style. 
