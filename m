Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 144FF572F98
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 09:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234888AbiGMHtj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 03:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234944AbiGMHtM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 03:49:12 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19BE332DB9
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 00:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657698546; x=1689234546;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Pzj7taUDwwbGHf+1hKhSpqF/yeVeQ7ysIBf+qqGoMlY=;
  b=llWW90S+3cZ9jtoxj5UojUjHTaoLkW5jfJgKm7aeSQOi4jfC3Bahf0SC
   gn621+t68N0F3oA4ih0m60PvF2cqmkO0PlLCHBtA/L+bW2YanRv6PKPhP
   WIvnCKsUD3ebCtY1dzPdOilaccQe1jQhaNzTr9kSzjb1z/2k4GAxs9V5a
   rUQtzy8NwpBugeIWdBuhfnTEGfIktOo6dZd4D0gCZ4gK9tnExReF7j7+C
   +VBRDsCGnF4qzZ9Z0BW5kxQSOr4Xlk0GwPu4eJnX2bCSnxrl8oqVm+w8y
   HhWIJhJVovcJNx5Am9aVYAhkgJsU+7guqNDdEXOn16sHrXT6RuopJue54
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10406"; a="371453744"
X-IronPort-AV: E=Sophos;i="5.92,267,1650956400"; 
   d="scan'208";a="371453744"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2022 00:48:59 -0700
X-IronPort-AV: E=Sophos;i="5.92,267,1650956400"; 
   d="scan'208";a="628206423"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.254.208.157]) ([10.254.208.157])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2022 00:48:56 -0700
Message-ID: <21d3fef7-c73a-74f7-427e-48191ac4fc4e@intel.com>
Date:   Wed, 13 Jul 2022 15:48:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH V3 1/6] vDPA/ifcvf: get_config_size should return a value
 no greater than dev implementation
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, parav@nvidia.com, xieyongji@bytedance.com,
        gautam.dawar@amd.com
References: <20220701132826.8132-1-lingshan.zhu@intel.com>
 <20220701132826.8132-2-lingshan.zhu@intel.com>
 <20220713012944-mutt-send-email-mst@kernel.org>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <20220713012944-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/13/2022 1:31 PM, Michael S. Tsirkin wrote:
> On Fri, Jul 01, 2022 at 09:28:21PM +0800, Zhu Lingshan wrote:
>> ifcvf_get_config_size() should return a virtio device type specific value,
>> however the ret_value should not be greater than the onboard size of
>> the device implementation. E.g., for virtio_net, config_size should be
>> the minimum value of sizeof(struct virtio_net_config) and the onboard
>> cap size.
>>
>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>> ---
>>   drivers/vdpa/ifcvf/ifcvf_base.c | 13 +++++++++++--
>>   drivers/vdpa/ifcvf/ifcvf_base.h |  2 ++
>>   2 files changed, 13 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c b/drivers/vdpa/ifcvf/ifcvf_base.c
>> index 48c4dadb0c7c..fb957b57941e 100644
>> --- a/drivers/vdpa/ifcvf/ifcvf_base.c
>> +++ b/drivers/vdpa/ifcvf/ifcvf_base.c
>> @@ -128,6 +128,7 @@ int ifcvf_init_hw(struct ifcvf_hw *hw, struct pci_dev *pdev)
>>   			break;
>>   		case VIRTIO_PCI_CAP_DEVICE_CFG:
>>   			hw->dev_cfg = get_cap_addr(hw, &cap);
>> +			hw->cap_dev_config_size = le32_to_cpu(cap.length);
>>   			IFCVF_DBG(pdev, "hw->dev_cfg = %p\n", hw->dev_cfg);
>>   			break;
>>   		}
>> @@ -233,15 +234,23 @@ int ifcvf_verify_min_features(struct ifcvf_hw *hw, u64 features)
>>   u32 ifcvf_get_config_size(struct ifcvf_hw *hw)
>>   {
>>   	struct ifcvf_adapter *adapter;
>> +	u32 net_config_size = sizeof(struct virtio_net_config);
>> +	u32 blk_config_size = sizeof(struct virtio_blk_config);
>> +	u32 cap_size = hw->cap_dev_config_size;
>>   	u32 config_size;
>>   
>>   	adapter = vf_to_adapter(hw);
>> +	/* If the onboard device config space size is greater than
>> +	 * the size of struct virtio_net/blk_config, only the spec
>> +	 * implementing contents size is returned, this is very
>> +	 * unlikely, defensive programming.
>> +	 */
>>   	switch (hw->dev_type) {
>>   	case VIRTIO_ID_NET:
>> -		config_size = sizeof(struct virtio_net_config);
>> +		config_size = cap_size >= net_config_size ? net_config_size : cap_size;
>>   		break;
>>   	case VIRTIO_ID_BLOCK:
>> -		config_size = sizeof(struct virtio_blk_config);
>> +		config_size = cap_size >= blk_config_size ? blk_config_size : cap_size;
>>   		break;
>>   	default:
>>   		config_size = 0;
> There's a min macro for this.
yes, a min macro is better.

Thanks,
Zhu Lingshan
>
>> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
>> index 115b61f4924b..f5563f665cc6 100644
>> --- a/drivers/vdpa/ifcvf/ifcvf_base.h
>> +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
>> @@ -87,6 +87,8 @@ struct ifcvf_hw {
>>   	int config_irq;
>>   	int vqs_reused_irq;
>>   	u16 nr_vring;
>> +	/* VIRTIO_PCI_CAP_DEVICE_CFG size */
>> +	u32 cap_dev_config_size;
>>   };
>>   
>>   struct ifcvf_adapter {
>> -- 
>> 2.31.1

