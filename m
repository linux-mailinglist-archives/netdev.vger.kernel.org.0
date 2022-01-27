Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B84449DC8C
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 09:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237767AbiA0I15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 03:27:57 -0500
Received: from mga18.intel.com ([134.134.136.126]:46609 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229683AbiA0I1y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 03:27:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643272074; x=1674808074;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=jIjsGNgMbhJFx8/1fddT5AVvnkPUNoQEpHbCyvi4tkg=;
  b=bG/qASKPCTTLNDGstmxFNTpfD2PRXhB4aPIzA8cWakvmykjRoBxeOwKq
   XKOn5sst2JYeWO69CcUkkdJ3CBICNHTMMuJWLuRbhqm5fRNTeOTZ02lmw
   nJ7Ww6gTRLDib3lpf6WZ3MEDT6DaGU50+T/Z6w0S9katjIA9PmLKNHWnX
   mhQroepvbjvq7KBCEu7hVgpv9z0itjrqR2bKuUL4300BCBqkf5xVj8tyB
   FcOcEP+2XNvW65LkqEOSWbkGgH7gPIkMRsu1U7MQ5uagQ+IpNeZ0KhM26
   o/GQY4lA9Fq9zAubD4KeY9v+Dzd/aysB8ExECyIInCQchRB2QtnGZowvj
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10239"; a="230361114"
X-IronPort-AV: E=Sophos;i="5.88,320,1635231600"; 
   d="scan'208";a="230361114"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 00:27:53 -0800
X-IronPort-AV: E=Sophos;i="5.88,320,1635231600"; 
   d="scan'208";a="495651294"
Received: from lingshan-mobl.ccr.corp.intel.com (HELO [10.249.171.72]) ([10.249.171.72])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 00:27:52 -0800
Message-ID: <db85c09f-3c9f-14ee-c4d8-b4d4faf8e7d6@intel.com>
Date:   Thu, 27 Jan 2022 16:27:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.5.0
Subject: Re: [PATCH V3 0/4] vDPA/ifcvf: implement shared IRQ feature
Content-Language: en-US
From:   "Zhu, Lingshan" <lingshan.zhu@intel.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     jasowang@redhat.com, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org
References: <20220126124912.90205-1-lingshan.zhu@intel.com>
 <20220126091329-mutt-send-email-mst@kernel.org>
 <841c85a6-1b3b-0d13-55ce-a51ae55bf901@intel.com>
In-Reply-To: <841c85a6-1b3b-0d13-55ce-a51ae55bf901@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/27/2022 12:31 PM, Zhu, Lingshan wrote:
>
>
> On 1/26/2022 10:14 PM, Michael S. Tsirkin wrote:
>> On Wed, Jan 26, 2022 at 08:49:08PM +0800, Zhu Lingshan wrote:
>>> It has been observed that on some platforms/devices, there may
>>> not be enough MSI vectors for virtqueues and the config change.
>>> Under such circumstances, the interrupt sources of a device
>>> have to share vectors/IRQs.
>>>
>>> This series implemented a shared IRQ feature for ifcvf.
>>>
>>> Please help review.
>> Given the history, can you please report which tests
>> were performed with this patchset? Which configs tested?
>> Thanks?
> Hi Michael,
>
> It is ping and netperf tests, and I have set nvectors = 1 and 2 in
> ifcvf_request_irq(), after ifcvf_alloc_vectors(),
> to hard coded the number of the allocate vectors.
>
> Thanks,
> Zhu Lingshan
We can verify the tests result by checking the requested IRQs for the 
two VMs(one vhost-vdpa device per VM).
(1)when setting nvectors = 1, only one IRQs requested per VM/device, all 
vqs and the config interrupt share this IRQ.
[lszhu@cra01infra01 ~]$ cat /proc/interrupts | grep ifc
  241:          0          0          0          0 0          0          
0          0          0          0 0          0          0          
0          0          0 0          0          0          0          
0          0 0          0          0          0          0          0 
0          0         45          0          0          0 0          
0          0          0          0          0 IR-PCI-MSI 
534528-edge      ifcvf[0000:01:00.5]-dev-shared-irq
  251:          0          0          0          0 0          0          
0          0          0          0 0         41          0          
0          0          0 0          0          0          0          
0          0 0          0          0          0          0          0 
0          0          0          0          0          0 0          
0          0          0          0          0 IR-PCI-MSI 
536576-edge      ifcvf[0000:01:00.6]-dev-shared-irq

(2)when setting nvectors = 2, two IRQs requested for each VM/device, one 
for all vqs, the other for the config interrupt
[lszhu@cra01infra01 ~]$ cat /proc/interrupts | grep ifc
  241:          0          0          0          0 0          0          
0          0          0          0 0          0          0          
0          0          0 0          0          0          0          
0          0 0          0          0          0          0          0 
0          0         39          0          0          0 0          
0          0          0          0          0 IR-PCI-MSI 
534528-edge      ifcvf[0000:01:00.5]-vqs-shared-irq
  242:          0          0          0          0 0          0          
0          0          0          0 0          0          0          
0          0          0 0          0          0          0          
0          0 0          0          0          0          0          0 
0          0          0          0          0          0 0          
0          0          0          0          0 IR-PCI-MSI 
534529-edge      ifcvf[0000:01:00.5]-config
  251:          0          0          0          0 0          0          
0          0          0          0 0         39          0          
0          0          0 0          0          0          0          
0          0 0          0          0          0          0          0 
0          0          0          0          0          0 0          
0          0          0          0          0 IR-PCI-MSI 
536576-edge      ifcvf[0000:01:00.6]-vqs-shared-irq
  252:          0          0          0          0 0          0          
0          0          0          0 0          0          0          
0          0          0 0          0          0          0          
0          0 0          0          0          0          0          0 
0          0          0          0          0          0 0          
0          0          0          0          0 IR-PCI-MSI 
536577-edge      ifcvf[0000:01:00.6]-config

(3)when remove nvectors hardcode, the driver allocates enough vectors 
for the queues and config interrupt,
and we do see better performance because irq_bypass is enabled:(too many 
lines, cut off)
[lszhu@cra01infra01 linux]$ cat /proc/interrupts | grep ifc
  241:          0          0          0          0 0          0          
0          0          0          0 0          0          0          
0          0          0 0          0          0          0          
0          0 0          0          0          0          0          0 
0          0          0          0          0          0 0          
0          0          0          0          0 IR-PCI-MSI 
534528-edge      ifcvf[0000:01:00.5]-0
  242:          0          0          0          0 0          0          
0          0          0          0 0          0          0          
0          0          0 0          0          0          0          
0          0 0          0          0          0          0          0 
0          0          0          0          0          0 0          
0          0          0          0          0 IR-PCI-MSI 
534529-edge      ifcvf[0000:01:00.5]-1
  243:          0          0          0          0 0          0          
0          0          0          0 0          0          0          
0          0          0 0          0          0          0          
0          0 0          0          0          0          0          0 
0          0          0          0          0          0 0          
0          0          0          0          0 IR-PCI-MSI 
534530-edge      ifcvf[0000:01:00.5]-2
  244:          0          0          0          0 0          0          
0          0          0          0 0          0          0          
0          0          0 0          0          0          0          
0          0 0          0          0          0          0          0 
0          0          0          0          0          0 0          
0          0          0          0          0 IR-PCI-MSI 
534531-edge      ifcvf[0000:01:00.5]-3
  245:          0          0          0          0 0          0          
0          0          0          0 0          0          0          
0          0          0 0          0          0          0          
0          0 0          0          0          0          0          0 
0          0          0          0          0          0 0          
0          0          0          0          0 IR-PCI-MSI 
534532-edge      ifcvf[0000:01:00.5]-4
  246:          0          0          0          0 0          0          
0          0          0          0 0          0          0          
0          0          0 0          0          0          0          
0          0 0          0          0          0          0          0 
0          0          0          0          0          0 0          
0          0          0          0          0 IR-PCI-MSI 
534533-edge      ifcvf[0000:01:00.5]-5
  247:          0          0          0          0 0          0          
0          0          0          0 0          0          0          
0          0          0 0          0          0          0          
0          0 0          0          0          0          0          0 
0          0          0          0          0          0 0          
0          0          0          0          0 IR-PCI-MSI 
534534-edge      ifcvf[0000:01:00.5]-6
  248:          0          0          0          0 0          0          
0          0          0          0 0          0          0          
0          0          0 0          0          0          0          
0          0 0          0          0          0          0          0 
0          0          0          0          0          0 0          
0          0          0          0          0 IR-PCI-MSI 
534535-edge      ifcvf[0000:01:00.5]-7
  249:          0          0          0          0 0          0          
0          0          0          0 0          0          0          
0          0          0 0          0          0          0          
0          0 0          0          0          0          0          0 
0          0          0          0          0          0 0          
0          0          0          0          0 IR-PCI-MSI 
534536-edge      ifcvf[0000:01:00.5]-8
  250:          0          0          0          0 0          0          
0          0          0          0 0          0          0          
0          0          0 0          0          0          0          
0          0 0          0          0          0          0          0 
0          0          0          0          0          0 0          
0          0          0          0          0 IR-PCI-MSI 
534537-edge      ifcvf[0000:01:00.5]-config
  251:          0          0          0          0 0          0          
0          0          0          0 0          0          0          
0          0          0 0          0          0          0          
0          0 0          0          0          0          0          0 
0          0          0          0          0          0 0          
0          0          0          0          0 IR-PCI-MSI 
536576-edge      ifcvf[0000:01:00.6]-0
  252:          0          0          0          0 0          0          
0          0          0          0 0          0          0          
0          0          0 0          0          0          0          
0          0 0          0          0          0          0          0 
0          0          0          0          0          0 0          
0          0          0          0          0 IR-PCI-MSI 
536577-edge      ifcvf[0000:01:00.6]-1

Thanks,
Zhu Lingshan


>>
>>> Changes from V2:
>>> (1) Fix misuse of nvectors(in ifcvf_alloc_vectors return 
>>> value)(Michael)
>>> (2) Fix misuse of irq = get_vq_irq() in setup irqbypass(Michael)
>>> (3) Coding style improvements(Michael)
>>> (4) Better naming of device shared irq/shared vq irq
>>>
>>> Changes from V1:
>>> (1) Enable config interrupt when only one vector is allocated(Michael)
>>> (2) Clean vectors/IRQs if failed to request config interrupt
>>> since config interrupt is a must(Michael)
>>> (3) Keep local vdpa_ops, disable irq_bypass by setting IRQ = -EINVAL
>>> for shared IRQ case(Michael)
>>> (4) Improvements on error messages(Michael)
>>> (5) Squash functions implementation patches to the callers(Michael)
>>>
>>> Zhu Lingshan (4):
>>>    vDPA/ifcvf: implement IO read/write helpers in the header file
>>>    vDPA/ifcvf: implement device MSIX vector allocator
>>>    vhost_vdpa: don't setup irq offloading when irq_num < 0
>>>    vDPA/ifcvf: implement shared IRQ feature
>>>
>>>   drivers/vdpa/ifcvf/ifcvf_base.c |  67 +++-----
>>>   drivers/vdpa/ifcvf/ifcvf_base.h |  60 +++++++-
>>>   drivers/vdpa/ifcvf/ifcvf_main.c | 260 
>>> ++++++++++++++++++++++++++++----
>>>   drivers/vhost/vdpa.c            |   4 +
>>>   4 files changed, 312 insertions(+), 79 deletions(-)
>>>
>>> -- 
>>> 2.27.0
>

