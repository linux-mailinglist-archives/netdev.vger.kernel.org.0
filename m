Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34A723C2AC7
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 23:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbhGIV1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 17:27:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:44552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229506AbhGIV1w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Jul 2021 17:27:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F8FA613C2;
        Fri,  9 Jul 2021 21:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625865908;
        bh=ogtdblbux76L36vhKQ7PkizGbPi2aw+AT/O2PEhM1y4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OAmZy6eKzQ9uicGPb4ZAkRRItR+HAq0aG3zsqBidLEbY9MpRUv+CwW9BAdwq6+Op4
         heYqYcLOLsUFIFxslg1QOOqcHfoL8B3zQSr7b2bxH73dHameBIuo5ySB+qk64G2FL5
         iS/1ziOwcb5WMSUsp5lxTYqHExHqW4ZqgrlCaOKApb9Yb/SGO/HRfjk+ixmmRZ6hUu
         78Re5WC5GQdBgM3TOap1xtuaE6rOc7S0UOStTOMaIeXWLOMr6Oza+t0nKGJTQpWEcL
         ZHXgg3ITASIABAgWMfZF7n7BmScl4Pg9qR1pk4sLpVSJgWTlMIr4pdyuwSrM4PtK27
         yLx/aF1/KXgAA==
Received: by pali.im (Postfix)
        id 6252C77D; Fri,  9 Jul 2021 23:25:05 +0200 (CEST)
Date:   Fri, 9 Jul 2021 23:25:05 +0200
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
Message-ID: <20210709212505.mmqxdplmxbemqzlo@pali>
References: <20210709151800.7b2qqezlcicbgrqn@pali>
 <b1002254-97c6-d271-c385-4a5c9fe0c914@mailbox.org>
 <20210709161251.g4cvq3l4fnh4ve4r@pali>
 <d9158206-8ebe-c857-7533-47155a6464e1@gmail.com>
 <20210709173013.vkavxrtz767vrmej@pali>
 <89a60b06-b22d-2ea8-d164-b74e4c92c914@gmail.com>
 <20210709184443.fxcbc77te6ptypar@pali>
 <251bd696-9029-ec5a-8b0c-da78a0c8b2eb@gmail.com>
 <20210709194401.7lto67x6oij23uc5@pali>
 <4e35bfc1-c38d-7198-dedf-a1f2ec28c788@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e35bfc1-c38d-7198-dedf-a1f2ec28c788@gmail.com>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday 09 July 2021 22:54:09 Maximilian Luz wrote:
