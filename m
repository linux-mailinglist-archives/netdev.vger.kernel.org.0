Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 220CF190E19
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 13:52:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727523AbgCXMwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 08:52:04 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:39727 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727504AbgCXMwE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 08:52:04 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 48mrjv33ZCz1qsbC;
        Tue, 24 Mar 2020 13:52:00 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 48mrjr3yY0z1r0bv;
        Tue, 24 Mar 2020 13:52:00 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id 3KN-5f0aoye5; Tue, 24 Mar 2020 13:51:59 +0100 (CET)
X-Auth-Info: tU0Jv6dz9wdZCOREgWp/v+xpCGXOoxK1mzRbyRjbgbY=
Received: from [IPv6:::1] (unknown [195.140.253.167])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Tue, 24 Mar 2020 13:51:59 +0100 (CET)
Subject: Re: [PATCH 06/14] net: ks8851: Remove ks8851_rdreg32()
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
References: <20200323234303.526748-1-marex@denx.de>
 <20200323234303.526748-7-marex@denx.de> <20200324013044.GM3819@lunn.ch>
From:   Marek Vasut <marex@denx.de>
Message-ID: <9896e220-8c39-422a-01b3-beda0fc5f355@denx.de>
Date:   Tue, 24 Mar 2020 13:34:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200324013044.GM3819@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/24/20 2:30 AM, Andrew Lunn wrote:
>> @@ -527,9 +507,8 @@ static void ks8851_rx_pkts(struct ks8851_net *ks)
>>  	 */
>>  
>>  	for (; rxfc != 0; rxfc--) {
>> -		rxh = ks8851_rdreg32(ks, KS_RXFHSR);
>> -		rxstat = rxh & 0xffff;
>> -		rxlen = (rxh >> 16) & 0xfff;
>> +		rxstat = ks8851_rdreg16(ks, KS_RXFHSR);
>> +		rxlen = ks8851_rdreg16(ks, KS_RXFHBCR) & RXFHBCR_CNT_MASK;
> 
> Hi Marek
> 
> Is there anything in the datasheet about these registers? Does reading
> them clear an interrupt etc? A 32bit read is i assume one SPI
> transaction, where as this is now two transactions, so no longer
> atomic.

Nope, they're just two registers holding packet metadata.
There are separate interrupt registers and separate register to clear
the packet from the RX FIFO, so reading these two registers does not
have to be atomic.
