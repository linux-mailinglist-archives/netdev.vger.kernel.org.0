Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF7585A2753
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 14:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241123AbiHZMDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 08:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbiHZMDD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 08:03:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E27FD75A0
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 05:03:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661515381;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mvhZd1faye/ybfe/MVZNdrwm4QdnFyd9ekOspTqotG4=;
        b=Er8VnpGfMTToTayej/VIrpuxMjevw2fxg74bzOpjOZorwVcw9wrP5aWsr6obh8/OY5T09v
        1b5WY2XHs9ZrkiwRjzZmMYSKU1JU+IDHGNBC15H2uD3HkjvePk62uobwLu4voAWvZ8UHcq
        9Hb4ATMEJ6kiZCiJP96uG3t1mvswX9U=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-307-lMNpJrG7Pa6AY3WtaUbkLg-1; Fri, 26 Aug 2022 08:03:00 -0400
X-MC-Unique: lMNpJrG7Pa6AY3WtaUbkLg-1
Received: by mail-io1-f71.google.com with SMTP id i14-20020a5d934e000000b006892db5bcd4so770104ioo.22
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 05:03:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc;
        bh=mvhZd1faye/ybfe/MVZNdrwm4QdnFyd9ekOspTqotG4=;
        b=3AfwAmtP5N87DiC7EtAKRttbWBDXWJLbnvLBG8XsY/8EoHRxw3fI2hHKSqkAE0O5TF
         YazIQQNDWC3KAIShMThbiFWwHRSCkggADcieBRONMMUy2i940MCILGXA+OP73A3JDqx6
         Bn6LdhcoXeSQz0TrAci/s6Ygp5Iv94sgT1Vz8aJ025s8kANDPhZy4FYmWy981RXEZJRw
         7n/XlvAk8Ss/M5FaUUtmQEAi5Z/y7vL6SrkGIaa8iTzAn2naJ5S0N0gQokUfwLH4jAMs
         K09N3ZiMkzi15wA4DUQYixeHUNP55sOH1ghW+XVcPgOawovJ+qmPaBSYX3O6CL+sQJTI
         l5Gg==
X-Gm-Message-State: ACgBeo0/ZBYZNqBdMpA2cCZtzZNLpDUgsyOIxRkDl4GI/O2YlLN8qQrg
        IvFdzHdMZChM0YGnr8Q/VEdfg5YIfEdQvrEP+PVhA36eJ/+LIrJ5AvsTFZbY3RTgoOHjv/7P7vd
        9vwpujWujzfQ7wrI5
X-Received: by 2002:a05:6638:12cd:b0:349:fd6e:d196 with SMTP id v13-20020a05663812cd00b00349fd6ed196mr3756969jas.143.1661515379674;
        Fri, 26 Aug 2022 05:02:59 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5f6qvYWg80QTM2iPmnHp4dzNq4p0uPHomTvXhdTgrchbHDQGZaRsMe8Q0awQcEi1LZXc/Egg==
X-Received: by 2002:a05:6638:12cd:b0:349:fd6e:d196 with SMTP id v13-20020a05663812cd00b00349fd6ed196mr3756952jas.143.1661515379454;
        Fri, 26 Aug 2022 05:02:59 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id s11-20020a92cc0b000000b002ea2a4b0b63sm996235ilp.85.2022.08.26.05.02.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Aug 2022 05:02:59 -0700 (PDT)
Date:   Fri, 26 Aug 2022 06:02:57 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, jgg@nvidia.com,
        saeedm@nvidia.com, kvm@vger.kernel.org, netdev@vger.kernel.org,
        kuba@kernel.org, kevin.tian@intel.com, leonro@nvidia.com,
        maorg@nvidia.com, cohuck@redhat.com
