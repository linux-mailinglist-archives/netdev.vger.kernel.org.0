Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4320B18EC26
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 21:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbgCVU3W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 16:29:22 -0400
Received: from mail.aboehler.at ([176.9.113.11]:40622 "EHLO mail.aboehler.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726664AbgCVU3W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Mar 2020 16:29:22 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.aboehler.at (Postfix) with ESMTP id CDD74618087E;
        Sun, 22 Mar 2020 21:29:20 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at aboehler.at
Received: from mail.aboehler.at ([127.0.0.1])
        by localhost (aboehler.at [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id qx54ZkCYH61F; Sun, 22 Mar 2020 21:29:19 +0100 (CET)
Received: from [192.168.17.123] (194-166-175-239.adsl.highway.telekom.at [194.166.175.239])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: andreas@aboehler.at)
        by mail.aboehler.at (Postfix) with ESMTPSA id F3517618087D;
        Sun, 22 Mar 2020 21:29:18 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aboehler.at;
        s=default; t=1584908959;
        bh=N5/uQZ3MrsyRCx6FrObCdxY9dkhONBvA//kCOhEPgZ0=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=JKPne4akLFQgLFqMUSYJnhcp+j6GGc2YgXpAZ+C5XPEfNRaAYT6meLFoEDOi4hOZn
         sc8RnattXP8f/YGs3zc/cDw/a3vnrzDt77ry8EtTZZxcAY77QXO9z6FP9lYx7BrZZ8
         HM2VBt3fXFWNx4CmWj5S4z5BXyp7WwRcj3QYlBco=
Subject: Re: [RFC] MDIO firmware upload for offloading CPU
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org
References: <27780925-4a60-f922-e1ed-e8e43a9cc8a2@aboehler.at>
 <20200322144306.GI11481@lunn.ch>
From:   =?UTF-8?Q?Andreas_B=c3=b6hler?= <news@aboehler.at>
Message-ID: <96bfdd47-80ce-b7fd-75f7-d2ad0705f8bb@aboehler.at>
Date:   Sun, 22 Mar 2020 21:29:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200322144306.GI11481@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: de-AT
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22/03/2020 15:43, Andrew Lunn wrote:
> On Sun, Mar 22, 2020 at 02:56:40PM +0100, Andreas Böhler wrote:
>> Hi,
>>
>> I'm working on support for AVM FRITZ!Box routers, specifically the 3390
>> and 3490. Both contain two SoCs: A Lantiq VDSL SoC that handles VDSL and
>> Ethernet connections and an Atheros SoC for WiFi. Only the Lantiq has
>> access to flash memory, the Atheros SoC requires firmware to be uploaded.
>>
>> AVM has implemented a two-stage firmware upload: The stage 1 firmware is
>> transferred via MDIO (there is no PHY), the stage 2 firmware is uploaded
>> via Ethernet. I've got basic support up and running, but I'm unsure how
>> to proceed:
>>
>> I implemented a user space utility that uses ioctls to upload the
>> firmware via MDIO. However, this only works when the switch
>> driver/ethernet driver is patched to allow MDIO writes to a fixed PHY
>> (actually, it now allows MDIO writes to an arbitrary address; I patched
>> the out-of-tree xrx200 driver for now). It is important to note that no
>> PHY probing must be done, as this confuses the target.
>>
>> 1. How should firmware uploads via MDIO be performed? Preferably in
>> userspace or in kernel space? Please keep in mind that the protocol is
>> entirely reverse-engineered.
>>
>> 2. If the firmware upload can/should be done in userspace, how do I best
>> get access to the MDIO bus?
>>
>> 3. What would be a suitable way to implement it?
> 
> Hi Andreas
> 
> You say there is no PHY. So is the MDIO bus used for anything other
> than firmware upload?

Yes - there are four other PHYs on the bus, everything is attached to
the Lantiq Gigabit switch. I wasn't clear enough in this regard.

> You can control scanning of the MDIO bus using mdio->phy_mask. If you
> set it to ~0, no scanning will be performed. It will then only probe
> for devices you have in device tree. If there are no devices on the
> bus, no probing will happen.

That sounds good.

> This two stage firmware upload is messy. If it had been just MDIO i
> would of said do it from the kernel, as part of the Atheros SoC WiFi
> driver. MDIO is a nice simple interface. Sending Ethernet frames is a
> bit harder. Still, if you can do it all in the wifi driver, i
> would. You can use phandle's to get references to the MDIO bus and the
> Ehernet interface. There are examples of this in net/dsa/dsa2.c.

A bit more info on the two-stage firmware upload: The Atheros SoC is a
complete AR9342 or QCA9558 SoC with 64MB or 128MB RAM. The stage 1
firmware only initializes the Ethernet connection and waits for the
stage 2 firmware. The latter consists in the vendor implementation of a
Linux kernel and minimal user space, the wireless cards are then somehow
"exported" over Ethernet to the Lantiq SoC. On the Lantiq, they look
like local Atheros interfaces  - it looks a lot like ath9k-htc with a
different transport

My current approach consists of a standalone Linux distribution (OpenWrt
based) that receives its configuration via Ethernet as stage 2 firmware.
This makes the second SoC quite capable.

To sum up: I've got two devices on one PCB where only one has access to
flash memory. The communication is entirely based on MDIO and Ethernet.

Regards,
Andreas
