Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3BB6ECC90
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 15:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbjDXNFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 09:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231680AbjDXNFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 09:05:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABA3349D4
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 06:04:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682341478;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/0YH7r11q6UscFZQ0zFEaIBNUY38Om/+S3bNYxbYC28=;
        b=OOL9Y7Ko/R4+16pJDagCCm8hAO/6IGbwtBhFeZyOyFI+ywFJel/XGMg/VY1Pe2/mandISi
        JnEY3MU+H410XL49qKTEzwXgnJ8RhLblT4ZxSveml/TscBbLPMXxGL/a9iZlJcQg53+E+F
        w4UuNdog8+QqNt6VXMixcB4cxKoIDHQ=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-542-XTevYetTPvSezAAvll_k5g-1; Mon, 24 Apr 2023 09:04:35 -0400
X-MC-Unique: XTevYetTPvSezAAvll_k5g-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-94a356c74e0so392667766b.2
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 06:04:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682341474; x=1684933474;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/0YH7r11q6UscFZQ0zFEaIBNUY38Om/+S3bNYxbYC28=;
        b=SqHa1QmoQP5AartlAnSEc96zQ2MOXVXwRkvQg8WQmDccGcXQp4VzxigbyCZDYdTFMV
         H3ByIPWOK8TYquxFygijjd64PP1X8L87a1l63PremB2xtPjz/3TVKa2rDmwb+hu4pP8E
         DIq/Od2BGaFAkZnebqL2TKGr8ye8rSMXoKQao434Eic5hyd1zN08ivM4zcVm/cf2RLYc
         8bXCrbVPeRw5/lkJTSI8XhKAYYetXARaXfeW9mvvjjPj0E1azkyGL92NYkl40JSwdi+t
         iIvOLjO47kITtqvIXvYTeoEVbds/n1/P98akZAPHQcPGQ3I/7xBjBbQ0LHqkRYBsICRW
         oV9A==
X-Gm-Message-State: AAQBX9ftsXyy/L3j8FOr31iyrL6JMjKybrifdPzUcfldkDqrirvfiLud
        J0wI1gCQhaNgaEPuGLkRGkUzmOA/AgXdll3ZRgfd75EDRgxa8biHlNZ7Jbtbt3vOvr2jgtXD3lt
        AMMb/i5Ijm6IY+qFk
X-Received: by 2002:a17:906:300b:b0:951:756d:6542 with SMTP id 11-20020a170906300b00b00951756d6542mr10080426ejz.32.1682341473845;
        Mon, 24 Apr 2023 06:04:33 -0700 (PDT)
X-Google-Smtp-Source: AKy350Z2cQvL6MOBn9AOQgtIBxBTg+AhSMzFYt/T8A6VXgAuiTYliIhTBXv96NLAvRk+3Pi2rLh2Ig==
X-Received: by 2002:a17:906:300b:b0:951:756d:6542 with SMTP id 11-20020a170906300b00b00951756d6542mr10080393ejz.32.1682341473529;
        Mon, 24 Apr 2023 06:04:33 -0700 (PDT)
Received: from [192.168.42.222] (194-45-78-10.static.kviknet.net. [194.45.78.10])
        by smtp.gmail.com with ESMTPSA id th7-20020a1709078e0700b009596e7e0dbasm1770916ejc.162.2023.04.24.06.04.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Apr 2023 06:04:32 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <6b44fcd0-9210-4b2b-780a-09e24bba508a@redhat.com>
Date:   Mon, 24 Apr 2023 15:04:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Cc:     brouer@redhat.com, Lorenzo Bianconi <lorenzo@kernel.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        hawk@kernel.org, john.fastabend@gmail.com, ast@kernel.org,
        daniel@iogearbox.net
Subject: Re: [PATCH v2 net-next 1/2] net: veth: add page_pool for page
 recycling
