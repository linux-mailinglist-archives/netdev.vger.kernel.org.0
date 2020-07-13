Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAA0521D1AF
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 10:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729128AbgGMI1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 04:27:36 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52742 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725818AbgGMI1e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 04:27:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594628852;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UxdZg1N6R8DqaKbCvSIupj1dKmqOdpoif6br+brtFjA=;
        b=W29OteRViQID5AsAn9QQcjvJ3mrlv4t+MVWm6xj+QbLTb2GKw4AI8hNE4Eh5Bp/YNixxaL
        nLFiI04ylq8CPFQB1cx3xT4tFEijl5MNUCLBNvMmApEIGZB+pVw6/gfmJ1PU8MCEqbEWMB
        Lm5V0Y3Dy7XcNzjtR3cgigsv2tuQJDs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-15-0pN_GoaCNFOBst1aDpKvCQ-1; Mon, 13 Jul 2020 04:27:26 -0400
X-MC-Unique: 0pN_GoaCNFOBst1aDpKvCQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1F2531902EC0;
        Mon, 13 Jul 2020 08:27:25 +0000 (UTC)
Received: from [10.72.13.177] (ovpn-13-177.pek2.redhat.com [10.72.13.177])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F338427DE90;
        Mon, 13 Jul 2020 08:27:14 +0000 (UTC)
Subject: Re: [PATCH 4/7] vDPA: implement IRQ offloading helpers in vDPA core
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com,
        alex.williamson@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com
Cc:     virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, dan.daly@intel.com
References: <1594565366-3195-1-git-send-email-lingshan.zhu@intel.com>
 <1594565366-3195-4-git-send-email-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <6e8b267c-0734-1d9b-d3da-e2e6f44f7847@redhat.com>
Date:   Mon, 13 Jul 2020 16:27:08 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1594565366-3195-4-git-send-email-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/7/12 下午10:49, Zhu Lingshan wrote:
> This commit implements IRQ offloading helpers in vDPA core by
> introducing two couple of functions:
>
> vdpa_alloc_vq_irq() and vdpa_free_vq_irq(): request irq and free
> irq, will setup irq offloading if irq_bypass is enabled.
>
> vdpa_setup_irq() and vdpa_unsetup_irq(): supportive functions,
> will call vhost_vdpa helpers.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>


This patch should go before patch 3.


