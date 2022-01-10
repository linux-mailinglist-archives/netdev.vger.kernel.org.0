Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1A88488FF0
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 07:04:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238860AbiAJGEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 01:04:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:26620 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238848AbiAJGEm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 01:04:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641794679;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TRpT8bngD6XZ524K5rzFmBos9SyDH7iJjpZ/ugkBaOo=;
        b=d6j5QJ6NnZlT+ZX13MDpMAtDCnGriOWtPUTcLW8eC5kCMPDG+N/MwEYBu6/draddTChCT4
        ljpx8xBiOIaGJLbE2vbkKSlE0tJ3g9xJ63Fx8XcjCt43Huap4eRNivfVgIeFVXdjIWAqTS
        RXHjFXlHqyzJhID8eJ+b6g6UeU5klkc=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-633-SBHT0MaJMqOdPzMsFhs-SA-1; Mon, 10 Jan 2022 01:04:38 -0500
X-MC-Unique: SBHT0MaJMqOdPzMsFhs-SA-1
Received: by mail-wr1-f70.google.com with SMTP id v18-20020a5d5912000000b001815910d2c0so3777692wrd.1
        for <netdev@vger.kernel.org>; Sun, 09 Jan 2022 22:04:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TRpT8bngD6XZ524K5rzFmBos9SyDH7iJjpZ/ugkBaOo=;
        b=V6MPaaL4x0v4wbiqKZzbfEae+0t1KwfAV3TePon1nTMU//Rs8GrOWwPQOoUsh29Zae
         KxnuBDRm3VBFGUUMbPxzBqFuP9gkrA89Ddg+UcHaVZJ78ySVW51gfpteUMQ7dOVCr8bP
         weEx7MwDNS6mu50x4r6hdf9rrjoFGDKDv6BQ5sQKy6qwyH1aVcqbxi29V+oPz1bNPSAs
         1VprvIHWUXldljOa0bVJA6SiBjQnangUiYj/c7zGYxcSEzqWuUh+S5dNH5NLspN5lgcQ
         yc+DV9IGEeQvbZHTRJclncIkQEyINjo8jAj/OFhG44nSuh5nd4YqL5GNE8VpL7JuVjhl
         USUQ==
X-Gm-Message-State: AOAM531g56grUjnUi1kYPxVlaTObWkj7b3EmcNAA/6Vz5V0Q/YFUsr49
        Zb21HcL1r4STEwRdilAfNeMo10jhtTexUlgN6a6NJs0Y6g13UtM7mqhz4YMqSdrRqK5e7VrlpF+
        GOTvCvGTjEMzo3cXV
X-Received: by 2002:a05:600c:3b18:: with SMTP id m24mr5929759wms.4.1641794676852;
        Sun, 09 Jan 2022 22:04:36 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyp9ss+esRbFFQJ+5+Nlyprq0Bux+msPGXjx3nNIwwL0P91VmNJBpROCT/VioW3E+Qxzjf66w==
X-Received: by 2002:a05:600c:3b18:: with SMTP id m24mr5929747wms.4.1641794676633;
        Sun, 09 Jan 2022 22:04:36 -0800 (PST)
Received: from redhat.com ([2a03:c5c0:107d:b60c:c297:16fe:7528:e989])
        by smtp.gmail.com with ESMTPSA id g18sm6337027wmq.5.2022.01.09.22.04.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Jan 2022 22:04:36 -0800 (PST)
Date:   Mon, 10 Jan 2022 01:04:32 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     jasowang@redhat.com, netdev@vger.kernel.org
Subject: Re: [PATCH 7/7] vDPA/ifcvf: improve irq requester, to handle
 per_vq/shared/config irq
Message-ID: <20220110005612-mutt-send-email-mst@kernel.org>
References: <20220110051851.84807-1-lingshan.zhu@intel.com>
 <20220110051851.84807-8-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220110051851.84807-8-lingshan.zhu@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 10, 2022 at 01:18:51PM +0800, Zhu Lingshan wrote:
