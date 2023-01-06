Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C67066034C
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 16:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235628AbjAFPa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 10:30:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235711AbjAFPaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 10:30:01 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 544CD8CD04
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 07:29:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673018953;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1wUWIR1pBf+36GM7NJtjcUHrcIRi5uuTFeA03EHZtU4=;
        b=MJNxxQ+jDULGliKgxI7DDIZXe3ZtTDeZNa/+hYgyqR0zUGrSe3Lb9ebSXWH13rYppEXBnT
        HikR8pQ1t6JqhNinH0Nr3o2334EfBrpBNQhLmt9x9fXoFuqUmzHStBYUe3tLTKIZr4fP7Z
        XNqBYVXssxAR3mnRNDdqSvSuXGIn2gY=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-526-t-cEPJEtPeenFe04ODFZcg-1; Fri, 06 Jan 2023 10:29:12 -0500
X-MC-Unique: t-cEPJEtPeenFe04ODFZcg-1
Received: by mail-ej1-f69.google.com with SMTP id ga21-20020a1709070c1500b007c171be7cd7so1347330ejc.20
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 07:29:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1wUWIR1pBf+36GM7NJtjcUHrcIRi5uuTFeA03EHZtU4=;
        b=YQLKmSyr5vkwWj4Y4JQnWTmA0ykOBu5GLV9IGxKOKPyinKk5YE70zTupYhH4y+LJVu
         1PhnQthSkEXjLbcE2lihfBMQk8ytuzQ38DC9sS0Y4RlveSg2wejKfnvhZO03thgelXSb
         APL/eIC/4RdOv76CUvbZybMgEoyaRV0XSl/nnLs5Es7xb4zXw076bJQLo3ylfTh5FMs9
         ipXs4reu7gsEnX4HxPzFwGef55iWxn7syl4xiEi6aNMMnkmPKWokH+TIkkmXb4AxXXPO
         ELGTpKtHd9BvupMOQzoQ8U1Zy4urgOeKNYQS7oCSGMFWlOfiLSd5avnoOvTHEsbO9eZs
         NiAg==
X-Gm-Message-State: AFqh2kpZtqxLo9aJWBKiR2ZkFBCzXGO4oNtpF5eOdcsTIDc7OjTp2A3N
        10AUnCaI64J+t0ZgDfGhIVJQxZU07gEHvShJ9+snrskK91kUx+4uLBm2bWPbUX4s6NRDsP1Q7Me
        0gRguMtaKJIx3OfFx
X-Received: by 2002:a05:6402:4141:b0:461:8be6:1ac4 with SMTP id x1-20020a056402414100b004618be61ac4mr49237558eda.20.1673018951293;
        Fri, 06 Jan 2023 07:29:11 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuQXfucD2zloav9VhKP39b0J7fzf2v82t+gepLpv6wDYjzvZ+sBMeoNgQ2Ioyrsjs8I4OlojA==
X-Received: by 2002:a05:6402:4141:b0:461:8be6:1ac4 with SMTP id x1-20020a056402414100b004618be61ac4mr49237537eda.20.1673018951088;
        Fri, 06 Jan 2023 07:29:11 -0800 (PST)
Received: from [192.168.42.222] (nat-cgn9-185-107-15-52.static.kviknet.net. [185.107.15.52])
        by smtp.gmail.com with ESMTPSA id w1-20020aa7dcc1000000b0047a3a407b49sm592391edu.43.2023.01.06.07.29.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jan 2023 07:29:10 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <2fa9336c-ed32-565e-6dda-70b1d1deda18@redhat.com>
Date:   Fri, 6 Jan 2023 16:29:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Cc:     brouer@redhat.com, netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2 14/24] page_pool: Convert page_pool_recycle_in_cache()
 to netmem
Content-Language: en-US
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
References: <20230105214631.3939268-1-willy@infradead.org>
 <20230105214631.3939268-15-willy@infradead.org>
In-Reply-To: <20230105214631.3939268-15-willy@infradead.org>
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
> Removes a few casts.
> 
> Signed-off-by: Matthew Wilcox (Oracle)<willy@infradead.org>
> ---
>   net/core/page_pool.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

