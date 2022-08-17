Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4D9A59674E
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 04:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238473AbiHQCOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 22:14:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235578AbiHQCOd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 22:14:33 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D9698C96;
        Tue, 16 Aug 2022 19:14:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660702471; x=1692238471;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0DeoIIzv9WJmJ1GTi9HjjtUrzPh0pXidbiDY3Az4408=;
  b=N4nZYH7t1/kn0LJrO6o+0G06sxzhMxROJxO9tBHCBx2rlnxRYl6eHoyN
   uIVdBRvM/5+uD/O874Sxh6WmwkkMN4NiRczzgmYFu/F9FdCupYpjdqnf8
   W0ineQeYVfCxwR7sb7NRRxGiVSbg1mKFjdn/qhjQ7Ngamp3SW0QTLQ3bG
   EwxEjMoyqtThjc0pEPjQlWW+asNVPNHGTdNmlow7ve+sar1OprqWAN4/l
   /Kb6hwB1ETs3+UVTFYT+kDH4zhUsgu12ie+rATb2vwbqSiDyANkQOR1bt
   YNtNHPDmONZas01Y0Hoi9PerMTacMhWSDPOqAvpZdi9FuEQG4AiI59BT8
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10441"; a="291132858"
X-IronPort-AV: E=Sophos;i="5.93,242,1654585200"; 
   d="scan'208";a="291132858"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 19:14:31 -0700
X-IronPort-AV: E=Sophos;i="5.93,242,1654585200"; 
   d="scan'208";a="667395570"
Received: from pregnie-mobl1.ccr.corp.intel.com (HELO [10.255.30.246]) ([10.255.30.246])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2022 19:14:28 -0700
Message-ID: <52a47bc7-bf26-b8f9-257f-7dc5cea66d23@intel.com>
Date:   Wed, 17 Aug 2022 10:14:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.12.0
Subject: Re: [PATCH 2/2] vDPA: conditionally read fields in virtio-net dev
Content-Language: en-US
To:     Si-Wei Liu <si-wei.liu@oracle.com>, jasowang@redhat.com,
        mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, parav@nvidia.com, xieyongji@bytedance.com,
        gautam.dawar@amd.com
References: <20220815092638.504528-1-lingshan.zhu@intel.com>
 <20220815092638.504528-3-lingshan.zhu@intel.com>
 <c5075d3d-9d2c-2716-1cbf-cede49e2d66f@oracle.com>
 <20e92551-a639-ec13-3d9c-13bb215422e1@intel.com>
 <9b6292f3-9bd5-ecd8-5e42-cd5d12f036e7@oracle.com>
 <22e0236f-b556-c6a8-0043-b39b02928fd6@intel.com>
 <892b39d6-85f8-bff5-030d-e21288975572@oracle.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <892b39d6-85f8-bff5-030d-e21288975572@oracle.com>
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



