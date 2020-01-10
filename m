Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97D6F1376AD
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 20:07:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbgAJTHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 14:07:36 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38857 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727242AbgAJTHg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 14:07:36 -0500
Received: by mail-pf1-f196.google.com with SMTP id x185so1570869pfc.5
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 11:07:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ysp0gXCZjlQdMKlmRPDxwx6Z/Tsiwkp04c2bB0niooI=;
        b=Gpq87b0ae4DT8e/AHLEUi0rnQ7sHKefAe5kDO7ukuOWrgfftqjAZcSZ/DStBD+g2fc
         pGiVGrmMIDgL48mqdgof9teqDCW97Ea1QJdQvwYbCHkxcoGA/UH3qPtU616oqBeRvSPI
         jwEv1WFwQFuNjfwDDYz5/tXnCRU6mHPEOTFje4s7KDNE310h/aSmNGKVga3Kd1FRXkrc
         NSWr4StxfPaeRwS7OR6GhlP2X1gmBRY6kWaB4KWU+bDyzbsOKrjDgw5TLQsHr5nKPpTb
         CK8+vnC6jKrY7SwsjtavigIz20XpTzb9HPB8WTxPn5nctQDx1qErxTRFAnNDAlwAHMiS
         XZbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ysp0gXCZjlQdMKlmRPDxwx6Z/Tsiwkp04c2bB0niooI=;
        b=LHp2QZzfnM+oxvQhKXsdO/c1xviAjh69vVdpsxeNztW1vHwScI5wlpm5MFokByeucX
         K2YGCq1tH8eR3+Sp3QLIrFbl51QzW68YYdZ0tOSBWmYgcLUpOUdlbumnaViigamxOS5n
         n+8DcZyWW30tFiaLh52/sWX2v7YxKhaC7WYONrJeGVhB9LUun4NcMY3twnpAgo0Om434
         oAgeSHUHdMnGTbqw8y8ktPcLprc2qH/Gy3F3mM67jOiexzeyTXrAA+TkpdRmO3UcL5Sj
         cPsZZeOOcaYC/HL4QnUjOMtToUfn1qkzTqEvs21dDHs7Yb8GgR0Qti6qe560ZlJhNHsd
         bVTQ==
X-Gm-Message-State: APjAAAUoLqpupA8R0yOibj+z2+vaQ/2C1Gc0bPyfd49/678oG5hBBolz
        0EmSQsLyWjAJzlu7qc01GLM=
X-Google-Smtp-Source: APXvYqwKBM5ywdLwH8ZUhaXCdTiVH7Y+Sw/yl2/Ecc7GnoNCxcUfa3eaVhqqvFRBK+KE07SI3tjk6A==
X-Received: by 2002:a63:1418:: with SMTP id u24mr5932220pgl.279.1578683255217;
        Fri, 10 Jan 2020 11:07:35 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id b22sm3691542pft.110.2020.01.10.11.07.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jan 2020 11:07:34 -0800 (PST)
Subject: Re: [PATCH net] net: usb: lan78xx: fix possible skb leak
To:     RENARD Pierre-Francois <pfrenard@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
References: <20200107185701.137063-1-edumazet@google.com>
 <393ec56d-5d37-ac75-13af-25ade6aabac8@gmail.com>
 <CANn89iKD6DSnz-QdBMYgm=1N2V7UZpCD3TiB+yTO_tGu7XKReg@mail.gmail.com>
 <870db5aa-d1b3-1466-c5f5-c6d84e250411@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <57d6fc48-3665-3df1-1c55-48d1b84ef889@gmail.com>
Date:   Fri, 10 Jan 2020 11:07:31 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <870db5aa-d1b3-1466-c5f5-c6d84e250411@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/8/20 3:19 PM, RENARD Pierre-Francois wrote:
> OK
> 
> Before scp command ( and after a fresh reboot)
> ---------------------------------
> skbuff_ext_cache     378    378    192   21    1 : tunables 0    0    0 : slabdata     18     18      0
> skbuff_fclone_cache    112    112    512   16    2 : tunables 0    0    0 : slabdata      7      7      0
> skbuff_head_cache   1936   2160    256   16    1 : tunables 0    0    0 : slabdata    135    135      0
> ---------------------------------
> ---------------------------------
> 
> After the hang of scp (hanged at 203 MB)
> ---------------------------------
> skbuff_ext_cache     693    693    192   21    1 : tunables 0    0    0 : slabdata     33     33      0
> skbuff_fclone_cache    128    128    512   16    2 : tunables 0    0    0 : slabdata      8      8      0
> skbuff_head_cache   2032   2176    256   16    1 : tunables 0    0    0 : slabdata    136    136      0
> ---------------------------------
> TcpExtTCPSpuriousRtxHostQueues 120                0.0
> ---------------------------------
> 
> After CTRL-C of scp
> ---------------------------------
> skbuff_ext_cache     693    693    192   21    1 : tunables 0    0    0 : slabdata     33     33      0
> skbuff_fclone_cache    128    128    512   16    2 : tunables 0    0    0 : slabdata      8      8      0
> skbuff_head_cache   2112   2336    256   16    1 : tunables 0    0    0 : slabdata    146    146      0
> ---------------------------------
> TcpExtTCPSpuriousRtxHostQueues  124                0.0
> ---------------------------------
> 
> 
> 
> After the hang of a second attempt (hanged at 1214 MB)
> ---------------------------------
> skbuff_ext_cache     735    735    192   21    1 : tunables 0    0    0 : slabdata     35     35      0
> skbuff_fclone_cache    160    160    512   16    2 : tunables 0    0    0 : slabdata     10     10      0
> skbuff_head_cache   2096   2240    256   16    1 : tunables 0    0    0 : slabdata    140    140      0
> ---------------------------------
> TcpExtTCPSpuriousRtxHostQueues  248                0.0
> ---------------------------------
> 
> 
> After a third attempt (hanged at 55 MB)
> ---------------------------------
> skbuff_ext_cache     735    735    192   21    1 : tunables 0    0    0 : slabdata     35     35      0
> skbuff_fclone_cache    176    176    512   16    2 : tunables 0    0    0 : slabdata     11     11      0
> skbuff_head_cache   2000   2144    256   16    1 : tunables 0    0    0 : slabdata    134    134      0
> ---------------------------------
> TcpExtTCPSpuriousRtxHostQueues  365                0.0
> ---------------------------------
> 
> 


