Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC8C941DFB3
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 19:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352473AbhI3RDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 13:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351962AbhI3RD3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 13:03:29 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73590C06176E
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 10:01:46 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id c20so6366503qtb.2
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 10:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4vHHMFNBH4hAm5F563BvE8+3o+7NJnRDr/RUjwsUT7o=;
        b=QGIRkmLfQXIeyUEAHPlvDndXmMMIAMxSXtZXhhRKYvklIE9s9V0mxKkMNZc361fu2+
         /oV28Ti2mLOszUCQtAVFm+lO7hdx7RISinOyXEgG679jauOsPEZJsDn97BSKI/Y+XZGn
         nvKzE18TgoAr5yYwzqF0BLBR/d2XlDNYCnfE8BWTl7rPF2hP87rXsdSJGEEz4xNJo7IA
         XD/7Y7rdo0+4GJu9Kcd/XwUsO2juMuUKx3MqXsyQc6zYkSOTMavlqDYBTbIG5C39TIF8
         RnCcanamumbSy2k6pKQ2iu96IWFTPNHP8Dtw3MHS8f+D1FklgeJFEug0i3XEm+5ai9kb
         OSaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4vHHMFNBH4hAm5F563BvE8+3o+7NJnRDr/RUjwsUT7o=;
        b=DSnyLFFOaQOutX31SXNtM8uYfCitBLlYQ3mV2Q8auMHmuoB3E+0mXzq24V3ZxleiWP
         4ImNEL/NkMVztQPeIHuPojuwntea90KyzqlCHbATjvSkhf1tciwRaS8EhO4tlQPyMOXM
         UgFdcMjUWFsxqZSfVrpmiDzPEVhcz/5ZJYLqQB6amUY8rMCvtzCW9bzWt05/ukP38HD/
         0aD0tIchXFGMj6b4uBj4RqKVa+13D7dxhRpdGYExl7rooBPuxIXSS31fH9QnNmHme3Z0
         nTtA8OQXPh/n3N11RgODyNC9sI+re3bvqI9PzCp95IwrMcEJG991ERrt/Zj9mgJmpveE
         a9og==
X-Gm-Message-State: AOAM531bxZp5vSqfbDqtbvEWfn6VaGDAk7BWMqKf/xF7tGBouFpiIVtT
        nSJQqcw/m9mDTvaLJNp+REtjgQ==
X-Google-Smtp-Source: ABdhPJzF+pPtZvhaFL1R8QP7BIsE2HJOfVSnKQcQu0YBk68rNLfkGNJ3nrCGS43Vfn59rLAM1LD5RQ==
X-Received: by 2002:ac8:4084:: with SMTP id p4mr7765655qtl.306.1633021305549;
        Thu, 30 Sep 2021 10:01:45 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id l7sm1852806qth.81.2021.09.30.10.01.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 10:01:44 -0700 (PDT)
Received: from jgg by jggl with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1mVzRH-000I2E-Ia; Thu, 30 Sep 2021 14:01:43 -0300
Date:   Thu, 30 Sep 2021 14:01:43 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH mlx5-next 2/7] vfio: Add an API to check migration state
 transition validity
Message-ID: <20210930170143.GB69218@ziepe.ca>
References: <20210929091712.6390141c.alex.williamson@redhat.com>
 <e1ba006f-f181-0b89-822d-890396e81c7b@nvidia.com>
 <20210929161433.GA1808627@ziepe.ca>
 <29835bf4-d094-ae6d-1a32-08e65847b52c@nvidia.com>
 <20210929232109.GC3544071@ziepe.ca>
 <d8324d96-c897-b914-16c6-ad0bbb9b13a5@nvidia.com>
 <20210930144752.GA67618@ziepe.ca>
 <d5b68bb7-d4d3-e9d8-1834-dba505bb8595@nvidia.com>
 <20210930162442.GB67618@ziepe.ca>
 <c7a18080-3ffc-488b-577c-1e3b356bf66e@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c7a18080-3ffc-488b-577c-1e3b356bf66e@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 07:51:22PM +0300, Max Gurtovoy wrote:
> 
> On 9/30/2021 7:24 PM, Jason Gunthorpe wrote:
> > On Thu, Sep 30, 2021 at 06:32:07PM +0300, Max Gurtovoy wrote:
> > > > Just prior to open device the vfio pci layer will generate a FLR to
> > > > the function so we expect that post open_device has a fresh from reset
> > > > fully running device state.
> > > running also mean that the device doesn't have a clue on its internal state
> > > ? or running means unfreezed and unquiesced ?
> > The device just got FLR'd and it should be in a clean state and
> > operating. Think the VM is booting for the first time.
> 
> During the resume phase in the dst, the VM is paused and not booting.
> Migration SW is waiting to get memory and state from SRC. The device will
> start from the exact point that was in the src.
> 
> it's exactly "000b => Device Stopped, not saving or resuming"

For this case qmeu should open the VFIO device and immediately issue a
command to go to resuming. The kernel cannot know at open_device time
which case userspace is trying to do. Due to backwards compat we
assume userspace is going to boot a fresh VM.

> Well, this is your design for the driver implementation. Nobody is
> preventing other drivers to start deserializing device state into the device
> during RESUMING bit on.

It is a logical model. Devices can stream the migration data directly
into the internal state if they like. It just creates more conditions
where they have report an error state.

> So if we moved from 100b to 010b somehow, one should deserialized its buffer
> to the device, and then serialize it to migration region again ?

Yes.
 
> I guess its doable since the device is freeze and quiesced. But moving from
> 100b to 011b is not possible, right ?

Why not?

100b to 011b is no different than going indirectly 100b -> 001b -> 011b

The time spent in 001b is just negligable.

Jason
