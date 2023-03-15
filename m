Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01EC16BAB42
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 09:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231497AbjCOIz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 04:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231127AbjCOIz0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 04:55:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E6D8692
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 01:54:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678870480;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y64prv5wVg+DiyHgg8Ypb15ZWnjU+qEIj+pra6dvCIk=;
        b=ZWHoK3KD+Gu9xRalKrdJbXdGAiG0YtDXIfuscEkeT7Co0xKeL5azH7ntynPdsGzf4jrAVy
        9djPDU6FNirvP/dFgAc5tfbahb5tIc4VhG2QQRO6B7dS9ufL29rkLjM0OFM1KFR845GxiA
        HWiaCYC9Ay5UGlCY6q7yWI9JwptDNHI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-651-g5s57qsJNDevJtrRq1nCSA-1; Wed, 15 Mar 2023 04:54:39 -0400
X-MC-Unique: g5s57qsJNDevJtrRq1nCSA-1
Received: by mail-wr1-f70.google.com with SMTP id i11-20020a5d522b000000b002ceac3d4413so1460321wra.11
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 01:54:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678870478;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y64prv5wVg+DiyHgg8Ypb15ZWnjU+qEIj+pra6dvCIk=;
        b=X2J62UQjPuhGEC5zX4Rg1yKXenzoisr3d4cYTsaJpf2KXm2KjKXzoMZvhOpwdLZhQe
         69JzxTWcVx4t3sKsnJKyZotQS+fYBT3LMF340TYIPen469tkcNmtKCaqZuX0nAPWbzAR
         YeqyGY1xnnKKZf8WVwHTn+CHrjjoFpVGXXps27raOBWLTgvNtte471XIl6t+6YWR8xjt
         Gm9BKjGqdGq7VrC6SaoQu+tbGV+gubBD+NKIFAA5/4dvKAIUopdaP4s4mjroRm/eoYuD
         l2MGVN/K7MgXa3DaCOtPFt6VfwmW9Wie2DmVkobsAOKPPwrULnXEkM9KDv1zz/OwU4bX
         H7OQ==
X-Gm-Message-State: AO0yUKUPpZ3XWBFEZWS5BDxkNcsW1M+jjubB3QaolyyHpnWKYl30VGko
        ZS+TgVXtsbBjkK0tQwcRK874GAEsVjr3kWZxreX1eDjiwAkr6Hknvz+4vKDhs/z57LaCu9Wl/Zb
        XauqobmF/XPMMtXcf
X-Received: by 2002:a05:600c:3c8f:b0:3ea:bc08:b63e with SMTP id bg15-20020a05600c3c8f00b003eabc08b63emr17904838wmb.2.1678870477976;
        Wed, 15 Mar 2023 01:54:37 -0700 (PDT)
X-Google-Smtp-Source: AK7set9sWlOy8aQ26VqmsWKCnPdhNwduBkqTOXiH4erQE5Q5iX/1h7RTVf1Y4MTJOseK2BeBTjEWVQ==
X-Received: by 2002:a05:600c:3c8f:b0:3ea:bc08:b63e with SMTP id bg15-20020a05600c3c8f00b003eabc08b63emr17904823wmb.2.1678870477713;
        Wed, 15 Mar 2023 01:54:37 -0700 (PDT)
Received: from [192.168.1.163] ([188.65.88.100])
        by smtp.gmail.com with ESMTPSA id p8-20020a7bcc88000000b003e22508a343sm1173398wma.12.2023.03.15.01.54.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 01:54:37 -0700 (PDT)
Message-ID: <a2d55af3-df0c-2ed8-fc2c-78c0da6e6390@redhat.com>
Date:   Wed, 15 Mar 2023 09:54:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH RESEND net-next v4 4/4] sfc: remove expired unicast PTP
 filters
Content-Language: en-US
To:     Edward Cree <ecree.xilinx@gmail.com>, habetsm.xilinx@gmail.com,
        richardcochran@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        Yalin Li <yalli@redhat.com>
