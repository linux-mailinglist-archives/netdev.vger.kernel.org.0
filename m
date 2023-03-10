Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39FD76B3B66
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 10:55:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230420AbjCJJzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 04:55:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbjCJJyv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 04:54:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9388FDD342
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 01:53:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678442031;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BJZ+haSRLZgV6ZdKradu2QUHXRi+jxvd6L7UDmrPOnQ=;
        b=EuYCdfrE83KUU2Vt50vVuAPa4xi3b6qlm6QhpeKYxJS/agDkrrQ0PjT9by3AdnZmoUnKy0
        AZTDeiJLGCxDVSvNXTBe+jEUu79ayawjVRw8ZISbuyCT5vGfpiX0QGtd8WNftv8oFUORZL
        SNi7SVJWOokxQY0+MVHVsT+ZNacmOrU=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-187-bMs7tACvMqqq_dahe2Ki8A-1; Fri, 10 Mar 2023 04:53:49 -0500
X-MC-Unique: bMs7tACvMqqq_dahe2Ki8A-1
Received: by mail-ed1-f72.google.com with SMTP id p36-20020a056402502400b004bb926a3d54so6970602eda.2
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 01:53:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678442028;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BJZ+haSRLZgV6ZdKradu2QUHXRi+jxvd6L7UDmrPOnQ=;
        b=QK/PvdiMUB3obcXK3wuouofBQgDdrBs19FA8tLyAed16hTBLz6ENg3WbMQYgeVpOxj
         q7ldrXQ2onxX1owmI3RWDP7bJ15zHciyC0S5Ys/IK4rZia86HuvBRe4derSrcDGwcBtb
         wq7uG/ekDoPXAVBfkahyIWu6Zy4WfbgrdH7za6lmpNWe9Z+SlIsmHt8KDTMzJg7kI0LA
         yWEztBnI/cuPGbJ8RTNRNNws4m6xqWMmicVoHh1PqzTQFDFxwcNc9d8kt3E7TyDwi2Bt
         sgouW1aeQOXlUqZdf5yNt4X5aC24m4vLG/5+bASss5pTX4TK+BRJY+AmxIGpNedCdVLR
         q+Zw==
X-Gm-Message-State: AO0yUKW6vG21Kj/Dkjp5mB/8kGMhYaNMJVvVi3mBF43cD0Cii9YPsGoq
        mZhpTLrD/gR2JBcGsFeq2iZLVkNVnpoBT/9rNGQwipEjqAXh/+cnXkL5V33Ng6RByQPyu/fxkWF
        IoMnBWQpQh5L8V9Rx
X-Received: by 2002:a17:907:c24c:b0:8af:2b57:b80f with SMTP id tj12-20020a170907c24c00b008af2b57b80fmr26919603ejc.55.1678442028256;
        Fri, 10 Mar 2023 01:53:48 -0800 (PST)
X-Google-Smtp-Source: AK7set84hVHKVbQM3/doo56JfwRs1MHyLT3B6JMxFy3rht/7SrZaJgsFx7Yr+6LNKTCvUqzlg4M8yA==
X-Received: by 2002:a17:907:c24c:b0:8af:2b57:b80f with SMTP id tj12-20020a170907c24c00b008af2b57b80fmr26919592ejc.55.1678442027988;
        Fri, 10 Mar 2023 01:53:47 -0800 (PST)
Received: from redhat.com ([2.52.9.88])
        by smtp.gmail.com with ESMTPSA id op7-20020a170906bce700b008e2dfc6382asm750509ejb.125.2023.03.10.01.53.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 01:53:47 -0800 (PST)
Date:   Fri, 10 Mar 2023 04:53:42 -0500
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
Message-ID: <20230310045100-mutt-send-email-mst@kernel.org>
References: <20230207120843.1580403-1-sunnanyong@huawei.com>
 <Y+7G+tiBCjKYnxcZ@nvidia.com>
 <20230217051158-mutt-send-email-mst@kernel.org>
 <Y+92c9us3HVjO2Zq@nvidia.com>
 <CACGkMEsVBhxtpUFs7TrQzAecO8kK_NR+b1EvD2H7MjJ+2aEKJw@mail.gmail.com>
 <20230310034101-mutt-send-email-mst@kernel.org>
 <CACGkMEsr3xSa=1WtU35CepWSJ8CK9g4nGXgmHS_9D09LHi7H8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEsr3xSa=1WtU35CepWSJ8CK9g4nGXgmHS_9D09LHi7H8g@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 05:45:46PM +0800, Jason Wang wrote:
> On Fri, Mar 10, 2023 at 4:41 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Mon, Feb 20, 2023 at 10:37:18AM +0800, Jason Wang wrote:
> > > On Fri, Feb 17, 2023 at 8:43 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
> > > >
> > > > On Fri, Feb 17, 2023 at 05:12:29AM -0500, Michael S. Tsirkin wrote:
> > > > > On Thu, Feb 16, 2023 at 08:14:50PM -0400, Jason Gunthorpe wrote:
> > > > > > On Tue, Feb 07, 2023 at 08:08:43PM +0800, Nanyong Sun wrote:
> > > > > > > From: Rong Wang <wangrong68@huawei.com>
> > > > > > >
> > > > > > > Once enable iommu domain for one device, the MSI
> > > > > > > translation tables have to be there for software-managed MSI.
> > > > > > > Otherwise, platform with software-managed MSI without an
> > > > > > > irq bypass function, can not get a correct memory write event
> > > > > > > from pcie, will not get irqs.
> > > > > > > The solution is to obtain the MSI phy base address from
> > > > > > > iommu reserved region, and set it to iommu MSI cookie,
> > > > > > > then translation tables will be created while request irq.
> > > > > >
> > > > > > Probably not what anyone wants to hear, but I would prefer we not add
> > > > > > more uses of this stuff. It looks like we have to get rid of
> > > > > > iommu_get_msi_cookie() :\
> > > > > >
> > > > > > I'd like it if vdpa could move to iommufd not keep copying stuff from
> > > > > > it..
> > > > >
> > > > > Absolutely but when is that happening?
> > > >
> > > > Don't know, I think it has to come from the VDPA maintainers, Nicolin
> > > > made some drafts but wasn't able to get it beyond that.
> > >
> > > Cindy (cced) will carry on the work.
> > >
> > > Thanks
> >
> > Hmm didn't see anything yet. Nanyong Sun maybe you can take a look?
> 
> Just to clarify, Cindy will work on the iommufd conversion for
> vhost-vDPA, the changes are non-trivial and may take time. Before we
> are able to achieve that,  I think we still need something like this
> patch to make vDPA work on software managed MSI platforms.
> 
> Maybe Nanyong can post a new version that addresses the comment so far?
> 
> Thanks

Maybe but an ack from iommu maintainers will be needed anyway. Let's see
that version, maybe split the export to a patch by itself to make the
need for that ack clear.


> >
> > > >
> > > > Please have people who need more iommu platform enablement to pick it
> > > > up instead of merging hacks like this..
> > > >
> > > > We are very close to having nested translation on ARM so anyone who is
> > > > serious about VDPA on ARM is going to need iommufd anyhow.
> > > >
> > > > Jason
> > > >
> >

