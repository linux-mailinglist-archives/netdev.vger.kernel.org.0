Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4D9634912
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 22:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234857AbiKVVSO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 16:18:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234853AbiKVVSN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 16:18:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7350385A1D
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 13:17:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669151842;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JPDjHDoH9++mlr8p4OfANKSJGcFV53l1p3BKiJIXBZM=;
        b=c59RWPgfdjh6baq0kKweyU1gM0CqS/HWC9PNCLUvhOfUhBmk+GKh/aE9uWBzmenalDZz2i
        tm5pZqE0WQFyDZpmSofDAUh/YHDKHI04rQkLKYDISKSbGpwOq7vsaH7V1wpvDQ+OdlCyaw
        5fNpR8TeI9Emkps6ykzSsVzQ/brK79A=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-660-rtSYWrAzO-GWo6fueARvPg-1; Tue, 22 Nov 2022 16:17:20 -0500
X-MC-Unique: rtSYWrAzO-GWo6fueARvPg-1
Received: by mail-qt1-f198.google.com with SMTP id fz10-20020a05622a5a8a00b003a4f466998cso15623557qtb.16
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 13:17:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JPDjHDoH9++mlr8p4OfANKSJGcFV53l1p3BKiJIXBZM=;
        b=WpsdvKu8bNlhwxbxxvCcDYQuodSqr1J7QLBzH+ksTdko22QI5CLL+4+pZMmV4UZS2U
         hsPBODXEyX9SblhajAgIgmId+cRJaxQvVKZCQl5FEi/q/F9a5ZUmBH33M6W6BxG6iZ7k
         SFbUMcqt8WCfPjzR38W25LgxduvZbLLji25HBUQi+U5lVEpxsOM8Ll9BnIPIEBY+AT3E
         OG05XQWBVwAhc8mEzTBrdtxAMbh1LuOdTMIvC3huf3tk2YQHAacsWB6zAb2MBGMCdmAm
         vAzTEDCYO7w7ngsaDNCpfuHefSbd7DANnmBPTmIlm+cZoL0Z/bnxTGJ2jCEtzgYUI9Bi
         Xl5g==
X-Gm-Message-State: ANoB5pnDxjGX4QfsZvPbBUVwpQUpMWe25lblhLCTkifqBsEzVC40kAWz
        orQ422JnpEPaRdOm90ahwQXMJ8d2p8pTDu1qVrl/ZaCz0RawirihRsYBdg95CbZ7u85Hh6oy7bP
        FxPHNfZsojfLIxz81
X-Received: by 2002:ac8:5992:0:b0:3a6:7a7:b39d with SMTP id e18-20020ac85992000000b003a607a7b39dmr5282269qte.193.1669151839809;
        Tue, 22 Nov 2022 13:17:19 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5OvGFE5yed5LhSLIPAGzfqX2bLLJl26JcHCQp691LGevPKIPVFf668USmFEfU3Js/EOoNdGA==
X-Received: by 2002:ac8:5992:0:b0:3a6:7a7:b39d with SMTP id e18-20020ac85992000000b003a607a7b39dmr5282247qte.193.1669151839591;
        Tue, 22 Nov 2022 13:17:19 -0800 (PST)
Received: from [192.168.33.110] (c-73-19-232-221.hsd1.tn.comcast.net. [73.19.232.221])
        by smtp.gmail.com with ESMTPSA id u20-20020a05620a0c5400b006cf8fc6e922sm10904600qki.119.2022.11.22.13.17.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Nov 2022 13:17:18 -0800 (PST)
Message-ID: <96fd10f0-45e8-c2c4-b197-d2809f800219@redhat.com>
Date:   Tue, 22 Nov 2022 16:17:17 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net-next 2/2] bonding: fix link recovery in mode 2 when
 updelay is nonzero
Content-Language: en-US
To:     Nikolay Aleksandrov <razor@blackwall.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Jay Vosburgh <j.vosburgh@gmail.com>
Cc:     Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
References: <cover.1668800711.git.jtoppins@redhat.com>
 <cb89b92af89973ee049a696c362b4a2abfdd9b82.1668800711.git.jtoppins@redhat.com>
 <38fbc36783d583f805f30fb3a55a8a87f67b59ac.camel@redhat.com>
 <1fe036eb-5207-eccd-0cb3-aa22f5d130ce@redhat.com>
 <5718ba71a8755040f61ed7b2f688b1067ca56594.camel@redhat.com>
 <e1150971-ec16-0421-a13a-d6d2a0a66348@redhat.com>
 <0e7bb31c-ca92-dac2-4d29-5eb2d3327b26@blackwall.org>
 <840d6f2a-abc9-c5d3-d1d3-3862e479509a@blackwall.org>
From:   Jonathan Toppins <jtoppins@redhat.com>
In-Reply-To: <840d6f2a-abc9-c5d3-d1d3-3862e479509a@blackwall.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/22/22 16:15, Nikolay Aleksandrov wrote:
> On 22/11/2022 23:12, Nikolay Aleksandrov wrote:
>> On 22/11/2022 17:37, Jonathan Toppins wrote:
>>> On 11/22/22 09:45, Paolo Abeni wrote:
>>>> On Tue, 2022-11-22 at 08:36 -0500, Jonathan Toppins wrote:
>>>>> On 11/22/22 05:59, Paolo Abeni wrote:
>>>>>> Hello,
>>>>>>
>>>>>> On Fri, 2022-11-18 at 15:30 -0500, Jonathan Toppins wrote:
>>>>>>> Before this change when a bond in mode 2 lost link, all of its slaves
>>>>>>> lost link, the bonding device would never recover even after the
>>>>>>> expiration of updelay. This change removes the updelay when the bond
>>>>>>> currently has no usable links. Conforming to bonding.txt section 13.1
>>>>>>> paragraph 4.
>>>>>>>
>>>>>>> Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
>>>>>>
>>>>>> Why are you targeting net-next? This looks like something suitable to
>>>>>> the -net tree to me. If, so could you please include a Fixes tag?
>>>>>>
>>>>>> Note that we can add new self-tests even via the -net tree.
>>>>>>
>>>>>
>>>>> I could not find a reasonable fixes tag for this, hence why I targeted
>>>>> the net-next tree.
>>>>
>>>> When in doubt I think it's preferrable to point out a commit surely
>>>> affected by the issue - even if that is possibly not the one
>>>> introducing the issue - than no Fixes as all. The lack of tag will make
>>>> more difficult the work for stable teams.
>>>>
>>>> In this specific case I think that:
>>>>
>>>> Fixes: 41f891004063 ("bonding: ignore updelay param when there is no active slave")
>>>>
>>>> should be ok, WDYT? if you agree would you mind repost for -net?
>>>>
>>>> Thanks,
>>>>
>>>> Paolo
>>>>
>>>
>>> Yes that looks like a good one. I will repost to -net a v2 that includes changes to reduce the number of icmp echos sent before failing the test.
>>>
>>> Thanks,
>>> -Jon
>>>
>>
>> One minor nit - could you please change "mode 2" to "mode balance-xor" ?
>> It saves reviewers some grepping around the code to see what is mode 2.
>> Obviously one has to dig in the code to see how it's affected, but still
>> it is a bit more understandable. It'd be nice to add more as to why the link is not recovered,
>> I get it after reading the code, but it would be nice to include a more detailed explanation in the
>> commit message as well.
>>
>> Thanks,
>>   Nik
>>
> 
> Ah, I just noticed I'm late to the party. :)
> Nevermind my comments, no need for a v3.
> 

If there are other issues with v2. I will gladly include these comments 
in a v3.

Thanks,
-Jon

