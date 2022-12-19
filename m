Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB1A8650826
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 08:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231651AbiLSHl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 02:41:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231589AbiLSHlW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 02:41:22 -0500
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 674312AC1;
        Sun, 18 Dec 2022 23:41:21 -0800 (PST)
Received: by mail-pf1-f180.google.com with SMTP id c7so5591674pfc.12;
        Sun, 18 Dec 2022 23:41:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WBGRE1+2gVpyciRz6kal4GRgitcm3glibRbLj9MWFrg=;
        b=2v/kSswAM8b+2TpErxE8BSOZPAhqWI1Vuon6xmAYQlw2bBELAL4B0u0GdPir1Yx4FJ
         RxNlDhlkr718NVqBdG9SvFm69hmbrmjc/shiAdZh2nNSJOAXZWKfU5HGD19K2CGGMgzT
         D/TDQE5v0+PCUC8/P5Yu6y9x8Ag5GeE0TNU7l33dAbXnJ1FM0TodeIZg4t+uTBAyWQvO
         ErbHyX3UEr7s4Vmx8aHvSkBqKXwavzzJJcN3qwKykuOkfkdiriXsei0vKarnRmy6h9fe
         illwcFbw+Rp361O4t8HwvsBnam0/NWJ6Q5qiebNFuVxpCs9p5P1jKoh6DwNv5LG+ESmn
         F8LQ==
X-Gm-Message-State: ANoB5pl8iekoYEM7jJ8avVw/khoAIPKGb2fHayfZKVvc5DfSSOXGNMr/
        LIwi5jlKazp186Pt8o6xOWM=
X-Google-Smtp-Source: AA0mqf4p4ZNMgTYVqbLumGYc2FkVA3jzfFM5c5P5zjj0bpBPibwRAC6aDekK2LPz4tFQUdDkuLFiBw==
X-Received: by 2002:a05:6a00:1c81:b0:577:8bae:29a7 with SMTP id y1-20020a056a001c8100b005778bae29a7mr40469582pfw.33.1671435680895;
        Sun, 18 Dec 2022 23:41:20 -0800 (PST)
Received: from [192.168.219.108] ([14.4.134.166])
        by smtp.gmail.com with ESMTPSA id w185-20020a627bc2000000b00575d1ba0ecfsm5836772pfc.133.2022.12.18.23.41.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Dec 2022 23:41:20 -0800 (PST)
Message-ID: <a2e0e98a-1044-908a-15bc-b165ff8b23ea@ooseel.net>
Date:   Mon, 19 Dec 2022 16:41:16 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] usbnet: jump to rx_cleanup case instead of calling
 skb_queue_tail
Content-Language: en-US
To:     Greg KH <greg@kroah.com>
Cc:     Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221217161851.829497-1-lsahn@ooseel.net>
 <Y57VkLKetDsbUUjC@kroah.com>
From:   Leesoo Ahn <lsahn@ooseel.net>
In-Reply-To: <Y57VkLKetDsbUUjC@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 22. 12. 18. 17:55, Greg KH wrote:
> On Sun, Dec 18, 2022 at 01:18:51AM +0900, Leesoo Ahn wrote:
>> The current source pushes skb into dev->done queue by calling
>> skb_queue_tail() and then, call skb_dequeue() to pop for rx_cleanup state
>> to free urb and skb next in usbnet_bh().
>> It wastes CPU resource with extra instructions. Instead, use return values
>> jumping to rx_cleanup case directly to free them. Therefore calling
>> skb_queue_tail() and skb_dequeue() is not necessary.
>>
>> The follows are just showing difference between calling skb_queue_tail()
>> and using return values jumping to rx_cleanup state directly in usbnet_bh()
>> in Arm64 instructions with perf tool.
>>
>> ----------- calling skb_queue_tail() -----------
>>         │     if (!(dev->driver_info->flags & FLAG_RX_ASSEMBLE))
>>    7.58 │248:   ldr     x0, [x20, #16]
>>    2.46 │24c:   ldr     w0, [x0, #8]
>>    1.64 │250: ↑ tbnz    w0, #14, 16c
>>         │     dev->net->stats.rx_errors++;
>>    0.57 │254:   ldr     x1, [x20, #184]
>>    1.64 │258:   ldr     x0, [x1, #336]
>>    2.65 │25c:   add     x0, x0, #0x1
>>         │260:   str     x0, [x1, #336]
>>         │     skb_queue_tail(&dev->done, skb);
>>    0.38 │264:   mov     x1, x19
>>         │268:   mov     x0, x21
>>    2.27 │26c: → bl      skb_queue_tail
>>    0.57 │270: ↑ b       44    // branch to call skb_dequeue()
>>
>> ----------- jumping to rx_cleanup state -----------
>>         │     if (!(dev->driver_info->flags & FLAG_RX_ASSEMBLE))
>>    1.69 │25c:   ldr     x0, [x21, #16]
>>    4.78 │260:   ldr     w0, [x0, #8]
>>    3.28 │264: ↑ tbnz    w0, #14, e4    // jump to 'rx_cleanup' state
>>         │     dev->net->stats.rx_errors++;
>>    0.09 │268:   ldr     x1, [x21, #184]
>>    2.72 │26c:   ldr     x0, [x1, #336]
>>    3.37 │270:   add     x0, x0, #0x1
>>    0.09 │274:   str     x0, [x1, #336]
>>    0.66 │278: ↑ b       e4    // branch to 'rx_cleanup' state
> Interesting, but does this even really matter given the slow speed of
> the USB hardware?

It doesn't if USB hardware has slow speed but in software view, it's 
still worth avoiding calling skb_queue_tail() and skb_dequeue() which 
work with spinlock, if possible.


>> Signed-off-by: Leesoo Ahn <lsahn@ooseel.net>
>> ---
>>   drivers/net/usb/usbnet.c | 11 ++++++-----
>>   1 file changed, 6 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
>> index 64a9a80b2309..924392a37297 100644
>> --- a/drivers/net/usb/usbnet.c
>> +++ b/drivers/net/usb/usbnet.c
>> @@ -555,7 +555,7 @@ static int rx_submit (struct usbnet *dev, struct urb *urb, gfp_t flags)
>>   
>>   /*-------------------------------------------------------------------------*/
>>   
>> -static inline void rx_process (struct usbnet *dev, struct sk_buff *skb)
>> +static inline int rx_process(struct usbnet *dev, struct sk_buff *skb)
>>   {
>>   	if (dev->driver_info->rx_fixup &&
>>   	    !dev->driver_info->rx_fixup (dev, skb)) {
>> @@ -576,11 +576,11 @@ static inline void rx_process (struct usbnet *dev, struct sk_buff *skb)
>>   		netif_dbg(dev, rx_err, dev->net, "rx length %d\n", skb->len);
>>   	} else {
>>   		usbnet_skb_return(dev, skb);
>> -		return;
>> +		return 0;
>>   	}
>>   
>>   done:
>> -	skb_queue_tail(&dev->done, skb);
>> +	return -1;
> Don't make up error numbers, this makes it look like this failed, not
> succeeded.  And if this failed, give it a real error value.
>
> thanks,
>
> greg k-h

Best regards,
Leesoo

