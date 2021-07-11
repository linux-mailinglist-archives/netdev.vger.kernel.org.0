Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0A663C3E2A
	for <lists+netdev@lfdr.de>; Sun, 11 Jul 2021 19:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232618AbhGKREp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 13:04:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:38906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229688AbhGKREp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Jul 2021 13:04:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8AE1610A6;
        Sun, 11 Jul 2021 17:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626022918;
        bh=XiwSCptAfKifULMy9fRRaw604V6wMcanQF7EaUJ+Kb0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V2up30sic42QEo3JlF7zsEZXxqmAEpu7iqQnAjKt47MhF0clgWLmKkFjNPsWeaAjq
         dCJtXpKdXPArMWt4k7WGeLZq0LYZrpe7miqE1X6liSvXrD9JE1jxOp0SX3j+0pKHfS
         HpgWa9apHIx0zZB6BR7HWRB0LZw16uybzKXh82s2+mtHSYgX9tNeQHXcPf7ZO3WrAo
         WZCsKucUVUdZ1dEo60fLQV3gUZK+Yk9vFfcRAEKG8t46Z6e7PANvzb4YUMgJTGhO4i
         evKlsPRR90/v1oniEUQJDgcbRu+0ggpvBB0l+13lU3HIZ6Mndoi7cQUzDLbYJCKnyT
         eYGRMkpRF6PUQ==
Received: by pali.im (Postfix)
        id 9577C773; Sun, 11 Jul 2021 19:01:55 +0200 (CEST)
Date:   Sun, 11 Jul 2021 19:01:55 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Jonas =?utf-8?Q?Dre=C3=9Fler?= <verdre@v0yd.nl>
Cc:     Maximilian Luz <luzmaximilian@gmail.com>,
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
Message-ID: <20210711170155.zt5mpig6sgusifs3@pali>
References: <4e35bfc1-c38d-7198-dedf-a1f2ec28c788@gmail.com>
 <20210709212505.mmqxdplmxbemqzlo@pali>
 <bfbb3b4d-07f7-1b97-54f0-21eba4766798@gmail.com>
 <20210709225433.axpzdsfbyvieahvr@pali>
 <89c9d1b8-c204-d028-9f2c-80d580dabb8b@gmail.com>
 <20210710000756.4j3tte63t5u6bbt4@pali>
 <1d45c961-d675-ea80-abe4-8d4bcf3cf8d4@gmail.com>
 <20210710003826.clnk5sh3cvlamwjr@pali>
 <2d7eef37-aab3-8986-800f-74ffc27b62c5@gmail.com>
 <fc1f39b0-2d61-387f-303f-9715781a2c4a@mailbox.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fc1f39b0-2d61-387f-303f-9715781a2c4a@mailbox.org>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sunday 11 July 2021 18:53:32 Jonas Dreßler wrote:
