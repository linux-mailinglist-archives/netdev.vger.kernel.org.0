Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9119195D89
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 19:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727549AbgC0SWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 14:22:25 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:45777 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbgC0SWZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 14:22:25 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 48pqvd4mnDz1qrGV;
        Fri, 27 Mar 2020 19:22:15 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 48pqvW1qkpz1qs9q;
        Fri, 27 Mar 2020 19:22:15 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id sMTDvatxhxaz; Fri, 27 Mar 2020 19:22:14 +0100 (CET)
X-Auth-Info: F/DGiF7zw28qtEXz/zk97MLVLdCgxSnYCGOtgwsS8wk=
Received: from [127.0.0.1] (unknown [195.140.253.167])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Fri, 27 Mar 2020 19:22:14 +0100 (CET)
Subject: Re: [PATCH V2 00/14] net: ks8851: Unify KS8851 SPI and MLL drivers
To:     Lukas Wunner <lukas@wunner.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>, Andrew Lunn <andrew@lunn.ch>
References: <20200325150543.78569-1-marex@denx.de>
 <20200326190219.zwu2qgu6f6lxbied@wunner.de>
From:   Marek Vasut <marex@denx.de>
Message-ID: <44b7417b-42d6-cb13-89a7-17b75905e75d@denx.de>
Date:   Fri, 27 Mar 2020 19:18:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200326190219.zwu2qgu6f6lxbied@wunner.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/26/20 8:02 PM, Lukas Wunner wrote:
> On Wed, Mar 25, 2020 at 04:05:29PM +0100, Marek Vasut wrote:
>> The KS8851SNL/SNLI and KS8851-16MLL/MLLI/MLLU are very much the same pieces
>> of silicon, except the former has an SPI interface, while the later has a
>> parallel bus interface. Thus far, Linux has two separate drivers for each
>> and they are diverging considerably.
>>
>> This series unifies them into a single driver with small SPI and parallel
>> bus specific parts. The approach here is to first separate out the SPI
>> specific parts into a separate file, then add parallel bus accessors in
>> another separate file and then finally remove the old parallel bus driver.
>> The reason for replacing the old parallel bus driver is because the SPI
>> bus driver is much higher quality.
> 
> With this series, ks8851.ko (SPI variant) failed to compile as a module.
> I got it working by renaming ks8851.c to ks8851_common.c and applying
> the following change to the Makefile:
> 
> --- a/drivers/net/ethernet/micrel/Makefile
> +++ b/drivers/net/ethernet/micrel/Makefile
> @@ -5,6 +5,8 @@
>  
>  obj-$(CONFIG_ARM_KS8695_ETHER) += ks8695net.o
>  obj-$(CONFIG_KS8842) += ks8842.o
> -obj-$(CONFIG_KS8851) += ks8851.o ks8851_spi.o
> -obj-$(CONFIG_KS8851_MLL) += ks8851.o ks8851_par.o
> +obj-$(CONFIG_KS8851) += ks8851.o
> +ks8851-objs = ks8851_common.o ks8851_spi.o
> +obj-$(CONFIG_KS8851_MLL) += ks8851_mll.o
> +ks8851_mll-objs = ks8851_common.o ks8851_par.o
>  obj-$(CONFIG_KSZ884X_PCI) += ksz884x.o
> 
> This series breaks reading the MAC address from an EEPROM attached to
> the KSZ8851SNLI:
> The MAC address stored in the EEPROM was c8:3e:a7:99:ef:aa.
> The MAC address was read as 3e:c8:99:a7:ef:aa with this series.
> Note: The MAC address starts at the third byte in the EEPROM and is
> stored as aa:ef:99:a7:3e:c8, i.e. in reverse order.  (I think the
> spec says something else but it appears to be wrong.)
> 
> Assigning a MAC address with "ifconfig eth1 hw ether <mac>" (which I
> believe ends up calling ks8851_write_mac_addr()) worked fine.

I added fixes for those.

> The performance degredation with this series is as follows:
> 
> Latency (ping) without this series:
>   rtt min/avg/max/mdev = 0.982/1.776/3.756/0.027 ms, ipg/ewma 2.001/1.761 ms
> With this series:
>   rtt min/avg/max/mdev = 1.084/1.811/3.546/0.040 ms, ipg/ewma 2.020/1.814 ms
> 
> Throughput (scp) without this series:
>   Transferred: sent 369780976, received 66088 bytes, in 202.0 seconds
>   Bytes per second: sent 1830943.5, received 327.2
> With this series:
>   Transferred: sent 369693896, received 67588 bytes, in 210.5 seconds
>   Bytes per second: sent 1755952.6, received 321.0

Maybe some iperf would be better here ?

> SPI clock is 25 MHz.  The chip would allow up to 40 MHz, but the board
> layout limits that.
> 
> I suspect the performance regression is not only caused by the
> suboptimal 16 byte instead of 8 byte accesses (and 2x16 byte instead
> of 32 byte accesses), but also because the accessor functions cannot
> be inlined.  It would be better if they were included from a header
> file as static inlines.  The performance regression would then likely
> disappear.

I did another measurement today and I found out that while RX on the old
KS8851-MLL driver runs at ~50 Mbit/s , TX runs at ~80 Mbit/s . With this
new driver, RX still runs at ~50 Mbit/s, but TX runs also at 50 Mbit/s .
That's real bad. Any ideas how to debug/profile this one ?

> I guess the good news is that it otherwise worked out of the box.

Great
