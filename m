Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00C8665605E
	for <lists+netdev@lfdr.de>; Mon, 26 Dec 2022 07:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbiLZGZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 01:25:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbiLZGZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 01:25:04 -0500
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EFC33A5;
        Sun, 25 Dec 2022 22:25:03 -0800 (PST)
Received: by mail-pl1-f173.google.com with SMTP id d3so10002798plr.10;
        Sun, 25 Dec 2022 22:25:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3HjLQD394T0N1zzJlCWkPmDMa8LBCihXMtLb1cY2QxY=;
        b=1E+viyUg/XZ8Z5CQ+SYv8X8aMw/yv5HTGDnsTC9s3EkLfXALKJt3ZdmVFGScTMklIK
         1qLtf1xmQE2zEKQYsB/DEuWFzsQkEMqUBUUndC+lWBNZNgrEJhB9jPBiSAjTMEXyWxMS
         dG3kVOg2jE/IKUChGZX5EwwMZYl0B3UbLZJ/Ff/3s+mypLwwsP2HImY6sZ6XQ9g+Jp/h
         9QtuZheSzmbBEeUOEQDT3W9mLE2OvvW/HbaJwK+Vptl1aVjgctc/U24ALTUlQKmT7GQa
         4fQ/54QWwjaOoOI8SsuCgbViaraH+cxNZp8yfeqryzxq60RaxNIdYSLfln7q9qzTF/D7
         QgKA==
X-Gm-Message-State: AFqh2kogbLqLYD7YKb79GD2NqrzIvC8XDkhlh6HzAttRW0mso78vW3ZP
        u38nAdDwxrv5hDiq0aBR/KLcJjQBAviBSw==
X-Google-Smtp-Source: AMrXdXsiFaWJunLQMje24SK02J3FZLosXdKBXBxsj3/hkBJj6hx+0hywlrB4BMWV0SIPyUZ1hNl7DA==
X-Received: by 2002:a17:902:7207:b0:189:6457:4e14 with SMTP id ba7-20020a170902720700b0018964574e14mr17765585plb.8.1672035902353;
        Sun, 25 Dec 2022 22:25:02 -0800 (PST)
Received: from [192.168.0.21] ([125.191.247.116])
        by smtp.gmail.com with ESMTPSA id o4-20020a170902d4c400b00188b5d25438sm6293402plg.35.2022.12.25.22.24.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Dec 2022 22:25:01 -0800 (PST)
Message-ID: <aa085d47-1163-6133-ed71-88eedb47dabe@ooseel.net>
Date:   Mon, 26 Dec 2022 15:24:57 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v3] usbnet: optimize usbnet_bh() to reduce CPU load
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Greg KH <greg@kroah.com>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221221075924.1141346-1-lsahn@ooseel.net>
 <070c6690ad7ea537a7081bc9faa0f78861751bc4.camel@redhat.com>
Content-Language: en-US
From:   Leesoo Ahn <lsahn@ooseel.net>
In-Reply-To: <070c6690ad7ea537a7081bc9faa0f78861751bc4.camel@redhat.com>
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



22. 12. 22. 20:13에 Paolo Abeni 이(가) 쓴 글:
> On Wed, 2022-12-21 at 16:59 +0900, Leesoo Ahn wrote:
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
>> v3:
>>    - Replace return values with proper -ERR values in rx_process()
>>
>> v2:
>>    - Replace goto label with return statement to reduce goto entropy
>>    - Add CPU load information by perf in commit message
>>
>> v1 at:
>>    https://patchwork.kernel.org/project/netdevbpf/patch/20221217161851.829497-1-lsahn@ooseel.net/
> 
> This looks like net-next material.
> 
> We have already submitted the networking pull request to Linus
> for v6.2 and therefore net-next is closed for new drivers, features,
> code refactoring and optimizations. We are currently accepting
> bug fixes only.
> 
> Please repost when net-next reopens after Jan 2nd, including the
> expected 'net-next' tag into the subject line
> 
> RFC patches sent for review only are obviously welcome at any time.
> 
> [...]
> 
>> @@ -1528,13 +1526,14 @@ static void usbnet_bh (struct timer_list *t)
>>   		entry = (struct skb_data *) skb->cb;
>>   		switch (entry->state) {
>>   		case rx_done:
>> -			entry->state = rx_cleanup;
>> -			rx_process (dev, skb);
>> +			if (rx_process(dev, skb))
>> +				goto cleanup;
> 
> You can avoid this additional label (which is a little confusing inside
> a switch) factoring out a usb_free_skb(skb) helper and calling it here
> and under the rx_cleanup case.

Thank you for the information and feedback, it will be in v4 when 
net-next reopens.

Best regards,
Leesoo