> ---
>   drivers/vdpa/vdpa.c   | 46 ++++++++++++++++++++++++++++++++++++++++++++++
>   drivers/vhost/Kconfig |  1 +
>   drivers/vhost/vdpa.c  |  2 ++
>   include/linux/vdpa.h  | 11 +++++++++++
>   4 files changed, 60 insertions(+)
>
> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
> index ff6562f..d8eba01 100644
> --- a/drivers/vdpa/vdpa.c
> +++ b/drivers/vdpa/vdpa.c
> @@ -163,6 +163,52 @@ void vdpa_unregister_driver(struct vdpa_driver *drv)
>   }
>   EXPORT_SYMBOL_GPL(vdpa_unregister_driver);
>   
> +static void vdpa_setup_irq(struct vdpa_device *vdev, int qid, int irq)
> +{
> +	struct vdpa_driver *drv = drv_to_vdpa(vdev->dev.driver);
> +
> +#ifdef CONFIG_HAVE_KVM_IRQ_BYPASS


Let's don't do the check here. It's the responsibility of driver to 
decide what it should do.


> +	if (drv->setup_vq_irq)
> +		drv->setup_vq_irq(vdev, qid, irq);
> +#endif
> +}
> +
> +static void vdpa_unsetup_irq(struct vdpa_device *vdev, int qid)
> +{
> +	struct vdpa_driver *drv = drv_to_vdpa(vdev->dev.driver);
> +
> +#ifdef CONFIG_HAVE_KVM_IRQ_BYPASS
> +	if (drv->unsetup_vq_irq)
> +		drv->unsetup_vq_irq(vdev, qid);
> +#endif
> +}
> +
> +int vdpa_alloc_vq_irq(struct device *dev, struct vdpa_device *vdev,
> +		      unsigned int irq, irq_handler_t handler,
> +		      unsigned long irqflags, const char *devname, void *dev_id,
> +		      int qid)
> +{
> +	int ret;
> +
> +	ret = devm_request_irq(dev, irq, handler, irqflags, devname, dev_id);
> +	if (ret)
> +		dev_err(dev, "Failed to request irq for vq %d\n", qid);
> +	else
> +		vdpa_setup_irq(vdev, qid, irq);


I'd like to squash the vdpa_setup_irq logic here.


> +
> +	return ret;
> +
> +}
> +EXPORT_SYMBOL_GPL(vdpa_alloc_vq_irq);
> +
> +void vdpa_free_vq_irq(struct device *dev, struct vdpa_device *vdev, int irq,
> +			 int qid, void *dev_id)
> +{
> +	devm_free_irq(dev, irq, dev_id);
> +	vdpa_unsetup_irq(vdev, qid);
> +}
> +EXPORT_SYMBOL_GPL(vdpa_free_vq_irq);
> +
>   static int vdpa_init(void)
>   {
>   	return bus_register(&vdpa_bus);
> diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig


Let squash the vhost patch into patch 3.


> index d3688c6..587fbae 100644
> --- a/drivers/vhost/Kconfig
> +++ b/drivers/vhost/Kconfig
> @@ -65,6 +65,7 @@ config VHOST_VDPA
>   	tristate "Vhost driver for vDPA-based backend"
>   	depends on EVENTFD
>   	select VHOST
> +	select IRQ_BYPASS_MANAGER
>   	depends on VDPA
>   	help
>   	  This kernel module can be loaded in host kernel to accelerate
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 92683e4..6e25158 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -1020,6 +1020,8 @@ static void vhost_vdpa_remove(struct vdpa_device *vdpa)
>   	},
>   	.probe	= vhost_vdpa_probe,
>   	.remove	= vhost_vdpa_remove,
> +	.setup_vq_irq = vhost_vdpa_setup_vq_irq,
> +	.unsetup_vq_irq = vhost_vdpa_unsetup_vq_irq,
>   };
>   
>   static int __init vhost_vdpa_init(void)
> diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
> index 239db79..9f9b245 100644
> --- a/include/linux/vdpa.h
> +++ b/include/linux/vdpa.h
> @@ -220,17 +220,28 @@ struct vdpa_device *__vdpa_alloc_device(struct device *parent,
>   
>   int vdpa_register_device(struct vdpa_device *vdev);
>   void vdpa_unregister_device(struct vdpa_device *vdev);
> +int vdpa_alloc_vq_irq(struct device *dev, struct vdpa_device *vdev,
> +		      unsigned int irq, irq_handler_t handler,
> +		      unsigned long irqflags, const char *devname, void *dev_id,
> +		      int qid);
> +void vdpa_free_vq_irq(struct device *dev, struct vdpa_device *vdev, int irq,
> +		      int qid, void *dev_id);


You need to document the devres implications of those two helpers.


> +
>   
>   /**
>    * vdpa_driver - operations for a vDPA driver
>    * @driver: underlying device driver
>    * @probe: the function to call when a device is found.  Returns 0 or -errno.
>    * @remove: the function to call when a device is removed.
> + * @setup_vq_irq: setup irq bypass for a vhost_vdpa vq.
> + * @unsetup_vq_irq: unsetup irq bypass for a vhost_vdpa vq.


Though irq bypass is used by vhost-vdpa, it's not necessarily to be true 
in the future. So it's better not to mention irqbypass in the doc here.

Thanks


>    */
>   struct vdpa_driver {
>   	struct device_driver driver;
>   	int (*probe)(struct vdpa_device *vdev);
>   	void (*remove)(struct vdpa_device *vdev);
> +	void (*setup_vq_irq)(struct vdpa_device *vdev, int qid, int irq);
> +	void (*unsetup_vq_irq)(struct vdpa_device *vdev, int qid);
>   };
>   
>   #define vdpa_register_driver(drv) \

