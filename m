Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 845684C3191
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 17:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbiBXQgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 11:36:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230258AbiBXQgb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 11:36:31 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7F9D21D67D6
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 08:35:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645720546;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wDDjkZB1tN7WoLrZnPw7rnKpZboHjUd6rhzXRyovb+E=;
        b=Sm4yayM/8K7coi7u5KWl7JmzZR070e+Hq6YuIVJcfL/sGVtjn4m3SaFCEfW4CX2ouRkp5w
        r8XFrCZUWh6+MGmDVCGe9AZ9NkWK0juQ5vX6u6HAPDbixKDLFPMphBLdlVpDEbAL8YzqQL
        dNaVyIkFkDfv3WZizYbvZ7LmjTqmEYQ=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-653-bufhYI9hPNeh3dPruoI5LQ-1; Thu, 24 Feb 2022 11:35:45 -0500
X-MC-Unique: bufhYI9hPNeh3dPruoI5LQ-1
Received: by mail-ot1-f69.google.com with SMTP id z23-20020a0568301db700b005af4caeadddso1751129oti.15
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 08:35:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=wDDjkZB1tN7WoLrZnPw7rnKpZboHjUd6rhzXRyovb+E=;
        b=ecGEuI3RIQbd//241/k0TTMOXUH4wycDTBF4Dy7Ylq3ryRLbGp3NTVOLXEsqFAYB/b
         6G5e/hLx4R8Gr2z4F6PVZSjUo6vSYkXHWSzJQ3IFm+foWtz2cO7aMH1XiKbbZa+o9rlT
         Y29gXQah9Zf41Ju9/uJkkv6EEJUpPomD5059c/yRWNq887anaSw4qOd35tVMboIU6vNV
         EaYybjXn3R3d/c0RoNpvaeQqlwfkG9hCsAUOFyBziQVUFwSFbcYpODXP9FFK/NZRmNz3
         alaHdDMhC9h1zFjZRoLz4inTWcAUg7ug0t2if83Q9TMZMZxQgRZq46dPNZz6SjI9YIGn
         ScYw==
X-Gm-Message-State: AOAM530cEc4wkneanhm82Df72gN7I9BN6A6j/LOXZmBoG6iS1ckr0PD4
        NiPZhyD7sAHivwNKdDl+ywRnQvggsC15chS/bVzWT1tchmzZgf/TELrEJzNm38QE1sMBb9PHVxb
        cc65qAANO91ZPDLXf
X-Received: by 2002:a05:6870:a889:b0:d3:65d:8458 with SMTP id eb9-20020a056870a88900b000d3065d8458mr1597112oab.134.1645720544379;
        Thu, 24 Feb 2022 08:35:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy/y7+3NJXgg5lD+7GP2KChmz8Ar5HPa014BSEX6g7UQrG9HxFNfIr0FmEi+t5Ag7Gx/SnUuw==
X-Received: by 2002:a05:6870:a889:b0:d3:65d:8458 with SMTP id eb9-20020a056870a88900b000d3065d8458mr1597089oab.134.1645720544111;
        Thu, 24 Feb 2022 08:35:44 -0800 (PST)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id w6sm1235344oop.32.2022.02.24.08.35.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 08:35:43 -0800 (PST)
Date:   Thu, 24 Feb 2022 09:35:42 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com,
        ashok.raj@intel.com, kevin.tian@intel.com,
        shameerali.kolothum.thodi@huawei.com
Subject: Re: [PATCH V9 mlx5-next 10/15] vfio: Extend the device migration
 protocol with RUNNING_P2P
