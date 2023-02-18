Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB9A69BBAA
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 20:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229441AbjBRTx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Feb 2023 14:53:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjBRTx4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Feb 2023 14:53:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1DFBE051
        for <netdev@vger.kernel.org>; Sat, 18 Feb 2023 11:53:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676749988;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j2OWYgrWSQRR79WjukkpePfMta6tan+/1jwS3aIuBeQ=;
        b=VzFzcZqL/05xAGWcPYELMt/UsxRozSOhU0Tm8V9gz/ypD4x0wp3uW6cZfBJrDoQqu006Yy
        RmHxlJiy0iIMtyUJAOhjL+I4wzd7X+ednl0d9y+v/+KVAp0qevpEiAC6H3rsZNEJvHZpLn
        WZMqLHz4d0pq58SNVjP1zb2IcOF0W4A=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-660-0T0EWKEsPrqehB6vmAoX2A-1; Sat, 18 Feb 2023 14:53:07 -0500
X-MC-Unique: 0T0EWKEsPrqehB6vmAoX2A-1
Received: by mail-ed1-f71.google.com with SMTP id ee3-20020a056402290300b004acbe232c03so1418143edb.9
        for <netdev@vger.kernel.org>; Sat, 18 Feb 2023 11:53:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j2OWYgrWSQRR79WjukkpePfMta6tan+/1jwS3aIuBeQ=;
        b=vZjyM/EndOmVQ6j71XBulh5otEwuYXMCayMA45kwi9Vmcf9i4yvIjufT9D5D9hBrMX
         4UEUZpDM74+/3aiu8yBqK6xpHhRgTu01eiLrsvvQvdZxXFpVljrwnhC5C5R5KxFMRrPz
         /rB3tLFOYpBAtslbWJBrj8Zs4oDp/jPWuyhByTybtB2r4G/KU1m93W3jbDjaSa6pHEiR
         NRrW61wVF5C40RQWvb9S0N99sL4aa3HA4WXbNiweYKDP+lWvdzH+CdjtoSH+OcBBVPe7
         XhFjGXvIFCQazjgXVtV38WYx9bmjtmRQX9AJ0afXW2/Y8AEQgyn8rqqU0D4T+eyvyvVd
         X6gw==
X-Gm-Message-State: AO0yUKVPf8RB4yB0YqKxazhB8iBVvPYp/UYJXFedl4KpPc4qQ8qSg0Tl
        2bmY51tZZGoVg60mr6FG1ruWtJnVXAhlZAp3Apj+TdJGpbK0Ug5a/HtZ6Mk25NHy4QI2VL+9ksQ
        pG381Y9V6ECveuSmm
X-Received: by 2002:a17:907:3ea7:b0:7c1:765:9cfc with SMTP id hs39-20020a1709073ea700b007c107659cfcmr11152746ejc.34.1676749986590;
        Sat, 18 Feb 2023 11:53:06 -0800 (PST)
X-Google-Smtp-Source: AK7set+6b+RFWXPXaiC6lxP++8mwLfyI3WbWX/dVc3VwuCgFXhn/2gN97UrboPo7UHRdVfoadiguMg==
X-Received: by 2002:a17:907:3ea7:b0:7c1:765:9cfc with SMTP id hs39-20020a1709073ea700b007c107659cfcmr11152724ejc.34.1676749986341;
        Sat, 18 Feb 2023 11:53:06 -0800 (PST)
Received: from [192.168.42.100] (nat-cgn9-185-107-15-52.static.kviknet.net. [185.107.15.52])
        by smtp.gmail.com with ESMTPSA id v18-20020a1709060b5200b008a9e585786dsm3710306ejg.64.2023.02.18.11.53.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Feb 2023 11:53:05 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <04a324be-69d1-7378-8e7f-0f0d85c6c09d@redhat.com>
Date:   Sat, 18 Feb 2023 20:53:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Cc:     brouer@redhat.com, alexander.duyck@gmail.com,
        Alexander Duyck <alexanderduyck@fb.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] page_pool: add a comment explaining the fragment
 counter usage
Content-Language: en-US
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        netdev@vger.kernel.org
References: <20230217222130.85205-1-ilias.apalodimas@linaro.org>
In-Reply-To: <20230217222130.85205-1-ilias.apalodimas@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 17/02/2023 23.21, Ilias Apalodimas wrote:
> When reading the page_pool code the first impression is that keeping
> two separate counters, one being the page refcnt and the other being
> fragment pp_frag_count, is counter-intuitive.
> 
> However without that fragment counter we don't know when to reliably
> destroy or sync the outstanding DMA mappings.  So let's add a comment
> explaining this part.
> 
> Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
> Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>


> ---
> Changes since v2:
>   - Removed a uneeded commas on the comment
> Changes since v1:
>   - Update the comment withe the correct description for pp_frag_count
>   include/net/page_pool.h | 10 ++++++++++
>   1 file changed, 10 insertions(+)
> 
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index 34bf531ffc8d..ddfa0b328677 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -277,6 +277,16 @@ void page_pool_put_defragged_page(struct page_pool *pool, struct page *page,
>   				  unsigned int dma_sync_size,
>   				  bool allow_direct);
> 
> +/* pp_frag_count represents the number of writers who can update the page
> + * either by updating skb->data or via DMA mappings for the device.
> + * We can't rely on the page refcnt for that as we don't know who might be
> + * holding page references and we can't reliably destroy or sync DMA mappings
> + * of the fragments.
> + *
> + * When pp_frag_count reaches 0 we can either recycle the page if the page
> + * refcnt is 1 or return it back to the memory allocator and destroy any
> + * mappings we have.
> + */
>   static inline void page_pool_fragment_page(struct page *page, long nr)
>   {
>   	atomic_long_set(&page->pp_frag_count, nr);
> --
> 2.38.1
> 

