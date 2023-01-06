Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA9FD660353
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 16:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235219AbjAFPcd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 10:32:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235807AbjAFPbr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 10:31:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 185F590872
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 07:30:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673019036;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZcTKvUKA9abXvjmSORhTIasq4C+lYOr4eidQtZ44FYo=;
        b=VvA8DbgqZU9wVwryDy+9qj9pOUswFzKNzqqSxyL38M0vnfVPVDekNC9ZzOfK3iHWaeevJk
        HyHampC5aRA2FN4mPx7yo+YYPjO12F9ovxn0TTLLlp1ybsxAjPctSvIFG7AEeQXOJtYAAr
        ayv7n5A9WI7Dx9GjjIzAdrG/tGMeVh8=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-320-Y6N9KjvmN2eaFWI-Keq-UA-1; Fri, 06 Jan 2023 10:30:35 -0500
X-MC-Unique: Y6N9KjvmN2eaFWI-Keq-UA-1
Received: by mail-ej1-f71.google.com with SMTP id gn28-20020a1709070d1c00b007c177fee5faso1340999ejc.23
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 07:30:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZcTKvUKA9abXvjmSORhTIasq4C+lYOr4eidQtZ44FYo=;
        b=qaJ1JNR8EtIGfJhOC1x5Xb5Bzvnp5dvP9oDNSQVTg+illDXVwvl9Eq63dc2ZB0mylU
         G7ktc1S8qknkDWG93JDiDfnHKTkcDTxAiPxBdVl/KsYezd4jJr8pkvshwx9hk2ow1fMo
         N6Ef8K+oyA9I87+A8h9LMf0+B1LEEoskDNJVi2vOGCcjKxDE0BTUjR+pKAmRdKXta7aI
         I6ucQAi210nxucmHyT31fHbkFqKzBwzmeTUuMHYrXXRGiSzmGQynw5fV6Ejte2nSayp7
         MeO9TiYSvPOZBhCUhG9Lx2cAHHmyHvprir2zl+00xv39irU6BmVk6cEuYWhQUywQ4mlr
         FTlQ==
X-Gm-Message-State: AFqh2kpB6NbdmYzUj6Ztb/T/VP4QDSdOnCeeeJdJWrllDFR/BRYy8HS0
        ZvhbwcKbLQpUjqE0PdVdsEjqBognSkD42dVOf8lAvACXy3mVEN5HOdaz1I6sfe2fSOrR5P2fmSy
        EERfRebYSGoEMuBed
X-Received: by 2002:a17:907:c011:b0:7c0:e5ca:411c with SMTP id ss17-20020a170907c01100b007c0e5ca411cmr45698529ejc.17.1673019034578;
        Fri, 06 Jan 2023 07:30:34 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtxPQLHUWhSXJNfMqJDUW8bZicGBmd3uFKSh22eOt4ijdsYD2+ZutQJKYTE+vlJomrXdCPMAw==
X-Received: by 2002:a17:907:c011:b0:7c0:e5ca:411c with SMTP id ss17-20020a170907c01100b007c0e5ca411cmr45698516ejc.17.1673019034420;
        Fri, 06 Jan 2023 07:30:34 -0800 (PST)
Received: from [192.168.42.222] (nat-cgn9-185-107-15-52.static.kviknet.net. [185.107.15.52])
        by smtp.gmail.com with ESMTPSA id qu25-20020a170907111900b0084c7574630csm506192ejb.97.2023.01.06.07.30.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jan 2023 07:30:33 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <c5d4142c-afa6-4f89-1918-735937a1a5af@redhat.com>
Date:   Fri, 6 Jan 2023 16:30:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Cc:     brouer@redhat.com, netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2 16/24] page_pool: Use netmem in page_pool_drain_frag()
Content-Language: en-US
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
References: <20230105214631.3939268-1-willy@infradead.org>
 <20230105214631.3939268-17-willy@infradead.org>
In-Reply-To: <20230105214631.3939268-17-willy@infradead.org>
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
> We're not quite ready to change the API of page_pool_drain_frag(),
> but we can remove the use of several wrappers by using the netmem
> throughout.
> 
> Signed-off-by: Matthew Wilcox (Oracle)<willy@infradead.org>
> ---
>   net/core/page_pool.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

