Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DA598A58C
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 20:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbfHLSUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 14:20:55 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54679 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbfHLSUy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 14:20:54 -0400
Received: by mail-wm1-f66.google.com with SMTP id p74so430356wme.4
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 11:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=O3FFW8Ykfpml4RMlyDl4XtJ8oB/ZXya3IVcgmZOkWLA=;
        b=QuZt9knar58hKfvwVoquCrrTrncr5GbQJdbGioKcSPsRRK+DdLaQZ57RA1wpekC7yU
         6wfXTYelh4/cVctspiNU6WSod4+wnqZ8G+xtd6FwQIrwvi7pVou+rand4IwUfnvKQRYN
         FN+UHSdIe/i4AENnAIoJfTfiePU852FJAerAEvfpEnjHOwiZ6Zc7ZX8OuPv00uyTeCA+
         OLWpym9o4FzakfYZhLc1e14edsAfDjdwcAA1Ip9ATzGZY+ti8ybpRs11pkD9nDnC7vT5
         qSoQJD0If5FY+IG1tmOxh3nsJvespP6dAmJWT9PFS22ZtENYvr++6HRkBcmgkPbZwI0O
         CfUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=O3FFW8Ykfpml4RMlyDl4XtJ8oB/ZXya3IVcgmZOkWLA=;
        b=CN6A0Mr6QASJs/is5bu9Rfv9vYtII/SV7DeAdqltl5d8gO30r2T65e/myxwmuszhFi
         9ivijhLsvziXTScoCDZt0AhEghvdjefkwE+7KpjeMwuqGxxtML9ZOgZoE9i9qNaauVia
         sH9hvTOaxbQOynJelJkVgALN6xuWSwRQwS0ZLKk143BhXFnU7G4mHAUOdOXQ/mQHuZVX
         x7FIpiTbV6zuFOaWr5huIrIML+eo27qdTljYDzUrKXUGRA6Ch31B5Wduqyzzn4mAFrcK
         y6tO1fSlzKTECNBPWcLU8+luWUlUAAeTywjBGCvIpst/MFpxB74YPw4DnIL5QweYMTWR
         RA4g==
X-Gm-Message-State: APjAAAUvYIpchF3/sf0EDA8PkAMh0T6p3bYJWeposjMI3TQ4QVV6jbmp
        MYEAgLspCH3dyUp9Wa59JME=
X-Google-Smtp-Source: APXvYqxFqJGjhKxPCuekfCqq/JUlFSW1BUAU0YgvcMHzY6X1sKJMdF/AbtKyaf5gyLXg2trmb7LwRA==
X-Received: by 2002:a1c:18a:: with SMTP id 132mr618600wmb.15.1565634052924;
        Mon, 12 Aug 2019 11:20:52 -0700 (PDT)
Received: from [192.168.8.147] (239.169.185.81.rev.sfr.net. [81.185.169.239])
        by smtp.gmail.com with ESMTPSA id a26sm218735wmg.45.2019.08.12.11.20.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Aug 2019 11:20:52 -0700 (PDT)
Subject: Re: [PATCH v3 net-next 0/3] net: batched receive in GRO path
To:     Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>,
        Edward Cree <ecree@solarflare.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "linux-net-drivers@solarflare.com" <linux-net-drivers@solarflare.com>
References: <c6e2474e-2c8a-5881-86bf-59c66bdfc34f@solarflare.com>
 <AM0PR04MB4994C1A8F32FB6C9A7EE057E94D60@AM0PR04MB4994.eurprd04.prod.outlook.com>
 <a6faf533-6dd3-d7d7-9464-1fe87d0ac7fc@solarflare.com>
 <AM0PR04MB4994A035C6121DC13C0EFBB194D30@AM0PR04MB4994.eurprd04.prod.outlook.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <a7456e50-13f1-7ffb-9913-cb7f9bc2312d@gmail.com>
Date:   Mon, 12 Aug 2019 20:20:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <AM0PR04MB4994A035C6121DC13C0EFBB194D30@AM0PR04MB4994.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/12/19 7:51 PM, Ioana Ciocoi Radulescu wrote:
>> -----Original Message-----
>> From: Edward Cree <ecree@solarflare.com>
>> Sent: Friday, August 9, 2019 8:32 PM
>> To: Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>
>> Cc: David Miller <davem@davemloft.net>; netdev <netdev@vger.kernel.org>;
>> Eric Dumazet <eric.dumazet@gmail.com>; linux-net-drivers@solarflare.com
>> Subject: Re: [PATCH v3 net-next 0/3] net: batched receive in GRO path
>>
>> On 09/08/2019 18:14, Ioana Ciocoi Radulescu wrote:
>>> Hi Edward,
>>>
>>> I'm probably missing a lot of context here, but is there a reason
>>> this change targets only the napi_gro_frags() path and not the
>>> napi_gro_receive() one?
>>> I'm trying to understand what drivers that don't call napi_gro_frags()
>>> should do in order to benefit from this batching feature.
>> The sfc driver (which is what I have lots of hardware for, so I can
>>  test it) uses napi_gro_frags().
>> It should be possible to do a similar patch to napi_gro_receive(),
>>  if someone wants to put in the effort of writing and testing it.
> 
> Rather tricky, since I'm not really familiar with GRO internals and
> probably don't understand all the implications of such a change :-/
> Any pointers to what I should pay attention to/sensitive areas that
> need extra care?
> 
>> However, there are many more callers, so more effort required to
>>  make sure none of them care whether the return value is GRO_DROP
>>  or GRO_NORMAL (since the listified version cannot give that
>>  indication).
> 
> At a quick glance, there's only one driver that looks at the return
> value of napi_gro_receive (drivers/net/ethernet/socionext/netsec.c),
> and it only updates interface stats based on it.
> 
>> Also, the guidance from Eric is that drivers seeking high performance
>>  should use napi_gro_frags(), as this allows GRO to recycle the SKB.
> 
> But this guidance is for GRO-able frames only, right? If I try to use
> napi_gro_frags() indiscriminately on the Rx path, I get a big
> performance penalty in some cases - e.g. forwarding of non-TCP
> single buffer frames.

How big is big ?

You can not win all the time.

Some design (or optimizations) are for the most common case,
they might hurt some other use cases.

> 
> On the other hand, Eric shot down my attempt to differentiate between
> TCP and non-TCP frames inside the driver (see 
> https://patchwork.ozlabs.org/patch/1135817/#2222236), so I'm not
> really sure what's the recommended approach here?

If GRO is not good enough for non-TCP buffer frames, please make the change in GRO,
or document that disabling GRO might help some setups.

We do not want each driver to implement their own logic that are a
maintenance nightmare.

GRO can aggregate non-TCP frames (say if you add any encapsulation over TCP),
with a very significant gain, so detecting if an incoming frame is a 'TCP packet'
in the driver would be a serious problem if the traffic is 100% SIT for example.

