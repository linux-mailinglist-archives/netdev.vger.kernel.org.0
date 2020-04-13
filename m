Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF791A645A
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 10:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727999AbgDMIkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 04:40:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:49374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727973AbgDMIkc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Apr 2020 04:40:32 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45242206E9;
        Mon, 13 Apr 2020 08:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586767231;
        bh=lec+XLa+bZRy13OGfwXSfzBA273C7nl3khRkobB7PMo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VjxlR7LeuduygCW8N3O7d8WuwuxRBDc5jWaVykBTvmghy8pyNm+q6KygLOUUbgPu/
         acACnfoqmgLIw2OqRBNn6GQ0NRrqLnH7NQvCCVw28dEaE9DtDPJuI6Xm/5Z9vexavL
         qfJ0DaAoxaW0KkjHuiLGRJUCtAzyM/frxuUheBLE=
Date:   Mon, 13 Apr 2020 11:40:26 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     David Miller <davem@davemloft.net>, kuba@kernel.org,
        thomas.lendacky@amd.com, keyur@os.amperecomputing.com,
        pcnet32@frontier.com, vfalico@gmail.com, j.vosburgh@gmail.com,
        linux-acenic@sunsite.dk, mripard@kernel.org, heiko@sntech.de,
        mark.einon@gmail.com, chris.snook@gmail.com,
        linux-rockchip@lists.infradead.org, iyappan@os.amperecomputing.com,
        irusskikh@marvell.com, dave@thedillows.org, netanel@amazon.com,
        quan@os.amperecomputing.com, jcliburn@gmail.com,
        LinoSanfilippo@gmx.de, linux-arm-kernel@lists.infradead.org,
        andreas@gaisler.com, andy@greyhouse.net, netdev@vger.kernel.org,
        thor.thayer@linux.intel.com, linux-kernel@vger.kernel.org,
        ionut@badula.org, akiyano@amazon.com, jes@trained-monkey.org,
        nios2-dev@lists.rocketboards.org, wens@csie.org
Subject: Re: [PATCH] net/3com/3c515: Fix MODULE_ARCH_VERMAGIC redefinition
Message-ID: <20200413084026.GH334007@unreal>
References: <20200413045555.GE334007@unreal>
 <20200412.220739.516022706077351913.davem@davemloft.net>
 <20200413052637.GG334007@unreal>
 <20200412.223604.1160930629964379276.davem@davemloft.net>
 <20200413080452.GA3772@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200413080452.GA3772@zn.tnic>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 13, 2020 at 10:04:52AM +0200, Borislav Petkov wrote:
> On Sun, Apr 12, 2020 at 10:36:04PM -0700, David Miller wrote:
> > From: Leon Romanovsky <leon@kernel.org>
> > Date: Mon, 13 Apr 2020 08:26:37 +0300
> >
> > > How do you want us to handle it? Boris resend, me to send, you to fix?
> >
> > Anyone other than me can do it ;-)
>
> Ok, here's what I'm thinking: that vermagic.h is normally automatically
> included in the *mod.c as part of the module creation, see add_header()
> in modpost.c.
>
> So then perhaps drivers should not use it directly due to the current
> inclusion order:
>
> linux/module.h includes asm/module.h and that arch-specific header
> defines MODULE_VERMAGIC* for the respective arch.
>
> linux/vermagic.h defines all those fallbacks for those MODULE_VERMAGIC*
> things and if the inclusion order is swapped - we get the redefinition
> warning.
>
> Yesterday I tried the below - basically get rid of all the remaining
> includers of linux/vermagic.h but two are left:
>
> drivers/net/ethernet/hisilicon/hns3/hns3_enet.c:18:#include <linux/vermagic.h>
> drivers/net/ethernet/netronome/nfp/nfp_main.c:17:#include <linux/vermagic.h>
>
> because both use VERMAGIC_STRING directly.
>
> So,
>
> * one could either allow that and sort the inclusion order so that, for
> example, asm/module.h includes linux/vermagic.h and thus the fallbacks
> are there present.
>
> or
>
> * remove all uses of VERMAGIC_STRING from the drivers, add a header
> guard which prevents people from using it directly and leave
> VERMAGIC_STRING only to the internal module machinery in the kernel.
>
> Judging by how only a handful of old drivers are even using that,
> perhaps not too far fetched.
>
> In any case, this needs a maintainer decision.
>
> Leon, if you wanna do it whatever you guys end up agreeing on, just go
> ahead and submit the patches - it's not like I don't have anything else
> on the TODO :-) Just add a Reported-by: me and that should be enough.

