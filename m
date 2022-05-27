Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4A5D5366A0
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 19:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353335AbiE0RjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 13:39:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344304AbiE0Riw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 13:38:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4E20C33E81
        for <netdev@vger.kernel.org>; Fri, 27 May 2022 10:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653673127;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XH8JceMnzACPxOVYRi5rGL9yBlbFn5ESC6LUPE3+e88=;
        b=Q5qcQuC9+8Sp0z11SvSGpWDwYBFVtzvmFNEQ9Htbxv5jWxNJ0eLyRCrozQP10AIYJXYzte
        PB5uufXxEFDZQv0AEwFAEhTxr7LPqOK1hUThVTHs30i7625m3UqQdRrJKpoQdTcIbrWTN+
        T7q5Ti//B2EOAGwVbxWobGWfiwEzfTw=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-310-XQl1u4QYPeavC-rxBrrqOw-1; Fri, 27 May 2022 13:38:46 -0400
X-MC-Unique: XQl1u4QYPeavC-rxBrrqOw-1
Received: by mail-ej1-f72.google.com with SMTP id nb10-20020a1709071c8a00b006e8f89863ceso2708044ejc.18
        for <netdev@vger.kernel.org>; Fri, 27 May 2022 10:38:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent:cc
         :subject:content-language:to:references:in-reply-to
         :content-transfer-encoding;
        bh=XH8JceMnzACPxOVYRi5rGL9yBlbFn5ESC6LUPE3+e88=;
        b=kfEIv4AW9YOK0RISJ6FkVf94q+zYNivtKEwbnRFzFpMxqMH5bPjBESqW2D95n5fwJr
         fKZQE1DP9+qew/0MG9GAP9iJfui5wPx3gj6Cxx6JNOr+038n9LQXFXEXIbD2PmncEmfm
         +crKFygVvk6p5OKXxacM1RrFtXizqo05sWG+8RjylONMo5FHjp+6SEV252LGVULo3PM8
         FsrIZwBUr/i9awjkWMlpAFQUi5NULkHlWlTmKNSViOxIA98Yg/83QuYm2IQJ4jLACzhX
         45/w8NhFj564O/JE885pKsAwRtNV4EdanQuj5DUK6Y+NEnzUErRNHkrs5zZBYLzC6jrA
         3emg==
X-Gm-Message-State: AOAM532+PkfuwDsKkcukt0HBL5yuY7C39zwC4sKnDJcp6PygFQpJuOGO
        wUmAR3y6dDYTaB/IlKGCLg3qIIiij7GINzZkOkGdEVKKmxbtURRumCOL8DhYQXDEyDvPjETtpnH
        GGiWz+k5KIMbax6Db
X-Received: by 2002:a17:907:3f89:b0:6fe:e7a7:c038 with SMTP id hr9-20020a1709073f8900b006fee7a7c038mr23489291ejc.730.1653673125047;
        Fri, 27 May 2022 10:38:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxfq/KHum1beI0pgS8zFIy4p88rHKII0qWsjSMtxoomkBINIhFL+w4teXgASOhFb6U+XLzhsQ==
X-Received: by 2002:a17:907:3f89:b0:6fe:e7a7:c038 with SMTP id hr9-20020a1709073f8900b006fee7a7c038mr23489277ejc.730.1653673124823;
        Fri, 27 May 2022 10:38:44 -0700 (PDT)
Received: from [192.168.0.50] (87-59-106-155-cable.dk.customer.tdc.net. [87.59.106.155])
        by smtp.gmail.com with ESMTPSA id bg17-20020a170906a05100b006fef5088792sm1645631ejb.108.2022.05.27.10.38.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 May 2022 10:38:43 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <2e34593e-65e3-df74-1280-5db6dc948130@redhat.com>
Date:   Fri, 27 May 2022 19:38:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Cc:     brouer@redhat.com, bjorn@kernel.org, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: xdp: Directly use ida_alloc()/free()
Content-Language: en-US
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        keliu <liuke94@huawei.com>
References: <20220527064609.2358482-1-liuke94@huawei.com>
 <YpEFpVkxRRFi+Cs8@boxer>
In-Reply-To: <YpEFpVkxRRFi+Cs8@boxer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 27/05/2022 19.08, Maciej Fijalkowski wrote:
> On Fri, May 27, 2022 at 06:46:09AM +0000, keliu wrote:
>> Use ida_alloc()/ida_free() instead of deprecated
>> ida_simple_get()/ida_simple_remove() .
>>
>> Signed-off-by: keliu <liuke94@huawei.com>

Could you use your full name with capital letters?

> 
> Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> 
> For future AF_XDP related patches please specify the bpf-next tree in the
> patch subject (or bpf if it's a fix).

I agree.

Could you also take care of net/core/xdp.c ?

Patch LGTM

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>


>> ---
>>   net/xdp/xdp_umem.c | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
>> index f01ef6bda390..869b9b9b9fad 100644
>> --- a/net/xdp/xdp_umem.c
>> +++ b/net/xdp/xdp_umem.c
>> @@ -57,7 +57,7 @@ static int xdp_umem_addr_map(struct xdp_umem *umem, struct page **pages,
>>   static void xdp_umem_release(struct xdp_umem *umem)
>>   {
>>   	umem->zc = false;
>> -	ida_simple_remove(&umem_ida, umem->id);
>> +	ida_free(&umem_ida, umem->id);
>>   
>>   	xdp_umem_addr_unmap(umem);
>>   	xdp_umem_unpin_pages(umem);
>> @@ -242,7 +242,7 @@ struct xdp_umem *xdp_umem_create(struct xdp_umem_reg *mr)
>>   	if (!umem)
>>   		return ERR_PTR(-ENOMEM);
>>   
>> -	err = ida_simple_get(&umem_ida, 0, 0, GFP_KERNEL);
>> +	err = ida_alloc(&umem_ida, GFP_KERNEL);
>>   	if (err < 0) {
>>   		kfree(umem);
>>   		return ERR_PTR(err);
>> @@ -251,7 +251,7 @@ struct xdp_umem *xdp_umem_create(struct xdp_umem_reg *mr)
>>   
>>   	err = xdp_umem_reg(umem, mr);
>>   	if (err) {
>> -		ida_simple_remove(&umem_ida, umem->id);
>> +		ida_free(&umem_ida, umem->id);
>>   		kfree(umem);
>>   		return ERR_PTR(err);
>>   	}
>> -- 
>> 2.25.1
>>
> 