References: <20230314100925.12040-1-ihuguet@redhat.com>
 <20230314100925.12040-5-ihuguet@redhat.com>
 <fcd12738-5e59-3483-540a-b0f6bb639bbd@gmail.com>
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
In-Reply-To: <fcd12738-5e59-3483-540a-b0f6bb639bbd@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



El 14/3/23 a las 18:24, Edward Cree escribió:
> On 14/03/2023 10:09, Íñigo Huguet wrote:
>> Filters inserted to support unicast PTP mode might become unused after
>> some time, so we need to remove them to avoid accumulating many of them.
>>
>> Actually, it would be a very unusual situation that many different
>> addresses are used, normally only a small set of predefined
>> addresses are tried. Anyway, some cleanup is necessary because
>> maintaining old filters forever makes very little sense.
>>
>> Reported-by: Yalin Li <yalli@redhat.com>
>> Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
> 
> Acked-by: Edward Cree <ecree.xilinx@gmail.com>
> but again a couple of nits to think about...
> 
>>  static int efx_ptp_insert_eth_multicast_filter(struct efx_nic *efx)
>>  {
>> +	struct efx_ptp_data *ptp = efx->ptp_data;
>>  	const u8 addr[ETH_ALEN] = PTP_ADDR_ETHER;
>>  	struct efx_filter_spec spec;
>>  
>> @@ -1418,7 +1437,7 @@ static int efx_ptp_insert_eth_multicast_filter(struct efx_nic *efx)
>>  	efx_filter_set_eth_local(&spec, EFX_FILTER_VID_UNSPEC, addr);
>>  	spec.match_flags |= EFX_FILTER_MATCH_ETHER_TYPE;
>>  	spec.ether_type = htons(ETH_P_1588);
>> -	return efx_ptp_insert_filter(efx, &efx->ptp_data->rxfilters_mcast, &spec);
>> +	return efx_ptp_insert_filter(efx, &ptp->rxfilters_mcast, &spec, 0);
>>  }
> 
> If respinning for any reason, maybe move the addition of the
>  local to patch #2.
> 
>> +static void efx_ptp_drop_expired_unicast_filters(struct efx_nic *efx)
>> +{
>> +	struct efx_ptp_data *ptp = efx->ptp_data;
>> +	struct efx_ptp_rxfilter *rxfilter, *tmp;
>> +
>> +	list_for_each_entry_safe(rxfilter, tmp, &ptp->rxfilters_ucast, list) {
>> +		if (time_is_before_jiffies(rxfilter->expiry))
>> +			efx_ptp_remove_one_filter(efx, rxfilter);
>> +	}
>> +}
>> +
>>  static int efx_ptp_start(struct efx_nic *efx)
>>  {
>>  	struct efx_ptp_data *ptp = efx->ptp_data;
>> @@ -1631,6 +1666,8 @@ static void efx_ptp_worker(struct work_struct *work)
>>  
>>  	while ((skb = __skb_dequeue(&tempq)))
>>  		efx_ptp_process_rx(efx, skb);
>> +
>> +	efx_ptp_drop_expired_unicast_filters(efx);
>>  }
> PTP worker runs on every PTP packet TX or RX, which might be
>  quite frequent.  It's probably fine but do we need to consider
>  limiting how much time we spend repeatedly scanning the list?

PTP traffic is not that frequent, few packets per second, isn't it?

> Conversely, if all PTP traffic suddenly stops, I think existing
>  unicast filters will stay indefinitely.  Again probably fine
>  but just want to check that sounds sane to everyone.

Yes, it's as you say. However, I thought it didn't worth it to create a new periodic worker only for this, given that I expected a short list, it wouldn't be harmful. However, as I said in the other message, maybe the list can be quite long if we're the PTP master?

Maybe I should create a dedicated periodic work for this? That would avoid both problems that you are pointing out.

