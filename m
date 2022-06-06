Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7AF453E35B
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 10:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbiFFIRt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 04:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231665AbiFFIRr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 04:17:47 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8638B19C03
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 01:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654503465; x=1686039465;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Ih6smTLwrxUtDtULp0+nLqvxelLQm5q7Jv5XrIxao7s=;
  b=RyqnDvusrwsFD58Pz7BcmQfxf//0DPKAxMGxly/6H7mXFCCsh2qB8LQ1
   C9hHJgGcMNyobs2GYt6FDqC26YwbnNTDHmiV+cWyxyuJ3vuTfBM0Tyk1h
   j/Kk05n1MtmROWN7ny/vJKfQ5RGxAhutOZSGza4PEQ5Dm6gmbc8guY+RS
   sAZXsLPq3yPrZqWLTKm5c1CoSmBMXLZezXetu07bpDec/1UySiaFBHx16
   o2hqclpwv/xfz9vbvTNVnu9vwuiqOqEFARIX/btJ/tapr6P/AEjeEEexW
   uzdS+ihnUmYw49kqa9KNcV5i6QgU7EcuGiYTmYoS+BzHLEKlEf5NrbRaE
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10369"; a="257079378"
X-IronPort-AV: E=Sophos;i="5.91,280,1647327600"; 
   d="scan'208";a="257079378"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2022 01:17:45 -0700
X-IronPort-AV: E=Sophos;i="5.91,280,1647327600"; 
   d="scan'208";a="583512421"
Received: from fengjia-mobl2.ccr.corp.intel.com (HELO [10.254.210.182]) ([10.254.210.182])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2022 01:17:43 -0700
Message-ID: <6d7a6da6-2c7e-d006-a225-4cd67f9b9c31@intel.com>
Date:   Mon, 6 Jun 2022 16:17:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.1
Subject: Re: [PATCH 1/6] vDPA/ifcvf: get_config_size should return a value no
 greater than dev implementation
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst <mst@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>
References: <20220602023845.2596397-1-lingshan.zhu@intel.com>
 <20220602023845.2596397-2-lingshan.zhu@intel.com>
 <CACGkMEsdKaWjmOncpLo1MO1DM2KDpE61KbH8uKBrnCqCxFubvw@mail.gmail.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <CACGkMEsdKaWjmOncpLo1MO1DM2KDpE61KbH8uKBrnCqCxFubvw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/2/2022 3:11 PM, Jason Wang wrote:
> On Thu, Jun 2, 2022 at 10:48 AM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
>> ifcvf_get_config_size() should return a virtio device type specific value,
>> however the ret_value should not be greater than the onboard size of
>> the device implementation. E.g., for virtio_net, config_size should be
>> the minimum value of sizeof(struct virtio_net_config) and the onboard
>> cap size.
>>
>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>> ---
>>   drivers/vdpa/ifcvf/ifcvf_base.c | 8 ++++++--
>>   drivers/vdpa/ifcvf/ifcvf_base.h | 2 ++
>>   2 files changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c b/drivers/vdpa/ifcvf/ifcvf_base.c
>> index 48c4dadb0c7c..6bccc8291c26 100644
>> --- a/drivers/vdpa/ifcvf/ifcvf_base.c
>> +++ b/drivers/vdpa/ifcvf/ifcvf_base.c
>> @@ -128,6 +128,7 @@ int ifcvf_init_hw(struct ifcvf_hw *hw, struct pci_dev *pdev)
>>                          break;
>>                  case VIRTIO_PCI_CAP_DEVICE_CFG:
>>                          hw->dev_cfg = get_cap_addr(hw, &cap);
>> +                       hw->cap_dev_config_size = le32_to_cpu(cap.length);
> One possible issue here is that, if the hardware have more size than
> spec, we may end up with a migration compatibility issue.
>
> It looks to me we'd better build the config size based on the
> features, e.g it looks to me for net, we should probably use
>
> offset_of(struct virtio_net_config, mtu)?
Hi Jason,

our ifcvf devices have nothing out of the spec in the device config 
space, so I think we can trust the cap size
>
>>                          IFCVF_DBG(pdev, "hw->dev_cfg = %p\n", hw->dev_cfg);
>>                          break;
>>                  }
>> @@ -233,15 +234,18 @@ int ifcvf_verify_min_features(struct ifcvf_hw *hw, u64 features)
>>   u32 ifcvf_get_config_size(struct ifcvf_hw *hw)
>>   {
>>          struct ifcvf_adapter *adapter;
>> +       u32 net_config_size = sizeof(struct virtio_net_config);
>> +       u32 blk_config_size = sizeof(struct virtio_blk_config);
>> +       u32 cap_size = hw->cap_dev_config_size;
>>          u32 config_size;
>>
>>          adapter = vf_to_adapter(hw);
>>          switch (hw->dev_type) {
>>          case VIRTIO_ID_NET:
>> -               config_size = sizeof(struct virtio_net_config);
>> +               config_size = cap_size >= net_config_size ? net_config_size : cap_size;
> I don't get the code here, any chance that net_config_size could be zero?
This means, if the capability size is more than the size of structure 
virtio-net-cofnig,
there may be something out of the spec, then we only migrate the spec 
contents, which is
a defensive coding. If the capability size is smaller than the size in 
spec, means
the capability is a sub-set of the spec contents, we only migrate the 
onboard contents.

Sorry for the confusing, I will add a comment here.

Thanks
Zhu Lingshan
>
> Thanks
>
>>                  break;
>>          case VIRTIO_ID_BLOCK:
>> -               config_size = sizeof(struct virtio_blk_config);
>> +               config_size = cap_size >= blk_config_size ? blk_config_size : cap_size;
>>                  break;
>>          default:
>>                  config_size = 0;
>> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
>> index 115b61f4924b..f5563f665cc6 100644
>> --- a/drivers/vdpa/ifcvf/ifcvf_base.h
>> +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
>> @@ -87,6 +87,8 @@ struct ifcvf_hw {
>>          int config_irq;
>>          int vqs_reused_irq;
>>          u16 nr_vring;
>> +       /* VIRTIO_PCI_CAP_DEVICE_CFG size */
>> +       u32 cap_dev_config_size;
>>   };
>>
>>   struct ifcvf_adapter {
>> --
>> 2.31.1
>>

