Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7F5141097
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 19:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729008AbgAQSQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 13:16:48 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33750 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726603AbgAQSQs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 13:16:48 -0500
Received: by mail-pf1-f193.google.com with SMTP id z16so12318889pfk.0;
        Fri, 17 Jan 2020 10:16:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aD0tuQOOzQ4oPbILPoDAiI6G2Z70ung0n+DSdMMnNJM=;
        b=XAwhFczp0KmF7S4+mP+LKpuEITPW8TFrYJjFMPDvKsfwAhoGkynU29aeT7ZqFXq1u7
         gVDBjYq8rj1+xwysNNi4G/44MygeUidK4BAC2uI4Ql20Wr2SRsWeirad2G4ygoaU+qIq
         zQccKK++5t95MmYnFfwAQb8HAZz+3HjAGkOWGyZ6hMfaKAR2MFL690nGCkZZdO56LoSj
         wjT2dLaloYNNswOOdL322gcruh2L6yUWgp6eL2VohufB2R0dlg9nZUhi+2fpetFEX+Rm
         GkVJY7CVN2swKSsvPBu0/h4L40vTxHjGYa6t+aAbCILTSKRl3zVO/4W+XhSDCSI7OPrV
         70ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aD0tuQOOzQ4oPbILPoDAiI6G2Z70ung0n+DSdMMnNJM=;
        b=R/HclvEcSkKUb6D87T+EuyhpHZ1pad/q8rhHisvrMHSlEwg9IAVgwr5IJsCaXCWDI8
         +8UFJk65gwu0ReyUoO13flbqhUnsnIMyjSxMiaXn9dpHc6Mc3xSvKilYFJq8MKlV4QI/
         Tj4i+tbk83IvIYdUn7HOa0E1jXdNs6e8EO+Tj3EvXfhy8TDOEY7aFK/+nMlAM3+Ta7PZ
         6G1SV609cHK13XPRGXY8UdDbvJGaQEldEhxyvZ43YPQ7sZsbemvO5OOhCR3vZ5fmJT7v
         G7ii50Gz7GorxshjljFvUESxsHiABnl8qkbzYCntJRWB6w17sTxZWzaioaHLayXnEj2R
         diCA==
X-Gm-Message-State: APjAAAUZ2RfkeCdlInVp7sI4yTUKPXHaULeKvpOP6XnlqDgO/TwE2Hxl
        ZmTRyPNQd2W+fu5MYRZaVE8=
X-Google-Smtp-Source: APXvYqwmqpjSoPfBdcrHSDgt2evoaybgY+qpc04lufY7AQGAgKNpGRqu1fs3w6huCAqrB5q65VH6hg==
X-Received: by 2002:a63:1204:: with SMTP id h4mr45519701pgl.288.1579285007532;
        Fri, 17 Jan 2020 10:16:47 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id q63sm30965322pfb.149.2020.01.17.10.16.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2020 10:16:46 -0800 (PST)
Subject: Re: [PATCH] net: optimize cmpxchg in ip_idents_reserve
To:     Arvind Sankar <nivedita@alum.mit.edu>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jinyuqi@huawei.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, edumazet@google.com,
        guoyang2@huawei.com, Will Deacon <will@kernel.org>
References: <1579058620-26684-1-git-send-email-zhangshaokun@hisilicon.com>
 <20200116.042722.153124126288244814.davem@davemloft.net>
 <930faaff-4d18-452d-2e44-ef05b65dc858@gmail.com>
 <1b3aaddf-22f5-1846-90f1-42e68583c1e4@gmail.com>
 <430496fc-9f26-8cb4-91d8-505fda9af230@hisilicon.com>
 <20200117123253.GC14879@hirez.programming.kicks-ass.net>
 <7e6c6202-24bb-a532-adde-d53dd6fb14c3@gmail.com>
 <20200117180324.GA2623847@rani.riverdale.lan>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <94573cea-a833-9b48-6581-8cc5cdd19b89@gmail.com>
Date:   Fri, 17 Jan 2020 10:16:45 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200117180324.GA2623847@rani.riverdale.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/17/20 10:03 AM, Arvind Sankar wrote:
> On Fri, Jan 17, 2020 at 08:35:07AM -0800, Eric Dumazet wrote:
>>
>>
>> On 1/17/20 4:32 AM, Peter Zijlstra wrote:
>>
>>>
>>> That's crazy, just accept that UBSAN is taking bonghits and ignore it.
>>> Use atomic_add_return() unconditionally.
>>>
>>
>> Yes, we might simply add a comment so that people do not bug us if
>> their compiler is too old.
>>
>> /* If UBSAN reports an error there, please make sure your compiler
>>  * supports -fno-strict-overflow before reporting it.
>>  */
>> return atomic_add_return(segs + delta, p_id) - segs;
>>
> 
> Do we need that comment any more? The flag was apparently introduced in
> gcc-4.2 and we only support 4.6+ anyway?

Wasńt it the case back in 2016 already for linux-4.8 ?

What will prevent someone to send another report to netdev/lkml ?

 -fno-strict-overflow support is not a prereq for CONFIG_UBSAN.

Fact that we kept in lib/ubsan.c and lib/test_ubsan.c code for 
test_ubsan_add_overflow() and test_ubsan_sub_overflow() is disturbing.


commit adb03115f4590baa280ddc440a8eff08a6be0cb7
Author: Eric Dumazet <edumazet@google.com>
Date:   Tue Sep 20 18:06:17 2016 -0700

    net: get rid of an signed integer overflow in ip_idents_reserve()
    
    Jiri Pirko reported an UBSAN warning happening in ip_idents_reserve()
    
    [] UBSAN: Undefined behaviour in ./arch/x86/include/asm/atomic.h:156:11
    [] signed integer overflow:
    [] -2117905507 + -695755206 cannot be represented in type 'int'
    
    Since we do not have uatomic_add_return() yet, use atomic_cmpxchg()
    so that the arithmetics can be done using unsigned int.
    
    Fixes: 04ca6973f7c1 ("ip: make IP identifiers less predictable")
    Signed-off-by: Eric Dumazet <edumazet@google.com>
    Reported-by: Jiri Pirko <jiri@resnulli.us>
    Signed-off-by: David S. Miller <davem@davemloft.net>

 
