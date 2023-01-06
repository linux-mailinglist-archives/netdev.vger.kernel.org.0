Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A62E86601CE
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 15:11:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233709AbjAFOLl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 09:11:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbjAFOLj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 09:11:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DE6DB481
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 06:10:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673014249;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=68B4uxuvOTqsVhTe1i1YRzx790Qk2POgDsBQiKTnCXg=;
        b=FyCUjFjXXCjqP4n6yNy/vzeU5H0Vnm3E1DO/MXKrbMW/+XTcfZUaNFI5ehc0mtuWdfKJvy
        BRwSBv9GhEbSmZ8OD2/8mwPx0zV7uGdJtITWgd22gNuGPF0jDXgkaouz/fjWdtBXCBKVBl
        Owg4H30xc+orj/IlaWwO4ty/Mf4dFgo=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-262-KS1sjR1YMGy1SV_20hEKRg-1; Fri, 06 Jan 2023 09:10:48 -0500
X-MC-Unique: KS1sjR1YMGy1SV_20hEKRg-1
Received: by mail-ed1-f72.google.com with SMTP id q10-20020a056402518a00b0048e5bc8cb74so1310972edd.5
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 06:10:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=68B4uxuvOTqsVhTe1i1YRzx790Qk2POgDsBQiKTnCXg=;
        b=WbkLNxTtQRRYDRsBdkFA5jtc+unkNHFn3hSrHj1HAPe/EqWPomi8cvL37xQZVweTCg
         GpYrST0+QbC4XoYjAHlFFJU7haes7iY0ZtllIgLTTutf8cs5kMY/AnejYEGoAVh3d4Ld
         eQ8xGCRxMrpRrlafCOS7jfosq/KRDqSTEBf5IVnzodYE7b5rvhLhSkuYYfAWEn9E/Hvs
         xT/nqy3+Qekqa1jXgl7cTWjbBZMtjnXk8vGdtUqv6asWWqU7xkAs9gCgghUmv30vrYQG
         ElnA6WNmsDop4GNEgp2ARApQewvC9XO2IoBMJug8DOHC2H2ScxMGUBxspnAIDbjcojOP
         3xPg==
X-Gm-Message-State: AFqh2kp4yU1PV525o5VOjT8IEYxyJ4D8LcEzaY55VG1dvqId14tWASSV
        9z7rT2JI6XJGBm53ymp9pPldMQIlOZ33o6jyR6n8em635z+Oqy9KNgA78o/3Dn2Nl97/uppmYSj
        X+ZccbRcsj2V0CftS
X-Received: by 2002:a05:6402:b91:b0:487:1a83:a6a0 with SMTP id cf17-20020a0564020b9100b004871a83a6a0mr30224682edb.13.1673014247141;
        Fri, 06 Jan 2023 06:10:47 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvnL2LNQENX9DlgXJJ9DHVGvoKuRN63U4CM/G9ueF0Kf1HaZ6+g8sa6S+mxtAdMycf4GqkuKg==
X-Received: by 2002:a05:6402:b91:b0:487:1a83:a6a0 with SMTP id cf17-20020a0564020b9100b004871a83a6a0mr30224671edb.13.1673014246993;
        Fri, 06 Jan 2023 06:10:46 -0800 (PST)
Received: from [192.168.42.222] (nat-cgn9-185-107-15-52.static.kviknet.net. [185.107.15.52])
        by smtp.gmail.com with ESMTPSA id cx26-20020a05640222ba00b0048ec121a52fsm540827edb.46.2023.01.06.06.10.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jan 2023 06:10:46 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <248e66ab-fed5-690b-e9e6-bbc0ff07e5e6@redhat.com>
Date:   Fri, 6 Jan 2023 15:10:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Cc:     brouer@redhat.com, netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2 06/24] page_pool: Convert page_pool_return_page() to
 page_pool_return_netmem()
Content-Language: en-US
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
References: <20230105214631.3939268-1-willy@infradead.org>
 <20230105214631.3939268-7-willy@infradead.org>
In-Reply-To: <20230105214631.3939268-7-willy@infradead.org>
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
> Removes a call to compound_head(), saving 464 bytes of kernel text
> as page_pool_return_page() is inlined seven times.

Nice save for I-cache :-)

> Signed-off-by: Matthew Wilcox (Oracle)<willy@infradead.org>
> ---
>   net/core/page_pool.c | 14 ++++++++++----
>   1 file changed, 10 insertions(+), 4 deletions(-)

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

