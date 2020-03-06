Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5752A17BC56
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 13:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbgCFMIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 07:08:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:40986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726025AbgCFMIU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Mar 2020 07:08:20 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 783B92072D;
        Fri,  6 Mar 2020 12:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583496499;
        bh=6oBvQeFqOzoUFzfuL3lnRBZg5MmJ6A0u4hpanTi93PU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WM+73UYQ3/em8c5e3U5mEA3RyCKq4LoEGQj8YUPfLBLt1vY0MFRvlvTeTByhbI2hg
         I5xIxROC0p4mYi8FOgjpNQG7ByVDfs8WQJydDUVrCBUsjG42UwfXwrXPB88HAmD3JF
         vEZcOFEfOQ2tI+CSgsNBmBXplaw4Ca/7Y23ZM/8U=
Date:   Fri, 6 Mar 2020 14:08:14 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     "Machulsky, Zorik" <zorik@amazon.com>
Cc:     "Kiyanovski, Arthur" <akiyano@amazon.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Agroskin, Shay" <shayagr@amazon.com>,
        "Jubran, Samih" <sameehj@amazon.com>
Subject: Re: [RESEND PATCH V1 net-next] net: ena: fix broken interface
 between ENA driver and FW
Message-ID: <20200306120814.GP184088@unreal>
References: <1582711415-4442-1-git-send-email-akiyano@amazon.com>
 <20200226.204809.102099518712120120.davem@davemloft.net>
 <20200301135007.GS12414@unreal>
 <37c7130a38ab46cda8a0f7a3e07e7fa3@EX13D22EUA004.ant.amazon.com>
 <20200305191633.GI184088@unreal>
 <F07A24C7-930D-4F59-92BD-405B74F01707@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <F07A24C7-930D-4F59-92BD-405B74F01707@amazon.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 05, 2020 at 08:37:43PM +0000, Machulsky, Zorik wrote:
>
>
> ﻿On 3/5/20, 11:17 AM, "Leon Romanovsky" <leon@kernel.org> wrote:
>
>
>     On Thu, Mar 05, 2020 at 02:28:33PM +0000, Kiyanovski, Arthur wrote:
>     > > -----Original Message-----
>     > > From: Leon Romanovsky <leon@kernel.org>
>     > > Sent: Sunday, March 1, 2020 3:50 PM
>     > > To: David Miller <davem@davemloft.net>
>     > > Cc: Kiyanovski, Arthur <akiyano@amazon.com>; netdev@vger.kernel.org;
>     > > Woodhouse, David <dwmw@amazon.co.uk>; Machulsky, Zorik
>     > > <zorik@amazon.com>; Matushevsky, Alexander <matua@amazon.com>;
>     > > Bshara, Saeed <saeedb@amazon.com>; Wilson, Matt <msw@amazon.com>;
>     > > Liguori, Anthony <aliguori@amazon.com>; Bshara, Nafea
>     > > <nafea@amazon.com>; Tzalik, Guy <gtzalik@amazon.com>; Belgazal, Netanel
>     > > <netanel@amazon.com>; Saidi, Ali <alisaidi@amazon.com>; Herrenschmidt,
>     > > Benjamin <benh@amazon.com>; Dagan, Noam <ndagan@amazon.com>;
>     > > Agroskin, Shay <shayagr@amazon.com>; Jubran, Samih
>     > > <sameehj@amazon.com>
>     > > Subject: Re: [RESEND PATCH V1 net-next] net: ena: fix broken interface between
>     > > ENA driver and FW
>     > >
>     > > On Wed, Feb 26, 2020 at 08:48:09PM -0800, David Miller wrote:
>     > > > From: <akiyano@amazon.com>
>     > > > Date: Wed, 26 Feb 2020 12:03:35 +0200
>     > > >
>     > > > > From: Arthur Kiyanovski <akiyano@amazon.com>
>     > > > >
>     > > > > In this commit we revert the part of commit 1a63443afd70
>     > > > > ("net/amazon: Ensure that driver version is aligned to the linux
>     > > > > kernel"), which breaks the interface between the ENA driver and FW.
>     > > > >
>     > > > > We also replace the use of DRIVER_VERSION with DRIVER_GENERATION
>     > > > > when we bring back the deleted constants that are used in interface
>     > > > > with ENA device FW.
>     > > > >
>     > > > > This commit does not change the driver version reported to the user
>     > > > > via ethtool, which remains the kernel version.
>     > > > >
>     > > > > Fixes: 1a63443afd70 ("net/amazon: Ensure that driver version is
>     > > > > aligned to the linux kernel")
>     > > > > Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
>     > > >
>     > > > Applied.
>     > >
>     > > Dave,
>     > >
>     > > I see that I'm late here and my email sounds like old man grumbling, but I asked
>     > > from those guys to update their commit with request to put the following line:
>     > > "/* DO NOT CHANGE DRV_MODULE_GEN_* values in in-tree code */"
>     > > https://lore.kernel.org/netdev/20200224162649.GA4526@unreal/
>     > >
>     > > I also asked how those versions are transferred to FW and used there, but was
>     > > ignored.
>     > > https://lore.kernel.org/netdev/20200224094116.GD422704@unreal/
>     > >
>     > > BTW, It is also unclear why I wasn't CCed in this patch.
>     > >
>     > > Thanks
>     >
>     > Leon,
>     >  Sorry for not responding earlier to your inquiries, they are exactly touching the
>     >  points that we would like to discuss.
>     >  Up until now, we in AWS, have been monitoring the drivers in the datacenter using the
>     >  driver version, and actively suggesting driver updates to our customers
>     >  whenever a critical bug was fixed, or a new important feature was added.
>     >  Removing the driver version and not allowing to maintain our own internal
>     >  version negatively impacts our effort to give our customers the best possible cloud
>     >  experience. We therefore prefer to maintain using our internal driver version.
>     >
>     >  Are there any other recommended ways to achieve our goal without a driver
>     >  version?
>
>     Of course, drivers are supposed to behave like any other user visible API.
>     They need to ensure backward compatibility, so new code will work with
>     old HW/FW. This is normally done by capability masks, see how it is done
>     in Mellanox drivers and I think in Intel too.
>
>     So your update policy based on driver version string is nonsense and
>     broken by design.
>
>     Original thread with Linus is here [1].
>
>     [1] https://lore.kernel.org/ksummit-discuss/CA+55aFx9A=5cc0QZ7CySC4F2K7eYaEfzkdYEc9JaNgCcV25=rg@mail.gmail.com/
>
>     Thanks
>
> We do support features capability mask as well as versioning per feature.
> However, whenever there are known issues in a certain version of the  driver
> that can be worked around by the device, we need the device to be aware of the
> driver version. Another purpose is operational - knowing driver version helps us
> reproduce customer issues and debug them, as well as suggest our customers
> to upgrade their drivers, as Arthur mentioned above.
> Thanks

Unfortunately, the versioning doesn't work outside closed source world.
This driver version doesn't say anything when customer uses stable@
kernel, distro or its custom variant. I asked more than once to explain
how this versioning works, but got only marketing answers that not
backed-up by any technical details.

The driver version works in closed source products, but here it has very
distant correlation between real driver in use and reported.

So please, stop those driver version bumps in the upstream kernel.

If you disagree with me, feel free to revive the thread in the link
posted above and we will be glad to hear your technical claims there.

Till then, we have unified kernel policy, no driver versions.

Thanks

>
>
>     >
>     >  Thanks!
>     >
>
>
