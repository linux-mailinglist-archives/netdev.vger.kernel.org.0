Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 170DB1D05D1
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 06:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbgEMEMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 00:12:13 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:33905 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725837AbgEMEMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 00:12:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589343131;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TFMNhtVPuv906gLl9sa3StnSPuNaMYBoacPzdy9DO50=;
        b=EuZksTD9w30LYmDsk45EyUhtnBa6dVcDt9wKIcUtuDNR0oRujB+2NNkls8sik0P2o3S0d5
        e8Q+/kuMTW8RiMm2zOnXgDd/mWPzBdhB6/9bewWCbeDSZxfHF2h/YRq7BFTTe4mjJAu3gO
        4NBX9BPoS0wBOMvlXxYJuSdXAnrPgrs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-339-trGUjsymPEWOpe8TrPlrpg-1; Wed, 13 May 2020 00:12:09 -0400
X-MC-Unique: trGUjsymPEWOpe8TrPlrpg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E22E2BFC1;
        Wed, 13 May 2020 04:12:07 +0000 (UTC)
Received: from [10.72.13.188] (ovpn-13-188.pek2.redhat.com [10.72.13.188])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E996160C47;
        Wed, 13 May 2020 04:12:01 +0000 (UTC)
Subject: Re: [PATCH V2] ifcvf: move IRQ request/free to status change handlers
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     lulu@redhat.com, dan.daly@intel.com, cunming.liang@intel.com
References: <1589270444-3669-1-git-send-email-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <8aca85c3-3bf6-a1ec-7009-cd9a635647d7@redhat.com>
Date:   Wed, 13 May 2020 12:12:00 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1589270444-3669-1-git-send-email-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/5/12 下午4:00, Zhu Lingshan wrote:
> This commit move IRQ request and free operations from probe()
> to VIRTIO status change handler to comply with VIRTIO spec.
>
> VIRTIO spec 1.1, section 2.1.2 Device Requirements: Device Status Field
> The device MUST NOT consume buffers or send any used buffer
> notifications to the driver before DRIVER_OK.


This comment needs to be checked as I said previously. It's only needed 
if we're sure ifcvf can generate interrupt before DRIVER_OK.


>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
> changes from V1:
> remove ifcvf_stop_datapath() in status == 0 handler, we don't need to do this
> twice; handle status == 0 after DRIVER_OK -> !DRIVER_OK handler (Jason Wang)


Patch looks good to me, but with this patch ping cannot work on my 
machine. (It works without this patch).

Thanks


