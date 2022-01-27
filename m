Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1600349D9A3
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 05:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236049AbiA0EcA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 23:32:00 -0500
Received: from mga05.intel.com ([192.55.52.43]:25405 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229750AbiA0EcA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jan 2022 23:32:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643257920; x=1674793920;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ImFF4Lw8kmaztuCjRooaXIXDzuNUFr1otHsVmxXtkds=;
  b=MZV9ODBQY9vxFff05hbGLcQyXeFGdWuhMiDm2th3VQyTgLYxvx4r9YCj
   QQTLDpKpItvKtoXvGY1rsin6iJBIBat6+ZhOEXooXnBzcvekYNNcumN7r
   JanHHF17KKkRvYVd0J5ZSGyXXK9gAH5pftmjJdMZwMvQ5VapanGF1QWwG
   7BQcWUlJQUQ0O6jiYfHtAlDR5BgFvVDsbJqZNFhwOKNlSZoWM+Os5USvP
   rwrbMgFaUOeAiBEdqB2v4SRWhVIvU+vc9O2gMJY8hnqDftDjJBzfCQ4B8
   tEgouzgi/MLN53uoPWmknHAWtQFh2y4bzMd0QrC79P0Co47786hnNdo9P
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="333099858"
X-IronPort-AV: E=Sophos;i="5.88,320,1635231600"; 
   d="scan'208";a="333099858"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 20:31:59 -0800
X-IronPort-AV: E=Sophos;i="5.88,320,1635231600"; 
   d="scan'208";a="535474058"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.249.171.72]) ([10.249.171.72])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 20:31:57 -0800
Message-ID: <841c85a6-1b3b-0d13-55ce-a51ae55bf901@intel.com>
Date:   Thu, 27 Jan 2022 12:31:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.5.0
Subject: Re: [PATCH V3 0/4] vDPA/ifcvf: implement shared IRQ feature
Content-Language: en-US
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     jasowang@redhat.com, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org
References: <20220126124912.90205-1-lingshan.zhu@intel.com>
 <20220126091329-mutt-send-email-mst@kernel.org>
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
In-Reply-To: <20220126091329-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/26/2022 10:14 PM, Michael S. Tsirkin wrote:
> On Wed, Jan 26, 2022 at 08:49:08PM +0800, Zhu Lingshan wrote:
>> It has been observed that on some platforms/devices, there may
>> not be enough MSI vectors for virtqueues and the config change.
>> Under such circumstances, the interrupt sources of a device
>> have to share vectors/IRQs.
>>
>> This series implemented a shared IRQ feature for ifcvf.
>>
>> Please help review.
> Given the history, can you please report which tests
> were performed with this patchset? Which configs tested?
> Thanks?
Hi Michael,

It is ping and netperf tests, and I have set nvectors = 1 and 2 in
ifcvf_request_irq(), after ifcvf_alloc_vectors(),
to hard coded the number of the allocate vectors.

Thanks,
Zhu Lingshan
>
>> Changes from V2:
>> (1) Fix misuse of nvectors(in ifcvf_alloc_vectors return value)(Michael)
>> (2) Fix misuse of irq = get_vq_irq() in setup irqbypass(Michael)
>> (3) Coding style improvements(Michael)
>> (4) Better naming of device shared irq/shared vq irq
>>
>> Changes from V1:
>> (1) Enable config interrupt when only one vector is allocated(Michael)
>> (2) Clean vectors/IRQs if failed to request config interrupt
>> since config interrupt is a must(Michael)
>> (3) Keep local vdpa_ops, disable irq_bypass by setting IRQ = -EINVAL
>> for shared IRQ case(Michael)
>> (4) Improvements on error messages(Michael)
>> (5) Squash functions implementation patches to the callers(Michael)
>>
>> Zhu Lingshan (4):
>>    vDPA/ifcvf: implement IO read/write helpers in the header file
>>    vDPA/ifcvf: implement device MSIX vector allocator
>>    vhost_vdpa: don't setup irq offloading when irq_num < 0
>>    vDPA/ifcvf: implement shared IRQ feature
>>
>>   drivers/vdpa/ifcvf/ifcvf_base.c |  67 +++-----
>>   drivers/vdpa/ifcvf/ifcvf_base.h |  60 +++++++-
>>   drivers/vdpa/ifcvf/ifcvf_main.c | 260 ++++++++++++++++++++++++++++----
>>   drivers/vhost/vdpa.c            |   4 +
>>   4 files changed, 312 insertions(+), 79 deletions(-)
>>
>> -- 
>> 2.27.0

