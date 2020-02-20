Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39374165603
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 05:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727806AbgBTEEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 23:04:22 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:38638 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727370AbgBTEEW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 23:04:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=GfaHd9nmnm5HfXiWFaqqp8qBssAR57L85ioPLwNgMwM=; b=EDi1urqdHU8SFhgPXHjCOBxh3N
        H7Yd8+L9MEo0TQvFhNMXw0UALwLUwW6Mx1G0sT9Qmpgzij4eUeEXceSu7tDZVBVH6YRpXnHz5smt0
        CRzcofXhMBcmUi7JtL7Z4rqh4J60RFydKPypF/Apf044TZbeV5CPq6GinEfySUr1N3bXJX6uou8nS
        RpF9kYvryDuCcRr1N4IA8TmFELdj7+UbWwR9jJshmHdpweXjfLruiNEtlluZ8PI49OanzGzrb/mTC
        HXi5hOFB3FYwP9MD+Fqx5kt5de1yErNw5XhKGPYRGRKQAL09XDTxNGbev7qAGlDLt/Tp481BOzbZV
        5geW1j+A==;
Received: from [2601:1c0:6280:3f0::19c2]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j4d4P-00008B-EK; Thu, 20 Feb 2020 04:04:13 +0000
Subject: Re: [PATCH V3 1/5] vhost: factor out IOTLB
To:     Jason Wang <jasowang@redhat.com>, mst@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     tiwei.bie@intel.com, jgg@mellanox.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        haotian.wang@sifive.com, lingshan.zhu@intel.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        kevin.tian@intel.com, stefanha@redhat.com, hch@infradead.org,
        aadam@redhat.com, jiri@mellanox.com, shahafs@mellanox.com,
        hanand@xilinx.com, mhabets@solarflare.com
References: <20200220035650.7986-1-jasowang@redhat.com>
 <20200220035650.7986-2-jasowang@redhat.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <61d64892-ce77-3e86-acb8-a49679fc0047@infradead.org>
Date:   Wed, 19 Feb 2020 20:04:10 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200220035650.7986-2-jasowang@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/19/20 7:56 PM, Jason Wang wrote:
> This patch factors out IOTLB into a dedicated module in order to be
> reused by other modules like vringh. User may choose to enable the
> automatic retiring by specifying VHOST_IOTLB_FLAG_RETIRE flag to fit
> for the case of vhost device IOTLB implementation.
> 
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  MAINTAINERS                 |   1 +
>  drivers/vhost/Kconfig       |   7 ++
>  drivers/vhost/Makefile      |   2 +
>  drivers/vhost/net.c         |   2 +-
>  drivers/vhost/vhost.c       | 221 +++++++++++-------------------------
>  drivers/vhost/vhost.h       |  36 ++----
>  drivers/vhost/vhost_iotlb.c | 171 ++++++++++++++++++++++++++++
>  include/linux/vhost_iotlb.h |  45 ++++++++
>  8 files changed, 304 insertions(+), 181 deletions(-)
>  create mode 100644 drivers/vhost/vhost_iotlb.c
>  create mode 100644 include/linux/vhost_iotlb.h
> 

Hi,
Sorry if you have gone over this previously:

> diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
> index 3d03ccbd1adc..eef634ff9a6e 100644
> --- a/drivers/vhost/Kconfig
> +++ b/drivers/vhost/Kconfig
> @@ -36,6 +36,7 @@ config VHOST_VSOCK
>  
>  config VHOST
>  	tristate
> +	select VHOST_IOTLB
>  	---help---
>  	  This option is selected by any driver which needs to access
>  	  the core of vhost.
> @@ -54,3 +55,9 @@ config VHOST_CROSS_ENDIAN_LEGACY
>  	  adds some overhead, it is disabled by default.
>  
>  	  If unsure, say "N".
> +
> +config VHOST_IOTLB
> +	tristate
> +	default m

"default m" should not be needed. Just make whatever needs it select it.

> +	help
> +	  Generic IOTLB implementation for vhost and vringh.


-- 
~Randy

