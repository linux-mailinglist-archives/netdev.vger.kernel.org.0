Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB9C155D1
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 23:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbfEFVsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 17:48:17 -0400
Received: from mga06.intel.com ([134.134.136.31]:9220 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725994AbfEFVsR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 May 2019 17:48:17 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 May 2019 14:48:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,439,1549958400"; 
   d="scan'208";a="148968542"
Received: from romley-ivt3.sc.intel.com ([172.25.110.60])
  by orsmga003.jf.intel.com with ESMTP; 06 May 2019 14:48:15 -0700
Date:   Mon, 6 May 2019 14:39:49 -0700
From:   Fenghua Yu <fenghua.yu@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
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
Subject: Re: [PATCH v8 13/15] x86/split_lock: Enable split lock detection by
 default
Message-ID: <20190506213948.GA124959@romley-ivt3.sc.intel.com>
References: <1556134382-58814-1-git-send-email-fenghua.yu@intel.com>
 <1556134382-58814-14-git-send-email-fenghua.yu@intel.com>
 <alpine.DEB.2.21.1904250943160.1762@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.21.1904250943160.1762@nanos.tec.linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 25, 2019 at 09:50:20AM +0200, Thomas Gleixner wrote:
> On Wed, 24 Apr 2019, Fenghua Yu wrote:
> >  
> > +static void split_lock_update_msr(void)
> > +{
> > +	/* Enable split lock detection */
> > +	msr_set_bit(MSR_TEST_CTL, TEST_CTL_SPLIT_LOCK_DETECT_SHIFT);
> > +	this_cpu_or(msr_test_ctl_cache, TEST_CTL_SPLIT_LOCK_DETECT);
> 
> I'm pretty sure, that I told you to utilize the cache proper. Again:
> 
> > > Nothing in this file initializes msr_test_ctl_cache explicitely. Register
> > > caching always requires to read the register and store it in the cache
> > > before doing anything with it. Nothing guarantees that all bits in that MSR
> > > are 0 by default forever.
> > >
> > > And once you do that _before_ calling split_lock_update_msr() then you can
> > > spare the RMW in that function.
> 
> So you managed to fix the initializaiton part, but then you still do a
> pointless RMW.

Ok. I see. msr_set_bit() is a RMW operation.

So is the following the right code to update msr and cache variable?

+static void split_lock_update_msr(void)
+{
+   /* Enable split lock detection */
+   this_cpu_or(msr_test_ctl_cache, TEST_CTL_SPLIT_LOCK_DETECT);
+   wrmsrl(MSR_TEST_CTL, msr_test_ctl_cache);

Thanks.

-Fenghua
