Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 925E818AD4D
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 08:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbgCSH2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 03:28:21 -0400
Received: from mga05.intel.com ([192.55.52.43]:5312 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725767AbgCSH2V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 03:28:21 -0400
IronPort-SDR: fQWJ7JZrrwYF2AaRI4RVYKH7rfqGwWaJnHejKBhNLVnComdphkmRfIy2MafdJpNXeck3vNxo+r
 UZSJtdAXZaqw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2020 00:28:20 -0700
IronPort-SDR: +ynZLPgX83Heh6CG9vN/Sgp/JsguDozsL8GoamStPtNkExemN3NrjpHL6OrLC9CGs5apg3EImw
 HF5mKlBQPRxg==
X-IronPort-AV: E=Sophos;i="5.70,570,1574150400"; 
   d="scan'208";a="391714770"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.254.211.233]) ([10.254.211.233])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2020 00:28:13 -0700
Subject: Re: [PATCH V6 8/8] virtio: Intel IFC VF driver for VDPA
To:     Jason Gunthorpe <jgg@mellanox.com>,
        Jason Wang <jasowang@redhat.com>
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
References: <20200318080327.21958-1-jasowang@redhat.com>
 <20200318080327.21958-9-jasowang@redhat.com>
 <20200318122255.GG13183@mellanox.com>
From:   Zhu Lingshan <lingshan.zhu@linux.intel.com>
Message-ID: <d3e0ec0d-3387-17bd-a33c-189933f70f95@linux.intel.com>
Date:   Thu, 19 Mar 2020 15:28:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200318122255.GG13183@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/18/2020 8:22 PM, Jason Gunthorpe wrote:
> On Wed, Mar 18, 2020 at 04:03:27PM +0800, Jason Wang wrote:
>> From: Zhu Lingshan <lingshan.zhu@intel.com>
>> +
>> +static int ifcvf_vdpa_attach(struct ifcvf_adapter *adapter)
>> +{
>> +	int ret;
>> +
>> +	adapter->vdpa_dev  = vdpa_alloc_device(adapter->dev, adapter->dev,
>> +					       &ifc_vdpa_ops);
>> +	if (IS_ERR(adapter->vdpa_dev)) {
>> +		IFCVF_ERR(adapter->dev, "Failed to init ifcvf on vdpa bus");
>> +		put_device(&adapter->vdpa_dev->dev);
>> +		return -ENODEV;
>> +	}
> The point of having an alloc call is so that the drivers
> ifcvf_adaptor memory could be placed in the same struct - eg use
> container_of to flip between them, and have a kref for both memories.
>
> It seem really weird to have an alloc followed immediately by
> register.

Hi Jason,

Thanks for your comments, but I failed to understand this. In IFCVF 
driver, we call ifcvf_vdpa_attach() at the end at probe(),
at this point, PCIE initialization almost done, then try to alloc vdpa 
device, if successful, we can register it to VDPA bus.

Are you suggesting to wait for anything else done?

THanks,
BR
Zhu Linghsan
>
>> diff --git a/drivers/virtio/virtio_vdpa.c b/drivers/virtio/virtio_vdpa.c
>> index c30eb55030be..de64b88ee7e4 100644
>> +++ b/drivers/virtio/virtio_vdpa.c
>> @@ -362,6 +362,7 @@ static int virtio_vdpa_probe(struct vdpa_device *vdpa)
>>   		goto err;
>>   
>>   	vdpa_set_drvdata(vdpa, vd_dev);
>> +	dev_info(vd_dev->vdev.dev.parent, "device attached to VDPA bus\n");
>>   
>>   	return 0;
> This hunk seems out of place
>
> Jason
