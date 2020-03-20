Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B994E18C716
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 06:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbgCTFiN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 20 Mar 2020 01:38:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:52332 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbgCTFiN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Mar 2020 01:38:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3EF15AC42;
        Fri, 20 Mar 2020 05:38:08 +0000 (UTC)
Date:   Thu, 19 Mar 2020 22:36:57 -0700
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Logan Gunthorpe <logang@deltatee.com>,
        Kurt Schwemmer <kurt.schwemmer@microsemi.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>,
        Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [patch V2 06/15] rcuwait: Add @state argument to
 rcuwait_wait_event()
Message-ID: <20200320053657.ggvcqsjtdotmrl7p@linux-p48b>
References: <20200318204302.693307984@linutronix.de>
 <20200318204408.010461877@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200318204408.010461877@linutronix.de>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Mar 2020, Thomas Gleixner wrote:

>--- a/include/linux/rcuwait.h
>+++ b/include/linux/rcuwait.h
>@@ -3,6 +3,7 @@
> #define _LINUX_RCUWAIT_H_
>
> #include <linux/rcupdate.h>
>+#include <linux/sched/signal.h>

So this is causing build to fail for me:

  CC      arch/x86/boot/compressed/cmdline.o
arch/x86/boot/compressed/cmdline.c:5:20: error: conflicting types for ‘set_fs’
 static inline void set_fs(unsigned long seg)
                    ^~~~~~
In file included from ./include/linux/uaccess.h:11:0,
                 from ./include/linux/sched/task.h:11,
                 from ./include/linux/sched/signal.h:9,
                 from ./include/linux/rcuwait.h:6,
                 from ./include/linux/percpu-rwsem.h:8,
                 from ./include/linux/fs.h:34,
                 from ./include/linux/proc_fs.h:9,
                 from ./include/acpi/acpi_bus.h:83,
                 from ./include/linux/acpi.h:32,
                 from arch/x86/boot/compressed/misc.h:28,
                 from arch/x86/boot/compressed/cmdline.c:2:
./arch/x86/include/asm/uaccess.h:29:20: note: previous definition of ‘set_fs’ was here
 static inline void set_fs(mm_segment_t fs)
                    ^~~~~~
make[2]: *** [scripts/Makefile.build:268: arch/x86/boot/compressed/cmdline.o] Error 1
make[1]: *** [arch/x86/boot/Makefile:113: arch/x86/boot/compressed/vmlinux] Error 2
make: *** [arch/x86/Makefile:285: bzImage] Error 2

Right now I'm not sure what the proper fix should be.

Thanks,
Davidlohr
