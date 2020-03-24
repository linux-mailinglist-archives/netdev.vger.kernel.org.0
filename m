Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9546190E1C
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 13:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727555AbgCXMwK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 08:52:10 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:37433 "EHLO
        mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727543AbgCXMwI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 08:52:08 -0400
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 48mrjy3dcRz1rsY2;
        Tue, 24 Mar 2020 13:52:06 +0100 (CET)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 48mrjy39JBz1r0by;
        Tue, 24 Mar 2020 13:52:06 +0100 (CET)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id rHy7cMGvY7gK; Tue, 24 Mar 2020 13:52:05 +0100 (CET)
X-Auth-Info: EppHg1AMoNmvFHWLqYV9Wf89n5ifSKqiJ0r1PWjUAYc=
Received: from [IPv6:::1] (unknown [195.140.253.167])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Tue, 24 Mar 2020 13:52:05 +0100 (CET)
Subject: Re: [PATCH 08/14] net: ks8851: Use 16-bit read of RXFC register
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
References: <20200323234303.526748-1-marex@denx.de>
 <20200323234303.526748-9-marex@denx.de> <20200324015041.GO3819@lunn.ch>
From:   Marek Vasut <marex@denx.de>
Message-ID: <8079699e-8235-c800-44a8-022ade8140f1@denx.de>
Date:   Tue, 24 Mar 2020 13:50:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200324015041.GO3819@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/24/20 2:50 AM, Andrew Lunn wrote:
>> @@ -470,7 +455,7 @@ static void ks8851_rx_pkts(struct ks8851_net *ks)
>>  	unsigned rxstat;
>>  	u8 *rxpkt;
>>  
>> -	rxfc = ks8851_rdreg8(ks, KS_RXFC);
>> +	rxfc = (ks8851_rdreg16(ks, KS_RXFCTR) >> 8) & 0xff;
> 
> The datasheet says:
> 
> 2. When software driver reads back Receive Frame Count (RXFCTR)
> Register; the KSZ8851 will update both Receive Frame Header Status and
> Byte Count Registers (RXFHSR/RXFHBCR)
> 
> Are you sure there is no side affect here?

Yes, look at the RXFC register 0x9c itself. It's a 16bit register, 0x9c
is the LSByte and 0x9d is the MSByte.

What happened here before was readout of register 0x9d, MSByte of RXFC,
which triggers the update of RXFHSR/RXFHBCR. What happens now is the
readout of the whole RXFC as 16bit value, which also triggers the update.
