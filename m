Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6AA55C82E
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbiF0Gjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 02:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232234AbiF0Gjy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 02:39:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 256832BF8
        for <netdev@vger.kernel.org>; Sun, 26 Jun 2022 23:39:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656311992;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U7baKcmVh0uhuh+ZmBGa53jqLb2UYPCAjccnnH6jK0k=;
        b=RBMXiC1qYB+yM8w4m4XxcH1W4IekBWfTlqb/GcduNEEXtOwaM1ck51jGi/b7hfLKmSHy0p
        CSAUoZqCmGaGUF5zR7bq7sbVJKfhAPp903bFFStW7OEYHc0L7lcbiw0PIGwhnwjtHY8qOA
        WJB4Q/xuVHbw7h5BVeHbg8IfzGaA+jY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-191-Dhfm8M6XMXeU__SVusUsnQ-1; Mon, 27 Jun 2022 02:39:49 -0400
X-MC-Unique: Dhfm8M6XMXeU__SVusUsnQ-1
Received: by mail-wm1-f71.google.com with SMTP id j31-20020a05600c1c1f00b0039c481c4664so3139936wms.7
        for <netdev@vger.kernel.org>; Sun, 26 Jun 2022 23:39:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=U7baKcmVh0uhuh+ZmBGa53jqLb2UYPCAjccnnH6jK0k=;
        b=rkv26oyz10IG8fC2tUV5F9lYWdgpMvV0T8LZlTKsuo9/gE0Z+Pj+sTh2j9g1RAbyyO
         ikLmdEcBWNCERqZIEb3675jXc3HN1pZY5hhS9DiNAW0KsoWhyDhaOjjYZsyP6EGStexY
         6wlDjOQOTlalwjXqbp0zjxCTaxvFKEGvxLSJie24BrkqnPZ8pP7itBSivmtXqthr5ZNb
         33NYRDlBCF3nxyppKGu3yCxmLd7fYVb+WtvtKQ54L7oX0vCefCQGJl/0z67e9PjrfX1N
         TQnUroKev3qVKgjx9FAxpr95/KMThCld12Pb+pFMn8i5txN7zyAYo81LHtY78zkTgEBh
         b8rg==
X-Gm-Message-State: AJIora8EAgEdURUWymJz7jPMld0Ka3QgO0KRexEKSdlw8pYUUTU2Lr8e
        40visEOJEV5UWB6XK7kh7MEqbIdnOhBRxiwQoTPnV/OoNAf3MpKGC4TSDzxt/LV5g8TA97n1AWj
        leVSYQ7Nff4RiFoE6
X-Received: by 2002:a1c:7719:0:b0:3a0:31a6:4469 with SMTP id t25-20020a1c7719000000b003a031a64469mr13386052wmi.20.1656311988762;
        Sun, 26 Jun 2022 23:39:48 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vfc26YvQIey3qttFGe5qu2ZyIXAHXaFMfl6hGpqk+G+5KirT06gbQyA+crLIwD71j66IUjig==
X-Received: by 2002:a1c:7719:0:b0:3a0:31a6:4469 with SMTP id t25-20020a1c7719000000b003a031a64469mr13386024wmi.20.1656311988469;
        Sun, 26 Jun 2022 23:39:48 -0700 (PDT)
Received: from redhat.com ([2.54.45.90])
        by smtp.gmail.com with ESMTPSA id bg21-20020a05600c3c9500b003a046549a85sm5777975wmb.37.2022.06.26.23.39.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jun 2022 23:39:47 -0700 (PDT)
Date:   Mon, 27 Jun 2022 02:39:41 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Richard Weinberger <richard@nod.at>,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        Vadim Pasternak <vadimp@nvidia.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        linux-um@lists.infradead.org, netdev <netdev@vger.kernel.org>,
        platform-driver-x86@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org,
        kvm <kvm@vger.kernel.org>,
        "open list:XDP (eXpress Data Path)" <bpf@vger.kernel.org>,
        kangjie.xu@linux.alibaba.com
Subject: Re: [PATCH v10 25/41] virtio_pci: struct virtio_pci_common_cfg add
 queue_notify_data
Message-ID: <20220627023841-mutt-send-email-mst@kernel.org>
References: <20220624025621.128843-1-xuanzhuo@linux.alibaba.com>
 <20220624025621.128843-26-xuanzhuo@linux.alibaba.com>
 <20220624025817-mutt-send-email-mst@kernel.org>
 <CACGkMEseptD=45j3kQr0yciRxR679Jcig=292H07-RYC2vXmFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGkMEseptD=45j3kQr0yciRxR679Jcig=292H07-RYC2vXmFQ@mail.gmail.com>
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 27, 2022 at 10:30:42AM +0800, Jason Wang wrote:
> On Fri, Jun 24, 2022 at 2:59 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Fri, Jun 24, 2022 at 10:56:05AM +0800, Xuan Zhuo wrote:
> > > Add queue_notify_data in struct virtio_pci_common_cfg, which comes from
> > > here https://github.com/oasis-tcs/virtio-spec/issues/89
> > >
> > > For not breaks uABI, add a new struct virtio_pci_common_cfg_notify.
> >
> > What exactly is meant by not breaking uABI?
> > Users are supposed to be prepared for struct size to change ... no?
> 
> Not sure, any doc for this?
> 
> Thanks


Well we have this:

        The drivers SHOULD only map part of configuration structure
        large enough for device operation.  The drivers MUST handle
        an unexpectedly large \field{length}, but MAY check that \field{length}
        is large enough for device operation.



> 
> >
> >
> > > Since I want to add queue_reset after queue_notify_data, I submitted
> > > this patch first.
> > >
> > > Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > Acked-by: Jason Wang <jasowang@redhat.com>
> > > ---
> > >  include/uapi/linux/virtio_pci.h | 7 +++++++
> > >  1 file changed, 7 insertions(+)
> > >
> > > diff --git a/include/uapi/linux/virtio_pci.h b/include/uapi/linux/virtio_pci.h
> > > index 3a86f36d7e3d..22bec9bd0dfc 100644
> > > --- a/include/uapi/linux/virtio_pci.h
> > > +++ b/include/uapi/linux/virtio_pci.h
> > > @@ -166,6 +166,13 @@ struct virtio_pci_common_cfg {
> > >       __le32 queue_used_hi;           /* read-write */
> > >  };
> > >
> > > +struct virtio_pci_common_cfg_notify {
> > > +     struct virtio_pci_common_cfg cfg;
> > > +
> > > +     __le16 queue_notify_data;       /* read-write */
> > > +     __le16 padding;
> > > +};
> > > +
> > >  /* Fields in VIRTIO_PCI_CAP_PCI_CFG: */
> > >  struct virtio_pci_cfg_cap {
> > >       struct virtio_pci_cap cap;
> > > --
> > > 2.31.0
> >

