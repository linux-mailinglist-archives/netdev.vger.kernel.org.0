Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 879876603B9
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 16:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232453AbjAFPwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 10:52:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233398AbjAFPwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 10:52:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6F90728BA
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 07:51:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673020313;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qPs88zrZ+jLjyqERyQWgINBt96bL0UXWc655zTk9zc4=;
        b=eIkus8L41eJ1quTE+WZkhB0B4FxcBLsOP7DBykl1YC4tN7XsO+RuvyGexFOmhjsLFvsheN
        tp7gYFcPK3NSAvsNIx8i25OhV47KaIPqwL99I2WpR4nsu5J34nOyWIRoB4dP8dVZ1GfbEB
        Ya5oPVMaoKs7xHzh74/w89ZhEbO62EA=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-303-70wvRJ36PsC0V5Nrz0wEkw-1; Fri, 06 Jan 2023 10:51:51 -0500
X-MC-Unique: 70wvRJ36PsC0V5Nrz0wEkw-1
Received: by mail-ej1-f71.google.com with SMTP id qf33-20020a1709077f2100b007c155ab74e9so1375084ejc.18
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 07:51:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qPs88zrZ+jLjyqERyQWgINBt96bL0UXWc655zTk9zc4=;
        b=e12oLT6u3c08+yH6wrl32mXvTBs5zqNNzVPkoidn0j7Rxe0olrMJI2UwLPq62vAfwr
         ElfVXQmV6qsQstN3xzzZx3wfqbFutzjhIZNx3ZJxsE3/9dksEhu2aH0z4bQDTYXFcx2S
         /SgzyzUafAw/eTcLNT0l+SwkmjvPJdykxSHTol6zW3udPiWEVmdERFgWSnkcLTVioHTi
         n1gB1U+buKcX1DwfQSQsQU/sOXJzawE3E7tjY72AGK7e6DwZHRQIw9oRGbD31M3VJJ6f
         sUPZGNwwPr1pGnt8kOo/9VGVuI2oXLlysUkXqsNg8z9vxjkP71YqO4Xp6Tgsbk2jbe8h
         Pfgw==
X-Gm-Message-State: AFqh2kpDyFmrCo5v2KiqU1kA3FRSfZzFIzJZFxJD5Yo2KurfEEdHQ33R
        SV7Nf78bnDrWXYYFr5SKa7Fw5pjL3gAiLLmiEIpXcXAopzZAVrY3CU6EY18KcuMCxL0Iu87cvwR
        lKdjMJO0TuuUanCgB
X-Received: by 2002:a05:6402:4141:b0:469:ee22:d97a with SMTP id x1-20020a056402414100b00469ee22d97amr50239342eda.32.1673020310723;
        Fri, 06 Jan 2023 07:51:50 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvpQunVLrPDSQOz5kOszKpfUoSJDJ2vHi7FxQvOELTdvFDRw7DAzl4UgCGCFV/xqrXIqSrkPQ==
X-Received: by 2002:a05:6402:4141:b0:469:ee22:d97a with SMTP id x1-20020a056402414100b00469ee22d97amr50239336eda.32.1673020310591;
        Fri, 06 Jan 2023 07:51:50 -0800 (PST)
Received: from [192.168.42.222] (nat-cgn9-185-107-15-52.static.kviknet.net. [185.107.15.52])
        by smtp.gmail.com with ESMTPSA id cb1-20020a170906a44100b0084d199d7f08sm517833ejb.21.2023.01.06.07.51.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jan 2023 07:51:50 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <3a3ad0cb-4176-cc83-5e7c-dc52bcb0d5c0@redhat.com>
Date:   Fri, 6 Jan 2023 16:51:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Cc:     brouer@redhat.com, netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2 18/24] page_pool: Convert frag_page to frag_nmem
Content-Language: en-US
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
References: <20230105214631.3939268-1-willy@infradead.org>
 <20230105214631.3939268-19-willy@infradead.org>
In-Reply-To: <20230105214631.3939268-19-willy@infradead.org>
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
> Remove page_pool_defrag_page() and page_pool_return_page() as they have
> no more callers.
> 
> Signed-off-by: Matthew Wilcox (Oracle)<willy@infradead.org>
> ---
>   include/net/page_pool.h | 17 ++++++---------
>   net/core/page_pool.c    | 47 ++++++++++++++++++-----------------------
>   2 files changed, 26 insertions(+), 38 deletions(-)

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