Thanks for testing.

This seems to suggest there is another bug in the driver, leading to some skb being never freed.

Since the driver seems to limit aggregation to 9000 bytes (MAX_SINGLE_PACKET_SIZE)
I wonder if gso skbs should also be limited to the same value.

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index d3239b49c3bb2803c874a2e8af332bcf03848e18..65dea9a94b90e27889c8f44294560ffeabda2eb9 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -3787,6 +3787,8 @@ static int lan78xx_probe(struct usb_interface *intf,
        if (ret < 0)
                goto out4;
 
+       netif_set_gso_max_size(netdev, MAX_SINGLE_PACKET_SIZE - MAX_HEADER);
+
        ret = register_netdev(netdev);
        if (ret != 0) {
                netif_err(dev, probe, netdev, "couldn't register the device\n");



> 
> 
> 
> 
> 
> 
> On 1/8/20 9:25 PM, Eric Dumazet wrote:
>> On Wed, Jan 8, 2020 at 11:13 AM RENARD Pierre-Francois
>> <pfrenard@gmail.com> wrote:
>>> I tried with last rawhide kernel 5.5.0-0.rc5.git0.1.local.fc32.aarch64
>>> I compiled it this night. (I check it includes the patch for lan78xx.c )
>>>
>>> Both tests (scp and nfs ) are failing the same way as before.
>>>
>>> Fox
>>>
>> Please report the output of " grep skb /proc/slabinfo"
>>
>> before and after your test.
>>
>> The symptoms (of retransmit being not attempted by TCP) match the fact
>> that skb(s) is(are) not freed by a driver (or some layer)
>>
>> When TCP detects this (function skb_still_in_host_queue()), one SNMP
>> counter is incremented
>>
>> nstat -a | grep TCPSpuriousRtxHostQueues
>>
>> Thanks.
>>
>>>
>>> On 1/7/20 7:57 PM, Eric Dumazet wrote:
>>>> If skb_linearize() fails, we need to free the skb.
>>>>
>>>> TSO makes skb bigger, and this bug might be the reason
>>>> Raspberry Pi 3B+ users had to disable TSO.
>>>>
>>>> Fixes: 55d7de9de6c3 ("Microchip's LAN7800 family USB 2/3 to 10/100/1000 Ethernet device driver")
>>>> Signed-off-by: Eric Dumazet <edumazet@google.com>
>>>> Reported-by: RENARD Pierre-Francois <pfrenard@gmail.com>
>>>> Cc: Stefan Wahren <stefan.wahren@i2se.com>
>>>> Cc: Woojung Huh <woojung.huh@microchip.com>
>>>> Cc: Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
>>>> ---
>>>>    drivers/net/usb/lan78xx.c | 9 +++------
>>>>    1 file changed, 3 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
>>>> index f940dc6485e56a7e8f905082ce920f5dd83232b0..fb4781080d6dec2af22f41c5e064350ea74130b3 100644
>>>> --- a/drivers/net/usb/lan78xx.c
>>>> +++ b/drivers/net/usb/lan78xx.c
>>>> @@ -2724,11 +2724,6 @@ static int lan78xx_stop(struct net_device *net)
>>>>        return 0;
>>>>    }
>>>>
>>>> -static int lan78xx_linearize(struct sk_buff *skb)
>>>> -{
>>>> -     return skb_linearize(skb);
>>>> -}
>>>> -
>>>>    static struct sk_buff *lan78xx_tx_prep(struct lan78xx_net *dev,
>>>>                                       struct sk_buff *skb, gfp_t flags)
>>>>    {
>>>> @@ -2740,8 +2735,10 @@ static struct sk_buff *lan78xx_tx_prep(struct lan78xx_net *dev,
>>>>                return NULL;
>>>>        }
>>>>
>>>> -     if (lan78xx_linearize(skb) < 0)
>>>> +     if (skb_linearize(skb)) {
>>>> +             dev_kfree_skb_any(skb);
>>>>                return NULL;
>>>> +     }
>>>>
>>>>        tx_cmd_a = (u32)(skb->len & TX_CMD_A_LEN_MASK_) | TX_CMD_A_FCS_;
>>>>
>>>
> 