Content-Language: en-US
To:     Yunsheng Lin <linyunsheng@huawei.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
References: <cover.1682188837.git.lorenzo@kernel.org>
 <6298f73f7cc7391c7c4a52a6a89b1ae21488bda1.1682188837.git.lorenzo@kernel.org>
 <4f008243-49d0-77aa-0e7f-d20be3a68f3c@huawei.com>
 <ZEU+vospFdm08IeE@localhost.localdomain>
 <3c78f045-aa8e-22a5-4b38-ab271122a79e@huawei.com>
 <ZEZJHCRsBVQwd9ie@localhost.localdomain>
 <0c1790dc-dbeb-8664-64ca-1f71e6c4f3a9@huawei.com>
In-Reply-To: <0c1790dc-dbeb-8664-64ca-1f71e6c4f3a9@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 24/04/2023 13.58, Yunsheng Lin wrote:
> On 2023/4/24 17:17, Lorenzo Bianconi wrote:
>>> On 2023/4/23 22:20, Lorenzo Bianconi wrote:
>>>>> On 2023/4/23 2:54, Lorenzo Bianconi wrote:
>>>>>>   struct veth_priv {
>>>>>> @@ -727,17 +729,20 @@ static int veth_convert_skb_to_xdp_buff(struct veth_rq *rq,
>>>>>>   			goto drop;
>>>>>>   
>>>>>>   		/* Allocate skb head */
>>>>>> -		page = alloc_page(GFP_ATOMIC | __GFP_NOWARN);
>>>>>> +		page = page_pool_dev_alloc_pages(rq->page_pool);
>>>>>>   		if (!page)
>>>>>>   			goto drop;
>>>>>>   
>>>>>>   		nskb = build_skb(page_address(page), PAGE_SIZE);
>>>>>
>>>>> If page pool is used with PP_FLAG_PAGE_FRAG, maybe there is some additional
>>>>> improvement for the MTU 1500B case, it seem a 4K page is able to hold two skb.
>>>>> And we can reduce the memory usage too, which is a significant saving if page
>>>>> size is 64K.
>>>>
>>>> please correct if I am wrong but I think the 1500B MTU case does not fit in the
>>>> half-page buffer size since we need to take into account VETH_XDP_HEADROOM.
>>>> In particular:
>>>>
>>>> - VETH_BUF_SIZE = 2048
>>>> - VETH_XDP_HEADROOM = 256 + 2 = 258
>>>
>>> On some arch the NET_IP_ALIGN is zero.
>>>
>>> I suppose XDP_PACKET_HEADROOM are for xdp_frame and data_meta, it seems
>>> xdp_frame is only 40 bytes for 64 bit arch and max size of metalen is 32
>>> as xdp_metalen_invalid() suggest, is there any other reason why we need
>>> 256 bytes here?
>>
>> XDP_PACKET_HEADROOM must be greater than (40 + 32)B because you may want push
>> new data at the beginning of the xdp_buffer/xdp_frame running
>> bpf_xdp_adjust_head() helper.
>> I think 256B has been selected for XDP_PACKET_HEADROOM since it is 4 cachelines
>> (but I can be wrong).
>> There was a discussion in the past to reduce XDP_PACKET_HEADROOM to 192B but
>> this is not merged yet and it is not related to this series. We can address
>> your comments in a follow-up patch when XDP_PACKET_HEADROOM series is merged.
> 
> It worth mentioning that the performance gain in this patch is at the cost of
> more memory usage, at most of VETH_RING_SIZE(256) + PP_ALLOC_CACHE_SIZE(128)
> pages is used.
> 

The general scheme with XDP is trading memory for speed up.

> IMHO, it seems better to limit the memory usage as much as possible, or provide a
> way to disable/enable page pool for user.
> 

Well, that sort of it exists right... If you disable XDP, or actually
NAPI (looking at patches), it will also disable the page pool.

I want to high-light that Lorenzo is "just" replacing allocating a full
page via alloc_page() to a faster api, that happens to cache some of
these pages.
In that sense, I think this patch makes sense ... isolated seen.

My concern beyond this patch is that netif_receive_generic_xdp() and
veth_convert_skb_to_xdp_buff() are both dealing with SKB-to-XDP
conversion, but they are diverting in how they do this.
(Is the challenge that veth will also see "TX" SKBs?)

Kind changing the direction, but I'm thinking why the beep are we
allocating+copying the entire contents of the SKB.
There must be a better way? (especially after XDP got frags support).

--Jesper

