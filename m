Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3919F5BE273
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 11:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbiITJyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 05:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbiITJyM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 05:54:12 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A33D26EF0F;
        Tue, 20 Sep 2022 02:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663667651; x=1695203651;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+rPVJn9Q+MdvPJzMg1dZPTGk5ep1WkTPToVi1D9keJE=;
  b=ViwBCCCYbkYW1tE0iF+cNBX+g/WTwOkyyg7YpzDGB5sCg1xyhP9WsO9X
   QRh3as/cWrN3FCTX4bqz+lSD/sx9Hbywo1aJL7ZzWiM2+RYeCIeWtMCsH
   Yis56oAm0Ukk4PmkG3ND0z4kO3/0N1IvffLOKttwhIuNIWU/KgdhLOGk4
   XveQNsTzsdmGlkyZTN5Zywq2hrdIyfzdUwtoMX7r/fE0O1rD/CPhiJCvZ
   W4R6ixAIdfOWoHVkD71TX6WLxGTZZ5vKnR9RIrfVT95xufxlCoXa5TC6g
   viJ2kxnCDIsd+CCj484ISOh2SAwu7gbRFtsciY7qIjI8Mnd9jLIAUwfDZ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10475"; a="363610594"
X-IronPort-AV: E=Sophos;i="5.93,330,1654585200"; 
   d="scan'208";a="363610594"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2022 02:54:11 -0700
X-IronPort-AV: E=Sophos;i="5.93,330,1654585200"; 
   d="scan'208";a="621202218"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.255.30.63]) ([10.255.30.63])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2022 02:54:08 -0700
Message-ID: <a5fd9d96-0a48-718b-25b8-ecf0f02ea37b@intel.com>
Date:   Tue, 20 Sep 2022 17:54:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.2.2
Subject: Re: [PATCH 3/4] vDPA: check VIRTIO_NET_F_RSS for
 max_virtqueue_paris's presence
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst <mst@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, kvm <kvm@vger.kernel.org>
References: <20220909085712.46006-1-lingshan.zhu@intel.com>
 <20220909085712.46006-4-lingshan.zhu@intel.com>
 <CACGkMEsjMotoSqukdzcCrQu-P8H1MxnVrC8LGCXiRQegLT7gJg@mail.gmail.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <CACGkMEsjMotoSqukdzcCrQu-P8H1MxnVrC8LGCXiRQegLT7gJg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/20/2022 10:17 AM, Jason Wang wrote:
> On Fri, Sep 9, 2022 at 5:05 PM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
>> virtio 1.2 spec says:
>> max_virtqueue_pairs only exists if VIRTIO_NET_F_MQ or
>> VIRTIO_NET_F_RSS is set.
>>
>> So when reporint MQ to userspace, it should check both
>> VIRTIO_NET_F_MQ and VIRTIO_NET_F_RSS.
>>
>> This commit also fixes:
>> 1) a spase warning by replacing le16_to_cpu with __virtio16_to_cpu.
>> 2) vdpa_dev_net_mq_config_fill() should checks device features
>> for MQ than driver features.
>> 3) struct vdpa_device *vdev is not needed for
>> vdpa_dev_net_mq_config_fill(), unused.
> Let's do those in separate patches please.
will do, thanks!
>
> Thanks
>
>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>> ---
>>   drivers/vdpa/vdpa.c | 11 ++++++-----
>>   1 file changed, 6 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
>> index 29d7e8858e6f..f8ff61232421 100644
>> --- a/drivers/vdpa/vdpa.c
>> +++ b/drivers/vdpa/vdpa.c
>> @@ -801,16 +801,17 @@ static int vdpa_nl_cmd_dev_get_dumpit(struct sk_buff *msg, struct netlink_callba
>>          return msg->len;
>>   }
>>
>> -static int vdpa_dev_net_mq_config_fill(struct vdpa_device *vdev,
>> -                                      struct sk_buff *msg, u64 features,
>> +static int vdpa_dev_net_mq_config_fill(struct sk_buff *msg, u64 features,
>>                                         const struct virtio_net_config *config)
>>   {
>>          u16 val_u16;
>>
>> -       if ((features & BIT_ULL(VIRTIO_NET_F_MQ)) == 0)
>> +       if ((features & BIT_ULL(VIRTIO_NET_F_MQ)) == 0 &&
>> +           (features & BIT_ULL(VIRTIO_NET_F_RSS)) == 0)
>>                  return 0;
>>
>> -       val_u16 = le16_to_cpu(config->max_virtqueue_pairs);
>> +       val_u16 = __virtio16_to_cpu(true, config->max_virtqueue_pairs);
>> +
>>          return nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, val_u16);
>>   }
>>
>> @@ -851,7 +852,7 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
>>                                VDPA_ATTR_PAD))
>>                  return -EMSGSIZE;
>>
>> -       return vdpa_dev_net_mq_config_fill(vdev, msg, features_driver, &config);
>> +       return vdpa_dev_net_mq_config_fill(msg, features_device, &config);
>>   }
>>
>>   static int
>> --
>> 2.31.1
>>