I broke it so I should fix and will send a patch today/tomorrow.

Thanks

>
> If you're busy too, lemme know and I'll put it on my todo then.
>
> Thx.
>
> diff --git a/drivers/net/bonding/bonding_priv.h b/drivers/net/bonding/bonding_priv.h
> index 45b77bc8c7b3..48cdf3a49a7d 100644
> --- a/drivers/net/bonding/bonding_priv.h
> +++ b/drivers/net/bonding/bonding_priv.h
> @@ -14,7 +14,7 @@
>
>  #ifndef _BONDING_PRIV_H
>  #define _BONDING_PRIV_H
> -#include <linux/vermagic.h>
> +#include <generated/utsrelease.h>
>
>  #define DRV_NAME	"bonding"
>  #define DRV_DESCRIPTION	"Ethernet Channel Bonding Driver"
> diff --git a/drivers/net/ethernet/3com/3c509.c b/drivers/net/ethernet/3com/3c509.c
> index b762176a1406..139d0120f511 100644
> --- a/drivers/net/ethernet/3com/3c509.c
> +++ b/drivers/net/ethernet/3com/3c509.c
> @@ -85,7 +85,6 @@
>  #include <linux/device.h>
>  #include <linux/eisa.h>
>  #include <linux/bitops.h>
> -#include <linux/vermagic.h>
>
>  #include <linux/uaccess.h>
>  #include <asm/io.h>
> diff --git a/drivers/net/ethernet/3com/3c515.c b/drivers/net/ethernet/3com/3c515.c
> index 90312fcd6319..47b4215bb93b 100644
> --- a/drivers/net/ethernet/3com/3c515.c
> +++ b/drivers/net/ethernet/3com/3c515.c
> @@ -22,7 +22,6 @@
>
>  */
>
> -#include <linux/vermagic.h>
>  #define DRV_NAME		"3c515"
>
>  #define CORKSCREW 1
> diff --git a/drivers/net/ethernet/adaptec/starfire.c b/drivers/net/ethernet/adaptec/starfire.c
> index 2db42211329f..a64191fc2af9 100644
> --- a/drivers/net/ethernet/adaptec/starfire.c
> +++ b/drivers/net/ethernet/adaptec/starfire.c
> @@ -45,7 +45,6 @@
>  #include <asm/processor.h>		/* Processor type for cache alignment. */
>  #include <linux/uaccess.h>
>  #include <asm/io.h>
> -#include <linux/vermagic.h>
>
>  /*
>   * The current frame processor firmware fails to checksum a fragment
> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
> index 588c62e9add7..3ed150512091 100644
> --- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
> +++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
> @@ -6,7 +6,7 @@
>  #include <linux/module.h>
>  #include <linux/netdevice.h>
>  #include <linux/utsname.h>
> -#include <linux/vermagic.h>
> +#include <generated/utsrelease.h>
>
>  #include "ionic.h"
>  #include "ionic_bus.h"
> diff --git a/drivers/power/supply/test_power.c b/drivers/power/supply/test_power.c
> index 65c23ef6408d..b3c05ff05783 100644
> --- a/drivers/power/supply/test_power.c
> +++ b/drivers/power/supply/test_power.c
> @@ -16,7 +16,7 @@
>  #include <linux/power_supply.h>
>  #include <linux/errno.h>
>  #include <linux/delay.h>
> -#include <linux/vermagic.h>
> +#include <generated/utsrelease.h>
>
>  enum test_power_id {
>  	TEST_AC,
> diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
> index 89d0b1827aaf..adab97e500cf 100644
> --- a/net/ethtool/ioctl.c
> +++ b/net/ethtool/ioctl.c
> @@ -17,7 +17,6 @@
>  #include <linux/phy.h>
>  #include <linux/bitops.h>
>  #include <linux/uaccess.h>
> -#include <linux/vermagic.h>
>  #include <linux/vmalloc.h>
>  #include <linux/sfp.h>
>  #include <linux/slab.h>
> @@ -29,6 +28,8 @@
>  #include <net/flow_offload.h>
>  #include <linux/ethtool_netlink.h>
>
> +#include <generated/utsrelease.h>
> +
>  #include "common.h"
>
>  /*
>
>
> --
> Regards/Gruss,
>     Boris.
>
> https://people.kernel.org/tglx/notes-about-netiquette
