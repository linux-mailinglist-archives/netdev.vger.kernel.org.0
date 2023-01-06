Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2AF86603CA
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 16:57:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbjAFP5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 10:57:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbjAFP5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 10:57:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3878CDF6A
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 07:56:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673020612;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vkf6Ae1nCEusZfYqyceAIihW5dOwzi3Mo4FjNFuOSXk=;
        b=PMXtXduT8ML7HoYiD3NaD6LSPRICzf3AyOjwTh/DEtp/6UGj8uftdXZlm0bELQP+nNIZo7
        zrCfS5rsIQ8OjTXjxITlQ8vo5pkE5MsY5+BgIAAjAKpkBRq1fvPCUHtcKNnuTaqOqVpHRk
        tfeUjaZugK4fFxlAW051n1qTkkRsr70=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-315-oI27sGnfP3Wel2_6rkEBcg-1; Fri, 06 Jan 2023 10:56:50 -0500
X-MC-Unique: oI27sGnfP3Wel2_6rkEBcg-1
Received: by mail-ej1-f70.google.com with SMTP id jg25-20020a170907971900b007c0e98ad898so1384211ejc.15
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 07:56:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vkf6Ae1nCEusZfYqyceAIihW5dOwzi3Mo4FjNFuOSXk=;
        b=25Ij0fsZ9RL0XX3Kozku4PLkcocdrpUFqPUlCfAdQZBxfgHd8DthnZovlfCu/0WzXf
         mAUXmMf9yhOH8ugL5WW5sOqiGu2iqOJoQWlrSesCWvMDP+MH64DhdRnxjuuyoODIeOB6
         b/3T85IxMY5qrU/pgBUZj9R7j8IRI6Z/NVwJuuVJ7/M1qO8t3IK0a/TZrzTkDgg5pfm1
         BcQ/k71x1p1wCSzgcG83e6Iz9e1wUkMb/GBxSoPaLIrY+rFzsr/y5kyJ+cZHtPSMFpjL
         Qas8kZfR6JQNBGTWxN1Bx4Yw79M2L0heEODG7dNYTnAszLHwwj7kYxaT1bemy0a0m7tg
         atqA==
X-Gm-Message-State: AFqh2koSB107C/YbzsOCbzJmzSHifIxvuEsUlGFYpc/CNhuPyehIqZnz
        rCvufsbi2Z1Auke3TvgraKqs7gcRztsHdAXYFzOT/2g8AqpcVoHTdoKosFSDIGYgrxg4l7CGmod
        wfuma2FV/SuJ3na/z
X-Received: by 2002:a17:907:2be8:b0:7e6:bae:fa0f with SMTP id gv40-20020a1709072be800b007e60baefa0fmr51546700ejc.58.1673020609850;
        Fri, 06 Jan 2023 07:56:49 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvrhu3KgnkrS97eJkeh/xAzK0ZaDS/RF5NWD7fv4vpnWqioVW5DrG0V8l9SAawywpYdIZHH+Q==
X-Received: by 2002:a17:907:2be8:b0:7e6:bae:fa0f with SMTP id gv40-20020a1709072be800b007e60baefa0fmr51546690ejc.58.1673020609661;
        Fri, 06 Jan 2023 07:56:49 -0800 (PST)
Received: from [192.168.42.222] (nat-cgn9-185-107-15-52.static.kviknet.net. [185.107.15.52])
        by smtp.gmail.com with ESMTPSA id qw25-20020a1709066a1900b007ae1e528390sm505999ejc.163.2023.01.06.07.56.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jan 2023 07:56:48 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <fff5de0b-afec-ce1e-d1cc-f4b8babc442f@redhat.com>
Date:   Fri, 6 Jan 2023 16:56:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Cc:     brouer@redhat.com, netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2 20/24] mm: Remove page pool members from struct page
Content-Language: en-US
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
References: <20230105214631.3939268-1-willy@infradead.org>
 <20230105214631.3939268-21-willy@infradead.org>
In-Reply-To: <20230105214631.3939268-21-willy@infradead.org>
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
> These are now split out into their own netmem struct.
> 
> Signed-off-by: Matthew Wilcox (Oracle)<willy@infradead.org>
> ---
>   include/linux/mm_types.h | 22 ----------------------
>   include/net/page_pool.h  |  4 ----
>   2 files changed, 26 deletions(-)

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

