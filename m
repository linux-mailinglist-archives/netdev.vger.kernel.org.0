Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C623A19B63A
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 21:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732532AbgDATIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 15:08:23 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:52587 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726785AbgDATIX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 15:08:23 -0400
Received: from tarshish (unknown [10.0.8.3])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id D6A15440813;
        Wed,  1 Apr 2020 22:08:01 +0300 (IDT)
References: <16e4a15e359012fc485d22c7e413a129029fbd0f.1585676858.git.baruch@tkos.co.il> <ad024231-40bd-c82f-e6d0-3b1b00c93e9a@gmail.com>
User-agent: mu4e 1.2.0; emacs 26.1
From:   Baruch Siach <baruch@tkos.co.il>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Shmuel Hazan <sh@tkos.co.il>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH] net: phy: marvell10g: add firmware load support
In-reply-to: <ad024231-40bd-c82f-e6d0-3b1b00c93e9a@gmail.com>
Date:   Wed, 01 Apr 2020 22:08:18 +0300
Message-ID: <87tv23ausd.fsf@tarshish>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Tue, Mar 31 2020, Florian Fainelli wrote:
> On 3/31/2020 10:47 AM, Baruch Siach wrote:

[snip]

>> +	ret = request_firmware(&fw_entry, fw_file, &phydev->mdio.dev);
>> +	if (ret < 0)
>> +		return ret;
>> +
>> +	/* Firmware size must be larger than header, and even */
>> +	if (fw_entry->size <= MV_FIRMWARE_HEADER_SIZE ||
>> +			(fw_entry->size % 2) != 0) {
>> +		dev_err(&phydev->mdio.dev, "firmware file invalid");
>> +		return -EINVAL;
>> +	}
>
> You need to release the firmware file here.

Will fix.

> There is also possibly another case that you are not covering here,
> which is that the firmware on disk is newer than the firmware
> *already* loaded in the PHY, this should presumably update the running
> firmware to the latest copy.

Firmware is only loaded when the PHY boot state is MV_PMA_BOOT_WAITING
(see below). The code does not attempt to update existing PHY firmware.

> Without being able to publish the firmware in linux-firmware though, all
> of this may be moot.

I can't do much about that, unfortunately.

baruch

--
     http://baruch.siach.name/blog/                  ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il -
