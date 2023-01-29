Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BDD368009C
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 18:59:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235198AbjA2R7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 12:59:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbjA2R7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 12:59:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CFF8B75F
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 09:58:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675015095;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TZoRK9BZ3t2Wi1ix9FutdV7vK4dm+2rgUqjlwcOivCI=;
        b=aF/YiOSop+/Fee+t9t4hOrRj7QczYpN9w3FYcGdbIamqL1LnwGVsT/wXPxReqbXB+14uAl
        pvuK/ESRut2fMw11XMu+RcKNegx3s/gE1oBnLxcGfHqKTS6wSfiZ54fvG+4MG8hqwxfG6D
        juivDMGSxs8zXHV7L7TDcJBU1BLpUJA=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-296-NQ_CmV4EOnaRC88o2AzW1Q-1; Sun, 29 Jan 2023 12:58:13 -0500
X-MC-Unique: NQ_CmV4EOnaRC88o2AzW1Q-1
Received: by mail-qk1-f197.google.com with SMTP id v7-20020a05620a0f0700b006faffce43b2so6157804qkl.9
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 09:58:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TZoRK9BZ3t2Wi1ix9FutdV7vK4dm+2rgUqjlwcOivCI=;
        b=l64uUGMgqHbQe0IwnmxrNFr4ZoAGDAkwMKmc4TSpLa5PMghDXT69qPgEOFIVs3HAkt
         UfltE+hsV2ZxH7VkXRqOoZQ6mU3+fZ2SwdS41cfF+O89eaCz/2BqYwCyje/gEO6/3UIV
         v1N6a1od8OFZkGhTz1jX4mH0X4NicSbyNFk2/gQdenF9mKHLZeJ+8gHW3I3te19schbo
         uVzho7rQtOQWrRPqDAwqA16CZspv5p84keGVLb1z1F+dRpCAtSMQ/blLqrBBB6GSqYW1
         JQmECq36CCfCkxGlFQzJc0NYUeRDQaszHe6IEfx30oTLK1KUKuB/WE5fyuyrCwFIRWPM
         Fj/Q==
X-Gm-Message-State: AO0yUKUDjJiOjduUekHecagzPIk4ylrFF4f274R7fom0Dy11q/OBhct6
        t2Nn7XExrsp9ncLtXTfOqtvCaczFixIysYwnhhwmExRChqhXot2irii/T8hLvfW27r82yEQpYxT
        9wh5F8PqJnsYCp+Ir
X-Received: by 2002:ac8:5f50:0:b0:3b8:2a6c:d1e4 with SMTP id y16-20020ac85f50000000b003b82a6cd1e4mr14798110qta.23.1675015093344;
        Sun, 29 Jan 2023 09:58:13 -0800 (PST)
X-Google-Smtp-Source: AK7set81mP2q7yHpiOp5TTYBWsJ3krnk4K3MhdR8gsDVQLP3L1zEgo8bkLBq0lFX+0cwwTn5XuracA==
X-Received: by 2002:ac8:5f50:0:b0:3b8:2a6c:d1e4 with SMTP id y16-20020ac85f50000000b003b82a6cd1e4mr14798091qta.23.1675015093057;
        Sun, 29 Jan 2023 09:58:13 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id t3-20020ac86a03000000b003a591194221sm4257080qtr.7.2023.01.29.09.58.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Jan 2023 09:58:12 -0800 (PST)
Message-ID: <3fe5971a-5991-488f-cef5-473c9faa1ba1@redhat.com>
Date:   Sun, 29 Jan 2023 18:58:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH 0/2] vhost/net: Clear the pending messages when the
 backend is removed
Content-Language: en-US
To:     eric.auger.pro@gmail.com, mst@redhat.com, jasowang@redhat.com,
        kvm@vger.kernel.org, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     peterx@redhat.com, lvivier@redhat.com
References: <20230117151518.44725-1-eric.auger@redhat.com>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <20230117151518.44725-1-eric.auger@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 1/17/23 16:15, Eric Auger wrote:
> When the vhost iotlb is used along with a guest virtual iommu
> and the guest gets rebooted, some MISS messages may have been
> recorded just before the reboot and spuriously executed by
> the virtual iommu after the reboot. This is due to the fact
> the pending messages are not cleared.
>
> As vhost does not have any explicit reset user API,
> VHOST_NET_SET_BACKEND looks a reasonable point where to clear
> the pending messages, in case the backend is removed (fd = -1).
>
> This version is a follow-up on the discussions held in [1].
>
> The first patch removes an unused 'enabled' parameter in
> vhost_init_device_iotlb().

Gentle Ping. Does it look a reasonable fix now?

Thanks

Eric
>
> Best Regards
>
> Eric
>
> History:
> [1] RFC: [RFC] vhost: Clear the pending messages on vhost_init_device_iotlb()
> https://lore.kernel.org/all/20221107203431.368306-1-eric.auger@redhat.com/
>
> Eric Auger (2):
>   vhost: Remove the enabled parameter from vhost_init_device_iotlb
>   vhost/net: Clear the pending messages when the backend is removed
>
>  drivers/vhost/net.c   | 5 ++++-
>  drivers/vhost/vhost.c | 5 +++--
>  drivers/vhost/vhost.h | 3 ++-
>  3 files changed, 9 insertions(+), 4 deletions(-)
>

