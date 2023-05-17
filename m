Return-Path: <netdev+bounces-3145-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0262F705C74
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 03:32:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A22C01C20C72
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 01:32:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A5EF17CD;
	Wed, 17 May 2023 01:32:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EE9917C8
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 01:32:52 +0000 (UTC)
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B0C3A80;
	Tue, 16 May 2023 18:32:50 -0700 (PDT)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0ViqT6U4_1684287167;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0ViqT6U4_1684287167)
          by smtp.aliyun-inc.com;
          Wed, 17 May 2023 09:32:48 +0800
Message-ID: <1684287159.5055063-1-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH v1] virtio_pci: Optimize virtio_pci_device structure size
Date: Wed, 17 May 2023 09:32:39 +0800
From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To: Feng Liu <feliu@nvidia.com>
Cc: Jason Wang <jasowang@redhat.com>,
 "Michael S . Tsirkin" <mst@redhat.com>,
 Bodong Wang <bodong@nvidia.com>,
 Feng Liu <feliu@nvidia.com>,
 Jiri Pirko <jiri@nvidia.com>,
 <virtualization@lists.linux-foundation.org>,
 <netdev@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
References: <20230516135446.16266-1-feliu@nvidia.com>
In-Reply-To: <20230516135446.16266-1-feliu@nvidia.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,
	USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

On Tue, 16 May 2023 09:54:46 -0400, Feng Liu <feliu@nvidia.com> wrote:
> Improve the size of the virtio_pci_device structure, which is commonly
> used to represent a virtio PCI device. A given virtio PCI device can
> either of legacy type or modern type, with the
> struct virtio_pci_legacy_device occupying 32 bytes and the
> struct virtio_pci_modern_device occupying 88 bytes. Make them a union,
> thereby save 32 bytes of memory as shown by the pahole tool. This
> improvement is particularly beneficial when dealing with numerous
> devices, as it helps conserve memory resources.
>
> Before the modification, pahole tool reported the following:
> struct virtio_pci_device {
> [...]
>         struct virtio_pci_legacy_device ldev;            /*   824    32 */
>         /* --- cacheline 13 boundary (832 bytes) was 24 bytes ago --- */
>         struct virtio_pci_modern_device mdev;            /*   856    88 */
>
>         /* XXX last struct has 4 bytes of padding */
> [...]
>         /* size: 1056, cachelines: 17, members: 19 */
> [...]
> };
>
> After the modification, pahole tool reported the following:
> struct virtio_pci_device {
> [...]
>         union {
>                 struct virtio_pci_legacy_device ldev;    /*   824    32 */
>                 struct virtio_pci_modern_device mdev;    /*   824    88 */
>         };                                               /*   824    88 */
> [...]
> 	/* size: 1024, cachelines: 16, members: 18 */
> [...]
> };
>
> Signed-off-by: Feng Liu <feliu@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>

Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>

Thanks.

> ---
>  drivers/virtio/virtio_pci_common.h | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/virtio/virtio_pci_common.h b/drivers/virtio/virtio_pci_common.h
> index 23112d84218f..4b773bd7c58c 100644
> --- a/drivers/virtio/virtio_pci_common.h
> +++ b/drivers/virtio/virtio_pci_common.h
> @@ -45,9 +45,10 @@ struct virtio_pci_vq_info {
>  struct virtio_pci_device {
>  	struct virtio_device vdev;
>  	struct pci_dev *pci_dev;
> -	struct virtio_pci_legacy_device ldev;
> -	struct virtio_pci_modern_device mdev;
> -
> +	union {
> +		struct virtio_pci_legacy_device ldev;
> +		struct virtio_pci_modern_device mdev;
> +	};
>  	bool is_legacy;
>
>  	/* Where to read and clear interrupt */
> --
> 2.37.1 (Apple Git-137.1)
>

