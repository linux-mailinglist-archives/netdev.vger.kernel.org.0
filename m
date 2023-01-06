Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2437B66030B
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 16:24:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234291AbjAFPYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 10:24:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234399AbjAFPXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 10:23:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E602545670
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 07:23:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673018581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vkMlgudnEw9cYCp+n6zfUM112uSc+tuDo/FfsaWzwqc=;
        b=SA9KWthuL+uVJyQBUrQmc0Ao9L0QU7j2ONETDWGQwYW36BxvYSijOn3VXBymJ/6TByMs9F
        o+iya9geHEH51Kk3OTSMm6nD2iOlmDvI2+jDhXp6rR837malJgJqE95lyT2/sXquU0gmSH
        Snu4rk1pncdoXf4JeQgLJOaG4TESTnw=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-529-nae1WlimPOCBY0VOYvg3uQ-1; Fri, 06 Jan 2023 10:22:20 -0500
X-MC-Unique: nae1WlimPOCBY0VOYvg3uQ-1
Received: by mail-ej1-f70.google.com with SMTP id hd17-20020a170907969100b007c117851c81so1338990ejc.10
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 07:22:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vkMlgudnEw9cYCp+n6zfUM112uSc+tuDo/FfsaWzwqc=;
        b=hJJ1vrRjBOivVTcoI5RHF/CugKFeU26QTMW7I6GmsVynaRHn5tvoUIpF2lMbt+W/4o
         mGMUSFi/fkk3aHuVjVbDSJq4BOv+mrcJoVuODba496EH/ar022LpTmH2y9qWUsB9t6BA
         RdrrTYQxHaslWLpFhBvl+ahd1l8q/Jv1IVUuTq1aGJpFs3sKVlezWjHs52QqRS+xEJMZ
         twYR/WL1zcF8MUOUM7sSUi8u2Hs1wVhm88CpMUkvnD6R3SCVoehBODw0CNqS/C62nA6i
         6bNvZQf1ig5WUL4aD9pUoR8T+uIYQuf/vLQiM3vSLCAZEsFprokCM/4RlTrFaB/E7QeO
         FRcw==
X-Gm-Message-State: AFqh2kqum/kpxe6gPyRXcjyZOwFslKoVcBBKfD8su0/p6QvhryhIQWKI
        QToa5jECciu1UuAwELf27c4aDKc8I3GMwedvSbgv+CvXE2qmhqLg+PcPzgARBFitxjAgqauyXLf
        ykid/bk8vzhtOSePb
X-Received: by 2002:a17:906:2b16:b0:81b:f931:cb08 with SMTP id a22-20020a1709062b1600b0081bf931cb08mr53830172ejg.47.1673018539372;
        Fri, 06 Jan 2023 07:22:19 -0800 (PST)
X-Google-Smtp-Source: AMrXdXskB1uFKW7sCrySt3QwJTexCkq+KHK25MYr8JlE4mYtzsho/RGqB4+BwR1dK/+DDvQtlwcBXQ==
X-Received: by 2002:a17:906:2b16:b0:81b:f931:cb08 with SMTP id a22-20020a1709062b1600b0081bf931cb08mr53830160ejg.47.1673018539203;
        Fri, 06 Jan 2023 07:22:19 -0800 (PST)
Received: from [192.168.42.222] (nat-cgn9-185-107-15-52.static.kviknet.net. [185.107.15.52])
        by smtp.gmail.com with ESMTPSA id l10-20020a1709063d2a00b0078db18d7972sm497026ejf.117.2023.01.06.07.22.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jan 2023 07:22:18 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <2dc46e55-6d16-d8d5-b70c-02c283970d4a@redhat.com>
Date:   Fri, 6 Jan 2023 16:22:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Cc:     brouer@redhat.com, netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2 11/24] page_pool: Convert page_pool_empty_ring() to use
 netmem
Content-Language: en-US
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
References: <20230105214631.3939268-1-willy@infradead.org>
 <20230105214631.3939268-12-willy@infradead.org>
In-Reply-To: <20230105214631.3939268-12-willy@infradead.org>
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
> Retrieve a netmem from the ptr_ring instead of a page.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>   net/core/page_pool.c | 10 +++++-----
>   1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index e727a74504c2..0212244e07e7 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -755,16 +755,16 @@ EXPORT_SYMBOL(page_pool_alloc_frag);
>   
>   static void page_pool_empty_ring(struct page_pool *pool)
>   {
> -	struct page *page;
> +	struct netmem *nmem;
>   
>   	/* Empty recycle ring */
> -	while ((page = ptr_ring_consume_bh(&pool->ring))) {
> +	while ((nmem = ptr_ring_consume_bh(&pool->ring)) != NULL) {
>   		/* Verify the refcnt invariant of cached pages */
> -		if (!(page_ref_count(page) == 1))
> +		if (netmem_ref_count(nmem) != 1)
>   			pr_crit("%s() page_pool refcnt %d violation\n",
> -				__func__, page_ref_count(page));
> +				__func__, netmem_ref_count(nmem));
>   
> -		page_pool_return_page(pool, page);
> +		page_pool_return_netmem(pool, nmem);
>   	}
>

I like the changes as it makes code more human readable :-)

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

