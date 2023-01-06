Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 287D4660338
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 16:30:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235291AbjAFPaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 10:30:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235619AbjAFP33 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 10:29:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D00F3831B4
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 07:28:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673018922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7cFjv1lP/ZjmYEIybBWAW8pxgUkHvOZMDXzsmCKt9ko=;
        b=OCDfHL2SEdCgo7QCCzPaBVsw5s7kilCH0WwM+BjVIHkDIAcfWKLeRzW+FUxAcahAbPS60x
        m2McDhqeWGTXlWktlj8wKrEynHb3AWat+yT9P3Qlc9ESVQ2eD7v35Sf1zkRCp+Tij87HOR
        jkgQAj/Lp9iTlNKELfpctn1LqQdwj4U=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-359-JqIe1MpJMouWLQqDVZANoQ-1; Fri, 06 Jan 2023 10:28:38 -0500
X-MC-Unique: JqIe1MpJMouWLQqDVZANoQ-1
Received: by mail-ej1-f70.google.com with SMTP id dr5-20020a170907720500b00808d17c4f27so1336438ejc.6
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 07:28:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7cFjv1lP/ZjmYEIybBWAW8pxgUkHvOZMDXzsmCKt9ko=;
        b=T3GtrywhdDFe8+z9yvSzt5a3hzuH2Db6W1NBi3m5nJmPqosJiuZuPfVr4USgJkdysK
         C5HA7UOEIODgOehch/bKvu1FQI1vrRk76r7JehTL16f1mKpPvHCLRAoAZiE+16skFxEb
         0Dwv4/anrBsafsmb5iytOiGW19BXdaze9JHF5cQnrjDGE+b69IZ+u6NIbrUZV4M160nq
         lXPFq7PW0ZLLiN2sImlWKXDjPbD4Unw6wPg6HrOJ42l70VX1fIi/VqTXvIct8x2sTWNc
         /FUbAE0CSUErmSxuEhU1DmYmKP/bR5966xJc34yi7NloAJ9PCAiDsTZ0jiq1N7yktwXg
         ErFQ==
X-Gm-Message-State: AFqh2ko4O6/Pfq4CCPOsFPtKOtpdkpRQR0used9fdm68E9X7jP7KLbPp
        sFNw6dgXQXo8KBkAaGJ/3lcfiuv4q9I7ermDolp3xNopuHlq47WEhfb0Ujh4p9h1Wxc4wy4yhbj
        MtUsC9aIPwKxVDAbe
X-Received: by 2002:a17:906:b142:b0:7c1:6fd3:1efa with SMTP id bt2-20020a170906b14200b007c16fd31efamr52148986ejb.28.1673018917736;
        Fri, 06 Jan 2023 07:28:37 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvYdyDZturEy/KwLBFxjcp4Ho9Ml/tRtnMdah1QWYrijGz+JZ0M04tYC0+uilvtcfJ1Fsaylw==
X-Received: by 2002:a17:906:b142:b0:7c1:6fd3:1efa with SMTP id bt2-20020a170906b14200b007c16fd31efamr52148977ejb.28.1673018917564;
        Fri, 06 Jan 2023 07:28:37 -0800 (PST)
Received: from [192.168.42.222] (nat-cgn9-185-107-15-52.static.kviknet.net. [185.107.15.52])
        by smtp.gmail.com with ESMTPSA id g23-20020a170906349700b0072a881b21d8sm500220ejb.119.2023.01.06.07.28.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jan 2023 07:28:37 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <2fbe877b-20e8-b8d8-006e-69bd6f7665b5@redhat.com>
Date:   Fri, 6 Jan 2023 16:28:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Cc:     brouer@redhat.com, netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2 13/24] page_pool: Convert
 page_pool_dma_sync_for_device() to take a netmem
Content-Language: en-US
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
References: <20230105214631.3939268-1-willy@infradead.org>
 <20230105214631.3939268-14-willy@infradead.org>
In-Reply-To: <20230105214631.3939268-14-willy@infradead.org>
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
> Change all callers.
> 
> Signed-off-by: Matthew Wilcox (Oracle)<willy@infradead.org>
> ---
>   net/core/page_pool.c | 11 ++++++-----
>   1 file changed, 6 insertions(+), 5 deletions(-)

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

