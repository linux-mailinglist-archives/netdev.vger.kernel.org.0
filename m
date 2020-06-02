Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6D541EB638
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 09:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725835AbgFBHJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 03:09:24 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:53180 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725907AbgFBHJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 03:09:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591081762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=doLYACsUkvy+mrMo/XyVks5vKo9blZJESy3aPW3MWD0=;
        b=HhT59VX13H2y9BlJlWxL3HiNLX+jfgCq4wOmJtk2P+koNjGHN7L3MQ9mFypTU5lvr0k1C+
        lUwIrrdPdswoOL3mG2a7kVF4c/CaLw1yhN49Thk0l4PAUNJlaEzpKQIC+mHMN7I51GU9+n
        R1L6L7nXB9UK0/JwHVSrKk7hWmCV86s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-60-v0pmb4asNTWrpJVBEZG22w-1; Tue, 02 Jun 2020 03:09:18 -0400
X-MC-Unique: v0pmb4asNTWrpJVBEZG22w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 66451100960F;
        Tue,  2 Jun 2020 07:09:16 +0000 (UTC)
Received: from [10.72.12.102] (ovpn-12-102.pek2.redhat.com [10.72.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 802B810013C1;
        Tue,  2 Jun 2020 07:08:43 +0000 (UTC)
Subject: Re: [PATCH 5/6] vdpa: introduce virtio pci driver
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rob.miller@broadcom.com, lingshan.zhu@intel.com,
        eperezma@redhat.com, lulu@redhat.com, shahafs@mellanox.com,
        hanand@xilinx.com, mhabets@solarflare.com, gdawar@xilinx.com,
        saugatm@xilinx.com, vmireyno@marvell.com,
        zhangweining@ruijie.com.cn, eli@mellanox.com
References: <20200529080303.15449-1-jasowang@redhat.com>
 <20200529080303.15449-6-jasowang@redhat.com>
 <20200602010332-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <5dbb0386-beeb-5bf4-d12e-fb5427486bb8@redhat.com>
Date:   Tue, 2 Jun 2020 15:08:39 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200602010332-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/6/2 下午1:08, Michael S. Tsirkin wrote:
> On Fri, May 29, 2020 at 04:03:02PM +0800, Jason Wang wrote:
>> +static void vp_vdpa_set_vq_ready(struct vdpa_device *vdpa,
>> +				 u16 qid, bool ready)
>> +{
>> +	struct vp_vdpa *vp_vdpa = vdpa_to_vp(vdpa);
>> +
>> +	vp_iowrite16(qid, &vp_vdpa->common->queue_select);
>> +	vp_iowrite16(ready, &vp_vdpa->common->queue_enable);
>> +}
>> +
> Looks like this needs to check and just skip the write if
> ready == 0, right? Of course vdpa core then insists on calling
> vp_vdpa_get_vq_ready which will warn. Maybe just drop the
> check from core, move it to drivers which need it?
>
> ...


That may work, but it may cause inconsistent semantic for set_vq_ready 
if we leave it to the driver.


>
>
>> +static const struct pci_device_id vp_vdpa_id_table[] = {
>> +	{ PCI_DEVICE(PCI_VENDOR_ID_REDHAT_QUMRANET, PCI_ANY_ID) },
>> +	{ 0 }
>> +};
> This looks like it'll create a mess with either virtio pci
> or vdpa being loaded at random. Maybe just don't specify
> any IDs for now. Down the road we could get a
> distinct vendor ID or a range of device IDs for this.


Right, will do.

Thanks


>
>> +MODULE_DEVICE_TABLE(pci, vp_vdpa_id_table);
>> +
>> +static struct pci_driver vp_vdpa_driver = {
>> +	.name		= "vp-vdpa",
>> +	.id_table	= vp_vdpa_id_table,
>> +	.probe		= vp_vdpa_probe,
>> +	.remove		= vp_vdpa_remove,
>> +};
>> +
>> +module_pci_driver(vp_vdpa_driver);
>> +
>> +MODULE_AUTHOR("Jason Wang <jasowang@redhat.com>");
>> +MODULE_DESCRIPTION("vp-vdpa");
>> +MODULE_LICENSE("GPL");
>> +MODULE_VERSION("1");
>> -- 
>> 2.20.1

