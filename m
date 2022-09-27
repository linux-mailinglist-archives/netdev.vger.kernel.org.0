Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 662E65EBF25
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 12:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbiI0KCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 06:02:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231269AbiI0KCX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 06:02:23 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E70892F4F;
        Tue, 27 Sep 2022 03:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664272941; x=1695808941;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=rvOIjYkZETRJiXSBJeZOwgo1UXNr0fy2AWtQ3v/xzbY=;
  b=IpKUUtB40Fxt5F6tg/nk/BVk7f/pyIP0CUODA4izAEyPFbo/ShOvHFLx
   OxGtIwrPnrtxfdWmO0wfwgk3tDVP4FmJKpTd3ff9E9L9Ihs9VsXOhoqh5
   EGuhXoow93pco2fVEkOZ7apoAbQZhQs+ZMbenRz46c8dr/sGSA2MvAbcs
   2Xmxki9xrj6HJt1ug4jlOGrrHEs8AZEupBC2bZpuuW4PFyt3ZXvLYNQ3K
   EAMox4DjqrgXsSYuzZgNWjw0SkH5+TFiGtwkgMGxQXBm1qKs269KcRC4y
   acJTlq7suQxtQTVjm4XCvHLLvuGzSKMvPJFdx5H07c8DvhIBVOrtsFuDx
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="363114393"
X-IronPort-AV: E=Sophos;i="5.93,349,1654585200"; 
   d="scan'208";a="363114393"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2022 03:02:20 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="689937325"
X-IronPort-AV: E=Sophos;i="5.93,349,1654585200"; 
   d="scan'208";a="689937325"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.249.174.145]) ([10.249.174.145])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2022 03:02:16 -0700
Message-ID: <4d9b3ea4-b9b2-a2c6-67a4-b2f57e6491d4@intel.com>
Date:   Tue, 27 Sep 2022 18:02:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.3.0
Subject: Re: [PATCH V2 RESEND 1/6] vDPA: allow userspace to query features of
 a vDPA device
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org
References: <20220927030117.5635-1-lingshan.zhu@intel.com>
 <20220927030117.5635-2-lingshan.zhu@intel.com>
 <CACGkMEtDmG=YvcVcvO1c371sk5wvz+UO1i4keZXA2f4PrXzXBg@mail.gmail.com>
Content-Language: en-US
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <CACGkMEtDmG=YvcVcvO1c371sk5wvz+UO1i4keZXA2f4PrXzXBg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/27/2022 12:36 PM, Jason Wang wrote:
> On Tue, Sep 27, 2022 at 11:09 AM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
>> This commit adds a new vDPA netlink attribution
>> VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES. Userspace can query
>> features of vDPA devices through this new attr.
>>
>> This commit invokes vdpa_config_ops.get_config()
>> rather than vdpa_get_config_unlocked() to read
>> the device config spcae, so no races in
>> vdpa_set_features_unlocked()
>>
>> Userspace tool iproute2 example:
>> $ vdpa dev config show vdpa0
>> vdpa0: mac 00:e8:ca:11:be:05 link up link_announce false max_vq_pairs 4 mtu 1500
>>    negotiated_features MRG_RXBUF CTRL_VQ MQ VERSION_1 ACCESS_PLATFORM
>>    dev_features MTU MAC MRG_RXBUF CTRL_VQ MQ ANY_LAYOUT VERSION_1 ACCESS_PLATFORM
>>
>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>> ---
>>   drivers/vdpa/vdpa.c       | 17 ++++++++++++-----
>>   include/uapi/linux/vdpa.h |  4 ++++
>>   2 files changed, 16 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
>> index c06c02704461..2035700d6fc8 100644
>> --- a/drivers/vdpa/vdpa.c
>> +++ b/drivers/vdpa/vdpa.c
>> @@ -491,6 +491,7 @@ static int vdpa_mgmtdev_fill(const struct vdpa_mgmt_dev *mdev, struct sk_buff *m
>>                  err = -EMSGSIZE;
>>                  goto msg_err;
>>          }
>> +
> Nit: Unnecessary changes.
oh, yes!
>
>>          if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_SUPPORTED_FEATURES,
>>                                mdev->supported_features, VDPA_ATTR_PAD)) {
>>                  err = -EMSGSIZE;
>> @@ -815,10 +816,10 @@ static int vdpa_dev_net_mq_config_fill(struct vdpa_device *vdev,
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
>> @@ -832,12 +833,18 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
>>          if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
>>                  return -EMSGSIZE;
>>
>> -       features = vdev->config->get_driver_features(vdev);
>> -       if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features,
>> +       features_driver = vdev->config->get_driver_features(vdev);
>> +       if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features_driver,
>> +                             VDPA_ATTR_PAD))
>> +               return -EMSGSIZE;
> It looks to me that those parts were removed in patch 2. I wonder if
> it's better to reorder the patch to let patch 2 come first?
I am not sure, if we apply patch 2(check FEATURES_OK in 
vdpa_dev_config_fill and report driver features there) first,
we need to remove driver_features in vdpa_dev_net_config_fill(),
however, we still not introduce and initialize device features(which is 
in patch 1, introduce device_features) yet,
so the last line "return vdpa_dev_net_mq_config_fill()" which needs 
features as its parameter may not work,
filling NULL looks worse than keep features_driver here.

Thanks
Zhu Lingshan
>
> Thanks
>
>> +
>> +       features_device = vdev->config->get_device_features(vdev);
>> +
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
>> index 25c55cab3d7c..07474183fdb3 100644
>> --- a/include/uapi/linux/vdpa.h
>> +++ b/include/uapi/linux/vdpa.h
>> @@ -46,12 +46,16 @@ enum vdpa_attr {
>>
>>          VDPA_ATTR_DEV_NEGOTIATED_FEATURES,      /* u64 */
>>          VDPA_ATTR_DEV_MGMTDEV_MAX_VQS,          /* u32 */
>> +       /* virtio features that are supported by the vDPA management device */
>>          VDPA_ATTR_DEV_SUPPORTED_FEATURES,       /* u64 */
>>
>>          VDPA_ATTR_DEV_QUEUE_INDEX,              /* u32 */
>>          VDPA_ATTR_DEV_VENDOR_ATTR_NAME,         /* string */
>>          VDPA_ATTR_DEV_VENDOR_ATTR_VALUE,        /* u64 */
>>
>> +       /* virtio features that are supported by the vDPA device */
>> +       VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES,  /* u64 */
>> +
>>          /* new attributes must be added above here */
>>          VDPA_ATTR_MAX,
>>   };
>> --
>> 2.31.1
>>