Message-ID: <20220224093542.3730bb24.alex.williamson@redhat.com>
In-Reply-To: <20220224161330.GA19295@nvidia.com>
References: <20220224142024.147653-1-yishaih@nvidia.com>
        <20220224142024.147653-11-yishaih@nvidia.com>
        <87fso870k8.fsf@redhat.com>
        <20220224083042.3f5ad059.alex.williamson@redhat.com>
        <20220224161330.GA19295@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Feb 2022 12:13:30 -0400
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Thu, Feb 24, 2022 at 08:30:42AM -0700, Alex Williamson wrote:
> > On Thu, 24 Feb 2022 16:21:11 +0100
> > Cornelia Huck <cohuck@redhat.com> wrote:
> >   
> > > On Thu, Feb 24 2022, Yishai Hadas <yishaih@nvidia.com> wrote:
> > >   
> > > > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > > > index 22ed358c04c5..26a66f68371d 100644
> > > > +++ b/include/uapi/linux/vfio.h
> > > > @@ -1011,10 +1011,16 @@ struct vfio_device_feature {
> > > >   *
> > > >   * VFIO_MIGRATION_STOP_COPY means that STOP, STOP_COPY and
> > > >   * RESUMING are supported.
> > > > + *
> > > > + * VFIO_MIGRATION_STOP_COPY | VFIO_MIGRATION_P2P means that RUNNING_P2P
> > > > + * is supported in addition to the STOP_COPY states.
> > > > + *
> > > > + * Other combinations of flags have behavior to be defined in the future.
> > > >   */
> > > >  struct vfio_device_feature_migration {
> > > >  	__aligned_u64 flags;
> > > >  #define VFIO_MIGRATION_STOP_COPY	(1 << 0)
> > > > +#define VFIO_MIGRATION_P2P		(1 << 1)
> > > >  };    
> > > 
> > > Coming back to my argument (for the previous series) that this should
> > > rather be "at least one of the flags below must be set". If we operate
> > > under the general assumption that each flag indicates that a certain
> > > functionality (including some states) is supported, and that flags may
> > > depend on other flags, we might have a future flag that defines a
> > > different behaviour, but does not depend on STOP_COPY, but rather
> > > conflicts with it. We should not create the impression that STOP_COPY
> > > will neccessarily be mandatory for all time.  
> > 
> > This sounds more like an enum than a bitfield.   
> 
> It is kind of working in both ways.
> 
> The comment enumerates all the valid tests of the flags. This is not
> really a mandatory/optional scheme.
> 
> If userspace wants to check support for what is described by
> VFIO_MIGRATION_STOP_COPY | VFIO_MIGRATION_P2P then it must test both
> bits exactly as the comment says.
> 
> In this way the universe of valid tests is limited, and it acts sort
> of like an enumeration.
> 
> Using a bit test, not an equality, allows better options for future
> expansion.

Yes.
 
> The key takeaway is that userspace cannot test bit combinations that
> are not defined in the comment and expect anything - which is exactly
> what the comment says:
> 
> > * Other combinations of flags have behavior to be defined in the future.  
> 
> 
> > > conflicts with it. We should not create the impression that STOP_COPY
> > > will neccessarily be mandatory for all time.  
> 
> We really *should* create that impression because a userspace that
> does not test STOP_COPY in the cases required above is *broken* and
> must be strongly discouraged from existing.
> 
> The purpose of this comment is to inform the userspace implementator,
> not to muse about possible future expansion options for kernel
> developers. We all agree this expansion path exists and is valid, we
> need to keep that option open by helping userspace implement
> correctly.

Chatting with Connie offline, I think the clarification that might help
is something alone the lines that the combination of bits must support
migration, which currently requires the STOP_COPY and RESUMING states.
The VFIO_MIGRATION_P2P flag alone does not provide these states.  The
only flag in the current specification to provide these states is
VFIO_MIGRATION_STOP_COPY.  I don't think we want to preclude that some
future flag might provide variants of STOP_COPY and RESUMING, so it's
not so much that VFIO_MIGRATION_STOP_COPY is mandatory, but it is
currently the only flag which provides the base degree of migration
support.

How or if that translates to an actual documentation update, I'm not
sure.  As it stands, we're not speculating about future support, we're
only stating these two combinations are valid.  Future combinations may
or may not include VFIO_MIGRATION_STOP_COPY.  As the existing proposed
comment indicates, other combinations are TBD.  Connie?  Thanks,

Alex

