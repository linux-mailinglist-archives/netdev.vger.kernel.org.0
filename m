Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0883E26FC52
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 14:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgIRMQ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 08:16:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbgIRMQY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 08:16:24 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C46DC061788
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 05:16:24 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id di5so2696060qvb.13
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 05:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hLNnX79G9nX+k+EVGGBz2aG4Mw+aUk0GIJq895hnjbI=;
        b=EpbAzbUNcX04Odo/GcQwU5ayGQ+p5PYbGV/k7n/wHFcUZ6gkJAZyRA5Kv6+xhrYyAA
         kW/Rws6ZJXNK1GrX6Jz9abd7y6ZQQjWkdnpVHcekqFZWGvRIH15NwfS1D4uI3qJ+n4wo
         iyKBU006H28WCKESyGl0JdtADbLGWisxEkMJ9U+BMdhzRMzMXGj9iY99Dlb/MXiCCFGY
         15qaIglSCN2hbaMLF2HLsnIz43low1k84Ae30uVKNXbwVqZNPj1Y75yi3+fxkZfz15ep
         6Ze1y+Ol8azNg2GnVSZjDCffvYw4LgnX6jCPn6+qtreFX1ONKAvQSu8q43ahPxhvrzsN
         fyyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hLNnX79G9nX+k+EVGGBz2aG4Mw+aUk0GIJq895hnjbI=;
        b=h149XxKB2y3r+q0Fqj1X9P9PAkUDAV39GZhOaeLrXTSNyGBXBt6OxeDU22GcwQc302
         N7rLcIusBL5/dBdRCtPNQF2I36GZ+Rx3+pbZHjmzemtX8cGxaXrl69Y1NYYzv88mHIWp
         8dkeKnuyiCuUEdD/CQtaIWC0hYwaM8qoZfthzBXH/9tOflr5UTtBbMrMqythnhlHVqnh
         XONMEs4Q5Z0ptUgH3q4vsXE54E0lSbg1Kkzj7seB3wYhSbfCKMi5UxDVKGRcPHuPhyTe
         vDH+y9zr3ov+0CM+nc/uyUUxSLHyuQ5fzMO4MpI/P/BsfNMoTmQC+rENV2btQTgMrCyD
         27Tg==
X-Gm-Message-State: AOAM5334YLbMFBXBtIPkhZ0B6mwCR7tSOyCkDWs4ZzJwDwaUoVjYbEoY
        ZhQJlVgfkXsyvhm85kG0H6feMg==
X-Google-Smtp-Source: ABdhPJwjJqP/kFe9m2MXchpGykfXMrwjGnGS79iJqA6ru+cxesW4ytuzUOvJU92XWp9WTtKORAHjng==
X-Received: by 2002:a0c:ee6a:: with SMTP id n10mr15996854qvs.45.1600431383221;
        Fri, 18 Sep 2020 05:16:23 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id s18sm1915204qks.44.2020.09.18.05.16.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2020 05:16:22 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1kJFJN-000x3I-DB; Fri, 18 Sep 2020 09:16:21 -0300
Date:   Fri, 18 Sep 2020 09:16:21 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Oded Gabbay <oded.gabbay@gmail.com>
Cc:     Gal Pressman <galpress@amazon.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH v3 00/14] Adding GAUDI NIC code to habanalabs driver
Message-ID: <20200918121621.GQ8409@ziepe.ca>
References: <20200915171022.10561-1-oded.gabbay@gmail.com>
 <20200915133556.21268811@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAFCwf12XZRxLYifSfuB+RGhuiKBytzsUTOnEa6FqfJHYvcVJPQ@mail.gmail.com>
 <20200917171833.GJ8409@ziepe.ca>
 <0b21db8d-1061-6453-960b-8043951b3bad@amazon.com>
 <20200918115601.GP8409@ziepe.ca>
 <CAFCwf12G4FnhjzijZLh_=n59SQMcTnULTqp8DOeQGyX6_q_ayA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFCwf12G4FnhjzijZLh_=n59SQMcTnULTqp8DOeQGyX6_q_ayA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 18, 2020 at 02:59:28PM +0300, Oded Gabbay wrote:
> On Fri, Sep 18, 2020 at 2:56 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> >
> > On Fri, Sep 18, 2020 at 02:36:10PM +0300, Gal Pressman wrote:
> > > On 17/09/2020 20:18, Jason Gunthorpe wrote:
> > > > On Tue, Sep 15, 2020 at 11:46:58PM +0300, Oded Gabbay wrote:
> > > >> infrastructure for communication between multiple accelerators. Same
> > > >> as Nvidia uses NVlink, we use RDMA that we have inside our ASIC.
> > > >> The RDMA implementation we did does NOT support some basic RDMA
> > > >> IBverbs (such as MR and PD) and therefore, we can't use the rdma-core
> > > >> library or to connect to the rdma infrastructure in the kernel.
> > > >
> > > > You can't create a parallel RDMA subsystem in netdev, or in misc, and
> > > > you can't add random device offloads as IOCTL to nedevs.
> > > >
> > > > RDMA is the proper home for all the networking offloads that don't fit
> > > > into netdev.
> > > >
> > > > EFA was able to fit into rdma-core/etc and it isn't even RoCE at
> > > > all. I'm sure this can too.
> > >
> > > Well, EFA wasn't welcomed to the RDMA subsystem with open arms ;), initially it
> > > was suggested to go through the vfio subsystem instead.
> > >
> > > I think this comes back to the discussion we had when EFA was upstreamed, which
> > > is what's the bar to get accepted to the RDMA subsystem.
> > > IIRC, what we eventually agreed on is having a userspace rdma-core provider and
> > > ibv_{ud,rc}_pingpong working (or just supporting one of the IB spec's QP types?).
> >
> > That is more or less where we ended up, yes.
> >
> > I'm most worried about this lack of PD and MR.
> >
> > Kernel must provide security for apps doing user DMA, PD and MR do
> > this. If the device doesn't have PD/MR then it is hard to see how a WQ
> > could ever be exposed directly to userspace, regardless of subsystem.
> 
> Hi Jason,
> What you say here is very true and we handle that with different
> mechanisms. I will start working on a dedicated patch-set of the RDMA
> code in the next few weeks with MUCH MORE details in the commit
> messages. That will explain exactly how we expose stuff and protect.
> 
> For example, regarding isolating between applications, we only support
> a single application opening our file descriptor.

Then the driver has a special PD create that requires the misc file
descriptor to authorize RDMA access to the resources in that security
context.

> Another example is that the submission of WQ is done through our QMAN
> mechanism and is NOT mapped to userspace (due to the restrictions you
> mentioned above and other restrictions).

Sure, other RDMA drivers also require a kernel ioctl for command
execution.

In this model the MR can be a software construct, again representing a
security authorization:

- A 'full process' MR, in which case the kernel command excution
  handles dma map and pinning at command execution time
- A 'normal' MR, in which case the DMA list is pre-created and the
  command execution just re-uses this data

The general requirement for RDMA is the same as DRM, you must provide
enough code in rdma-core to show how the device works, and minimally
test it. EFA uses ibv_ud_pingpong, and some pyverbs tests IIRC.

So you'll want to arrange something where the default MR and PD
mechanisms do something workable on this device, like auto-open the
misc FD when building the PD, and support the 'normal' MR flow for
command execution.

Jason
