Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CAB33C29CB
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 21:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbhGITqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 15:46:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:33342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229459AbhGITqs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Jul 2021 15:46:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6EE3D613C7;
        Fri,  9 Jul 2021 19:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625859844;
        bh=RbWgNoXocKPuKxxsMy4RZrjytBCVpBJDJmOJqeSJ5Tw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nPjMvTB6iczmwdJ/qhsQQyPUxpxQtqH2rPMph4R8uq3hpTF4XCP3Eu0F43cQL5YFa
         RZP6OKU2aN4Ay2T6grrthd14Z3PNsCPTyMBbUHjMgPYtIjyzSI97Ft9kIutFbNNGZb
         TIPhDXvkMoUgwB9gLC4f54iSPnXmfhU2N8MLHaXRomnEymKkPpPok4wm+E7ko6kyD8
         S6ev7vGRIP8pFTmVQPIO8O54LhjMpums/g9hA9+ynD/baaiiPVumhxz8BGMgWty9S0
         ap21V8CIFN7s6tzfwP8Kg4sJhRBgOplpTMAq/1IhcMLHGh7WRVS8sSO2ccAjjFhNuf
         eWSsSTmELtsbQ==
Received: by pali.im (Postfix)
        id B1BAA77D; Fri,  9 Jul 2021 21:44:01 +0200 (CEST)
Date:   Fri, 9 Jul 2021 21:44:01 +0200
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
Message-ID: <20210709194401.7lto67x6oij23uc5@pali>
References: <20210709145831.6123-1-verdre@v0yd.nl>
 <20210709145831.6123-3-verdre@v0yd.nl>
 <20210709151800.7b2qqezlcicbgrqn@pali>
 <b1002254-97c6-d271-c385-4a5c9fe0c914@mailbox.org>
 <20210709161251.g4cvq3l4fnh4ve4r@pali>
 <d9158206-8ebe-c857-7533-47155a6464e1@gmail.com>
 <20210709173013.vkavxrtz767vrmej@pali>
 <89a60b06-b22d-2ea8-d164-b74e4c92c914@gmail.com>
 <20210709184443.fxcbc77te6ptypar@pali>
 <251bd696-9029-ec5a-8b0c-da78a0c8b2eb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <251bd696-9029-ec5a-8b0c-da78a0c8b2eb@gmail.com>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday 09 July 2021 21:27:51 Maximilian Luz wrote:
