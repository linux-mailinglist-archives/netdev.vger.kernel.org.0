Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10F506D1934
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 10:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbjCaIBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 04:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231435AbjCaIBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 04:01:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2252A1B7D0
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 01:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680249630;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M2zRQCJfE4IfmCVgFP+fSUH3fGzboBASzjg7r7jVyXI=;
        b=ArL+BpqyyVxQDxH2XMpzwoT1X/djrYZKILsYYpnS49tRfZh8ldrJQsuJWb+1Oh18e0aesl
        r07PjFSdZGp2ZiHhoZeoqGYqj2fBOfkThYNPMJcm+/oBZ6+RVq2lR84gYyX7rlu7/6utwi
        /Y8XsiJK6A5mgeFpt9APzOzh5X5JTR0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-504-etQmhLSNN9SPfwmNyDKyLA-1; Fri, 31 Mar 2023 04:00:29 -0400
X-MC-Unique: etQmhLSNN9SPfwmNyDKyLA-1
Received: by mail-wm1-f71.google.com with SMTP id bi7-20020a05600c3d8700b003edecc610abso11627908wmb.7
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 01:00:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680249627;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M2zRQCJfE4IfmCVgFP+fSUH3fGzboBASzjg7r7jVyXI=;
        b=zjOTOrkAVqm524TInm9kgBsi8V5ac164A/IZhSTBrl5UlvQGa67V7CnnRzkyGu7fP4
         WhAW9H4v4/lKGiv1288jO0KgPDorlWnlkkBDEtI8UX3LtZn8RE3I+Mp2MvHf1MAV3/yP
         BNU41o+KZGcNzYpAGOpTnM//JFN4WHF3G85IhjyvU0ulhQeFXLUHr+Axb+n4lyETD1mW
         E+VX8TDDx11G3dMFjIyidPBFBsNhkcHv/oqwjQLKKrG5DksJ2PmR0ihbzZq16h1eK06R
         fX9b0eDnQa4W5pavGiPNJO5sttgtxtu6z8RfHOKdUdmQQnYDqA4lcveZgjhKPwVMagII
         Xz6Q==
X-Gm-Message-State: AAQBX9cl0Z9/tTONWI66TISlXUGSQXNTLBwgPr4c6G4m2BFtd3rAxbN6
        xid7hxKIYdslyFRKvH3bNVktnh1Lp6jq5iCZ3dyJzNd22vTNP00k7FWxKB88ImXqNxlLXDCMUYo
        eHNze72tnp3egq+FSiCsmiVyF
X-Received: by 2002:adf:e70c:0:b0:2ce:9f35:59c7 with SMTP id c12-20020adfe70c000000b002ce9f3559c7mr17844651wrm.45.1680249627455;
        Fri, 31 Mar 2023 01:00:27 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZYg1o6rqxhuN/GDlXyBevUxypRmEZ8q6c+KByR/Zvjl+kNcSKPYKcRt2PJxPmhUH9Buxct8w==
X-Received: by 2002:adf:e70c:0:b0:2ce:9f35:59c7 with SMTP id c12-20020adfe70c000000b002ce9f3559c7mr17844624wrm.45.1680249627100;
        Fri, 31 Mar 2023 01:00:27 -0700 (PDT)
Received: from redhat.com ([2.52.159.107])
        by smtp.gmail.com with ESMTPSA id y11-20020adfd08b000000b002c55b0e6ef1sm1520733wrh.4.2023.03.31.01.00.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 01:00:26 -0700 (PDT)
