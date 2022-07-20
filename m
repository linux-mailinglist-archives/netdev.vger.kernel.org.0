Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A061757B374
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 11:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232452AbiGTJGA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 05:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231806AbiGTJF7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 05:05:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3336E474CC
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 02:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658307957;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hUH5Z/hHJ+hGm2pA2z/ZRWuwGM5GCMYI9hiRh4b+WpQ=;
        b=SWGRh8WwvKXKJeFJsvFy2HDcz5xPgnMW8XnXlJ+NK9w8XikIEvZb+bClfVXV2ShQP9QuZM
        L9uZSFVhoVPXYP7TvOrqWYAyj21A+ya5QHgPrAZdrC6873OuiYK1dBsrL6tbtz9OWd5PcP
        GV8rnAwWS3vVtMtsLpEl8agOu0FwUYY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-246-IK_HPx1xMZSPE0upGMA_4w-1; Wed, 20 Jul 2022 05:05:50 -0400
X-MC-Unique: IK_HPx1xMZSPE0upGMA_4w-1
Received: by mail-wm1-f72.google.com with SMTP id 189-20020a1c02c6000000b003a2d01897e4so7103047wmc.9
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 02:05:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hUH5Z/hHJ+hGm2pA2z/ZRWuwGM5GCMYI9hiRh4b+WpQ=;
        b=NWF2pI9IFuZp1Cdn2wIgT5u7nXTxmAqSX6zw3coQ36Anz3u6i/6AsQz/Te2mQruldH
         cVhatHN/XRn0Yivzf7eWlgZao7Y7rchKz+Yeqm8hvkjRA5ALyPSJHXVIKYA0QHmirLSi
         RB1NTZ5CxfgDPkxwSHUS2TqmyvQZwEIx6xccUPyeOtRa7M1rcLUIjfgmQ7Z98Miu0wXV
         9bvuq4UKrokztuitURUoTDaisGBFN9MNbyUHBUAWH74LVCyd+zyDnRmTTVA0nHGVGLE5
         gnSSR2gwKuU6a412onsss0T73TmXAtXWLt1uA6y9xp0RSEXxW3wMyIkyVa9Qmyl9Dvdd
         LNXg==
X-Gm-Message-State: AJIora+cvggAp6Lyeh0H5QAId6q9xmakREvTDdGjYy9w6wc3FjKAuVCP
        Q5ZcrSengSIUKi5Zj+9kjwZIZN21l02hQFVruIjaIsHPJPQR+47YUHeYb1OToW2/sqy4uTWWf0a
        UJyii1D4IcRR3qF7Y
X-Received: by 2002:adf:d1c4:0:b0:21d:76e1:bf2c with SMTP id b4-20020adfd1c4000000b0021d76e1bf2cmr30201218wrd.576.1658307948710;
        Wed, 20 Jul 2022 02:05:48 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vbsfPmQX3Sx3ldJf4ik5BdkgjRSpn6B7XQEV6k9RWhNBHKL0nWkOWmYHPxfwF1ulidovZVWg==
X-Received: by 2002:adf:d1c4:0:b0:21d:76e1:bf2c with SMTP id b4-20020adfd1c4000000b0021d76e1bf2cmr30201193wrd.576.1658307948468;
        Wed, 20 Jul 2022 02:05:48 -0700 (PDT)
Received: from redhat.com ([2.55.25.63])
        by smtp.gmail.com with ESMTPSA id x8-20020a05600c21c800b003a31ba538c2sm1651782wmj.40.2022.07.20.02.05.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 02:05:47 -0700 (PDT)
Date:   Wed, 20 Jul 2022 05:05:44 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Alvaro Karsz <alvaro.karsz@solid-run.com>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v4] net: virtio_net: notifications coalescing
 support
