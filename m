Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A94671156F1
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 19:05:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbfLFSFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 13:05:25 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:35934 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726287AbfLFSFZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 13:05:25 -0500
Received: by mail-pl1-f193.google.com with SMTP id k20so3034398pls.3;
        Fri, 06 Dec 2019 10:05:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tclkaBl0jj6cwB3LlPqPdMHPc7972vo1qQ0/01hkmns=;
        b=AqmLVp8kARYlrxiWWhV7pIjgEQHUZRVY45fvjTgSfZsyMyOg9FIiwrggF176dlUWRE
         DkenH5rlzzx86HUlyofYJNH2NKrLBItjaDXI7kYI6FIBL5wanOKZiBX6GfRr1DwAGYlq
         SuRHYd57jZoXJwgjbiDcrdz4HMvzwK4LXE7ZZryZ5jutkJCJ3nKnHAdqb+8tnSdUuwlf
         Cm/vCf76ZonDRn8beBDJGZUrKBESczPCR30t66n03wgNfAyAYAt0Ves/IjKZa4PmoJjM
         cRUOk17MgtcVdlRRzJa2W4Jmf7qa4dE1DaU69qkeiCnXlFuqdsmhGiamTEmcSsi2V5GD
         jFuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=tclkaBl0jj6cwB3LlPqPdMHPc7972vo1qQ0/01hkmns=;
        b=MFoJb+J96wkHvtb656DXN4zcRoZR8VgdwMrGesUgSZGbHUfccxrm5sxXU2MzlyAc2h
         8Dk/LA9jC4JgDrSN4mwIr6bYQImQOADcRKJwD7WYHz25rS0dwFYnk/7IePH4+IIa1uY0
         iRZd+ZYdEEWcGMJJBNloW4KxbMTWlXeQCoEj0yie+qS64rK63nuA8UYj58Sc/exX17ol
         EJtvB09sbIrYWVlzhThhhL1ETeJ1eZWw2J/BWHgfYc0HYcTFlSSscT5+qGedDlWOGSMN
         2tUDf6JxUqnmBUwM5dMIJugospEgsfGTvd1kXVT2ppuORsI6aYAaT58vmSHfQLvmPn8e
         INlA==
X-Gm-Message-State: APjAAAVKdHS2BJtwDiNvXLOanvpm1kHeDD//fL5/j/UExiBqYX5f/n11
        18cGbPH3hFmQZRcXXMG7teMzySNp
X-Google-Smtp-Source: APXvYqzKBtpiwJ310D2bmszGFchwGpfIAoN3UT8yWi++ZZ7A3q301ffO7nJirNhTHWuev9dy41n/Kw==
X-Received: by 2002:a17:90a:8c1:: with SMTP id 1mr17597259pjn.12.1575655523551;
        Fri, 06 Dec 2019 10:05:23 -0800 (PST)
Received: from [10.67.50.53] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id h3sm3723127pji.16.2019.12.06.10.05.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Dec 2019 10:05:22 -0800 (PST)
Subject: Re: [PATCH net] net: dsa: fix flow dissection on Tx path
To:     Alexander Lobakin <alobakin@dlink.ru>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Muciri Gatimu <muciri@openmesh.com>,
        Shashidhar Lakkavalli <shashidhar.lakkavalli@openmesh.com>,
        John Crispin <john@phrozen.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Matteo Croce <mcroce@redhat.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>,
        Paul Blakey <paulb@mellanox.com>,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20191205100235.14195-1-alobakin@dlink.ru>
 <20191205125827.GA28269@lunn.ch> <2e03b82a8ec999fade26253ff35077c6@dlink.ru>
 <20191205140132.GD28269@lunn.ch> <72a21c5f03abdc3d2d1c1bb85fd4489d@dlink.ru>
 <3cc7a0c3-4eeb-52d5-1777-f646329a9303@gmail.com>
 <5e108291220110b10fdf0c88f8894fdb@dlink.ru>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 G10n8gCguORqNGMsVRxrlLs7/himep7MrCc=
