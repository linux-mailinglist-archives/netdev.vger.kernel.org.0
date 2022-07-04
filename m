Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9129D564CC3
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 06:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbiGDEqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 00:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiGDEqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 00:46:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AE82763BC
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 21:46:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656910009;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eVLTlK2cLdRIb6wwURVfoHDHENc0Sq+A4u8ZtgUepwk=;
        b=SXZ/JS074HTb4RQmbeUUjvc4j7jCQmraS0DJqSzonem2mYB5WkySfiriZXxdS76cwIZ5I5
        oa15w38B0mM9RTKIZ8gj+ibmjc1hT3F0ZikSalCf5YcRmjqhGp5H9UIfHfwK2VGMGNGtko
        MW1NgFUYp7dDpsu2fHvyuOPvZM2k+SA=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-22-KO0qtqlyNrCYSS3q-Ful8g-1; Mon, 04 Jul 2022 00:46:47 -0400
X-MC-Unique: KO0qtqlyNrCYSS3q-Ful8g-1
Received: by mail-pg1-f200.google.com with SMTP id d66-20020a636845000000b0040a88edd9c1so3509641pgc.13
        for <netdev@vger.kernel.org>; Sun, 03 Jul 2022 21:46:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=eVLTlK2cLdRIb6wwURVfoHDHENc0Sq+A4u8ZtgUepwk=;
        b=eEMTMTQeXZ6TzQLs3Sa/GaIw/jWZpr/JpWG82yvmapUaEBotBjcq+oNRqobWGVMcs5
         3fdK03d7OmUNMtF7CvdAAv8Law/GwHzUNrRFRTGy94OWCB2Wh1KatYw/eJIuMG/jrUEI
         cClHHoT8+DEYC+IJTvA1xXdjcVmxgSOf1dMXJ5UI/+hHrOGC/zMHAUS/e+farcyTELwf
         AmSwCmhtVcWFXah7Oyi4tTVun21moUTEecGGxbGcEzxj6p6u6FbXq/BdiruGE8vBaRFi
         W10d4tVEOmRcb0G/x2bPnhBstsSoLEADfI5o6WOBx+jojaEYko9MI/t5sKaErz44NW0C
         rNVg==
X-Gm-Message-State: AJIora/mATnD68Tv/5vIQ1fOeoltK9q0jbiCG5c8YhaHUOlPPkNqfUVa
        IDMVYdHeO/hL9jBeNm3xQJ9r4pNbilrQKaeh9/c9uuZc6bENKisgkCqVQ9eK+M8q+sGtFdZMTGz
        KFsIh2lrXiCpEAj4v
X-Received: by 2002:a17:90a:408f:b0:1e3:23a:2370 with SMTP id l15-20020a17090a408f00b001e3023a2370mr32620799pjg.84.1656910006507;
        Sun, 03 Jul 2022 21:46:46 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1v6hfJy7wsXAEMzEbQxIUAgQMSBvJ5aR8WrcJqPjNTC/a9X/urokyGR00sXwPo5/IcLXxDHNg==
X-Received: by 2002:a17:90a:408f:b0:1e3:23a:2370 with SMTP id l15-20020a17090a408f00b001e3023a2370mr32620777pjg.84.1656910006218;
        Sun, 03 Jul 2022 21:46:46 -0700 (PDT)
Received: from [10.72.13.251] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g194-20020a6252cb000000b00527d84df6a6sm10937482pfb.208.2022.07.03.21.46.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Jul 2022 21:46:45 -0700 (PDT)
Message-ID: <e8479441-78d2-8b39-c5ad-6729b79a2f35@redhat.com>
Date:   Mon, 4 Jul 2022 12:46:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH V3 3/6] vDPA: allow userspace to query features of a vDPA
 device
Content-Language: en-US
To:     Parav Pandit <parav@nvidia.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        "mst@redhat.com" <mst@redhat.com>
Cc:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>
References: <20220701132826.8132-1-lingshan.zhu@intel.com>
 <20220701132826.8132-4-lingshan.zhu@intel.com>
 <PH0PR12MB5481AEB53864F35A79AAD7F5DCBD9@PH0PR12MB5481.namprd12.prod.outlook.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <PH0PR12MB5481AEB53864F35A79AAD7F5DCBD9@PH0PR12MB5481.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/7/2 06:02, Parav Pandit 写道:
