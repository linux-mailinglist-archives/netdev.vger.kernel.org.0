Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 367DF56B2FF
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 08:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237134AbiGHGyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 02:54:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236525AbiGHGyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 02:54:44 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFFCF72EEC
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 23:54:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657263283; x=1688799283;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=VsisQ0BEWsEuR/P7mVfwoilpiFOxHfQOccotQUfXK8U=;
  b=U6fyzfCzcoAURGl8Z1eHGD57Xxb2OluQQL/GUc1xjsB1IqdwRbSiqoBK
   kXRZkWnbdQXAGmRCjjhf/yxCJYQGF15eIGI/N5SSpedrMlaiCKNc2qO2e
   CHR6OvrHPw1EocpDRdUs3pNN3Q4GvG6BsRayPwpM5I/j4tevzptX//FtB
   pRNbSIdM5KZqqq7qJBI6KtyfWvxnWmMTtX8RdOyqQHzgYxAFtqgdvAPmF
   guNGr1jgOwL1KCdyjbD7XGrWzei9y/QcDAbOg2NkX/sxm69kwNYuK7Nwh
   jzn8vfWay17apBHR867NMwRsFj5fvC5hRQtU/dxAr5Rpq7grDYkj5b1Q6
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10401"; a="284949574"
X-IronPort-AV: E=Sophos;i="5.92,254,1650956400"; 
   d="scan'208";a="284949574"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2022 23:54:31 -0700
X-IronPort-AV: E=Sophos;i="5.92,254,1650956400"; 
   d="scan'208";a="920893148"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.254.210.36]) ([10.254.210.36])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2022 23:54:28 -0700
Message-ID: <1a40a361-536f-c1a6-8a95-09df80014dc5@intel.com>
Date:   Fri, 8 Jul 2022 14:54:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH V3 2/6] vDPA/ifcvf: support userspace to query features
 and MQ of a management device
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        parav@nvidia.com, xieyongji@bytedance.com, gautam.dawar@amd.com
References: <20220701132826.8132-1-lingshan.zhu@intel.com>
 <20220701132826.8132-3-lingshan.zhu@intel.com>
 <c602c6c3-b38a-9543-2bb5-03be7d99fef3@redhat.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <c602c6c3-b38a-9543-2bb5-03be7d99fef3@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/4/2022 12:43 PM, Jason Wang wrote:
>
> 在 2022/7/1 21:28, Zhu Lingshan 写道:
>> Adapting to current netlink interfaces, this commit allows userspace
>> to query feature bits and MQ capability of a management device.
>>
>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>> ---
>>   drivers/vdpa/ifcvf/ifcvf_base.c | 12 ++++++++++++
>>   drivers/vdpa/ifcvf/ifcvf_base.h |  1 +
>>   drivers/vdpa/ifcvf/ifcvf_main.c |  3 +++
>>   3 files changed, 16 insertions(+)
>>
>> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c 
>> b/drivers/vdpa/ifcvf/ifcvf_base.c
>> index fb957b57941e..7c5f1cc93ad9 100644
>> --- a/drivers/vdpa/ifcvf/ifcvf_base.c
>> +++ b/drivers/vdpa/ifcvf/ifcvf_base.c
>> @@ -346,6 +346,18 @@ int ifcvf_set_vq_state(struct ifcvf_hw *hw, u16 
>> qid, u16 num)
>>       return 0;
>>   }
>>   +u16 ifcvf_get_max_vq_pairs(struct ifcvf_hw *hw)
>> +{
>> +    struct virtio_net_config __iomem *config;
>> +    u16 val, mq;
>> +
>> +    config = hw->dev_cfg;
>> +    val = vp_ioread16((__le16 __iomem *)&config->max_virtqueue_pairs);
>> +    mq = le16_to_cpu((__force __le16)val);
>> +
>> +    return mq;
>> +}
>> +
>>   static int ifcvf_hw_enable(struct ifcvf_hw *hw)
>>   {
>>       struct virtio_pci_common_cfg __iomem *cfg;
>> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h 
>> b/drivers/vdpa/ifcvf/ifcvf_base.h
>> index f5563f665cc6..d54a1bed212e 100644
>> --- a/drivers/vdpa/ifcvf/ifcvf_base.h
>> +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
>> @@ -130,6 +130,7 @@ u64 ifcvf_get_hw_features(struct ifcvf_hw *hw);
>>   int ifcvf_verify_min_features(struct ifcvf_hw *hw, u64 features);
>>   u16 ifcvf_get_vq_state(struct ifcvf_hw *hw, u16 qid);
>>   int ifcvf_set_vq_state(struct ifcvf_hw *hw, u16 qid, u16 num);
>> +u16 ifcvf_get_max_vq_pairs(struct ifcvf_hw *hw);
>>   struct ifcvf_adapter *vf_to_adapter(struct ifcvf_hw *hw);
>>   int ifcvf_probed_virtio_net(struct ifcvf_hw *hw);
>>   u32 ifcvf_get_config_size(struct ifcvf_hw *hw);
>> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c 
>> b/drivers/vdpa/ifcvf/ifcvf_main.c
>> index 0a5670729412..3ff7096d30f1 100644
>> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
>> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
>> @@ -791,6 +791,9 @@ static int ifcvf_vdpa_dev_add(struct 
>> vdpa_mgmt_dev *mdev, const char *name,
>>       vf->hw_features = ifcvf_get_hw_features(vf);
>>       vf->config_size = ifcvf_get_config_size(vf);
>>   +    ifcvf_mgmt_dev->mdev.max_supported_vqs = 
>> ifcvf_get_max_vq_pairs(vf);
>
>
> Do we want #qps or #queues?
>
> FYI, vp_vdpa did:
>
> drivers/vdpa/virtio_pci/vp_vdpa.c: mgtdev->max_supported_vqs = 
> vp_modern_get_num_queues(mdev);
Oh Yes, it should be the queues, will fix this

Thanks
>
> Thanks
>
>
>> + ifcvf_mgmt_dev->mdev.supported_features = vf->hw_features;
>> +
>>       adapter->vdpa.mdev = &ifcvf_mgmt_dev->mdev;
>>       ret = _vdpa_register_device(&adapter->vdpa, vf->nr_vring);
>>       if (ret) {
>

