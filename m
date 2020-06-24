Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C948207BE0
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 21:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406207AbgFXTAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 15:00:06 -0400
Received: from foss.arm.com ([217.140.110.172]:56106 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405469AbgFXTAG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 15:00:06 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AA3121F1;
        Wed, 24 Jun 2020 12:00:04 -0700 (PDT)
Received: from [10.57.9.128] (unknown [10.57.9.128])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 470C13F71E;
        Wed, 24 Jun 2020 11:59:59 -0700 (PDT)
Subject: Re: [PATCH 09/15] net: phy: delay PHY driver probe until PHY
 registration
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        devicetree <devicetree@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fabien Parent <fparent@baylibre.com>,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        "moderated list:ARM/Mediatek SoC..." 
        <linux-mediatek@lists.infradead.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Salil Mehta <salil.mehta@huawei.com>,
        netdev <netdev@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Mark Brown <broonie@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <20200622093744.13685-1-brgl@bgdev.pl>
 <20200622093744.13685-10-brgl@bgdev.pl> <20200622133940.GL338481@lunn.ch>
 <20200622135106.GK4560@sirena.org.uk>
 <dca54c57-a3bd-1147-63b2-4631194963f0@gmail.com>
 <20200624094302.GA5472@sirena.org.uk>
 <CAMRc=McBxJdujCyjQF3NA=bCWHF1dx8xJ1Nc2snmqukvJ_VyoQ@mail.gmail.com>
 <f806586d-a6d7-99af-bba4-d1e7d28be192@gmail.com>
 <20200624165016.GA1551@shell.armlinux.org.uk>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <0c78a4ab-5aae-a45c-babd-e860c6cfc3c8@arm.com>
Date:   Wed, 24 Jun 2020 19:59:57 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200624165016.GA1551@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-06-24 17:50, Russell King - ARM Linux admin wrote:
> On Wed, Jun 24, 2020 at 09:06:28AM -0700, Florian Fainelli wrote:
>> On 6/24/2020 6:48 AM, Bartosz Golaszewski wrote:
>>> I didn't expect to open such a can of worms...
>>>
>>> This has evolved into several new concepts being proposed vs my
>>> use-case which is relatively simple. The former will probably take
>>> several months of development, reviews and discussions and it will
>>> block supporting the phy supply on pumpkin boards upstream. I would
>>> prefer not to redo what other MAC drivers do (phy-supply property on
>>> the MAC node, controlling it from the MAC driver itself) if we've
>>> already established it's wrong.
>>
>> You are not new to Linux development, so none of this should come as a
>> surprise to you. Your proposed solution has clearly short comings and is
>> a hack, especially around the PHY_ID_NONE business to get a phy_device
>> only then to have the real PHY device ID. You should also now that "I
>> need it now because my product deliverable depends on it" has never been
>> received as a valid argument to coerce people into accepting a solution
>> for which there are at review time known deficiencies to the proposed
>> approach.
> 
> It /is/ a generic issue.  The same problem exists for AMBA Primecell
> devices, and that code has an internal deferred device list that it
> manages.  See drivers/amba/bus.c, amba_deferred_retry_func(),
> amba_device_try_add(), and amba_device_add().
> 
> As we see more devices gain this property, it needs to be addressed
> in a generic way, rather than coming up with multiple bus specific
> implementations.
> 
> Maybe struct bus_type needs a method to do the preparation to add
> a device (such as reading IDs etc), which is called by device_add().
> If that method returns -EPROBE_DEFER, the device gets added to a
> deferred list, which gets retried when drivers are successfully
> probed.  Possible maybe?

FWIW that would be ideal for solving an ordering a problem we have in 
the IOMMU subsystem too (which we currently sort-of-handle by deferring 
driver probe from dma_configure(), but it really needs to be done 
earlier and not depend on drivers being present at all).

Robin.
