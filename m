Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8FD6D8BDC
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 02:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234495AbjDFA0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 20:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234501AbjDFAYn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 20:24:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A2487DAD
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 17:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680740586;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dmxYUd/8A3wAugrMWHGLFh0BYZ1r65I6RJYgA5IvTZw=;
        b=CXROgr7uNpDNn/YfD9amva9OnP5qzAZid/sQxN6O1npUnbblBvlW3rDVbDY1El19qSRuIx
        qL2Z7rNJc5BUqitEQ0DeGrXNorq1p4b9jfmV8Uc/N9NTekTCQOpnchbR9ERumaD0rstH7o
        8GoOEJ95HwbK9TpT3z7pyWq/ZFcNNn8=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-41-tcnr_dvdOmK2-EN3h7Jz_w-1; Wed, 05 Apr 2023 20:23:04 -0400
X-MC-Unique: tcnr_dvdOmK2-EN3h7Jz_w-1
Received: by mail-qv1-f69.google.com with SMTP id f8-20020a0cbec8000000b005b14a30945cso17134192qvj.8
        for <netdev@vger.kernel.org>; Wed, 05 Apr 2023 17:23:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680740584;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dmxYUd/8A3wAugrMWHGLFh0BYZ1r65I6RJYgA5IvTZw=;
        b=D6rnIsRRp0i/H+a+SKWnGuO4POy2/bDdNID85Kf8z3lFmRe/C/E3pgfNQFWEIYNf8c
         cXhrRhgSb83dnF9qLVT3UrRCAY6HaIMKOyKyozjt9gupgFYFKckoChb+7SEPjmQV7pxa
         kt3dakoeSmzksVcrjcxAKoZ2Bq1x0uhI2JMw4pl3wKgjtKWK9fUYsAhDaC0TQ2a5Y0b/
         UWQgIQ+eLYAfdA6UzUVfEFHnFFUDo/mVk+8mjZ4wAhpF5Mb9PUe+lCaayATXo+r+B413
         xN7ccpV2LA4Vgt95NBQsf/LMxEHN+2gcfd3oE0ZmcT098wksUhTZ8Ew4kf9E6rexJkfh
         tAXg==
X-Gm-Message-State: AAQBX9eC88iRu7ee6dyfRuUAp8P3y3hhz+KXYc3RyXVp1/dohsCCnHhN
        n+WOSsutvq+EyF+2UUyowo/vVlH+FLJGdDsb9Drrs+2UHAc+lx2S5ADXklgWItn33AZW6KylKKN
        aWfvvBe2ngLjIe4Xy
X-Received: by 2002:ac8:5b96:0:b0:3bf:d1b3:2bbb with SMTP id a22-20020ac85b96000000b003bfd1b32bbbmr7797513qta.13.1680740584126;
        Wed, 05 Apr 2023 17:23:04 -0700 (PDT)
X-Google-Smtp-Source: AKy350bINmMrUR3oXy5BPvidrztz5XltfR4WGMtZ+/sPLyxa8K0HePGw89rw/LG+qsUMYmmSRacKbg==
X-Received: by 2002:ac8:5b96:0:b0:3bf:d1b3:2bbb with SMTP id a22-20020ac85b96000000b003bfd1b32bbbmr7797504qta.13.1680740583916;
        Wed, 05 Apr 2023 17:23:03 -0700 (PDT)
Received: from [192.168.98.18] ([107.12.98.143])
        by smtp.gmail.com with ESMTPSA id t10-20020ac865ca000000b003b635a5d56csm46716qto.30.2023.04.05.17.23.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Apr 2023 17:23:03 -0700 (PDT)
Message-ID: <b9f37d6f-a52c-97bd-6cd4-1bc58c362e22@redhat.com>
Date:   Wed, 5 Apr 2023 20:23:01 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net 2/3] selftests: bonding: re-format bond option tests
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, Liang Li <liali@redhat.com>
References: <20230329101859.3458449-1-liuhangbin@gmail.com>
 <20230329101859.3458449-3-liuhangbin@gmail.com>
 <301d2861-1390-eaea-4521-90d4dcfe7336@redhat.com>
 <ZCZGDQezuxXJuMd5@Laptop-X1> <ZCuLTjZjg7pZqO0X@Laptop-X1>
 <ec1b7951-2890-9603-dce3-5623de4b814d@redhat.com>
 <ZC1GInfrzuZ8Rj8p@Laptop-X1>
Content-Language: en-US
From:   Jonathan Toppins <jtoppins@redhat.com>
In-Reply-To: <ZC1GInfrzuZ8Rj8p@Laptop-X1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/5/23 05:57, Hangbin Liu wrote:
> On Tue, Apr 04, 2023 at 12:34:03PM -0400, Jonathan Toppins wrote:
>>>>> I like this idea, we might want to separate network topology from library
>>>>> code however. That way a given test case can just include a predefined
>>>>
>>>> Would you like to help explain more clear? Separate network topology to where?
>>>
>>>
>>> Hi Jon, would you please help explain this part?
>>
>> Thanks for the ping. It looks like several test cases build largely the same
>> virtual network topology and then execute the test case. I was attempting to
>> point out that it might be better to provide a standard network topology and
>> then each test case utilizes this standard topology instead of each test
>> case rolling its own. Also, with my comment about separating out the
>> topology from library code I was accounting for the ability to support
>> multiple topologies, fe:
>>
>>   bond_lib.sh
>>   bond_topo_gateway.sh
>>   bond_topo_2.sh
>>
>> Then a given test case only includes/sources `bond_topo_gateway.sh` which
>> creates the virtual network.
> 
> Thank Jon, this is much clear to me now. I'm not good at naming.
> For topology with 2 down link devices, 1 client, I plan to name it
> bond_topo_2d1c.sh. So 3 down links devices, 2 clients will be
> bond_topo_3d2c.sh. If there is no switch between server and client, it could
> be bond_topo_2d1c_ns.sh.
> 
> I'm not sure if the name is weird to you. Any comments?
> 

Hi Hangbin, I do not have a particular preference for the naming. What 
you have proposed seems good to me.

-Jon

