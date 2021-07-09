Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A221A3C2797
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 18:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbhGIQea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 12:34:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:58588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229441AbhGIQe2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Jul 2021 12:34:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C98CC6139A;
        Fri,  9 Jul 2021 16:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625848305;
        bh=PEw0NEaUyBjfW7GXEDHxHYCvnLY7I1NpyX1B2xWF90M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U1DYYcXCOFbm42pmjM3ROP8WlTfqPN3f97C/qSoFOlKAw3b4Od2DOzJrYlg4c/U9t
         d41LE5LBhjbAfxKyTh00SH5Hzm6Sf7XDDsNsL6Zq4O/1QITASB/KGLChrwJeO4itfY
         uex6w1Tb0n/wG7/X9oLNI7LjCLZSmmvb7MJ9uIkDsMntmcXrXBmPMxqVBr8qx89wEy
         Nmrvlhu1EuOTILdddo8eWVqaYdp5PWiWZIfPYr0WLiiVh9KEusHyWL7QdM7GOY8yUg
         KM+4+ihGaoKJfKAweCKJwuV/Bl8bMsRXnzw/OS5j5C3oV44WNFi1zQvkJI5KgXpTIp
         3dwLaHqUz0F1g==
Received: by pali.im (Postfix)
        id 3CF6F77D; Fri,  9 Jul 2021 18:31:42 +0200 (CEST)
Date:   Fri, 9 Jul 2021 18:31:42 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Jonas =?utf-8?Q?Dre=C3=9Fler?= <verdre@v0yd.nl>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v2 2/2] mwifiex: pcie: add reset_d3cold quirk for Surface
 gen4+ devices
Message-ID: <20210709163142.e3jilbxjjlpzs7qf@pali>
References: <20210709145831.6123-1-verdre@v0yd.nl>
 <20210709145831.6123-3-verdre@v0yd.nl>
 <20210709151800.7b2qqezlcicbgrqn@pali>
 <CAHp75Vf71NfbzN_k2F7AXA944O9QZus0Ja7N_seer1NJzZHzeA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHp75Vf71NfbzN_k2F7AXA944O9QZus0Ja7N_seer1NJzZHzeA@mail.gmail.com>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday 09 July 2021 19:01:44 Andy Shevchenko wrote:
> On Fri, Jul 9, 2021 at 6:18 PM Pali Rohár <pali@kernel.org> wrote:
> > On Friday 09 July 2021 16:58:31 Jonas Dreßler wrote:
> 
> 
> > Hello! Now I'm thinking loudly about this patch. Why this kind of reset
> > is needed only for Surface devices? AFAIK these 88W8897 chips are same
> > in all cards. Chip itself implements PCIe interface (and also SDIO) so
> > for me looks very strange if this 88W8897 PCIe device needs DMI specific
> > quirks. I cannot believe that Microsoft got some special version of
> > these chips from Marvell which are different than version uses on cards
> > in mPCIe form factor.
> >
> > And now when I'm reading comment below about PCIe bridge to which is
> > this 88W8897 PCIe chip connected, is not this rather an issue in that
> > PCIe bridge (instead of mwifiex/88W8897) or in ACPI firmware which
> > controls this bridge?
> >
> > Or are having other people same issues on mPCIe form factor wifi cards
> > with 88W8897 chips and then this quirk should not DMI dependent?
> >
> > Note that I'm seeing issues with reset and other things also on chip
> > 88W8997 when is connected to system via SDIO. These chips have both PCIe
> > and SDIO buses, it just depends which pins are used.
> 
> I'm replying loudly :-)
> 
> You know that depending on the interface the firmware even for the
> same chip may be way different. And if you have had any experience
> working in product companies you should know well that bug in product
> X is not gonna be fixed if it was not reported, but gets fixed on
> product Y due to that. Besides that, how do you know that MS has not
> been given the special edition of the FW?

Yes! But I know something about these chips/cards (I have also one
development kit) and it is quite different. It is possible that
Microsoft may have its special version, because I know that e.g. Google
got "fixed version" for some 88W8xxx chips (it is/was available on
internet). But firmware is loading by mwifiex driver and we
(linux-firmware) have just one version of firmware for these cards.
These 88W8xxx cards lost state and running firmware after reset/power so
after linux is booted, it loads "linux-firmware" version into 88W8897
card and then card not run "possibly MS special edition FW".

What can be possible is that we are dealing with ACPI firmware (which is
same for both Windows and Linux OS) and then it is related to PCIe
bridge where are some PCIe parts implemented...

> As icing on the cake, the Marvell has been bought and I believe they
> abandoned their products quite a while ago. You may read kernel
> bugzilla for the details (last Marvell developer who answered to the
> reports seems has no clue about the driver).

Marvell 88W[89]xxx wifi cards were sold to NXP together with developers.
Old @marvell addresses do not work so it is required to find new @nxp
addresses for developers.

There are recent firmware upgrades from NXP for linux-firmware, see:
https://lore.kernel.org/linux-firmware/DB7PR04MB453855B0D6C41923BCB0922EFC1C9@DB7PR04MB4538.eurprd04.prod.outlook.com/
(just only SDIO firmware for 88W8897, not PCIe)

But I know that response from NXP about these cards is slow... And more
people are complaining about firmware/driver issues for these cards.

> All that said, I believe that we have to follow whatever fixes we
> would have and be thankful to contributors and testers.

I agree. If this is really fixing these issues and we do not have better
fix yet, go ahead with it (if PCIe/WiFi maintainers are fine with it).

Once we have better fix, we can replace it.

Currently I'm just trying to understand this issue more deeply (e.g. how
it can relate with similar issue which I see on SDIO and if I cannot fix
also SDIO in better way) but seems that nobody knows more than "this
hack/quirk somehow works for PCIe".

> For the record, I've been suffering from the Linux driver of this
> hardware for a while. And I'm fully in support of any quirks that will
> help UX.
> 
> -- 
> With Best Regards,
> Andy Shevchenko
