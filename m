Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 373141D6CBF
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 22:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbgEQUKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 16:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbgEQUKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 May 2020 16:10:00 -0400
X-Greylist: delayed 70524 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 17 May 2020 13:09:59 PDT
Received: from mail-out.m-online.net (mail-out.m-online.net [IPv6:2001:a60:0:28:0:1:25:1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D7BC061A0C
        for <netdev@vger.kernel.org>; Sun, 17 May 2020 13:09:59 -0700 (PDT)
Received: from frontend01.mail.m-online.net (unknown [192.168.8.182])
        by mail-out.m-online.net (Postfix) with ESMTP id 49QCtF3y2Rz1rsXP;
        Sun, 17 May 2020 22:09:47 +0200 (CEST)
Received: from localhost (dynscan1.mnet-online.de [192.168.6.70])
        by mail.m-online.net (Postfix) with ESMTP id 49QCt26qzYz1qr4x;
        Sun, 17 May 2020 22:09:46 +0200 (CEST)
X-Virus-Scanned: amavisd-new at mnet-online.de
Received: from mail.mnet-online.de ([192.168.8.182])
        by localhost (dynscan1.mail.m-online.net [192.168.6.70]) (amavisd-new, port 10024)
        with ESMTP id uCTYHvTSfwLu; Sun, 17 May 2020 22:09:45 +0200 (CEST)
X-Auth-Info: 2BIgvmLjEZ2VyiTJcmEDx0k7hcBgTeYIBEOKDnhMBNE=
Received: from [IPv6:::1] (unknown [195.140.253.167])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mnet-online.de (Postfix) with ESMTPSA;
        Sun, 17 May 2020 22:09:45 +0200 (CEST)
Subject: Re: [PATCH V6 09/20] net: ks8851: Use 16-bit read of RXFC register
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
References: <20200517003354.233373-1-marex@denx.de>
 <20200517003354.233373-10-marex@denx.de> <20200517194439.GG606317@lunn.ch>
From:   Marek Vasut <marex@denx.de>
Message-ID: <48afe451-f690-c038-003d-88331f254239@denx.de>
Date:   Sun, 17 May 2020 22:02:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200517194439.GG606317@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/17/20 9:44 PM, Andrew Lunn wrote:
> On Sun, May 17, 2020 at 02:33:43AM +0200, Marek Vasut wrote:
>> The RXFC register is the only one being read using 8-bit accessors.
>> To make it easier to support the 16-bit accesses used by the parallel
>> bus variant of KS8851, use 16-bit accessor to read RXFC register as
>> well as neighboring RXFCTR register.
>>
>> Remove ks8851_rdreg8() as it is not used anywhere anymore.
>>
>> There should be no functional change.
>>
>> Signed-off-by: Marek Vasut <marex@denx.de>
>> Cc: David S. Miller <davem@davemloft.net>
>> Cc: Lukas Wunner <lukas@wunner.de>
>> Cc: Petr Stetiar <ynezz@true.cz>
>> Cc: YueHaibing <yuehaibing@huawei.com>
>> ---
>> V2: No change
>> V3: No change
>> V4: Drop the NOTE from the comment, the performance is OK
>> V5: No change
>> V6: No change
>> ---
>>  drivers/net/ethernet/micrel/ks8851.c | 17 +----------------
>>  1 file changed, 1 insertion(+), 16 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/micrel/ks8851.c b/drivers/net/ethernet/micrel/ks8851.c
>> index 1b81340e811f..e2e75041e931 100644
>> --- a/drivers/net/ethernet/micrel/ks8851.c
>> +++ b/drivers/net/ethernet/micrel/ks8851.c
>> @@ -236,21 +236,6 @@ static void ks8851_rdreg(struct ks8851_net *ks, unsigned op,
>>  		memcpy(rxb, trx + 2, rxl);
>>  }
>>  
>> -/**
>> - * ks8851_rdreg8 - read 8 bit register from device
>> - * @ks: The chip information
>> - * @reg: The register address
>> - *
>> - * Read a 8bit register from the chip, returning the result
>> -*/
>> -static unsigned ks8851_rdreg8(struct ks8851_net *ks, unsigned reg)
>> -{
>> -	u8 rxb[1];
>> -
>> -	ks8851_rdreg(ks, MK_OP(1 << (reg & 3), reg), rxb, 1);
>> -	return rxb[0];
>> -}
>> -
>>  /**
>>   * ks8851_rdreg16 - read 16 bit register from device
>>   * @ks: The chip information
>> @@ -470,7 +455,7 @@ static void ks8851_rx_pkts(struct ks8851_net *ks)
>>  	unsigned rxstat;
>>  	u8 *rxpkt;
>>  
>> -	rxfc = ks8851_rdreg8(ks, KS_RXFC);
>> +	rxfc = (ks8851_rdreg16(ks, KS_RXFCTR) >> 8) & 0xff;
>>  
>>  	netif_dbg(ks, rx_status, ks->netdev,
>>  		  "%s: %d packets\n", __func__, rxfc);
> 
> Hi Marek
> 
> This is the patch which i think it causing most problems. So why not
> add accessors ks8851_rd_rxfc_spi() and ks8851_rd_rxfc_par(), each
> doing which is optimal for each?

Because it makes no difference when I do iperf tests on current
linux-next. I think I mentioned this before a few times, but the real
performance improvement here would be gained if this whole driver was
converted to regmap and then the regmap core could merge the SPI
transfers as needed. But that is something for another series.
