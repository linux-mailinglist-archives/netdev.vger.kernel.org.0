Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C086586408
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 08:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239813AbiHAG0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 02:26:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbiHAG0H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 02:26:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 789BEDF94
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 23:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659335165;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RZbVHA0w0Xc+aslJovVEopjfgsCwbIKoUshPZUH/uWE=;
        b=D6LK5jQsYMNXURzqYJLFO6RvvX/AILUlwC4Gt/2K3vWYDJwSnN5W1QERQy1CiZ+wJs7nBt
        6qWHrUI+NTJ0sjpFLdwnRm1Ef4t72AwCJmHvh1MQa5plm6U4kzUarKTaf/pJEUwVNh3mU9
        zJ5CMcXnvPncQTVYCPPyAUwETfUuZCo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-496-euSJxpYVMTuPokFQ_I3paA-1; Mon, 01 Aug 2022 02:26:03 -0400
X-MC-Unique: euSJxpYVMTuPokFQ_I3paA-1
Received: by mail-wr1-f70.google.com with SMTP id w17-20020adfbad1000000b0021f0acd5398so2137097wrg.1
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 23:26:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=RZbVHA0w0Xc+aslJovVEopjfgsCwbIKoUshPZUH/uWE=;
        b=JiA5i9GP5mmDoTohuGJG8OQJ+ACuw4m5eOGou1CQPJuEZGH9jGwl1X35EvFu9l2weA
         bFBJptKdiUghgmfcTZLAkP6bKGQqty9+oJ+3+vrFLf5SVGMN2dhcg9Ncpid334SWWKr0
         8BbVm6fXGIZSyYG4x4ggyPfdiI7z9OH6jrCSUBrbpF7Rwt/sZsCuHqTbofcoIavvJvgD
         W4Y6T5adqTswzZ+da/IIJibWXhAI90xgQDfmzV9H8rBn8VLhdUm3thxRovXIliVj3iXo
         hQtKC+RV15dHKB0TOwx9lVULdr+j63wljVl4KWm4NDUF+9UAo6epQTKlO9fO/OyQW9Id
         GVkQ==
X-Gm-Message-State: AJIora+ofIOBF79WlNSoQ0QJHfL5EKjOiYdJTyuGaLjt7KKQAGnSxTPz
        74QaVnmf7H5xxvae7OsFGfvwMYJOMeEj1/IRCtScYajHLgJYp379MOKRcj5+Vjx3hugOCaJYHry
        Dgx2jKf3iKiemkQL1
X-Received: by 2002:a05:600c:683:b0:3a2:fe34:3e1a with SMTP id a3-20020a05600c068300b003a2fe343e1amr10265753wmn.192.1659335162549;
        Sun, 31 Jul 2022 23:26:02 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vg99hZHhSrU0VsvVoqqOBmMcCkq3sC98q3CkmYWO+M89+5XE/AFnHDNNgtojz56WBtoMkeeQ==
X-Received: by 2002:a05:600c:683:b0:3a2:fe34:3e1a with SMTP id a3-20020a05600c068300b003a2fe343e1amr10265743wmn.192.1659335162321;
        Sun, 31 Jul 2022 23:26:02 -0700 (PDT)
Received: from redhat.com ([2.52.130.0])
        by smtp.gmail.com with ESMTPSA id z5-20020a5d6405000000b0021f138e07acsm8279636wru.35.2022.07.31.23.26.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Jul 2022 23:26:01 -0700 (PDT)
Date:   Mon, 1 Aug 2022 02:25:57 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        parav@nvidia.com, xieyongji@bytedance.com, gautam.dawar@amd.com
Subject: Re: [PATCH V3 6/6] vDPA: fix 'cast to restricted le16' warnings in
 vdpa.c
Message-ID: <20220801022539-mutt-send-email-mst@kernel.org>
References: <20220701132826.8132-1-lingshan.zhu@intel.com>
 <20220701132826.8132-7-lingshan.zhu@intel.com>
 <20220729045039-mutt-send-email-mst@kernel.org>
 <7ce4da7f-80aa-14d6-8200-c7f928f32b48@intel.com>
 <20220729051119-mutt-send-email-mst@kernel.org>
 <50b4e7ba-3e49-24b7-5c23-d8a76c61c924@intel.com>
 <20220729052149-mutt-send-email-mst@kernel.org>
 <05bf4c84-28dd-4956-4719-3a5361d151d8@intel.com>
 <20220729053615-mutt-send-email-mst@kernel.org>
 <555d9757-0989-5a57-c3c5-dfb741f23564@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <555d9757-0989-5a57-c3c5-dfb741f23564@redhat.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 01, 2022 at 12:33:44PM +0800, Jason Wang wrote:
> 
> 在 2022/7/29 17:39, Michael S. Tsirkin 写道:
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
> 
> 
> Not sure, and even if we had this, the query could happen before
> VHOST_SET_VRING_ENDIAN.
> 
> Actually, the patch should be fine itself, since the issue exist even before
> the patch (which assumes a le).
> 
> Thanks


I agree, let's just add a TODO comment.

> 
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

