Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42CC614336
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 02:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727950AbfEFA3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 20:29:36 -0400
Received: from mga06.intel.com ([134.134.136.31]:15298 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727285AbfEFA3f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 May 2019 20:29:35 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 May 2019 17:29:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,435,1549958400"; 
   d="scan'208";a="140299105"
Received: from romley-ivt3.sc.intel.com ([172.25.110.60])
  by orsmga008.jf.intel.com with ESMTP; 05 May 2019 17:29:34 -0700
Date:   Sun, 5 May 2019 17:21:08 -0700
From:   Fenghua Yu <fenghua.yu@intel.com>
To:     Ingo Molnar <mingo@kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        H Peter Anvin <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ravi V Shankar <ravi.v.shankar@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Christopherson Sean J <sean.j.christopherson@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Michael Chan <michael.chan@broadcom.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v8 15/15] x86/split_lock: Add a sysfs interface to
 enable/disable split lock detection during run time
Message-ID: <20190506002108.GB110479@romley-ivt3.sc.intel.com>
References: <1556134382-58814-1-git-send-email-fenghua.yu@intel.com>
 <1556134382-58814-16-git-send-email-fenghua.yu@intel.com>
 <20190425063115.GD40105@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190425063115.GD40105@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 25, 2019 at 08:31:15AM +0200, Ingo Molnar wrote:
> 
> * Fenghua Yu <fenghua.yu@intel.com> wrote:
> 
> > +		disabled if split lock operation in kernel code happens on
> > +		the CPU. The interface doesn't show or control split lock
> > +		detection on individual CPU.
> 
> I.e. implementation and possible actual state are out of sync. Why?
> 
> Also, if it's a global flag, why waste memory on putting a sysfs knob 
> into every CPU's sysfs file?
> 
> Finally, why is a debugging facility in sysfs, why not a debugfs knob? 
> Using a sysctl would solve the percpu vs. global confusion as well ...

Can I put the interface in /sys/kernel/debug/x86/split_lock_detect?

> 
> > --- a/arch/x86/kernel/cpu/intel.c
> > +++ b/arch/x86/kernel/cpu/intel.c
> > @@ -35,6 +35,7 @@
> >  DEFINE_PER_CPU(u64, msr_test_ctl_cache);
> >  EXPORT_PER_CPU_SYMBOL_GPL(msr_test_ctl_cache);
> >  
> > +static DEFINE_MUTEX(split_lock_detect_mutex);
> >  static bool split_lock_detect_enable;
> 
> 'enable' is a verb in plain form - which we use for function names.
> 
> For variable names that denotes current state we typically use past 
> tense, i.e. 'enabled'.
> 
> (The only case where we'd us the split_lock_detect_enable name for a flag 
> if it's a flag to trigger some sort of enabling action - which this 
> isn't.)
> 
> Please review the whole series for various naming mishaps.
OK.

> 
> > +	mutex_lock(&split_lock_detect_mutex);
> > +
> > +	split_lock_detect_enable = val;
> > +
> > +	/* Update the split lock detection setting in MSR on all online CPUs. */
> > +	on_each_cpu(split_lock_update_msr, NULL, 1);
> > +
> > +	if (split_lock_detect_enable)
> > +		pr_info("enabled\n");
> > +	else
> > +		pr_info("disabled\n");
> > +
> > +	mutex_unlock(&split_lock_detect_mutex);
> 
> Instead of a mutex, please just use the global atomic debug flag which 
> controls the warning printout. By using that flag both for the WARN()ing 
> and for controlling MSR state all the races are solved and the code is 
> simplified.

So is it OK to define split_lock_debug and use it in #AC handler and in
here?

static atomic_t split_lock_debug;

in #AC handler:

+       if (atomic_cmpxchg(&split_lock_debug, 0, 1) == 0) {
+               /* Only warn split lock once */
+               WARN_ONCE(1, "split lock operation detected\n");
+               atomic_set(&split_lock_debug, 0);
+       }

And in split_lock_detect_store(), replace the mutex with split_lock_debug
like this:
 
-       mutex_lock(&split_lock_detect_mutex);
+       while (atomic_cmpxchg(&split_lock_debug, 1, 0))
+              cpu_relax();
.... 
-       mutex_unlock(&split_lock_detect_mutex);
+       atomic_set(&split_lock_debug, 0);
 
Is this right code for sync in both #AC handler and in
split_lock_detect_store()?

Thanks.

-Fenghua
