Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8C3595315
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 08:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbiHPGyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 02:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231153AbiHPGyG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 02:54:06 -0400
Received: from out30-42.freemail.mail.aliyun.com (out30-42.freemail.mail.aliyun.com [115.124.30.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE6E2075B7;
        Mon, 15 Aug 2022 20:09:13 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R361e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0VMOG.Le_1660619347;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VMOG.Le_1660619347)
          by smtp.aliyun-inc.com;
          Tue, 16 Aug 2022 11:09:08 +0800
Message-ID: <1660619231.7656944-2-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH v3 0/5] virtio: drop sizing vqs during init
Date:   Tue, 16 Aug 2022 11:07:11 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
References: <20220815215938.154999-1-mst@redhat.com>
In-Reply-To: <20220815215938.154999-1-mst@redhat.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Series:
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>

There is also a commit, I just submitted, about the problem you pointed
out about using container_of(). Can we submit together?


On Mon, 15 Aug 2022 18:00:21 -0400, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> Reporting after I botched up v2 posting. Sorry about the noise.
>
> Supplying size during init does not work for all transports.
> In fact for legacy pci doing that causes a memory
> corruption which was reported on Google Cloud.
>
> We might get away with changing size to size_hint so it's
> safe to ignore and then fixing legacy to ignore the hint.
>
> But the benefit is unclear in any case, so let's revert for now.
> Any new version will have to come with
> - documentation of performance gains
> - performance testing showing existing workflows
>   are not harmed materially. especially ones with
>   bursty traffic
> - report of testing on legacy devices
>
>
> Huge shout out to Andres Freund for the effort spent reproducing and
> debugging!  Thanks to Guenter Roeck for help with testing!
>
>
> changes from v2
> 	drop unrelated patches
> changes from v1
> 	revert the ring size api, it's unused now
>
> Michael S. Tsirkin (5):
>   virtio_net: Revert "virtio_net: set the default max ring size by
>     find_vqs()"
>   virtio: Revert "virtio: add helper virtio_find_vqs_ctx_size()"
>   virtio-mmio: Revert "virtio_mmio: support the arg sizes of find_vqs()"
>   virtio_pci: Revert "virtio_pci: support the arg sizes of find_vqs()"
>   virtio: Revert "virtio: find_vqs() add arg sizes"
>
>  arch/um/drivers/virtio_uml.c             |  2 +-
>  drivers/net/virtio_net.c                 | 42 +++---------------------
>  drivers/platform/mellanox/mlxbf-tmfifo.c |  1 -
>  drivers/remoteproc/remoteproc_virtio.c   |  1 -
>  drivers/s390/virtio/virtio_ccw.c         |  1 -
>  drivers/virtio/virtio_mmio.c             |  9 ++---
>  drivers/virtio/virtio_pci_common.c       | 20 +++++------
>  drivers/virtio/virtio_pci_common.h       |  3 +-
>  drivers/virtio/virtio_pci_legacy.c       |  6 +---
>  drivers/virtio/virtio_pci_modern.c       | 17 +++-------
>  drivers/virtio/virtio_vdpa.c             |  1 -
>  include/linux/virtio_config.h            | 26 +++------------
>  12 files changed, 28 insertions(+), 101 deletions(-)
>
> --
> MST
>
