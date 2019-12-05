Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05C80113FA5
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 11:48:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729259AbfLEKsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 05:48:54 -0500
Received: from lelv0143.ext.ti.com ([198.47.23.248]:56228 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726384AbfLEKsy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 05:48:54 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id xB5Amp3N018249;
        Thu, 5 Dec 2019 04:48:51 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1575542931;
        bh=Yr1ap4SSHWog4tXt53WGnFZBb6L+rohICVNxJP+6XvA=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=dk7COAeFm+rSgjWH50v8Xmtr67h23FLzwE34kZzIGQQ3Zjlx22fvda2x585Eo17+2
         4rj5AgOWVRNb+R4ZW6QLmMZURrzsyIhhhzVWzO938dD5eEizFG2MjGFKuhPh7q4aDy
         PN5wPhqq5ANvwAE8Phqey5B6GAWpq1zAGUqiSnoI=
Received: from DLEE108.ent.ti.com (dlee108.ent.ti.com [157.170.170.38])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xB5AmpIU127780
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 5 Dec 2019 04:48:51 -0600
Received: from DLEE105.ent.ti.com (157.170.170.35) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Thu, 5 Dec
 2019 04:48:51 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Thu, 5 Dec 2019 04:48:51 -0600
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id xB5AmmcB107536;
        Thu, 5 Dec 2019 04:48:49 -0600
Subject: Re: [PATCH v2] net: ethernet: ti: davinci_cpdma: fix warning "device
 driver frees DMA memory with different size"
To:     David Miller <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <ivan.khoronzhuk@linaro.org>,
        <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>
References: <20191204165029.9264-1-grygorii.strashko@ti.com>
 <20191204.123718.1152659362924451799.davem@davemloft.net>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <0c6b88b2-31b1-11f0-7baa-1ecd5f4b6644@ti.com>
Date:   Thu, 5 Dec 2019 12:48:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191204.123718.1152659362924451799.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 04/12/2019 22:37, David Miller wrote:
> From: Grygorii Strashko <grygorii.strashko@ti.com>
> Date: Wed, 4 Dec 2019 18:50:29 +0200
> 
>> @@ -1018,7 +1018,7 @@ static int cpdma_chan_submit_si(struct submit_info *si)
>>   	struct cpdma_chan		*chan = si->chan;
>>   	struct cpdma_ctlr		*ctlr = chan->ctlr;
>>   	int				len = si->len;
>> -	int				swlen = len;
>> +	int				swlen;
>>   	struct cpdma_desc __iomem	*desc;
>>   	dma_addr_t			buffer;
>>   	u32				mode;
>> @@ -1040,6 +1040,7 @@ static int cpdma_chan_submit_si(struct submit_info *si)
>>   		chan->stats.runt_transmit_buff++;
>>   	}
>>   
>> +	swlen = len;
>>   	mode = CPDMA_DESC_OWNER | CPDMA_DESC_SOP | CPDMA_DESC_EOP;
>>   	cpdma_desc_to_port(chan, mode, si->directed);
>>   
>> -- 
>> 2.17.1
>>
> 
> Now there is no reason to keep a separate swlen variable.
> 
> The integral value is always consumed as the length before the descriptor bits
> are added to it.
> 
> Therefore you can just use 'len' everywhere in this function now.
> 

Sry, but seems i can't, at least i can't just drop swlen.

Below in this function:
	writel_relaxed(0, &desc->hw_next);
	writel_relaxed(buffer, &desc->hw_buffer);
	writel_relaxed(len, &desc->hw_len);
	writel_relaxed(mode | len, &desc->hw_mode);
^^ here the "len" should be use

	writel_relaxed((uintptr_t)si->token, &desc->sw_token);
	writel_relaxed(buffer, &desc->sw_buffer);
	writel_relaxed(swlen, &desc->sw_len);
^^ and here "len"|CPDMA_DMA_EXT_MAP if (si->data_dma) [1]

	desc_read(desc, sw_len);

so additional if statement has to be added at [1] if "swlen" is dropped

-- 
Best regards,
grygorii
