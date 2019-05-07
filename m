Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D73016CB5
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 22:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727961AbfEGU4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 16:56:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:10113 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727944AbfEGU4m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 16:56:42 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 May 2019 13:56:41 -0700
X-ExtLoop1: 1
Received: from romley-ivt3.sc.intel.com ([172.25.110.60])
  by orsmga008.jf.intel.com with ESMTP; 07 May 2019 13:56:40 -0700
Date:   Tue, 7 May 2019 13:48:12 -0700
From:   Fenghua Yu <fenghua.yu@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     David Laight <David.Laight@ACULAB.COM>,
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
        x86 <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v8 13/15] x86/split_lock: Enable split lock detection by
 default
Message-ID: <20190507204812.GC124959@romley-ivt3.sc.intel.com>
References: <1556134382-58814-1-git-send-email-fenghua.yu@intel.com>
 <1556134382-58814-14-git-send-email-fenghua.yu@intel.com>
 <762682ba43a0468897ff5ddbf6633d58@AcuMS.aculab.com>
 <alpine.DEB.2.21.1904251255590.1960@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.21.1904251255590.1960@nanos.tec.linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 25, 2019 at 12:58:32PM +0200, Thomas Gleixner wrote:
> On Thu, 25 Apr 2019, David Laight wrote:
> 
> > From:  Fenghua Yu
> > > Sent: 24 April 2019 20:33
> > > A split locked access locks bus and degrades overall memory access
> > > performance. When split lock detection feature is enumerated, enable
> > > the feature by default by writing 1 to bit 29 in MSR TEST_CTL to find
> > > any split lock issue.
> > 
> > You can't enable this by default until ALL the known potentially
> > misaligned locked memory operations have been fixed.
> 
> Errm? The result will be a WARN_ON() printed and no further damage. It's
> not making anything worse than it is now. In fact we just should add a
> 
>     WARN_ON_ONCE(!aligned_to_long(p)) to all the xxx_bit() operations.
> 
> so we catch them even when they do not trigger that #AC thingy.

I add WARN_ON_ONCE() in atomic xxx_bit(). But the code cannot be compiled.

Here is a simplified patch (only adding warning in set_bit()):

diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
index 8e790ec219a5..bc889ac12e26 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -14,6 +14,8 @@
 #endif

 #include <linux/compiler.h>
+#include <linux/kernel.h>
+#include <asm-generic/bug.h>
 #include <asm/alternative.h>
 #include <asm/rmwcc.h>
 #include <asm/barrier.h>
@@ -67,6 +69,8 @@
 static __always_inline void
 set_bit(long nr, volatile unsigned long *addr)
 {
+       WARN_ON_ONCE(!IS_ALIGNED((unsigned long)addr, sizeof(unsigned long)));
+
        if (IS_IMMEDIATE(nr)) {
                asm volatile(LOCK_PREFIX "orb %1,%0"
                        : CONST_MASK_ADDR(nr, addr)

gcc reports errors:
  CC      kernel/bounds.s
  CALL    scripts/atomic/check-atomics.sh
In file included from ./include/linux/bitops.h:19,
                 from ./include/linux/kernel.h:12,
                 from ./include/asm-generic/bug.h:18,
                 from ./arch/x86/include/asm/bug.h:83,
                 from ./include/linux/bug.h:5,
                 from ./include/linux/page-flags.h:10,
                 from kernel/bounds.c:10:
./arch/x86/include/asm/bitops.h: In function ‘set_bit’:
./arch/x86/include/asm/bitops.h:72:2: error: implicit declaration of function ‘WARN_ON_ONCE’; did you mean ‘WRITE_ONCE’? [-Werror=implicit-function-declaration]
  WARN_ON_ONCE(!IS_ALIGNED((unsigned long)addr, sizeof(unsigned long)));
  ^~~~~~~~~~~~
./arch/x86/include/asm/bitops.h:72:16: error: implicit declaration of function ‘IS_ALIGNED’; did you mean ‘IS_ENABLED’? [-Werror=implicit-function-declaration]
  WARN_ON_ONCE(!IS_ALIGNED((unsigned long)addr, sizeof(unsigned long)));
                ^~~~~~~~~~
I think it's because arch/x86/include/asm/bitops.h is included in
include/linux/kernel.h before IS_ALIGNED() is defined and in
include/asm-generic/bug.h before WARN_ON_ONCE() is defined.

How to write a right warn patch and solve the compilation issue?

Thanks.

-Fenghua
