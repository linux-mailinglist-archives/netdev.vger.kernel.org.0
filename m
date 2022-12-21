Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 909F3652D76
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 08:50:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234180AbiLUHur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 02:50:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbiLUHup (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 02:50:45 -0500
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7980EC63;
        Tue, 20 Dec 2022 23:50:44 -0800 (PST)
Received: by mail-pf1-f179.google.com with SMTP id n3so10113210pfq.10;
        Tue, 20 Dec 2022 23:50:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fm64jsD+iWiv+aI/tC+mxgZxQxDAC4CvvxRTJ+o+uJo=;
        b=P0Ff1ojAijGuyblJATXCV8BcJ0El6NYxoPC2xbF/xnNY+3jyClITLlyCFc+ACuJxN+
         pd7rFg9i9b2RAKwOwz6O6aQo81ujU1o6JREwpSb1pTETCooGHJ61tqkNOUoi80lJIzQW
         d3T1zDOo7gDl+wIPUvfuiwgOw8utBOLhb+8uWTr/5iTkaca6C5eZJmtN6PjpZrHXGrUX
         P/R5cp6ox/CiPF7rkbg7M/fhgt0nazGQEOC2TkL/4ltP1hVhVFfVYxtPAHLuVND+38xf
         wx7lAoQE/Shensw9DCHqW0YvlHU4v1Fu0hyvVE8X82tKfVIuiHvA/nlMc1xif3qDSNsc
         DtNw==
X-Gm-Message-State: AFqh2kqLZBRp9E+pNekyEWocYm46BRIMAI/n1sFYacWzPBjIYbUEARnz
        AgXVYNf4KalZagUaVMAK5jU=
X-Google-Smtp-Source: AMrXdXvLRfsaX2xHMWECnLkzz/psqXO/pwcUVFysseXXM0MQkLGP4IhPZsNqxQaW8UfCZHbvjyFpxw==
X-Received: by 2002:aa7:9254:0:b0:572:6e9b:9f9e with SMTP id 20-20020aa79254000000b005726e9b9f9emr1538319pfp.19.1671609043759;
        Tue, 20 Dec 2022 23:50:43 -0800 (PST)
Received: from [192.168.219.101] ([14.4.134.166])
        by smtp.gmail.com with ESMTPSA id y12-20020aa78f2c000000b00572c12a1e91sm9941627pfr.48.2022.12.20.23.50.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Dec 2022 23:50:43 -0800 (PST)
Message-ID: <1ba25d2e-6b46-dd8d-60d9-99cf2e7cd897@ooseel.net>
Date:   Wed, 21 Dec 2022 16:50:39 +0900
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
 <2d4033ea-3034-24cf-493c-f60258f9988d@ooseel.net>
 <Y6K2L+t5NjK/3ipj@kroah.com>
From:   Leesoo Ahn <lsahn@ooseel.net>
In-Reply-To: <Y6K2L+t5NjK/3ipj@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 22. 12. 21. 16:30, Greg KH wrote:
> On Wed, Dec 21, 2022 at 04:19:45PM +0900, Leesoo Ahn wrote:
>> On 22. 12. 21. 15:32, Greg KH wrote:
>>> On Wed, Dec 21, 2022 at 01:42:30PM +0900, Leesoo Ahn wrote:
>>>> The current source pushes skb into dev->done queue by calling
>>>> skb_queue_tail() and then pop it by calling skb_dequeue() to branch to
>>>> rx_cleanup state for freeing urb/skb in usbnet_bh(). It takes extra CPU
>>>> load, 2.21% (skb_queue_tail) as follows.
>>>>
>>>> -   11.58%     0.26%  swapper          [k] usbnet_bh
>>>>      - 11.32% usbnet_bh
>>>>         - 6.43% skb_dequeue
>>>>              6.34% _raw_spin_unlock_irqrestore
>>>>         - 2.21% skb_queue_tail
>>>>              2.19% _raw_spin_unlock_irqrestore
>>>>         - 1.68% consume_skb
>>>>            - 0.97% kfree_skbmem
>>>>                 0.80% kmem_cache_free
>>>>              0.53% skb_release_data
>>>>
>>>> To reduce the extra CPU load use return values jumping to rx_cleanup
>>>> state directly to free them instead of calling skb_queue_tail() and
>>>> skb_dequeue() for push/pop respectively.
>>>>
>>>> -    7.87%     0.25%  swapper          [k] usbnet_bh
>>>>      - 7.62% usbnet_bh
>>>>         - 4.81% skb_dequeue
>>>>              4.74% _raw_spin_unlock_irqrestore
>>>>         - 1.75% consume_skb
>>>>            - 0.98% kfree_skbmem
>>>>                 0.78% kmem_cache_free
>>>>              0.58% skb_release_data
>>>>           0.53% smsc95xx_rx_fixup
>>>>
>>>> Signed-off-by: Leesoo Ahn <lsahn@ooseel.net>
>>>> ---
>>>> v2:
>>>>     - Replace goto label with return statement to reduce goto entropy
>>>>     - Add CPU load information by perf in commit message
>>>>
>>>> v1 at:
>>>>     https://patchwork.kernel.org/project/netdevbpf/patch/20221217161851.829497-1-lsahn@ooseel.net/
>>>> ---
>>>>    drivers/net/usb/usbnet.c | 19 +++++++++----------
>>>>    1 file changed, 9 insertions(+), 10 deletions(-)
>>>>
>>>> diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
>>>> index 64a9a80b2309..6e82fef90dd9 100644
>>>> --- a/drivers/net/usb/usbnet.c
>>>> +++ b/drivers/net/usb/usbnet.c
>>>> @@ -555,32 +555,30 @@ static int rx_submit (struct usbnet *dev, struct urb *urb, gfp_t flags)
>>>>    /*-------------------------------------------------------------------------*/
>>>> -static inline void rx_process (struct usbnet *dev, struct sk_buff *skb)
>>>> +static inline int rx_process(struct usbnet *dev, struct sk_buff *skb)
>>>>    {
>>>>    	if (dev->driver_info->rx_fixup &&
>>>>    	    !dev->driver_info->rx_fixup (dev, skb)) {
>>>>    		/* With RX_ASSEMBLE, rx_fixup() must update counters */
>>>>    		if (!(dev->driver_info->flags & FLAG_RX_ASSEMBLE))
>>>>    			dev->net->stats.rx_errors++;
>>>> -		goto done;
>>>> +		return 1;
>>> "1" means that you processed 1 byte, not that this is an error, which is
>>> what you want to say here, right?
>> No not at all..
>>> Please return a negative error value
>>> like I asked this to be changed to last time :(
>> Could you help me to decide the message type at this point please? I am
>> confused.
> I do not know, pick something that seems correct and we can go from
> there.  The important thing is that it is a -ERR value, not a positive
> one as that makes no sense for kernel functions.

Thank you for reviewing, v3 will be sent soon.

Best regards,
Leesoo

