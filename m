Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5987D137C51
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 09:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728638AbgAKIUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 03:20:23 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53030 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728626AbgAKIUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 03:20:22 -0500
Received: by mail-wm1-f68.google.com with SMTP id p9so4372166wmc.2
        for <netdev@vger.kernel.org>; Sat, 11 Jan 2020 00:20:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=11AexEDhCWrONHKkV2o41CP3JylAVBhE9wS2UnkPlVY=;
        b=Dzp42I+zBq8gLLIzouLMiGLE8s6+wl1yFjlYWJvIIL5H9kW7Reii6wwHMiQ4Al6AXF
         E1fjMb2rsEAnh8BiKBDaaqC7GSltElEcwtbNhJ1iX2D++ZEYF0uKVDRKjnTVe9MTIkBs
         F6+A7cnHhtG88EL4/EYKs7Sm0ioiXDtsjmgW0R2vrzBIw4fnWKtYgXiZNGnvCYQLOW42
         Ha9BoeuuI9y9eaahHpPsmYmsyc4qR5uXZtlPqmuPPfxPvhiuM2n+idqSnr3Jmb5sMylo
         H94GAWSrToobLLPyPm8scKTX0dapVL3I+mzxzvqYC2NM+w3y4JwYmGvsru5Elm4ly7O2
         vXYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=11AexEDhCWrONHKkV2o41CP3JylAVBhE9wS2UnkPlVY=;
        b=IjFDIGhMxSJ3zw9OPp4XCoegA/KJrxYoFWjuEOVzzBEWBirHMh9hphAFcC06TuV51M
         b+9hOdcXKf96SeYlIasQMLmUGXGtY+EDW83ScN87yLEAPHmPdqLLxitiP2IWlfzJPNlb
         Fz58FlixszPLDggI/jl8x/syVcLawmdFt5rFtpl3sOuvgpfFEcLAyZfXvkPAp1+9M0v2
         AFYvbMVgYccs6mR41+nzt8DcsO0qppqRze8upjRg7+oIDrc0riJNg2Lrvc+QiuF5O7CD
         uAIgMuR1NfbsfsjMmSfn5VW6A1K6Ugg2CTe6lSY1e9RwdTQ8WHp1KXHjtRpsxkMVQhE8
         Hg5Q==
X-Gm-Message-State: APjAAAXysf9RRdNozYT1vBZ7GEYUUjTZqJJW9ykwuuQA1QlGg5SJSQLq
        yWMHpIEGLN1vfLdZvkiHoOO5rdjkL1bX/A==
X-Google-Smtp-Source: APXvYqwBMOfdkRCRsLEB9EG+0E8ZTJgZoWjszTkvvN9YCToKjXk5AAFeNbI6v4kswnH9GK1+s3OK0g==
X-Received: by 2002:a1c:7d92:: with SMTP id y140mr8236421wmc.145.1578730820297;
        Sat, 11 Jan 2020 00:20:20 -0800 (PST)
Received: from xps13.intranet.net (82-64-122-65.subs.proxad.net. [82.64.122.65])
        by smtp.googlemail.com with ESMTPSA id v14sm5441053wrm.28.2020.01.11.00.20.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Jan 2020 00:20:19 -0800 (PST)
Subject: Re: [PATCH net] net: usb: lan78xx: fix possible skb leak
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
References: <20200107185701.137063-1-edumazet@google.com>
 <393ec56d-5d37-ac75-13af-25ade6aabac8@gmail.com>
 <CANn89iKD6DSnz-QdBMYgm=1N2V7UZpCD3TiB+yTO_tGu7XKReg@mail.gmail.com>
 <870db5aa-d1b3-1466-c5f5-c6d84e250411@gmail.com>
 <57d6fc48-3665-3df1-1c55-48d1b84ef889@gmail.com>