Subject: Re: [PATCH V4 vfio 04/10] vfio: Add an IOVA bitmap support
Message-ID: <20220826060257.6767231e.alex.williamson@redhat.com>
In-Reply-To: <e78407fa-20db-ed9e-fd3e-a427712f75e7@oracle.com>
References: <20220815151109.180403-1-yishaih@nvidia.com>
        <20220815151109.180403-5-yishaih@nvidia.com>
        <20220825132701.07f9a1c3.alex.williamson@redhat.com>
        <b230f8e1-1519-3164-fe0e-abf1aa55e5d4@oracle.com>
        <20220825171532.0123cbac.alex.williamson@redhat.com>
        <e78407fa-20db-ed9e-fd3e-a427712f75e7@oracle.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 26 Aug 2022 10:37:26 +0100
Joao Martins <joao.m.martins@oracle.com> wrote:
> On 8/26/22 00:15, Alex Williamson wrote:
> > On Thu, 25 Aug 2022 23:24:39 +0100
> > Joao Martins <joao.m.martins@oracle.com> wrote:  
> >> On 8/25/22 20:27, Alex Williamson wrote:  
> >>> Maybe it doesn't really make sense to differentiate the iterator from
> >>> the bitmap in the API.  In fact, couldn't we reduce the API to simply:
> >>>
> >>> int iova_bitmap_init(struct iova_bitmap *bitmap, dma_addr_t iova,
> >>> 		     size_t length, size_t page_size, u64 __user *data);
> >>>
> >>> int iova_bitmap_for_each(struct iova_bitmap *bitmap, void *data,
> >>> 			 int (*fn)(void *data, dma_addr_t iova,
> >>> 			 	   size_t length,
> >>> 				   struct iova_bitmap *bitmap));
> >>>
> >>> void iova_bitmap_free(struct iova_bitmap *bitmap);
> >>>
> >>> unsigned long iova_bitmap_set(struct iova_bitmap *bitmap,
> >>> 			      dma_addr_t iova, size_t length);
> >>>
> >>> Removes the need for the API to have done, advance, iova, and length
> >>> functions.
> >>>     
> >> True, it would be simpler.
> >>
> >> Could also allow us to hide the iterator details enterily and switch to
> >> container_of() from iova_bitmap pointer. Though, from caller, it would be
> >> weird to do:
> >>
> >> struct iova_bitmap_iter iter;
> >>
> >> iova_bitmap_init(&iter.dirty, ....);
> >>
> >> Hmm, maybe not that strange.
> >>
> >> Unless you are trying to suggest to merge both struct iova_bitmap and
> >> iova_bitmap_iter together? I was trying to keep them separate more for
> >> the dirty tracker (IOMMUFD/VFIO, to just be limited to iova_bitmap_set()
> >> with the generic infra being the one managing that iterator state in a
> >> separate structure.  
> > 
> > Not suggesting the be merged, but why does the embedded mapping
> > structure need to be exposed to the API?  That's an implementation
> > detail that's causing confusion and naming issues for which structure
> > is passed and how do we represent that in the function name.  Thanks,  
> 
> I wanted the convention to be that the end 'device' tracker (IOMMU or VFIO
> vendor driver) does not have "direct" access to the iterator state. So it acesses
> or modifies only the mapped bitmap *data*. The hardware tracker is always *provided*
> with a iova_bitmap to set bits but it should not allocate, iterate or pin anything,
> making things simpler for tracker.
> 
> Thus the point was to have a clear division between how you iterate
> (iova_bitmap_iter* API) and the actual bits manipulation (so far only
> iova_bitmap_set()) including which data structures you access in the APIs, thus
> embedding the least accessed there (struct iova_bitmap).
> 
> The alternative is to reverse it and just allocate iter state in iova_bitmap_init()
> and have it stored as a pointer say as iova_bitmap::iter. We encapsulate both and mix
> the structures, which while not as clean but maybe this is not that big of a deal as
> I thought it would be

Is there really a need for struct iova_bitmap to be defined in a shared
header, or could we just have a forward declaration?  With the proposed
interface above, iova_bitmap could be opaque to the caller if it were
dynamically allocated, ex:

struct iova_bitmap* iova_bitmap_alloc(dma_addr_t iova, size_t length,
				      size_t page_size, u64 __user *bitmap);

Thanks,
Alex

