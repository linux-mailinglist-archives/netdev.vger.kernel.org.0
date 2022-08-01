Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 976D558638F
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 06:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239280AbiHAEeH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 00:34:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238580AbiHAEeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 00:34:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EC2D4D49
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 21:34:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659328444;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W4HPbiBG2eCU8mgNI8fe5+OkFApeI6GLNgJKBXRoiEA=;
        b=ev2oR8ylLozzN+6nXLCPU7OEvEpQq5yh2x7QgU631a6v6mx3MA/Ug9RzZ+7X7NzZnQ3yG9
        nAexHUn4YZTHywDcmptqL0PZqHtl1sShoT1DSBmJuog2ZC0GV7yfsMZStvoLNG9sYXDYUy
        fpoe0JjySPTiygk888SQPK3pQzI4iok=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-76-t4kCDAYQOr-0jTeITuZcUg-1; Mon, 01 Aug 2022 00:34:02 -0400
X-MC-Unique: t4kCDAYQOr-0jTeITuZcUg-1
Received: by mail-pl1-f199.google.com with SMTP id m5-20020a170902f64500b0016d313f3ce7so6823750plg.23
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 21:34:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=W4HPbiBG2eCU8mgNI8fe5+OkFApeI6GLNgJKBXRoiEA=;
        b=y6zSuKbAd3twrsXmKzoZ27oAOGWHL8e2DhU7MqTK9z1o1BBVUneOY7TccTuJ2AIR/X
         RX7fIfuBzcibxJZPxdLzEz22BsyD6Kp7qAb62pll0zZlIPWAdHiQtosEsuAu/Jjh3nNZ
         G9Ei3jgNOBUGRfA8s7KiN/Uu7ys90GOMwTBkYJNRjY/UQMYNyjZwzkIiFn6/Rfogu7HA
         +/ss8xo121cgfKCVSciCN9Kh32QxTgnoGwq/XL6K+oCJi8DGjxFFJIUO3aSUyWp2Afaa
         Yy2iUHm0Y4x7QrocGjG/zR7Oey4nYVveeJBmzDRS1lxcvedoruoA91h6I7KQE4KL7UPC
         qC4A==
X-Gm-Message-State: ACgBeo0NdakJKE6WHie7jDbsUlLuxfVBgWnbbKodOmxFf5sKOUzb1Sfx
        YKB/k3+5RrjHc2/YhXo5uxqEIvcwCMZyyljoBGJqlkvZ4x6bcRvgJm4L1Hy6LDnKoTNUUc4mrGq
        MQzS37CLvQ0p6iVx+
X-Received: by 2002:a17:90b:4a12:b0:1ef:fd9e:a02e with SMTP id kk18-20020a17090b4a1200b001effd9ea02emr17977113pjb.216.1659328441633;
        Sun, 31 Jul 2022 21:34:01 -0700 (PDT)
X-Google-Smtp-Source: AA6agR42MPMDMFpVNU9QZD9ItBP7KwR1+Z1iLRfR68affTWCSxG4XkUZGwpZFsJ11pb6X4yz0AI0qw==
X-Received: by 2002:a17:90b:4a12:b0:1ef:fd9e:a02e with SMTP id kk18-20020a17090b4a1200b001effd9ea02emr17977104pjb.216.1659328441351;
        Sun, 31 Jul 2022 21:34:01 -0700 (PDT)
Received: from [10.72.13.139] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i1-20020a1709026ac100b0016bee668a5asm8257019plt.161.2022.07.31.21.33.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 Jul 2022 21:33:53 -0700 (PDT)
Message-ID: <555d9757-0989-5a57-c3c5-dfb741f23564@redhat.com>
Date:   Mon, 1 Aug 2022 12:33:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH V3 6/6] vDPA: fix 'cast to restricted le16' warnings in
 vdpa.c
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        "Zhu, Lingshan" <lingshan.zhu@intel.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        parav@nvidia.com, xieyongji@bytedance.com, gautam.dawar@amd.com
References: <20220701132826.8132-1-lingshan.zhu@intel.com>
 <20220701132826.8132-7-lingshan.zhu@intel.com>
 <20220729045039-mutt-send-email-mst@kernel.org>
 <7ce4da7f-80aa-14d6-8200-c7f928f32b48@intel.com>
 <20220729051119-mutt-send-email-mst@kernel.org>
 <50b4e7ba-3e49-24b7-5c23-d8a76c61c924@intel.com>
 <20220729052149-mutt-send-email-mst@kernel.org>
 <05bf4c84-28dd-4956-4719-3a5361d151d8@intel.com>
 <20220729053615-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
