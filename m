Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74F0717AED4
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 20:16:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725989AbgCETQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 14:16:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:52842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725938AbgCETQl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 14:16:41 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 909542072A;
        Thu,  5 Mar 2020 19:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583435799;
        bh=4tSF+Cqg5D6qeCUwwnzRF+GI/nHzErsxQYFzeScgWtM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NexCopjVac1RoKg5nbBuqSmkVnT8aO4Vh6SHYL5wH9R7OHMvHPDvVzVQKvpI572S9
         QFV110dx3nYVKExS/gcJrIvcKc6gew5dk6299vP6j0eg0w/g+u9qmRF+6Q/XtCBJP5
         qHmTcKZZ+2c2uFFQPcnAU8NVn3Hq/WkV18qpBIz0=
Date:   Thu, 5 Mar 2020 21:16:33 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     "Kiyanovski, Arthur" <akiyano@amazon.com>
Cc:     David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "Machulsky, Zorik" <zorik@amazon.com>,
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
Message-ID: <20200305191633.GI184088@unreal>
References: <1582711415-4442-1-git-send-email-akiyano@amazon.com>
 <20200226.204809.102099518712120120.davem@davemloft.net>
 <20200301135007.GS12414@unreal>
 <37c7130a38ab46cda8a0f7a3e07e7fa3@EX13D22EUA004.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37c7130a38ab46cda8a0f7a3e07e7fa3@EX13D22EUA004.ant.amazon.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 05, 2020 at 02:28:33PM +0000, Kiyanovski, Arthur wrote:
> > -----Original Message-----
> > From: Leon Romanovsky <leon@kernel.org>
> > Sent: Sunday, March 1, 2020 3:50 PM
> > To: David Miller <davem@davemloft.net>
> > Cc: Kiyanovski, Arthur <akiyano@amazon.com>; netdev@vger.kernel.org;
> > Woodhouse, David <dwmw@amazon.co.uk>; Machulsky, Zorik
> > <zorik@amazon.com>; Matushevsky, Alexander <matua@amazon.com>;
> > Bshara, Saeed <saeedb@amazon.com>; Wilson, Matt <msw@amazon.com>;
> > Liguori, Anthony <aliguori@amazon.com>; Bshara, Nafea
> > <nafea@amazon.com>; Tzalik, Guy <gtzalik@amazon.com>; Belgazal, Netanel
> > <netanel@amazon.com>; Saidi, Ali <alisaidi@amazon.com>; Herrenschmidt,
> > Benjamin <benh@amazon.com>; Dagan, Noam <ndagan@amazon.com>;
> > Agroskin, Shay <shayagr@amazon.com>; Jubran, Samih
> > <sameehj@amazon.com>
> > Subject: Re: [RESEND PATCH V1 net-next] net: ena: fix broken interface between
> > ENA driver and FW
> >
> > On Wed, Feb 26, 2020 at 08:48:09PM -0800, David Miller wrote:
> > > From: <akiyano@amazon.com>
> > > Date: Wed, 26 Feb 2020 12:03:35 +0200
> > >
> > > > From: Arthur Kiyanovski <akiyano@amazon.com>
> > > >
> > > > In this commit we revert the part of commit 1a63443afd70
> > > > ("net/amazon: Ensure that driver version is aligned to the linux
> > > > kernel"), which breaks the interface between the ENA driver and FW.
> > > >
> > > > We also replace the use of DRIVER_VERSION with DRIVER_GENERATION
> > > > when we bring back the deleted constants that are used in interface
> > > > with ENA device FW.
> > > >
> > > > This commit does not change the driver version reported to the user
> > > > via ethtool, which remains the kernel version.
> > > >
> > > > Fixes: 1a63443afd70 ("net/amazon: Ensure that driver version is
> > > > aligned to the linux kernel")
> > > > Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
> > >
> > > Applied.
> >
> > Dave,
> >
> > I see that I'm late here and my email sounds like old man grumbling, but I asked
> > from those guys to update their commit with request to put the following line:
> > "/* DO NOT CHANGE DRV_MODULE_GEN_* values in in-tree code */"
> > https://lore.kernel.org/netdev/20200224162649.GA4526@unreal/
> >
> > I also asked how those versions are transferred to FW and used there, but was
> > ignored.
> > https://lore.kernel.org/netdev/20200224094116.GD422704@unreal/
> >
> > BTW, It is also unclear why I wasn't CCed in this patch.
> >
> > Thanks
>
> Leon,
>  Sorry for not responding earlier to your inquiries, they are exactly touching the
>  points that we would like to discuss.
>  Up until now, we in AWS, have been monitoring the drivers in the datacenter using the
>  driver version, and actively suggesting driver updates to our customers
>  whenever a critical bug was fixed, or a new important feature was added.
>  Removing the driver version and not allowing to maintain our own internal
>  version negatively impacts our effort to give our customers the best possible cloud
>  experience. We therefore prefer to maintain using our internal driver version.
>
>  Are there any other recommended ways to achieve our goal without a driver
>  version?

Of course, drivers are supposed to behave like any other user visible API.
They need to ensure backward compatibility, so new code will work with
old HW/FW. This is normally done by capability masks, see how it is done
in Mellanox drivers and I think in Intel too.

So your update policy based on driver version string is nonsense and
broken by design.

Original thread with Linus is here [1].

[1] https://lore.kernel.org/ksummit-discuss/CA+55aFx9A=5cc0QZ7CySC4F2K7eYaEfzkdYEc9JaNgCcV25=rg@mail.gmail.com/

Thanks

>
>  Thanks!
>
