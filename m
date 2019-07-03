Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B75AC5EBAB
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 20:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727259AbfGCScK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 14:32:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54056 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725933AbfGCScK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 14:32:10 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B5D31307D846;
        Wed,  3 Jul 2019 18:32:04 +0000 (UTC)
Received: from x1.home (ovpn-116-83.phx2.redhat.com [10.3.116.83])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1818F83085;
        Wed,  3 Jul 2019 18:31:58 +0000 (UTC)
Date:   Wed, 3 Jul 2019 12:31:57 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Tiwei Bie <tiwei.bie@intel.com>
Cc:     mst@redhat.com, jasowang@redhat.com, maxime.coquelin@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        dan.daly@intel.com, cunming.liang@intel.com, zhihong.wang@intel.com
Subject: Re: [RFC v2] vhost: introduce mdev based hardware vhost backend
Message-ID: <20190703123157.2452bf95@x1.home>
In-Reply-To: <20190703091339.1847-1-tiwei.bie@intel.com>
References: <20190703091339.1847-1-tiwei.bie@intel.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Wed, 03 Jul 2019 18:32:09 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  3 Jul 2019 17:13:39 +0800
Tiwei Bie <tiwei.bie@intel.com> wrote:
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index 8f10748dac79..6c5718ab7eeb 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -201,6 +201,7 @@ struct vfio_device_info {
>  #define VFIO_DEVICE_FLAGS_AMBA  (1 << 3)	/* vfio-amba device */
>  #define VFIO_DEVICE_FLAGS_CCW	(1 << 4)	/* vfio-ccw device */
>  #define VFIO_DEVICE_FLAGS_AP	(1 << 5)	/* vfio-ap device */
> +#define VFIO_DEVICE_FLAGS_VHOST	(1 << 6)	/* vfio-vhost device */
>  	__u32	num_regions;	/* Max region index + 1 */
>  	__u32	num_irqs;	/* Max IRQ index + 1 */
>  };
> @@ -217,6 +218,7 @@ struct vfio_device_info {
>  #define VFIO_DEVICE_API_AMBA_STRING		"vfio-amba"
>  #define VFIO_DEVICE_API_CCW_STRING		"vfio-ccw"
>  #define VFIO_DEVICE_API_AP_STRING		"vfio-ap"
> +#define VFIO_DEVICE_API_VHOST_STRING		"vfio-vhost"
>  
>  /**
>   * VFIO_DEVICE_GET_REGION_INFO - _IOWR(VFIO_TYPE, VFIO_BASE + 8,
> @@ -573,6 +575,23 @@ enum {
>  	VFIO_CCW_NUM_IRQS
>  };
>  
> +/*
> + * The vfio-vhost bus driver makes use of the following fixed region and
> + * IRQ index mapping. Unimplemented regions return a size of zero.
> + * Unimplemented IRQ types return a count of zero.
> + */
> +
> +enum {
> +	VFIO_VHOST_CONFIG_REGION_INDEX,
> +	VFIO_VHOST_NOTIFY_REGION_INDEX,
> +	VFIO_VHOST_NUM_REGIONS
> +};
> +
> +enum {
> +	VFIO_VHOST_VQ_IRQ_INDEX,
> +	VFIO_VHOST_NUM_IRQS
> +};
> +

Note that the vfio API has evolved a bit since vfio-pci started this
way, with fixed indexes for pre-defined region types.  We now support
device specific regions which can be identified by a capability within
the REGION_INFO ioctl return data.  This allows a bit more flexibility,
at the cost of complexity, but the infrastructure already exists in
kernel and QEMU to make it relatively easy.  I think we'll have the
same support for interrupts soon too.  If you continue to pursue the
vfio-vhost direction you might want to consider these before committing
to fixed indexes.  Thanks,

Alex
