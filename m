Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E61CB584E8E
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 12:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235495AbiG2KQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 06:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234827AbiG2KQf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 06:16:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5F9EB5A153
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 03:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659089792;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iWL3NAWG3ppJl3mwx2whoKSyv4nrUsZKE4WIgdT1mxo=;
        b=YmgsJdFNa57GTC462UMihZFkJ59Biw7J+x8FgAMJW5fWfBL1Jlmf5UgRDq06G6Lr0j3FvY
        zjo35deSph8ghl8qrP2+NzbBoxwn8ytDCF28zWugHARK/4eqI3mY+yl6TQGABtwcjqFwgp
        vw/7dVDhqjNVRKpR775+Zkax5jpiJpE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-475-xsxJvqK9NXKoCq8VETf9_g-1; Fri, 29 Jul 2022 06:16:31 -0400
X-MC-Unique: xsxJvqK9NXKoCq8VETf9_g-1
Received: by mail-wr1-f69.google.com with SMTP id i15-20020adfa50f000000b0021ebd499de2so1055288wrb.7
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 03:16:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=iWL3NAWG3ppJl3mwx2whoKSyv4nrUsZKE4WIgdT1mxo=;
        b=bI1jRr2wOuAJu0dzaJGSLOs7Q+obkXoeb5KL96WCL0/A/xBQvfrx+aDoTkRGX+bpae
         jouDzy4PUJ7KEAwPjdLFVkUqlAwjrjMTE+22XlzrsL7oMntACrC96VEhok26IHqcfSpD
         yxch6IlIr8gCGEBdfZV2nlzESxgkoMT4I2L2RVtARxbFveKKey/ctD/SekS8kQRMIOte
         cXownAaCv9s8oYZzqbiMYSlRMekxUDRtw2EYgjXsIL2XVX79okju03VcOv75+MtPsg13
         fs8DyI+0Dz4RPn+uCp4cZ424hyiVFVe8/k0eQc63uqPqTsK91yk02+jjDCiuraQAp6gN
         PDlQ==
X-Gm-Message-State: AJIora/VFjU1NQTe5S+aAe653fzv2exNNCnE5MX3AsAOQortz1tiEGDm
        wRXZ/kEK6E5/EsRwxwGlSJyr4a74c0xDR3dCYVD30e05ZDRjwr7ln+wTMvTUckLS87e54vdRjtN
        wpsBhjLVDSk8KZ+Q8
X-Received: by 2002:a05:600c:4e4b:b0:3a3:19bf:35e1 with SMTP id e11-20020a05600c4e4b00b003a319bf35e1mr2356557wmq.74.1659089790584;
        Fri, 29 Jul 2022 03:16:30 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1usMxzAsZ4QDmMbUfElFkphsghoQYmabWjYP/bB1lTAbeVJ3zCzLL67ohkXH4Ls93FdXUSmRQ==
X-Received: by 2002:a05:600c:4e4b:b0:3a3:19bf:35e1 with SMTP id e11-20020a05600c4e4b00b003a319bf35e1mr2356524wmq.74.1659089790067;
        Fri, 29 Jul 2022 03:16:30 -0700 (PDT)
Received: from redhat.com ([2.54.183.236])
        by smtp.gmail.com with ESMTPSA id o5-20020a05600c510500b003a2d6c623f3sm8712248wms.19.2022.07.29.03.16.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 03:16:29 -0700 (PDT)
Date:   Fri, 29 Jul 2022 06:16:26 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>
Cc:     jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, parav@nvidia.com, xieyongji@bytedance.com,
        gautam.dawar@amd.com
Subject: Re: [PATCH V3 6/6] vDPA: fix 'cast to restricted le16' warnings in
 vdpa.c
Message-ID: <20220729061433-mutt-send-email-mst@kernel.org>
References: <20220701132826.8132-1-lingshan.zhu@intel.com>
 <20220701132826.8132-7-lingshan.zhu@intel.com>
 <20220729045039-mutt-send-email-mst@kernel.org>
 <7ce4da7f-80aa-14d6-8200-c7f928f32b48@intel.com>
 <20220729051119-mutt-send-email-mst@kernel.org>
 <50b4e7ba-3e49-24b7-5c23-d8a76c61c924@intel.com>
 <20220729052149-mutt-send-email-mst@kernel.org>
 <05bf4c84-28dd-4956-4719-3a5361d151d8@intel.com>
 <20220729053615-mutt-send-email-mst@kernel.org>
 <87efac3e-2196-f9ad-1af1-a27470824eac@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87efac3e-2196-f9ad-1af1-a27470824eac@intel.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 29, 2022 at 06:01:38PM +0800, Zhu, Lingshan wrote:
> 
> 
> On 7/29/2022 5:39 PM, Michael S. Tsirkin wrote:
> > On Fri, Jul 29, 2022 at 05:35:09PM +0800, Zhu, Lingshan wrote:
> > > 
> > > On 7/29/2022 5:23 PM, Michael S. Tsirkin wrote:
> > > > On Fri, Jul 29, 2022 at 05:20:17PM +0800, Zhu, Lingshan wrote:
> > > > > On 7/29/2022 5:17 PM, Michael S. Tsirkin wrote:
> > > > > > On Fri, Jul 29, 2022 at 05:07:11PM +0800, Zhu, Lingshan wrote:
> > > > > > > On 7/29/2022 4:53 PM, Michael S. Tsirkin wrote:
> > > > > > > > On Fri, Jul 01, 2022 at 09:28:26PM +0800, Zhu Lingshan wrote:
> > > > > > > > > This commit fixes spars warnings: cast to restricted __le16
> > > > > > > > > in function vdpa_dev_net_config_fill() and
> > > > > > > > > vdpa_fill_stats_rec()
> > > > > > > > > 
> > > > > > > > > Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> > > > > > > > > ---
> > > > > > > > >      drivers/vdpa/vdpa.c | 6 +++---
> > > > > > > > >      1 file changed, 3 insertions(+), 3 deletions(-)
> > > > > > > > > 
> > > > > > > > > diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
> > > > > > > > > index 846dd37f3549..ed49fe46a79e 100644
> > > > > > > > > --- a/drivers/vdpa/vdpa.c
> > > > > > > > > +++ b/drivers/vdpa/vdpa.c
> > > > > > > > > @@ -825,11 +825,11 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
> > > > > > > > >      		    config.mac))
> > > > > > > > >      		return -EMSGSIZE;
> > > > > > > > > -	val_u16 = le16_to_cpu(config.status);
> > > > > > > > > +	val_u16 = __virtio16_to_cpu(true, config.status);
> > > > > > > > >      	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_STATUS, val_u16))
> > > > > > > > >      		return -EMSGSIZE;
> > > > > > > > > -	val_u16 = le16_to_cpu(config.mtu);
> > > > > > > > > +	val_u16 = __virtio16_to_cpu(true, config.mtu);
> > > > > > > > >      	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
> > > > > > > > >      		return -EMSGSIZE;
> > > > > > > > Wrong on BE platforms with legacy interface, isn't it?
> > > > > > > > We generally don't handle legacy properly in VDPA so it's
> > > > > > > > not a huge deal, but maybe add a comment at least?
> > > > > > > Sure, I can add a comment here: this is for modern devices only.
> > > > > > > 
> > > > > > > Thanks,
> > > > > > > Zhu Lingshan
> > > > > > Hmm. what "this" is for modern devices only here?
> > > > > this cast, for LE modern devices.
> > > > I think status existed in legacy for sure, and it's possible that
> > > > some legacy devices backported mtu and max_virtqueue_pairs otherwise
> > > > we would have these fields as __le not as __virtio, right?
> > > yes, that's the reason why it is virtio_16 than just le16.
> > > 
> > > I may find a better solution to detect whether it is LE, or BE without a
> > > virtio_dev structure.
> > > Check whether vdpa_device->get_device_features() has VIRTIO_F_VERISON_1. If
> > > the device offers _F_VERSION_1, then it is a LE device,
> > > or it is a BE device, then we use __virtio16_to_cpu(false, config.status).
> > > 
> > > Does this look good?
> > No since the question is can be a legacy driver with a transitional
> > device.  I don't have a good idea yet. vhost has VHOST_SET_VRING_ENDIAN
> > and maybe we need something like this for config as well?
> Is it a little overkill to implementing vdpa_ops.get_endian()?

I think the question is driver endian-ness.

But another approach is really just to say userspace should
tweak config endian itself.  Let's just say that in the comment?
/*
 * Assume little endian for now, userspace can tweak this for
 * legacy guest support.
 */
?

> > 
> > > > > > > > > @@ -911,7 +911,7 @@ static int vdpa_fill_stats_rec(struct vdpa_device *vdev, struct sk_buff *msg,
> > > > > > > > >      	}
> > > > > > > > >      	vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config));
> > > > > > > > > -	max_vqp = le16_to_cpu(config.max_virtqueue_pairs);
> > > > > > > > > +	max_vqp = __virtio16_to_cpu(true, config.max_virtqueue_pairs);
> > > > > > > > >      	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, max_vqp))
> > > > > > > > >      		return -EMSGSIZE;
> > > > > > > > > -- 
> > > > > > > > > 2.31.1

