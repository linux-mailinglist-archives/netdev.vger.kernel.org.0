Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26AF1D55C2
	for <lists+netdev@lfdr.de>; Sun, 13 Oct 2019 13:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728884AbfJMLZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Oct 2019 07:25:25 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:37070 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728620AbfJMLZY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Oct 2019 07:25:24 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 46rfW56mTzz1rGRb;
        Sun, 13 Oct 2019 13:25:21 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 46rfW54srRz1qqkB;
        Sun, 13 Oct 2019 13:25:21 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id VaIw_UY2e7b7; Sun, 13 Oct 2019 13:25:19 +0200 (CEST)
X-Auth-Info: kqYQkCQdlsUpReVqK5xeQpQ9TZ0ArohXdkL4cpalQRU=
Received: from [IPv6:::1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Sun, 13 Oct 2019 13:25:19 +0200 (CEST)
Subject: Re: [PATCH 2/2] net: dsa: microchip: Add shared regmap mutex
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        george.mccollister@gmail.com, Tristram.Ha@microchip.com,
        woojung.huh@microchip.com
References: <20191010182508.22833-1-marex@denx.de>
 <20191010182508.22833-2-marex@denx.de>
 <20191012.172055.1647651676286562151.davem@davemloft.net>
 <20191012.172140.1744793229621810305.davem@davemloft.net>
From:   Marek Vasut <marex@denx.de>
Message-ID: <018dad90-f6a4-328c-765e-8e5b66df27d6@denx.de>
Date:   Sun, 13 Oct 2019 12:50:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191012.172140.1744793229621810305.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/13/19 2:21 AM, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Sat, 12 Oct 2019 17:20:55 -0700 (PDT)
> 
>> From: Marek Vasut <marex@denx.de>
>> Date: Thu, 10 Oct 2019 20:25:08 +0200
>>
>>> The KSZ driver uses one regmap per register width (8/16/32), each with
>>> it's own lock, but accessing the same set of registers. In theory, it
>>> is possible to create a race condition between these regmaps, although
>>> the underlying bus (SPI or I2C) locking should assure nothing bad will
>>> really happen and the accesses would be correct.
>>>
>>> To make the driver do the right thing, add one single shared mutex for
>>> all the regmaps used by the driver instead. This assures that even if
>>> some future hardware is on a bus which does not serialize the accesses
>>> the same way SPI or I2C does, nothing bad will happen.
>>>
>>> Note that the status_mutex was unused and only initied, hence it was
>>> renamed and repurposed as the regmap mutex.
>>>
>>> Signed-off-by: Marek Vasut <marex@denx.de>
>>
>> Applied.
> 
> Actually, both patches reverted.  Please test your changes properly:
> 
> ERROR: "ksz_regmap_unlock" [drivers/net/dsa/microchip/ksz8795_spi.ko] undefined!
> ERROR: "ksz_regmap_lock" [drivers/net/dsa/microchip/ksz8795_spi.ko] undefined!
> ERROR: "ksz_regmap_unlock" [drivers/net/dsa/microchip/ksz9477_spi.ko] undefined!
> ERROR: "ksz_regmap_lock" [drivers/net/dsa/microchip/ksz9477_spi.ko] undefined!
> ERROR: "ksz_regmap_unlock" [drivers/net/dsa/microchip/ksz9477_i2c.ko] undefined!
> ERROR: "ksz_regmap_lock" [drivers/net/dsa/microchip/ksz9477_i2c.ko] undefined!

So the test is to compile it as a module ?

-- 
Best regards,
Marek Vasut
