Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF5F5836A8
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 04:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236086AbiG1CGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 22:06:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234004AbiG1CGY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 22:06:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A3E4C59249
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 19:06:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658973981;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eCY1EoVQoU5KC7LUlytquyO2gcpF+E49noICdTq3U8o=;
        b=X8359Wdp24WvZ2tkfND6y1vN/ijCqD0AkAOFYJED9ywiKwsISFNrmmjdMSh9ior5mN8URj
        SuGs26ykVS+BdXzFoTqYyVpDeVC5nIpZq8YhImRXneJ1sYQz4NJr7p4U7FnvvsDi2GCVST
        3qlb1nFrx/TBEDV0kh52DVPPFlSOajE=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-544--ESZj-yKPLKuku39nslAjg-1; Wed, 27 Jul 2022 22:06:20 -0400
X-MC-Unique: -ESZj-yKPLKuku39nslAjg-1
Received: by mail-pl1-f197.google.com with SMTP id l7-20020a170902f68700b0016d95380e6fso392187plg.2
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 19:06:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=eCY1EoVQoU5KC7LUlytquyO2gcpF+E49noICdTq3U8o=;
        b=SER5tdEvsYMY3Gl+ni3hQ742YVi7LUfteGZV/9bwBXMTCWUthSCOt7qhrEtH55Z6i2
         Ff9zW4sJYKJKqZW5/lNwPl0FhROadKbAV5lTjikDpEiL4ECsy1zrp6tD++JENVZbSIQD
         ebBdVooEykWkGmV1OfKProy/nCSdLjldEshtVTSdbTtAEU73kASCV7LnU1mj4ZjONI3V
         81EJ5ayXSa2jbOaxP/y6/F+X6ZOHKFksygx0NacI9qIHCaCRWQLfpk7g3SFGwhnt9YD4
         nlhdzLDJVUXPWqXKV4J4w2o071XQRfAxxHelU4kxNI9fYsm3q1tOLsJioAunh3Ia3oCj
         /B9Q==
X-Gm-Message-State: AJIora9TuqYretBs34r9X3ppa+HhY+JZBXO6U++A5klpgsrkLOXUfQZk
        PBJbk0S8dfM6OrxV86OufmkzjZ24t7yDkEqQO6VdrVxFzFi4h7NGXvIgjOSXNbrBoR0jgQLmbx2
        sWE7qSJcub6UIGVgt
X-Received: by 2002:a17:902:f68e:b0:16d:784f:ba with SMTP id l14-20020a170902f68e00b0016d784f00bamr16741078plg.174.1658973978777;
        Wed, 27 Jul 2022 19:06:18 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1v75WMjcHX73GY0Nw7gRf1j3Pxyub0ev6gdUf/jIzZl8+S0YnXKpq/SsihBZz6VYBnq0CpOpw==
X-Received: by 2002:a17:902:f68e:b0:16d:784f:ba with SMTP id l14-20020a170902f68e00b0016d784f00bamr16741052plg.174.1658973978312;
        Wed, 27 Jul 2022 19:06:18 -0700 (PDT)
Received: from [10.72.12.210] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c3-20020a170903234300b0016be5f24aaesm12347377plh.163.2022.07.27.19.06.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jul 2022 19:06:17 -0700 (PDT)
Message-ID: <c8bd5396-84f2-e782-79d7-f493aca95781@redhat.com>
Date:   Thu, 28 Jul 2022 10:06:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH V3 4/6] vDPA: !FEATURES_OK should not block querying
 device config space
Content-Language: en-US
To:     Si-Wei Liu <si-wei.liu@oracle.com>,
        "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        Parav Pandit <parav@nvidia.com>,
        "mst@redhat.com" <mst@redhat.com>, Eli Cohen <elic@nvidia.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
