Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF6D5F41E3
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 13:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbiJDLV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 07:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiJDLV6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 07:21:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 009F4286F7
        for <netdev@vger.kernel.org>; Tue,  4 Oct 2022 04:21:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664882515;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TdrzGR8b2o0PMyri4IUewO1nY7AXkHC5c0JZN4P78VE=;
        b=C3dHXQN/EOsogNceJ540EHsUTCv5CLfvita8mbnT6E28/Ts3zMEZFNK6k7Qh1o1gjIJAZo
        ihPBz5y+BzP+Y78K/5KaJ1hBnk871EUMV1GFV5cH0L8M9/1grbEaaIeYPZbkDtQamzQk1W
        hcPqGx5B+XqjMqPmioOnasuwC3Fge9w=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-269-8pjCv7_gP5CiZmpZdino-w-1; Tue, 04 Oct 2022 07:21:53 -0400
X-MC-Unique: 8pjCv7_gP5CiZmpZdino-w-1
Received: by mail-ed1-f72.google.com with SMTP id i17-20020a05640242d100b0044f18a5379aso11065330edc.21
        for <netdev@vger.kernel.org>; Tue, 04 Oct 2022 04:21:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date;
        bh=TdrzGR8b2o0PMyri4IUewO1nY7AXkHC5c0JZN4P78VE=;
        b=639HiWocVmq+UFcZblgWID1x02KFuiD6SsLMXPMZw4E0X8WX9SNqo2y26C/jMRvzuq
         c+yTf4cAq/9K7R5lELsELvu8a4sBFd8AmZFrdf/5wABXOxMZ7EsFskyICWuxw9cS0Tcb
         ENcvdb/SkCjRnftrCjoKopTbGuc71S0DOdfUeN9o64CMczbyFQH4nbpl1+LgMu/z7mvf
         zPIEwIXYdS55hKACVLT3ZQuoskwVjnflVLvKjETt0lSN7wATQEvQm5INCTcL1G7QP0Aa
         C+C0wAeWvhDk2urmd7q8IfOt+wfBTjS3BqmYW6nBMmrDx2o7/Z1H4bv1d+ojd6eMB5Dy
         09HQ==
X-Gm-Message-State: ACrzQf09oKos3uGwL5ds6GVQ9JUMQ7b6UCyVXqZj9PnlpyEQFTUeyOP8
        XuyWWxV5x1IxbW2BvhGzaWtz/07rvvaRtWW29LeRXtLPoeOR/t/1M0/zKBktidil2N/PuY1lhM2
        tIJMpv2ko02Fx0iH0
X-Received: by 2002:a17:907:9493:b0:78d:1eca:1cda with SMTP id dm19-20020a170907949300b0078d1eca1cdamr799715ejc.407.1664882512757;
        Tue, 04 Oct 2022 04:21:52 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6rSat7HfiZZunmN6Y5g1Zjqz7Yj6M9P32x+DCZ3aKHZqKFVbkjH8w6Uvd28EgTsY+ojosOmg==
X-Received: by 2002:a17:907:9493:b0:78d:1eca:1cda with SMTP id dm19-20020a170907949300b0078d1eca1cdamr799694ejc.407.1664882512532;
        Tue, 04 Oct 2022 04:21:52 -0700 (PDT)
Received: from [192.168.41.81] (83-90-141-187-cable.dk.customer.tdc.net. [83.90.141.187])
        by smtp.gmail.com with ESMTPSA id z10-20020a50eb4a000000b0044e01e2533asm1494358edp.43.2022.10.04.04.21.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Oct 2022 04:21:51 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <4f7cf74d-95ca-f93f-7328-e0386348a06e@redhat.com>
Date:   Tue, 4 Oct 2022 13:21:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Cc:     brouer@redhat.com, Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "imx@lists.linux.dev" <imx@lists.linux.dev>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: Re: [EXT] Re: [PATCH 1/1] net: fec: add initial XDP support
Content-Language: en-US
To:     Shenwei Wang <shenwei.wang@nxp.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Andrew Lunn <andrew@lunn.ch>
References: <20220928152509.141490-1-shenwei.wang@nxp.com>
 <YzT2An2J5afN1w3L@lunn.ch>
 <PAXPR04MB9185141B58499FD00C43BB6889579@PAXPR04MB9185.eurprd04.prod.outlook.com>
 <YzWcI+U1WYJuZIdk@lunn.ch>
 <PAXPR04MB918545B92E493CB57CDE612B89579@PAXPR04MB9185.eurprd04.prod.outlook.com>
 <ae658987-8763-c6de-7198-1a418e4728b4@redhat.com>
 <PAXPR04MB918584422BE4ECAF79C0295A89579@PAXPR04MB9185.eurprd04.prod.outlook.com>
 <afb652db-05fc-d3d6-6774-bfd9830414d9@redhat.com>
 <PAXPR04MB9185743919EC6DDA54FAC3B7895B9@PAXPR04MB9185.eurprd04.prod.outlook.com>
