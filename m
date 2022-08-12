Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69A62590FE9
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 13:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233297AbiHLLOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 07:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231237AbiHLLOn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 07:14:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F3308A570F
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 04:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660302882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Vjey9K3TeQYDdy1zlBcGzUENTBb/IIn2zN2Vn3gMAeY=;
        b=QUhfLuxbmlSy+ZDB21HA2VY8FY6PiYOi7kmPpAc5lZTjqbonTBkyQJCkgSkXxmIqYSGbXQ
        98LwkQit8mIard0rER3zUtCerjovX0lyAAkhaecJHpao/7gkhI/Heq59wp3q1GUk/QdmaH
        PRkpHe2t35HIPQRLNn+6ZVSWUr2CUD4=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-562-JM5ftAicNjWFkfZ3AlZbqw-1; Fri, 12 Aug 2022 07:14:41 -0400
X-MC-Unique: JM5ftAicNjWFkfZ3AlZbqw-1
Received: by mail-wr1-f71.google.com with SMTP id d6-20020adfa346000000b002206e4c29caso63895wrb.8
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 04:14:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=Vjey9K3TeQYDdy1zlBcGzUENTBb/IIn2zN2Vn3gMAeY=;
        b=DlIWsRy3jVlnIZenuM6dXeWLzbYmEbRyv/GhelsQcVev4jfPVBRx7iDMWFNGUlxcy7
         Xj+u53D1pFhVGMTaMKLwSKzyBPrHVH59aTEhUGNtpt4dzO4F3UkFzT+7OJ1zEwpeo0C/
         oCvTEBd5EMb/E2ijAhz9mW+jMJHvWsHDFzqaIocN0ChMnGIYTZ1xrmm5bfHyxHEKyThW
         tPpmxY/98cxeKLHtaKEy94I7rUUyBmEwLKzEpYcP3QgxY8a6eso+Gd7tWCf2zxlrnivr
         mUC3k8Q7f6dIAd1PBkhqEZDF01r87b96RT5NBOBmkcPyc6EZxR0lS/4bmJWRb0WWTtiR
         gKjQ==
X-Gm-Message-State: ACgBeo09qI/kXO3BYDYPHZEV+dNZlZYQh9SiV+gTM0mlzkL78E2H4hDz
        cLEx/98EmVdf8lSEhIZM4QHDtWEUx5nbHmoL50ShMms980rIYHZPCUTIfY3h/z7i2bCu/xUS34C
        2C1h7rbeSJUsarZin
X-Received: by 2002:a05:600c:3c94:b0:3a5:373d:df0d with SMTP id bg20-20020a05600c3c9400b003a5373ddf0dmr2324912wmb.132.1660302879670;
        Fri, 12 Aug 2022 04:14:39 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7J/dxXbbJOk5zZn+Sq4GfdrE6hekhKR5t2In0Rczaj/tO5ISPT0p2ZgrfSLLHtzOt4qDcffg==
X-Received: by 2002:a05:600c:3c94:b0:3a5:373d:df0d with SMTP id bg20-20020a05600c3c9400b003a5373ddf0dmr2324893wmb.132.1660302879372;
        Fri, 12 Aug 2022 04:14:39 -0700 (PDT)
Received: from redhat.com ([2a06:c701:7416:9d00:bb54:f6b1:32e:b9fc])
        by smtp.gmail.com with ESMTPSA id m8-20020a5d4a08000000b0021edb2d07bbsm1685611wrq.33.2022.08.12.04.14.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Aug 2022 04:14:38 -0700 (PDT)
Date:   Fri, 12 Aug 2022 07:14:35 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org, parav@nvidia.com,
        xieyongji@bytedance.com, gautam.dawar@amd.com
Subject: Re: [PATCH V5 0/6] ifcvf/vDPA: support query device config space
 through netlink
Message-ID: <20220812071251-mutt-send-email-mst@kernel.org>
References: <20220812104500.163625-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220812104500.163625-1-lingshan.zhu@intel.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 12, 2022 at 06:44:54PM +0800, Zhu Lingshan wrote:
> This series allows userspace to query device config space of vDPA
> devices and the management devices through netlink,
> to get multi-queue, feature bits and etc.
> 
> This series has introduced a new netlink attr
> VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES, this should be used to query
> features of vDPA  devices than the management device.
> 
> Please help review.

I can't merge this for this merge window.
Am I right when I say that the new thing here is patch 5/6 + new
comments?
If yes I can queue it out of the window, on top.

> Thanks!
> Zhu Lingshan
> 
> Changes rom V4:
> (1) Read MAC, MTU, MQ conditionally (Michael)
> (2) If VIRTIO_NET_F_MAC not set, don't report MAC to userspace
> (3) If VIRTIO_NET_F_MTU not set, report 1500 to userspace
> (4) Add comments to the new attr
> VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES(Michael)
> (5) Add comments for reporting the device status as LE(Michael)
> 
> Changes from V3:
> (1)drop the fixes tags(Parva)
> (2)better commit log for patch 1/6(Michael)
> (3)assign num_queues to max_supported_vqs than max_vq_pairs(Jason)
> (4)initialize virtio pci capabilities in the probe() function.
> 
> Changes from V2:
> Add fixes tags(Parva)
> 
> Changes from V1:
> (1) Use __virito16_to_cpu(true, xxx) for the le16 casting(Jason)
> (2) Add a comment in ifcvf_get_config_size(), to explain
> why we should return the minimum value of
> sizeof(struct virtio_net_config) and the onboard
> cap size(Jason)
> (3) Introduced a new attr VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES
> (4) Show the changes of iproute2 output before and after 5/6 patch(Jason)
> (5) Fix cast warning in vdpa_fill_stats_rec() 
> 
> Zhu Lingshan (6):
>   vDPA/ifcvf: get_config_size should return a value no greater than dev
>     implementation
>   vDPA/ifcvf: support userspace to query features and MQ of a management
>     device
>   vDPA: allow userspace to query features of a vDPA device
>   vDPA: !FEATURES_OK should not block querying device config space
>   vDPA: Conditionally read fields in virtio-net dev config space
>   fix 'cast to restricted le16' warnings in vdpa.c
> 
>  drivers/vdpa/ifcvf/ifcvf_base.c |  13 ++-
>  drivers/vdpa/ifcvf/ifcvf_base.h |   2 +
>  drivers/vdpa/ifcvf/ifcvf_main.c | 142 +++++++++++++++++---------------
>  drivers/vdpa/vdpa.c             |  82 ++++++++++++------
>  include/uapi/linux/vdpa.h       |   3 +
>  5 files changed, 149 insertions(+), 93 deletions(-)
> 
> -- 
> 2.31.1

