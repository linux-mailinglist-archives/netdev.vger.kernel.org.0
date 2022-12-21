Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FBC1652D3D
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 08:19:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234434AbiLUHTx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 02:19:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234040AbiLUHTv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 02:19:51 -0500
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD7952DA;
        Tue, 20 Dec 2022 23:19:50 -0800 (PST)
Received: by mail-pl1-f172.google.com with SMTP id d15so14696068pls.6;
        Tue, 20 Dec 2022 23:19:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fNp8m2LDVsPPcD0Zs4UZSAN2iWMB2g5usgyu5XJskKU=;
        b=2k8H0FyG5BCMvLz13CqUFxc6tOTh7KJI2D1SQMG6F6op95HzV5tM/PHmUe1ZL+Uu/2
         U0G27vXl2t1wRAtT1wAbSWe004e9V55RpLmiq7Fsukrfqw2mJgTLAvuGX95YE1lKOosU
         iWIN6gYDU0gxhXYRwt+m6lAyGX/QE3gXc7Z5Mkpzk75Tvzh+cOJQQ1Vgtkx3oXBbp9Xf
         6cAX67EyEZpuvhqh7lCo6PIajVop0qCkPgKajufpJlm0QB3ycY4m0EFUyLbuMS950Gzx
         iF10bxpR1OePXwv/nIiDv7IW2QqmKh4gEUxI1c3J/Bgqj71KtGNyBvx29d+4avMUWO3M
         BTQQ==
X-Gm-Message-State: AFqh2kp/sLKBvvxEZEPhoE5x1Eci8ox+A7YrhlFlIYwaFLkoSYsvDRx2
        TmZxbNcKcPlQ7YSvi2/qTxddQ0GUzux2XUTP
X-Google-Smtp-Source: AMrXdXtw6/uAv+el3BR9wZ4gpSFmlVM23HDTW/M7dKePVVYWT92alwiZGoahoj62PoZwmt84AKwzfw==
X-Received: by 2002:a05:6a20:5489:b0:b0:b870:54e1 with SMTP id i9-20020a056a20548900b000b0b87054e1mr2082396pzk.12.1671607190168;
        Tue, 20 Dec 2022 23:19:50 -0800 (PST)
Received: from [192.168.219.101] ([14.4.134.166])
        by smtp.gmail.com with ESMTPSA id x12-20020a63cc0c000000b004468cb97c01sm9385928pgf.56.2022.12.20.23.19.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Dec 2022 23:19:49 -0800 (PST)
Message-ID: <2d4033ea-3034-24cf-493c-f60258f9988d@ooseel.net>
Date:   Wed, 21 Dec 2022 16:19:45 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v2] usbnet: optimize usbnet_bh() to reduce CPU load
Content-Language: en-US
To:     Greg KH <greg@kroah.com>
Cc:     Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221221044230.1012787-1-lsahn@ooseel.net>
 <Y6KoglOyuFEqfp2k@kroah.com>
From:   Leesoo Ahn <lsahn@ooseel.net>
In-Reply-To: <Y6KoglOyuFEqfp2k@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 22. 12. 21. 15:32, Greg KH wrote:
> On Wed, Dec 21, 2022 at 01:42:30PM +0900, Leesoo Ahn wrote:
>> The current source pushes skb into dev->done queue by calling
>> skb_queue_tail() and then pop it by calling skb_dequeue() to branch to
>> rx_cleanup state for freeing urb/skb in usbnet_bh(). It takes extra CPU
>> load, 2.21% (skb_queue_tail) as follows.
>>
>> -   11.58%     0.26%  swapper          [k] usbnet_bh
>>     - 11.32% usbnet_bh
>>        - 6.43% skb_dequeue
>>             6.34% _raw_spin_unlock_irqrestore
>>        - 2.21% skb_queue_tail
>>             2.19% _raw_spin_unlock_irqrestore
>>        - 1.68% consume_skb
>>           - 0.97% kfree_skbmem
>>                0.80% kmem_cache_free
>>             0.53% skb_release_data
>>
>> To reduce the extra CPU load use return values jumping to rx_cleanup
>> state directly to free them instead of calling skb_queue_tail() and
>> skb_dequeue() for push/pop respectively.
>>
>> -    7.87%     0.25%  swapper          [k] usbnet_bh
>>     - 7.62% usbnet_bh
>>        - 4.81% skb_dequeue
>>             4.74% _raw_spin_unlock_irqrestore
>>        - 1.75% consume_skb
>>           - 0.98% kfree_skbmem
>>                0.78% kmem_cache_free
>>             0.58% skb_release_data
>>          0.53% smsc95xx_rx_fixup
>>
>> Signed-off-by: Leesoo Ahn <lsahn@ooseel.net>
>> ---
>> v2:
>>    - Replace goto label with return statement to reduce goto entropy
>>    - Add CPU load information by perf in commit message
>>
>> v1 at:
>>    https://patchwork.kernel.org/project/netdevbpf/patch/20221217161851.829497-1-lsahn@ooseel.net/
>> ---
>>   drivers/net/usb/usbnet.c | 19 +++++++++----------
>>   1 file changed, 9 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
>> index 64a9a80b2309..6e82fef90dd9 100644
>> --- a/drivers/net/usb/usbnet.c
>> +++ b/drivers/net/usb/usbnet.c
>> @@ -555,32 +555,30 @@ static int rx_submit (struct usbnet *dev, struct urb *urb, gfp_t flags)
>>   
>>   /*-------------------------------------------------------------------------*/
>>   
>> -static inline void rx_process (struct usbnet *dev, struct sk_buff *skb)
>> +static inline int rx_process(struct usbnet *dev, struct sk_buff *skb)
>>   {
>>   	if (dev->driver_info->rx_fixup &&
>>   	    !dev->driver_info->rx_fixup (dev, skb)) {
>>   		/* With RX_ASSEMBLE, rx_fixup() must update counters */
>>   		if (!(dev->driver_info->flags & FLAG_RX_ASSEMBLE))
>>   			dev->net->stats.rx_errors++;
>> -		goto done;
>> +		return 1;
> "1" means that you processed 1 byte, not that this is an error, which is
> what you want to say here, right?
No not at all..
> Please return a negative error value
> like I asked this to be changed to last time :(
Could you help me to decide the message type at this point please? I am 
confused.

The return value totally depends on how rx_fixup() is. For instance, in 
smsc95xx.c, smsc95xx_rx_fixup() function returns 0 in two cases that

1) frame size is greater than ETH_FRAME_LEN(1526 bytes) as follows

  1853             /* ETH_FRAME_LEN + 4(CRC) + 2(COE) + 4(Vlan) */
  1854             if (unlikely(size > (ETH_FRAME_LEN + 12))) {
  1855                 netif_dbg(dev, rx_err, dev->net,
  1856                       "size err header=0x%08x\n", header);
  1857                 return 0;
  1858             }

2) it is failed for skb allocation, but memory?

  1870             ax_skb = skb_clone(skb, GFP_ATOMIC);
  1871             if (unlikely(!ax_skb)) {
  1872                 netdev_warn(dev->net, "Error allocating skb\n");
  1873                 return 0;
  1874             }

I guess EPROTO or ENOMEM, one of them could be the value at the point 
but I have no ideas..

Best regards,
Leesoo

