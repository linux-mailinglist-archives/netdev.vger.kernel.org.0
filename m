Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E18492232F1
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 07:33:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726013AbgGQFdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 01:33:07 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44089 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725864AbgGQFdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 01:33:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594963985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SKw3TmjYzVk1C1S6gNL1iMqtEatrMQdgW83gtCC8/HU=;
        b=PBgonayvnhSpr6vJK+LTuHoU1eUbfOoyVryBaS3ZbULHtdI3HPPuNHkVN3OCza+S9VxrtI
        4KRWLtbF96X5yKfgeZKYskQIWGsH2IXDdlGzY78pYjPbGGkw8Xs7CC4LRqgOiVUoplEGFH
        AelbERnlJRZhSK7IEBRRHIj1rTprcW8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-355-R8FnbaM6POmutVFsP9W-Nw-1; Fri, 17 Jul 2020 01:33:03 -0400
X-MC-Unique: R8FnbaM6POmutVFsP9W-Nw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 79A6D107ACCA;
        Fri, 17 Jul 2020 05:33:02 +0000 (UTC)
Received: from [10.72.12.157] (ovpn-12-157.pek2.redhat.com [10.72.12.157])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1D0F71A7C8;
        Fri, 17 Jul 2020 05:32:32 +0000 (UTC)
Subject: Re: [PATCH V2 5/6] ifcvf: replace irq_request/free with vDPA helpers
To:     Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com,
        alex.williamson@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
References: <1594898629-18790-1-git-send-email-lingshan.zhu@intel.com>
 <1594898629-18790-6-git-send-email-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <c0662b7e-98ad-b7a3-a054-56bbb6a364ac@redhat.com>
Date:   Fri, 17 Jul 2020 13:32:28 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1594898629-18790-6-git-send-email-lingshan.zhu@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/7/16 下午7:23, Zhu Lingshan wrote:
> This commit replaced irq_request/free() with helpers in vDPA
> core, so that it can request/free irq and setup irq offloading
> on order.
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> Suggested-by: Jason Wang <jasowang@redhat.com>
> ---
>   drivers/vdpa/ifcvf/ifcvf_main.c | 14 +++++++++-----
>   1 file changed, 9 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> index f5a60c1..bd2a317 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -47,11 +47,12 @@ static void ifcvf_free_irq(struct ifcvf_adapter *adapter, int queues)
>   {
>   	struct pci_dev *pdev = adapter->pdev;
>   	struct ifcvf_hw *vf = &adapter->vf;
> +	struct vdpa_device *vdpa = &adapter->vdpa;
>   	int i;
>   
>   
>   	for (i = 0; i < queues; i++)
> -		devm_free_irq(&pdev->dev, vf->vring[i].irq, &vf->vring[i]);
> +		vdpa_free_vq_irq(&pdev->dev, vdpa, vf->vring[i].irq, i, &vf->vring[i]);
>   
>   	ifcvf_free_irq_vectors(pdev);
>   }
> @@ -60,6 +61,7 @@ static int ifcvf_request_irq(struct ifcvf_adapter *adapter)
>   {
>   	struct pci_dev *pdev = adapter->pdev;
>   	struct ifcvf_hw *vf = &adapter->vf;
> +	struct vdpa_device *vdpa = &adapter->vdpa;
>   	int vector, i, ret, irq;
>   
>   	ret = pci_alloc_irq_vectors(pdev, IFCVF_MAX_INTR,
> @@ -73,6 +75,10 @@ static int ifcvf_request_irq(struct ifcvf_adapter *adapter)
>   		 pci_name(pdev));
>   	vector = 0;
>   	irq = pci_irq_vector(pdev, vector);
> +	/* This isconfig interrupt, config accesses all go


Missing a blank between is and config.

Thanks


> +	 * through userspace, so no need to setup
> +	 * config interrupt offloading.
> +	 */
>   	ret = devm_request_irq(&pdev->dev, irq,
>   			       ifcvf_config_changed, 0,
>   			       vf->config_msix_name, vf);
> @@ -82,13 +88,11 @@ static int ifcvf_request_irq(struct ifcvf_adapter *adapter)
>   			 pci_name(pdev), i);
>   		vector = i + IFCVF_MSI_QUEUE_OFF;
>   		irq = pci_irq_vector(pdev, vector);
> -		ret = devm_request_irq(&pdev->dev, irq,
> +		ret = vdpa_alloc_vq_irq(&pdev->dev, vdpa, irq,
>   				       ifcvf_intr_handler, 0,
>   				       vf->vring[i].msix_name,
> -				       &vf->vring[i]);
> +				       &vf->vring[i], i);
>   		if (ret) {
> -			IFCVF_ERR(pdev,
> -				  "Failed to request irq for vq %d\n", i);
>   			ifcvf_free_irq(adapter, i);
>   
>   			return ret;

