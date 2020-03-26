Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD0B7194097
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 14:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbgCZN5W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 09:57:22 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:29382 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727834AbgCZN5T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 09:57:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585231038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uTy9XzunUpSqneSBWA8G2EaCSTiTKP7tCVW6EiON0Oc=;
        b=NUExir/e/3L3rdcfNi8sREWrjBgGeCDsxh6Iq44GQ+goMcWo/YR/X+pKp8ImbIgqK/SvA1
        z/B5kD71xoDHbwrv4WS3rKrfrTHbevfMEQ5HW2SMHMY9pK5Pk3hV5qXWaKXj6A2JfNItv0
        OZeOIqCVbwE3QR9t0iKPJxbzMcddU4E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-aLmbfdiSP4iuwWm6Alh4Rw-1; Thu, 26 Mar 2020 09:57:12 -0400
X-MC-Unique: aLmbfdiSP4iuwWm6Alh4Rw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 82830800D50;
        Thu, 26 Mar 2020 13:57:09 +0000 (UTC)
Received: from [10.72.12.19] (ovpn-12-19.pek2.redhat.com [10.72.12.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CFE2E60BF3;
        Thu, 26 Mar 2020 13:56:49 +0000 (UTC)
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
 <ed04692d-236c-2eee-4429-6ef4d5d165fe@redhat.com>
 <20200326121705.GJ13183@mellanox.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <a03edad7-e1c9-ae2f-5843-d63907289a3f@redhat.com>
Date:   Thu, 26 Mar 2020 21:56:48 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200326121705.GJ13183@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/3/26 =E4=B8=8B=E5=8D=888:17, Jason Gunthorpe wrote:
> On Thu, Mar 26, 2020 at 01:50:53PM +0800, Jason Wang wrote:
>
>>>> +	adapter->vdpa.dma_dev =3D dev;
>>>> +	ret =3D vdpa_register_device(&adapter->vdpa);
>>>> +	if (ret) {
>>>> +		IFCVF_ERR(adapter->dev, "Failed to register ifcvf to vdpa bus");
>>>> +		goto err_msix;
>>>> +	}
>>>> +
>>>> +	return 0;
>>>> +
>>>> +err_msix:
>>>> +	put_device(&adapter->vdpa.dev);
>>>> +	return ret;
>>>> +err_alloc:
>>>> +	pci_free_irq_vectors(pdev);
>>>> +err_vectors:
>>>> +	pci_release_regions(pdev);
>>>> +err_regions:
>>>> +	pci_disable_device(pdev);
>>>> +err_enable:
>>>> +	return ret;
>>>> +}
>>> I personally don't like seeing goto unwinds with multiple returns, an=
d
>>> here I think it is actually a tiny bug.
>>>
>>> All touches to the PCI device must stop before the driver core
>>> remove() returns - so these pci function cannot be in the kref put
>>> release function anyhow.
>>
>> I'm not sure I get here. IFCVF held refcnt of its PCI parent, so it lo=
oks to
>> me it's safe to free PCI resources in vDPA free callback?
> The refcnt doesn't prevent the driver core from re-binding the
> pci_device to another driver. Then the refcount put would do a
> pci_disable_device() after another driver has started
>
> For this reason all touches to a struct pci_device must stop before
> remove returns.
>
> Jason


Ok, will send a new version shortly.

Thanks


>

