Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 280335EBF2E
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 12:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbiI0KDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 06:03:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231366AbiI0KDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 06:03:09 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30DE395E55;
        Tue, 27 Sep 2022 03:03:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664272988; x=1695808988;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=B3uGEaw5dJgYcFV9ERDaKVy8kcHjm/JqyNAQD2xGZaM=;
  b=apiC+eblHdlqhF0Odfht0ox/kAXXss1UBtIcq/1X/RAqABnk48TEmGwT
   ghqFqAg7zFrB8P++FFPjTu09/+9Ht7m4l9ObjMDvfTnPRnMDDJUz5DxE3
   7E5miZA4QXVwbLtaPq2aNZpZrgkaBFNmfDEuQ930sKb4oYLaKJace09ec
   3El3xBxxOHpCnjMRWvVKo9DRxyUDJ6JrM3Cn71ecALv6PM6EKIZ704og6
   9s2M2VGbdtTVrVpjqK3kLoAl4CL+gdsoUq1siJMhXTEajhc0Qr2zhg3SM
   E8kdlFL88RGFrygynRWa9OWPMKSFt3TGyzHRe6y9aJHIEjZJVI4Zl6qPB
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="302756537"
X-IronPort-AV: E=Sophos;i="5.93,349,1654585200"; 
   d="scan'208";a="302756537"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2022 03:02:56 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10482"; a="689937544"
X-IronPort-AV: E=Sophos;i="5.93,349,1654585200"; 
   d="scan'208";a="689937544"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.249.174.145]) ([10.249.174.145])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2022 03:02:54 -0700
Message-ID: <750e006b-7ec8-873e-8df0-b6979f6890b3@intel.com>
Date:   Tue, 27 Sep 2022 18:02:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.3.0
Subject: Re: [PATCH V2 RESEND 2/6] vDPA: only report driver features if
 FEATURES_OK is set
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org
References: <20220927030117.5635-1-lingshan.zhu@intel.com>
 <20220927030117.5635-3-lingshan.zhu@intel.com>
 <CACGkMEsioquc=hVe0D87UjZkaZ1m3B-g1hXAAyq6bHD=Fc0uFQ@mail.gmail.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <CACGkMEsioquc=hVe0D87UjZkaZ1m3B-g1hXAAyq6bHD=Fc0uFQ@mail.gmail.com>
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



On 9/27/2022 12:37 PM, Jason Wang wrote:
> On Tue, Sep 27, 2022 at 11:09 AM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
>> This commit reports driver features to user space
>> only after FEATURES_OK is features negotiation is done.
>>
>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>> ---
>>   drivers/vdpa/vdpa.c | 22 ++++++++++++++++------
>>   1 file changed, 16 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
>> index 2035700d6fc8..e7765953307f 100644
>> --- a/drivers/vdpa/vdpa.c
>> +++ b/drivers/vdpa/vdpa.c
>> @@ -816,7 +816,7 @@ static int vdpa_dev_net_mq_config_fill(struct vdpa_device *vdev,
>>   static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *msg)
>>   {
>>          struct virtio_net_config config = {};
>> -       u64 features_device, features_driver;
>> +       u64 features_device;
>>          u16 val_u16;
>>
>>          vdev->config->get_config(vdev, 0, &config, sizeof(config));
>> @@ -833,11 +833,6 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
>>          if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
>>                  return -EMSGSIZE;
>>
>> -       features_driver = vdev->config->get_driver_features(vdev);
>> -       if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features_driver,
>> -                             VDPA_ATTR_PAD))
>> -               return -EMSGSIZE;
>> -
>>          features_device = vdev->config->get_device_features(vdev);
>>
>>          if (nla_put_u64_64bit(msg, VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES, features_device,
>> @@ -851,6 +846,8 @@ static int
>>   vdpa_dev_config_fill(struct vdpa_device *vdev, struct sk_buff *msg, u32 portid, u32 seq,
>>                       int flags, struct netlink_ext_ack *extack)
>>   {
>> +       u64 features_driver;
>> +       u8 status = 0;
>>          u32 device_id;
>>          void *hdr;
>>          int err;
>> @@ -874,6 +871,19 @@ vdpa_dev_config_fill(struct vdpa_device *vdev, struct sk_buff *msg, u32 portid,
>>                  goto msg_err;
>>          }
>>
>> +       /* only read driver features after the feature negotiation is done */
>> +       if (vdev->config->get_status)
>> +               status = vdev->config->get_status(vdev);
> get_status is mandatory, so I think we can remove this check.
>
> Or if you want a strict check on the config operations, we need to do
> that in __vdpa_alloc_device().
I will remove it

Thanks!
>
> Thanks
>
>> +
>> +       if (status & VIRTIO_CONFIG_S_FEATURES_OK) {
>> +               features_driver = vdev->config->get_driver_features(vdev);
>> +               if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features_driver,
>> +                                     VDPA_ATTR_PAD)) {
>> +                       err = -EMSGSIZE;
>> +                       goto msg_err;
>> +               }
>> +       }
>> +
>>          switch (device_id) {
>>          case VIRTIO_ID_NET:
>>                  err = vdpa_dev_net_config_fill(vdev, msg);
>> --
>> 2.31.1
>>

