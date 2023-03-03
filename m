Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99D746A9547
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 11:32:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbjCCKc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 05:32:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbjCCKc0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 05:32:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AABDA559D5
        for <netdev@vger.kernel.org>; Fri,  3 Mar 2023 02:31:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677839499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7hFKulmrqZbTf9q6Sh0sTv9iLMhiQyVri/7U3fZos58=;
        b=XpeJBgJI5B4RYCIYnzi+nnFoTjWZkVIzuRTeH0vXkSvKIm5tL+Kue/C8powXR3OsXFHtAw
        jD/SWZd5atbh1czv8g0QhRjOMynqc/93Z/RuEp2uh2JuTxbmTid+qjbCrrGLSI5iii8Kre
        Rw1nmg2S/ak1nhTadxBy6vOXaJHNhjM=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-413-xPYChlCTPyy66yW5sZgI7g-1; Fri, 03 Mar 2023 05:31:38 -0500
X-MC-Unique: xPYChlCTPyy66yW5sZgI7g-1
Received: by mail-ed1-f71.google.com with SMTP id u10-20020a056402064a00b004c689813557so3208563edx.10
        for <netdev@vger.kernel.org>; Fri, 03 Mar 2023 02:31:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7hFKulmrqZbTf9q6Sh0sTv9iLMhiQyVri/7U3fZos58=;
        b=PdiRY+ofWNOH7WPjdDjkJfHykn1qIX+aNC5QrbELXlIhJG8qqovcMBWs7SHwneHgvY
         1Q+7o+zEE9r+OCHcA9a0FS3d9LU10lbPqH/1Ydj32f+K5vf3RgCjKDgGSUWU740qKkiK
         oimZLtnvuZGc1Y38b+NI4ASSHFp+6+FpENhqMEQ+r8zKgUQXHAJg8tySDXrbO1OyAbt4
         xfdo0nF2PXPeQgJDv6yloLWVFBnDTF7KQPEl+dnq0ZPK9Y93rYNZ/cExZOpjuaYX+cX8
         FKWcZQ5gZyN3heRa6TdDO0cWiUH9szzas/PjyqeI896OtZHYB0XHOy08D9ey7jNydr+y
         8b0w==
X-Gm-Message-State: AO0yUKXNa9tOYLjOgFWRyf9aWBhug02BSIy9MuRlrVSScUG2HSw3GEyH
        nvhGrX7gb/zH7Orxfmf8qkRxHb397OdqarUifAHCXFX/HN5/IPOflylUFqxJE9gONoCX84FWPXR
        o+DZgAxHQ9HcDOzs9
X-Received: by 2002:a17:906:a882:b0:8aa:a802:adcd with SMTP id ha2-20020a170906a88200b008aaa802adcdmr1126697ejb.30.1677839497577;
        Fri, 03 Mar 2023 02:31:37 -0800 (PST)
X-Google-Smtp-Source: AK7set+dNeTha+dpDazmX7Y6KMFZSZy5QW/4mxFqD4WQL+q6eFTVdNlEwM6IxZz2Z/PPEAHrK/Ks/w==
X-Received: by 2002:a17:906:a882:b0:8aa:a802:adcd with SMTP id ha2-20020a170906a88200b008aaa802adcdmr1126668ejb.30.1677839497257;
        Fri, 03 Mar 2023 02:31:37 -0800 (PST)
Received: from [192.168.42.100] (nat-cgn9-185-107-15-52.static.kviknet.net. [185.107.15.52])
        by smtp.gmail.com with ESMTPSA id ci25-20020a170906c35900b008b23e619960sm803620ejb.139.2023.03.03.02.31.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Mar 2023 02:31:36 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <ac7c7be0-656a-8b5a-c629-e135e39f844a@redhat.com>
Date:   Fri, 3 Mar 2023 11:31:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Cc:     brouer@redhat.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Song Liu <song@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next v1 1/2] xdp: recycle Page Pool backed skbs built
 from XDP frames
Content-Language: en-US
To:     Yunsheng Lin <linyunsheng@huawei.com>,
        Alexander Lobakin <aleksander.lobakin@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>
References: <20230301160315.1022488-1-aleksander.lobakin@intel.com>
 <20230301160315.1022488-2-aleksander.lobakin@intel.com>
 <36d42e20-b33f-5442-0db7-e9f5ef9d0941@huawei.com>
In-Reply-To: <36d42e20-b33f-5442-0db7-e9f5ef9d0941@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 02/03/2023 03.30, Yunsheng Lin wrote:
> On 2023/3/2 0:03, Alexander Lobakin wrote:
>> __xdp_build_skb_from_frame() state(d):
>>
>> /* Until page_pool get SKB return path, release DMA here */
>>
>> Page Pool got skb pages recycling in April 2021, but missed this
>> function.
>>
>> xdp_release_frame() is relevant only for Page Pool backed frames and it
>> detaches the page from the corresponding Pool in order to make it
>> freeable via page_frag_free(). It can instead just mark the output skb
>> as eligible for recycling if the frame is backed by a PP. No change for
>> other memory model types (the same condition check as before).
>> cpumap redirect and veth on Page Pool drivers now become zero-alloc (or
>> almost).
>>
>> Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
>> ---
>>   net/core/xdp.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/core/xdp.c b/net/core/xdp.c
>> index 8c92fc553317..a2237cfca8e9 100644
>> --- a/net/core/xdp.c
>> +++ b/net/core/xdp.c
>> @@ -658,8 +658,8 @@ struct sk_buff *__xdp_build_skb_from_frame(struct xdp_frame *xdpf,
>>   	 * - RX ring dev queue index	(skb_record_rx_queue)
>>   	 */
>>   
>> -	/* Until page_pool get SKB return path, release DMA here */
>> -	xdp_release_frame(xdpf);
>> +	if (xdpf->mem.type == MEM_TYPE_PAGE_POOL)
>> +		skb_mark_for_recycle(skb);
> 
> 
> We both rely on both skb->pp_recycle and page->pp_magic to decide
> the page is really from page pool. So there was a few corner case
> problem when we are sharing a page for different skb in the driver
> level or calling skb_clone() or skb_try_coalesce().
> see:
> https://github.com/torvalds/linux/commit/2cc3aeb5ecccec0d266813172fcd82b4b5fa5803
> https://lore.kernel.org/netdev/MW5PR15MB51214C0513DB08A3607FBC1FBDE19@MW5PR15MB5121.namprd15.prod.outlook.com/t/
> https://lore.kernel.org/netdev/167475990764.1934330.11960904198087757911.stgit@localhost.localdomain/
> 
> As the 'struct xdp_frame' also use 'struct skb_shared_info' which is
> sharable, see xdp_get_shared_info_from_frame().
> 
> For now xdpf_clone() does not seems to handling frag page yet,
> so it should be fine for now.
> 
> IMHO we should find a way to use per-page marker, instead of both
> per-skb and per-page markers, in order to avoid the above problem
> for xdp if xdp has a similar processing as skb, as suggested by Eric.
> 

Moving to a per-page marker can be *more* expensive if the struct-page
memory isn't cache-hot.  So, if struct-page is accessed anyhow then sure
we can move it to a per-page marker.

> https://lore.kernel.org/netdev/CANn89iKgZU4Q+THXupzZi4hETuKuCOvOB=iHpp5JzQTNv_Fg_A@mail.gmail.com/
> 
>>   
>>   	/* Allow SKB to reuse area used by xdp_frame */
>>   	xdp_scrub_frame(xdpf);
>>
> 

