Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F20E01B1BDD
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 04:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgDUC1m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 22:27:42 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54190 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725989AbgDUC1m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 22:27:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587436060;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JIuPfMXVgjCpv9MlxvGB/R8vQTIoKax5wzQ+5UKEudw=;
        b=dEuz6ydieXEVXKVBX3WWTaX3/srPn3dvZqzlmy1uPRXoT9oRHz6sPapBrt9dAMDGhT8h46
        xI7jJ2YGnc8vVjco4q9nSeNZcCgEE9x0kXb+9dHWCYlG2gzN8Acia+7mqc70dVpqzAjJrn
        S2jUBn667a6wIQBGgUtbzg0dtfZLyPk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-439-aWoUFW9gO0imRlDrPR6qbQ-1; Mon, 20 Apr 2020 22:27:38 -0400
X-MC-Unique: aWoUFW9gO0imRlDrPR6qbQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9BE05107ACC4;
        Tue, 21 Apr 2020 02:27:36 +0000 (UTC)
Received: from [10.72.12.74] (ovpn-12-74.pek2.redhat.com [10.72.12.74])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9CBF85C1B2;
        Tue, 21 Apr 2020 02:27:29 +0000 (UTC)
Subject: Re: [PATCH v4] vhost: disable for OABI
To:     "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Richard Earnshaw <Richard.Earnshaw@arm.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
References: <20200420143229.245488-1-mst@redhat.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <9ccae969-17ec-787c-e6ac-a88222bd1759@redhat.com>
Date:   Tue, 21 Apr 2020 10:27:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200420143229.245488-1-mst@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/4/20 =E4=B8=8B=E5=8D=8810:34, Michael S. Tsirkin wrote:
> vhost is currently broken on the some ARM configs.
>
> The reason is that the ring element addresses are passed between
> components with different alignments assumptions. Thus, if
> guest selects a pointer and host then gets and dereferences
> it, then alignment assumed by the host's compiler might be
> greater than the actual alignment of the pointer.
> compiler on the host from assuming pointer is aligned.
>
> This actually triggers on ARM with -mabi=3Dapcs-gnu - which is a
> deprecated configuration. With this OABI, compiler assumes that
> all structures are 4 byte aligned - which is stronger than
> virtio guarantees for available and used rings, which are
> merely 2 bytes. Thus a guest without -mabi=3Dapcs-gnu running
> on top of host with -mabi=3Dapcs-gnu will be broken.
>
> The correct fix is to force alignment of structures - however
> that is an intrusive fix that's best deferred until the next release.
>
> We didn't previously support such ancient systems at all - this surface=
d
> after vdpa support prompted removing dependency of vhost on
> VIRTULIZATION. So for now, let's just add something along the lines of
>
> 	depends on !ARM || AEABI
>
> to the virtio Kconfig declaration, and add a comment that it has to do
> with struct member alignment.
>
> Note: we can't make VHOST and VHOST_RING themselves have
> a dependency since these are selected. Add a new symbol for that.
>
> We should be able to drop this dependency down the road.
>
> Fixes: 20c384f1ea1a0bc7 ("vhost: refine vhost and vringh kconfig")
> Suggested-by: Ard Biesheuvel <ardb@kernel.org>
> Suggested-by: Richard Earnshaw <Richard.Earnshaw@arm.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>
> changes from v3:
> 	update commit log clarifying the motivation and that
> 	it's a temporary fix.
>
> 	suggested by Christoph Hellwig
>
>   drivers/misc/mic/Kconfig |  2 +-
>   drivers/net/caif/Kconfig |  2 +-
>   drivers/vdpa/Kconfig     |  2 +-
>   drivers/vhost/Kconfig    | 17 +++++++++++++----
>   4 files changed, 16 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/misc/mic/Kconfig b/drivers/misc/mic/Kconfig
> index 8f201d019f5a..3bfe72c59864 100644
> --- a/drivers/misc/mic/Kconfig
> +++ b/drivers/misc/mic/Kconfig
> @@ -116,7 +116,7 @@ config MIC_COSM
>  =20
>   config VOP
>   	tristate "VOP Driver"
> -	depends on VOP_BUS
> +	depends on VOP_BUS && VHOST_DPN
>   	select VHOST_RING
>   	select VIRTIO
>   	help
> diff --git a/drivers/net/caif/Kconfig b/drivers/net/caif/Kconfig
> index 9db0570c5beb..661c25eb1c46 100644
> --- a/drivers/net/caif/Kconfig
> +++ b/drivers/net/caif/Kconfig
> @@ -50,7 +50,7 @@ config CAIF_HSI
>  =20
>   config CAIF_VIRTIO
>   	tristate "CAIF virtio transport driver"
> -	depends on CAIF && HAS_DMA
> +	depends on CAIF && HAS_DMA && VHOST_DPN
>   	select VHOST_RING
>   	select VIRTIO
>   	select GENERIC_ALLOCATOR
> diff --git a/drivers/vdpa/Kconfig b/drivers/vdpa/Kconfig
> index 3e1ceb8e9f2b..e8140065c8a5 100644
> --- a/drivers/vdpa/Kconfig
> +++ b/drivers/vdpa/Kconfig
> @@ -10,7 +10,7 @@ if VDPA
>  =20
>   config VDPA_SIM
>   	tristate "vDPA device simulator"
> -	depends on RUNTIME_TESTING_MENU && HAS_DMA
> +	depends on RUNTIME_TESTING_MENU && HAS_DMA && VHOST_DPN
>   	select VHOST_RING
>   	default n
>   	help
> diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
> index 2c75d164b827..c4f273793595 100644
> --- a/drivers/vhost/Kconfig
> +++ b/drivers/vhost/Kconfig
> @@ -13,6 +13,15 @@ config VHOST_RING
>   	  This option is selected by any driver which needs to access
>   	  the host side of a virtio ring.
>  =20
> +config VHOST_DPN
> +	bool
> +	depends on !ARM || AEABI
> +	default y
> +	help
> +	  Anything selecting VHOST or VHOST_RING must depend on VHOST_DPN.
> +	  This excludes the deprecated ARM ABI since that forces a 4 byte
> +	  alignment on all structs - incompatible with virtio spec requiremen=
ts.
> +
>   config VHOST
>   	tristate
>   	select VHOST_IOTLB
> @@ -28,7 +37,7 @@ if VHOST_MENU
>  =20
>   config VHOST_NET
>   	tristate "Host kernel accelerator for virtio net"
> -	depends on NET && EVENTFD && (TUN || !TUN) && (TAP || !TAP)
> +	depends on NET && EVENTFD && (TUN || !TUN) && (TAP || !TAP) && VHOST_=
DPN
>   	select VHOST
>   	---help---
>   	  This kernel module can be loaded in host kernel to accelerate
> @@ -40,7 +49,7 @@ config VHOST_NET
>  =20
>   config VHOST_SCSI
>   	tristate "VHOST_SCSI TCM fabric driver"
> -	depends on TARGET_CORE && EVENTFD
> +	depends on TARGET_CORE && EVENTFD && VHOST_DPN
>   	select VHOST
>   	default n
>   	---help---
> @@ -49,7 +58,7 @@ config VHOST_SCSI
>  =20
>   config VHOST_VSOCK
>   	tristate "vhost virtio-vsock driver"
> -	depends on VSOCKETS && EVENTFD
> +	depends on VSOCKETS && EVENTFD && VHOST_DPN
>   	select VHOST
>   	select VIRTIO_VSOCKETS_COMMON
>   	default n
> @@ -63,7 +72,7 @@ config VHOST_VSOCK
>  =20
>   config VHOST_VDPA
>   	tristate "Vhost driver for vDPA-based backend"
> -	depends on EVENTFD
> +	depends on EVENTFD && VHOST_DPN
>   	select VHOST
>   	depends on VDPA
>   	help


Acked-by: Jason Wang <jasowang@redhat.com>

Thanks

