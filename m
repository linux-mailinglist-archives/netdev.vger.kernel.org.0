Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94AD3DFDCD
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 08:48:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387740AbfJVGst (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 02:48:49 -0400
Received: from mga14.intel.com ([192.55.52.115]:21797 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728346AbfJVGst (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 02:48:49 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Oct 2019 23:48:49 -0700
X-IronPort-AV: E=Sophos;i="5.67,326,1566889200"; 
   d="scan'208";a="191365233"
Received: from lingshan-mobl5.ccr.corp.intel.com (HELO [10.238.129.48]) ([10.238.129.48])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 21 Oct 2019 23:48:45 -0700
Subject: Re: [RFC 1/2] vhost: IFC VF hardware operation layer
To:     Jason Wang <jasowang@redhat.com>,
        Simon Horman <simon.horman@netronome.com>,
        "Zhu, Lingshan" <lingshan.zhu@intel.com>
Cc:     mst@redhat.com, alex.williamson@redhat.com,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, dan.daly@intel.com,
        cunming.liang@intel.com, tiwei.bie@intel.com, jason.zeng@intel.com,
        zhiyuan.lv@intel.com
References: <20191016011041.3441-1-lingshan.zhu@intel.com>
 <20191016011041.3441-2-lingshan.zhu@intel.com>
 <20191016095347.5sb43knc7eq44ivo@netronome.com>
 <075be045-3a02-e7d8-672f-4a207c410ee8@intel.com>
 <20191021163139.GC4486@netronome.com>
 <15d94e61-9b3d-7854-b65e-6fea6db75450@redhat.com>
From:   Zhu Lingshan <lingshan.zhu@linux.intel.com>
Message-ID: <1f468365-4fe4-b13f-0841-cc5a60a8fe41@linux.intel.com>
Date:   Tue, 22 Oct 2019 14:48:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.0
MIME-Version: 1.0
In-Reply-To: <15d94e61-9b3d-7854-b65e-6fea6db75450@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/22/2019 9:32 AM, Jason Wang wrote:
>
> On 2019/10/22 上午12:31, Simon Horman wrote:
>> On Mon, Oct 21, 2019 at 05:55:33PM +0800, Zhu, Lingshan wrote:
>>> On 10/16/2019 5:53 PM, Simon Horman wrote:
>>>> Hi Zhu,
>>>>
>>>> thanks for your patch.
>>>>
>>>> On Wed, Oct 16, 2019 at 09:10:40AM +0800, Zhu Lingshan wrote:
>> ...
>>
>>>>> +static void ifcvf_read_dev_config(struct ifcvf_hw *hw, u64 offset,
>>>>> +               void *dst, int length)
>>>>> +{
>>>>> +    int i;
>>>>> +    u8 *p;
>>>>> +    u8 old_gen, new_gen;
>>>>> +
>>>>> +    do {
>>>>> +        old_gen = ioread8(&hw->common_cfg->config_generation);
>>>>> +
>>>>> +        p = dst;
>>>>> +        for (i = 0; i < length; i++)
>>>>> +            *p++ = ioread8((u8 *)hw->dev_cfg + offset + i);
>>>>> +
>>>>> +        new_gen = ioread8(&hw->common_cfg->config_generation);
>>>>> +    } while (old_gen != new_gen);
>>>> Would it be wise to limit the number of iterations of the loop above?
>>> Thanks but I don't quite get it. This is used to make sure the function
>>> would get the latest config.
>> I am worried about the possibility that it will loop forever.
>> Could that happen?
>>
>> ...
>
>
> My understanding is that the function here is similar to virtio config 
> generation [1]. So this can only happen for a buggy hardware.
>
> Thanks
>
> [1] 
> https://docs.oasis-open.org/virtio/virtio/v1.1/csprd01/virtio-v1.1-csprd01.html 
> Section 2.4.1
Yes!
>
>
>>
>>>>> +static void io_write64_twopart(u64 val, u32 *lo, u32 *hi)
>>>>> +{
>>>>> +    iowrite32(val & ((1ULL << 32) - 1), lo);
>>>>> +    iowrite32(val >> 32, hi);
>>>>> +}
>>>> I see this macro is also in virtio_pci_modern.c
>>>>
>>>> Assuming lo and hi aren't guaranteed to be sequential
>>>> and thus iowrite64_hi_lo() cannot be used perhaps
>>>> it would be good to add a common helper somewhere.
>>> Thanks, I will try after this IFC patchwork, I will cc you.
>> Thanks.
>>
>> ...
>