In-Reply-To: <PAXPR04MB9185743919EC6DDA54FAC3B7895B9@PAXPR04MB9185.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 03/10/2022 14.49, Shenwei Wang wrote:
> Hi Jesper,
> 
>>>> On mvneta driver/platform we saw huge speedup replacing:
>>>>
>>>>      page_pool_release_page(rxq->page_pool, page); with
>>>>      skb_mark_for_recycle(skb);
>>>>
> 
> After replacing the page_pool_release_page with the
> skb_mark_for_recycle, I found something confused me a little in the
> testing result. >
> I tested with the sample app of "xdpsock" under two modes: 
>  1. Native (xdpsock -i eth0). 
>  2. Skb-mode (xdpsock -S -i eth0).
Great that you are also testing AF_XDP, but do you have a particular
use-case that needs AF_XDP on this board?

What packet size are used in below results?

> The following are the testing result:
 >
>       With page_pool_release_page (pps)  With skb_mark_for_recycle (pps)
> 
>   SKB-Mode                          90K                            200K
>   Native                           190K                            190K
> 

The default AF_XDP test with xdpsock is rxdrop IIRC.

Can you test the normal XDP code path and do a XDP_DROP test via the
samples tool 'xdp_rxq_info' and cmdline:

   sudo ./xdp_rxq_info --dev eth42 --act XDP_DROP --read

And then same with --skb-mode

> The skb_mark_for_recycle solution boosted the performance of SKB-Mode
> to 200K+ PPS. That is even higher than the performance of Native
> solution.  Is this result reasonable? Do you have any clue why the
> SKB-Mode performance can go higher than that of Native one?
I might be able to explain this (Cc. AF_XDP maintainers to keep me honest).

When you say "native" *AF_XDP* that isn't Zero-Copy AF_XDP.

Sure, XDP runs in native driver mode and redirects the raw frames into 
the AF_XDP socket, but as this isn't zero-copy AF_XDP. Thus, the packets 
needs to be copied into the AF_XDP buffers.

As soon as the frame or SKB (for generic XDP) have been copied it is 
released/freed by AF_XDP/xsk code (either via xdp_return_buff() or 
consume_skb()). Thus, it looks like it really pays off to recycle the 
frame via page_pool, also for the SKB consume_skb() case.

I am still a little surprised that to can be faster than native AF_XDP, 
as the SKB-mode ("XDP-generic") needs to call through lot more software 
layers and convert the SKB to look like an xdp_buff.

--Jesper



