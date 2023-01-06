Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 254BE66015E
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 14:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233857AbjAFNgY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 08:36:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbjAFNgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 08:36:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9707E4567C
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 05:35:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673012136;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LIoBt2cIV9yO6fK3uHUSYIcjRX0xwLFEsr7h2iHNS+A=;
        b=KKtp6ciJErEPDIySFLsKnMZknirn0y1ZNUW75vadqzi5c3HBpdqeigNp8eNmCSieiTmgNb
        xxvw9TuxbkKyOwR3PLQzxVJsBnxGqidSkaGqUj9HPe2G15BDaw/K8IrmhhHuKAW0nV3I66
        0IrtqSYkZY8KSsDzrgFVvT/BWxjOaoc=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-628-T9yEDL0oMzmPiAB7CU8PZQ-1; Fri, 06 Jan 2023 08:35:35 -0500
X-MC-Unique: T9yEDL0oMzmPiAB7CU8PZQ-1
Received: by mail-ej1-f72.google.com with SMTP id qw20-20020a1709066a1400b007c1727f7c55so1144538ejc.2
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 05:35:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LIoBt2cIV9yO6fK3uHUSYIcjRX0xwLFEsr7h2iHNS+A=;
        b=c+JRPR8BXoXXODExhQYuIvXLOdcInaGRFM88sXmkDWplMnQPaz/bmVdILEQuheSU6Y
         69ydONHoOTuf8lrNJy2p9bhoihxID1hezonMprkZ2c6E1eft74M14ZaeKFYR6/z8CXhQ
         hlvfiKfp8t1PEF6lbdhZGBMX0GNGu1clg23WD71ihjBwQDNDirGXQupGpqpEJb/HgEhh
         S4Y5lSkzR329tHOy9FQVwcQxr5dLaY7FKssWWv9J3VYkZDtfj+akqEkag2y4fIIByvnH
         yDyHNCyxuRA47+DSawdvm5GZAdVF3k+gBm9j/CapddsvcSydb2yeAdDWqjpGxBoQa0yI
         4Oxg==
X-Gm-Message-State: AFqh2kq1Kk6jVAuFIeIxjWMeYGP0VUOjdgHn4X6uZgVZrADsHO0kgUdq
        /WJyKIAh4HuF+BGy9nhQ2XyYuCsqyI67RWjKh7d/9zFNR17MhkP4VakqbrB7YhfMVr9d1q2eyRW
        4DZQCIKqEnR+4oPfr
X-Received: by 2002:a17:907:d045:b0:7c1:5464:3360 with SMTP id vb5-20020a170907d04500b007c154643360mr65541988ejc.65.1673012134665;
        Fri, 06 Jan 2023 05:35:34 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvWAUneBPUc38Wmpn/S6VLRUMXWYlzfkb+3PTkKLrSs5aK4knINco9ASbmEMCIyTnFye+LLsg==
X-Received: by 2002:a17:907:d045:b0:7c1:5464:3360 with SMTP id vb5-20020a170907d04500b007c154643360mr65541971ejc.65.1673012134493;
        Fri, 06 Jan 2023 05:35:34 -0800 (PST)
Received: from [192.168.42.222] (nat-cgn9-185-107-15-52.static.kviknet.net. [185.107.15.52])
        by smtp.gmail.com with ESMTPSA id 18-20020a170906319200b007c1651aeeacsm403265ejy.181.2023.01.06.05.35.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jan 2023 05:35:33 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <2bdb5499-beec-d44c-b23b-38ad11eaf554@redhat.com>
Date:   Fri, 6 Jan 2023 14:35:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Cc:     brouer@redhat.com, netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2 02/24] netmem: Add utility functions
Content-Language: en-US
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
References: <20230105214631.3939268-1-willy@infradead.org>
 <20230105214631.3939268-3-willy@infradead.org>
In-Reply-To: <20230105214631.3939268-3-willy@infradead.org>
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
> netmem_page() is defined this way to preserve constness.  page_netmem()
> doesn't call compound_head() because netmem users always use the head
> page; it does include a debugging assert to check that it's true.
> 
> Signed-off-by: Matthew Wilcox (Oracle)<willy@infradead.org>
> ---
>   include/net/page_pool.h | 59 +++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 59 insertions(+)

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