> This commit expends irq requester abilities to handle per vq irq,
> shared irq and config irq.
> 
> On some platforms, the device can not get enough vectors for every
> virtqueue and config interrupt, the device needs to work under such
> circumstances.
> 
> Normally a device can get enough vectors, so every virtqueue and
> config interrupt can have its own vector/irq. If the total vector
> number is less than all virtqueues + 1(config interrupt), all
> virtqueues need to share a vector/irq and config interrupt is
> enabled. If the total vector number < 2, all vitequeues share
> a vector/irq, and config interrupt is disabled. Otherwise it will
> fail if allocation for vectors fails.
> 
> This commit also made necessary chages to the irq cleaner to
> free per vq irq/shared irq and config irq.
> 
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>


In this case, shouldn't you also check VIRTIO_PCI_ISR_CONFIG?
doing that will skip the need 


> ---
>  drivers/vdpa/ifcvf/ifcvf_base.h |  6 +--
>  drivers/vdpa/ifcvf/ifcvf_main.c | 78 +++++++++++++++------------------
>  2 files changed, 38 insertions(+), 46 deletions(-)
> 
> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
> index 1d5431040d7d..1d0afb63f06c 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_base.h
> +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
> @@ -27,8 +27,6 @@
>  
>  #define IFCVF_QUEUE_ALIGNMENT	PAGE_SIZE
>  #define IFCVF_QUEUE_MAX		32768
> -#define IFCVF_MSI_CONFIG_OFF	0
> -#define IFCVF_MSI_QUEUE_OFF	1
>  #define IFCVF_PCI_MAX_RESOURCE	6
>  
>  #define IFCVF_LM_CFG_SIZE		0x40
> @@ -102,11 +100,13 @@ struct ifcvf_hw {
>  	u8 notify_bar;
>  	/* Notificaiton bar address */
>  	void __iomem *notify_base;
> +	u8 vector_per_vq;
> +	u16 padding;

What is this padding doing?

>  	phys_addr_t notify_base_pa;
>  	u32 notify_off_multiplier;
> +	u32 dev_type;
>  	u64 req_features;
>  	u64 hw_features;
> -	u32 dev_type;

moving things around ... optimization? split out.

>  	struct virtio_pci_common_cfg __iomem *common_cfg;
>  	void __iomem *net_cfg;
>  	struct vring_info vring[IFCVF_MAX_QUEUES];
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> index 414b5dfd04ca..ec76e342bd7e 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -17,6 +17,8 @@
>  #define DRIVER_AUTHOR   "Intel Corporation"
>  #define IFCVF_DRIVER_NAME       "ifcvf"
>  
> +static struct vdpa_config_ops ifc_vdpa_ops;
> +

there can be multiple devices thinkably.
reusing a global ops does not sound reasonable.


>  static irqreturn_t ifcvf_config_changed(int irq, void *arg)
>  {
>  	struct ifcvf_hw *vf = arg;
> @@ -63,13 +65,20 @@ static void ifcvf_free_irq(struct ifcvf_adapter *adapter, int queues)
>  	struct ifcvf_hw *vf = &adapter->vf;
>  	int i;
>  
> +	if (vf->vector_per_vq)
> +		for (i = 0; i < queues; i++) {
> +			devm_free_irq(&pdev->dev, vf->vring[i].irq, &vf->vring[i]);
> +			vf->vring[i].irq = -EINVAL;
> +		}
> +	else
> +		devm_free_irq(&pdev->dev, vf->vring[0].irq, vf);
>  
> -	for (i = 0; i < queues; i++) {
> -		devm_free_irq(&pdev->dev, vf->vring[i].irq, &vf->vring[i]);
> -		vf->vring[i].irq = -EINVAL;
> +
> +	if (vf->config_irq != -EINVAL) {
> +		devm_free_irq(&pdev->dev, vf->config_irq, vf);
> +		vf->config_irq = -EINVAL;
>  	}

what about other error types?

>  
> -	devm_free_irq(&pdev->dev, vf->config_irq, vf);
>  	ifcvf_free_irq_vectors(pdev);
>  }
>  
> @@ -191,52 +200,35 @@ static int ifcvf_request_config_irq(struct ifcvf_adapter *adapter, int config_ve
>  
>  static int ifcvf_request_irq(struct ifcvf_adapter *adapter)
>  {
> -	struct pci_dev *pdev = adapter->pdev;
>  	struct ifcvf_hw *vf = &adapter->vf;
> -	int vector, i, ret, irq;
> -	u16 max_intr;
> +	u16 nvectors, max_vectors;
> +	int config_vector, ret;
>  
> -	/* all queues and config interrupt  */
> -	max_intr = vf->nr_vring + 1;
> +	nvectors = ifcvf_alloc_vectors(adapter);
> +	if (nvectors < 0)
> +		return nvectors;
>  
> -	ret = pci_alloc_irq_vectors(pdev, max_intr,
> -				    max_intr, PCI_IRQ_MSIX);
> -	if (ret < 0) {
> -		IFCVF_ERR(pdev, "Failed to alloc IRQ vectors\n");
> -		return ret;
> -	}
> +	vf->vector_per_vq = true;
> +	max_vectors = vf->nr_vring + 1;
> +	config_vector = vf->nr_vring;
>  
> -	snprintf(vf->config_msix_name, 256, "ifcvf[%s]-config\n",
> -		 pci_name(pdev));
> -	vector = 0;
> -	vf->config_irq = pci_irq_vector(pdev, vector);
> -	ret = devm_request_irq(&pdev->dev, vf->config_irq,
> -			       ifcvf_config_changed, 0,
> -			       vf->config_msix_name, vf);
> -	if (ret) {
> -		IFCVF_ERR(pdev, "Failed to request config irq\n");
> -		return ret;
> +	if (nvectors < max_vectors) {
> +		vf->vector_per_vq = false;
> +		config_vector = 1;
> +		ifc_vdpa_ops.get_vq_irq = NULL;
>  	}
>  
> -	for (i = 0; i < vf->nr_vring; i++) {
> -		snprintf(vf->vring[i].msix_name, 256, "ifcvf[%s]-%d\n",
> -			 pci_name(pdev), i);
> -		vector = i + IFCVF_MSI_QUEUE_OFF;
> -		irq = pci_irq_vector(pdev, vector);
> -		ret = devm_request_irq(&pdev->dev, irq,
> -				       ifcvf_intr_handler, 0,
> -				       vf->vring[i].msix_name,
> -				       &vf->vring[i]);
> -		if (ret) {
> -			IFCVF_ERR(pdev,
> -				  "Failed to request irq for vq %d\n", i);
> -			ifcvf_free_irq(adapter, i);
> +	if (nvectors < 2)
> +		config_vector = 0;
>  
> -			return ret;
> -		}
> +	ret = ifcvf_request_vq_irq(adapter, vf->vector_per_vq);
> +	if (ret)
> +		return ret;
>  
> -		vf->vring[i].irq = irq;
> -	}
> +	ret = ifcvf_request_config_irq(adapter, config_vector);
> +
> +	if (ret)
> +		return ret;

here on error we need to cleanup vq irq we requested, need we not?

>  
>  	return 0;
>  }
> @@ -573,7 +565,7 @@ static struct vdpa_notification_area ifcvf_get_vq_notification(struct vdpa_devic
>   * IFCVF currently does't have on-chip IOMMU, so not
>   * implemented set_map()/dma_map()/dma_unmap()
>   */
> -static const struct vdpa_config_ops ifc_vdpa_ops = {
> +static struct vdpa_config_ops ifc_vdpa_ops = {
>  	.get_features	= ifcvf_vdpa_get_features,
>  	.set_features	= ifcvf_vdpa_set_features,
>  	.get_status	= ifcvf_vdpa_get_status,
> -- 
> 2.27.0

