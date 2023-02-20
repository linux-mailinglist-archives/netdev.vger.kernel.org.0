Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D87069D097
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 16:26:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbjBTPZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 10:25:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231529AbjBTPZ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 10:25:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E5361C5A7
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 07:24:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676906669;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XXbeg/8n4ojsPY6rFquIIVMt+7vRYFxzuQ9z7o+cgT8=;
        b=Vc8E9jyEHLj61nUOjktduqzw57TqpoBXWks/hxSvl9sa4JIlaKgQWq4o5DEvrqJetQxUBJ
        aBk2yFmKJZ6cYKsHobf5ZWk8gDMrU5TiUkjhZh7q/9coJmPX7kBnY6VDsF7PR57CBdCo4j
        YO5tey18tN5F9xDyWJxX8pbxq+YW93E=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-237-CzAC9RMvM-OzPNSym6qZ2Q-1; Mon, 20 Feb 2023 10:24:28 -0500
X-MC-Unique: CzAC9RMvM-OzPNSym6qZ2Q-1
Received: by mail-wm1-f72.google.com with SMTP id k26-20020a05600c0b5a00b003dfe4bae099so697833wmr.0
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 07:24:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XXbeg/8n4ojsPY6rFquIIVMt+7vRYFxzuQ9z7o+cgT8=;
        b=mcmNv1WH5q+1H0Qr1tGyQPqQRwqPErPl3LxcQKEr/3jyg+Jrx+HYwe6qdoaROOR3iy
         u3SlpNVKrQPKF+11zhoT3r0vBzGKOMhkVKjAhLT/iD2L8OXnu+RBbmHNKQC5BvMGluff
         I1zy0F20MqRsh6TxygBGJVD1WZji3fPAgMB925sPr5L5v4LiAx+/oE2zUMRgQ8Zpyqv/
         ii2EHCTU8Lioq+JI63j6xw6aXetLwbycFCuuPLgSwjWzENpnKh7yFxWb7Su0zYowMWYa
         SJX6Ko6UpOqNCD/6Cvn1SnYko6a4rKrJ7aZm/4vIkn+RnwGKPu/9k/P5ROJG3xov8wfK
         Ff7g==
X-Gm-Message-State: AO0yUKXeAjNnxR8V9rs/n0w3PxsooU3wBr4Ui/62DLwKH/AJ6gElYihQ
        f+lOD17sGAl8DTZFHDhe4Xbe1UDKzsW50AbItsXcbGNHrOPsdmQKsATC1LXgdvoETbV73AcbBg8
        PVl6F/LV6VZon7eYh
X-Received: by 2002:a05:600c:4591:b0:3e0:481:c897 with SMTP id r17-20020a05600c459100b003e00481c897mr1269888wmo.37.1676906667353;
        Mon, 20 Feb 2023 07:24:27 -0800 (PST)
X-Google-Smtp-Source: AK7set9tFwhAVYPdJYx0EhG2sVxAmzmAIlOl5vAvFJ3YD45gjzKLDP25kfvtfbMuXNPd38LD2ll++g==
X-Received: by 2002:a05:600c:4591:b0:3e0:481:c897 with SMTP id r17-20020a05600c459100b003e00481c897mr1269863wmo.37.1676906667016;
        Mon, 20 Feb 2023 07:24:27 -0800 (PST)
Received: from redhat.com ([2.52.5.34])
        by smtp.gmail.com with ESMTPSA id p8-20020a1c7408000000b003b47b80cec3sm541587wmc.42.2023.02.20.07.24.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Feb 2023 07:24:26 -0800 (PST)
Date:   Mon, 20 Feb 2023 10:24:22 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Nanyong Sun <sunnanyong@huawei.com>, joro@8bytes.org,
        will@kernel.org, robin.murphy@arm.com, iommu@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        wangrong68@huawei.com
Subject: Re: [PATCH v2] vhost/vdpa: Add MSI translation tables to iommu for
 software-managed MSI
Message-ID: <20230220102216-mutt-send-email-mst@kernel.org>
References: <20230207120843.1580403-1-sunnanyong@huawei.com>
 <Y+7G+tiBCjKYnxcZ@nvidia.com>
 <CACGkMEtehykvqNUnfCi0VmHR1xpmhj4sSWdYW1-0oATY=0YhXw@mail.gmail.com>
 <20230217051038-mutt-send-email-mst@kernel.org>
 <CACGkMEuDG1NUs0=ry1=Mphfd+TrqAvVS0yeu9hcni2VrPkB8tQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGkMEuDG1NUs0=ry1=Mphfd+TrqAvVS0yeu9hcni2VrPkB8tQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 20, 2023 at 10:36:27AM +0800, Jason Wang wrote:
> On Fri, Feb 17, 2023 at 6:11 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Fri, Feb 17, 2023 at 01:35:59PM +0800, Jason Wang wrote:
> > > On Fri, Feb 17, 2023 at 8:15 AM Jason Gunthorpe <jgg@nvidia.com> wrote:
> > > >
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
> > > Yes, but we probably need a patch for -stable.
> >
> > Hmm do we? this looks like it's enabling new platforms is not a bugfix...
> 
> I think we haven't limited vDPA to any specific arch in the past?
> 
> Thanks

No, but it still fails gracefully right?

Anyway, this will need iommu maintainer's ack.  We'll see.


> >
> > > >
> > > > Also the iommu_group_has_isolated_msi() check is missing on the vdpa
> > > > path, and it is missing the iommu ownership mechanism.
> > >
> > > Ok.
> > >
> > > >
> > > > Also which in-tree VDPA driver that uses the iommu runs on ARM? Please
> > >
> > > ifcvf and vp_vpda are two drivers that use platform IOMMU.
> > >
> > > Thanks
> > >
> > > > don't propose core changes for unmerged drivers. :(
> > > >
> > > > Jason
> > > >
> >