>
>> From: Zhu Lingshan <lingshan.zhu@intel.com>
>> Sent: Friday, July 1, 2022 9:28 AM
>>
>> This commit adds a new vDPA netlink attribution
>> VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES. Userspace can query
>> features of vDPA devices through this new attr.
>>
>> Fixes: a64917bc2e9b vdpa: (Provide interface to read driver feature)
> Missing the "" in the line.
> I reviewed the patches again.
>
> However, this is not the fix.
> A fix cannot add a new UAPI.
>
> Code is already considering negotiated driver features to return the device config space.
> Hence it is fine.
>
> This patch intents to provide device features to user space.
> First what vdpa device are capable of, are already returned by features attribute on the management device.
> This is done in commit [1].
>
> The only reason to have it is, when one management device indicates that feature is supported, but device may end up not supporting this feature if such feature is shared with other devices on same physical device.
> For example all VFs may not be symmetric after large number of them are in use. In such case features bit of management device can differ (more features) than the vdpa device of this VF.
> Hence, showing on the device is useful.
>
> As mentioned before in V2, commit [1] has wrongly named the attribute to VDPA_ATTR_DEV_SUPPORTED_FEATURES.
> It should have been, VDPA_ATTR_DEV_MGMTDEV_SUPPORTED_FEATURES.
> Because it is in UAPI, and since we don't want to break compilation of iproute2,
> It cannot be renamed anymore.
>
> Given that, we do not want to start trend of naming device attributes with additional _VDPA_ to it as done in this patch.
> Error in commit [1] was exception.
>
> Hence, please reuse VDPA_ATTR_DEV_SUPPORTED_FEATURES to return for device features too.


This will probably break or confuse the existing userspace?

Thanks


>
> Secondly, you need output example for showing device features in the commit log.
>
> 3rd, please drop the fixes tag as new capability is not a fix.
>
> [1] cd2629f6df1c ("vdpa: Support reporting max device capabilities ")
>
>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>> ---
>>   drivers/vdpa/vdpa.c       | 13 +++++++++----
>>   include/uapi/linux/vdpa.h |  1 +
>>   2 files changed, 10 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c index
>> ebf2f363fbe7..9b0e39b2f022 100644
>> --- a/drivers/vdpa/vdpa.c
>> +++ b/drivers/vdpa/vdpa.c
>> @@ -815,7 +815,7 @@ static int vdpa_dev_net_mq_config_fill(struct
>> vdpa_device *vdev,  static int vdpa_dev_net_config_fill(struct vdpa_device
>> *vdev, struct sk_buff *msg)  {
>>   	struct virtio_net_config config = {};
>> -	u64 features;
>> +	u64 features_device, features_driver;
>>   	u16 val_u16;
>>
>>   	vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config)); @@ -
>> 832,12 +832,17 @@ static int vdpa_dev_net_config_fill(struct vdpa_device
>> *vdev, struct sk_buff *ms
>>   	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
>>   		return -EMSGSIZE;
>>
>> -	features = vdev->config->get_driver_features(vdev);
>> -	if (nla_put_u64_64bit(msg,
>> VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features,
>> +	features_driver = vdev->config->get_driver_features(vdev);
>> +	if (nla_put_u64_64bit(msg,
>> VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features_driver,
>> +			      VDPA_ATTR_PAD))
>> +		return -EMSGSIZE;
>> +
>> +	features_device = vdev->config->get_device_features(vdev);
>> +	if (nla_put_u64_64bit(msg,
>> VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES,
>> +features_device,
>>   			      VDPA_ATTR_PAD))
>>   		return -EMSGSIZE;
>>
>> -	return vdpa_dev_net_mq_config_fill(vdev, msg, features, &config);
>> +	return vdpa_dev_net_mq_config_fill(vdev, msg, features_driver,
>> +&config);
>>   }
>>
>>   static int
>> diff --git a/include/uapi/linux/vdpa.h b/include/uapi/linux/vdpa.h index
>> 25c55cab3d7c..39f1c3d7c112 100644
>> --- a/include/uapi/linux/vdpa.h
>> +++ b/include/uapi/linux/vdpa.h
>> @@ -47,6 +47,7 @@ enum vdpa_attr {
>>   	VDPA_ATTR_DEV_NEGOTIATED_FEATURES,	/* u64 */
>>   	VDPA_ATTR_DEV_MGMTDEV_MAX_VQS,		/* u32 */
>>   	VDPA_ATTR_DEV_SUPPORTED_FEATURES,	/* u64 */
>> +	VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES,	/* u64 */
>>
>>   	VDPA_ATTR_DEV_QUEUE_INDEX,              /* u32 */
>>   	VDPA_ATTR_DEV_VENDOR_ATTR_NAME,		/* string */
>> --
>> 2.31.1

