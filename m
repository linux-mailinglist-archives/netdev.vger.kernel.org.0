Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 036D16723DA
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 17:44:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbjARQo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 11:44:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbjARQns (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 11:43:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 033ED36B3F
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 08:42:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674060147;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aMOub1ZBfg5oynlLk/wGraeCyV9SMDn+MaxD1V/APb4=;
        b=aX/Tzus3wNBp9LDrsxJ9ojH10wG2g4YdF6yOfUXMoYOTQtlFiZIAEfDXX43Rlok2VIYjW7
        SX0qqmUcaLKIvrbNQjO2p8kRQxYsUlfo8Vcrkt2FOZpQJH24X46Vr41M1kWEMLQRdpJiLB
        St41sCJ4TQhURsaBSt7QOdJgyq0M/ik=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-56-vMu0Os9eMnSXrUbfAj_FLw-1; Wed, 18 Jan 2023 11:42:25 -0500
X-MC-Unique: vMu0Os9eMnSXrUbfAj_FLw-1
Received: by mail-ed1-f72.google.com with SMTP id q20-20020a056402519400b0049e5b8c71b3so592269edd.17
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 08:42:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aMOub1ZBfg5oynlLk/wGraeCyV9SMDn+MaxD1V/APb4=;
        b=PztL9wdnDO6a50kifz345UYjP9LkQTsXD+EWypJrez4CgPOZiEXqmjYTIzjY4Ouvkc
         nC8z+oRAr9EMjc2N//rB9+gSkASzQQZFgjscEo43VJ34Jb945jAF6MBwA7OIETcxq2yk
         bNAtdwXHkOZuMAyXf1EwbkgY8LY3K/yNJtmJPLbqlnvCi1PujI3NuD9K5yCcsocF7NIY
         oO5cRwCUnTOfQly1P75Trs5ZYNTkGoEGn4xbT8J1ZX/Ye/w/QpHOX00tu8sd1mLK04tY
         TrBiiw0B7nej/a/uD8Vmuh33yuCTohe1F2DPyPJrZnZEzkcvJa2P+qZW1xaMNpgLhfux
         qHog==
X-Gm-Message-State: AFqh2kqr5zVbbarXuFPSIJ+PRGJFrgT7qB6CnXFsoIQ3A+GuDCkCfmIv
        jJZOjT6s4+pn89jmCpGKU05lTDVoNWGLP8/7UC9gpQbX8/RlG+LNIhLVMnEJSbMp/G00mZi2moi
        ODy/l+Q5IqjMS7c06
X-Received: by 2002:a05:6402:5151:b0:494:dd8c:1098 with SMTP id n17-20020a056402515100b00494dd8c1098mr6867388edd.22.1674060144674;
        Wed, 18 Jan 2023 08:42:24 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuJuM3rYB0Hv0EapDdnex2/joeZ3dOgd0AxTVxpmwicJHFWC+tap29DZTFbPK0caNb8o6xRPA==
X-Received: by 2002:a05:6402:5151:b0:494:dd8c:1098 with SMTP id n17-20020a056402515100b00494dd8c1098mr6867374edd.22.1674060144480;
        Wed, 18 Jan 2023 08:42:24 -0800 (PST)
Received: from [192.168.41.200] (83-90-141-187-cable.dk.customer.tdc.net. [83.90.141.187])
        by smtp.gmail.com with ESMTPSA id l4-20020a056402344400b004822681a671sm14430983edc.37.2023.01.18.08.42.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Jan 2023 08:42:23 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <9b290dd9-3729-2371-b3ad-ac6570279027@redhat.com>
Date:   Wed, 18 Jan 2023 17:42:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Cc:     brouer@redhat.com, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, pabeni@redhat.com
Subject: Re: [PATCH net-next V2 2/2] net: kfree_skb_list use
 kmem_cache_free_bulk
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
References: <167361788585.531803.686364041841425360.stgit@firesoul>
 <167361792462.531803.224198635706602340.stgit@firesoul>
 <CANn89i+POvkrx-RW3WNA2-1oQSdHt2-0sOddQWwtGQkAbW9RFQ@mail.gmail.com>
In-Reply-To: <CANn89i+POvkrx-RW3WNA2-1oQSdHt2-0sOddQWwtGQkAbW9RFQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 18/01/2023 17.05, Eric Dumazet wrote:
> On Fri, Jan 13, 2023 at 2:52 PM Jesper Dangaard Brouer
> <brouer@redhat.com> wrote:
>>
>> The kfree_skb_list function walks SKB (via skb->next) and frees them
>> individually to the SLUB/SLAB allocator (kmem_cache). It is more
>> efficient to bulk free them via the kmem_cache_free_bulk API.
>>
>> This patches create a stack local array with SKBs to bulk free while
>> walking the list. Bulk array size is limited to 16 SKBs to trade off
>> stack usage and efficiency. The SLUB kmem_cache "skbuff_head_cache"
>> uses objsize 256 bytes usually in an order-1 page 8192 bytes that is
>> 32 objects per slab (can vary on archs and due to SLUB sharing). Thus,
>> for SLUB the optimal bulk free case is 32 objects belonging to same
>> slab, but runtime this isn't likely to occur.
>>
>> The expected gain from using kmem_cache bulk alloc and free API
>> have been assessed via a microbencmark kernel module[1].
>>
>> The module 'slab_bulk_test01' results at bulk 16 element:
>>   kmem-in-loop Per elem: 109 cycles(tsc) 30.532 ns (step:16)
>>   kmem-bulk    Per elem: 64 cycles(tsc) 17.905 ns (step:16)
>>
>> More detailed description of benchmarks avail in [2].
>>
>> [1] https://github.com/netoptimizer/prototype-kernel/tree/master/kernel/mm
>> [2] https://github.com/xdp-project/xdp-project/blob/master/areas/mem/kfree_skb_list01.org
>>
>> V2: rename function to kfree_skb_add_bulk.
>>
>> Reviewed-by: Saeed Mahameed <saeed@kernel.org>
>> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
>> ---
> 
> According to syzbot, this patch causes kernel panics, in IP fragmentation logic.
> 
> Can you double check if there is no obvious bug ?

Do you have a link to the syzbot issue?

--Jesper

