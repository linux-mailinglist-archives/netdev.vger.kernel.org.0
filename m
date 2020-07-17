Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FECC223209
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 06:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbgGQET5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 00:19:57 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:20831 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725936AbgGQET4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 00:19:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594959594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=p8lAg2x78oICwymLwcBtrZ7x/TJ3QSVkvfTDbtDIY1c=;
        b=Dia3wZAQfraGZAIV8U75Hf+k61+aZEQ35jUYyoaLn+IpDWkNsn3mpsLofEQU/68NNPiRPz
        dWL44n8p9y61CKMLZKW1/4xDCoU7cIYbgOaDL6d5QMTrzFoAgATnksV76nMK9E+7Pi9And
        m2oufRUWIv8WU5TuRhrEMV/711lDUjY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-461-iSydANI1P7Gk1OAsrv5axQ-1; Fri, 17 Jul 2020 00:19:51 -0400
X-MC-Unique: iSydANI1P7Gk1OAsrv5axQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B667E10059A9;
        Fri, 17 Jul 2020 04:19:49 +0000 (UTC)
Received: from [10.72.12.157] (ovpn-12-157.pek2.redhat.com [10.72.12.157])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7896A1001B07;
        Fri, 17 Jul 2020 04:19:37 +0000 (UTC)
Subject: Re: [PATCH V2 3/6] vDPA: implement IRQ offloading helpers in vDPA
 core
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com,
        alex.williamson@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
References: <1594898629-18790-1-git-send-email-lingshan.zhu@intel.com>
 <1594898629-18790-4-git-send-email-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <ab4644cc-9668-a909-4dea-5416aacf7221@redhat.com>
Date:   Fri, 17 Jul 2020 12:19:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1594898629-18790-4-git-send-email-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/7/16 下午7:23, Zhu Lingshan wrote:
> This commit implements IRQ offloading helpers


Let's say "vq irq allocate/free helpers" here.


> in vDPA core by
> introducing two couple of functions:
>
> vdpa_alloc_vq_irq() and vdpa_free_vq_irq(): request irq and free
> irq, will setup irq offloading.
>
> vdpa_setup_irq() and vdpa_unsetup_irq(): supportive functions,
> will call vhost_vdpa helpers.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> Suggested-by: Jason Wang <jasowang@redhat.com>
> ---
>   drivers/vdpa/vdpa.c  | 42 ++++++++++++++++++++++++++++++++++++++++++
>   include/linux/vdpa.h | 13 +++++++++++++
>   2 files changed, 55 insertions(+)
>
> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
> index ff6562f..cce4d91 100644
> --- a/drivers/vdpa/vdpa.c
> +++ b/drivers/vdpa/vdpa.c
> @@ -163,6 +163,48 @@ void vdpa_unregister_driver(struct vdpa_driver *drv)
>   }
>   EXPORT_SYMBOL_GPL(vdpa_unregister_driver);
>   
> +static void vdpa_setup_irq(struct vdpa_device *vdev, int qid, int irq)
> +{
> +	struct vdpa_driver *drv = drv_to_vdpa(vdev->dev.driver);
> +
> +	if (drv->setup_vq_irq)
> +		drv->setup_vq_irq(vdev, qid, irq);
> +}
> +
> +static void vdpa_unsetup_irq(struct vdpa_device *vdev, int qid)
> +{
> +	struct vdpa_driver *drv = drv_to_vdpa(vdev->dev.driver);
> +
> +	if (drv->unsetup_vq_irq)
> +		drv->unsetup_vq_irq(vdev, qid);


Do you need to check the existence of drv before calling unset_vq_irq()?

And how can this synchronize with driver releasing and binding?


> +}
> +
> +int vdpa_alloc_vq_irq(struct device *dev, struct vdpa_device *vdev,
> +		      unsigned int irq, irq_handler_t handler,
> +		      unsigned long irqflags, const char *devname, void *dev_id,
> +		      int qid)


Let's add comment as what has been done by other exported helpers.


> +{
> +	int ret;
> +
> +	ret = devm_request_irq(dev, irq, handler, irqflags, devname, dev_id);
> +	if (ret)
> +		dev_err(dev, "Failed to request irq for vq %d\n", qid);
> +	else
> +		vdpa_setup_irq(vdev, qid, irq);
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
> diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
> index 239db79..7d64d83 100644
> --- a/include/linux/vdpa.h
> +++ b/include/linux/vdpa.h
> @@ -220,17 +220,30 @@ struct vdpa_device *__vdpa_alloc_device(struct device *parent,
>   
>   int vdpa_register_device(struct vdpa_device *vdev);
>   void vdpa_unregister_device(struct vdpa_device *vdev);
> +/* request irq for a vq, setup irq offloading if its a vhost_vdpa vq */


Let's do the documentation in vdpa.c, and again, document the devres 
implications or j_xxxust name it as vdpa_devm_xxx.


> +int vdpa_alloc_vq_irq(struct device *dev, struct vdpa_device *vdev,
> +		      unsigned int irq, irq_handler_t handler,
> +		      unsigned long irqflags, const char *devname, void *dev_id,
> +		      int qid);
> +/* free irq for a vq, unsetup irq offloading if its a vhost_vdpa vq */
> +void vdpa_free_vq_irq(struct device *dev, struct vdpa_device *vdev, int irq,
> +		      int qid, void *dev_id);
> +
>   
>   /**
>    * vdpa_driver - operations for a vDPA driver
>    * @driver: underlying device driver
>    * @probe: the function to call when a device is found.  Returns 0 or -errno.
>    * @remove: the function to call when a device is removed.
> + * @setup_vq_irq: setup irq offloading for a vhost_vdpa vq.
> + * @unsetup_vq_irq: unsetup offloading for a vhost_vdpa vq.


Let's not limit the methods for a specific use case like irq offloading 
here.


>    */
>   struct vdpa_driver {
>   	struct device_driver driver;
>   	int (*probe)(struct vdpa_device *vdev);
>   	void (*remove)(struct vdpa_device *vdev);
> +	void (*setup_vq_irq)(struct vdpa_device *vdev, int qid, int irq);
> +	void (*unsetup_vq_irq)(struct vdpa_device *vdev, int qid);


To be consistent with the exported helper, let's use 
alloc_vq_irq/free_vq_irq

Thanks


>   };
>   
>   #define vdpa_register_driver(drv) \

