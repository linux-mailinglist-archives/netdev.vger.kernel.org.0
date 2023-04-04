Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1789E6D68F7
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 18:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235176AbjDDQfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 12:35:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231516AbjDDQfC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 12:35:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83ABD40C4
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 09:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680626055;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QiVD/y4I2WnavOYWIxcNFC9RQGVGbQH5NBpUE72HY2g=;
        b=e3d0YsW7CY9Za58G98ex2rtb82ps/aL4a0xXH3nPsfsVo9WUMOCYcw0C2jeVy7O7axTh4J
        Uu2OJT2XOHRY1+Y66pBCShhnWKDWzUN8gfVux6DysOgL3U0nA5zY/HnXVjyY7un7c3kGJs
        OmXDXDPqW/7/jirVKz8s8Z+vMQiWwvA=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-481-uywvrkiFMDm2Le0q-ptSgg-1; Tue, 04 Apr 2023 12:34:06 -0400
X-MC-Unique: uywvrkiFMDm2Le0q-ptSgg-1
Received: by mail-qt1-f197.google.com with SMTP id m7-20020a05622a118700b003e4e203bc30so20155636qtk.7
        for <netdev@vger.kernel.org>; Tue, 04 Apr 2023 09:34:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680626046;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QiVD/y4I2WnavOYWIxcNFC9RQGVGbQH5NBpUE72HY2g=;
        b=H8FCF9Mu9u+pJLfUgQrfwBMw2ziVdYb+28xgNY7l17eY6CEIKWVpvzIbWrA44m2+xV
         l+FZOpB85ixa1swAepotGBgckgE+8L+WTzxY8CbRQwoQ31mgBY3rd4UC2JS2ljqWUca+
         AIdGF58dAjTi6DPMv8WxDbZH3AWzWSOrHWCZIp4b9NwX6aDj4qwcV3wj7w523hLRM3qg
         Cq5EMI8yMSiXwqSHGgtjMDYM/eLZ8LRSkcVGw7EZiu44Dt31J3UNTmMc7SMNsW+RMUfO
         465XJrK/n9YxID5oLhWjZo3s4zbRze24QIrsLlbMakoJ7k8IrL0JHed7+yS2V2DmD/4v
         wjdg==
X-Gm-Message-State: AAQBX9cCRFdnPB4VegzhD2nEAe/c3a+u9w7D2Kez2L92oV7edTkdfgP9
        Sq0tZNuLOD2vtfjlVi08/zVeshU86xrShXNZPJcK3vDqgc2gCJ6HsGkHhFZF2LEIsUwC67f7DYy
        BZxLSuLhUt6Cwxzoo
X-Received: by 2002:a05:6214:1c0f:b0:56e:af49:7a1d with SMTP id u15-20020a0562141c0f00b0056eaf497a1dmr5174693qvc.24.1680626046237;
        Tue, 04 Apr 2023 09:34:06 -0700 (PDT)
X-Google-Smtp-Source: AKy350Z/BTgfeq/3SGJGMCIKsaJ0Yhm9GuOW5g6w5HHwcMxNvOVcJylnMzalgZYrk+OEazgxstX44A==
X-Received: by 2002:a05:6214:1c0f:b0:56e:af49:7a1d with SMTP id u15-20020a0562141c0f00b0056eaf497a1dmr5174666qvc.24.1680626046006;
        Tue, 04 Apr 2023 09:34:06 -0700 (PDT)
Received: from [192.168.98.18] ([107.12.98.143])
        by smtp.gmail.com with ESMTPSA id l14-20020ac84a8e000000b003e393c9feb7sm3374404qtq.58.2023.04.04.09.34.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Apr 2023 09:34:05 -0700 (PDT)
Message-ID: <ec1b7951-2890-9603-dce3-5623de4b814d@redhat.com>
Date:   Tue, 4 Apr 2023 12:34:03 -0400
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
Content-Language: en-US
From:   Jonathan Toppins <jtoppins@redhat.com>
In-Reply-To: <ZCuLTjZjg7pZqO0X@Laptop-X1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/3/23 22:28, Hangbin Liu wrote:
> On Fri, Mar 31, 2023 at 10:31:47AM +0800, Hangbin Liu wrote:
>>>> +++ b/tools/testing/selftests/drivers/net/bonding/bond_lib.sh
>>>
>>> I like this idea, we might want to separate network topology from library
>>> code however. That way a given test case can just include a predefined
>>
>> Would you like to help explain more clear? Separate network topology to where?
> 
> 
> Hi Jon, would you please help explain this part?

Thanks for the ping. It looks like several test cases build largely the 
same virtual network topology and then execute the test case. I was 
attempting to point out that it might be better to provide a standard 
network topology and then each test case utilizes this standard topology 
instead of each test case rolling its own. Also, with my comment about 
separating out the topology from library code I was accounting for the 
ability to support multiple topologies, fe:

  bond_lib.sh
  bond_topo_gateway.sh
  bond_topo_2.sh

Then a given test case only includes/sources `bond_topo_gateway.sh` 
which creates the virtual network.

-Jon

> 
>>
>>> topology. A quick review of the test cases show a 2 node setup is the most
>>> common across all test cases.
>>
>> Liang suggested that with 2 clients we can test xmit_hash_policy. In
>> client_create() I only create 1 client for current testing. We can add more
>> clients in future.
>>
>> Thanks
>> Hangbin
> 