References: <20220701132826.8132-1-lingshan.zhu@intel.com>
 <20220701132826.8132-5-lingshan.zhu@intel.com>
 <PH0PR12MB548190DE76CC64E56DA2DF13DCBD9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <00889067-50ac-d2cd-675f-748f171e5c83@oracle.com>
 <63242254-ba84-6810-dad8-34f900b97f2f@intel.com>
 <8002554a-a77c-7b25-8f99-8d68248a741d@oracle.com>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <8002554a-a77c-7b25-8f99-8d68248a741d@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/7/28 08:56, Si-Wei Liu 写道:
>
>
> On 7/27/2022 4:47 AM, Zhu, Lingshan wrote:
>>
>>
>> On 7/27/2022 5:43 PM, Si-Wei Liu wrote:
>>> Sorry to chime in late in the game. For some reason I couldn't get 
>>> to most emails for this discussion (I only subscribed to the 
>>> virtualization list), while I was taking off amongst the past few 
>>> weeks.
>>>
>>> It looks to me this patch is incomplete. Noted down the way in 
>>> vdpa_dev_net_config_fill(), we have the following:
>>>          features = vdev->config->get_driver_features(vdev);
>>>          if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features,
>>>                                VDPA_ATTR_PAD))
>>>                  return -EMSGSIZE;
>>>
>>> Making call to .get_driver_features() doesn't make sense when 
>>> feature negotiation isn't complete. Neither should present 
>>> negotiated_features to userspace before negotiation is done.
>>>
>>> Similarly, max_vqp through vdpa_dev_net_mq_config_fill() probably 
>>> should not show before negotiation is done - it depends on driver 
>>> features negotiated.
>> I have another patch in this series introduces device_features and 
>> will report device_features to the userspace even features 
>> negotiation not done. Because the spec says we should allow driver 
>> access the config space before FEATURES_OK.
> The config space can be accessed by guest before features_ok doesn't 
> necessarily mean the value is valid. 


It's valid as long as the device offers the feature:

"The device MUST allow reading of any device-specific configuration 
field before FEATURES_OK is set by the driver. This includes fields 
which are conditional on feature bits, as long as those feature bits are 
offered by the device."


> You may want to double check with Michael for what he quoted earlier:
>> Nope:
>>
>> 2.5.1  Driver Requirements: Device Configuration Space
>>
>> ...
>>
>> For optional configuration space fields, the driver MUST check that the corresponding feature is offered
>> before accessing that part of the configuration space.
>
> and how many driver bugs taking wrong assumption of the validity of 
> config space field without features_ok. I am not sure what use case 
> you want to expose config resister values for before features_ok, if 
> it's mostly for live migration I guess it's probably heading a wrong 
> direction.


I guess it's not for migration. For migration, a provision with the 
correct features/capability would be sufficient.

Thanks


