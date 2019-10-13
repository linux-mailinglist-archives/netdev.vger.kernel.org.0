Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDE29D56CD
	for <lists+netdev@lfdr.de>; Sun, 13 Oct 2019 18:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728839AbfJMQ0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Oct 2019 12:26:31 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41980 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbfJMQ0b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Oct 2019 12:26:31 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AE9121426D0F4;
        Sun, 13 Oct 2019 09:26:30 -0700 (PDT)
Date:   Sun, 13 Oct 2019 09:26:28 -0700 (PDT)
Message-Id: <20191013.092628.1408615115437209574.davem@davemloft.net>
To:     marex@denx.de
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        george.mccollister@gmail.com, Tristram.Ha@microchip.com,
        woojung.huh@microchip.com
Subject: Re: [PATCH 2/2] net: dsa: microchip: Add shared regmap mutex
From:   David Miller <davem@davemloft.net>
In-Reply-To: <018dad90-f6a4-328c-765e-8e5b66df27d6@denx.de>
References: <20191012.172055.1647651676286562151.davem@davemloft.net>
        <20191012.172140.1744793229621810305.davem@davemloft.net>
        <018dad90-f6a4-328c-765e-8e5b66df27d6@denx.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 13 Oct 2019 09:26:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Vasut <marex@denx.de>
Date: Sun, 13 Oct 2019 12:50:15 +0200

> On 10/13/19 2:21 AM, David Miller wrote:
>> From: David Miller <davem@davemloft.net>
>> Date: Sat, 12 Oct 2019 17:20:55 -0700 (PDT)
>> 
>>> From: Marek Vasut <marex@denx.de>
>>> Date: Thu, 10 Oct 2019 20:25:08 +0200
>>>
>>>> The KSZ driver uses one regmap per register width (8/16/32), each with
>>>> it's own lock, but accessing the same set of registers. In theory, it
>>>> is possible to create a race condition between these regmaps, although
>>>> the underlying bus (SPI or I2C) locking should assure nothing bad will
>>>> really happen and the accesses would be correct.
>>>>
>>>> To make the driver do the right thing, add one single shared mutex for
>>>> all the regmaps used by the driver instead. This assures that even if
>>>> some future hardware is on a bus which does not serialize the accesses
>>>> the same way SPI or I2C does, nothing bad will happen.
>>>>
>>>> Note that the status_mutex was unused and only initied, hence it was
>>>> renamed and repurposed as the regmap mutex.
>>>>
>>>> Signed-off-by: Marek Vasut <marex@denx.de>
>>>
>>> Applied.
>> 
>> Actually, both patches reverted.  Please test your changes properly:
>> 
>> ERROR: "ksz_regmap_unlock" [drivers/net/dsa/microchip/ksz8795_spi.ko] undefined!
>> ERROR: "ksz_regmap_lock" [drivers/net/dsa/microchip/ksz8795_spi.ko] undefined!
>> ERROR: "ksz_regmap_unlock" [drivers/net/dsa/microchip/ksz9477_spi.ko] undefined!
>> ERROR: "ksz_regmap_lock" [drivers/net/dsa/microchip/ksz9477_spi.ko] undefined!
>> ERROR: "ksz_regmap_unlock" [drivers/net/dsa/microchip/ksz9477_i2c.ko] undefined!
>> ERROR: "ksz_regmap_lock" [drivers/net/dsa/microchip/ksz9477_i2c.ko] undefined!
> 
> So the test is to compile it as a module ?

The test is to compile it in all relevant possible configurations.

As a module, statically, and with dependent modules both static and
modular as is relevant.