>> -----Original Message-----
>> From: Jesper Dangaard Brouer <jbrouer@redhat.com>
>> Sent: Thursday, September 29, 2022 1:55 PM
>> To: Shenwei Wang <shenwei.wang@nxp.com>; Jesper Dangaard Brouer
>> <jbrouer@redhat.com>; Andrew Lunn <andrew@lunn.ch>
>> Cc: brouer@redhat.com; Joakim Zhang <qiangqing.zhang@nxp.com>; David S.
>> Miller <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>; Jakub
>> Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; Alexei
>> Starovoitov <ast@kernel.org>; Daniel Borkmann <daniel@iogearbox.net>;
>> Jesper Dangaard Brouer <hawk@kernel.org>; John Fastabend
>> <john.fastabend@gmail.com>; netdev@vger.kernel.org; linux-
>> kernel@vger.kernel.org; imx@lists.linux.dev
>> Subject: Re: [EXT] Re: [PATCH 1/1] net: fec: add initial XDP support
>>
>> Caution: EXT Email
>>
>> On 29/09/2022 17.52, Shenwei Wang wrote:
>>>
>>>> From: Jesper Dangaard Brouer <jbrouer@redhat.com>
>>>>
>>>> On 29/09/2022 15.26, Shenwei Wang wrote:
>>>>>
>>>>>> From: Andrew Lunn <andrew@lunn.ch>
>>>>>> Sent: Thursday, September 29, 2022 8:23 AM
>>>> [...]
>>>>>>
>>>>>>> I actually did some compare testing regarding the page pool for
>>>>>>> normal traffic.  So far I don't see significant improvement in the
>>>>>>> current implementation. The performance for large packets improves
>>>>>>> a little, and the performance for small packets get a little worse.
>>>>>>
>>>>>> What hardware was this for? imx51? imx6? imx7 Vybrid? These all use the
>> FEC.
>>>>>
>>>>> I tested on imx8qxp platform. It is ARM64.
>>>>
>>>> On mvneta driver/platform we saw huge speedup replacing:
>>>>
>>>>      page_pool_release_page(rxq->page_pool, page); with
>>>>      skb_mark_for_recycle(skb);
>>>>
>>>> As I mentioned: Today page_pool have SKB recycle support (you might
>>>> have looked at drivers that didn't utilize this yet), thus you don't
>>>> need to release the page (page_pool_release_page) here.  Instead you
>>>> could simply mark the SKB for recycling, unless driver does some page refcnt
>> tricks I didn't notice.
>>>>
>>>> On the mvneta driver/platform the DMA unmap (in
>>>> page_pool_release_page) was very expensive. This imx8qxp platform
>>>> might have faster DMA unmap in case is it cache-coherent.
>>>>
>>>> I would be very interested in knowing if skb_mark_for_recycle() helps
>>>> on this platform, for normal network stack performance.
>>>>
>>>
>>> Did a quick compare testing for the following 3 scenarios:
>>
>> Thanks for doing this! :-)
>>
>>> 1. original implementation
>>>
>>> shenwei@5810:~$ iperf -c 10.81.16.245 -w 2m -i 1
>>> ------------------------------------------------------------
>>> Client connecting to 10.81.16.245, TCP port 5001 TCP window size:  416
>>> KByte (WARNING: requested 1.91 MByte)
>>> ------------------------------------------------------------
>>> [  1] local 10.81.17.20 port 49154 connected with 10.81.16.245 port 5001
>>> [ ID] Interval       Transfer     Bandwidth
>>> [  1] 0.0000-1.0000 sec   104 MBytes   868 Mbits/sec
>>> [  1] 1.0000-2.0000 sec   105 MBytes   878 Mbits/sec
>>> [  1] 2.0000-3.0000 sec   105 MBytes   881 Mbits/sec
>>> [  1] 3.0000-4.0000 sec   105 MBytes   879 Mbits/sec
>>> [  1] 4.0000-5.0000 sec   105 MBytes   878 Mbits/sec
>>> [  1] 5.0000-6.0000 sec   105 MBytes   878 Mbits/sec
>>> [  1] 6.0000-7.0000 sec   104 MBytes   875 Mbits/sec
>>> [  1] 7.0000-8.0000 sec   104 MBytes   875 Mbits/sec
>>> [  1] 8.0000-9.0000 sec   104 MBytes   873 Mbits/sec
>>> [  1] 9.0000-10.0000 sec   104 MBytes   875 Mbits/sec
>>> [  1] 0.0000-10.0073 sec  1.02 GBytes   875 Mbits/sec
>>>
>>> 2. Page pool with page_pool_release_page
>>>
>>> shenwei@5810:~$ iperf -c 10.81.16.245 -w 2m -i 1
>>> ------------------------------------------------------------
>>> Client connecting to 10.81.16.245, TCP port 5001 TCP window size:  416
>>> KByte (WARNING: requested 1.91 MByte)
>>> ------------------------------------------------------------
>>> [  1] local 10.81.17.20 port 35924 connected with 10.81.16.245 port 5001
>>> [ ID] Interval       Transfer     Bandwidth
>>> [  1] 0.0000-1.0000 sec   101 MBytes   849 Mbits/sec
>>> [  1] 1.0000-2.0000 sec   102 MBytes   860 Mbits/sec
>>> [  1] 2.0000-3.0000 sec   102 MBytes   860 Mbits/sec
>>> [  1] 3.0000-4.0000 sec   102 MBytes   859 Mbits/sec
>>> [  1] 4.0000-5.0000 sec   103 MBytes   863 Mbits/sec
>>> [  1] 5.0000-6.0000 sec   103 MBytes   864 Mbits/sec
>>> [  1] 6.0000-7.0000 sec   103 MBytes   863 Mbits/sec
>>> [  1] 7.0000-8.0000 sec   103 MBytes   865 Mbits/sec
>>> [  1] 8.0000-9.0000 sec   103 MBytes   862 Mbits/sec
>>> [  1] 9.0000-10.0000 sec   102 MBytes   856 Mbits/sec
>>> [  1] 0.0000-10.0246 sec  1.00 GBytes   858 Mbits/sec
>>>
>>>
>>> 3. page pool with skb_mark_for_recycle
>>>
>>> shenwei@5810:~$ iperf -c 10.81.16.245 -w 2m -i 1
>>> ------------------------------------------------------------
>>> Client connecting to 10.81.16.245, TCP port 5001 TCP window size:  416
>>> KByte (WARNING: requested 1.91 MByte)
>>> ------------------------------------------------------------
>>> [  1] local 10.81.17.20 port 42724 connected with 10.81.16.245 port 5001
>>> [ ID] Interval       Transfer     Bandwidth
>>> [  1] 0.0000-1.0000 sec   111 MBytes   931 Mbits/sec
>>> [  1] 1.0000-2.0000 sec   112 MBytes   935 Mbits/sec
>>> [  1] 2.0000-3.0000 sec   111 MBytes   934 Mbits/sec
>>> [  1] 3.0000-4.0000 sec   111 MBytes   934 Mbits/sec
>>> [  1] 4.0000-5.0000 sec   111 MBytes   934 Mbits/sec
>>> [  1] 5.0000-6.0000 sec   112 MBytes   935 Mbits/sec
>>> [  1] 6.0000-7.0000 sec   111 MBytes   934 Mbits/sec
>>> [  1] 7.0000-8.0000 sec   111 MBytes   933 Mbits/sec
>>> [  1] 8.0000-9.0000 sec   112 MBytes   935 Mbits/sec
>>> [  1] 9.0000-10.0000 sec   111 MBytes   933 Mbits/sec
>>> [  1] 0.0000-10.0069 sec  1.09 GBytes   934 Mbits/sec
>>
>> This is a very significant performance improvement (page pool with
>> skb_mark_for_recycle).  This is very close to the max goodput for a 1Gbit/s link.
>>
>>
>>> For small packet size (64 bytes), all three cases have almost the same result:
>>>
>>
>> To me this indicate, that the DMA map/unmap operations on this platform are
>> indeed more expensive on larger packets.  Given this is what page_pool does,
>> keeping the DMA mapping intact when recycling.
>>
>> Driver still need DMA-sync, although I notice you set page_pool feature flag
>> PP_FLAG_DMA_SYNC_DEV, this is good as page_pool will try to reduce sync size
>> where possible. E.g. in this SKB case will reduce the DMA-sync to the
>> max_len=FEC_ENET_RX_FRSIZE which should also help on performance.
>>
>>
>>> shenwei@5810:~$ iperf -c 10.81.16.245 -w 2m -i 1 -l 64
>>> ------------------------------------------------------------
>>> Client connecting to 10.81.16.245, TCP port 5001 TCP window size:  416
>>> KByte (WARNING: requested 1.91 MByte)
>>> ------------------------------------------------------------
>>> [  1] local 10.81.17.20 port 58204 connected with 10.81.16.245 port 5001
>>> [ ID] Interval       Transfer     Bandwidth
>>> [  1] 0.0000-1.0000 sec  36.9 MBytes   309 Mbits/sec
>>> [  1] 1.0000-2.0000 sec  36.6 MBytes   307 Mbits/sec
>>> [  1] 2.0000-3.0000 sec  36.6 MBytes   307 Mbits/sec
>>> [  1] 3.0000-4.0000 sec  36.5 MBytes   307 Mbits/sec
>>> [  1] 4.0000-5.0000 sec  37.1 MBytes   311 Mbits/sec
>>> [  1] 5.0000-6.0000 sec  37.2 MBytes   312 Mbits/sec
>>> [  1] 6.0000-7.0000 sec  37.1 MBytes   311 Mbits/sec
>>> [  1] 7.0000-8.0000 sec  37.1 MBytes   311 Mbits/sec
>>> [  1] 8.0000-9.0000 sec  37.1 MBytes   312 Mbits/sec
>>> [  1] 9.0000-10.0000 sec  37.2 MBytes   312 Mbits/sec
>>> [  1] 0.0000-10.0097 sec   369 MBytes   310 Mbits/sec
>>>
>>> Regards,
>>> Shenwei
>>>
>>>
>>>>>> By small packets, do you mean those under the copybreak limit?
>>>>>>
>>>>>> Please provide some benchmark numbers with your next patchset.
>>>>>
>>>>> Yes, the packet size is 64 bytes and it is under the copybreak limit.
>>>>> As the impact is not significant, I would prefer to remove the
>>>>> copybreak  logic.
>>>>
>>>> +1 to removing this logic if possible, due to maintenance cost.
>>>>
>>>> --Jesper
>>>
> 

