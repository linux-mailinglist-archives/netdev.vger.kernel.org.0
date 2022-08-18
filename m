Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ACF9597FA9
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 10:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243926AbiHRH6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 03:58:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236334AbiHRH6i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 03:58:38 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87FAA2DD1;
        Thu, 18 Aug 2022 00:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660809514; x=1692345514;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Twxx38m/B6MP00GziwC+0h9SZWmuKEGBvpIWsVx0Ifk=;
  b=iUlo7hkwADea3wP1BhGqlTX81dSsvZMiHzt7g9LDsmPWcjvYftZiKcoT
   99x7vmhGHXHaBH892dwmhREXD1MQSRPtNgV6TBnXkjVF51N0eGMA1UlUk
   NrsAKlKgNAx+bX9PBlcQAF6J6IPphO7kwrH3i4PBpI0UDKYYxUHdWVFpa
   j7O+IvasYJxL9KS/466lkNSLm6f4iFp8ZJxKheIP4Ta6cJWaVDorBzqJQ
   /uVyUlXwpZ1oXDfBaGZtLv6T2xMqLB3j70iAqu/ABVysQdyKst6b1SwI/
   4umMznPHTEmkhbKYp5sOz1C56uGZrxPa4M8YJq5eZKb5sMdbXtpDcpxOW
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10442"; a="318711961"
X-IronPort-AV: E=Sophos;i="5.93,245,1654585200"; 
   d="scan'208";a="318711961"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 00:58:18 -0700
X-IronPort-AV: E=Sophos;i="5.93,245,1654585200"; 
   d="scan'208";a="636720178"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.255.28.224]) ([10.255.28.224])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 00:58:16 -0700
Message-ID: <4f11f53f-c6d4-c7eb-de7b-0260942464fe@intel.com>
Date:   Thu, 18 Aug 2022 15:58:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.12.0
Subject: Re: [PATCH 2/2] vDPA: conditionally read fields in virtio-net dev
Content-Language: en-US
To:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Si-Wei Liu <si-wei.liu@oracle.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, parav@nvidia.com, xieyongji@bytedance.com,
        gautam.dawar@amd.com
References: <c5075d3d-9d2c-2716-1cbf-cede49e2d66f@oracle.com>
 <20e92551-a639-ec13-3d9c-13bb215422e1@intel.com>
 <9b6292f3-9bd5-ecd8-5e42-cd5d12f036e7@oracle.com>
 <22e0236f-b556-c6a8-0043-b39b02928fd6@intel.com>
 <892b39d6-85f8-bff5-030d-e21288975572@oracle.com>
 <52a47bc7-bf26-b8f9-257f-7dc5cea66d23@intel.com>
 <20220817045406-mutt-send-email-mst@kernel.org>
 <a91fa479-d1cc-a2d6-0821-93386069a2c1@intel.com>
 <20220817053821-mutt-send-email-mst@kernel.org>
 <449c2fb2-3920-7bf9-8c5c-a68456dfea76@intel.com>
 <20220817063450-mutt-send-email-mst@kernel.org>
 <54aa5a5c-69e2-d372-3e0c-b87f595d213c@redhat.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <54aa5a5c-69e2-d372-3e0c-b87f595d213c@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/18/2022 12:15 PM, Jason Wang wrote:
>
> 在 2022/8/17 18:37, Michael S. Tsirkin 写道:
>> On Wed, Aug 17, 2022 at 05:43:22PM +0800, Zhu, Lingshan wrote:
>>>
>>> On 8/17/2022 5:39 PM, Michael S. Tsirkin wrote:
>>>> On Wed, Aug 17, 2022 at 05:13:59PM +0800, Zhu, Lingshan wrote:
>>>>> On 8/17/2022 4:55 PM, Michael S. Tsirkin wrote:
>>>>>> On Wed, Aug 17, 2022 at 10:14:26AM +0800, Zhu, Lingshan wrote:
>>>>>>> Yes it is a little messy, and we can not check _F_VERSION_1 
>>>>>>> because of
>>>>>>> transitional devices, so maybe this is the best we can do for now
>>>>>> I think vhost generally needs an API to declare config space 
>>>>>> endian-ness
>>>>>> to kernel. vdpa can reuse that too then.
>>>>> Yes, I remember you have mentioned some IOCTL to set the endian-ness,
>>>>> for vDPA, I think only the vendor driver knows the endian,
>>>>> so we may need a new function vdpa_ops->get_endian().
>>>>> In the last thread, we say maybe it's better to add a comment for 
>>>>> now.
>>>>> But if you think we should add a vdpa_ops->get_endian(), I can work
>>>>> on it for sure!
>>>>>
>>>>> Thanks
>>>>> Zhu Lingshan
>>>> I think QEMU has to set endian-ness. No one else knows.
>>> Yes, for SW based vhost it is true. But for HW vDPA, only
>>> the device & driver knows the endian, I think we can not
>>> "set" a hardware's endian.
>> QEMU knows the guest endian-ness and it knows that
>> device is accessed through the legacy interface.
>> It can accordingly send endian-ness to the kernel and
>> kernel can propagate it to the driver.
>
>
> I wonder if we can simply force LE and then Qemu can do the endian 
> conversion?
I think this is what we are doing now, force it to be LE, leave a comment.

QEMU will not set ENDIAN for vDPA devices, vhost_kernel_call() verifies
whether the backend is TYPE_KERNEL (we have TYPE_VDPA here),
so we can not rely on this code path.

Thanks
Zhu Lingshan
>
> Thanks
>
>
>>
>>> So if you think we should add a vdpa_ops->get_endian(),
>>> I will drop these comments in the next version of
>>> series, and work on a new patch for get_endian().
>>>
>>> Thanks,
>>> Zhu Lingshan
>> Guests don't get endian-ness from devices so this seems pointless.
>>
>

