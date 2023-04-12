Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3296DE9D0
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 05:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbjDLDN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 23:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjDLDN5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 23:13:57 -0400
Received: from www381.your-server.de (www381.your-server.de [78.46.137.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 865D410F1;
        Tue, 11 Apr 2023 20:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=metafoo.de;
        s=default2002; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID;
        bh=zod9V2xsFQscz6pBYpVMwNkVtwPutEMxzbmVvqs5Dow=; b=jRbzgwB42uTEo/ukPU/+4I3Lyf
        xh0Ty85hNaPmdtO4RiR42+uyJEL/3Mgdqin41DBC2W+0vOW7I29tMqRapJfbkvkjv9G+EZGXR5EHC
        dR0tOJhSP8/03XKOXePlKbR0/LMQeySgVgmn8cwht9ajTLKxzmCf1CLbG8hmKmnzEqsI9jE82kMKA
        mWIDEtVNgtKhd1RN7ImYuepQEoG/YYqKlM0P/cymPOcXesrgVtZx32UNu+Gc6xGKgOhYYAJ1uVrNj
        5wb71JcXfyX7VVvYM+So/VFdhiQ93e3ouKoXTq+doqPespdzOMPI88CkJoi4ot0HNr6pwZh9f5pj5
        E75q+VMA==;
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www381.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <lars@metafoo.de>)
        id 1pmQvh-00021o-Mi; Wed, 12 Apr 2023 05:13:53 +0200
Received: from [2604:5500:c0e5:eb00:da5e:d3ff:feff:933b]
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <lars@metafoo.de>)
        id 1pmQvh-000TbH-CH; Wed, 12 Apr 2023 05:13:53 +0200
Message-ID: <6c025530-e2f1-955f-fa5f-8779db23edde@metafoo.de>
Date:   Tue, 11 Apr 2023 20:13:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH net] net: macb: fix a memory corruption in extended buffer
 descriptor mode
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rafal Ozieblo <rafalo@cadence.com>
References: <20230407172402.103168-1-roman.gushchin@linux.dev>
 <20230411184814.5be340a8@kernel.org>
From:   Lars-Peter Clausen <lars@metafoo.de>
In-Reply-To: <20230411184814.5be340a8@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: lars@metafoo.de
X-Virus-Scanned: Clear (ClamAV 0.103.8/26872/Tue Apr 11 09:26:30 2023)
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/11/23 18:48, Jakub Kicinski wrote:
> On Fri,  7 Apr 2023 10:24:02 -0700 Roman Gushchin wrote:
>> The problem is resolved by extending the MACB_RX_WADDR_SIZE
>> in the extended mode.
>>
>> Fixes: 7b4296148066 ("net: macb: Add support for PTP timestamps in DMA descriptors")
>> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
>> Co-developed-by: Lars-Peter Clausen <lars@metafoo.de>
>> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
>> ---
>>   drivers/net/ethernet/cadence/macb.h | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
>> index c1fc91c97cee..1b330f7cfc09 100644
>> --- a/drivers/net/ethernet/cadence/macb.h
>> +++ b/drivers/net/ethernet/cadence/macb.h
>> @@ -826,8 +826,13 @@ struct macb_dma_desc_ptp {
>>   #define MACB_RX_USED_SIZE			1
>>   #define MACB_RX_WRAP_OFFSET			1
>>   #define MACB_RX_WRAP_SIZE			1
>> +#ifdef MACB_EXT_DESC
>> +#define MACB_RX_WADDR_OFFSET			3
>> +#define MACB_RX_WADDR_SIZE			29
>> +#else
>>   #define MACB_RX_WADDR_OFFSET			2
>>   #define MACB_RX_WADDR_SIZE			30
>> +#endif
> Changing register definition based on Kconfig seems a bit old school.
>
> Where is the extended descriptor mode enabled? Is it always on if
> Kconfig is set or can it be off for some platforms based on other
> capabilities? Judging by macb_dma_desc_get_size() small descriptors
> can still be used even with EXT_DESC?
>
> If I'm grepping correctly thru the painful macro magic this register
> is only used in macb_get_addr(). It'd seem a bit more robust to me
> to open code the extraction of the address based on bp->hw_dma_cap
> in that one function.
>
> In addition to maintainers please also CC Harini Katakam
> <harini.katakam@xilinx.com> on v2.

We had an alternative patch which fixes this based on runtime settings. 
But it didn't seem to be worth it considering the runtime overhead, even 
though it is small. The skb buffer address is guaranteed to be cacheline 
aligned, otherwise the DMA wouldn't work at all. So we know that the 
LSBs must always be 0. We could even unconditionally define 
MACB_RX_WADDR_OFFSET as 3.

Alternative runtime base patch:

diff --git a/drivers/net/ethernet/cadence/macb_main.c 
b/drivers/net/ethernet/cadence/macb_main.c
index d13fb1d31821..1a40d5a26f36 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -1042,6 +1042,10 @@ static dma_addr_t macb_get_addr(struct macb *bp, 
struct macb_dma_desc *desc)
         }
  #endif
         addr |= MACB_BF(RX_WADDR, MACB_BFEXT(RX_WADDR, desc->addr));
+#ifdef CONFIG_MACB_USE_HWSTAMP
+       if (bp->hw_dma_cap & HW_DMA_CAP_PTP)
+               addr &= ~GEM_BIT(DMA_RXVALID_OFFSET);
+#endif
         return addr;
  }

