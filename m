Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC3C96CFB66
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 08:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbjC3GSm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 02:18:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjC3GSi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 02:18:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34DEC2720
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 23:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680157070;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6xBOVpWxCK25mn4qE7KBnQ/szJiPX1gzHnLt3zUuvz0=;
        b=GV1MPYkFfsw8qsREHk4oGncGXP26DjHi4EuRG5W0mibcdssCuW9oooHGXSp5YPzD3l5mg/
        mw0/M0Mhfh2ygkbmKyw6Ogz3O79LHxuV7fWOaf6ep3Lb4ZH7OY3ee2dDEEoDSrSBJQuw5R
        PCWEXdd4f80Fd3MrxRMmicLpnEmfq58=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-377-7UFOTF84N3-ZH9sGLQvvsA-1; Thu, 30 Mar 2023 02:17:48 -0400
X-MC-Unique: 7UFOTF84N3-ZH9sGLQvvsA-1
Received: by mail-wr1-f69.google.com with SMTP id b9-20020a05600018a900b002cfe70737d2so1766260wri.1
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 23:17:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680157067;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6xBOVpWxCK25mn4qE7KBnQ/szJiPX1gzHnLt3zUuvz0=;
        b=UiTRfC2W953YmU5zImPRsFzaxrylk1DcOsQdbJEDHHgHqKfdT2vTxF7Q/98X8EpJH8
         ie6/mCz740MmknTcbPOZh68sUjO2DpJaMoMDrEyR8q+EG9htVFegKQP3W5kUuCRyMQwU
         u6OyXGp8LZcNHaQV+tWe8hYCPXXcR5WLZVUqzZJP7Gp/HOLCgbpKB2dllJp/ZE4HjMkX
         kYKMhOCZNIFDzhZOzK6t/2fxi7pZtctbs5E4ul8YrmRmEs+tiMMgBh+iiF5P1JURUbON
         NsgqxVPxdTgovgUdtbimPCLNsY1CLEfVAnzM3p+K+xf5ljd8Zui3sCChbceY6MWSw6Yr
         SoYw==
X-Gm-Message-State: AAQBX9fz+9YjETeDNcgvD/xzRSEV9Xh3Co2fh+AoiXBauLkaculAwLcj
        zSdAsYzt7xbdv0UyMByKQLNgxSm3HZaluskPh1yAvgIkRZjGkPDzNTJom7JsSdIP4Ju13g7i/Ux
        C+9OsdlVHYCEM7ISp
X-Received: by 2002:adf:e401:0:b0:2d4:896:a204 with SMTP id g1-20020adfe401000000b002d40896a204mr16043746wrm.60.1680157067615;
        Wed, 29 Mar 2023 23:17:47 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZWrzkHbAP6BkiUUe9yyebCiunrV4M5BvT7N+wH2ZkjcjHW/6tNcTYFjDHgUDimgRCyWS3QsQ==
X-Received: by 2002:adf:e401:0:b0:2d4:896:a204 with SMTP id g1-20020adfe401000000b002d40896a204mr16043735wrm.60.1680157067244;
        Wed, 29 Mar 2023 23:17:47 -0700 (PDT)
Received: from redhat.com ([2.52.159.107])
        by smtp.gmail.com with ESMTPSA id p5-20020adfce05000000b002d64fcb362dsm26643606wrn.111.2023.03.29.23.17.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 23:17:46 -0700 (PDT)
Date:   Thu, 30 Mar 2023 02:17:43 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: Re: [PATCH 00/16] virtio-net: split virtio-net.c
Message-ID: <20230330015412-mutt-send-email-mst@kernel.org>
References: <20230328092847.91643-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230328092847.91643-1-xuanzhuo@linux.alibaba.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 28, 2023 at 05:28:31PM +0800, Xuan Zhuo wrote:
> Considering the complexity of virtio-net.c and the new features we want
> to add, it is time to split virtio-net.c into multiple independent
> module files.
> 
> This is beneficial to the maintenance and adding new functions.
> 
> And AF_XDP support will be added later, then a separate xsk.c file will
> be added.
> 
> This patchset split virtio-net.c into these parts:
> 
> * virtnet.c:         virtio net device ops (napi, tx, rx, device ops, ...)
> * virtnet_common.c:  virtio net common code
> * virtnet_ethtool.c: virtio net ethtool callbacks
> * virtnet_ctrl.c:    virtio net ctrl queue command APIs
> * virtnet_virtio.c:  virtio net virtio callbacks/ops (driver register, virtio probe, virtio free, ...)
> 
> Please review.
> 
> Thanks.


