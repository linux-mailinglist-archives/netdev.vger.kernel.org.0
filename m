Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB802DB89C
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 02:47:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725789AbgLPBq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 20:46:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:33858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725562AbgLPBq5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 20:46:57 -0500
Date:   Tue, 15 Dec 2020 17:46:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608083176;
        bh=6oGqf8YNdR6n8cCHeDIbFqB5b7wcwBQilmXNT/TPfm0=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=LIhhtalnxo4ouESvIS/XcznbvR0DgTNfyX0UZ4g63vzcW412BFx9sWnrK18A2Yk1l
         oAQifUQgax3zdXNIZi6A9e4y1YFd1clgRvPyP4T7l/4PmpusQDR11PiefxqFPTrD1X
         G1MSwmZiSfAXzbanFw+O1EIHkB/OKDqD1mdtSvxTkgsVUu8KtBY3ErJuYSpybwX5B5
         s8pMlQR6ls/kSnkTE1gD4ABvY5DjlFRivEgNV0fO9xihk6RpuK07pEBUWd7DytuI0o
         MKVDIWmoVf89V6Hq+IHDLAqDPWNBizZASzA1+SC4/V1Ya0ona5BHe+NsPrCfKdWkYE
         B7neAY/wL+XBA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lukasz Stelmach <l.stelmach@samsung.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, jim.cromie@gmail.com,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        =?UTF-8?B?QmFydMWCb21pZWogxbtvbG5pZXJr?= =?UTF-8?B?aWV3aWN6?= 
        <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v8 3/3] net: ax88796c: ASIX AX88796C SPI Ethernet
 Adapter Driver
Message-ID: <20201215174615.17c08e88@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <dleftjr1nq8tus.fsf%l.stelmach@samsung.com>
References: <20201204193702.1e4b0427@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <CGME20201216004251eucas1p17b212b74d7382f4dbc0eb9a1955404e7@eucas1p1.samsung.com>
        <dleftjr1nq8tus.fsf%l.stelmach@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Dec 2020 01:42:03 +0100 Lukasz Stelmach wrote:
> >> +	ax_local->stats.rx_packets++;
> >> +	ax_local->stats.rx_bytes += skb->len;
> >> +	skb->dev = ndev;
> >> +
> >> +	skb->truesize = skb->len + sizeof(struct sk_buff);  
> >
> > Why do you modify truesize?
> >  
> 
> I don't know. Although uncommon, this appears in a few usb drivers, so I
> didn't think much about it when I ported this code.

I'd guess they do aggregation. I wouldn't touch it in your driver.

>> Since you always punt to a workqueue did you consider just using
>> threaded interrupts instead?   
> 
> Yes, and I have decided to stay with the workqueue. Interrupt
> processing is not the only task performed in the workqueue. There is
> also trasmission to the hardware, which may be quite slow (remember, it
> is SPI), so it's better decoupled from syscalls

I see, and since the device can't do RX and TX simultaneously (IIRC),
that makes sense.

> >> +	u8			plat_endian;
> >> +		#define PLAT_LITTLE_ENDIAN	0
> >> +		#define PLAT_BIG_ENDIAN		1  
> >
> > Why do you store this little nugget of information?
> >  
> 
> I don't know*. The hardware enables endianness detection by providing a
> constant value (0x1234) in one of its registers. Unfortunately I don't
> have a big-endian board with this chip to check if it is necessary to
> alter AX_READ/AX_WRITE in any way.

Yeah, may be hard to tell what magic the device is doing.
I was mostly saying that you don't seem to use this information,
so the member of the struct can be removed IIRC.

> > These all look like multiple of 2 bytes. Why do they need to be packed?
> >  
> 
> These are structures sent to and returned from the hardware. They are
> prepended and appended to the network packets. I think it is good to
> keep them packed, so compilers won't try any tricks.

Compilers can't play tricks on memory layout of structures, the
standard is pretty strict about that. Otherwise ABIs would never work.
We prefer not to unnecessarily pack structures in the neworking code,
because it generates byte by byte loads on architectures which can't 
do unaligned accesses.

> > No need to return some specific pattern on failure? Like 0xffff?
> >  
> 
> All registers are 16 bit wide. I am afraid it isn't safe to assume that
> there is a 16 bit value we could use. Chances that SPI goes south are
> pretty slim. And if it does, there isn't much more than reporting an
> error we can do about it anyway.
> 
> One thing I can think of is to change axspi_* to (s32), return -1,
> somehow (how?) shutdown the device in AX_*.

I'm mostly concerned about potentially random data left over in the
buffer. Seems like it could lead to hard to repro bugs. Hence the
suggestion to return a constant of your choosing on error, doesn't
really matter what as long as it's a known constant.
