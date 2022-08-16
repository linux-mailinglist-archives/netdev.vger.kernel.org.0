Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67B6F5953F3
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 09:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232213AbiHPHgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 03:36:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232164AbiHPHez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 03:34:55 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 182FA198EC4;
        Mon, 15 Aug 2022 21:18:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660623524; x=1692159524;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=6de6Rx9nxeGmOpm+2sYR/0ilW9PghPT1d+klNjf9GdQ=;
  b=Sobbq1XR5vJ8BUify52uIrF9e6RT5u/AfB4KSfNWLNwUYMnhzCd+qfrW
   F2hALPc9AZ6pK0Sm1bxWb/RB60Wq4jze/xu84c1CFJybIFnbTwjz7w56C
   0S/tBquI6OhlvYK0C8Pf7nNUqrN4f3NEcwv4xuy2vEXq4VvLpCuT6lrNL
   Jmw5KtUUY4OgDRgHUjUQ0N9oVzZfchwYnIjO/GnWrzagspfaGsLpPTL0U
   v/9dJRkPQ2FB/dKi/2UeAehURCaNlsfCIfi19GOJwMX2U8C68NMaBe4BY
   Ikzvlz1sDXkyen+5tuKs0IGSQWDQiDUNCSqkhNjpaYx1sfc+y+pU0Rm8K
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10440"; a="289690529"
X-IronPort-AV: E=Sophos;i="5.93,240,1654585200"; 
   d="scan'208";a="289690529"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2022 21:18:43 -0700
X-IronPort-AV: E=Sophos;i="5.93,240,1654585200"; 
   d="scan'208";a="666936857"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.255.29.22]) ([10.255.29.22])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2022 21:18:39 -0700
Message-ID: <4184a943-f1c0-a57b-6411-bdd21e0bc710@intel.com>
Date:   Tue, 16 Aug 2022 12:18:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.12.0
Subject: Re: [PATCH 2/2] vDPA: conditionally read fields in virtio-net dev
Content-Language: en-US
To:     Parav Pandit <parav@nvidia.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>
Cc:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>
References: <20220815092638.504528-1-lingshan.zhu@intel.com>
 <20220815092638.504528-3-lingshan.zhu@intel.com>
 <PH0PR12MB54815EF8C19F70072169FA56DC6B9@PH0PR12MB5481.namprd12.prod.outlook.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <PH0PR12MB54815EF8C19F70072169FA56DC6B9@PH0PR12MB5481.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/16/2022 10:32 AM, Parav Pandit wrote:
>> From: Zhu Lingshan <lingshan.zhu@intel.com>
>> Sent: Monday, August 15, 2022 5:27 AM
>>
>> Some fields of virtio-net device config space are conditional on the feature
>> bits, the spec says:
>>
>> "The mac address field always exists
>> (though is only valid if VIRTIO_NET_F_MAC is set)"
>>
>> "max_virtqueue_pairs only exists if VIRTIO_NET_F_MQ or
>> VIRTIO_NET_F_RSS is set"
>>
>> "mtu only exists if VIRTIO_NET_F_MTU is set"
>>
>> so we should read MTU, MAC and MQ in the device config space only when
>> these feature bits are offered.
> Yes.
>
>> For MQ, if both VIRTIO_NET_F_MQ and VIRTIO_NET_F_RSS are not set, the
>> virtio device should have one queue pair as default value, so when userspace
>> querying queue pair numbers, it should return mq=1 than zero.
> No.
> No need to treat mac and max_qps differently.
> It is meaningless to differentiate when field exist/not-exists vs value valid/not valid.
as we discussed before, MQ has a default value 1, to be a functional 
virtio-net device,
while MAC has no default value, if no VIRTIO_NET_F_MAC set, the driver 
should generate
a random MAC.
>
>> For MTU, if VIRTIO_NET_F_MTU is not set, we should not read MTU from
>> the device config sapce.
>> RFC894 <A Standard for the Transmission of IP Datagrams over Ethernet
>> Networks> says:"The minimum length of the data field of a packet sent over
>> an Ethernet is 1500 octets, thus the maximum length of an IP datagram sent
>> over an Ethernet is 1500 octets.  Implementations are encouraged to support
>> full-length packets"
> This line in the RFC 894 of 1984 is wrong.
> Errata already exists for it at [1].
>
> [1] https://www.rfc-editor.org/errata_search.php?rfc=894&rec_status=0
OK, so I think we should return nothing if _F_MTU not set, like handling 
the MAC
>
>> virtio spec says:"The virtio network device is a virtual ethernet card", so the
>> default MTU value should be 1500 for virtio-net.
>>
> Practically I have seen 1500 and highe mtu.
> And this derivation is not good of what should be the default mtu as above errata exists.
>
> And I see the code below why you need to work so hard to define a default value so that _MQ and _MTU can report default values.
>
> There is really no need for this complexity and such a long commit message.
>
> Can we please expose feature bits as-is and report config space field which are valid?
>
> User space will be querying both.
I think MAC and MTU don't have default values, so return nothing if the 
feature bits not set,
for MQ, it is still max_vq_paris == 1 by default.
>
>> For MAC, the spec says:"If the VIRTIO_NET_F_MAC feature bit is set, the
>> configuration space mac entry indicates the “physical” address of the
>> network card, otherwise the driver would typically generate a random local
>> MAC address." So there is no default MAC address if VIRTIO_NET_F_MAC
>> not set.
>>
>> This commits introduces functions vdpa_dev_net_mtu_config_fill() and
>> vdpa_dev_net_mac_config_fill() to fill MTU and MAC.
>> It also fixes vdpa_dev_net_mq_config_fill() to report correct MQ when
>> _F_MQ is not present.
>>
> Multiple changes in single patch are not good idea.
> Its ok to split to smaller patches.
OK, I can try to split it.
>
>> +	if ((features & BIT_ULL(VIRTIO_NET_F_MTU)) == 0)
>> +		val_u16 = 1500;
>> +	else
>> +		val_u16 = __virtio16_to_cpu(true, config->mtu);
>> +
> Need to work hard to find default values and that too turned out had errata.
> There are more fields that doesn’t have default values.
>
> There is no point in kernel doing this guess work, that user space can figure out of what is valid/invalid.
It's not guest work, when guest finds no feature bits set, it can decide 
what to do. These code only for the
user space, just MST ever suggest, if there is a default value, we can 
return it from the kernel, once for all.

Thanks
>

