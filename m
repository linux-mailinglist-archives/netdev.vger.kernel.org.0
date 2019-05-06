Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B57A14330
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 02:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728057AbfEFAUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 20:20:49 -0400
Received: from mga18.intel.com ([134.134.136.126]:43916 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727373AbfEFAUt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 May 2019 20:20:49 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 May 2019 17:20:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,435,1549958400"; 
   d="scan'208";a="140297852"
Received: from romley-ivt3.sc.intel.com ([172.25.110.60])
  by orsmga008.jf.intel.com with ESMTP; 05 May 2019 17:20:47 -0700
Date:   Sun, 5 May 2019 17:12:21 -0700
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
Subject: Re: [PATCH v8 05/15] x86/msr-index: Define MSR_IA32_CORE_CAPABILITY
 and split lock detection bit
Message-ID: <20190506001219.GA110479@romley-ivt3.sc.intel.com>
References: <1556134382-58814-1-git-send-email-fenghua.yu@intel.com>
 <1556134382-58814-6-git-send-email-fenghua.yu@intel.com>
 <20190425054511.GA40105@gmail.com>
 <20190425190148.GA64477@romley-ivt3.sc.intel.com>
 <20190425194714.GA58719@gmail.com>
 <20190425195154.GC64477@romley-ivt3.sc.intel.com>
 <20190425200830.GD58719@gmail.com>
 <20190425202226.GD64477@romley-ivt3.sc.intel.com>
 <20190426060010.GB122831@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190426060010.GB122831@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 26, 2019 at 08:00:10AM +0200, Ingo Molnar wrote:
> 
> * Fenghua Yu <fenghua.yu@intel.com> wrote:
> 
> > On Thu, Apr 25, 2019 at 10:08:30PM +0200, Ingo Molnar wrote:
> > > 
> > > * Fenghua Yu <fenghua.yu@intel.com> wrote:
> > > 
> > > > On Thu, Apr 25, 2019 at 09:47:14PM +0200, Ingo Molnar wrote:
> > > > > 
> > > > > * Fenghua Yu <fenghua.yu@intel.com> wrote:
> > > > > 
> > > > > > On Thu, Apr 25, 2019 at 07:45:11AM +0200, Ingo Molnar wrote:
> > > > > > > 
> > > > > > > * Fenghua Yu <fenghua.yu@intel.com> wrote:
> > > > > > > 
> > > > > > > > A new MSR_IA32_CORE_CAPABILITY (0xcf) is defined. Each bit in the MSR
> > > > > > > > enumerates a model specific feature. Currently bit 5 enumerates split
> > > > > > > > lock detection. When bit 5 is 1, split lock detection is supported.
> > > > > > > > When the bit is 0, split lock detection is not supported.
> > > > > > > > 
> > > > > > > > Please check the latest Intel 64 and IA-32 Architectures Software
> > > > > > > > Developer's Manual for more detailed information on the MSR and the
> > > > > > > > split lock detection bit.
> > > > > > > > 
> > > > > > > > Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> > > > > > > > ---
> > > > > > > >  arch/x86/include/asm/msr-index.h | 3 +++
> > > > > > > >  1 file changed, 3 insertions(+)
> > > > > > > > 
> > > > > > > > diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> > > > > > > > index ca5bc0eacb95..f65ef6f783d2 100644
> > > > > > > > --- a/arch/x86/include/asm/msr-index.h
> > > > > > > > +++ b/arch/x86/include/asm/msr-index.h
> > > > > > > > @@ -59,6 +59,9 @@
> > > > > > > >  #define MSR_PLATFORM_INFO_CPUID_FAULT_BIT	31
> > > > > > > >  #define MSR_PLATFORM_INFO_CPUID_FAULT		BIT_ULL(MSR_PLATFORM_INFO_CPUID_FAULT_BIT)
> > > > > > > >  
> > > > > > > > +#define MSR_IA32_CORE_CAPABILITY	0x000000cf
> > > > > > > > +#define CORE_CAP_SPLIT_LOCK_DETECT	BIT(5)     /* Detect split lock */
> > > > > > > 
> > > > > > > Please don't put comments into definitions.
> > > > > > 
> > > > > > I'll remove the comment and change definitions of the MSR and the split lock
> > > > > > detection bit as following:
> > > > > > 
> > > > > > +#define MSR_IA32_CORE_CAPABILITY                       0x000000cf
> > > > > > +#define MSR_IA32_CORE_CAPABILITY_SPLIT_LOCK_DETECT_BIT 5
> > > > > > +#define MSR_IA32_CORE_CAPABILITY_SPLIT_LOCK_DETECT     BIT(MSR_IA32_CORE_CAPABILITY_SPLIT_LOCK_DETECT_BIT)
> > > > > > 
> > > > > > Are these right changes?
> > > > > 
> > > > > I suspect it could be shortened to CORE_CAP as you (partly) did it 
> > > > > originally.
> > > > 
> > > > IA32_CORE_CAPABILITY is the MSR's exact name in the latest SDM (in Table 2-14):
> > > > https://software.intel.com/en-us/download/intel-64-and-ia-32-architectures-sdm-combined-volumes-1-2a-2b-2c-2d-3a-3b-3c-3d-and-4
> > > > 
> > > > So can I define the MSR and the bits as follows?
> > > > 
> > > > +#define MSR_IA32_CORE_CAP                       0x000000cf
> > > > +#define MSR_IA32_CORE_CAP_SPLIT_LOCK_DETECT_BIT 5
> > > > +#define MSR_IA32_CORE_CAP_SPLIT_LOCK_DETECT     BIT(MSR_IA32_CORE_CAP_SPLIT_LOCK_DETECT_BIT)
> > > 
> > > Yeah, I suppose that looks OK.
> > 
> > Should I also change the feature definition 'X86_FEATURE_CORE_CAPABILITY' to
> > 'X86_FEATURE_CORE_CAP' in cpufeatures.h in patch #0006 to match the
> > MSR definition here? Or should I still keep the current feature definition?
> > 
> > Thanks.
> 
> Hm, no, for CPU features it's good to follow the vendor convention.
> 
> So I guess the long-form CPU_CAPABILITY for all of these is the best 
> after all.

Since MSR_IA32_CORE_CAP_SPLIT_LOCK_DETECT_BIT is not used anywhere else
except in this patch, is it OK not to define this macro?

So this patch will only has two shorter lines:

+#define MSR_IA32_CORE_CAP                      0x000000cf
+#define MSR_IA32_CORE_CAP_SPLIT_LOCK_DETECT	BIT(5)

Is this OK for this patch to only define these two macros?

Thanks.

-Fenghua
