Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A47166022B
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 15:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232212AbjAFOa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 09:30:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235075AbjAFOaw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 09:30:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 509258099F
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 06:29:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673015392;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3hcVntwsh6lIO7yUjmF27Fv8L9IinEFcIgDUFlmwZeo=;
        b=NnZ4Bo78vCbCz6hSloQrQrw8GyQ7iBTnY3wzEdzQCfSoWyZ7G2z44hqerWGkKiBeWLWUtA
        cnqL6QbUymVJXQFktPW8kovSloEceW3iRJ8E5cIBJowUi2C4MPiNuqTBYgcH2QDpb4dPnI
        1J+QiUit8fR28LNYYI2UoSCB3cAXwMM=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-50-6aOenLoDMT6qZGopI6CqVg-1; Fri, 06 Jan 2023 09:29:51 -0500
X-MC-Unique: 6aOenLoDMT6qZGopI6CqVg-1
Received: by mail-ed1-f70.google.com with SMTP id g14-20020a056402090e00b0046790cd9082so1333677edz.21
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 06:29:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3hcVntwsh6lIO7yUjmF27Fv8L9IinEFcIgDUFlmwZeo=;
        b=vjVDlgTNzZIefRlsHSgQfaz0AmyvQjDtfFLZ5PZR5SYAJftlg9vTmXmgn5Fhru8Tkv
         AiVZsnfMvdmeeJN9MRetAdm9Bxa/3HA8Pl/3oy45izsi6rIoBNarTltVmE8MvN4/mZB5
         Na8b7sTm9/Q6iBTj1Af3goo1RbvpH2yjIZVsq6gQxvXcDrlZong717pU0JMQHAxkFmsT
         AHiQ0H7n1ueJ35LMHncy2uy+uCBu09akD5gNJ32PqHNHfnP8isCimISl+R6D97ZuJFWd
         dIY7lFQxWs2w3PfMGzYj7hxLWCeLL99BB2+KJMthp/PfCutMsW5NN9U8hC4YB4McacuA
         wBdw==
X-Gm-Message-State: AFqh2ko5+dxDX6TZN+eL2uYUMz5j7xI0bScjgRnqAPfeACHlw2jp6IVS
        +LfEgSUp2O3Nuv78BJjCo8RlpPb77Wz2QPiQDvEfaG+2YSiYFisemKVzMX/X7ykuF1fH3uNjy20
        WCBI+q2YaVlgG7wlt
X-Received: by 2002:a17:907:a08d:b0:7c1:6986:2b7c with SMTP id hu13-20020a170907a08d00b007c169862b7cmr43081973ejc.8.1673015390110;
        Fri, 06 Jan 2023 06:29:50 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvEKGFpZWIE6oJWLIuCf78gtspLpx4NaSyKAN6SUyS5zdrlD4FQ0/Rubr7bbgxJ4BPqx8gJWw==
X-Received: by 2002:a17:907:a08d:b0:7c1:6986:2b7c with SMTP id hu13-20020a170907a08d00b007c169862b7cmr43081960ejc.8.1673015389910;
        Fri, 06 Jan 2023 06:29:49 -0800 (PST)
Received: from [192.168.42.222] (nat-cgn9-185-107-15-52.static.kviknet.net. [185.107.15.52])
        by smtp.gmail.com with ESMTPSA id kx4-20020a170907774400b007c10d47e748sm454612ejc.36.2023.01.06.06.29.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jan 2023 06:29:49 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <95451dfd-cce7-f16f-4eec-ee6c73a23bdb@redhat.com>
Date:   Fri, 6 Jan 2023 15:29:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Cc:     brouer@redhat.com, netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2 09/24] page_pool: Convert page_pool_defrag_page() to
 page_pool_defrag_netmem()
Content-Language: en-US
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
References: <20230105214631.3939268-1-willy@infradead.org>
 <20230105214631.3939268-10-willy@infradead.org>
In-Reply-To: <20230105214631.3939268-10-willy@infradead.org>
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
> Add a page_pool_defrag_page() wrapper.
> 
> Signed-off-by: Matthew Wilcox (Oracle)<willy@infradead.org>
> ---
>   include/net/page_pool.h | 11 ++++++++---
>   1 file changed, 8 insertions(+), 3 deletions(-)

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

