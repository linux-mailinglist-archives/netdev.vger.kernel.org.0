Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF8071A5341
	for <lists+netdev@lfdr.de>; Sat, 11 Apr 2020 20:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbgDKSKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 14:10:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:41288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726167AbgDKSKV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Apr 2020 14:10:21 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1AE420732;
        Sat, 11 Apr 2020 18:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586628620;
        bh=cR0eHiEhVEU/CYCz8ttOIHBrqvYs0p6ey3Uw55qOSGo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dcNVzinV8moP+fO5RfqQizJEQ1Fo5MA/EWcPhgl3anCgpKoqChGaQQMh6g6lxD8Zu
         U4Uz5GI9QK6vrVpGwcn3HSXE+MfBDWSMFeD7yfpw5OsGv/2b1L7VjOahk8qLWPZWwn
         jvyrMweq0NnBZhQyYqoGjPPwE0zfMs2kGVTNuapw=
Date:   Sat, 11 Apr 2020 21:10:15 +0300
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
Message-ID: <20200411181015.GC200683@unreal>
References: <20200224085311.460338-1-leon@kernel.org>
 <20200224085311.460338-4-leon@kernel.org>
 <20200411155623.GA22175@zn.tnic>
 <20200411161156.GA200683@unreal>
 <20200411173504.GA11128@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200411173504.GA11128@zn.tnic>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 11, 2020 at 07:35:04PM +0200, Borislav Petkov wrote:
> On Sat, Apr 11, 2020 at 07:11:56PM +0300, Leon Romanovsky wrote:
> > Probably, this is the right change, but I have a feeling that the right
> > solution will be inside headers itself. It is a little bit strange that
> > both very common kernel headers like module.h and vermagic.h are location
> > dependant.
>
> Judging by how only a couple of net drivers include vermagic.h directly,
> doh, of course:
>
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
>
> ---
>
> Drivers include
>
> #include <linux/module.h>
>
> which includes
>
> #include <asm/module.h>
>
> which defines the arch-specific MODULE_ARCH_VERMAGIC.
>
> Why did you need to include vermagic.h directly? i386 builds fine with
> the vermagic.h includes removed or was it some other arches which needed
> it?

I want to think that it was an outcome of some 0-day kbuild report,
but I am not sure about that anymore [1].

Thanks

[1] https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org/

>
> Thx.
>
> --
> Regards/Gruss,
>     Boris.
>
> https://people.kernel.org/tglx/notes-about-netiquette
