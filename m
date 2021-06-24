Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1033B2503
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 04:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhFXCbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 22:31:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:59964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229758AbhFXCbc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Jun 2021 22:31:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB35F613B0;
        Thu, 24 Jun 2021 02:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624501754;
        bh=qfes4XlTr7wZHA/gX1R4vn3ErhXUgft2vuwloOuqJH8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FAMh4+QoAuFF1jJ9kHmTbp9/ydQxbb3M5ZXBFYFE5KwhbO8otL4kipxuWZCx5CvXV
         1g/6NvgDwplHRZuGBhTtc6SHDQxjSpk6y95eGTetqRfIvyp32Kx5Ya5T5ay344bzEE
         D9sGb1HKg9xTiP3RmSnd4WkjUR/SLietI7dEfA5kf+f011nRkGNq5yCRB1cyr9AQmK
         00KuXivitCPNOy5tY6Da+rcrfkF2EBc9mOkR5HmtnRsp9bCtE9HojGQ9c48JJ6RFVv
         /P/luhRi5YV574NjTxA3YTl7IYODn5ZeuXzd5tx51WGfWxH6C91MYON63V/vMoiXJ+
         /lOBphk8eqyUg==
Date:   Wed, 23 Jun 2021 19:29:11 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <YNPt91bfjrgSt8G3@Ryzen-9-3900X.localdomain>
References: <20210624082911.5d013e8c@canb.auug.org.au>
 <CAPv3WKfiL+sR+iK_BjGKDhtNgjoxKEPv49bU1X9_7+v+ytdR1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPv3WKfiL+sR+iK_BjGKDhtNgjoxKEPv49bU1X9_7+v+ytdR1w@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 24, 2021 at 12:46:48AM +0200, Marcin Wojtas wrote:
> Hi Stephen,
> 
> czw., 24 cze 2021 o 00:29 Stephen Rothwell <sfr@canb.auug.org.au> napisał(a):
> >
> > Hi all,
> >
> > Today's linux-next build (x86_64 modules_install) failed like this:
> >
> > depmod: ../tools/depmod.c:1792: depmod_report_cycles_from_root: Assertion `is < stack_size' failed.
> >
> > Caused by commit
> >
> > 62a6ef6a996f ("net: mdiobus: Introduce fwnode_mdbiobus_register()")
> >
> > (I bisected to there and tested the commit before.)
> >
> > The actual build is an x86_64 allmodconfig, followed by a
> > modules_install.  This happens in my cross build environment as well as
> > a native build.
> >
> > $ gcc --version
> > gcc (Debian 10.2.1-6) 10.2.1 20210110
> > $ ld --version
> > GNU ld (GNU Binutils for Debian) 2.35.2
> > $ /sbin/depmod --version
> > kmod version 28
> > -ZSTD +XZ -ZLIB +LIBCRYPTO -EXPERIMENTAL
> >
> > I have no idea why that commit should caused this failure.
> 
> Thank you for letting us know. Not sure if related, but I just found
> out that this code won't compile for the !CONFIG_FWNODE_MDIO. Below
> one-liner fixes it:
> 
> --- a/include/linux/fwnode_mdio.h
> +++ b/include/linux/fwnode_mdio.h
> @@ -40,7 +40,7 @@ static inline int fwnode_mdiobus_register(struct mii_bus *bus,
>          * This way, we don't have to keep compat bits around in drivers.
>          */
> 
> -       return mdiobus_register(mdio);
> +       return mdiobus_register(bus);
>  }
>  #endif
> 
> I'm curious if this is the case. Tomorrow I'll resubmit with above, so
> I'd appreciate recheck.

I wonder if this message that I see with Arch Linux's config is related
and maybe explains the issue a little bit more:

$ curl -LSso .config https://raw.githubusercontent.com/archlinux/svntogit-packages/packages/linux/trunk/config

# do not require pahole
$ scripts/config -d DEBUG_INFO_BTF

$ make -skj"$(nproc)" INSTALL_MOD_PATH=rootfs olddefconfig all modules_install
...
depmod: ERROR: Cycle detected: acpi_mdio -> fwnode_mdio -> acpi_mdio
depmod: ERROR: Found 2 modules in dependency cycles!
...

Reverting all the patches in that series fixes the issue for me.

Cheers,
Nathan
