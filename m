Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BED7101194
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 04:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbfKSDI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 22:08:59 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:37972 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727018AbfKSDI7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 22:08:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=tfQMF/ImpigZRzGAkXKTeqPCcjxpDrsHo/JYishAbN4=; b=jjK+AcYBafpxdbSm76WElPASc
        5CL9L0xascrqnfvofR66yVADq8Ci80s+J8maSI+Ak8l49pefsLqqMXDUBYjwS3B4VZs+YVHs3BxyH
        JasoWsw0ghlA2XGhw1Pq8hh7suMahQ7N3SJamv3PHLA7t8rRH4eUm+PtMnF+B900N4IILc0DGr2yN
        K2gPxTWEBGydGvq1hQWDlVDkI3x+FaW8tSvnPZYa2CU8/idN3BmT04Kij6nNIvtKqVnN5OLDus47o
        OO79yzaw2GEXUVu5+mpq/MMz0CMASJ9Vr615acYcx8ExboR1jfjxct8BRuSrJyPRGM7/130hGNsgw
        wV30nRGcw==;
Received: from [2601:1c0:6280:3f0::5a22]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iWtsh-0007Zo-MQ; Tue, 19 Nov 2019 03:08:43 +0000
Subject: Re: [PATCH V13 1/6] mdev: make mdev bus agnostic
To:     Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, kwankhede@nvidia.com,
        alex.williamson@redhat.com, mst@redhat.com, tiwei.bie@intel.com,
        gregkh@linuxfoundation.org, jgg@mellanox.com
Cc:     netdev@vger.kernel.org, cohuck@redhat.com,
        maxime.coquelin@redhat.com, cunming.liang@intel.com,
        zhihong.wang@intel.com, rob.miller@broadcom.com,
        xiao.w.wang@intel.com, haotian.wang@sifive.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com,
        jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com,
        rodrigo.vivi@intel.com, airlied@linux.ie, daniel@ffwll.ch,
        farman@linux.ibm.com, pasic@linux.ibm.com, sebott@linux.ibm.com,
        oberpar@linux.ibm.com, heiko.carstens@de.ibm.com,
        gor@linux.ibm.com, borntraeger@de.ibm.com, akrowiak@linux.ibm.com,
        freude@linux.ibm.com, lingshan.zhu@intel.com, eperezma@redhat.com,
        lulu@redhat.com, parav@mellanox.com,
        christophe.de.dinechin@gmail.com, kevin.tian@intel.com,
        stefanha@redhat.com, hch@infradead.org, aadam@redhat.com,
        jakub.kicinski@netronome.com, jiri@mellanox.com,
        jeffrey.t.kirsher@intel.com
References: <20191118105923.7991-1-jasowang@redhat.com>
 <20191118105923.7991-2-jasowang@redhat.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <61f6a20c-3492-4144-9c7c-f62200718853@infradead.org>
Date:   Mon, 18 Nov 2019 19:08:41 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191118105923.7991-2-jasowang@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/18/19 2:59 AM, Jason Wang wrote:
> diff --git a/drivers/vfio/mdev/Kconfig b/drivers/vfio/mdev/Kconfig
> index 5da27f2100f9..2e07ca915a96 100644
> --- a/drivers/vfio/mdev/Kconfig
> +++ b/drivers/vfio/mdev/Kconfig
> @@ -1,15 +1,24 @@
> -# SPDX-License-Identifier: GPL-2.0-only
>  
> -config VFIO_MDEV
> +config MDEV
>  	tristate "Mediated device driver framework"
> -	depends on VFIO
>  	default n
>  	help
>  	  Provides a framework to virtualize devices.
> -	  See Documentation/driver-api/vfio-mediated-device.rst for more details.
>  
>  	  If you don't know what do here, say N.
>  

Hi,

> +config VFIO_MDEV
> +	tristate "VFIO Mediated device driver"
> +        depends on VFIO && MDEV
> +        default n

The depends and default lines should be indented with tab, not spaces.

> +	help
> +	  Proivdes a mediated BUS for userspace driver through VFIO

	  Provides

> +	  framework. See Documentation/vfio-mediated-device.txt for
> +	  more details.
> +
> +	  If you don't know what do here, say N.
> +
> +
>  config VFIO_MDEV_DEVICE
>  	tristate "VFIO driver for Mediated devices"
>  	depends on VFIO && VFIO_MDEV


-- 
~Randy

