Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1C8A6601E6
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 15:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234951AbjAFOQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 09:16:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235233AbjAFOPs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 09:15:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 213557814B
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 06:15:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673014499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1HbAZFCQHoB7KCS88jGK1MvZ0nX1Vbznt6Ohf9bI3yc=;
        b=HFAgpGHXk8pZ2SGbZEMPIgu+25msWNayyk6k2M2UjIeX3MDF4VxtbcIKDNlNqiiIivWc5a
        v7twwQHtiQYXfpWDYYJvmfHSyBuDuJ0jSQ4Z6wmPbFZQyXIQ4X5lTxfekmAsP5FFzXDJeE
        zA9XWHuVH+XoLlH777dj+iuVKk8eWNQ=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-65-TB_hDHX6O3mUObwJwXKlBw-1; Fri, 06 Jan 2023 09:14:58 -0500
X-MC-Unique: TB_hDHX6O3mUObwJwXKlBw-1
Received: by mail-ej1-f70.google.com with SMTP id gn28-20020a1709070d1c00b007c177fee5faso1205936ejc.23
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 06:14:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1HbAZFCQHoB7KCS88jGK1MvZ0nX1Vbznt6Ohf9bI3yc=;
        b=IRpUcWilH+yyViCgYVN1RJgeK7ta1cGMrF85ew/ifIIuEkxUoaIO6mWJGH6LDW8wjI
         24e9LtH7z35DJGtpJqmnp8bioAGbBdMUKZDH/P5JwRAtnoZLn3bac5QPCgXCGr6aWNjA
         Mq5fRAusEMceeDUDl6B2hzH5QnL6CWNsb7YPmMEqdtHT8oeS8dsltPoY03cm4NuZToGQ
         /3U1grYo7HyPD4F7qq9EJjbsvXCod4RGLQyKmCuqXopXyAQnjAA53DEEnFpNnCH0xJhl
         cTDJO4Q5kBXmMsczganGBr+RMB0cvPNC1RRCmPYdslaxW58M5Rxb2NlhtJUR7ewzJMtk
         J9oQ==
X-Gm-Message-State: AFqh2koI/D09SIXFA+hth3leNqkIdZTHO8XRLU+Uwn01KdWxZAI/H1aB
        sKQVjpnlt1gGu+pTG1wfbsBJqQMLtp1Brunx3IaezWYIjaM8GQ8nqBUmlLhcuqXayomAjp0c908
        sJM3tNFU8MlzUjmMQ
X-Received: by 2002:a17:906:8a58:b0:7c1:6981:d062 with SMTP id gx24-20020a1709068a5800b007c16981d062mr48881719ejc.72.1673014496912;
        Fri, 06 Jan 2023 06:14:56 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvwdyVXbgCgJWgv/NtB4G/vAEMk5wPi9BulGNDj/NJSO6Ff3njXVIvsJxFsVM4OIl2HlPhTVg==
X-Received: by 2002:a17:906:8a58:b0:7c1:6981:d062 with SMTP id gx24-20020a1709068a5800b007c16981d062mr48881705ejc.72.1673014496713;
        Fri, 06 Jan 2023 06:14:56 -0800 (PST)
Received: from [192.168.42.222] (nat-cgn9-185-107-15-52.static.kviknet.net. [185.107.15.52])
        by smtp.gmail.com with ESMTPSA id k9-20020a17090646c900b00782e3cf7277sm429583ejs.120.2023.01.06.06.14.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jan 2023 06:14:56 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <bfeda5eb-9c51-f27e-a594-cf523696ff8e@redhat.com>
Date:   Fri, 6 Jan 2023 15:14:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Cc:     brouer@redhat.com, netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2 07/24] page_pool: Convert __page_pool_put_page() to
 __page_pool_put_netmem()
Content-Language: en-US
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
References: <20230105214631.3939268-1-willy@infradead.org>
 <20230105214631.3939268-8-willy@infradead.org>
In-Reply-To: <20230105214631.3939268-8-willy@infradead.org>
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
> Removes the call to compound_head() hidden in put_page() which
> saves 169 bytes of kernel text as __page_pool_put_page() is
> inlined twice.
> 
> Signed-off-by: Matthew Wilcox (Oracle)<willy@infradead.org>
> ---
>   net/core/page_pool.c | 29 +++++++++++++++++++----------
>   1 file changed, 19 insertions(+), 10 deletions(-)

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

