Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9327D1A345B
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 14:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbgDIMty (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 08:49:54 -0400
Received: from mga07.intel.com ([134.134.136.100]:41653 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726470AbgDIMty (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Apr 2020 08:49:54 -0400
IronPort-SDR: Pb6bj8f5yrXrVPTT+TA3ZgKRaHkb8pxTbBMrkIB39iJFOaNgh5QTecRwL2JGIqTXR+V8Ea0ziB
 XHHeNZ84bH6A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Apr 2020 05:49:53 -0700
IronPort-SDR: N5VXaRe48B8SAxKxfo5v5QMlhj9Pa+/OO0FWcuPh8ngN915uUgU5EGRTHFbRorl/pt6equ/xjd
 lJeakK0NqPNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,362,1580803200"; 
   d="scan'208";a="255137124"
Received: from jieren-mobl.ccr.corp.intel.com (HELO [10.249.174.27]) ([10.249.174.27])
  by orsmga006.jf.intel.com with ESMTP; 09 Apr 2020 05:49:46 -0700
Subject: Re: [PATCH V9 9/9] virtio: Intel IFC VF driver for VDPA
To:     Jason Wang <jasowang@redhat.com>, Arnd Bergmann <arnd@arndb.de>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Networking <netdev@vger.kernel.org>,
        Jason Gunthorpe <jgg@mellanox.com>, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        eperezma@redhat.com, lulu@redhat.com,
        Parav Pandit <parav@mellanox.com>, kevin.tian@intel.com,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Christoph Hellwig <hch@infradead.org>, aadam@redhat.com,
        Jiri Pirko <jiri@mellanox.com>, shahafs@mellanox.com,
        hanand@xilinx.com, mhabets@solarflare.com, gdawar@xilinx.com,
        saugatm@xilinx.com, vmireyno@marvell.com,
        zhangweining@ruijie.com.cn, Bie Tiwei <tiwei.bie@intel.com>
References: <20200326140125.19794-1-jasowang@redhat.com>
 <20200326140125.19794-10-jasowang@redhat.com>
 <CAK8P3a1RXUXs5oYjB=Jq5cpvG11eTnmJ+vc18_-0fzgTH6envA@mail.gmail.com>
 <ffc4c788-2319-efda-508c-275b9f7efb95@redhat.com>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
Message-ID: <4bd16fa9-5436-4cd4-a565-89e11b9f6f92@intel.com>
Date:   Thu, 9 Apr 2020 20:49:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <ffc4c788-2319-efda-508c-275b9f7efb95@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/9/2020 8:43 PM, Jason Wang wrote:
>
> On 2020/4/9 下午6:41, Arnd Bergmann wrote:
>> On Thu, Mar 26, 2020 at 3:08 PM Jason Wang <jasowang@redhat.com> wrote:
>>> From: Zhu Lingshan <lingshan.zhu@intel.com>
>>>
>>> This commit introduced two layers to drive IFC VF:
>>>
>>> (1) ifcvf_base layer, which handles IFC VF NIC hardware operations and
>>>      configurations.
>>>
>>> (2) ifcvf_main layer, which complies to VDPA bus framework,
>>>      implemented device operations for VDPA bus, handles device probe,
>>>      bus attaching, vring operations, etc.
>>>
>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>>> Signed-off-by: Bie Tiwei <tiwei.bie@intel.com>
>>> Signed-off-by: Wang Xiao <xiao.w.wang@intel.com>
>>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>>> +
>>> +#define IFCVF_QUEUE_ALIGNMENT  PAGE_SIZE
>>> +#define IFCVF_QUEUE_MAX                32768
>>> +static u16 ifcvf_vdpa_get_vq_align(struct vdpa_device *vdpa_dev)
>>> +{
>>> +       return IFCVF_QUEUE_ALIGNMENT;
>>> +}
>> This fails to build on arm64 with 64kb page size (found in linux-next):
>>
>> /drivers/vdpa/ifcvf/ifcvf_main.c: In function 'ifcvf_vdpa_get_vq_align':
>> arch/arm64/include/asm/page-def.h:17:20: error: conversion from 'long
>> unsigned int' to 'u16' {aka 'short unsigned int'} changes value from
>> '65536' to '0' [-Werror=overflow]
>>     17 | #define PAGE_SIZE  (_AC(1, UL) << PAGE_SHIFT)
>>        |                    ^
>> drivers/vdpa/ifcvf/ifcvf_base.h:37:31: note: in expansion of macro 
>> 'PAGE_SIZE'
>>     37 | #define IFCVF_QUEUE_ALIGNMENT PAGE_SIZE
>>        |                               ^~~~~~~~~
>> drivers/vdpa/ifcvf/ifcvf_main.c:231:9: note: in expansion of macro
>> 'IFCVF_QUEUE_ALIGNMENT'
>>    231 |  return IFCVF_QUEUE_ALIGNMENT;
>>        |         ^~~~~~~~~~~~~~~~~~~~~
>>
>> It's probably good enough to just not allow the driver to be built in 
>> that
>> configuration as it's fairly rare but unfortunately there is no 
>> simple Kconfig
>> symbol for it.
>
>
> Or I think the 64KB alignment is probably more than enough.
>
> Ling Shan, can we use smaller value here?
>
> Thanks

sure, we just need it page aligned, this value is only used in 
get_vq_align(). I will try to find a arm64 machine and debug on this issue

Thanks!

>
>
>>
>> In a similar driver, we did
>>
>> config VMXNET3
>>          tristate "VMware VMXNET3 ethernet driver"
>>          depends on PCI && INET
>>          depends on !(PAGE_SIZE_64KB || ARM64_64K_PAGES || \
>>                       IA64_PAGE_SIZE_64KB || MICROBLAZE_64K_PAGES || \
>>                       PARISC_PAGE_SIZE_64KB || PPC_64K_PAGES)
>>
>> I think we should probably make PAGE_SIZE_64KB a global symbol
>> in arch/Kconfig and have it selected by the other symbols so drivers
>> like yours can add a dependency for it.
>>
>>           Arnd
>>
>
