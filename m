Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 086336601F3
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 15:20:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbjAFOUA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 09:20:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjAFOT6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 09:19:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48A9C7BDCA
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 06:19:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673014741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=34j7KhAoNDRapq+Tmw4Rc6jXDb/evOO5OOPPPJq+DbE=;
        b=VRdxNBiT3cumasnf8xZ2FGel6yX55j5uBo4cmjPIMu/ltUcrJTynh85t/fQwVtlZ8kNPX7
        v3RCIDN5uhHfhUssiepbotKkR9t37GCuAqbVNjcPeFG05rxwR/davRQDBsyXQ/uSfj3HVs
        dGoFWH/xi5Z79pthQm5ITDHDU05l6aY=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-594-Rwfh5wZMPxOSQcVjCBuMLQ-1; Fri, 06 Jan 2023 09:19:00 -0500
X-MC-Unique: Rwfh5wZMPxOSQcVjCBuMLQ-1
Received: by mail-ej1-f70.google.com with SMTP id sd1-20020a1709076e0100b00810be49e7afso1226523ejc.22
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 06:19:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=34j7KhAoNDRapq+Tmw4Rc6jXDb/evOO5OOPPPJq+DbE=;
        b=cZKd8KiYGa9wsZW1pcvY9lQV6X97f7Q01V+pC5VA1s3AXLXsYkMJ+A3e9CkTh96O3S
         x8TaSjIRSYmtTiPeMaMyWX0kr/dZdnXh5DdvQz8BDDOaLs/NxLZyaJWjKb7VeAxkg5nZ
         qlxJKMzsYdTtQTNtX6SqX2bBzql8FrQxt6suJfQzJAgfOQLyFdCzO6//3ufnYvF/9lX/
         qRZroZIcNb2IjWQsczf13gQ71um7/aL6s3/U89nBQoF9569ZSKucgvhZSpzJAbOsbgC/
         iONWp8YTPWfeyHhs3Ie5Ydaae5wO2EChsgqxfxsRhZ176Y3fbZ0AicrCq5bSn4f3U1zM
         b5Eg==
X-Gm-Message-State: AFqh2kpOXzMrGOqZb3nmhNk70Qbh1Quk7WczkWvcoE0fcL653oKCe2WR
        InnKq9815KSQMoP9mJ0iwJSqWYQJ/jLTzeejaHSDiklWP+YFewqyY9HWa8WFuJR6HinXWIa2a3L
        LMwQhkfP2Rw+pfW1z
X-Received: by 2002:a17:906:edd6:b0:84d:138a:316 with SMTP id sb22-20020a170906edd600b0084d138a0316mr4423671ejb.36.1673014739077;
        Fri, 06 Jan 2023 06:18:59 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvCSAVqt90f8FKNv39vDnpXXIvgQEnXX6pBIIUtz4guEJ1eigEsmnFf+9NMDLAqcTGSNQ2GeA==
X-Received: by 2002:a17:906:edd6:b0:84d:138a:316 with SMTP id sb22-20020a170906edd600b0084d138a0316mr4423658ejb.36.1673014738891;
        Fri, 06 Jan 2023 06:18:58 -0800 (PST)
Received: from [192.168.42.222] (nat-cgn9-185-107-15-52.static.kviknet.net. [185.107.15.52])
        by smtp.gmail.com with ESMTPSA id nd38-20020a17090762a600b0084d1b34973dsm444754ejc.61.2023.01.06.06.18.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jan 2023 06:18:58 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <8c4847dd-6ff8-109b-d3cd-587b17e8fe24@redhat.com>
Date:   Fri, 6 Jan 2023 15:18:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Cc:     brouer@redhat.com, netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2 08/24] page_pool: Convert pp_alloc_cache to contain
 netmem
Content-Language: en-US
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
References: <20230105214631.3939268-1-willy@infradead.org>
 <20230105214631.3939268-9-willy@infradead.org>
In-Reply-To: <20230105214631.3939268-9-willy@infradead.org>
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
> Change the type here from page to netmem.  It works out well to
> convert page_pool_refill_alloc_cache() to return a netmem instead
> of a page as part of this commit.
> 
> Signed-off-by: Matthew Wilcox (Oracle)<willy@infradead.org>
> ---
>   include/net/page_pool.h |  2 +-
>   net/core/page_pool.c    | 52 ++++++++++++++++++++---------------------
>   2 files changed, 27 insertions(+), 27 deletions(-)

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