>
>
>>>
>>>
>>> Last but not the least, this "vdpa dev config" command was not 
>>> designed to display the real config space register values in the 
>>> first place. Quoting the vdpa-dev(8) man page:
>>>
>>>> vdpa dev config show - Show configuration of specific device or all 
>>>> devices.
>>>> DEV - specifies the vdpa device to show its configuration. If this 
>>>> argument is omitted all devices configuration is listed.
>>> It doesn't say anything about configuration space or register values 
>>> in config space. As long as it can convey the config attribute when 
>>> instantiating vDPA device instance, and more importantly, the config 
>>> can be easily imported from or exported to userspace tools when 
>>> trying to reconstruct vdpa instance intact on destination host for 
>>> live migration, IMHO in my personal interpretation it doesn't matter 
>>> what the config space may present. It may be worth while adding a 
>>> new debug command to expose the real register value, but that's 
>>> another story.
>> I am not sure getting your points. vDPA now reports device feature 
>> bits(device_features) and negotiated feature bits(driver_features), 
>> and yes, the drivers features can be a subset of the device features; 
>> and the vDPA device features can be a subset of the management device 
>> features.
> What I said is after unblocking the conditional check, you'd have to 
> handle the case for each of the vdpa attribute when feature 
> negotiation is not yet done: basically the register values you got 
> from config space via the vdpa_get_config_unlocked() call is not 
> considered to be valid before features_ok (per-spec). Although in some 
> case you may get sane value, such behavior is generally undefined. If 
> you desire to show just the device_features alone without any config 
> space field, which the device had advertised *before feature 
> negotiation is complete*, that'll be fine. But looks to me this is not 
> how patch has been implemented. Probably need some more work?
>
> Regards,
> -Siwei
>
>>>
>>> Having said, please consider to drop the Fixes tag, as appears to me 
>>> you're proposing a new feature rather than fixing a real issue.
>> it's a new feature to report the device feature bits than only 
>> negotiated features, however this patch is a must, or it will block 
>> the device feature bits reporting. but I agree, the fix tag is not a 
>> must.
>>>
>>> Thanks,
>>> -Siwei
>>>
>>> On 7/1/2022 3:12 PM, Parav Pandit via Virtualization wrote:
>>>>> From: Zhu Lingshan<lingshan.zhu@intel.com>
>>>>> Sent: Friday, July 1, 2022 9:28 AM
>>>>>
>>>>> Users may want to query the config space of a vDPA device, to choose a
>>>>> appropriate one for a certain guest. This means the users need to read the
>>>>> config space before FEATURES_OK, and the existence of config space
>>>>> contents does not depend on FEATURES_OK.
>>>>>
>>>>> The spec says:
>>>>> The device MUST allow reading of any device-specific configuration field
>>>>> before FEATURES_OK is set by the driver. This includes fields which are
>>>>> conditional on feature bits, as long as those feature bits are offered by the
>>>>> device.
>>>>>
>>>>> Fixes: 30ef7a8ac8a07 (vdpa: Read device configuration only if FEATURES_OK)
>>>> Fix is fine, but fixes tag needs correction described below.
>>>>
>>>> Above commit id is 13 letters should be 12.
>>>> And
>>>> It should be in format
>>>> Fixes: 30ef7a8ac8a0 ("vdpa: Read device configuration only if FEATURES_OK")
>>>>
>>>> Please use checkpatch.pl script before posting the patches to catch these errors.
>>>> There is a bot that looks at the fixes tag and identifies the right kernel version to apply this fix.
>>>>
>>>>> Signed-off-by: Zhu Lingshan<lingshan.zhu@intel.com>
>>>>> ---
>>>>>   drivers/vdpa/vdpa.c | 8 --------
>>>>>   1 file changed, 8 deletions(-)
>>>>>
>>>>> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c index
>>>>> 9b0e39b2f022..d76b22b2f7ae 100644
>>>>> --- a/drivers/vdpa/vdpa.c
>>>>> +++ b/drivers/vdpa/vdpa.c
>>>>> @@ -851,17 +851,9 @@ vdpa_dev_config_fill(struct vdpa_device *vdev,
>>>>> struct sk_buff *msg, u32 portid,  {
>>>>>   	u32 device_id;
>>>>>   	void *hdr;
>>>>> -	u8 status;
>>>>>   	int err;
>>>>>
>>>>>   	down_read(&vdev->cf_lock);
>>>>> -	status = vdev->config->get_status(vdev);
>>>>> -	if (!(status & VIRTIO_CONFIG_S_FEATURES_OK)) {
>>>>> -		NL_SET_ERR_MSG_MOD(extack, "Features negotiation not
>>>>> completed");
>>>>> -		err = -EAGAIN;
>>>>> -		goto out;
>>>>> -	}
>>>>> -
>>>>>   	hdr = genlmsg_put(msg, portid, seq, &vdpa_nl_family, flags,
>>>>>   			  VDPA_CMD_DEV_CONFIG_GET);
>>>>>   	if (!hdr) {
>>>>> --
>>>>> 2.31.1
>>>> _______________________________________________
>>>> Virtualization mailing list
>>>> Virtualization@lists.linux-foundation.org
>>>> https://lists.linuxfoundation.org/mailman/listinfo/virtualization
>>>
>>
>

