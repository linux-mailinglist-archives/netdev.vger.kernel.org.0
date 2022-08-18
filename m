Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FBBF597EB9
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 08:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243706AbiHRGjF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 02:39:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233362AbiHRGjD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 02:39:03 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 598B3AE9DA;
        Wed, 17 Aug 2022 23:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660804742; x=1692340742;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3e6E6UGOJLm5YBLt6FyceJ6VTkOvzzJ7+5IJhYEVpFU=;
  b=d3ifrI95lmDesi4d/YNK5Kzfhqj1wCoBIEPCIbTCXvaWLTir+QNPuDh9
   9pakMfviewVfWWw+tarvxTH5dF2Ots79G/4MUlwQeqDnQIMlGf8U7O/2F
   VOMu/Knor1cfeS+hNVX8xjgVPizbStZ6GT9vUKJ4Y454VWLuU1Ubzifdv
   Vpu4pRb5qXC1UxF64Jwlz9DL8bOePEb7cljDlM+wTO1LodzcpNVoja+oh
   Gj5bhHrAM9RuGlO+xnHUQTJcscIKp4bC+zbi6yxhQ54MYYAtVKGXknWPa
   9IsO1INbuwbsPyNUO70RwUuFyIwAZpnzKPeeUaKukm9UOqWfKVLBIpU4g
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10442"; a="378972306"
X-IronPort-AV: E=Sophos;i="5.93,245,1654585200"; 
   d="scan'208";a="378972306"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2022 23:39:02 -0700
X-IronPort-AV: E=Sophos;i="5.93,245,1654585200"; 
   d="scan'208";a="636695073"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.255.28.224]) ([10.255.28.224])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2022 23:38:50 -0700
Message-ID: <132a0b6b-3074-965b-9155-7b9f8c528e41@intel.com>
Date:   Thu, 18 Aug 2022 14:38:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.12.0
Subject: Re: [PATCH 2/2] vDPA: conditionally read fields in virtio-net dev
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Parav Pandit <parav@nvidia.com>
Cc:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>
References: <20220815092638.504528-1-lingshan.zhu@intel.com>
 <20220815092638.504528-3-lingshan.zhu@intel.com>
 <PH0PR12MB54815EF8C19F70072169FA56DC6B9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <4184a943-f1c0-a57b-6411-bdd21e0bc710@intel.com>
 <PH0PR12MB5481EBA9E08963DEF0743063DC6B9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220816170753-mutt-send-email-mst@kernel.org>
 <352e9533-8ab1-cec0-0141-ce0735ee39f5@intel.com>
 <df2bab2d-2bc1-c3c2-f87c-dcc6bdc5737d@redhat.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <df2bab2d-2bc1-c3c2-f87c-dcc6bdc5737d@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/18/2022 12:18 PM, Jason Wang wrote:
>
> 在 2022/8/17 10:03, Zhu, Lingshan 写道:
>>
>>
>> On 8/17/2022 5:09 AM, Michael S. Tsirkin wrote:
>>> On Tue, Aug 16, 2022 at 09:02:17PM +0000, Parav Pandit wrote:
>>>>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
>>>>> Sent: Tuesday, August 16, 2022 12:19 AM
>>>>>
>>>>>
>>>>> On 8/16/2022 10:32 AM, Parav Pandit wrote:
>>>>>>> From: Zhu Lingshan <lingshan.zhu@intel.com>
>>>>>>> Sent: Monday, August 15, 2022 5:27 AM
>>>>>>>
>>>>>>> Some fields of virtio-net device config space are conditional on 
>>>>>>> the
>>>>>>> feature bits, the spec says:
>>>>>>>
>>>>>>> "The mac address field always exists
>>>>>>> (though is only valid if VIRTIO_NET_F_MAC is set)"
>>>>>>>
>>>>>>> "max_virtqueue_pairs only exists if VIRTIO_NET_F_MQ or
>>>>>>> VIRTIO_NET_F_RSS is set"
>>>>>>>
>>>>>>> "mtu only exists if VIRTIO_NET_F_MTU is set"
>>>>>>>
>>>>>>> so we should read MTU, MAC and MQ in the device config space only
>>>>>>> when these feature bits are offered.
>>>>>> Yes.
>>>>>>
>>>>>>> For MQ, if both VIRTIO_NET_F_MQ and VIRTIO_NET_F_RSS are not set,
>>>>> the
>>>>>>> virtio device should have one queue pair as default value, so when
>>>>>>> userspace querying queue pair numbers, it should return mq=1 
>>>>>>> than zero.
>>>>>> No.
>>>>>> No need to treat mac and max_qps differently.
>>>>>> It is meaningless to differentiate when field exist/not-exists vs 
>>>>>> value
>>>>> valid/not valid.
>>>>> as we discussed before, MQ has a default value 1, to be a 
>>>>> functional virtio-
>>>>> net device, while MAC has no default value, if no VIRTIO_NET_F_MAC 
>>>>> set,
>>>>> the driver should generate a random MAC.
>>>>>>> For MTU, if VIRTIO_NET_F_MTU is not set, we should not read MTU 
>>>>>>> from
>>>>>>> the device config sapce.
>>>>>>> RFC894 <A Standard for the Transmission of IP Datagrams over 
>>>>>>> Ethernet
>>>>>>> Networks> says:"The minimum length of the data field of a packet 
>>>>>>> sent
>>>>>>> Networks> over
>>>>>>> an Ethernet is 1500 octets, thus the maximum length of an IP 
>>>>>>> datagram
>>>>>>> sent over an Ethernet is 1500 octets. Implementations are 
>>>>>>> encouraged
>>>>>>> to support full-length packets"
>>>>>> This line in the RFC 894 of 1984 is wrong.
>>>>>> Errata already exists for it at [1].
>>>>>>
>>>>>> [1] 
>>>>>> https://www.rfc-editor.org/errata_search.php?rfc=894&rec_status=0
>>>>> OK, so I think we should return nothing if _F_MTU not set, like 
>>>>> handling the
>>>>> MAC
>>>>>>> virtio spec says:"The virtio network device is a virtual ethernet
>>>>>>> card", so the default MTU value should be 1500 for virtio-net.
>>>>>>>
>>>>>> Practically I have seen 1500 and highe mtu.
>>>>>> And this derivation is not good of what should be the default mtu 
>>>>>> as above
>>>>> errata exists.
>>>>>> And I see the code below why you need to work so hard to define a 
>>>>>> default
>>>>> value so that _MQ and _MTU can report default values.
>>>>>> There is really no need for this complexity and such a long commit
>>>>> message.
>>>>>> Can we please expose feature bits as-is and report config space 
>>>>>> field which
>>>>> are valid?
>>>>>> User space will be querying both.
>>>>> I think MAC and MTU don't have default values, so return nothing 
>>>>> if the
>>>>> feature bits not set,
>>>>> for MQ, it is still max_vq_paris == 1 by default.
>>>> I have stressed enough to highlight the fact that we don’t want to 
>>>> start digging default/no default, valid/no-valid part of the spec.
>>>> I prefer kernel to reporting fields that _exists_ in the config 
>>>> space and are valid.
>>>> I will let MST to handle the maintenance nightmare that this kind 
>>>> of patch brings in without any visible gain to user 
>>>> space/orchestration apps.
>>>>
>>>> A logic that can be easily build in user space, should be written 
>>>> in user space.
>>>> I conclude my thoughts here for this discussion.
>>>>
>>>> I will let MST to decide how he prefers to proceed.
>>>>
>>>>>>> +    if ((features & BIT_ULL(VIRTIO_NET_F_MTU)) == 0)
>>>>>>> +        val_u16 = 1500;
>>>>>>> +    else
>>>>>>> +        val_u16 = __virtio16_to_cpu(true, config->mtu);
>>>>>>> +
>>>>>> Need to work hard to find default values and that too turned out had
>>>>> errata.
>>>>>> There are more fields that doesn’t have default values.
>>>>>>
>>>>>> There is no point in kernel doing this guess work, that user 
>>>>>> space can figure
>>>>> out of what is valid/invalid.
>>>>> It's not guest work, when guest finds no feature bits set, it can 
>>>>> decide what
>>>>> to do.
>>>> Above code of doing 1500 was probably an honest attempt to find a 
>>>> legitimate default value, and we saw that it doesn’t work.
>>>> This is second example after _MQ that we both agree should not 
>>>> return default.
>>>>
>>>> And there are more fields coming in this area.
>>>> Hence, I prefer to not avoid returning such defaults for MAC, MTU, 
>>>> MQ and rest all fields which doesn’t _exists_.
>>>>
>>>> I will let MST to decide how he prefers to proceed for every field 
>>>> to come next.
>>>> Thanks.
>>>>
>>>
>>> If MTU does not return a value without _F_MTU, and MAC does not return
>>> a value without _F_MAC then IMO yes, number of queues should not return
>>> a value without _F_MQ.
>> sure I can do this, but may I ask whether it is a final decision, I 
>> remember you supported max_queue_paris = 1 without _F_MQ before
>
>
> I think we just need to be consistent:
>
> Either
>
> 1) make field conditional to align with spec
>
> or
>
> 2) always return a value even if the feature is not set
>
> It seems to me 1) is easier.
>
> Thanks
I will pick 1

Thanks
>
>
>>
>> Thanks
>>>
>>>
>>
>