> On 7/9/21 9:44 PM, Pali Rohár wrote:
> > On Friday 09 July 2021 21:27:51 Maximilian Luz wrote:
> > > On 7/9/21 8:44 PM, Pali Rohár wrote:
> > > 
> > > [...]
> > > 
> > > > > My (very) quick attempt ('echo 1 > /sys/bus/pci/.../reset) at
> > > > > reproducing this didn't work, so I think at very least a network
> > > > > connection needs to be active.
> > > > 
> > > > This is doing PCIe function level reset. Maybe you can get more luck
> > > > with PCIe Hot Reset. See following link how to trigger PCIe Hot Reset
> > > > from userspace: https://alexforencich.com/wiki/en/pcie/hot-reset-linux
> > > 
> > > Thanks for that link! That does indeed do something which breaks the
> > > adapter. Running the script produces
> > > 
> > >    [  178.388414] mwifiex_pcie 0000:01:00.0: PREP_CMD: card is removed
> > >    [  178.389128] mwifiex_pcie 0000:01:00.0: PREP_CMD: card is removed
> > >    [  178.461365] mwifiex_pcie 0000:01:00.0: performing cancel_work_sync()...
> > >    [  178.461373] mwifiex_pcie 0000:01:00.0: cancel_work_sync() done
> > >    [  178.984106] pci 0000:01:00.0: [11ab:2b38] type 00 class 0x020000
> > >    [  178.984161] pci 0000:01:00.0: reg 0x10: [mem 0x00000000-0x000fffff 64bit pref]
> > >    [  178.984193] pci 0000:01:00.0: reg 0x18: [mem 0x00000000-0x000fffff 64bit pref]
> > >    [  178.984430] pci 0000:01:00.0: supports D1 D2
> > >    [  178.984434] pci 0000:01:00.0: PME# supported from D0 D1 D3hot D3cold
> > >    [  178.984871] pcieport 0000:00:1c.0: ASPM: current common clock configuration is inconsistent, reconfiguring
> > >    [  179.297919] pci 0000:01:00.0: BAR 0: assigned [mem 0xd4400000-0xd44fffff 64bit pref]
> > >    [  179.297961] pci 0000:01:00.0: BAR 2: assigned [mem 0xd4500000-0xd45fffff 64bit pref]
> > >    [  179.298316] mwifiex_pcie 0000:01:00.0: enabling device (0000 -> 0002)
> > >    [  179.298752] mwifiex_pcie: PCI memory map Virt0: 00000000c4593df1 PCI memory map Virt2: 0000000039d67daf
> > >    [  179.300522] mwifiex_pcie 0000:01:00.0: WLAN read winner status failed!
> > >    [  179.300552] mwifiex_pcie 0000:01:00.0: info: _mwifiex_fw_dpc: unregister device
> > >    [  179.300622] mwifiex_pcie 0000:01:00.0: Read register failed
> > >    [  179.300912] mwifiex_pcie 0000:01:00.0: performing cancel_work_sync()...
> > >    [  179.300928] mwifiex_pcie 0000:01:00.0: cancel_work_sync() done
> > > 
> > > after which the card is unusable (there is no WiFi interface availabel
> > > any more). Reloading the driver module doesn't help and produces
> > > 
> > >    [  376.906833] mwifiex_pcie: PCI memory map Virt0: 0000000025149d28 PCI memory map Virt2: 00000000c4593df1
> > >    [  376.907278] mwifiex_pcie 0000:01:00.0: WLAN read winner status failed!
> > >    [  376.907281] mwifiex_pcie 0000:01:00.0: info: _mwifiex_fw_dpc: unregister device
> > >    [  376.907293] mwifiex_pcie 0000:01:00.0: Read register failed
> > >    [  376.907404] mwifiex_pcie 0000:01:00.0: performing cancel_work_sync()...
> > >    [  376.907406] mwifiex_pcie 0000:01:00.0: cancel_work_sync() done
> > > 
> > > again. Performing a function level reset produces
> > > 
> > >    [  402.489572] mwifiex_pcie 0000:01:00.0: mwifiex_pcie_reset_prepare: adapter structure is not valid
> > >    [  403.514219] mwifiex_pcie 0000:01:00.0: mwifiex_pcie_reset_done: adapter structure is not valid
> > > 
> > > and doesn't help either.
> > 
> > More Qualcomm/Atheros wifi cards are broken in a way that they stop
> > responding after PCIe Hot Reset and completely disappear from the PCIe
> > bus. It is possible that similar issue have also these Marvell cards?
> > 
> > As now we know that bride does not support hotplug it cannot inform
> > system when card disconnect from the bus. The one possible way how to
> > detect if PCIe card is available at specific address is trying to read
> > its device and vendor id. Kernel caches device/vendor id, so from
> > userspace is needed to call lspci with -b argument (to ignore kernel's
> > reported cached value). Could you provide output of following command
> > after you do PCIe Hot Reset?
> > 
> >      lspci -s 01:00.0 -b -vv
> > 
> > (and compare with output which you have already provided if there are
> > any differences)
> 
> There do seem to be some differences, specifically regarding memory.
> See https://paste.ubuntu.com/p/Rz2CDjwkCv/ for the full output.

Output is OK, card is alive and available on bus. So at least we are not
dealing with the similar issue like are observed in Qualcomm/Atheros.
Missing memory just means that driver has not enabled memory access
(because it did not successfully initialized).

Anyway, card is reporting error via AER:

	Capabilities: [100 v2] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- AdvNonFatalErr+
		AERCap:	First Error Pointer: 14, ECRCGenCap+ ECRCGenEn- ECRCChkCap+ ECRCChkEn-
			MultHdrRecCap- MultHdrRecEn- TLPPfxPres- HdrLogCap-
		HeaderLog: 40000001 0000000f d4500c58 00000000

There is (UESta) marked that Unsupported Request happened and in
HeaderLog is information about error. Unfortunately I'm not skilled to
decode it, so maybe other PCI developers could say if there is something
important in HeaderLog or not.

> > If PCIe Hot Reset is breaking the card then the only option how to
> > "reset" card into working state again is PCIe Warm Reset. Unfortunately
> > there is no common mechanism how to do it from system. PCIe Warm Reset
> > is done by asserting PERST# signal on card itself, in mPCIe form factor
> > it is pin 22. In most cases pin 22 is connected to some GPIO so via GPIO
> > subsystem it could be controlled.
> > 
> > > Running the same command on a kernel with (among other) this patch
> > > unfortunately also breaks the adapter in the same way. As far as I can
> > > tell though, it doesn't run through the reset code added by this patch
> > > (as indicated by the log message when performing FLR), which I assume
> > > in a non-forced scenario, e.g. firmware issues (which IIRC is why this
> > > patch exists), it would?
> > 
> > Err... I have caught this part. Is proposed patch able to recover also
> > from state which happens after PCIe Hot Reset?
> 
> I'm not sure at this point if the power-cycle through D3cold would fix
> this (I think it might, but have no evidence for that). This patch alone
> isn't able to recover the device, as, when triggering the hot-reset via
> that script, the code never seems to run mwifiex_pcie_reset_d3cold_quirk().
> 
> If I remember correctly, the main issue was that the firmware state
> doesn't get reset completely. This can be somewhat observed when doing
> 'echo 1 > /sys/bus/pci/devices/.../reset' via the difference in log
> messages:
> 
> For an unpatched kernel:
> 
>   [   64.159509] mwifiex_pcie 0000:01:00.0: info: shutdown mwifiex...
>   [   64.159546] mwifiex_pcie 0000:01:00.0: PREP_CMD: card is removed
>   [   64.159922] mwifiex_pcie 0000:01:00.0: PREP_CMD: card is removed
>   [   65.240272] mwifiex_pcie 0000:01:00.0: WLAN FW already running! Skip FW dnld
>   [   65.240285] mwifiex_pcie 0000:01:00.0: WLAN FW is active
>   [   65.327359] mwifiex_pcie 0000:01:00.0: info: MWIFIEX VERSION: mwifiex 1.0 (15.68.19.p21)
>   [   65.327370] mwifiex_pcie 0000:01:00.0: driver_version = mwifiex 1.0 (15.68.19.p21)
> 
> For a patched kernel:
> 
>   [   41.966094] mwifiex_pcie 0000:01:00.0: info: shutdown mwifiex...
>   [   41.966451] mwifiex_pcie 0000:01:00.0: PREP_CMD: card is removed
>   [   41.967227] mwifiex_pcie 0000:01:00.0: PREP_CMD: card is removed
>   [   42.063543] mwifiex_pcie 0000:01:00.0: Using reset_d3cold quirk to perform FW reset
>   [   42.063558] mwifiex_pcie 0000:01:00.0: putting into D3cold...
>   [   42.081010] usb 1-6: USB disconnect, device number 9
>   [   42.339922] pcieport 0000:00:1c.0: putting into D3cold...
>   [   42.425766] pcieport 0000:00:1c.0: putting into D0...
>   [   42.695987] mwifiex_pcie 0000:01:00.0: putting into D0...
>   [   42.956673] mwifiex_pcie 0000:01:00.0: enabling device (0000 -> 0002)
>   [   45.012736] mwifiex_pcie 0000:01:00.0: info: FW download over, size 723540 bytes
>   [   45.740882] usb 1-6: new high-speed USB device number 10 using xhci_hcd
>   [   45.881294] usb 1-6: New USB device found, idVendor=1286, idProduct=204c, bcdDevice=32.01
>   [   45.881308] usb 1-6: New USB device strings: Mfr=1, Product=2, SerialNumber=3
>   [   45.881313] usb 1-6: Product: Bluetooth and Wireless LAN Composite Device
>   [   45.881318] usb 1-6: Manufacturer: Marvell
>   [   45.881322] usb 1-6: SerialNumber: 0000000000000000
>   [   45.884882] Bluetooth: hci0: unexpected event for opcode 0x0000
>   [   45.885128] Bluetooth: hci0: unexpected event for opcode 0x0000
>   [   45.966218] mwifiex_pcie 0000:01:00.0: WLAN FW is active
>   [   46.157474] mwifiex_pcie 0000:01:00.0: info: MWIFIEX VERSION: mwifiex 1.0 (15.68.19.p21)
>   [   46.157485] mwifiex_pcie 0000:01:00.0: driver_version = mwifiex 1.0 (15.68.19.p21)

Interesting... putting PCIe card into D3cold cause shutdown also of USB
bluetooth part.

> Note the absence of "WLAN FW already running! Skip FW dnld" on the
> second log. Due to the power cycle we're essentially forcing the device
> to re-download and re-initialize its firmware.

Yea, this proves that putting into D3cold and returning back to D0 cause
full reset of the card, both PCIe and USB parts. ARM CPU on this card
therefore must be reset and so new full firmware download and start it
again is needed.

> On an unpatched kernel,
> it looks like the firmware itself is kept and state may not be cleared
> properly. So in other words it looks like the firmware, while being
> prompted to do a reset, doesn't do that properly (at least when it has
> crashed before).
> 
> IIRC this then allowed us to recover from firmware issues that the
> "normal" firmware reset that mwifiex supposedly performs on a FLR
> (or reloading driver modules) didn't help with.

