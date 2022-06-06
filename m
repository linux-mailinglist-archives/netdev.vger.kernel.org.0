Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 578EF53E334
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 10:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231642AbiFFIUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 04:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231719AbiFFIT6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 04:19:58 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B3D46B679
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 01:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654503597; x=1686039597;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=WqYOyIOxS95fVpk0+ru4DQSRjSMyAB/j2v1Rm8K4l9Y=;
  b=n7JI6zApCls2YwNqUafq2p3rN2EdVXyNp7ILI1oSaBrwXL2oBIdwAB0W
   f1jhkD9CrqZsYVURW6P8UKmPgDfeND2O2nexwiJYLXl+U+bG3Xv99xgqJ
   YMJgZ8RmRwl+woewqwCw8HQShQjaMpqFRq/ZjtEYjEdBbLyya+G8dlO3d
   51gTBFUBlzYtqQZVD/UR4XLdAtinOwnmrd5Qew5I3wDF7l0o0hpYvGWH4
   ikjZNehDd7ectafqVXHgmAl3E/AeLxMOdUWShzod6SZsOpbJubacdKUWS
   SSXstnRwe7IprCb5WwDybczaIVVUEjivXZA3Pthxton9TWiRR6GYk68ZP
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10369"; a="275415122"
X-IronPort-AV: E=Sophos;i="5.91,280,1647327600"; 
   d="scan'208";a="275415122"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2022 01:19:57 -0700
X-IronPort-AV: E=Sophos;i="5.91,280,1647327600"; 
   d="scan'208";a="583513237"
Received: from fengjia-mobl2.ccr.corp.intel.com (HELO [10.254.210.182]) ([10.254.210.182])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2022 01:19:54 -0700
Message-ID: <c644798b-7894-0a40-c64b-1eedf38ded49@intel.com>
Date:   Mon, 6 Jun 2022 16:19:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.1
Subject: Re: [PATCH 4/6] vDPA: !FEATURES_OK should not block querying device
 config space
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst <mst@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>
References: <20220602023845.2596397-1-lingshan.zhu@intel.com>
 <20220602023845.2596397-5-lingshan.zhu@intel.com>
 <CACGkMEtzHB9e9fgQ=t9vT1iz6A9t46hsEMmpHghQSTSfhr7kuw@mail.gmail.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <CACGkMEtzHB9e9fgQ=t9vT1iz6A9t46hsEMmpHghQSTSfhr7kuw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/2/2022 3:36 PM, Jason Wang wrote:
> On Thu, Jun 2, 2022 at 10:48 AM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
>> Users may want to query the config space of a vDPA device,
>> to choose a appropriate one for a certain guest. This means the
>> users need to read the config space before FEATURES_OK, and
>> the existence of config space contents does not depend on
>> FEATURES_OK.
> Quotes from the spec:
>
> "The device MUST allow reading of any device-specific configuration
> field before FEATURES_OK is set by the driver. This includes fields
> which are conditional on feature bits, as long as those feature bits
> are offered by the device."
>
>> This commit removes FEATURES_OK blocker in vdpa_dev_config_fill()
>> which calls vdpa_dev_net_config_fill() for virtio-net
>>
>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>> ---
>>   drivers/vdpa/vdpa.c | 8 --------
>>   1 file changed, 8 deletions(-)
>>
>> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
>> index c820dd2b0307..030d96bdeed2 100644
>> --- a/drivers/vdpa/vdpa.c
>> +++ b/drivers/vdpa/vdpa.c
>> @@ -863,17 +863,9 @@ vdpa_dev_config_fill(struct vdpa_device *vdev, struct sk_buff *msg, u32 portid,
>>   {
>>          u32 device_id;
>>          void *hdr;
>> -       u8 status;
>>          int err;
>>
>>          mutex_lock(&vdev->cf_mutex);
>> -       status = vdev->config->get_status(vdev);
>> -       if (!(status & VIRTIO_CONFIG_S_FEATURES_OK)) {
>> -               NL_SET_ERR_MSG_MOD(extack, "Features negotiation not completed");
>> -               err = -EAGAIN;
>> -               goto out;
>> -       }
> So we had the following in vdpa_dev_net_config_fill():
>
>          features = vdev->config->get_driver_features(vdev);
>          if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features,
>                                VDPA_ATTR_PAD))
>                  return -EMSGSIZE;
>
> It looks to me we need to switch to using get_device_features() instead.
This is done in the 3/6 patch

Thanks,
ZHu Lingshan
>
> Thanks
>
>> -
>>          hdr = genlmsg_put(msg, portid, seq, &vdpa_nl_family, flags,
>>                            VDPA_CMD_DEV_CONFIG_GET);
>>          if (!hdr) {
>> --
>> 2.31.1
>>

