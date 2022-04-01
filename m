Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F13224EE7BE
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 07:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238458AbiDAFXa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 01:23:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233906AbiDAFX1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 01:23:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6612D60CC2
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 22:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648790497;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eAAnzfZLLVlNK5OERojWZUUPvVIc99+Dw3jOsp5DP0k=;
        b=TuZ34O5urMJtDTiN73MN/VKzNxr6YjoWqDwxER+obYX/OIdIZz6dxZgc7p7VpyZB+HLrxv
        f6L0RxvyBCU96Q7sTBJOTmNJ8A9S4qoQ7hNUaNjgKvfARepmM2VW2MqHzWVrAsTSll2IdO
        zK95fxW1EXmhMCU0pDzb6vu19SfAynY=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-290-5aLxY1JINSa0gOryAYKyVw-1; Fri, 01 Apr 2022 01:21:36 -0400
X-MC-Unique: 5aLxY1JINSa0gOryAYKyVw-1
Received: by mail-ej1-f71.google.com with SMTP id ga31-20020a1709070c1f00b006cec400422fso916668ejc.22
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 22:21:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent:cc
         :subject:content-language:to:references:in-reply-to
         :content-transfer-encoding;
        bh=eAAnzfZLLVlNK5OERojWZUUPvVIc99+Dw3jOsp5DP0k=;
        b=LG8WkfIQB1M2pRRd9cX2lczR3fZnh8BUJrwM+Rpt1+Vow3rz1iuHo2YAQmvNB6KPHC
         TnOpiM4mjxbZDy2hE/JDYD0PUMuCaedT0SBleCsYFBpE5TrTdXMbpxS8ODC1QY3C5/e2
         9pNbmIZqBuoYdqXRjdIF/j3iVCyyeUNRh1NZx6poTOYhLS1vveYdNik0d85rt+WH8Tcy
         NLzPwlLMGXrEVGMikbFmJx9MfKhqm7gjRyrXGOgl0s3Mdfzh2sI41IquE4d5SGIBTYaT
         TQjBoILlONRN8rNSAbdq+K42/dQ8gnqph8ucckVbmpwgbAmquXga0+UgL9i5Xn41Id52
         RedQ==
X-Gm-Message-State: AOAM530KI/ztKvgIrJcof1GoVvRr/FJBMtcOddzJ3a60hWi5LFgJCZLF
        9J4OHa6M0t7Gml+c4ocOWpWgzRqsGBWnbtyQbAAF3f8IfeDPqTyJqGzz9sk2jnw5gfVEkLWJTul
        EpAYmZjDYW1pVRxX9
X-Received: by 2002:a05:6402:4491:b0:419:4aeb:a648 with SMTP id er17-20020a056402449100b004194aeba648mr19579733edb.411.1648790495021;
        Thu, 31 Mar 2022 22:21:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzHjnAt0qtx9dIy0FTdhfilLYM3BVKSb4mioFArI/5v+TqjKNMXVKTA7nDa5weGCvQOGi6Blw==
X-Received: by 2002:a05:6402:4491:b0:419:4aeb:a648 with SMTP id er17-20020a056402449100b004194aeba648mr19579727edb.411.1648790494832;
        Thu, 31 Mar 2022 22:21:34 -0700 (PDT)
Received: from [192.168.2.20] (3-14-107-185.static.kviknet.dk. [185.107.14.3])
        by smtp.gmail.com with ESMTPSA id m3-20020a17090679c300b006cf9ce53354sm586136ejo.190.2022.03.31.22.21.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 31 Mar 2022 22:21:34 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <44bbb611-842e-8b0f-f296-958485179dbc@redhat.com>
Date:   Fri, 1 Apr 2022 07:21:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Cc:     brouer@redhat.com, "hawk@kernel.org" <hawk@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net v3] skbuff: fix coalescing for page_pool fragment
 recycling
Content-Language: en-US
To:     Alexander Duyck <alexanderduyck@fb.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "linyunsheng@huawei.com" <linyunsheng@huawei.com>
References: <20220331102440.1673-1-jean-philippe@linaro.org>
 <MW5PR15MB51214C0513DB08A3607FBC1FBDE19@MW5PR15MB5121.namprd15.prod.outlook.com>
In-Reply-To: <MW5PR15MB51214C0513DB08A3607FBC1FBDE19@MW5PR15MB5121.namprd15.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 31/03/2022 20.44, Alexander Duyck wrote:
>> -----Original Message-----
>> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
>> Sent: Thursday, March 31, 2022 3:25 AM
>> To: ilias.apalodimas@linaro.org; Alexander Duyck
>> <alexanderduyck@fb.com>; linyunsheng@huawei.com
>> Cc: hawk@kernel.org; davem@davemloft.net; kuba@kernel.org;
>> pabeni@redhat.com; netdev@vger.kernel.org; Jean-Philippe Brucker <jean-
>> philippe@linaro.org>
>> Subject: [PATCH net v3] skbuff: fix coalescing for page_pool fragment
>> recycling
>>
>> Fix a use-after-free when using page_pool with page fragments. We
>> encountered this problem during normal RX in the hns3 driver:
> 
> <snip>
> 
>> ---
>>   net/core/skbuff.c | 15 +++++++++++----
>>   1 file changed, 11 insertions(+), 4 deletions(-)
>>
>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c index
>> ea51e23e9247..2d6ef6d7ebf5 100644
>> --- a/net/core/skbuff.c
>> +++ b/net/core/skbuff.c
>> @@ -5244,11 +5244,18 @@ bool skb_try_coalesce(struct sk_buff *to, struct
>> sk_buff *from,
>>   	if (skb_cloned(to))
>>   		return false;
>>
>> -	/* The page pool signature of struct page will eventually figure out
>> -	 * which pages can be recycled or not but for now let's prohibit slab
>> -	 * allocated and page_pool allocated SKBs from being coalesced.
>> +	/* In general, avoid mixing slab allocated and page_pool allocated
>> +	 * pages within the same SKB. However when @to is not pp_recycle
>> and
>> +	 * @from is cloned, we can transition frag pages from page_pool to
>> +	 * reference counted.
>> +	 *
>> +	 * On the other hand, don't allow coalescing two pp_recycle SKBs if
>> +	 * @from is cloned, in case the SKB is using page_pool fragment
>> +	 * references (PP_FLAG_PAGE_FRAG). Since we only take full page
>> +	 * references for cloned SKBs at the moment that would result in
>> +	 * inconsistent reference counts.
>>   	 */
>> -	if (to->pp_recycle != from->pp_recycle)
>> +	if (to->pp_recycle != (from->pp_recycle && !skb_cloned(from)))
>>   		return false;
>>
>>   	if (len <= skb_tailroom(to)) {
>> --
>> 2.25.1
> 
> This looks good to me. The impact should be minimal since it only applies to pp_recycle pages.
> 
> Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>

I really appreciate Alex that you helped review this, thanks! :-)

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