> On 7/10/21 3:07 AM, Maximilian Luz wrote:
> > On 7/10/21 2:38 AM, Pali Rohár wrote:
> > > On Saturday 10 July 2021 02:18:12 Maximilian Luz wrote:
> > > > On 7/10/21 2:07 AM, Pali Rohár wrote:
> > > > 
> > > > [...]
> > > > 
> > > > > > Interesting, I was not aware of this. IIRC we've been
> > > > > > experimenting with
> > > > > > the mwlwifi driver (which that lrdmwl driver seems to be
> > > > > > based on?), but
> > > > > > couldn't get that to work with the firmware we have.
> > > > > 
> > > > > mwlwifi is that soft-mac driver and uses completely different firmware.
> > > > > For sure it would not work with current full-mac firmware.
> > > > > 
> > > > > > IIRC it also didn't
> > > > > > work with the Windows firmware (which seems to be significantly
> > > > > > different from the one we have for Linux and seems to
> > > > > > use or be modeled
> > > > > > after some special Windows WiFi driver interface).
> > > > > 
> > > > > So... Microsoft has different firmware for this chip? And it is working
> > > > > with mwifiex driver?
> > > > 
> > > > I'm not sure how special that firmware really is (i.e. if it is Surface
> > > > specific or just what Marvell uses on Windows), only that it doesn't
> > > > look like the firmware included in the linux-firmware repo. The Windows
> > > > firmware doesn't work with either mwlwifi or mwifiex drivers (IIRC) and
> > > > on Linux we use the official firmware from the linux-firmware repo.
> > > 
> > > Version available in the linux-firmware repo is also what big companies
> > > (like google) receive for their systems... sometimes just only older
> > > version as Marvell/NXP is slow in updating files in linux-firmware.
> > > Seems that it is also same what receive customers under NDA as more
> > > companies dropped "proprietary" ex-Marvell/NXP driver on internet and it
> > > contained this firmware with some sources of driver which looks like a
> > > fork of mwifiex (or maybe mwifiex is "cleaned fork" of that driver :D)
> > > 
> > > There is old firmware documentation which describe RPC communication
> > > between OS and firmware:
> > > http://wiki.laptop.org/images/f/f3/Firmware-Spec-v5.1-MV-S103752-00.pdf
> > > 
> > > It is really old for very old wifi chips and when I checked it, it still
> > > matches what mwifiex is doing with new chips. Just there are new and
> > > more commands. And documentation is OS-neutral.
> > > 
> > > So if Microsoft has some "incompatible" firmware with this, it could
> > > mean that they got something special which nobody else have? Maybe it
> > > can explain that "connected standby" and maybe also better stability?
> > > 
> > > Or just windows distribute firmware in different format and needs to
> > > "unpack" or "preprocess" prior downloading it to device?
> > 
> > If memory serves me right, Jonas did some reverse engineering on the
> > Windows driver and found that it uses the "new" WDI Miniport API: It
> > seems that originally both Windows and Linux drivers (and firmware)
> > were pretty much the same (he mentioned there were similarities in
> > terminology), but then they switched to that new API on Windows and
> > changed the firmware with it, so that the driver now essentially only
> > forwards the commands from that API to the firmware and the firmware
> > handles the rest.
> > 
> > By reading the Windows docs on that API, that change might have been
> > forced on them as some Windows 10 features apparently only work via
> > that API.
> > 
> > He'll probably know more about that than I do.
> 
> Not much I can add there, it seemed a lot like both mwifiex and the Windows
> 10 WDI miniport driver were both derived from the same codebase originally,
> but in order to be compatible with the WDI miniport API and other stuff
> Windows requires from wifi devices (I recall there was some SAR-value
> control/reporting stuff too), some parts of the firmware had to be
> rewritten.
> 
> In the end, the Windows firmware is updated a lot more often and likely
> includes a bunch of bugfixes the linux firmware doesn't have, but it can't
> be used on linux without a ton of work that would probably include
> rebuilding proprietary APIs from Windows.
> 
> Also, from my testing with custom APs and sniffing packets with Wireshark,
> the functionality, limitations and weird "semi-spec-compliant" behaviors
> were exactly the same with the Windows firmware: It doesn't support WPA3, it
> can't connect to fast transition APs (funnily enough that's opposed to what
> MS claims) and it also can't spawn an AP with WPA-PSK-SHA256 AKM ciphers. So
> not sure there's a lot of sense in spending more time trying to go down that
> path.

New version of firmware files are available on NXP portal, where are
updated more frequently, but only for companies which have NXP accounts
and signed NDA with NXP. Not for end users.

If you want these new firmware files, you need to ask NXP developers as
only they can ask for non-NDA distribution and include new version into
linux-firmware repository. Like in this pull request where is new SDIO
firmware for 88W8897:
https://lore.kernel.org/linux-firmware/DB7PR04MB453855B0D6C41923BCB0922EFC1C9@DB7PR04MB4538.eurprd04.prod.outlook.com/
