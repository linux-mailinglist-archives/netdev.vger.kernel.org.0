Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 923E25A5970
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 04:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbiH3CbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 22:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbiH3CbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 22:31:22 -0400
Received: from out30-44.freemail.mail.aliyun.com (out30-44.freemail.mail.aliyun.com [115.124.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E5A158B4D
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 19:31:21 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R571e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0VNij1ik_1661826675;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VNij1ik_1661826675)
          by smtp.aliyun-inc.com;
          Tue, 30 Aug 2022 10:31:16 +0800
Message-ID: <1661826662.4733112-2-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH v3 1/2] virtio-net: introduce and use helper function for guest gso support checks
Date:   Tue, 30 Aug 2022 10:31:02 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     Gavin Li <gavinl@nvidia.com>
Cc:     <gavi@nvidia.com>, <parav@nvidia.com>,
        <stephen@networkplumber.org>, <davem@davemloft.net>,
        <jesse.brandeburg@intel.com>, <alexander.h.duyck@intel.com>,
        <kuba@kernel.org>, <sridhar.samudrala@intel.com>,
        <jasowang@redhat.com>, <loseweigh@gmail.com>,
        <netdev@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <virtio-dev@lists.oasis-open.org>, <mst@redhat.com>
References: <20220830022634.69686-1-gavinl@nvidia.com>
 <20220830022634.69686-2-gavinl@nvidia.com>
In-Reply-To: <20220830022634.69686-2-gavinl@nvidia.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 30 Aug 2022 05:26:33 +0300, Gavin Li <gavinl@nvidia.com> wrote:
> Probe routine is already several hundred lines.
> Use helper function for guest gso support check.
>
> Signed-off-by: Gavin Li <gavinl@nvidia.com>
> Reviewed-by: Gavi Teitz <gavi@nvidia.com>
> Reviewed-by: Parav Pandit <parav@nvidia.com>


Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>

> ---
> changelog:
> v1->v2
> - Add new patch
> ---
>  drivers/net/virtio_net.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 9cce7dec7366..e1904877d461 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -3682,6 +3682,14 @@ static int virtnet_validate(struct virtio_device *vdev)
>  	return 0;
>  }
>
> +static bool virtnet_check_guest_gso(const struct virtnet_info *vi)
> +{
> +	return (virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO4) ||
> +		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_TSO6) ||
> +		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_ECN) ||
> +		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_UFO));
> +}
> +
>  static int virtnet_probe(struct virtio_device *vdev)
>  {
>  	int i, err = -ENOMEM;
> @@ -3777,10 +3785,7 @@ static int virtnet_probe(struct virtio_device *vdev)
>  	spin_lock_init(&vi->refill_lock);
>
>  	/* If we can receive ANY GSO packets, we must allocate large ones. */
> -	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
> -	    virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO6) ||
> -	    virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_ECN) ||
> -	    virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_UFO))
> +	if (virtnet_check_guest_gso(vi))
>  		vi->big_packets = true;
>
>  	if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF))
> --
> 2.31.1
>