In-Reply-To: <20220729053615-mutt-send-email-mst@kernel.org>
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


在 2022/7/29 17:39, Michael S. Tsirkin 写道:
> On Fri, Jul 29, 2022 at 05:35:09PM +0800, Zhu, Lingshan wrote:
>>
>> On 7/29/2022 5:23 PM, Michael S. Tsirkin wrote:
>>> On Fri, Jul 29, 2022 at 05:20:17PM +0800, Zhu, Lingshan wrote:
>>>> On 7/29/2022 5:17 PM, Michael S. Tsirkin wrote:
>>>>> On Fri, Jul 29, 2022 at 05:07:11PM +0800, Zhu, Lingshan wrote:
>>>>>> On 7/29/2022 4:53 PM, Michael S. Tsirkin wrote:
>>>>>>> On Fri, Jul 01, 2022 at 09:28:26PM +0800, Zhu Lingshan wrote:
>>>>>>>> This commit fixes spars warnings: cast to restricted __le16
>>>>>>>> in function vdpa_dev_net_config_fill() and
>>>>>>>> vdpa_fill_stats_rec()
>>>>>>>>
>>>>>>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>>>>>>> ---
>>>>>>>>      drivers/vdpa/vdpa.c | 6 +++---
>>>>>>>>      1 file changed, 3 insertions(+), 3 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
>>>>>>>> index 846dd37f3549..ed49fe46a79e 100644
>>>>>>>> --- a/drivers/vdpa/vdpa.c
>>>>>>>> +++ b/drivers/vdpa/vdpa.c
>>>>>>>> @@ -825,11 +825,11 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
>>>>>>>>      		    config.mac))
>>>>>>>>      		return -EMSGSIZE;
>>>>>>>> -	val_u16 = le16_to_cpu(config.status);
>>>>>>>> +	val_u16 = __virtio16_to_cpu(true, config.status);
>>>>>>>>      	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_STATUS, val_u16))
>>>>>>>>      		return -EMSGSIZE;
>>>>>>>> -	val_u16 = le16_to_cpu(config.mtu);
>>>>>>>> +	val_u16 = __virtio16_to_cpu(true, config.mtu);
>>>>>>>>      	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
>>>>>>>>      		return -EMSGSIZE;
>>>>>>> Wrong on BE platforms with legacy interface, isn't it?
>>>>>>> We generally don't handle legacy properly in VDPA so it's
>>>>>>> not a huge deal, but maybe add a comment at least?
>>>>>> Sure, I can add a comment here: this is for modern devices only.
>>>>>>
>>>>>> Thanks,
>>>>>> Zhu Lingshan
>>>>> Hmm. what "this" is for modern devices only here?
>>>> this cast, for LE modern devices.
>>> I think status existed in legacy for sure, and it's possible that
>>> some legacy devices backported mtu and max_virtqueue_pairs otherwise
>>> we would have these fields as __le not as __virtio, right?
>> yes, that's the reason why it is virtio_16 than just le16.
>>
>> I may find a better solution to detect whether it is LE, or BE without a
>> virtio_dev structure.
>> Check whether vdpa_device->get_device_features() has VIRTIO_F_VERISON_1. If
>> the device offers _F_VERSION_1, then it is a LE device,
>> or it is a BE device, then we use __virtio16_to_cpu(false, config.status).
>>
>> Does this look good?
> No since the question is can be a legacy driver with a transitional
> device.  I don't have a good idea yet. vhost has VHOST_SET_VRING_ENDIAN
> and maybe we need something like this for config as well?


Not sure, and even if we had this, the query could happen before 
VHOST_SET_VRING_ENDIAN.

Actually, the patch should be fine itself, since the issue exist even 
before the patch (which assumes a le).

Thanks


>
>>>>>>>> @@ -911,7 +911,7 @@ static int vdpa_fill_stats_rec(struct vdpa_device *vdev, struct sk_buff *msg,
>>>>>>>>      	}
>>>>>>>>      	vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config));
>>>>>>>> -	max_vqp = le16_to_cpu(config.max_virtqueue_pairs);
>>>>>>>> +	max_vqp = __virtio16_to_cpu(true, config.max_virtqueue_pairs);
>>>>>>>>      	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, max_vqp))
>>>>>>>>      		return -EMSGSIZE;
>>>>>>>> -- 
>>>>>>>> 2.31.1

