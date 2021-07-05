Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB173BB73F
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 08:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbhGEGks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 02:40:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:7463 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229817AbhGEGks (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Jul 2021 02:40:48 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10035"; a="230646532"
X-IronPort-AV: E=Sophos;i="5.83,325,1616482800"; 
   d="scan'208";a="230646532"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2021 23:38:06 -0700
X-IronPort-AV: E=Sophos;i="5.83,325,1616482800"; 
   d="scan'208";a="456615277"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.255.31.182]) ([10.255.31.182])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2021 23:38:04 -0700
Subject: Re: [PATCH 2/3] vDPA/ifcvf: implement management netlink framework
 for ifcvf
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org
References: <20210630082145.5729-1-lingshan.zhu@intel.com>
 <20210630082145.5729-3-lingshan.zhu@intel.com>
 <1ebb3dc8-5416-f718-2837-8371e78dd3d0@redhat.com>
 <20210705023354-mutt-send-email-mst@kernel.org>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
Message-ID: <d75f9005-22ca-ad55-5f54-3b292ff21931@intel.com>
Date:   Mon, 5 Jul 2021 14:38:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210705023354-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/5/2021 2:34 PM, Michael S. Tsirkin wrote:
> On Mon, Jul 05, 2021 at 01:04:11PM +0800, Jason Wang wrote:
>>> +static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>>> +{
>>> +	struct ifcvf_vdpa_mgmt_dev *ifcvf_mgmt_dev;
>>> +	struct device *dev = &pdev->dev;
>>> +	struct ifcvf_adapter *adapter;
>>
>> adapter is not used.
> It's used in error handling below. It's not *initialized*.
sorry, my bad. I think I should move adapter related error handling code 
into ifcvf_vdpa_dev_add(),
probe() does not see adapter anymore, only struct ifcvf_vdpa_mgmt_dev.

Thanks
>
>>> +	u32 dev_type;
>>> +	int ret;
>>> +
>>> +	ifcvf_mgmt_dev = kzalloc(sizeof(struct ifcvf_vdpa_mgmt_dev), GFP_KERNEL);
>>> +	if (!ifcvf_mgmt_dev) {
>>> +		IFCVF_ERR(pdev, "Failed to alloc memory for the vDPA management device\n");
>>> +		return -ENOMEM;
>>> +	}
>>> +
>>> +	dev_type = get_dev_type(pdev);
>>> +	switch (dev_type) {
>>> +	case VIRTIO_ID_NET:
>>> +		ifcvf_mgmt_dev->mdev.id_table = id_table_net;
>>> +		break;
>>> +	case VIRTIO_ID_BLOCK:
>>> +		ifcvf_mgmt_dev->mdev.id_table = id_table_blk;
>>> +		break;
>>> +	default:
>>> +		IFCVF_ERR(pdev, "VIRTIO ID %u not supported\n", dev_type);
>>> +		ret = -EOPNOTSUPP;
>>> +		goto err;
>>> +	}
>>> +
>>> +	ifcvf_mgmt_dev->mdev.ops = &ifcvf_vdpa_mgmt_dev_ops;
>>> +	ifcvf_mgmt_dev->mdev.device = dev;
>>> +	ifcvf_mgmt_dev->pdev = pdev;
>>> +
>>> +	ret = pcim_enable_device(pdev);
>>> +	if (ret) {
>>> +		IFCVF_ERR(pdev, "Failed to enable device\n");
>>> +		goto err;
>>> +	}
>>> +
>>> +	ret = pcim_iomap_regions(pdev, BIT(0) | BIT(2) | BIT(4),
>>> +				 IFCVF_DRIVER_NAME);
>>> +	if (ret) {
>>> +		IFCVF_ERR(pdev, "Failed to request MMIO region\n");
>>> +		goto err;
>>> +	}
>>> +
>>> +	ret = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(64));
>>> +	if (ret) {
>>> +		IFCVF_ERR(pdev, "No usable DMA configuration\n");
>>> +		goto err;
>>> +	}
>>> +
>>> +	ret = devm_add_action_or_reset(dev, ifcvf_free_irq_vectors, pdev);
>>> +	if (ret) {
>>> +		IFCVF_ERR(pdev,
>>> +			  "Failed for adding devres for freeing irq vectors\n");
>>> +		goto err;
>>> +	}
>>> +
>>> +	pci_set_master(pdev);
>>> +
>>> +	ret = vdpa_mgmtdev_register(&ifcvf_mgmt_dev->mdev);
>>> +	if (ret) {
>>> +		IFCVF_ERR(pdev,
>>> +			  "Failed to initialize the management interfaces\n");
>>>    		goto err;
>>>    	}
>>> @@ -533,14 +610,21 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>>>    err:
>>>    	put_device(&adapter->vdpa.dev);
>>> +	kfree(ifcvf_mgmt_dev);
>>>    	return ret;
>>>    }