>
>   drivers/vdpa/ifcvf/ifcvf_main.c | 120 ++++++++++++++++++++++++----------------
>   1 file changed, 73 insertions(+), 47 deletions(-)
>
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> index abf6a061..d529ed6 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -28,6 +28,60 @@ static irqreturn_t ifcvf_intr_handler(int irq, void *arg)
>   	return IRQ_HANDLED;
>   }
>   
> +static void ifcvf_free_irq_vectors(void *data)
> +{
> +	pci_free_irq_vectors(data);
> +}
> +
> +static void ifcvf_free_irq(struct ifcvf_adapter *adapter, int queues)
> +{
> +	struct pci_dev *pdev = adapter->pdev;
> +	struct ifcvf_hw *vf = &adapter->vf;
> +	int i;
> +
> +
> +	for (i = 0; i < queues; i++)
> +		devm_free_irq(&pdev->dev, vf->vring[i].irq, &vf->vring[i]);
> +
> +	ifcvf_free_irq_vectors(pdev);
> +}
> +
> +static int ifcvf_request_irq(struct ifcvf_adapter *adapter)
> +{
> +	struct pci_dev *pdev = adapter->pdev;
> +	struct ifcvf_hw *vf = &adapter->vf;
> +	int vector, i, ret, irq;
> +
> +	ret = pci_alloc_irq_vectors(pdev, IFCVF_MAX_INTR,
> +				    IFCVF_MAX_INTR, PCI_IRQ_MSIX);
> +	if (ret < 0) {
> +		IFCVF_ERR(pdev, "Failed to alloc IRQ vectors\n");
> +		return ret;
> +	}
> +
> +	for (i = 0; i < IFCVF_MAX_QUEUE_PAIRS * 2; i++) {
> +		snprintf(vf->vring[i].msix_name, 256, "ifcvf[%s]-%d\n",
> +			 pci_name(pdev), i);
> +		vector = i + IFCVF_MSI_QUEUE_OFF;
> +		irq = pci_irq_vector(pdev, vector);
> +		ret = devm_request_irq(&pdev->dev, irq,
> +				       ifcvf_intr_handler, 0,
> +				       vf->vring[i].msix_name,
> +				       &vf->vring[i]);
> +		if (ret) {
> +			IFCVF_ERR(pdev,
> +				  "Failed to request irq for vq %d\n", i);
> +			ifcvf_free_irq(adapter, i);
> +
> +			return ret;
> +		}
> +
> +		vf->vring[i].irq = irq;
> +	}
> +
> +	return 0;
> +}
> +
>   static int ifcvf_start_datapath(void *private)
>   {
>   	struct ifcvf_hw *vf = ifcvf_private_to_vf(private);
> @@ -118,17 +172,34 @@ static void ifcvf_vdpa_set_status(struct vdpa_device *vdpa_dev, u8 status)
>   {
>   	struct ifcvf_adapter *adapter;
>   	struct ifcvf_hw *vf;
> +	u8 status_old;
> +	int ret;
>   
>   	vf  = vdpa_to_vf(vdpa_dev);
>   	adapter = dev_get_drvdata(vdpa_dev->dev.parent);
> +	status_old = ifcvf_get_status(vf);
>   
> -	if (status == 0) {
> +	if ((status_old & VIRTIO_CONFIG_S_DRIVER_OK) &&
> +	    !(status & VIRTIO_CONFIG_S_DRIVER_OK)) {
>   		ifcvf_stop_datapath(adapter);
> +		ifcvf_free_irq(adapter, IFCVF_MAX_QUEUE_PAIRS * 2);
> +	}
> +
> +	if (status == 0) {
>   		ifcvf_reset_vring(adapter);
>   		return;
>   	}
>   
> -	if (status & VIRTIO_CONFIG_S_DRIVER_OK) {
> +	if ((status & VIRTIO_CONFIG_S_DRIVER_OK) &&
> +	    !(status_old & VIRTIO_CONFIG_S_DRIVER_OK)) {
> +		ret = ifcvf_request_irq(adapter);
> +		if (ret) {
> +			status = ifcvf_get_status(vf);
> +			status |= VIRTIO_CONFIG_S_FAILED;
> +			ifcvf_set_status(vf, status);
> +			return;
> +		}
> +
>   		if (ifcvf_start_datapath(adapter) < 0)
>   			IFCVF_ERR(adapter->pdev,
>   				  "Failed to set ifcvf vdpa  status %u\n",
> @@ -284,38 +355,6 @@ static void ifcvf_vdpa_set_config_cb(struct vdpa_device *vdpa_dev,
>   	.set_config_cb  = ifcvf_vdpa_set_config_cb,
>   };
>   
> -static int ifcvf_request_irq(struct ifcvf_adapter *adapter)
> -{
> -	struct pci_dev *pdev = adapter->pdev;
> -	struct ifcvf_hw *vf = &adapter->vf;
> -	int vector, i, ret, irq;
> -
> -
> -	for (i = 0; i < IFCVF_MAX_QUEUE_PAIRS * 2; i++) {
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
> -			return ret;
> -		}
> -		vf->vring[i].irq = irq;
> -	}
> -
> -	return 0;
> -}
> -
> -static void ifcvf_free_irq_vectors(void *data)
> -{
> -	pci_free_irq_vectors(data);
> -}
> -
>   static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>   {
>   	struct device *dev = &pdev->dev;
> @@ -349,13 +388,6 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>   		return ret;
>   	}
>   
> -	ret = pci_alloc_irq_vectors(pdev, IFCVF_MAX_INTR,
> -				    IFCVF_MAX_INTR, PCI_IRQ_MSIX);
> -	if (ret < 0) {
> -		IFCVF_ERR(pdev, "Failed to alloc irq vectors\n");
> -		return ret;
> -	}
> -
>   	ret = devm_add_action_or_reset(dev, ifcvf_free_irq_vectors, pdev);
>   	if (ret) {
>   		IFCVF_ERR(pdev,
> @@ -379,12 +411,6 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>   	adapter->pdev = pdev;
>   	adapter->vdpa.dma_dev = &pdev->dev;
>   
> -	ret = ifcvf_request_irq(adapter);
> -	if (ret) {
> -		IFCVF_ERR(pdev, "Failed to request MSI-X irq\n");
> -		goto err;
> -	}
> -
>   	ret = ifcvf_init_hw(vf, pdev);
>   	if (ret) {
>   		IFCVF_ERR(pdev, "Failed to init IFCVF hw\n");

