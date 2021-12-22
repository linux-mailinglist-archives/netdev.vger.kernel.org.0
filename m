Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54D2A47D5A8
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 18:19:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344241AbhLVRSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 12:18:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344242AbhLVRSy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 12:18:54 -0500
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 049FFC061401
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 09:18:53 -0800 (PST)
Received: by mail-qk1-x72a.google.com with SMTP id 69so2960129qkd.6
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 09:18:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/L5NSqmnmp0JrNCe4jEZo1LjnyYAG3Zj1ZGvlLyNRww=;
        b=LXqfRFsU799kS6etQx2wny/MKAWaffuWQk76RfpfJW+3X5OCImXg1Dp90Y0mRBI1EG
         WNjZzNDzZKIcmS8X1m46mdALXkuotSNdEczKGUd/PBewYiLrbLh2zbN/CaonWPBMBbDx
         LHnygp0gSkx2zU/yGMCtl+rcj3S3J3Cw2iqmWXTzbF9xYnXxu99hrM6LBcYVQrggMDeJ
         2E+MC79QzCOqtuTTypNlhmVcPYm8OP5ZRavMcgb9yx/5gpRRO0HB1BziVlKih5ozJC/8
         M0ic/La1wfEsbcI58LTI+gJPcyj/M/6EKryf3RVyZBHv/tF5fEsE7drF8k3qsF+r9v3q
         +Ryg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/L5NSqmnmp0JrNCe4jEZo1LjnyYAG3Zj1ZGvlLyNRww=;
        b=wldPzi/kikuS7ninPXGRKBTdD2SpvNOPlxoAYj7/MM9wfkmfMh/7Ss/7/I6WpIlaXo
         x+Qa9cl/bDdy9GnHysJP30hjWhjK9mfrfJ4nAReJEbH+k81BofBpt2SRAA2rBpNFYGCG
         uRnT68FfOIixZhAQjak+yDRdmCZdtLxXipN2ni36zUCnX+lNj7tIu8cOfnM+x2cooqTH
         GOmjk6669rwZshoK0FtNSmfH5Xpi6AhQvtelqKZBD2qqYJP9ODc6+S72z+qAl2gLiaGq
         BcrslHVyO4AQYKIlJkR5gBdQb3gcG7dw0WQ96Yik+tcUxmUW+FbFw339tp/iv6bNAHdp
         Wgbw==
X-Gm-Message-State: AOAM530mu9PntH1divZeA0/8xP/nOYxsYhTqgjmQbK4EZfUBczwpoM2v
        qAldT1cHfZQRiZPVUo6a/XuuBA==
X-Google-Smtp-Source: ABdhPJwP5NJyymLKCRDlLyH4OX0k1lbimBfGNffLbMt6CEmyfRjzYEMg0Rxlwp8mOtStmN8qCKq7rQ==
X-Received: by 2002:ae9:df87:: with SMTP id t129mr2774584qkf.67.1640193533176;
        Wed, 22 Dec 2021 09:18:53 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id de33sm2244073qkb.5.2021.12.22.09.18.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Dec 2021 09:18:52 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1n05GN-007SI7-Km; Wed, 22 Dec 2021 13:18:51 -0400
Date:   Wed, 22 Dec 2021 13:18:51 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "David E. Box" <david.e.box@linux.intel.com>
Cc:     gregkh@linuxfoundation.org, mustafa.ismail@intel.com,
        shiraz.saleem@intel.com, dledford@redhat.com, leon@kernel.org,
        saeedm@nvidia.com, davem@davemloft.net, kuba@kernel.org,
        vkoul@kernel.org, yung-chuan.liao@linux.intel.com,
        pierre-louis.bossart@linux.intel.com, mst@redhat.com,
        jasowang@redhat.com, andriy.shevchenko@linux.intel.com,
        hdegoede@redhat.com, virtualization@lists.linux-foundation.org,
        alsa-devel@alsa-project.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH 0/4] driver_core: Auxiliary drvdata helper cleanup
Message-ID: <20211222171851.GO6467@ziepe.ca>
References: <20211221235852.323752-1-david.e.box@linux.intel.com>
 <20211222000905.GN6467@ziepe.ca>
 <35bca887e697597f7b3e1944b3dd7347c6defca1.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35bca887e697597f7b3e1944b3dd7347c6defca1.camel@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 21, 2021 at 04:48:17PM -0800, David E. Box wrote:
> On Tue, 2021-12-21 at 20:09 -0400, Jason Gunthorpe wrote:
> > On Tue, Dec 21, 2021 at 03:58:48PM -0800, David E. Box wrote:
> > > Depends on "driver core: auxiliary bus: Add driver data helpers" patch [1].
> > > Applies the helpers to all auxiliary device drivers using
> > > dev_(get/set)_drvdata. Drivers were found using the following search:
> > > 
> > >     grep -lr "struct auxiliary_device" $(grep -lr "drvdata" .)
> > > 
> > > Changes were build tested using the following configs:
> > > 
> > >     vdpa/mlx5:       CONFIG_MLX5_VDPA_NET
> > >     net/mlx53:       CONFIG_MLX5_CORE_EN
> > >     soundwire/intel: CONFIG_SOUNDWIRE_INTEL
> > >     RDAM/irdma:      CONFIG_INFINIBAND_IRDMA
> > >                      CONFIG_MLX5_INFINIBAND
> > > 
> > > [1] https://www.spinics.net/lists/platform-driver-x86/msg29940.html 
> > 
> > I have to say I don't really find this to be a big readability
> > improvement.
> 
> I should have referenced the thread [1] discussing the benefit of this change
> since the question was asked and answered already. The idea is that drivers
> shouldn't have to touch the device API directly if they are already using a
> higher level core API (auxiliary bus) that can do that on its behalf.

Driver writers should rarely use the auxilary device type directly, the
should always immediately container_of it to their proper derived
type.

> > Also, what use is 'to_auxiliary_dev()' ? I didn't see any users added..
>
> This was not added by that patch.

It was added by the referenced patch, and seems totally pointless cut
and paste, again because nothing should be using the auxiliary_device
type for anything more than container_of'ing to their own type.

We've been ripping out bus specific APIs in favour of generic ones
(see the work on the DMA API for instance) so this whole concept seems
regressive, particularly when applied to auxiliary bus which does not
have an API of its own.

Jason
