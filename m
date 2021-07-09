Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E02D53C2B81
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 00:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231325AbhGIW5V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 18:57:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:55388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229542AbhGIW5U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Jul 2021 18:57:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BA59613BF;
        Fri,  9 Jul 2021 22:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625871276;
        bh=x0FRejFIgHX/Bw4TECN4z64GQhcXeWno1qkqNAwLb9w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q4I353nNmA0X0JD+fTI12W8VBiL7kPT1K9IFK+bfBNIZH+jDTx2++DKHrR4xF3BhK
         amk5u1srp3vX8EqMnopHmAC8XjFiL3I/18bs3QlpOGe87rLRy0Nd+MKNVP+OMRZsfi
         Jb9w+PrK28jPtQqahNddD/tUg75V/xGPfET25cN42fLnQI4nasQOw6l+ZxosuAlH9L
         d2lqQowrnqqwpNbtORMF/oUBRWf1igxi3Lk8BGAlMrwyrb0TvxCOIz68w/lxXdMSax
         Uw0ck13THuA7TvXraCTpmHEuKdfd3Hb3rqPdfDmKQLOtizhxLsl47IdZELkedpxk3Y
         rZxKDwdSC5aBw==
Received: by pali.im (Postfix)
        id 7FD9A77D; Sat, 10 Jul 2021 00:54:33 +0200 (CEST)
Date:   Sat, 10 Jul 2021 00:54:33 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Maximilian Luz <luzmaximilian@gmail.com>
Cc:     Jonas =?utf-8?Q?Dre=C3=9Fler?= <verdre@v0yd.nl>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v2 2/2] mwifiex: pcie: add reset_d3cold quirk for Surface
 gen4+ devices
Message-ID: <20210709225433.axpzdsfbyvieahvr@pali>
References: <20210709161251.g4cvq3l4fnh4ve4r@pali>
 <d9158206-8ebe-c857-7533-47155a6464e1@gmail.com>
 <20210709173013.vkavxrtz767vrmej@pali>
 <89a60b06-b22d-2ea8-d164-b74e4c92c914@gmail.com>
 <20210709184443.fxcbc77te6ptypar@pali>
 <251bd696-9029-ec5a-8b0c-da78a0c8b2eb@gmail.com>
 <20210709194401.7lto67x6oij23uc5@pali>
 <4e35bfc1-c38d-7198-dedf-a1f2ec28c788@gmail.com>
 <20210709212505.mmqxdplmxbemqzlo@pali>
 <bfbb3b4d-07f7-1b97-54f0-21eba4766798@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bfbb3b4d-07f7-1b97-54f0-21eba4766798@gmail.com>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Saturday 10 July 2021 00:25:36 Maximilian Luz wrote:
> On 7/9/21 11:25 PM, Pali Rohár wrote:
> 
> [...]
> 
> > PCIe Function Level Reset should reset only one PCIe part of device. And
> > seems that this type of reset does not work properly in some situations.
> > 
> > Note that PCIe Function Level Reset is independent of running firmware.
> > It is implement in hardware and (should) work also at early stage when
> > firmware is not loaded yet.
> > 
> > I'm starting to think more and more if quirk in this patch really needs
> > to be behind DMI check and if rather it should not be called on other
> > platforms too?
> 
> Maybe? I'm not sure how well this behaves on other devices and if there
> even are any devices outside of the MS Surface line that really require
> or benefit from something like this. To me it seems safer to put it
> behind quirks, at least until we know more.

This is a good argument for DMI based quirk.

But at the end, PCI people should look at this patch and say what do
they thing about it, if it is better to enable it only for specific set
of machines (Surface) or it is better to enable it for every 88W8xxx
wifi or for none.

> Also not sure if this is just my bias, but it feels like the Surface
> line always had more problems with that driver (and firmware) than
> others.

Ehm, really? I see reports also from non-Surface users about bad quality
of these 88W[89]xxx cards and repeating firmware issues. I have bad
personal experience with 88W8997 SDIO firmware and lot of times I get
advice about ex-Marvell/NXP wifi cards "do not touch and run away
quickly".

I think that more people if they get mPCIe/M.2 wifi card in laptop which
does not work, they just replace it with some working one. And not
spending infinite time in trying to fix it... So this may explain why
there are more Surface users with these issues...

> I'm honestly a bit surprised that MS stuck with them for this
> long (they decided to go with Intel for 7th gen devices). AFAICT they
> initially chose Marvell due to connected standby support, so maybe that
> causes issue for us and others simply aren't using that feature? Just
> guessing though.

In my opinion that "Connected Standby" is just MS marketing term.

88W[89]xxx chips using full-mac firmware and drivers [*]. Full-mac lot
of times causing more issues than soft-mac solution. Moreover this
Marvell firmware implements also other "application" layers in firmware
which OS drivers can use, e.g. there is fully working "wpa-supplicant"
replacement and also AP part. Maybe windows drivers are using it and it
cause less problems? Duno. mwifiex uses only "low level" commands and
WPA state machine is implemented in userspace wpa-supplicant daemon.


[*] - Small note: There are also soft-mac firmwares and drivers but
apparently Marvell has never finished linux driver and firmware was not
released to public...

And there is also Laird Connectivity which offers their own proprietary
linux kernel drivers with their own firmware for these 88W[89]xxx chips.
Last time I checked it they released some parts of driver on github.
Maybe somebody could contact Laird or check if their driver can be
replaced by mwifiex? Or just replacing ex-Marvell/NXP firmware by their?
But I'm not sure if they have something for 88W8897.
