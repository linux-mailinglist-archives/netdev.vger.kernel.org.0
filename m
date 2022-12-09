Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE216647F07
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 09:12:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiLIIME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 03:12:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230057AbiLIIMA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 03:12:00 -0500
Received: from mx05lb.world4you.com (mx05lb.world4you.com [81.19.149.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C1443FBAA;
        Fri,  9 Dec 2022 00:11:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=XC5/MMmtJdf0hJ+jzFyQ1kSBjAfC/+KimqL3WG7xuN4=; b=xd4cVeAfhTfNvV18S8zqs6Dk0v
        LSseYN5J30XzIdjur/UL/bnzQLhtPtk6VuUXLHCQ1/rGJEIFMui3MmmT2QjbNd/aJEpKCHY5NJogH
        hT//ARVi+vli36/dFysFvZp26sySNzBhCNE8G3SU0X8gvNT46w4N8YSYsb+Im+f4jS10=;
Received: from [88.117.53.17] (helo=[10.0.0.160])
        by mx05lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1p3YU5-0001XO-QT; Fri, 09 Dec 2022 09:11:53 +0100
Message-ID: <82b5acef-6d2f-6631-326e-6ec12b2257ec@engleder-embedded.com>
Date:   Fri, 9 Dec 2022 09:11:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next v2 5/6] tsnep: Add RX queue info for XDP support
Content-Language: en-US
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com
References: <20221208054045.3600-1-gerhard@engleder-embedded.com>
 <20221208054045.3600-6-gerhard@engleder-embedded.com>
 <Y5HfxltuOThxi+Wf@boxer>
 <45d4de61-9a6e-be55-5a00-9e7ff464f4be@engleder-embedded.com>
 <Y5KG7dhAjyzcPDHB@x130>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <Y5KG7dhAjyzcPDHB@x130>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09.12.22 01:53, Saeed Mahameed wrote:
> On 08 Dec 21:32, Gerhard Engleder wrote:
>> On 08.12.22 13:59, Maciej Fijalkowski wrote:
>>> On Thu, Dec 08, 2022 at 06:40:44AM +0100, Gerhard Engleder wrote:
>>>> Register xdp_rxq_info with page_pool memory model. This is needed for
>>>> XDP buffer handling.
>>>>
>>>> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
>>>> ---
>>>>  drivers/net/ethernet/engleder/tsnep.h      |  5 ++--
>>>>  drivers/net/ethernet/engleder/tsnep_main.c | 34 +++++++++++++++++-----
>>>>  2 files changed, 30 insertions(+), 9 deletions(-)
>>>>
>>>> diff --git a/drivers/net/ethernet/engleder/tsnep.h 
>>>> b/drivers/net/ethernet/engleder/tsnep.h
>>>> index 0e7fc36a64e1..70bc133d4a9d 100644
>>>> --- a/drivers/net/ethernet/engleder/tsnep.h
>>>> +++ b/drivers/net/ethernet/engleder/tsnep.h
>>>> @@ -127,6 +127,7 @@ struct tsnep_rx {
>>>>      u32 owner_counter;
>>>>      int increment_owner_counter;
>>>>      struct page_pool *page_pool;
>>>> +    struct xdp_rxq_info xdp_rxq;
>>>
>>> this occupies full cacheline, did you make sure that you don't break
>>> tsnep_rx layout with having xdp_rxq_info in the middle of the way?
>>
>> Actually I did no cacheline optimisation for this structure so far.
>> I saw that igb/igc put xdp_rxq_info to the end. Is this best practice
>> to prevent other variables in the same cacheline of xdp_rxq?
> 
> a rule of thumb, organize the structure in the same order they are
> being accessed in the data path.. but this doesn't go without saying you
> need to do some layout testing via pahole for example..
> It's up to you and the maintainer of this driver to decide how critical 
> this
> is.
> 
> Reviewed-by: Saeed Mahameed <saeed@kernel.org>

Thanks for the clarification, I will think about it.

I wrote the driver and I'm responsible to keep it working. Is this equal
to being the maintainer?

Thanks for the review!

Gerhard
