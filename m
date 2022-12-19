Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 805F965086A
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 09:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbiLSIJ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 03:09:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbiLSIJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 03:09:27 -0500
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1703362D2;
        Mon, 19 Dec 2022 00:09:26 -0800 (PST)
Received: by mail-pg1-f180.google.com with SMTP id w37so5650141pga.5;
        Mon, 19 Dec 2022 00:09:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A3yf0KS/FP0thjxq563bdYl/LLOFgjmgJm4mPBjDh+U=;
        b=vB06uoUCjCNuSxlG8wnY9I+42x3b6yCrax3FE7yJ3iI9HUtTiEMeTmMiKwxS1UlefF
         aL7MlKa3S3C+f02/x1TnK8FktGUHxfp3veHa4FiXsHCME7PmRzxdUPc+en9wBlhrOEU1
         6gw3e3364OsAObAuyFzL+djOmmjel/Onn0sEHRBCEjMrvUL8rOWMQC36KIWinQkjnUn5
         VlBYqbchGM1JRb+nkoDAphHwnC3htVp11+Fi27ASR0pdWloFcPbhx2MDyKbrPeYLyMo+
         O9nsB2uy7y5lCcztanVCwN2LUhnUPi2/3l82KZbgQupcU/r8NphUAM6Sq8GhXD+f0Q8F
         IGDw==
X-Gm-Message-State: ANoB5pnb5Xywhemhpa2+OtqSOpEeux/ycx5Z58Lou9udur5PrBDp5zf/
        2ZDEO7R1hSHLBTeAuVe4tXg=
X-Google-Smtp-Source: AA0mqf4H0gtMj6oWuz+nKGu4Zj9+L0sGeSxNQIbpGC17bYZwlG9YG0ee5hNFJ6n0IXhIBLrnTmZGfw==
X-Received: by 2002:a62:17d5:0:b0:577:2a9:ec82 with SMTP id 204-20020a6217d5000000b0057702a9ec82mr37369305pfx.5.1671437365558;
        Mon, 19 Dec 2022 00:09:25 -0800 (PST)
Received: from [192.168.219.108] ([14.4.134.166])
        by smtp.gmail.com with ESMTPSA id 62-20020a621641000000b00574afdc0391sm6066785pfw.174.2022.12.19.00.09.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Dec 2022 00:09:24 -0800 (PST)
Message-ID: <403f3ea8-eeec-2a78-640e-c11c3fe28f45@ooseel.net>
Date:   Mon, 19 Dec 2022 17:09:21 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] usbnet: jump to rx_cleanup case instead of calling
 skb_queue_tail
To:     Greg KH <greg@kroah.com>
Cc:     Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221217161851.829497-1-lsahn@ooseel.net>
 <Y57VkLKetDsbUUjC@kroah.com>
 <a2e0e98a-1044-908a-15bc-b165ff8b23ea@ooseel.net>
 <Y6AXqOlCUy7mahgj@kroah.com>
Content-Language: en-US
From:   Leesoo Ahn <lsahn@ooseel.net>
In-Reply-To: <Y6AXqOlCUy7mahgj@kroah.com>
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


On 22. 12. 19. 16:50, Greg KH wrote:
> On Mon, Dec 19, 2022 at 04:41:16PM +0900, Leesoo Ahn wrote:
>> On 22. 12. 18. 17:55, Greg KH wrote:
>>> On Sun, Dec 18, 2022 at 01:18:51AM +0900, Leesoo Ahn wrote:
>>>> The current source pushes skb into dev->done queue by calling
>>>> skb_queue_tail() and then, call skb_dequeue() to pop for rx_cleanup state
>>>> to free urb and skb next in usbnet_bh().
>>>> It wastes CPU resource with extra instructions. Instead, use return values
>>>> jumping to rx_cleanup case directly to free them. Therefore calling
>>>> skb_queue_tail() and skb_dequeue() is not necessary.
>>>>
>>>> The follows are just showing difference between calling skb_queue_tail()
>>>> and using return values jumping to rx_cleanup state directly in usbnet_bh()
>>>> in Arm64 instructions with perf tool.
>>>>
>>>> ----------- calling skb_queue_tail() -----------
>>>>          │     if (!(dev->driver_info->flags & FLAG_RX_ASSEMBLE))
>>>>     7.58 │248:   ldr     x0, [x20, #16]
>>>>     2.46 │24c:   ldr     w0, [x0, #8]
>>>>     1.64 │250: ↑ tbnz    w0, #14, 16c
>>>>          │     dev->net->stats.rx_errors++;
>>>>     0.57 │254:   ldr     x1, [x20, #184]
>>>>     1.64 │258:   ldr     x0, [x1, #336]
>>>>     2.65 │25c:   add     x0, x0, #0x1
>>>>          │260:   str     x0, [x1, #336]
>>>>          │     skb_queue_tail(&dev->done, skb);
>>>>     0.38 │264:   mov     x1, x19
>>>>          │268:   mov     x0, x21
>>>>     2.27 │26c: → bl      skb_queue_tail
>>>>     0.57 │270: ↑ b       44    // branch to call skb_dequeue()
>>>>
>>>> ----------- jumping to rx_cleanup state -----------
>>>>          │     if (!(dev->driver_info->flags & FLAG_RX_ASSEMBLE))
>>>>     1.69 │25c:   ldr     x0, [x21, #16]
>>>>     4.78 │260:   ldr     w0, [x0, #8]
>>>>     3.28 │264: ↑ tbnz    w0, #14, e4    // jump to 'rx_cleanup' state
>>>>          │     dev->net->stats.rx_errors++;
>>>>     0.09 │268:   ldr     x1, [x21, #184]
>>>>     2.72 │26c:   ldr     x0, [x1, #336]
>>>>     3.37 │270:   add     x0, x0, #0x1
>>>>     0.09 │274:   str     x0, [x1, #336]
>>>>     0.66 │278: ↑ b       e4    // branch to 'rx_cleanup' state
>>> Interesting, but does this even really matter given the slow speed of
>>> the USB hardware?
>> It doesn't if USB hardware has slow speed but in software view, it's still
>> worth avoiding calling skb_queue_tail() and skb_dequeue() which work with
>> spinlock, if possible.
> But can you actually measure that in either CPU load or in increased
> transfer speeds?
>
> thanks,
>
> greg k-h

I think the follows are maybe what you would be interested in. I have 
tested both case with perf on the same machine and environments, also 
modified driver code a bit to go to rx_cleanup case, not to net stack in 
a specific packet.

----- calling skb_queue_tail() -----
-   11.58%     0.26%  swapper          [k] usbnet_bh
    - 11.32% usbnet_bh
       - 6.43% skb_dequeue
            6.34% _raw_spin_unlock_irqrestore
       - 2.21% skb_queue_tail
            2.19% _raw_spin_unlock_irqrestore
       - 1.68% consume_skb
          - 0.97% kfree_skbmem
               0.80% kmem_cache_free
            0.53% skb_release_data

----- jump to rx_cleanup directly -----
-    7.62%     0.18%  swapper          [k] usbnet_bh
    - 7.44% usbnet_bh
       - 4.63% skb_dequeue
            4.57% _raw_spin_unlock_irqrestore
       - 1.76% consume_skb
          - 1.03% kfree_skbmem
               0.86% kmem_cache_free
            0.56% skb_release_data
         0.54% smsc95xx_rx_fixup

The first case takes CPU resource a bit much by the result.

Thank you for reviewing, by the way.

Best regards,
Leesoo



