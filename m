Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3157D660183
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 14:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbjAFNrA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 08:47:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbjAFNq6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 08:46:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F2D5265C
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 05:46:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673012771;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lg3yw+/az8CkGW+1upNiNNli1S0wuptJau1IqqB4JOw=;
        b=KsE32q3JQ6rVvAkbHWmV8PsFIFFEFFTxMNbd6A1HNoOJWOzxjs+idxbPlRIpNmGyRKlyGT
        v+jwT+/S7J/A+dkw34kjdrhQUWBuL5aVcLOKUP6FUnuCTrqi8RDTgWmvT7uzDwD2xiENpE
        thUtXs/pPIbhQry6eVAOZ10Q1aS801M=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-224-xJoN-JccPa6uYeAlv53Tnw-1; Fri, 06 Jan 2023 08:46:10 -0500
X-MC-Unique: xJoN-JccPa6uYeAlv53Tnw-1
Received: by mail-ed1-f70.google.com with SMTP id h8-20020a056402280800b0046af59e0986so1262561ede.22
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 05:46:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lg3yw+/az8CkGW+1upNiNNli1S0wuptJau1IqqB4JOw=;
        b=aR8Gr1nN77JC4FMuKbdwO1PkgUAx2Io2brjkgDXUEHmaU3P+nJMF3kMz1oHsFEXntT
         9RrP/66i2W/p5CTmBLJdCD1Car993EacMBuqjyIKdIMH27z0ANtl/+15vJS+Q61LFEJG
         AMkSQ+TnWcibw3eK0ylF8y0Z+xqShZvNgtkC1NxJveFa1fUwf8jLoRvwYGwfP4gSb4KN
         kjGgiZC3kK5u+NiT0705zy5NgT/3KJF2QHDXiJnhSEaGTAuM5ycyov7lUudIt5XR2oZY
         BqYsTADn9hRpfQ8oBARAU8mmlCKmcgCsaTqSxZ7a1MzjnD5QYClFdF5GXUH5pUCOo/7M
         sN6g==
X-Gm-Message-State: AFqh2kqYuETF7X1wp9Y0e1nKfpfKJdthi6MoBjxRmIz06ZccWJ/njcUz
        tZqPAJVB72hK9dRahx/6vc7cwrHZEJKqi9rsxHwPn0j2kPSWpKM86xW0l/ct62GfmBcveg2Y535
        qh8jkHcYSCk9mYX3v
X-Received: by 2002:a17:906:430a:b0:7c0:f909:1a23 with SMTP id j10-20020a170906430a00b007c0f9091a23mr42414661ejm.76.1673012769290;
        Fri, 06 Jan 2023 05:46:09 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvtS77BjElcPMXdcbFTrxQQChoqZYsvfPovB6cMzu/cYj758wmujdedh2wBgR3hpK72sCziHg==
X-Received: by 2002:a17:906:430a:b0:7c0:f909:1a23 with SMTP id j10-20020a170906430a00b007c0f9091a23mr42414647ejm.76.1673012769119;
        Fri, 06 Jan 2023 05:46:09 -0800 (PST)
Received: from [192.168.42.222] (nat-cgn9-185-107-15-52.static.kviknet.net. [185.107.15.52])
        by smtp.gmail.com with ESMTPSA id sb25-20020a1709076d9900b007a4e02e32ffsm423843ejc.60.2023.01.06.05.46.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jan 2023 05:46:08 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <528842d1-fbbb-8f89-5999-02e71633dc2e@redhat.com>
Date:   Fri, 6 Jan 2023 14:46:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Cc:     brouer@redhat.com, netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2 04/24] page_pool: Convert page_pool_release_page() to
 page_pool_release_netmem()
Content-Language: en-US
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
References: <20230105214631.3939268-1-willy@infradead.org>
 <20230105214631.3939268-5-willy@infradead.org>
In-Reply-To: <20230105214631.3939268-5-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 05/01/2023 22.46, Matthew Wilcox (Oracle) wrote:
> Also convert page_pool_clear_pp_info() and trace_page_pool_state_release()
> to take a netmem.  Include a wrapper for page_pool_release_page() to
> avoid converting all callers.
> 
> Signed-off-by: Matthew Wilcox (Oracle)<willy@infradead.org>
> ---
>   include/net/page_pool.h          | 14 ++++++++++----
>   include/trace/events/page_pool.h | 14 +++++++-------
>   net/core/page_pool.c             | 18 +++++++++---------
>   3 files changed, 26 insertions(+), 20 deletions(-)

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

