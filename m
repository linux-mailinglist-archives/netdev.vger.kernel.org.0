Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94209647754
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 21:32:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbiLHUc3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 15:32:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiLHUc2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 15:32:28 -0500
Received: from mx10lb.world4you.com (mx10lb.world4you.com [81.19.149.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B12284B47;
        Thu,  8 Dec 2022 12:32:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=kKGPa90V/pDs0W6z5wumrfyXH0DwrQpT4FFX1tz+27A=; b=tdY6JW0YTnCvpwEP/CCBUn1EOH
        aRKooEZijE/5Bsi3/jV64Ctn3FUKNLzQfoH5ZcYfZ4IyZSTS/llz9q42275p5R0VV2RrBz9c+u66O
        ltZMRW7OmqazJZksqPeGK/rt4geZzQQoGzT20WTslEhlLyvAdS13huGgkHRWzMbrvSR4=;
Received: from [88.117.53.17] (helo=[10.0.0.160])
        by mx10lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1p3NZ9-0001gV-ON; Thu, 08 Dec 2022 21:32:23 +0100
Message-ID: <45d4de61-9a6e-be55-5a00-9e7ff464f4be@engleder-embedded.com>
Date:   Thu, 8 Dec 2022 21:32:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next v2 5/6] tsnep: Add RX queue info for XDP support
Content-Language: en-US
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com
References: <20221208054045.3600-1-gerhard@engleder-embedded.com>
 <20221208054045.3600-6-gerhard@engleder-embedded.com>
 <Y5HfxltuOThxi+Wf@boxer>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <Y5HfxltuOThxi+Wf@boxer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
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

On 08.12.22 13:59, Maciej Fijalkowski wrote:
> On Thu, Dec 08, 2022 at 06:40:44AM +0100, Gerhard Engleder wrote:
>> Register xdp_rxq_info with page_pool memory model. This is needed for
>> XDP buffer handling.
>>
>> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
>> ---
>>   drivers/net/ethernet/engleder/tsnep.h      |  5 ++--
>>   drivers/net/ethernet/engleder/tsnep_main.c | 34 +++++++++++++++++-----
>>   2 files changed, 30 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/engleder/tsnep.h b/drivers/net/ethernet/engleder/tsnep.h
>> index 0e7fc36a64e1..70bc133d4a9d 100644
>> --- a/drivers/net/ethernet/engleder/tsnep.h
>> +++ b/drivers/net/ethernet/engleder/tsnep.h
>> @@ -127,6 +127,7 @@ struct tsnep_rx {
>>   	u32 owner_counter;
>>   	int increment_owner_counter;
>>   	struct page_pool *page_pool;
>> +	struct xdp_rxq_info xdp_rxq;
> 
> this occupies full cacheline, did you make sure that you don't break
> tsnep_rx layout with having xdp_rxq_info in the middle of the way?

Actually I did no cacheline optimisation for this structure so far.
I saw that igb/igc put xdp_rxq_info to the end. Is this best practice
to prevent other variables in the same cacheline of xdp_rxq?

>>   
>>   	u32 packets;
>>   	u32 bytes;
>> @@ -139,11 +140,11 @@ struct tsnep_queue {
>>   	struct tsnep_adapter *adapter;
>>   	char name[IFNAMSIZ + 9];
>>   
>> +	struct napi_struct napi;
>> +
>>   	struct tsnep_tx *tx;
>>   	struct tsnep_rx *rx;
>>   
>> -	struct napi_struct napi;
> 
> why this move?

I reordered it because napi is now initialised before tx/rx. A cosmetic
move.

Gerhard
