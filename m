Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6581419381F
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 06:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726180AbgCZFvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 01:51:21 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:40275 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725819AbgCZFvU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 01:51:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585201879;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jMJJQtTusqzXruy5fUBgUSvmMkI27a/obMAYeFbHg3s=;
        b=N5Qgg5pmIfG4kFUqTQff+VVK8uThu42XSxWqIfGnv3ngalln0WnFxsxUhbrcKaqvb2q4u6
        sfdXMkD2ozhwk6dzaQrCfhRxueaj0eNR/UCGMPfYZbjUaMVLhYMBytJuUP1ak+oEzn0o0u
        8SEWZTNO+bAL9ktssRo8iCV0b3VCRH0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-117-ox8Usa4NObSsCMFORatLyA-1; Thu, 26 Mar 2020 01:51:15 -0400
X-MC-Unique: ox8Usa4NObSsCMFORatLyA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0B386107ACC4;
        Thu, 26 Mar 2020 05:51:13 +0000 (UTC)
Received: from [10.72.13.193] (ovpn-13-193.pek2.redhat.com [10.72.13.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E7BFC100EBA4;
        Thu, 26 Mar 2020 05:50:54 +0000 (UTC)
Subject: Re: [PATCH V8 9/9] virtio: Intel IFC VF driver for VDPA
To:     Jason Gunthorpe <jgg@mellanox.com>
Cc:     mst@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        maxime.coquelin@redhat.com, cunming.liang@intel.com,
        zhihong.wang@intel.com, rob.miller@broadcom.com,
        xiao.w.wang@intel.com, lingshan.zhu@intel.com, eperezma@redhat.com,
        lulu@redhat.com, parav@mellanox.com, kevin.tian@intel.com,
        stefanha@redhat.com, rdunlap@infradead.org, hch@infradead.org,
        aadam@redhat.com, jiri@mellanox.com, shahafs@mellanox.com,
        hanand@xilinx.com, mhabets@solarflare.com, gdawar@xilinx.com,
        saugatm@xilinx.com, vmireyno@marvell.com,
        Bie Tiwei <tiwei.bie@intel.com>
References: <20200325082711.1107-1-jasowang@redhat.com>
 <20200325082711.1107-10-jasowang@redhat.com>
 <20200325123410.GX13183@mellanox.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <ed04692d-236c-2eee-4429-6ef4d5d165fe@redhat.com>
Date:   Thu, 26 Mar 2020 13:50:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200325123410.GX13183@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/3/25 =E4=B8=8B=E5=8D=888:34, Jason Gunthorpe wrote:
> On Wed, Mar 25, 2020 at 04:27:11PM +0800, Jason Wang wrote:
>> +static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_=
id *id)
>> +{
>> +	struct device *dev =3D &pdev->dev;
>> +	struct ifcvf_adapter *adapter;
>> +	struct ifcvf_hw *vf;
>> +	int ret, i;
>> +
>> +	ret =3D pci_enable_device(pdev);
>> +	if (ret) {
>> +		IFCVF_ERR(&pdev->dev, "Failed to enable device\n");
>> +		goto err_enable;
>> +	}
>> +
>> +	ret =3D pci_request_regions(pdev, IFCVF_DRIVER_NAME);
>> +	if (ret) {
>> +		IFCVF_ERR(&pdev->dev, "Failed to request MMIO region\n");
>> +		goto err_regions;
>> +	}
>> +
>> +	ret =3D pci_alloc_irq_vectors(pdev, IFCVF_MAX_INTR,
>> +				    IFCVF_MAX_INTR, PCI_IRQ_MSIX);
>> +	if (ret < 0) {
>> +		IFCVF_ERR(&pdev->dev, "Failed to alloc irq vectors\n");
>> +		goto err_vectors;
>> +	}
>> +
>> +	adapter =3D vdpa_alloc_device(ifcvf_adapter, vdpa, dev, &ifc_vdpa_op=
s);
>> +	if (adapter =3D=3D NULL) {
>> +		IFCVF_ERR(&pdev->dev, "Failed to allocate vDPA structure");
>> +		ret =3D -ENOMEM;
>> +		goto err_alloc;
>> +	}
>> +
>> +	adapter->dev =3D dev;
>> +	pci_set_master(pdev);
>> +	pci_set_drvdata(pdev, adapter);
>> +
>> +	ret =3D ifcvf_request_irq(adapter);
>> +	if (ret) {
>> +		IFCVF_ERR(&pdev->dev, "Failed to request MSI-X irq\n");
>> +		goto err_msix;
>> +	}
>> +
>> +	vf =3D &adapter->vf;
>> +	for (i =3D 0; i < IFCVF_PCI_MAX_RESOURCE; i++) {
>> +		vf->mem_resource[i].phys_addr =3D pci_resource_start(pdev, i);
>> +		vf->mem_resource[i].len =3D pci_resource_len(pdev, i);
>> +		if (!vf->mem_resource[i].len)
>> +			continue;
>> +
>> +		vf->mem_resource[i].addr =3D pci_iomap_range(pdev, i, 0,
>> +				vf->mem_resource[i].len);
>> +		if (!vf->mem_resource[i].addr) {
>> +			IFCVF_ERR(&pdev->dev,
>> +				  "Failed to map IO resource %d\n", i);
>> +			ret =3D -EINVAL;
>> +			goto err_msix;
>> +		}
>> +	}
>> +
>> +	if (ifcvf_init_hw(vf, pdev) < 0) {
>> +		ret =3D -EINVAL;
>> +		goto err_msix;
>> +	}
>> +
>> +	ret =3D dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
>> +	if (ret)
>> +		ret =3D dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
>> +
>> +	if (ret) {
>> +		IFCVF_ERR(adapter->dev, "No usable DMA confiugration\n");
>> +		ret =3D -EINVAL;
>> +		goto err_msix;
>> +	}
>> +
>> +	adapter->vdpa.dma_dev =3D dev;
>> +	ret =3D vdpa_register_device(&adapter->vdpa);
>> +	if (ret) {
>> +		IFCVF_ERR(adapter->dev, "Failed to register ifcvf to vdpa bus");
>> +		goto err_msix;
>> +	}
>> +
>> +	return 0;
>> +
>> +err_msix:
>> +	put_device(&adapter->vdpa.dev);
>> +	return ret;
>> +err_alloc:
>> +	pci_free_irq_vectors(pdev);
>> +err_vectors:
>> +	pci_release_regions(pdev);
>> +err_regions:
>> +	pci_disable_device(pdev);
>> +err_enable:
>> +	return ret;
>> +}
> I personally don't like seeing goto unwinds with multiple returns, and
> here I think it is actually a tiny bug.
>
> All touches to the PCI device must stop before the driver core
> remove() returns - so these pci function cannot be in the kref put
> release function anyhow.


I'm not sure I get here. IFCVF held refcnt of its PCI parent, so it=20
looks to me it's safe to free PCI resources in vDPA free callback?


>
> Suggest to use the devm versions of the above instead, and then you
> can reorder things so the allocation is done first.
>
> Jason


Using devm looks nice, but if it's possible I prefer to tweak on top.

Thanks


>

