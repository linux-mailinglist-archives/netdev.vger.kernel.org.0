Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 987D95BDC8A
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 07:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbiITFqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 01:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbiITFq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 01:46:29 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CCCD30577;
        Mon, 19 Sep 2022 22:46:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663652788; x=1695188788;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=8if4oEU+jgF9EPnMIvANoDaAASIk/9Q0fZBXTbiM/z4=;
  b=cqpG3rN0Mi0hRbJ9ItDxzJR/3poy+0tOMhBgNIViUQdwkvXPmP/u8imI
   7v/1elTUZKV0mdvCWo2iQMrG4Lqsi16BNKYJozpBr25jmXMzXCGm9aDJD
   1FgN3VbtC2NI+zbCTPWjwoMZwv0HcrB776cBPpr/QNGpGMXBc+iy7a9BD
   FSKjeZgvbGXFEHnXtjL7koy7VglE5YOZuWAC/mQEDbWtY4jtoENt0HPdu
   1AtnDcEm/85wWl1walEBZTuzKP9EHeuoyh4F+RBz15F66/m8LrWq4/fho
   SkLXgsVsGfE5/D4yCBCSmdIcHZJuw7cJqD2WgNU5Jc4yGgQT020ATSTf6
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10475"; a="298328580"
X-IronPort-AV: E=Sophos;i="5.93,329,1654585200"; 
   d="scan'208";a="298328580"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2022 22:46:28 -0700
X-IronPort-AV: E=Sophos;i="5.93,329,1654585200"; 
   d="scan'208";a="761166318"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.255.30.63]) ([10.255.30.63])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2022 22:46:26 -0700
Message-ID: <6fd1f8b3-23b1-84cc-2376-ee04f1fa8438@intel.com>
Date:   Tue, 20 Sep 2022 13:46:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.2.2
Subject: Re: [PATCH 2/4] vDPA: only report driver features if FEATURES_OK is
 set
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst <mst@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, kvm <kvm@vger.kernel.org>
References: <20220909085712.46006-1-lingshan.zhu@intel.com>
 <20220909085712.46006-3-lingshan.zhu@intel.com>
 <CACGkMEsYARr3toEBTxVcwFi86JxK0D-w4OpNtvVdhCEbAnc8ZA@mail.gmail.com>
Content-Language: en-US
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <CACGkMEsYARr3toEBTxVcwFi86JxK0D-w4OpNtvVdhCEbAnc8ZA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/20/2022 10:16 AM, Jason Wang wrote:
> On Fri, Sep 9, 2022 at 5:05 PM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
>> vdpa_dev_net_config_fill() should only report driver features
>> to userspace after features negotiation is done.
>>
>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>> ---
>>   drivers/vdpa/vdpa.c | 13 +++++++++----
>>   1 file changed, 9 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
>> index 798a02c7aa94..29d7e8858e6f 100644
>> --- a/drivers/vdpa/vdpa.c
>> +++ b/drivers/vdpa/vdpa.c
>> @@ -819,6 +819,7 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
>>          struct virtio_net_config config = {};
>>          u64 features_device, features_driver;
>>          u16 val_u16;
>> +       u8 status;
>>
>>          vdev->config->get_config(vdev, 0, &config, sizeof(config));
>>
>> @@ -834,10 +835,14 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
>>          if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
>>                  return -EMSGSIZE;
>>
>> -       features_driver = vdev->config->get_driver_features(vdev);
>> -       if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features_driver,
>> -                             VDPA_ATTR_PAD))
>> -               return -EMSGSIZE;
>> +       /* only read driver features after the feature negotiation is done */
>> +       status = vdev->config->get_status(vdev);
>> +       if (status & VIRTIO_CONFIG_S_FEATURES_OK) {
> Any reason this is not checked in its caller as what it used to do before?
will check the existence of vdev->config->get_status before calling it in V2

Thanks,
Zhu Lingshan
>
> Thanks
>
>> +               features_driver = vdev->config->get_driver_features(vdev);
>> +               if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features_driver,
>> +                                     VDPA_ATTR_PAD))
>> +                       return -EMSGSIZE;
>> +       }
>>
>>          features_device = vdev->config->get_device_features(vdev);
>>
>> --
>> 2.31.1
>>

