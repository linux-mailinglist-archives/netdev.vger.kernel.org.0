Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E57CE6600F9
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 14:08:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233717AbjAFNIT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 08:08:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233525AbjAFNID (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 08:08:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFA746E406
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 05:07:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673010437;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wnlFpjFM8Ra9KtLz1z8CJvSdIhorBLJ5cJC0eKcQJqw=;
        b=dioHyOAaZZ8GC5dfmjLEvxo+7bBAJ1G9aHGey8sPLceoATK8C4YEZwubNCeovC3nSLG4c6
        jArkr4wo/iujV3IUkDLCdV4k06utIKppcSMiu4ScVbeIyEp+rBJjjhFGcdA6A6bqWajGNC
        XEeHzt0I58MoH4N+nppUMpH54Gg1/K0=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-245-wwy7gLo2MN-i_ovV9Ufrdg-1; Fri, 06 Jan 2023 08:07:16 -0500
X-MC-Unique: wwy7gLo2MN-i_ovV9Ufrdg-1
Received: by mail-ed1-f70.google.com with SMTP id m7-20020a056402510700b00488d1fcdaebso1186759edd.9
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 05:07:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:subject:cc:user-agent:mime-version:date:message-id:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wnlFpjFM8Ra9KtLz1z8CJvSdIhorBLJ5cJC0eKcQJqw=;
        b=CS1Vqa719gpmSCb7Erv1oeGeEITgpv2qfweHRucfL6ie/AM2QG975vdUeDjQgNPptR
         ka6GVZPbivAA5Ml0peAiAQv5JfFVPwQU19K84vyFqkytnv4xmjISo9S92f1z0I5I6m0p
         TXIA17NC/vDP9rz37m6LFuDwp0LEYdbylMmAMvuxT4SgOxf1jBMWnbacWRZo5WhWhiIN
         nOysATnhtdQ0w97OY1vs08E4arPB4Ah0ndkETJQEMdaFV+5YhE2Ck2F1OuheeHGZ6Gak
         tEj+ixkEkOsC5vuQbVXw7m/iIhsvWfWBU9n/TUOllFSdgkB6mTJV+vCIP6pzXkLW+Lbi
         9pDg==
X-Gm-Message-State: AFqh2krISortBmVlg/puaKYMC/lTjVJMFRvW6aYXFXPqwI523ofroJBX
        Gjgl0M0iGwMwuqGBN914YS4dM3SvXmgqq/W7W3U0sDfqKnP/lnakU7qovt1cN/Biv5SpTNXRAUB
        Ht7U2Z5QK+lNDd7/N
X-Received: by 2002:a05:6402:1c8b:b0:485:832:1e46 with SMTP id cy11-20020a0564021c8b00b0048508321e46mr33625694edb.23.1673010435709;
        Fri, 06 Jan 2023 05:07:15 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsS03bf5bYMCpSayOzjBqD2TeLo/HPDWk8sivJujymF+3Pwk/xwZ69Y/16Amblrp8M2NWnr9g==
X-Received: by 2002:a05:6402:1c8b:b0:485:832:1e46 with SMTP id cy11-20020a0564021c8b00b0048508321e46mr33625682edb.23.1673010435497;
        Fri, 06 Jan 2023 05:07:15 -0800 (PST)
Received: from [192.168.42.222] (nat-cgn9-185-107-15-52.static.kviknet.net. [185.107.15.52])
        by smtp.gmail.com with ESMTPSA id t18-20020aa7d712000000b0046b4e0fae75sm479331edq.40.2023.01.06.05.07.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jan 2023 05:07:14 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <255a407c-1dd2-9663-693a-0418dac9b215@redhat.com>
Date:   Fri, 6 Jan 2023 14:07:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Cc:     brouer@redhat.com, netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2 01/24] netmem: Create new type
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
References: <20230105214631.3939268-1-willy@infradead.org>
 <20230105214631.3939268-2-willy@infradead.org>
Content-Language: en-US
In-Reply-To: <20230105214631.3939268-2-willy@infradead.org>
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
> As part of simplifying struct page, create a new netmem type which
> mirrors the page_pool members in struct page.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>   Documentation/networking/page_pool.rst |  5 +++
>   include/net/page_pool.h                | 46 ++++++++++++++++++++++++++
>   2 files changed, 51 insertions(+)

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