Message-ID: <20220720045658-mutt-send-email-mst@kernel.org>
References: <20220718091102.498774-1-alvaro.karsz@solid-run.com>
 <20220719172652.0d072280@kernel.org>
 <20220720022901-mutt-send-email-mst@kernel.org>
 <CACGkMEvFdMRX-sb7hUpEq+6e04ubehefr8y5Gjnjz8R26f=qDA@mail.gmail.com>
 <20220720030343-mutt-send-email-mst@kernel.org>
 <CACGkMEuLSAFfh-vZ1XoerjNrbPWVmfF-L5DCGBPMnwzif7ENSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGkMEuLSAFfh-vZ1XoerjNrbPWVmfF-L5DCGBPMnwzif7ENSA@mail.gmail.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 20, 2022 at 03:15:08PM +0800, Jason Wang wrote:
> On Wed, Jul 20, 2022 at 3:05 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Wed, Jul 20, 2022 at 03:02:04PM +0800, Jason Wang wrote:
> > > On Wed, Jul 20, 2022 at 2:45 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > >
> > > > On Tue, Jul 19, 2022 at 05:26:52PM -0700, Jakub Kicinski wrote:
> > > > > On Mon, 18 Jul 2022 12:11:02 +0300 Alvaro Karsz wrote:
> > > > > > New VirtIO network feature: VIRTIO_NET_F_NOTF_COAL.
> > > > > >
> > > > > > Control a Virtio network device notifications coalescing parameters
> > > > > > using the control virtqueue.
> > > > > >
> > > > > > A device that supports this fetature can receive
> > > > > > VIRTIO_NET_CTRL_NOTF_COAL control commands.
> > > > > >
> > > > > > - VIRTIO_NET_CTRL_NOTF_COAL_TX_SET:
> > > > > >   Ask the network device to change the following parameters:
> > > > > >   - tx_usecs: Maximum number of usecs to delay a TX notification.
> > > > > >   - tx_max_packets: Maximum number of packets to send before a
> > > > > >     TX notification.
> > > > > >
> > > > > > - VIRTIO_NET_CTRL_NOTF_COAL_RX_SET:
> > > > > >   Ask the network device to change the following parameters:
> > > > > >   - rx_usecs: Maximum number of usecs to delay a RX notification.
> > > > > >   - rx_max_packets: Maximum number of packets to receive before a
> > > > > >     RX notification.
> > > > > >
> > > > > > VirtIO spec. patch:
> > > > > > https://lists.oasis-open.org/archives/virtio-comment/202206/msg00100.html
> > > > > >
> > > > > > Signed-off-by: Alvaro Karsz <alvaro.karsz@solid-run.com>
> > > > >
> > > > > Waiting a bit longer for Michael's ack, so in case other netdev
> > > > > maintainer takes this:
> > > > >
> > > > > Reviewed-by: Jakub Kicinski <kuba@kernel.org>
> > > >
> > > > Yea was going to ack this but looking at the UAPI again we have a
> > > > problem because we abused tax max frames values 0 and 1 to control napi
> > > > in the past. technically does not affect legacy cards but userspace
> > > > can't easily tell the difference, can it?
> > >
> > > The "abuse" only works for iproute2.
> >
> > That's kernel/userspace API. That's what this patch affects, right?
> 
> I'm not sure I get this.
> 
> The 1-to-enable-napi is only used between iproute2 and kernel via
> ETHTOOL_A_COALESCE_TX_MAX_FRAMES not the uAPI introduced here.
> So I don't see how it can conflict with the virito uAPI extension here.
> 
> Thanks

As far as I can see ETHTOOL_A_COALESCE_TX_MAX_FRAMES invokes the
ops->get_coalesce and ops->set_coalesce callbacks.
This patch changes their behaviour when the card has VIRTIO_NET_F_NOTF_COAL.

Userspace making assumptions about what this option does will
thinkably might get unexpected behaviour. So:

Minimally we need a way for userspace to find out what are the semantics
of the command now, so one can implement portable userspace going
forward.

Preferably, analysis of existing userspace, what it does and how
does the change affect it should be included.

Ideally, a work-around that does not affect existing userspace
would be found.


> 
> >
> > > For uAPI we know it should follow
> > > the spec? (anyhow NAPI is something out of the spec)
> > >
> > > Thanks
> >
> > When you say uAPI here you mean the virtio header. I am not
> > worried about that just yet (maybe I should be).
> >
> > > >
> > > > --
> > > > MST
> > > >
> >

