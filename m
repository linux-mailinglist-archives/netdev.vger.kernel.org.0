Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3846649C96E
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 13:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241160AbiAZMSR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 07:18:17 -0500
Received: from mga11.intel.com ([192.55.52.93]:27360 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241135AbiAZMSR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 07:18:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643199497; x=1674735497;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=JxqShvO8aZrRNHX9ZBCILcO4aOllXTiZCFP4Hj5Qo4U=;
  b=L77MC665oe1BHTULERgK0K5MsNgLovUZjYlJFNQeLnmAlE6ZCHrD1aQQ
   kV9eYw7ryUcNx6MxQpaEFzHTfF+C+1+t3zj78AxTU0heH6hv9s5NzV/dA
   ChdEOqnVZ6zggkfB1DVmQjZ5TmfKzzGaJd2UW7Pxwu8gURxKwHoN468Em
   uonOAb+vOG+thdNMm+mLQYhBW8NtKY0LbRzvb2zhOlAQElLtdriqc4EyN
   S1M1jNzA7AwXy+yj+8Sm367YnMlkOX2VTtsDDbeDHFoiTitbdb/sYFy0V
   Xcb3LaGkaJ5g8d2G33MwYXBmBljtem4++ItCNmLvjxLKcyBYcsSrXIx4k
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10238"; a="244136409"
X-IronPort-AV: E=Sophos;i="5.88,318,1635231600"; 
   d="scan'208";a="244136409"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 04:18:17 -0800
X-IronPort-AV: E=Sophos;i="5.88,318,1635231600"; 
   d="scan'208";a="535159735"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.249.171.61]) ([10.249.171.61])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 04:18:15 -0800
Message-ID: <e6ef0e04-f7ee-a4e4-5975-855c8f6b9da7@intel.com>
Date:   Wed, 26 Jan 2022 20:18:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.5.0
Subject: Re: [PATCH V2 3/4] vhost_vdpa: don't setup irq offloading when
 irq_num < 0
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     jasowang@redhat.com, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org
References: <20220125091744.115996-1-lingshan.zhu@intel.com>
 <20220125091744.115996-4-lingshan.zhu@intel.com>
 <20220125143008-mutt-send-email-mst@kernel.org>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <20220125143008-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/26/2022 3:30 AM, Michael S. Tsirkin wrote:
> On Tue, Jan 25, 2022 at 05:17:43PM +0800, Zhu Lingshan wrote:
>> When irq number is negative(e.g., -EINVAL), the virtqueue
>> may be disabled or the virtqueues are sharing a device irq.
>> In such case, we should not setup irq offloading for a virtqueue.
>>
>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>> ---
>>   drivers/vhost/vdpa.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>> index 851539807bc9..909891d518e8 100644
>> --- a/drivers/vhost/vdpa.c
>> +++ b/drivers/vhost/vdpa.c
>> @@ -96,6 +96,9 @@ static void vhost_vdpa_setup_vq_irq(struct vhost_vdpa *v, u16 qid)
>>   	if (!ops->get_vq_irq)
>>   		return;
>>   
>> +	if (irq < 0)
>> +		return;
>> +
>>   	irq = ops->get_vq_irq(vdpa, qid);
> So it's used before it's initialized. Ugh.
> How was this patchset tested?
Sorry, my bad, it is not rebased properly, V3 can fix this for sure.

Thanks
>
>>   	irq_bypass_unregister_producer(&vq->call_ctx.producer);
>>   	if (!vq->call_ctx.ctx || irq < 0)
>> -- 
>> 2.27.0

