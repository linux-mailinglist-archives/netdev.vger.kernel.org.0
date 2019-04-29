Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF333DB7C
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 07:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727279AbfD2FVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 01:21:20 -0400
Received: from mga17.intel.com ([192.55.52.151]:10549 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726585AbfD2FVU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 01:21:20 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Apr 2019 22:21:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,408,1549958400"; 
   d="scan'208";a="341652909"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.239.13.123]) ([10.239.13.123])
  by fmsmga005.fm.intel.com with ESMTP; 28 Apr 2019 22:21:18 -0700
Subject: Re: [PATCH v8 12/15] kvm/vmx: Emulate MSR TEST_CTL
To:     Thomas Gleixner <tglx@linutronix.de>,
        Xiaoyao Li <xiaoyao.li@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>, H Peter Anvin <hpa@zytor.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ravi V Shankar <ravi.v.shankar@intel.com>,
        Christopherson Sean J <sean.j.christopherson@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Michael Chan <michael.chan@broadcom.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org
References: <1556134382-58814-1-git-send-email-fenghua.yu@intel.com>
 <1556134382-58814-13-git-send-email-fenghua.yu@intel.com>
 <alpine.DEB.2.21.1904250931020.1762@nanos.tec.linutronix.de>
 <7395908840acfbf806146f5f20d3509342771a19.camel@linux.intel.com>
 <alpine.DEB.2.21.1904280903520.1757@nanos.tec.linutronix.de>
From:   Xiaoyao Li <xiaoyao.li@linux.intel.com>
Message-ID: <725e3442-949d-efe6-a60c-1ca3716428fb@linux.intel.com>
Date:   Mon, 29 Apr 2019 13:21:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.21.1904280903520.1757@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Thomas,

Base on your comments, I plan to make the design as following:

1) When host enables this feature, there is no switch between host and 
guest that guest running with it enabled by force. Since #AC in 
exception bitmap is set in current kvm, every #AC in guest will be 
trapped. And in handle_exception() handler in kvm, if #AC is caused by 
alignment check, kvm injects #AC back to guest; if #AC is caused by 
split lock, kvm sends a SIGBUS to userspace.

2) When host disables this feature, there needs atomic switch between 
host and guest if different. And in handle_exception() handler in kvm, 
we can just inject #AC back to guest, and let guest to handle it.

Besides, I think there might be an optimization for case #1.
When host has it enabled and guest also has it enabled, I think it's OK 
to inject #AC back to guest, not directly kill the guest.
Because guest kernel has it enabled means it knows what this feature is 
and it also want to get aware of and fault every split lock.
At this point, if guest has it enabled, we can leave it to guest. Only 
when guest's configuration is having it disabled, can it be regards as 
potentially harmful that we kill the guest once there is a #AC due to 
split lock.

How do you think about the design and this optimization?

Hi, Paolo,

What's your opinion about this design of split lock in KVM?

Thanks.

On 4/28/2019 3:09 PM, Thomas Gleixner wrote:
> On Sat, 27 Apr 2019, Xiaoyao Li wrote:
>> On Thu, 2019-04-25 at 09:42 +0200, Thomas Gleixner wrote:
>>> But the way more interesting question is why are you exposing the MSR and
>>> the bit to the guest at all if the host has split lock detection enabled?
>>>
>>> That does not make any sense as you basically allow the guest to switch it
>>> off and then launch a slowdown attack. If the host has it enabled, then a
>>> guest has to be treated like any other process and the #AC trap has to be
>>> caught by the hypervisor which then kills the guest.
>>>
>>> Only if the host has split lock detection disabled, then you can expose it
>>> and allow the guest to turn it on and handle it on its own.
>>
>> Indeed, if we use split lock detection for protection purpose, when host
>> has it enabled we should directly pass it to guest and forbid guest from
>> disabling it.  And only when host disables split lock detection, we can
>> expose it and allow the guest to turn it on.
> ?
>> If it is used for protection purpose, then it should follow what you said and
>> this feature needs to be disabled by default. Because there are split lock
>> issues in old/current kernels and BIOS. That will cause the existing guest
>> booting failure and killed due to those split lock.
> 
> Rightfully so.
> 
>> If it is only used for debug purpose, I think it might be OK to enable this
>> feature by default and make it indepedent between host and guest?
> 
> No. It does not make sense.
> 
>> So I think how to handle this feature between host and guest depends on how we
>> use it? Once you give me a decision, I will follow it in next version.
> 
> As I said: The host kernel makes the decision.
> 
> If the host kernel has it enabled then the guest is not allowed to change
> it. If the guest triggers an #AC it will be killed.
> 
> If the host kernel has it disabled then the guest can enable it for it's
> own purposes.
> 
> Thanks,
> 
> 	tglx
> 
