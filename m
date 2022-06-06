Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5108253E2B1
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 10:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231639AbiFFIWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 04:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231629AbiFFIWP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 04:22:15 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C2B9140E1
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 01:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654503732; x=1686039732;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=TIyvk2goAfDRIti3w8WZV1rsnq1LUIvqJFHtE7IF0hk=;
  b=QpVq6ynfwMdbhtgxA9Npgd520xpEuSa1u15HfEVXFpfvBKwcoWBUGB0j
   vPbXHx8KsfXnC/LFbdVn/UZQfGhuk/DPg6h1Y+4JFzT4leaP2faxJx/1N
   EC4O8FCIZgs3VympIFoZ2GANMA13cihuRmCITCAzT9ASwyY6x1QlXe6WL
   UceMN6DK1DAZLWcWtrCQqDDRJ1gJ91Pdpeedlz3mSK7r10mRhhVposQu9
   yyuHRMIueiZFs+oBhwb5jKFdTenPUkFWftaRiq/mHb+TCKk/mv8nkA3wq
   HVkw2N+khakNd4s7zGpToB6tnP0joRqPlki2XvhvGmY3sTT7yJdd+ewOh
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10369"; a="276675235"
X-IronPort-AV: E=Sophos;i="5.91,280,1647327600"; 
   d="scan'208";a="276675235"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2022 01:22:12 -0700
X-IronPort-AV: E=Sophos;i="5.91,280,1647327600"; 
   d="scan'208";a="583514047"
Received: from fengjia-mobl2.ccr.corp.intel.com (HELO [10.254.210.182]) ([10.254.210.182])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2022 01:22:09 -0700
Message-ID: <054679a9-16ed-6cf6-ba8d-037aedc29357@intel.com>
Date:   Mon, 6 Jun 2022 16:22:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.1
Subject: Re: [PATCH 6/6] vDPA: fix 'cast to restricted le16' warnings in
 vdpa_dev_net_config_fill()
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst <mst@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>
References: <20220602023845.2596397-1-lingshan.zhu@intel.com>
 <20220602023845.2596397-7-lingshan.zhu@intel.com>
 <CACGkMEtS6W8wXdrXbQuniZ-ox1WsCAc1UQHJGD=J4PViviQYpA@mail.gmail.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <CACGkMEtS6W8wXdrXbQuniZ-ox1WsCAc1UQHJGD=J4PViviQYpA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-11.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/2/2022 3:40 PM, Jason Wang wrote:
> On Thu, Jun 2, 2022 at 10:48 AM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
>> This commit fixes spars warnings: cast to restricted __le16
>> in function vdpa_dev_net_config_fill()
>>
>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>> ---
>>   drivers/vdpa/vdpa.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
>> index 50a11ece603e..2719ce9962fc 100644
>> --- a/drivers/vdpa/vdpa.c
>> +++ b/drivers/vdpa/vdpa.c
>> @@ -837,11 +837,11 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
>>                      config.mac))
>>                  return -EMSGSIZE;
>>
>> -       val_u16 = le16_to_cpu(config.status);
>> +       val_u16 = le16_to_cpu((__force __le16)config.status);
> Can we use virtio accessors like virtio16_to_cpu()?
I will work out a vdpa16_to_cpu()

Thanks,
Zhu Lingshan
>
> Thanks
>
>>          if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_STATUS, val_u16))
>>                  return -EMSGSIZE;
>>
>> -       val_u16 = le16_to_cpu(config.mtu);
>> +       val_u16 = le16_to_cpu((__force __le16)config.mtu);
>>          if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
>>                  return -EMSGSIZE;
>>
>> --
>> 2.31.1
>>