From:   RENARD Pierre-Francois <pfrenard@gmail.com>
Message-ID: <b9440da5-3682-634f-fca8-7cb70bae8581@gmail.com>
Date:   Sat, 11 Jan 2020 09:20:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <57d6fc48-3665-3df1-1c55-48d1b84ef889@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hello,

I applied patch and I am NOT able to reproduce the issue with both NFS 
or SCP !

Congratulations !

Fox


On 1/10/20 8:07 PM, Eric Dumazet wrote:
>
> On 1/8/20 3:19 PM, RENARD Pierre-Francois wrote:
>> OK
>>
>> Before scp command ( and after a fresh reboot)
>> ---------------------------------
>> skbuff_ext_cache     378    378    192   21    1 : tunables 0    0    0 : slabdata     18     18      0
>> skbuff_fclone_cache    112    112    512   16    2 : tunables 0    0    0 : slabdata      7      7      0
>> skbuff_head_cache   1936   2160    256   16    1 : tunables 0    0    0 : slabdata    135    135      0
>> ---------------------------------
>> ---------------------------------
>>
>> After the hang of scp (hanged at 203 MB)
>> ---------------------------------
>> skbuff_ext_cache     693    693    192   21    1 : tunables 0    0    0 : slabdata     33     33      0
>> skbuff_fclone_cache    128    128    512   16    2 : tunables 0    0    0 : slabdata      8      8      0
>> skbuff_head_cache   2032   2176    256   16    1 : tunables 0    0    0 : slabdata    136    136      0
>> ---------------------------------
>> TcpExtTCPSpuriousRtxHostQueues 120                0.0
>> ---------------------------------
>>
>> After CTRL-C of scp
>> ---------------------------------
>> skbuff_ext_cache     693    693    192   21    1 : tunables 0    0    0 : slabdata     33     33      0
>> skbuff_fclone_cache    128    128    512   16    2 : tunables 0    0    0 : slabdata      8      8      0
>> skbuff_head_cache   2112   2336    256   16    1 : tunables 0    0    0 : slabdata    146    146      0
>> ---------------------------------
>> TcpExtTCPSpuriousRtxHostQueues  124                0.0
>> ---------------------------------
>>
>>
>>
>> After the hang of a second attempt (hanged at 1214 MB)
>> ---------------------------------
>> skbuff_ext_cache     735    735    192   21    1 : tunables 0    0    0 : slabdata     35     35      0
>> skbuff_fclone_cache    160    160    512   16    2 : tunables 0    0    0 : slabdata     10     10      0
>> skbuff_head_cache   2096   2240    256   16    1 : tunables 0    0    0 : slabdata    140    140      0
>> ---------------------------------
>> TcpExtTCPSpuriousRtxHostQueues  248                0.0
>> ---------------------------------
>>
>>
>> After a third attempt (hanged at 55 MB)
>> ---------------------------------
>> skbuff_ext_cache     735    735    192   21    1 : tunables 0    0    0 : slabdata     35     35      0
>> skbuff_fclone_cache    176    176    512   16    2 : tunables 0    0    0 : slabdata     11     11      0
>> skbuff_head_cache   2000   2144    256   16    1 : tunables 0    0    0 : slabdata    134    134      0
>> ---------------------------------
>> TcpExtTCPSpuriousRtxHostQueues  365                0.0
>> ---------------------------------
>>
>>
>
> Thanks for testing.
>
> This seems to suggest there is another bug in the driver, leading to some skb being never freed.
>
> Since the driver seems to limit aggregation to 9000 bytes (MAX_SINGLE_PACKET_SIZE)
> I wonder if gso skbs should also be limited to the same value.
>
> diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
> index d3239b49c3bb2803c874a2e8af332bcf03848e18..65dea9a94b90e27889c8f44294560ffeabda2eb9 100644
> --- a/drivers/net/usb/lan78xx.c
> +++ b/drivers/net/usb/lan78xx.c
> @@ -3787,6 +3787,8 @@ static int lan78xx_probe(struct usb_interface *intf,
>          if (ret < 0)
>                  goto out4;
>   
> +       netif_set_gso_max_size(netdev, MAX_SINGLE_PACKET_SIZE - MAX_HEADER);
> +
>          ret = register_netdev(netdev);
>          if (ret != 0) {
>                  netif_err(dev, probe, netdev, "couldn't register the device\n");
>
>
>
>>
>>
>>
>>
>>
>> On 1/8/20 9:25 PM, Eric Dumazet wrote:
>>> On Wed, Jan 8, 2020 at 11:13 AM RENARD Pierre-Francois
>>> <pfrenard@gmail.com> wrote:
>>>> I tried with last rawhide kernel 5.5.0-0.rc5.git0.1.local.fc32.aarch64
>>>> I compiled it this night. (I check it includes the patch for lan78xx.c )
>>>>
>>>> Both tests (scp and nfs ) are failing the same way as before.
>>>>
>>>> Fox
>>>>
>>> Please report the output of " grep skb /proc/slabinfo"
>>>
>>> before and after your test.
>>>
>>> The symptoms (of retransmit being not attempted by TCP) match the fact
>>> that skb(s) is(are) not freed by a driver (or some layer)
>>>
>>> When TCP detects this (function skb_still_in_host_queue()), one SNMP
>>> counter is incremented
>>>
>>> nstat -a | grep TCPSpuriousRtxHostQueues
>>>
>>> Thanks.
>>>
>>>> On 1/7/20 7:57 PM, Eric Dumazet wrote:
>>>>> If skb_linearize() fails, we need to free the skb.
>>>>>
>>>>> TSO makes skb bigger, and this bug might be the reason
>>>>> Raspberry Pi 3B+ users had to disable TSO.
>>>>>
>>>>> Fixes: 55d7de9de6c3 ("Microchip's LAN7800 family USB 2/3 to 10/100/1000 Ethernet device driver")
>>>>> Signed-off-by: Eric Dumazet <edumazet@google.com>
>>>>> Reported-by: RENARD Pierre-Francois <pfrenard@gmail.com>
>>>>> Cc: Stefan Wahren <stefan.wahren@i2se.com>
>>>>> Cc: Woojung Huh <woojung.huh@microchip.com>
>>>>> Cc: Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
>>>>> ---
>>>>>     drivers/net/usb/lan78xx.c | 9 +++------
>>>>>     1 file changed, 3 insertions(+), 6 deletions(-)
>>>>>
>>>>> diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
>>>>> index f940dc6485e56a7e8f905082ce920f5dd83232b0..fb4781080d6dec2af22f41c5e064350ea74130b3 100644
>>>>> --- a/drivers/net/usb/lan78xx.c
>>>>> +++ b/drivers/net/usb/lan78xx.c
>>>>> @@ -2724,11 +2724,6 @@ static int lan78xx_stop(struct net_device *net)
>>>>>         return 0;
>>>>>     }
>>>>>
>>>>> -static int lan78xx_linearize(struct sk_buff *skb)
>>>>> -{
>>>>> -     return skb_linearize(skb);
>>>>> -}
>>>>> -
>>>>>     static struct sk_buff *lan78xx_tx_prep(struct lan78xx_net *dev,
>>>>>                                        struct sk_buff *skb, gfp_t flags)
>>>>>     {
>>>>> @@ -2740,8 +2735,10 @@ static struct sk_buff *lan78xx_tx_prep(struct lan78xx_net *dev,
>>>>>                 return NULL;
>>>>>         }
>>>>>
>>>>> -     if (lan78xx_linearize(skb) < 0)
>>>>> +     if (skb_linearize(skb)) {
>>>>> +             dev_kfree_skb_any(skb);
>>>>>                 return NULL;
>>>>> +     }
>>>>>
>>>>>         tx_cmd_a = (u32)(skb->len & TX_CMD_A_LEN_MASK_) | TX_CMD_A_FCS_;
>>>>>

