Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4A7195E92
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 20:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbgC0TZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 15:25:22 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:57692 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbgC0TZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 15:25:22 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 48psJJ4T8Mz1rnKC;
        Fri, 27 Mar 2020 20:25:20 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 48psJJ3lMxz1qs9t;
        Fri, 27 Mar 2020 20:25:20 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id iQIXUzHN5NOz; Fri, 27 Mar 2020 20:25:19 +0100 (CET)
X-Auth-Info: SDlwHNJiyPSr94xChPB5/BOGMVMjfFe1xt/9ocRoS8s=
Received: from [IPv6:::1] (unknown [195.140.253.167])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Fri, 27 Mar 2020 20:25:19 +0100 (CET)
Subject: Re: [PATCH V2 00/14] net: ks8851: Unify KS8851 SPI and MLL drivers
From:   Marek Vasut <marex@denx.de>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>, Andrew Lunn <andrew@lunn.ch>
References: <20200325150543.78569-1-marex@denx.de>
 <20200326190219.zwu2qgu6f6lxbied@wunner.de>
 <44b7417b-42d6-cb13-89a7-17b75905e75d@denx.de>
Message-ID: <fb948d50-8b7a-bbff-861c-efd03b3d687a@denx.de>
Date:   Fri, 27 Mar 2020 20:25:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <44b7417b-42d6-cb13-89a7-17b75905e75d@denx.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/27/20 7:18 PM, Marek Vasut wrote:

[...]

>> The performance degredation with this series is as follows:
>>
>> Latency (ping) without this series:
>>   rtt min/avg/max/mdev = 0.982/1.776/3.756/0.027 ms, ipg/ewma 2.001/1.761 ms
>> With this series:
>>   rtt min/avg/max/mdev = 1.084/1.811/3.546/0.040 ms, ipg/ewma 2.020/1.814 ms
>>
>> Throughput (scp) without this series:
>>   Transferred: sent 369780976, received 66088 bytes, in 202.0 seconds
>>   Bytes per second: sent 1830943.5, received 327.2
>> With this series:
>>   Transferred: sent 369693896, received 67588 bytes, in 210.5 seconds
>>   Bytes per second: sent 1755952.6, received 321.0
> 
> Maybe some iperf would be better here ?
> 
>> SPI clock is 25 MHz.  The chip would allow up to 40 MHz, but the board
>> layout limits that.
>>
>> I suspect the performance regression is not only caused by the
>> suboptimal 16 byte instead of 8 byte accesses (and 2x16 byte instead
>> of 32 byte accesses), but also because the accessor functions cannot
>> be inlined.  It would be better if they were included from a header
>> file as static inlines.  The performance regression would then likely
>> disappear.
> 
> I did another measurement today and I found out that while RX on the old
> KS8851-MLL driver runs at ~50 Mbit/s , TX runs at ~80 Mbit/s . With this
> new driver, RX still runs at ~50 Mbit/s, but TX runs also at 50 Mbit/s .
> That's real bad. Any ideas how to debug/profile this one ?

So this schedule_work in start_xmit is the problem I have. If I hack it
up to do what the ks8851-mll does -- basically write packet into HW and
wait until it's transmitted -- then I get my 75 Mbit/s back.

I think we should implement some napi here, but for TX ? Basically
buffer up a few packets and then write them to the hardware in bulk.
There has to be something like that in the network stack , no ?
