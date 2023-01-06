Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B7E3660351
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 16:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235054AbjAFPb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 10:31:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235738AbjAFPas (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 10:30:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 395C88CD21
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 07:29:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673018988;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+IaDQyMKt0xbKCvngin5PhJsIPTsblNxvINiE3iZqHM=;
        b=dGgDtxxAyBMOt9HouOvvNWXUYS4e7fnKrSAKSXvZ2q7CNUMsCgNhhVU7M8jRL/IwUUrLeR
        iuUh7caoviEsQro9TZfhYfTYlFRxNzrmNdG8UWB/z+HX3lvAdHH+P148O0HhtkF1fI9D+a
        frebMS8ttuZQkmxoVym29tYP1DiyHlc=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-661-uhv9Hg-jPWexUdIvfuUygA-1; Fri, 06 Jan 2023 10:29:47 -0500
X-MC-Unique: uhv9Hg-jPWexUdIvfuUygA-1
Received: by mail-ej1-f70.google.com with SMTP id qf33-20020a1709077f2100b007c155ab74e9so1337573ejc.18
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 07:29:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+IaDQyMKt0xbKCvngin5PhJsIPTsblNxvINiE3iZqHM=;
        b=AV5AZBuVdumQAWNliDrY7T1/aPNJqyUJ7pe21REwZeixb4Adk2K/cglceDJfGVVjTw
         bOj5CQH61zUbW4HNBt1uNovprqd8TCZhVr6Jtu6VLS1fPMxF9zdHG3XLEcUCWmlnmHCi
         X3DwtunDgI/Fockq+9ryN4wolLAfGrGOFZTgmwj1FZQXN+XLS46Gtu6zLwSTxipx8Xss
         lqnpuO9pGpxA8RYHO2CjnkAvdg2QOKmvFvgBP3nJj2986O7ZzFHrZVRXKO8yWrrdsZBt
         FiOAorzEh7pfYgYSIwxI1RJiy+5ghY0fBtvkHJ8nRKXyerIhM0gDM3od8Ux8jaskq3+l
         hyyQ==
X-Gm-Message-State: AFqh2ko5CUzFVfUfXKtruuRwyJvf7W+A2H6Ebvrpf1Id7aVy96uocgGD
        1JIyBmBq6uBDbZ6fzW01G8XpH0m9nF6kCE8th27lhb/alBztPJBrmu1AdHStiBGoQbMP0PkmuSZ
        unwyF2BOdmnAha3aA
X-Received: by 2002:a05:6402:2a02:b0:470:44eb:9e58 with SMTP id ey2-20020a0564022a0200b0047044eb9e58mr50414189edb.30.1673018986213;
        Fri, 06 Jan 2023 07:29:46 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvgDUa91OennSCatnIFV9Vgy9spnDkvcVbnc4wI2VqOkr0eD88Dis/lNr9SJFJxoT3Cn0kaFw==
X-Received: by 2002:a05:6402:2a02:b0:470:44eb:9e58 with SMTP id ey2-20020a0564022a0200b0047044eb9e58mr50414178edb.30.1673018986057;
        Fri, 06 Jan 2023 07:29:46 -0800 (PST)
Received: from [192.168.42.222] (nat-cgn9-185-107-15-52.static.kviknet.net. [185.107.15.52])
        by smtp.gmail.com with ESMTPSA id c39-20020a509faa000000b00483cccdfeaesm602847edf.38.2023.01.06.07.29.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jan 2023 07:29:45 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <f2743684-5add-1bab-4c68-48d6aa0244a3@redhat.com>
Date:   Fri, 6 Jan 2023 16:29:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Cc:     brouer@redhat.com, netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2 15/24] page_pool: Remove page_pool_defrag_page()
Content-Language: en-US
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
References: <20230105214631.3939268-1-willy@infradead.org>
 <20230105214631.3939268-16-willy@infradead.org>
In-Reply-To: <20230105214631.3939268-16-willy@infradead.org>
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
> This wrapper is no longer used.
> 
> Signed-off-by: Matthew Wilcox (Oracle)<willy@infradead.org>
> ---
>   net/core/page_pool.c | 8 --------
>   1 file changed, 8 deletions(-)

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

