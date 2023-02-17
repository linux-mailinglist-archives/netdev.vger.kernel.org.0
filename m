Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8E569A8EE
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 11:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbjBQKNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 05:13:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjBQKNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 05:13:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF70C62FF7
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 02:12:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676628761;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7Y7MkPKxQ4b4S+E2uuEcl4fSWKwkp7IBI4B2vVLi24A=;
        b=gYgkYUgdFbdNjpghAwLo3F6CReTzKdAez2EoQ5jl6FBBHRQWBv33LgZ04BVZv7gxaDHMPd
        eiCugxIElUsRU1ekxK5yV4otTLdgxH2E7vkHOVN7wtsngmRyF5FilX4U3fer9UQU/wuZvq
        jLgdUdSpErhVH6BSGo1w/ithNFPWfxM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-633-2sF5PiIUM6yNm4kRv5Br9Q-1; Fri, 17 Feb 2023 05:12:36 -0500
X-MC-Unique: 2sF5PiIUM6yNm4kRv5Br9Q-1
Received: by mail-wm1-f70.google.com with SMTP id v6-20020a05600c444600b003e206cbce8dso509643wmn.7
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 02:12:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7Y7MkPKxQ4b4S+E2uuEcl4fSWKwkp7IBI4B2vVLi24A=;
        b=6R/Sw3Zb9CbTxCQvCt+DOAXI85yI7m+B5lD5PhImCgJpMbL59l2SNvj5rY1s56Ixkb
         R360bliTd8S6rhGmUR/0RDk4PPFrLFzBt64AEz9YDdcahbC4wNBJV1IVagyxTE435nto
         8cZVOvcaXQgi8UwZhY/49YpLPUDM3JXHJVLEzXIpyDq6xAZ2U8aoktLc5kPqFxO7H2kh
         6zMh6ORBhF0R9Upvzd8uQHESBu/ELvHxiK0Rc9/tBmjK/NQIral+Ph3QcUzFvXfIwoXY
         qPTgikDaJxoE9cDkx8eGuKopOGxOVtLVfGqiGunWRunCu9/b7gkXiGvrNLp1FL8TZSwx
         GXJA==
X-Gm-Message-State: AO0yUKWXAGJKlbsh4WA7e5E1mzclhVm09IgBTbNGb0u/s7Uvj/hOH+ys
        T9NRSbExy270pXVhHHCZTbWVmAjMt8TPi3i12gd4rF/XJhAUxpw+uJ6/3kX9KAaZlaqJPydRyf/
        QMnL6B1hKm2Kl0DbR
X-Received: by 2002:adf:f40b:0:b0:2c5:5ff8:93e5 with SMTP id g11-20020adff40b000000b002c55ff893e5mr6717179wro.44.1676628755108;
        Fri, 17 Feb 2023 02:12:35 -0800 (PST)
X-Google-Smtp-Source: AK7set9h4wA736ZeMYva3jBcgfzObA1Ee5DxMQNCqSjLJtJ9uB6fqQFZuR5r1/3OYbU7YpGJ6GX0bQ==
X-Received: by 2002:adf:f40b:0:b0:2c5:5ff8:93e5 with SMTP id g11-20020adff40b000000b002c55ff893e5mr6717163wro.44.1676628754834;
        Fri, 17 Feb 2023 02:12:34 -0800 (PST)
Received: from redhat.com ([2.52.5.34])
        by smtp.gmail.com with ESMTPSA id i3-20020a05600011c300b002c4061a687bsm3720864wrx.31.2023.02.17.02.12.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 02:12:34 -0800 (PST)
Date:   Fri, 17 Feb 2023 05:12:29 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Nanyong Sun <sunnanyong@huawei.com>, joro@8bytes.org,
        will@kernel.org, robin.murphy@arm.com, jasowang@redhat.com,
        iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, wangrong68@huawei.com
Subject: Re: [PATCH v2] vhost/vdpa: Add MSI translation tables to iommu for
 software-managed MSI
Message-ID: <20230217051158-mutt-send-email-mst@kernel.org>
References: <20230207120843.1580403-1-sunnanyong@huawei.com>
 <Y+7G+tiBCjKYnxcZ@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+7G+tiBCjKYnxcZ@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 16, 2023 at 08:14:50PM -0400, Jason Gunthorpe wrote:
> On Tue, Feb 07, 2023 at 08:08:43PM +0800, Nanyong Sun wrote:
> > From: Rong Wang <wangrong68@huawei.com>
> > 
> > Once enable iommu domain for one device, the MSI
> > translation tables have to be there for software-managed MSI.
> > Otherwise, platform with software-managed MSI without an
> > irq bypass function, can not get a correct memory write event
> > from pcie, will not get irqs.
> > The solution is to obtain the MSI phy base address from
> > iommu reserved region, and set it to iommu MSI cookie,
> > then translation tables will be created while request irq.
> 
> Probably not what anyone wants to hear, but I would prefer we not add
> more uses of this stuff. It looks like we have to get rid of
> iommu_get_msi_cookie() :\
> 
> I'd like it if vdpa could move to iommufd not keep copying stuff from
> it..

Absolutely but when is that happening?

> Also the iommu_group_has_isolated_msi() check is missing on the vdpa
> path, and it is missing the iommu ownership mechanism.
> 
> Also which in-tree VDPA driver that uses the iommu runs on ARM? Please
> don't propose core changes for unmerged drivers. :(
> 
> Jason