Date:   Fri, 31 Mar 2023 04:00:22 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        virtualization@lists.linux-foundation.org,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, bpf@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 00/16] virtio-net: split virtio-net.c
Message-ID: <20230331035942-mutt-send-email-mst@kernel.org>
References: <20230328092847.91643-1-xuanzhuo@linux.alibaba.com>
 <20230330015412-mutt-send-email-mst@kernel.org>
 <1680247317.9193828-3-xuanzhuo@linux.alibaba.com>
 <CACGkMEt2M3zaytjOmhTuSx6wnerZBrVoQxgbUuAv0WmUu50Hiw@mail.gmail.com>
 <1680248880.8897254-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1680248880.8897254-1-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 03:48:00PM +0800, Xuan Zhuo wrote:
> On Fri, 31 Mar 2023 15:35:14 +0800, Jason Wang <jasowang@redhat.com> wrote:
> > On Fri, Mar 31, 2023 at 3:31 PM Xuan Zhuo <xuanzhuo@linux.alibaba.com> wrote:
> > >
> > > On Thu, 30 Mar 2023 02:17:43 -0400, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > > > On Tue, Mar 28, 2023 at 05:28:31PM +0800, Xuan Zhuo wrote:
> > > > > Considering the complexity of virtio-net.c and the new features we want
> > > > > to add, it is time to split virtio-net.c into multiple independent
> > > > > module files.
> > > > >
> > > > > This is beneficial to the maintenance and adding new functions.
> > > > >
> > > > > And AF_XDP support will be added later, then a separate xsk.c file will
> > > > > be added.
> > > > >
> > > > > This patchset split virtio-net.c into these parts:
> > > > >
> > > > > * virtnet.c:         virtio net device ops (napi, tx, rx, device ops, ...)
> > > > > * virtnet_common.c:  virtio net common code
> > > > > * virtnet_ethtool.c: virtio net ethtool callbacks
> > > > > * virtnet_ctrl.c:    virtio net ctrl queue command APIs
> > > > > * virtnet_virtio.c:  virtio net virtio callbacks/ops (driver register, virtio probe, virtio free, ...)
> > > > >
> > > > > Please review.
> > > > >
> > > > > Thanks.
> > > >
> > > >
> > > > I don't feel this is an improvement as presented, will need more work
> > > > to make code placement more logical.
> > >
> > > Yes, this does need some time and energy. But I think this always need to do,
> > > just when to do it. I think it is currently an opportunity.
> > >
> > >
> > > >
> > > > For example where do I find code to update rq stats?
> > > > Rx data path should be virtnet.c?
> > > > No it's in virtnet_ethtool.c because rq stats can be
> > > > accessed by ethtool.
> > >
> > > That's what I do.
> > >
> > > > A bunch of stuff seems to be in headers just because of technicalities.
> > > > virtio common seems to be a dumping ground with no guiding principle at
> > > > all.
> > >
> > > Yes, I agree, with the development of time, common will indeed become a dumping
> > > group. This is something we should pay attention to after this.
> > >
> > >
> > > > drivers/net/virtio/virtnet_virtio.c is weird with
> > > > virt repeated three times in the path.
> > >
> > > Any good idea.
> > >
> > > >
> > > > These things only get murkier with time, at the point of reorg
> > > > I would expect very logical placement, since
> > > > without clear guiding rule finding where something is becomes harder but
> > > > more importantly we'll now get endless heartburn about where does each new
> > > > function go.
> > > >
> > > >
> > > > The reorg is unfortunately not free - for example git log --follow will
> > > > no longer easily match virtio because --follow works with exactly one
> > > > path.
> > >
> > > One day we will face this problem.
> > >
> > > > It's now also extra work to keep headers self-consistent.
> > >
> > > Can we make it simpler, first complete the split.
> > >
> > >
> > > > So it better be a big improvement to be worth it.
> > >
> > >
> > > Or about split, do you have any better thoughts? Or do you think we have always
> > > been like this and make Virtio-Net more and more complicated?
> >
> > My feeling is that maybe it's worth it to start using a separate file
> > for xsk support.
> 
> I agree.
> 
> @Michael at this point, what is your thought?
> 
> 
> Thanks.
> 

I am fine with either adding just xsk in a new file or even
just adding in same file working on a split later.


