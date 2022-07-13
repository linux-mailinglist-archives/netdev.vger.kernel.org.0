Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB4F572D0C
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 07:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbiGMF1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 01:27:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiGMF1J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 01:27:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BFC17DC19C
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 22:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657690024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=z/8AW1mLy0vS7+l6IodLYuxxHB7nmU0fVG4Vd5xB/EI=;
        b=iWAkoXX3p0lB877eWyP25744R0+64kgPrzE4Rdxgo4GCGgseSc5T7JuL5V6XeoqQgM8gJf
        fFikncLHm7NKB4uufG9ZAq3GXM9UUYvM7YpxSMeiRq68w4WJYm9RoTYLOT64SXWHVXt0dz
        fHWj9ssmJAU+eFYfD/v5b3+ktsIVQpo=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-660-1oMIrmjcOI-yuEL-ZOwQQg-1; Wed, 13 Jul 2022 01:27:03 -0400
X-MC-Unique: 1oMIrmjcOI-yuEL-ZOwQQg-1
Received: by mail-wm1-f71.google.com with SMTP id k62-20020a1ca141000000b003a2e342a55bso4433954wme.1
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 22:27:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=z/8AW1mLy0vS7+l6IodLYuxxHB7nmU0fVG4Vd5xB/EI=;
        b=MwH//tt7YgRNlOjrN0Buhd6hP8waDAPqwfe7OLV1Dtsf4z9so5Spv13L3VX/XQZjd0
         rgDRSe+sQcz8XYRNIkAuT1MS5hr1p/CVeHGd3p6Hc279eSoiHLU9HMcZpqz+MyZJm7Du
         LtsDmKF04oeOuN4lLyaQr/GcH2kODyfWA48lmeWAo3SDIECqRyNIgDutXtRD72SP0LtJ
         fOTUyH4E+RHEwFvB+SXqYRPMxRc4+Rn7i1QgdoIdXZuhOuAW1NsMjijrzQP94HIw2ViJ
         q0JDqAImUihA8FYYfAf/pezv5jYDqrOqsw6XvTaYVBPuwvqpYN3XJEBzXfgXCJD1JxYA
         SiXg==
X-Gm-Message-State: AJIora8PVecAiH6MSvgFJPoZqhDXt8hCl8OgwgprX0Iy8ZVNfJ6FJUoU
        UppGKQDDEsXJAi4Ri8YmRxzPQd68V6jZT4eaV7TYtvTWbth6u2G4HPI9Atmq8w8BIQeNUEzYQ6V
        2Yhx+9avEpjJUIIy7
X-Received: by 2002:adf:ce81:0:b0:21d:6d21:9752 with SMTP id r1-20020adfce81000000b0021d6d219752mr1362244wrn.26.1657690022478;
        Tue, 12 Jul 2022 22:27:02 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uowWaNmX8XxlwA6SGk6pOQWK89++LFMozOdfKgz9YOkSHJGoX27WaK+yiZFiAfckDuwrGSMw==
X-Received: by 2002:adf:ce81:0:b0:21d:6d21:9752 with SMTP id r1-20020adfce81000000b0021d6d219752mr1362232wrn.26.1657690022234;
        Tue, 12 Jul 2022 22:27:02 -0700 (PDT)
Received: from redhat.com ([2.52.24.42])
        by smtp.gmail.com with ESMTPSA id m2-20020a05600c3b0200b0039ee391a024sm975273wms.14.2022.07.12.22.27.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 22:27:01 -0700 (PDT)
Date:   Wed, 13 Jul 2022 01:26:58 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Parav Pandit <parav@nvidia.com>
Cc:     Zhu Lingshan <lingshan.zhu@intel.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>
Subject: Re: [PATCH V3 5/6] vDPA: answer num of queue pairs = 1 to userspace
 when VIRTIO_NET_F_MQ == 0
Message-ID: <20220713011631-mutt-send-email-mst@kernel.org>
References: <20220701132826.8132-1-lingshan.zhu@intel.com>
 <20220701132826.8132-6-lingshan.zhu@intel.com>
 <PH0PR12MB548173B9511FD3941E2D5F64DCBD9@PH0PR12MB5481.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR12MB548173B9511FD3941E2D5F64DCBD9@PH0PR12MB5481.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 01, 2022 at 10:07:59PM +0000, Parav Pandit wrote:
> 
> 
> > From: Zhu Lingshan <lingshan.zhu@intel.com>
> > Sent: Friday, July 1, 2022 9:28 AM
> > If VIRTIO_NET_F_MQ == 0, the virtio device should have one queue pair, so
> > when userspace querying queue pair numbers, it should return mq=1 than
> > zero.
> > 
> > Function vdpa_dev_net_config_fill() fills the attributions of the vDPA
> > devices, so that it should call vdpa_dev_net_mq_config_fill() so the
> > parameter in vdpa_dev_net_mq_config_fill() should be feature_device than
> > feature_driver for the vDPA devices themselves
> > 
> > Before this change, when MQ = 0, iproute2 output:
> > $vdpa dev config show vdpa0
> > vdpa0: mac 00:e8:ca:11:be:05 link up link_announce false max_vq_pairs 0
> > mtu 1500
> >
> The fix belongs to user space.
> When a feature bit _MQ is not negotiated, vdpa kernel space will not add attribute VDPA_ATTR_DEV_NET_CFG_MAX_VQP.
> When such attribute is not returned by kernel, max_vq_pairs should not be shown by the iproute2.
> 
> We have many config space fields that depend on the feature bits and some of them do not have any defaults.
> To keep consistency of existence of config space fields among all, we don't want to show default like below.
> 
> Please fix the iproute2 to not print max_vq_pairs when it is not returned by the kernel.

Parav I read the discussion and don't get your argument. From driver's POV
_MQ with 1 VQ pair and !_MQ are exactly functionally equivalent.

It's true that iproute probably needs to be fixed too, to handle old
kernels. But iproute is not the only userspace, why not make it's life
easier by fixing the kernel?

-- 
MST

