Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54AF05BE28A
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 11:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbiITJ6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 05:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230438AbiITJ6j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 05:58:39 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97BD46F268;
        Tue, 20 Sep 2022 02:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663667918; x=1695203918;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZdfQN94fb6a00fA5azfm26uBEbAPljxnRlrR5PaKYuk=;
  b=nZ0JSl6QaH7Ryo/AP9dyG3XB3yBJsk+sEhZmbAOmO/LAwqcJyU2TnF8t
   ePf6FrsGAlMdLH7xahGYKzKPX2Q2UxflAp7QR2zdRVT3kozbDcGSt+Bms
   oJyCUdoDSSWa46Dmy7w5Xl8dJufUM1Ma07uImRgZwyWh59p+31DkuXVpb
   JmY82FZeLtIHVBac5iI/D/QX+uMMz/MKzeQCGOQNk2N1r0LUjdoRuNPzQ
   6BPBamE18l6FGR/FIQ9DM8W6KfuseVhbdhSBBbETtgHXTzVCW1/P46BnB
   vTkBAOBSGY+E9MO3ISXlrZ9fNKuqoLUPW17HZ1PbrkZK3HaDhopuYzapZ
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10475"; a="298377082"
X-IronPort-AV: E=Sophos;i="5.93,330,1654585200"; 
   d="scan'208";a="298377082"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2022 02:58:38 -0700
X-IronPort-AV: E=Sophos;i="5.93,330,1654585200"; 
   d="scan'208";a="596454045"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.255.30.63]) ([10.255.30.63])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Sep 2022 02:58:36 -0700
Message-ID: <e69b65e7-516f-55bd-cb99-863d7accbd32@intel.com>
Date:   Tue, 20 Sep 2022 17:58:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.2.2
Subject: Re: [PATCH 1/4] vDPA: allow userspace to query features of a vDPA
 device
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst <mst@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, kvm <kvm@vger.kernel.org>
References: <20220909085712.46006-1-lingshan.zhu@intel.com>
 <20220909085712.46006-2-lingshan.zhu@intel.com>
 <CACGkMEsq+weeO7i8KtNNAPhXGwN=cTwWt3RWfTtML-Xwj3K5Qg@mail.gmail.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <CACGkMEsq+weeO7i8KtNNAPhXGwN=cTwWt3RWfTtML-Xwj3K5Qg@mail.gmail.com>
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



On 9/20/2022 10:02 AM, Jason Wang wrote:
> On Fri, Sep 9, 2022 at 5:05 PM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
>> This commit adds a new vDPA netlink attribution
>> VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES. Userspace can query
>> features of vDPA devices through this new attr.
>>
>> This commit invokes vdpa_config_ops.get_config() than
>> vdpa_get_config_unlocked() to read the device config
>> spcae, so no raeces in vdpa_set_features_unlocked()
>>
>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> It's better to share the userspace code as well.
OK, will share it in V2.
>
>> ---
>>   drivers/vdpa/vdpa.c       | 19 ++++++++++++++-----
>>   include/uapi/linux/vdpa.h |  4 ++++
>>   2 files changed, 18 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
>> index c06c02704461..798a02c7aa94 100644
>> --- a/drivers/vdpa/vdpa.c
>> +++ b/drivers/vdpa/vdpa.c
>> @@ -491,6 +491,8 @@ static int vdpa_mgmtdev_fill(const struct vdpa_mgmt_dev *mdev, struct sk_buff *m
>>                  err = -EMSGSIZE;
>>                  goto msg_err;
>>          }
>> +
>> +       /* report features of a vDPA management device through VDPA_ATTR_DEV_SUPPORTED_FEATURES */
> The code explains itself, there's no need for the comment.
these comments are required in other discussions
>
>>          if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_SUPPORTED_FEATURES,
>>                                mdev->supported_features, VDPA_ATTR_PAD)) {
>>                  err = -EMSGSIZE;
>> @@ -815,10 +817,10 @@ static int vdpa_dev_net_mq_config_fill(struct vdpa_device *vdev,
>>   static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *msg)
>>   {
>>          struct virtio_net_config config = {};
>> -       u64 features;
>> +       u64 features_device, features_driver;
>>          u16 val_u16;
>>
>> -       vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config));
>> +       vdev->config->get_config(vdev, 0, &config, sizeof(config));
>>
>>          if (nla_put(msg, VDPA_ATTR_DEV_NET_CFG_MACADDR, sizeof(config.mac),
>>                      config.mac))
>> @@ -832,12 +834,19 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
>>          if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
>>                  return -EMSGSIZE;
>>
>> -       features = vdev->config->get_driver_features(vdev);
>> -       if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features,
>> +       features_driver = vdev->config->get_driver_features(vdev);
>> +       if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features_driver,
>> +                             VDPA_ATTR_PAD))
>> +               return -EMSGSIZE;
>> +
>> +       features_device = vdev->config->get_device_features(vdev);
>> +
>> +       /* report features of a vDPA device through VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES */
>> +       if (nla_put_u64_64bit(msg, VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES, features_device,
>>                                VDPA_ATTR_PAD))
>>                  return -EMSGSIZE;
>>
>> -       return vdpa_dev_net_mq_config_fill(vdev, msg, features, &config);
>> +       return vdpa_dev_net_mq_config_fill(vdev, msg, features_driver, &config);
>>   }
>>
>>   static int
>> diff --git a/include/uapi/linux/vdpa.h b/include/uapi/linux/vdpa.h
>> index 25c55cab3d7c..97531b52dcbe 100644
>> --- a/include/uapi/linux/vdpa.h
>> +++ b/include/uapi/linux/vdpa.h
>> @@ -46,12 +46,16 @@ enum vdpa_attr {
>>
>>          VDPA_ATTR_DEV_NEGOTIATED_FEATURES,      /* u64 */
>>          VDPA_ATTR_DEV_MGMTDEV_MAX_VQS,          /* u32 */
>> +       /* features of a vDPA management device */
>>          VDPA_ATTR_DEV_SUPPORTED_FEATURES,       /* u64 */
>>
>>          VDPA_ATTR_DEV_QUEUE_INDEX,              /* u32 */
>>          VDPA_ATTR_DEV_VENDOR_ATTR_NAME,         /* string */
>>          VDPA_ATTR_DEV_VENDOR_ATTR_VALUE,        /* u64 */
>>
>> +       /* features of a vDPA device, e.g., /dev/vhost-vdpa0 */
>> +       VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES,  /* u64 */
> What's the difference between this and VDPA_ATTR_DEV_SUPPORTED_FEATURES?
This is to report a vDPA device features, and 
VDPA_ATTR_DEV_SUPPORTED_FEATURES
is used for reporting the management device features, we have a long 
discussion
on this before.
>
> Thanks
>
>> +
>>          /* new attributes must be added above here */
>>          VDPA_ATTR_MAX,
>>   };
>> --
>> 2.31.1
>>

