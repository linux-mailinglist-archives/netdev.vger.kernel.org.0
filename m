Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 230EE59672B
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 04:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238498AbiHQCDx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 22:03:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238457AbiHQCDk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 22:03:40 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A9AE95AC7;
        Tue, 16 Aug 2022 19:03:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660701812; x=1692237812;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=dl7DZK7xwAHmVqPwuvCPEvVjDWc0EuOKC0VSZ2rqSM4=;
  b=eBxFQ9vsONEo99TlYsvZrkE9k5vK03TuSdoh+WwMhcLR9eIup1ffc+yV
   f7tIZJGQJNRLxbz6pkpdjWKF1CPTJPSNRXnm7h8rP8J2IIAd8RGaLShTU
   41IegKLro/aPih1mIpKXXhZ2w0XUXQvXKGG/JPH3c2BNQqkXAHoyzrdpf
   eWLs/m7WNKtPjwUbri9LkdfDkqZ6gJBjSJ81UWLck+/4tXPvRk7e9LmK+
   g30XTJjEMSZ2C7fqOWvG7vSdzXicLVGkDZHraVmt9P0eyII1KsfzV/Mca
   5LRrhnO8OVeB2KNjhcJHHj7xXhlwjlGKP2zBi+8JTQ7r3sAoLx+1UubCI
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10441"; a="289949021"
X-IronPort-AV: E=Sophos;i="5.93,242,1654585200"; 
   d="scan'208";a="289949021"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 19:03:24 -0700
X-IronPort-AV: E=Sophos;i="5.93,242,1654585200"; 
   d="scan'208";a="667392119"
Received: from pregnie-mobl1.ccr.corp.intel.com (HELO [10.255.30.246]) ([10.255.30.246])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 19:03:21 -0700
Message-ID: <352e9533-8ab1-cec0-0141-ce0735ee39f5@intel.com>
Date:   Wed, 17 Aug 2022 10:03:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.12.0
Subject: Re: [PATCH 2/2] vDPA: conditionally read fields in virtio-net dev
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Parav Pandit <parav@nvidia.com>
Cc:     "jasowang@redhat.com" <jasowang@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
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
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <20220816170753-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/17/2022 5:09 AM, Michael S. Tsirkin wrote:
> On Tue, Aug 16, 2022 at 09:02:17PM +0000, Parav Pandit wrote:
>>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
>>> Sent: Tuesday, August 16, 2022 12:19 AM
>>>
>>>
>>> On 8/16/2022 10:32 AM, Parav Pandit wrote:
>>>>> From: Zhu Lingshan <lingshan.zhu@intel.com>
>>>>> Sent: Monday, August 15, 2022 5:27 AM
>>>>>
>>>>> Some fields of virtio-net device config space are conditional on the
>>>>> feature bits, the spec says:
>>>>>
>>>>> "The mac address field always exists
>>>>> (though is only valid if VIRTIO_NET_F_MAC is set)"
>>>>>
>>>>> "max_virtqueue_pairs only exists if VIRTIO_NET_F_MQ or
>>>>> VIRTIO_NET_F_RSS is set"
>>>>>
>>>>> "mtu only exists if VIRTIO_NET_F_MTU is set"
>>>>>
>>>>> so we should read MTU, MAC and MQ in the device config space only
>>>>> when these feature bits are offered.
>>>> Yes.
>>>>
>>>>> For MQ, if both VIRTIO_NET_F_MQ and VIRTIO_NET_F_RSS are not set,
>>> the
>>>>> virtio device should have one queue pair as default value, so when
>>>>> userspace querying queue pair numbers, it should return mq=1 than zero.
>>>> No.
>>>> No need to treat mac and max_qps differently.
>>>> It is meaningless to differentiate when field exist/not-exists vs value
>>> valid/not valid.
>>> as we discussed before, MQ has a default value 1, to be a functional virtio-
>>> net device, while MAC has no default value, if no VIRTIO_NET_F_MAC set,
>>> the driver should generate a random MAC.
>>>>> For MTU, if VIRTIO_NET_F_MTU is not set, we should not read MTU from
>>>>> the device config sapce.
>>>>> RFC894 <A Standard for the Transmission of IP Datagrams over Ethernet
>>>>> Networks> says:"The minimum length of the data field of a packet sent
>>>>> Networks> over
>>>>> an Ethernet is 1500 octets, thus the maximum length of an IP datagram
>>>>> sent over an Ethernet is 1500 octets.  Implementations are encouraged
>>>>> to support full-length packets"
>>>> This line in the RFC 894 of 1984 is wrong.
>>>> Errata already exists for it at [1].
>>>>
>>>> [1] https://www.rfc-editor.org/errata_search.php?rfc=894&rec_status=0
>>> OK, so I think we should return nothing if _F_MTU not set, like handling the
>>> MAC
>>>>> virtio spec says:"The virtio network device is a virtual ethernet
>>>>> card", so the default MTU value should be 1500 for virtio-net.
>>>>>
>>>> Practically I have seen 1500 and highe mtu.
>>>> And this derivation is not good of what should be the default mtu as above
>>> errata exists.
>>>> And I see the code below why you need to work so hard to define a default
>>> value so that _MQ and _MTU can report default values.
>>>> There is really no need for this complexity and such a long commit
>>> message.
>>>> Can we please expose feature bits as-is and report config space field which
>>> are valid?
>>>> User space will be querying both.
>>> I think MAC and MTU don't have default values, so return nothing if the
>>> feature bits not set,
>>> for MQ, it is still max_vq_paris == 1 by default.
>> I have stressed enough to highlight the fact that we don’t want to start digging default/no default, valid/no-valid part of the spec.
>> I prefer kernel to reporting fields that _exists_ in the config space and are valid.
>> I will let MST to handle the maintenance nightmare that this kind of patch brings in without any visible gain to user space/orchestration apps.
>>
>> A logic that can be easily build in user space, should be written in user space.
>> I conclude my thoughts here for this discussion.
>>
>> I will let MST to decide how he prefers to proceed.
>>
>>>>> +	if ((features & BIT_ULL(VIRTIO_NET_F_MTU)) == 0)
>>>>> +		val_u16 = 1500;
>>>>> +	else
>>>>> +		val_u16 = __virtio16_to_cpu(true, config->mtu);
>>>>> +
>>>> Need to work hard to find default values and that too turned out had
>>> errata.
>>>> There are more fields that doesn’t have default values.
>>>>
>>>> There is no point in kernel doing this guess work, that user space can figure
>>> out of what is valid/invalid.
>>> It's not guest work, when guest finds no feature bits set, it can decide what
>>> to do.
>> Above code of doing 1500 was probably an honest attempt to find a legitimate default value, and we saw that it doesn’t work.
>> This is second example after _MQ that we both agree should not return default.
>>
>> And there are more fields coming in this area.
>> Hence, I prefer to not avoid returning such defaults for MAC, MTU, MQ and rest all fields which doesn’t _exists_.
>>
>> I will let MST to decide how he prefers to proceed for every field to come next.
>> Thanks.
>>
>
> If MTU does not return a value without _F_MTU, and MAC does not return
> a value without _F_MAC then IMO yes, number of queues should not return
> a value without _F_MQ.
sure I can do this, but may I ask whether it is a final decision, I 
remember you supported max_queue_paris = 1 without _F_MQ before

Thanks
>
>