> >
> > Thanks
> >
> > >
> > >
> > > Thanks.
> > >
> > > >
> > > >
> > > >
> > > >
> > > > > Xuan Zhuo (16):
> > > > >   virtio_net: add a separate directory for virtio-net
> > > > >   virtio_net: move struct to header file
> > > > >   virtio_net: add prefix to the struct inside header file
> > > > >   virtio_net: separating cpu-related funs
> > > > >   virtio_net: separate virtnet_ctrl_set_queues()
> > > > >   virtio_net: separate virtnet_ctrl_set_mac_address()
> > > > >   virtio_net: remove lock from virtnet_ack_link_announce()
> > > > >   virtio_net: separating the APIs of cq
> > > > >   virtio_net: introduce virtnet_rq_update_stats()
> > > > >   virtio_net: separating the funcs of ethtool
> > > > >   virtio_net: introduce virtnet_dev_rx_queue_group()
> > > > >   virtio_net: introduce virtnet_get_netdev()
> > > > >   virtio_net: prepare for virtio
> > > > >   virtio_net: move virtnet_[en/dis]able_delayed_refill to header file
> > > > >   virtio_net: add APIs to register/unregister virtio driver
> > > > >   virtio_net: separating the virtio code
> > > > >
> > > > >  MAINTAINERS                                   |    2 +-
> > > > >  drivers/net/Kconfig                           |    8 +-
> > > > >  drivers/net/Makefile                          |    2 +-
> > > > >  drivers/net/virtio/Kconfig                    |   11 +
> > > > >  drivers/net/virtio/Makefile                   |   10 +
> > > > >  .../net/{virtio_net.c => virtio/virtnet.c}    | 2368 ++---------------
> > > > >  drivers/net/virtio/virtnet.h                  |  213 ++
> > > > >  drivers/net/virtio/virtnet_common.c           |  138 +
> > > > >  drivers/net/virtio/virtnet_common.h           |   14 +
> > > > >  drivers/net/virtio/virtnet_ctrl.c             |  272 ++
> > > > >  drivers/net/virtio/virtnet_ctrl.h             |   45 +
> > > > >  drivers/net/virtio/virtnet_ethtool.c          |  578 ++++
> > > > >  drivers/net/virtio/virtnet_ethtool.h          |    8 +
> > > > >  drivers/net/virtio/virtnet_virtio.c           |  880 ++++++
> > > > >  drivers/net/virtio/virtnet_virtio.h           |    8 +
> > > > >  15 files changed, 2366 insertions(+), 2191 deletions(-)
> > > > >  create mode 100644 drivers/net/virtio/Kconfig
> > > > >  create mode 100644 drivers/net/virtio/Makefile
> > > > >  rename drivers/net/{virtio_net.c => virtio/virtnet.c} (50%)
> > > > >  create mode 100644 drivers/net/virtio/virtnet.h
> > > > >  create mode 100644 drivers/net/virtio/virtnet_common.c
> > > > >  create mode 100644 drivers/net/virtio/virtnet_common.h
> > > > >  create mode 100644 drivers/net/virtio/virtnet_ctrl.c
> > > > >  create mode 100644 drivers/net/virtio/virtnet_ctrl.h
> > > > >  create mode 100644 drivers/net/virtio/virtnet_ethtool.c
> > > > >  create mode 100644 drivers/net/virtio/virtnet_ethtool.h
> > > > >  create mode 100644 drivers/net/virtio/virtnet_virtio.c
> > > > >  create mode 100644 drivers/net/virtio/virtnet_virtio.h
> > > > >
> > > > > --
> > > > > 2.32.0.3.g01195cf9f
> > > >
> > >
> >
> > _______________________________________________
> > Virtualization mailing list
> > Virtualization@lists.linux-foundation.org
> > https://lists.linuxfoundation.org/mailman/listinfo/virtualization

