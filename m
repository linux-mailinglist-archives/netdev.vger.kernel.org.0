Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39BC31A52D6
	for <lists+netdev@lfdr.de>; Sat, 11 Apr 2020 18:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbgDKQMC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 12:12:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:58758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726054AbgDKQMC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 12:12:02 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 708232078E;
        Sat, 11 Apr 2020 16:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586621522;
        bh=xGSrZYsmr8Rx4rTlJx8S0cahLkNk3/rISN1e36L5dfw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PJuvLC60UfUFZJ6c6uAbd2GfsMnVqppzNcrJkgGE26coDxnU244BVymNHyLFxVvh/
         SGVBw4msc7PUOKxizlBOLa+Zn/nyY2mOeFWU/EoNXeoNDBtx/E+f2V7a03X+E0IQLE
         zchs/QnkHPcr3mObpoAV1v4FVmYW1XFsrDBGjrbw=
Date:   Sat, 11 Apr 2020 19:11:56 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Don Fry <pcnet32@frontier.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>, linux-acenic@sunsite.dk,
        Maxime Ripard <mripard@kernel.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Mark Einon <mark.einon@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        linux-rockchip@lists.infradead.org,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        David Dillow <dave@thedillows.org>,
        Netanel Belgazal <netanel@amazon.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        linux-arm-kernel@lists.infradead.org,
        Andreas Larsson <andreas@gaisler.com>,
        Andy Gospodarek <andy@greyhouse.net>, netdev@vger.kernel.org,
        Thor Thayer <thor.thayer@linux.intel.com>,
        linux-kernel@vger.kernel.org, Ion Badulescu <ionut@badula.org>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        Jes Sorensen <jes@trained-monkey.org>,
        nios2-dev@lists.rocketboards.org, Chen-Yu Tsai <wens@csie.org>
Subject: Re: [PATCH] net/3com/3c515: Fix MODULE_ARCH_VERMAGIC redefinition
Message-ID: <20200411161156.GA200683@unreal>
References: <20200224085311.460338-1-leon@kernel.org>
 <20200224085311.460338-4-leon@kernel.org>
 <20200411155623.GA22175@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200411155623.GA22175@zn.tnic>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 11, 2020 at 05:56:23PM +0200, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
>
> Change the include order so that MODULE_ARCH_VERMAGIC from the arch
> header arch/x86/include/asm/module.h gets used instead of the fallback
> from include/linux/vermagic.h and thus fix:
>
>   In file included from ./include/linux/module.h:30,
>                    from drivers/net/ethernet/3com/3c515.c:56:
>   ./arch/x86/include/asm/module.h:73: warning: "MODULE_ARCH_VERMAGIC" redefined
>      73 | # define MODULE_ARCH_VERMAGIC MODULE_PROC_FAMILY
>         |
>   In file included from drivers/net/ethernet/3com/3c515.c:25:
>   ./include/linux/vermagic.h:28: note: this is the location of the previous definition
>      28 | #define MODULE_ARCH_VERMAGIC ""
>         |
>
> Fixes: 6bba2e89a88c ("net/3com: Delete driver and module versions from 3com drivers")
> Signed-off-by: Borislav Petkov <bp@suse.de>
> ---
>  drivers/net/ethernet/3com/3c515.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Probably, this is the right change, but I have a feeling that the right
solution will be inside headers itself. It is a little bit strange that
both very common kernel headers like module.h and vermagic.h are location
dependant.

Thanks

>
> diff --git a/drivers/net/ethernet/3com/3c515.c b/drivers/net/ethernet/3com/3c515.c
> index 90312fcd6319..cdceef891dbd 100644
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
> @@ -67,6 +66,7 @@ static int max_interrupt_work = 20;
>  #include <linux/timer.h>
>  #include <linux/ethtool.h>
>  #include <linux/bitops.h>
> +#include <linux/vermagic.h>
>
>  #include <linux/uaccess.h>
>  #include <asm/io.h>
> --
> 2.21.0
>
> --
> Regards/Gruss,
>     Boris.
>
> https://people.kernel.org/tglx/notes-about-netiquette