PCIe Function Level Reset should reset only one PCIe part of device. And
seems that this type of reset does not work properly in some situations.

Note that PCIe Function Level Reset is independent of running firmware.
It is implement in hardware and (should) work also at early stage when
firmware is not loaded yet.

I'm starting to think more and more if quirk in this patch really needs
to be behind DMI check and if rather it should not be called on other
platforms too?

> I'm not so sure any more if resetting actively caused issues or if it
> just showed different symptoms of some firmware issue that prompted us
> to do the reset in the first place (again, been quite a while since I
> last dealt with this stuff, sorry). All I know is that this patched
> reset gets the card going again.
> 
> As a side note: There are also more patches by Jonas (and Tsuchiya?)
> building on top of the quirk implementation introduced here which
> significantly reduce the need for doing resets in the first place
> (nevertheless having a reset that actually does properly reset the
> device is a good thing IMHO). Those patches can for example be found
> here:
> 
>   https://github.com/linux-surface/kernel/compare/eaaf96ba58a5fe5999b89fe3afaded74caa96480...989c8725a6d4e62db6370dd0fefe45498274d3ce
> 
> > > > > Unfortunately I can't test that with a
> > > > > network connection (and without compiling a custom kernel for which I
> > > > > don't have the time right now) because there's currently another bug
> > > > > deadlocking on device removal if there's an active connection during
> > > > > removal (which also seems to trigger on reset). That one ill be fixed
> > > > > by
> > > > > 
> > > > >     https://lore.kernel.org/linux-wireless/20210515024227.2159311-1-briannorris@chromium.org/
> > > > > 
> > > > > Jonas might know more.
> > > 
> > > [...]