Message-ID: <30eb10a3-ad94-5b9b-5cea-f4b50c2f0e42@gmail.com>
Date:   Fri, 6 Dec 2019 10:05:20 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <5e108291220110b10fdf0c88f8894fdb@dlink.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/5/19 11:37 PM, Alexander Lobakin wrote:
> Florian Fainelli wrote 06.12.2019 06:32:
>> On 12/5/2019 6:58 AM, Alexander Lobakin wrote:
>>> Andrew Lunn wrote 05.12.2019 17:01:
>>>>> Hi,
>>>>>
>>>>> > What i'm missing here is an explanation why the flow dissector is
>>>>> > called here if the protocol is already set? It suggests there is a
>>>>> > case when the protocol is not correctly set, and we do need to look
>>>>> > into the frame?
>>>>>
>>>>> If we have a device with multiple Tx queues, but XPS is not configured
>>>>> or system is running on uniprocessor system, then networking core code
>>>>> selects Tx queue depending on the flow to utilize as much Tx queues as
>>>>> possible but without breaking frames order.
>>>>> This selection happens in net/core/dev.c:skb_tx_hash() as:
>>>>>
>>>>> reciprocal_scale(skb_get_hash(skb), qcount)
>>>>>
>>>>> where 'qcount' is the total number of Tx queues on the network device.
>>>>>
>>>>> If skb has not been hashed prior to this line, then skb_get_hash()
>>>>> will
>>>>> call flow dissector to generate a new hash. That's why flow dissection
>>>>> can occur on Tx path.
>>>>
>>>>
>>>> Hi Alexander
>>>>
>>>> So it looks like you are now skipping this hash. Which in your
>>>> testing, give better results, because the protocol is already set
>>>> correctly. But are there cases when the protocol is not set correctly?
>>>> We really do need to look into the frame?
>>>
>>> Actually no, I'm not skipping the entire hashing, I'm only skipping
>>> tag_ops->flow_dissect() (helper that only alters network offset and
>>> replaces fake ETH_P_XDSA with the actual protocol) call on Tx path,
>>> because this only breaks flow dissection logics. All skbs are still
>>> processed and hashed by the generic code that goes after that call.
>>>
>>>> How about when an outer header has just been removed? The frame was
>>>> received on a GRE tunnel, the GRE header has just been removed, and
>>>> now the frame is on its way out? Is the protocol still GRE, and we
>>>> should look into the frame to determine if it is IPv4, ARP etc?
>>>>
>>>> Your patch looks to improve things for the cases you have tested, but
>>>> i'm wondering if there are other use cases where we really do need to
>>>> look into the frame? In which case, your fix is doing the wrong thing.
>>>> Should we be extending the tagger to handle the TX case as well as the
>>>> RX case?
>>>
>>> We really have two options: don't call tag_ops->flow_dissect() on Tx
>>> (this patch), or extend tagger callbacks to handle Tx path too. I was
>>> using both of this for several months each and couldn't detect cases
>>> where the first one was worse than the second.
>>> I mean, there _might_ be such cases in theory, and if they will appear
>>> we should extend our taggers. But for now I don't see the necessity to
>>> do this as generic flow dissection logics works as expected after this
>>> patch and is completely broken without it.
>>> And remember that we have the reverse logic on Tx and all skbs are
>>> firstly queued on slave netdevice and only then on master/CPU port.
>>>
>>> It would be nice to see what other people think about it anyways.
>>
>> Your patch seems appropriate to me and quite frankly I am not sure why
>> flow dissection on RX is done at the DSA master device level, where we
>> have not parsed the DSA tag yet, instead of being done at the DSA slave
>> network device level. It seems to me that if the DSA master has N RX
>> queues, we should be creating the DSA slave devices with the same amount
>> of RX queues and perform RPS there against a standard Ethernet frame
>> (sans DSA tag).
>>
>> For TX the story is a little different because we can have multiqueue
>> DSA slave network devices in order to steer traffic towards particular
>> switch queues and we could do XPS there that way.
>>
>> What do you think?
> 
> Hi Florian,
> 
> First of all, thank you for the "Reviewed-by"!
> 
> I agree with you that all the network stack processing should be
> performed on standard frames without CPU tags and on corresponding
> slave netdevices. So I think we really should think about extending
> DSA core code to create slaves with at least as many Rx queues as
> master device have. With this done we could remove .flow_dissect()
> callback from DSA taggers entirely and simplify traffic flow.

Indeed.

> 
> Also, if we get back to Tx processing, number of Tx queues on slaves
> should be equal to number of queues on switch inself in ideal case.
> Maybe we should then apply this rule to Rx queues too, i.e. create
> slaves with the number of Rx queues that switch has?

Yes, I would offer the same configuration knob we have today with TX
queues for RX queues.

> 
> (for example, I'm currently working with the switches that have 8 Rxqs
> and 8 Txqs, but their Ethernet controlers / CPU ports have only 4/4)

Yes, that is not uncommon unfortunately, we have a similar set-up with
BCM7278 which has 16 TX queues for its DSA master and we have 4 switch
ports with 8 TX queues per port, what I did is basically clamp the
number of DSA slave device TX queues to have a 1:1 mapping and that
seems acceptable to the users :)
-- 
Florian
