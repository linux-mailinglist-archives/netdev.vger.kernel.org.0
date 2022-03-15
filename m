Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 612544D97EB
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 10:42:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346755AbiCOJnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 05:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346746AbiCOJnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 05:43:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BF0FE4EF5E
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 02:42:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647337350;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ds972m32UsHYPTXO2zaE7harfTeBM/jXF+brjmWcEJU=;
        b=Sk9AE5DjhirNDBdoXcs411BYKYZf5z3c9cCQbtGBeN9ITOIrra1CCBZJZ47rou4RkL9Lme
        ESRiOoDnXeJ2jIEf6BpNEavMXXWt6WC1SARck0cFdN8JaC9U9X2bnZy6dQ81+cwjiI39zh
        OYJ3c3Ic93eMD9lUqRmDVETowhWOdr0=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-493-lkU-H0D1Pxu2FmD6yLMv1g-1; Tue, 15 Mar 2022 05:42:29 -0400
X-MC-Unique: lkU-H0D1Pxu2FmD6yLMv1g-1
Received: by mail-qv1-f69.google.com with SMTP id fw9-20020a056214238900b0043522aa5b81so16045715qvb.21
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 02:42:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ds972m32UsHYPTXO2zaE7harfTeBM/jXF+brjmWcEJU=;
        b=w5+yplYTz7BE9m14fNSmGKuy4d+Rv4EXWPRJvn3yvEFn+CMFbrvKpXhMivF7z4dIe9
         yyMbrWmTCV3c8BtDorinz4Z54uULwIzBySwsLfUN9ZM787gG5x2+KIxPFylUQk0S9rzb
         NHi+krLbdeK0vv05O+V6ntvFaYRnPYLOB409xuMugPgbqFIAAuwNn8xLIquBwEyP8QKx
         8B+AlFM54FmkadU0iIHsAeB1RafvlUBnGzmArNzQMAwY628dDNT72x9+rLW0mnwkhhJ0
         18GrEGAjMZuX5QO1d38n95Oi418Acw7IVQ1sJyoqTX4beQQiT1OCGs0oDlxwnfiAtX/G
         izKw==
X-Gm-Message-State: AOAM530jAE5IPnTElbDI0C4vesfnb12/7M7LqdwdoRdTjnN8lcNl4+Yo
        +y44GH52utcA5/b1adXQRtFRM0BaU0ytgUG9mbVOAxm2iiPanlc2KoYlQbMEWivx+NLzkmearui
        RvNVCNe+AbIoWMwUk
X-Received: by 2002:a05:6214:c6d:b0:440:ac02:7780 with SMTP id t13-20020a0562140c6d00b00440ac027780mr6806433qvj.3.1647337349126;
        Tue, 15 Mar 2022 02:42:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz42nBONUMqEZ4XOsuNGpVckpNWadr0jR4fGhO7CwI1fHw6DycfxJ/bVDSIU0KjGdkQQBH4Ag==
X-Received: by 2002:a05:6214:c6d:b0:440:ac02:7780 with SMTP id t13-20020a0562140c6d00b00440ac027780mr6806421qvj.3.1647337348926;
        Tue, 15 Mar 2022 02:42:28 -0700 (PDT)
Received: from sgarzare-redhat (host-212-171-187-184.pool212171.interbusiness.it. [212.171.187.184])
        by smtp.gmail.com with ESMTPSA id u19-20020a05622a199300b002e1a669eeb6sm11762076qtc.34.2022.03.15.02.42.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 02:42:28 -0700 (PDT)
Date:   Tue, 15 Mar 2022 10:42:22 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Longpeng(Mike)" <longpeng2@huawei.com>
Cc:     stefanha@redhat.com, mst@redhat.com, jasowang@redhat.com,
        arei.gonglei@huawei.com, yechuan@huawei.com,
        huangzhichao@huawei.com, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 2/3] vdpa: change the type of nvqs to u32
Message-ID: <20220315094222.nbrknj5lqtqnbvmt@sgarzare-redhat>
References: <20220315032553.455-1-longpeng2@huawei.com>
 <20220315032553.455-3-longpeng2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220315032553.455-3-longpeng2@huawei.com>
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 15, 2022 at 11:25:52AM +0800, Longpeng(Mike) wrote:
>From: Longpeng <longpeng2@huawei.com>
>
>Change vdpa_device.nvqs and vhost_vdpa.nvqs to use u32
>
>Signed-off-by: Longpeng <longpeng2@huawei.com>
>---
> drivers/vdpa/vdpa.c  |  6 +++---
> drivers/vhost/vdpa.c | 10 ++++++----
> include/linux/vdpa.h |  6 +++---
> 3 files changed, 12 insertions(+), 10 deletions(-)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

