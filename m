Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2008A66031D
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 16:28:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234867AbjAFP2S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 10:28:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233592AbjAFP2Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 10:28:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7E7113A
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 07:27:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673018852;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wqldc59IyE6GClXAgz6o8M/DUbFE2wUbD1HBJcCrPDo=;
        b=hCbowdHqoRAVSPOzkpztvxnPYvDvjhOtptDaN6m3fA3utg3jgxkDwrnwMN5qewXTDy2sOI
        vlrzUw8k1Zxt7vJTdVIoVY1v4BmJvxqtAxl2yTWiJU9YYf2wt9w2cQPV03zIot9Coy4o0s
        h3IU3Ks0zCe39GHtCsdngoEq9eC86Bg=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-332-3fJsPP2SOQ-p6C4KipraSQ-1; Fri, 06 Jan 2023 10:27:30 -0500
X-MC-Unique: 3fJsPP2SOQ-p6C4KipraSQ-1
Received: by mail-ej1-f72.google.com with SMTP id qw20-20020a1709066a1400b007c1727f7c55so1339442ejc.2
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 07:27:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wqldc59IyE6GClXAgz6o8M/DUbFE2wUbD1HBJcCrPDo=;
        b=6c/7FuH86gd/ZaBCjxuqCEkXJ7wcnkomH12syUCHW1aYQjk5DCilLsH9LqAp7sF0w8
         skC2Yp5+byr7F2Xz2KBsx5cHymOgAUY0BkjtafFZzoNM8nHCv/j0N3KcOivM3YexyPPL
         Zcn5POHFzMqitbIR/nJtp3KhtrvSueZ9zh5Hj1bdMUdG6LxBCwBwRDnGGMq/WaMUNnip
         Zmg0CY6akR0+RramfRL37JqKA+VSWhdLAlmhoKquL9sBGcv54Y1JB920NcxNJ5KpGUfp
         i8y1aj8yLEv3BAHAT3ZXSdZX6Uv7ekO8MGoMfDvZ0Iy0ksAqtd1Jms6F5Gq9aL3nswen
         YBrA==
X-Gm-Message-State: AFqh2kqYRjkp398cCwg8dybH/wdxMMDHGSF9faVGTUo95OnXLbqMCQmG
        xmMteY4t1qCLtTGmI09aH/eg9d91cIqfpVpMrSXn/XgFyZuidszS92uRuT+7Ql1xWQWdGid1/6N
        XQmcxzhyLgKB15hyN
X-Received: by 2002:a05:6402:33a:b0:461:608f:f3e0 with SMTP id q26-20020a056402033a00b00461608ff3e0mr46482418edw.28.1673018849506;
        Fri, 06 Jan 2023 07:27:29 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtAz8mhik02/SF7ESF1JSYLiK3xTEHtMqrWtlv2nZq5iQtmDXoJwXywWasRLF8zfQz65AnZ8A==
X-Received: by 2002:a05:6402:33a:b0:461:608f:f3e0 with SMTP id q26-20020a056402033a00b00461608ff3e0mr46482405edw.28.1673018849301;
        Fri, 06 Jan 2023 07:27:29 -0800 (PST)
Received: from [192.168.42.222] (nat-cgn9-185-107-15-52.static.kviknet.net. [185.107.15.52])
        by smtp.gmail.com with ESMTPSA id n3-20020aa7c443000000b00486074b4ce4sm580485edr.68.2023.01.06.07.27.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jan 2023 07:27:28 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <5e54569c-fde8-02ba-894b-f545872b5cd4@redhat.com>
Date:   Fri, 6 Jan 2023 16:27:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Cc:     brouer@redhat.com, netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2 12/24] page_pool: Convert page_pool_alloc_pages() to
 page_pool_alloc_netmem()
Content-Language: en-US
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
References: <20230105214631.3939268-1-willy@infradead.org>
 <20230105214631.3939268-13-willy@infradead.org>
In-Reply-To: <20230105214631.3939268-13-willy@infradead.org>
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
> Add wrappers for page_pool_alloc_pages() and
> page_pool_dev_alloc_netmem().  Also convert __page_pool_alloc_pages_slow()
> to __page_pool_alloc_netmem_slow() and __page_pool_alloc_page_order()
> to __page_pool_alloc_netmem().  __page_pool_get_cached() now returns
> a netmem.
> 
> Signed-off-by: Matthew Wilcox (Oracle)<willy@infradead.org>
> ---
>   include/net/page_pool.h | 13 ++++++++++++-
>   net/core/page_pool.c    | 39 +++++++++++++++++++--------------------
>   2 files changed, 31 insertions(+), 21 deletions(-)

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