On 8/17/2022 7:14 AM, Si-Wei Liu wrote:
>
>
> On 8/16/2022 2:08 AM, Zhu, Lingshan wrote:
>>
>>
>> On 8/16/2022 3:58 PM, Si-Wei Liu wrote:
>>>
>>>
>>> On 8/15/2022 6:58 PM, Zhu, Lingshan wrote:
>>>>
>>>>
>>>> On 8/16/2022 7:32 AM, Si-Wei Liu wrote:
>>>>>
>>>>>
>>>>> On 8/15/2022 2:26 AM, Zhu Lingshan wrote:
>>>>>> Some fields of virtio-net device config space are
>>>>>> conditional on the feature bits, the spec says:
>>>>>>
>>>>>> "The mac address field always exists
>>>>>> (though is only valid if VIRTIO_NET_F_MAC is set)"
>>>>>>
>>>>>> "max_virtqueue_pairs only exists if VIRTIO_NET_F_MQ
>>>>>> or VIRTIO_NET_F_RSS is set"
>>>>>>
>>>>>> "mtu only exists if VIRTIO_NET_F_MTU is set"
>>>>>>
>>>>>> so we should read MTU, MAC and MQ in the device config
>>>>>> space only when these feature bits are offered.
>>>>>>
>>>>>> For MQ, if both VIRTIO_NET_F_MQ and VIRTIO_NET_F_RSS are
>>>>>> not set, the virtio device should have
>>>>>> one queue pair as default value, so when userspace querying queue 
>>>>>> pair numbers,
>>>>>> it should return mq=1 than zero.
>>>>>>
>>>>>> For MTU, if VIRTIO_NET_F_MTU is not set, we should not read
>>>>>> MTU from the device config sapce.
>>>>>> RFC894 <A Standard for the Transmission of IP Datagrams over 
>>>>>> Ethernet Networks>
>>>>>> says:"The minimum length of the data field of a packet sent over an
>>>>>> Ethernet is 1500 octets, thus the maximum length of an IP datagram
>>>>>> sent over an Ethernet is 1500 octets.  Implementations are 
>>>>>> encouraged
>>>>>> to support full-length packets"
>>>>> Noted there's a typo in the above "The *maximum* length of the 
>>>>> data field of a packet sent over an Ethernet is 1500 octets ..." 
>>>>> and the RFC was written 1984.
>>>> the spec RFC894 says it is 1500, see <a 
>>>> href="https://urldefense.com/v3/__https://www.rfc-editor.org/rfc/rfc894.txt__;!!ACWV5N9M2RV99hQ!MdgxZjw5sp5Qz-GKfwT1IWcw_L4Jo1-UekuJPFz1UrG3YuqirKz7P9ksdJFh1vB6zHJ7z8Q04fpT0-9jWXCtlWM$">https://urldefense.com/v3/__https://www.rfc-editor.org/rfc/rfc894.txt__;!!ACWV5N9M2RV99hQ!KVwfun0b1Q59Ajp6O7JrB-BuEBSLyQ9e95oGq1cVG_sQIPDL0whI5frx1EGoQFznmm67RsEeJTrUdfYrmZPRFaM$ 
>>>> </a>
>>>>>
>>>>> Apparently that is no longer true with the introduction of Jumbo 
>>>>> size frame later in the 2000s. I'm not sure what is the point of 
>>>>> mention this ancient RFC. It doesn't say default MTU of any 
>>>>> Ethernet NIC/switch should be 1500 in either  case.
>>>> This could be a larger number for sure, we are trying to find out 
>>>> the min value for Ethernet here, to support 1500 octets, MTU should 
>>>> be 1500 at least, so I assume 1500 should be the default value for MTU
>>>>>
>>>>>>
>>>>>> virtio spec says:"The virtio network device is a virtual ethernet 
>>>>>> card",
>>>>> Right,
>>>>>> so the default MTU value should be 1500 for virtio-net.
>>>>> ... but it doesn't say the default is 1500. At least, not in 
>>>>> explicit way. Why it can't be 1492 or even lower? In practice, if 
>>>>> the network backend has a MTU higher than 1500, there's nothing 
>>>>> wrong for guest to configure default MTU more than 1500.
>>>> same as above
>>>>>
>>>>>>
>>>>>> For MAC, the spec says:"If the VIRTIO_NET_F_MAC feature bit is set,
>>>>>> the configuration space mac entry indicates the “physical” address
>>>>>> of the network card, otherwise the driver would typically
>>>>>> generate a random local MAC address." So there is no
>>>>>> default MAC address if VIRTIO_NET_F_MAC not set.
>>>>>>
>>>>>> This commits introduces functions vdpa_dev_net_mtu_config_fill()
>>>>>> and vdpa_dev_net_mac_config_fill() to fill MTU and MAC.
>>>>>> It also fixes vdpa_dev_net_mq_config_fill() to report correct
>>>>>> MQ when _F_MQ is not present.
>>>>>>
>>>>>> These functions should check devices features than driver
>>>>>> features, and struct vdpa_device is not needed as a parameter
>>>>>>
>>>>>> The test & userspace tool output:
>>>>>>
>>>>>> Feature bit VIRTIO_NET_F_MTU, VIRTIO_NET_F_RSS, VIRTIO_NET_F_MQ
>>>>>> and VIRTIO_NET_F_MAC can be mask out by hardcode.
>>>>>>
>>>>>> However, it is challenging to "disable" the related fields
>>>>>> in the HW device config space, so let's just assume the values
>>>>>> are meaningless if the feature bits are not set.
>>>>>>
>>>>>> Before this change, when feature bits for RSS, MQ, MTU and MAC
>>>>>> are not set, iproute2 output:
>>>>>> $vdpa vdpa0: mac 00:e8:ca:11:be:05 link up link_announce false 
>>>>>> mtu 1500
>>>>>>    negotiated_features
>>>>>>
>>>>>> without this commit, function vdpa_dev_net_config_fill()
>>>>>> reads all config space fields unconditionally, so let's
>>>>>> assume the MAC and MTU are meaningless, and it checks
>>>>>> MQ with driver_features, so we don't see max_vq_pairs.
>>>>>>
>>>>>> After applying this commit, when feature bits for
>>>>>> MQ, RSS, MAC and MTU are not set,iproute2 output:
>>>>>> $vdpa dev config show vdpa0
>>>>>> vdpa0: link up link_announce false max_vq_pairs 1 mtu 1500
>>>>>>    negotiated_features
>>>>>>
>>>>>> As explained above:
>>>>>> Here is no MAC, because VIRTIO_NET_F_MAC is not set,
>>>>>> and there is no default value for MAC. It shows
>>>>>> max_vq_paris = 1 because even without MQ feature,
>>>>>> a functional virtio-net must have one queue pair.
>>>>>> mtu = 1500 is the default value as ethernet
>>>>>> required.
>>>>>>
>>>>>> This commit also add supplementary comments for
>>>>>> __virtio16_to_cpu(true, xxx) operations in
>>>>>> vdpa_dev_net_config_fill() and vdpa_fill_stats_rec()
>>>>>>
>>>>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>>>>> ---
>>>>>>   drivers/vdpa/vdpa.c | 60 
>>>>>> +++++++++++++++++++++++++++++++++++----------
>>>>>>   1 file changed, 47 insertions(+), 13 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
>>>>>> index efb55a06e961..a74660b98979 100644
>>>>>> --- a/drivers/vdpa/vdpa.c
>>>>>> +++ b/drivers/vdpa/vdpa.c
>>>>>> @@ -801,19 +801,44 @@ static int 
>>>>>> vdpa_nl_cmd_dev_get_dumpit(struct sk_buff *msg, struct 
>>>>>> netlink_callba
>>>>>>       return msg->len;
>>>>>>   }
>>>>>>   -static int vdpa_dev_net_mq_config_fill(struct vdpa_device *vdev,
>>>>>> -                       struct sk_buff *msg, u64 features,
>>>>>> +static int vdpa_dev_net_mq_config_fill(struct sk_buff *msg, u64 
>>>>>> features,
>>>>>>                          const struct virtio_net_config *config)
>>>>>>   {
>>>>>>       u16 val_u16;
>>>>>>   -    if ((features & BIT_ULL(VIRTIO_NET_F_MQ)) == 0)
>>>>>> -        return 0;
>>>>>> +    if ((features & BIT_ULL(VIRTIO_NET_F_MQ)) == 0 &&
>>>>>> +        (features & BIT_ULL(VIRTIO_NET_F_RSS)) == 0)
>>>>>> +        val_u16 = 1;
>>>>>> +    else
>>>>>> +        val_u16 = __virtio16_to_cpu(true, 
>>>>>> config->max_virtqueue_pairs);
>>>>>>   -    val_u16 = le16_to_cpu(config->max_virtqueue_pairs);
>>>>>>       return nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, 
>>>>>> val_u16);
>>>>>>   }
>>>>>>   +static int vdpa_dev_net_mtu_config_fill(struct sk_buff *msg, 
>>>>>> u64 features,
>>>>>> +                    const struct virtio_net_config *config)
>>>>>> +{
>>>>>> +    u16 val_u16;
>>>>>> +
>>>>>> +    if ((features & BIT_ULL(VIRTIO_NET_F_MTU)) == 0)
>>>>>> +        val_u16 = 1500;
>>>>> As said, there's no virtio spec defined value for MTU. Please 
>>>>> leave this field out if feature VIRTIO_NET_F_MTU is not negotiated.
>>>> same as above
>>>>>> +    else
>>>>>> +        val_u16 = __virtio16_to_cpu(true, config->mtu);
>>>>>> +
>>>>>> +    return nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16);
>>>>>> +}
>>>>>> +
>>>>>> +static int vdpa_dev_net_mac_config_fill(struct sk_buff *msg, u64 
>>>>>> features,
>>>>>> +                    const struct virtio_net_config *config)
>>>>>> +{
>>>>>> +    if ((features & BIT_ULL(VIRTIO_NET_F_MAC)) == 0)
>>>>>> +        return 0;
>>>>>> +    else
>>>>>> +        return  nla_put(msg, VDPA_ATTR_DEV_NET_CFG_MACADDR,
>>>>>> +                sizeof(config->mac), config->mac);
>>>>>> +}
>>>>>> +
>>>>>> +
>>>>>>   static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, 
>>>>>> struct sk_buff *msg)
>>>>>>   {
>>>>>>       struct virtio_net_config config = {};
>>>>>> @@ -822,18 +847,16 @@ static int vdpa_dev_net_config_fill(struct 
>>>>>> vdpa_device *vdev, struct sk_buff *ms
>>>>>>         vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config));
>>>>>>   -    if (nla_put(msg, VDPA_ATTR_DEV_NET_CFG_MACADDR, 
>>>>>> sizeof(config.mac),
>>>>>> -            config.mac))
>>>>>> -        return -EMSGSIZE;
>>>>>> +    /*
>>>>>> +     * Assume little endian for now, userspace can tweak this for
>>>>>> +     * legacy guest support.
>>>>> You can leave it as a TODO for kernel (vdpa core limitation), but 
>>>>> AFAIK there's nothing userspace needs to do to infer the 
>>>>> endianness. IMHO it's the kernel's job to provide an abstraction 
>>>>> rather than rely on userspace guessing it.
>>>> we have discussed it in another thread, and this comment is 
>>>> suggested by MST.
>>> Can you provide the context or link? It shouldn't work like this, 
>>> otherwise it is breaking uABI. E.g. how will a legacy/BE supporting 
>>> kernel/device be backward compatible with older vdpa tool (which has 
>>> knowledge of this endianness implication/assumption from day one)?
>> https://urldefense.com/v3/__https://www.spinics.net/lists/netdev/msg837114.html__;!!ACWV5N9M2RV99hQ!KVwfun0b1Q59Ajp6O7JrB-BuEBSLyQ9e95oGq1cVG_sQIPDL0whI5frx1EGoQFznmm67RsEeJTrUdfYrGq7Vwjk$ 
>>
>> The challenge is that the status filed is virtio16, not le16, so 
>> le16_to_cpu(xxx) is wrong anyway. However we can not tell whether it 
>> is a LE or BE device from struct vdpa_device, so for most cases, we 
>> assume it is LE, and leave this comment.
> While the fix is fine, the comment is misleading in giving readers 
> false hope. This is in vdpa_dev_net_config_fill() the vdpa tool query 
> path, instead of calls from the VMM dealing with vhost/virtio plumbing 
> specifics. I think what's missing today in vdpa core is the detection 
> of guest type (legacy, transitional, or modern) regarding endianness 
> through F_VERSION_1 and legacy interface access, the latter of which 
> would need some assistance from VMM for sure. However, the presence of 
> information via the vdpa tool query is totally orthogonal. I don't get 
> a good reason for why it has to couple with endianness. How vdpa tool 
> users space is supposed to tweak it? I don't get it...
Yes it is a little messy, and we can not check _F_VERSION_1 because of 
transitional devices, so maybe this is the best we can do for now
>
> -Siwei
>
>
>>
>> Thanks
>>>
>>> -Siwei
>>>
>>>>>
>>>>>> +     */
>>>>>> +    val_u16 = __virtio16_to_cpu(true, config.status);
>>>>>>         val_u16 = __virtio16_to_cpu(true, config.status);
>>>>>>       if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_STATUS, val_u16))
>>>>>>           return -EMSGSIZE;
>>>>>>   -    val_u16 = __virtio16_to_cpu(true, config.mtu);
>>>>>> -    if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
>>>>>> -        return -EMSGSIZE;
>>>>>> -
>>>>>>       features_driver = vdev->config->get_driver_features(vdev);
>>>>>>       if (nla_put_u64_64bit(msg, 
>>>>>> VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features_driver,
>>>>>>                     VDPA_ATTR_PAD))
>>>>>> @@ -846,7 +869,13 @@ static int vdpa_dev_net_config_fill(struct 
>>>>>> vdpa_device *vdev, struct sk_buff *ms
>>>>>>                     VDPA_ATTR_PAD))
>>>>>>           return -EMSGSIZE;
>>>>>>   -    return vdpa_dev_net_mq_config_fill(vdev, msg, 
>>>>>> features_driver, &config);
>>>>>> +    if (vdpa_dev_net_mac_config_fill(msg, features_device, 
>>>>>> &config))
>>>>>> +        return -EMSGSIZE;
>>>>>> +
>>>>>> +    if (vdpa_dev_net_mtu_config_fill(msg, features_device, 
>>>>>> &config))
>>>>>> +        return -EMSGSIZE;
>>>>>> +
>>>>>> +    return vdpa_dev_net_mq_config_fill(msg, features_device, 
>>>>>> &config);
>>>>>>   }
>>>>>>     static int
>>>>>> @@ -914,6 +943,11 @@ static int vdpa_fill_stats_rec(struct 
>>>>>> vdpa_device *vdev, struct sk_buff *msg,
>>>>>>       }
>>>>>>       vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config));
>>>>>>   +    /*
>>>>>> +     * Assume little endian for now, userspace can tweak this for
>>>>>> +     * legacy guest support.
>>>>>> +     */
>>>>>> +
>>>>> Ditto.
>>>> same as above
>>>>
>>>> Thanks
>>>>>
>>>>> Thanks,
>>>>> -Siwei
>>>>>> max_vqp = __virtio16_to_cpu(true, config.max_virtqueue_pairs);
>>>>>>       if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, max_vqp))
>>>>>>           return -EMSGSIZE;
>>>>>
>>>>
>>>
>>
>

