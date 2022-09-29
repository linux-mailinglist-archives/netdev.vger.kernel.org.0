Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0CCC5EEE33
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 09:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235007AbiI2HAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 03:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234991AbiI2HAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 03:00:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCDAA97D5F
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 00:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664434819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=siVqAVCemr3NKP1W8qdwtDUtzgPJwy1cV7KpGtWXqJw=;
        b=Il5V+K0Qd061c0hZAmecUk4GCsjzbwQg+g3zvIjQFJ6AlxpL+6D981N4rbuWZUbgAS3ZAi
        fbAbDxnYRKGJdvRBK9Var5XJiq1SnZ8QTlIZpWJK/dan9uswikOcPyJ6pWveE9gvkRqDIX
        /39zEbp8AGqjzgw/9/qbW46HDTMClwE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-571-LDgivPXxMD-A6QgH5ZXjQg-1; Thu, 29 Sep 2022 03:00:17 -0400
X-MC-Unique: LDgivPXxMD-A6QgH5ZXjQg-1
Received: by mail-wr1-f72.google.com with SMTP id v22-20020adf8b56000000b0022af189148bso144476wra.22
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 00:00:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=siVqAVCemr3NKP1W8qdwtDUtzgPJwy1cV7KpGtWXqJw=;
        b=aqfZA+/GIAX+pG0VLQA+6aOJgV1TVQQPy8K0110IfyBlBlu6KX0jEe1c88XM/P2zXt
         oQAMVEXb4P8pqe22HY9+tmn/gkf/zuVnIGUN9hm/Uj8NYcasrkJWdIcMzG2+iiSG4BQL
         +gaG4uPhsyrcd6G7Ogg4M8gXzzUSr/0xsVLENmIfl2IhIfhIXMYgOxgW0NWTFkqHgJYC
         BSFMriu+UvAHCNwmttdhgitmoCFCdC1aE8koDGpuLgjw5JvY0axgV0QDb+h9LlBtpY9W
         sgB81ok56IYM447h21f/l+XPjq6XjQM+i1cXSw6fSWuhewgutLJN0EGFmv6igfYsCxHJ
         1ztw==
X-Gm-Message-State: ACrzQf1vWVIn4SeNauw6vqcTvoNHRFYyHBdbap8YAzKlWJlAUAnpdnwy
        YykCU1KVfWS7XNZPhlfjtMs+qyAmMTpu9mdwp6F0xxGMIz6sTZCr79xaO2z08qou/SR1D4oUqsG
        k4h6LdWb71yu9MKEj
X-Received: by 2002:adf:fb50:0:b0:22a:e4e9:a6b3 with SMTP id c16-20020adffb50000000b0022ae4e9a6b3mr980593wrs.467.1664434816657;
        Thu, 29 Sep 2022 00:00:16 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7Evcri6XbqauFOm2LZgvV3/+osg0i+bYVRABZfrHmkdTJzc7KusTw0CxXeXlGDXMd4NT2c9A==
X-Received: by 2002:adf:fb50:0:b0:22a:e4e9:a6b3 with SMTP id c16-20020adffb50000000b0022ae4e9a6b3mr980575wrs.467.1664434816424;
        Thu, 29 Sep 2022 00:00:16 -0700 (PDT)
Received: from redhat.com ([2.55.17.78])
        by smtp.gmail.com with ESMTPSA id 2-20020a05600c228200b003a6a3595edasm3528412wmf.27.2022.09.29.00.00.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 00:00:15 -0700 (PDT)
Date:   Thu, 29 Sep 2022 03:00:11 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Gavin Li <gavinl@nvidia.com>
Cc:     stephen@networkplumber.org, davem@davemloft.net,
        jesse.brandeburg@intel.com, kuba@kernel.org,
        sridhar.samudrala@intel.com, jasowang@redhat.com,
        loseweigh@gmail.com, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        virtio-dev@lists.oasis-open.org
Subject: Re: [PATCH v6 0/2] Improve virtio performance for 9k mtu
Message-ID: <20220929025946-mutt-send-email-mst@kernel.org>
References: <20220914144911.56422-1-gavinl@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220914144911.56422-1-gavinl@nvidia.com>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 14, 2022 at 05:49:09PM +0300, Gavin Li wrote:
> This small series contains two patches that improves virtio netdevice
> performance for 9K mtu when GRO/ guest TSO is disabled.
> 
> Gavin Li (2):
>   virtio-net: introduce and use helper function for guest gso support
>     checks


series:

Acked-by: Michael S. Tsirkin <mst@redhat.com>

this is net-next material


> ---
> changelog:
> v4->v5
> - Addressed comments from Michael S. Tsirkin
> - Remove unnecessary () in return clause
> v1->v2
> - Add new patch
> ---
>   virtio-net: use mtu size as buffer length for big packets
> ---
> changelog:
> v5->v6
> - Addressed comments from Jason and Michael S. Tsirkin
> - Remove wrong commit log description
> - Rename virtnet_set_big_packets_fields with virtnet_set_big_packets
> - Add more test results for different feature combinations
> v4->v5
> - Addressed comments from Michael S. Tsirkin
> - Improve commit message
> v3->v4
> - Addressed comments from Si-Wei
> - Rename big_packets_sg_num with big_packets_num_skbfrags
> v2->v3
> - Addressed comments from Si-Wei
> - Simplify the condition check to enable the optimization
> v1->v2
> - Addressed comments from Jason, Michael, Si-Wei.
> - Remove the flag of guest GSO support, set sg_num for big packets and
>   use it directly
> - Recalculate sg_num for big packets in virtnet_set_guest_offloads
> - Replace the round up algorithm with DIV_ROUND_UP
> ---
> 
>  drivers/net/virtio_net.c | 48 ++++++++++++++++++++++++++--------------
>  1 file changed, 32 insertions(+), 16 deletions(-)
> 
> -- 
> 2.31.1