> On 7/9/21 8:44 PM, Pali Rohár wrote:
> 
> [...]
> 
> > > My (very) quick attempt ('echo 1 > /sys/bus/pci/.../reset) at
> > > reproducing this didn't work, so I think at very least a network
> > > connection needs to be active.
> > 
> > This is doing PCIe function level reset. Maybe you can get more luck
> > with PCIe Hot Reset. See following link how to trigger PCIe Hot Reset
> > from userspace: https://alexforencich.com/wiki/en/pcie/hot-reset-linux
> 
> Thanks for that link! That does indeed do something which breaks the
> adapter. Running the script produces
> 
>   [  178.388414] mwifiex_pcie 0000:01:00.0: PREP_CMD: card is removed
>   [  178.389128] mwifiex_pcie 0000:01:00.0: PREP_CMD: card is removed
>   [  178.461365] mwifiex_pcie 0000:01:00.0: performing cancel_work_sync()...
>   [  178.461373] mwifiex_pcie 0000:01:00.0: cancel_work_sync() done
>   [  178.984106] pci 0000:01:00.0: [11ab:2b38] type 00 class 0x020000
>   [  178.984161] pci 0000:01:00.0: reg 0x10: [mem 0x00000000-0x000fffff 64bit pref]
>   [  178.984193] pci 0000:01:00.0: reg 0x18: [mem 0x00000000-0x000fffff 64bit pref]
>   [  178.984430] pci 0000:01:00.0: supports D1 D2
>   [  178.984434] pci 0000:01:00.0: PME# supported from D0 D1 D3hot D3cold
>   [  178.984871] pcieport 0000:00:1c.0: ASPM: current common clock configuration is inconsistent, reconfiguring
>   [  179.297919] pci 0000:01:00.0: BAR 0: assigned [mem 0xd4400000-0xd44fffff 64bit pref]
>   [  179.297961] pci 0000:01:00.0: BAR 2: assigned [mem 0xd4500000-0xd45fffff 64bit pref]
>   [  179.298316] mwifiex_pcie 0000:01:00.0: enabling device (0000 -> 0002)
>   [  179.298752] mwifiex_pcie: PCI memory map Virt0: 00000000c4593df1 PCI memory map Virt2: 0000000039d67daf
>   [  179.300522] mwifiex_pcie 0000:01:00.0: WLAN read winner status failed!
>   [  179.300552] mwifiex_pcie 0000:01:00.0: info: _mwifiex_fw_dpc: unregister device
>   [  179.300622] mwifiex_pcie 0000:01:00.0: Read register failed
>   [  179.300912] mwifiex_pcie 0000:01:00.0: performing cancel_work_sync()...
>   [  179.300928] mwifiex_pcie 0000:01:00.0: cancel_work_sync() done
> 
> after which the card is unusable (there is no WiFi interface availabel
> any more). Reloading the driver module doesn't help and produces
> 
>   [  376.906833] mwifiex_pcie: PCI memory map Virt0: 0000000025149d28 PCI memory map Virt2: 00000000c4593df1
>   [  376.907278] mwifiex_pcie 0000:01:00.0: WLAN read winner status failed!
>   [  376.907281] mwifiex_pcie 0000:01:00.0: info: _mwifiex_fw_dpc: unregister device
>   [  376.907293] mwifiex_pcie 0000:01:00.0: Read register failed
>   [  376.907404] mwifiex_pcie 0000:01:00.0: performing cancel_work_sync()...
>   [  376.907406] mwifiex_pcie 0000:01:00.0: cancel_work_sync() done
> 
> again. Performing a function level reset produces
> 
>   [  402.489572] mwifiex_pcie 0000:01:00.0: mwifiex_pcie_reset_prepare: adapter structure is not valid
>   [  403.514219] mwifiex_pcie 0000:01:00.0: mwifiex_pcie_reset_done: adapter structure is not valid
> 
> and doesn't help either.

More Qualcomm/Atheros wifi cards are broken in a way that they stop
responding after PCIe Hot Reset and completely disappear from the PCIe
bus. It is possible that similar issue have also these Marvell cards?

As now we know that bride does not support hotplug it cannot inform
system when card disconnect from the bus. The one possible way how to
detect if PCIe card is available at specific address is trying to read
its device and vendor id. Kernel caches device/vendor id, so from
userspace is needed to call lspci with -b argument (to ignore kernel's
reported cached value). Could you provide output of following command
after you do PCIe Hot Reset?

    lspci -s 01:00.0 -b -vv

(and compare with output which you have already provided if there are
any differences)

If PCIe Hot Reset is breaking the card then the only option how to
"reset" card into working state again is PCIe Warm Reset. Unfortunately
there is no common mechanism how to do it from system. PCIe Warm Reset
is done by asserting PERST# signal on card itself, in mPCIe form factor
it is pin 22. In most cases pin 22 is connected to some GPIO so via GPIO
subsystem it could be controlled.

> Running the same command on a kernel with (among other) this patch
> unfortunately also breaks the adapter in the same way. As far as I can
> tell though, it doesn't run through the reset code added by this patch
> (as indicated by the log message when performing FLR), which I assume
> in a non-forced scenario, e.g. firmware issues (which IIRC is why this
> patch exists), it would?

Err... I have caught this part. Is proposed patch able to recover also
from state which happens after PCIe Hot Reset?

> > > Unfortunately I can't test that with a
> > > network connection (and without compiling a custom kernel for which I
> > > don't have the time right now) because there's currently another bug
> > > deadlocking on device removal if there's an active connection during
> > > removal (which also seems to trigger on reset). That one ill be fixed
> > > by
> > > 
> > >    https://lore.kernel.org/linux-wireless/20210515024227.2159311-1-briannorris@chromium.org/
> > > 
> > > Jonas might know more.
> 
> [...]