I don't feel this is an improvement as presented, will need more work
to make code placement more logical.

For example where do I find code to update rq stats?
Rx data path should be virtnet.c?
No it's in virtnet_ethtool.c because rq stats can be
accessed by ethtool.
A bunch of stuff seems to be in headers just because of technicalities.
virtio common seems to be a dumping ground with no guiding principle at
all.
drivers/net/virtio/virtnet_virtio.c is weird with
virt repeated three times in the path.

These things only get murkier with time, at the point of reorg
I would expect very logical placement, since
without clear guiding rule finding where something is becomes harder but
more importantly we'll now get endless heartburn about where does each new
function go.


The reorg is unfortunately not free - for example git log --follow will
no longer easily match virtio because --follow works with exactly one
path.  It's now also extra work to keep headers self-consistent.
So it better be a big improvement to be worth it.




> Xuan Zhuo (16):
>   virtio_net: add a separate directory for virtio-net
>   virtio_net: move struct to header file
>   virtio_net: add prefix to the struct inside header file
>   virtio_net: separating cpu-related funs
>   virtio_net: separate virtnet_ctrl_set_queues()
>   virtio_net: separate virtnet_ctrl_set_mac_address()
>   virtio_net: remove lock from virtnet_ack_link_announce()
>   virtio_net: separating the APIs of cq
>   virtio_net: introduce virtnet_rq_update_stats()
>   virtio_net: separating the funcs of ethtool
>   virtio_net: introduce virtnet_dev_rx_queue_group()
>   virtio_net: introduce virtnet_get_netdev()
>   virtio_net: prepare for virtio
>   virtio_net: move virtnet_[en/dis]able_delayed_refill to header file
>   virtio_net: add APIs to register/unregister virtio driver
>   virtio_net: separating the virtio code
> 
>  MAINTAINERS                                   |    2 +-
>  drivers/net/Kconfig                           |    8 +-
>  drivers/net/Makefile                          |    2 +-
>  drivers/net/virtio/Kconfig                    |   11 +
>  drivers/net/virtio/Makefile                   |   10 +
>  .../net/{virtio_net.c => virtio/virtnet.c}    | 2368 ++---------------
>  drivers/net/virtio/virtnet.h                  |  213 ++
>  drivers/net/virtio/virtnet_common.c           |  138 +
>  drivers/net/virtio/virtnet_common.h           |   14 +
>  drivers/net/virtio/virtnet_ctrl.c             |  272 ++
>  drivers/net/virtio/virtnet_ctrl.h             |   45 +
>  drivers/net/virtio/virtnet_ethtool.c          |  578 ++++
>  drivers/net/virtio/virtnet_ethtool.h          |    8 +
>  drivers/net/virtio/virtnet_virtio.c           |  880 ++++++
>  drivers/net/virtio/virtnet_virtio.h           |    8 +
>  15 files changed, 2366 insertions(+), 2191 deletions(-)
>  create mode 100644 drivers/net/virtio/Kconfig
>  create mode 100644 drivers/net/virtio/Makefile
>  rename drivers/net/{virtio_net.c => virtio/virtnet.c} (50%)
>  create mode 100644 drivers/net/virtio/virtnet.h
>  create mode 100644 drivers/net/virtio/virtnet_common.c
>  create mode 100644 drivers/net/virtio/virtnet_common.h
>  create mode 100644 drivers/net/virtio/virtnet_ctrl.c
>  create mode 100644 drivers/net/virtio/virtnet_ctrl.h
>  create mode 100644 drivers/net/virtio/virtnet_ethtool.c
>  create mode 100644 drivers/net/virtio/virtnet_ethtool.h
>  create mode 100644 drivers/net/virtio/virtnet_virtio.c
>  create mode 100644 drivers/net/virtio/virtnet_virtio.h
> 
> --
> 2.32.0.3.g01195cf9f

