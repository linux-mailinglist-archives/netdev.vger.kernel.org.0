Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 827A56B3912
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 09:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231140AbjCJIpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 03:45:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbjCJIoi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 03:44:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00ECB10E269
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 00:41:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678437704;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PgZ9DWKppXLbZXIYqFbF8nghQRnE3BR/P3wfdlRGiz4=;
        b=ZzMJuKv2FY7OCL/FsJvyy99Q6zcXZTVhVr2VJDsp3NfyciYZHUTVcZHi6z5Cf9BtbkAjos
        U3y9nROGNl5q92BxUQTNWvFHhxuQeqb/kM72rp5hcHGZ1bfkEcZRaki8Nu+MD6tTI0dKyg
        wPLwSvUlOn5AuEkV63wu3/UOnrJpC5w=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-484-s82eRvYeOISByPALEHcXAw-1; Fri, 10 Mar 2023 03:41:43 -0500
X-MC-Unique: s82eRvYeOISByPALEHcXAw-1
Received: by mail-wr1-f71.google.com with SMTP id m7-20020a056000008700b002c7047ea429so902092wrx.21
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 00:41:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678437701;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PgZ9DWKppXLbZXIYqFbF8nghQRnE3BR/P3wfdlRGiz4=;
        b=VgnOSyylOj4+5AznHGCwYCKYj662eaKlzZOSstG4LOJ9uAPPRZO4FFjzySpbp66kbZ
         5Qz8uljmVsTx5uwmAs3bx4eK7fG/8a5cDj56IVxnde5nVwXN4xFDEp0auDxDbWG5/kgF
         M5Hw5cmpsTnGKjnkGbYeY2T2MQ4m9aZN/GzhL9+K88KQlosIraru/avbw0rMER+elz0T
         AWMpoG7Q4ZySmrVn4E/D1U1WIpD/0jsJ1aYox7HCxar6ZlpNeiPLer55E6C/17oixO2Y
         pl5c1MZMXiNWk5f7SVs4j518vJhEL90MLBpO8yx92Wncxp8/AB5pGB+63fjuLy/ElkBG
         p2+A==
X-Gm-Message-State: AO0yUKXVTrHjYdcN11MeutvpsZS6o3VFQ2oG0VMuyLj/ZzEiNktNe6LJ
        anumtG0Sl2pa4038lpuccfzoKfmovfFIaAWc7mWvsMbm4a33ukGLFMA2yBny8lcT6XJi6JnJ+ue
        m4rZk0Hlz6h9h7fw+2SPkBoqJ
X-Received: by 2002:adf:f006:0:b0:2c7:1a96:63f2 with SMTP id j6-20020adff006000000b002c71a9663f2mr15408166wro.3.1678437701510;
        Fri, 10 Mar 2023 00:41:41 -0800 (PST)
X-Google-Smtp-Source: AK7set/0zNz/ZZRX8XUCR+0UQZYSDN/cLZcU6NuWf8z1hU8kWNXs0SEm1rd0WtH4SBmkrKRw2UpQgw==
X-Received: by 2002:adf:f006:0:b0:2c7:1a96:63f2 with SMTP id j6-20020adff006000000b002c71a9663f2mr15408153wro.3.1678437701194;
        Fri, 10 Mar 2023 00:41:41 -0800 (PST)
Received: from redhat.com ([2.52.9.88])
        by smtp.gmail.com with ESMTPSA id q6-20020a05600c46c600b003eb0d6f48f3sm2337036wmo.27.2023.03.10.00.41.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 00:41:40 -0800 (PST)
Date:   Fri, 10 Mar 2023 03:41:36 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Nanyong Sun <sunnanyong@huawei.com>, joro@8bytes.org,
        will@kernel.org, robin.murphy@arm.com, iommu@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        wangrong68@huawei.com, Cindy Lu <lulu@redhat.com>
Subject: Re: [PATCH v2] vhost/vdpa: Add MSI translation tables to iommu for
 software-managed MSI
Message-ID: <20230310034101-mutt-send-email-mst@kernel.org>
References: <20230207120843.1580403-1-sunnanyong@huawei.com>
 <Y+7G+tiBCjKYnxcZ@nvidia.com>
 <20230217051158-mutt-send-email-mst@kernel.org>
 <Y+92c9us3HVjO2Zq@nvidia.com>
 <CACGkMEsVBhxtpUFs7TrQzAecO8kK_NR+b1EvD2H7MjJ+2aEKJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGkMEsVBhxtpUFs7TrQzAecO8kK_NR+b1EvD2H7MjJ+2aEKJw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 20, 2023 at 10:37:18AM +0800, Jason Wang wrote:
> On Fri, Feb 17, 2023 at 8:43 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
> >
> > On Fri, Feb 17, 2023 at 05:12:29AM -0500, Michael S. Tsirkin wrote:
> > > On Thu, Feb 16, 2023 at 08:14:50PM -0400, Jason Gunthorpe wrote:
> > > > On Tue, Feb 07, 2023 at 08:08:43PM +0800, Nanyong Sun wrote:
> > > > > From: Rong Wang <wangrong68@huawei.com>
> > > > >
> > > > > Once enable iommu domain for one device, the MSI
> > > > > translation tables have to be there for software-managed MSI.
> > > > > Otherwise, platform with software-managed MSI without an
> > > > > irq bypass function, can not get a correct memory write event
> > > > > from pcie, will not get irqs.
> > > > > The solution is to obtain the MSI phy base address from
> > > > > iommu reserved region, and set it to iommu MSI cookie,
> > > > > then translation tables will be created while request irq.
> > > >
> > > > Probably not what anyone wants to hear, but I would prefer we not add
> > > > more uses of this stuff. It looks like we have to get rid of
> > > > iommu_get_msi_cookie() :\
> > > >
> > > > I'd like it if vdpa could move to iommufd not keep copying stuff from
> > > > it..
> > >
> > > Absolutely but when is that happening?
> >
> > Don't know, I think it has to come from the VDPA maintainers, Nicolin
> > made some drafts but wasn't able to get it beyond that.
> 
> Cindy (cced) will carry on the work.
> 
> Thanks

Hmm didn't see anything yet. Nanyong Sun maybe you can take a look?

> >
> > Please have people who need more iommu platform enablement to pick it
> > up instead of merging hacks like this..
> >
> > We are very close to having nested translation on ARM so anyone who is
> > serious about VDPA on ARM is going to need iommufd anyhow.
> >
> > Jason
> >

