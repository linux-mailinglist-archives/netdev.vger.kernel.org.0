Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A84E43CEE2
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 18:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239801AbhJ0QqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 12:46:19 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:45382 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237657AbhJ0QqT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 12:46:19 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id CE96021637;
        Wed, 27 Oct 2021 16:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1635353032; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type;
        bh=wjWcOQpKPYrltrU/q2bbFwJqLCaUyfo2FJLEzHDbz/w=;
        b=tTIWbW8zAG6209NeQd65H9NJ5BwCpZxv6KJCCn03h59DCXODghQw9jxrg4Tq8HkuUpM63C
        eqRIzeR1pX/uLYWXIvJbpSXiU7zQYfBuOUSABRFLSXMV6nsMe5P03WEiT5C0GoWAIRHadu
        6yy8HIecI/FdUI5xeR92KWYRSuXBEI4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1635353032;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type;
        bh=wjWcOQpKPYrltrU/q2bbFwJqLCaUyfo2FJLEzHDbz/w=;
        b=Fpfa3dUZANNLpfkRsRvWCsx6DfTzL6SYJ7o5LTHy0dCLxfmMwySdkVcDE/qPbxwrwtd4yd
        wpZK2zY7wMsrjnCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BBA5E14068;
        Wed, 27 Oct 2021 16:43:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id xgvFLciBeWGDCQAAMHmgww
        (envelope-from <jwiesner@suse.de>); Wed, 27 Oct 2021 16:43:52 +0000
Received: by incl.suse.cz (Postfix, from userid 1000)
        id 17066588CC; Wed, 27 Oct 2021 18:43:52 +0200 (CEST)
Date:   Wed, 27 Oct 2021 18:43:52 +0200
From:   Jiri Wiesner <jwiesner@suse.de>
To:     "Paul E. McKenney" <paulmck@kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>, Mel Gorman <mgorman@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>
Subject: [RFC PATCH] clocksource: increase watchdog retries
Message-ID: <20211027164352.GA23273@incl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A recent change to the clocksource watchdog in commit db3a34e17433
("clocksource: Retry clock read if long delays detected") has caused a
severe performance regression in TCP throughput tests. Netperf executed on
localhost was used for testing. The regression was more than 80%. On the
testing machine, the HPET clocksource was used to detect delays in reading
the TSC clocksource, which was the selected clocksource. In 10% of the
boots of the machine, TSC was marked unstable and the HPET clocksource was
selected as the best clocksource:

[   13.669682] clocksource: timekeeping watchdog on CPU6: hpet read-back delay of 60666ns, attempt 4, marking unstable
[   13.669827] tsc: Marking TSC unstable due to clocksource watchdog
[   13.669917] TSC found unstable after boot, most likely due to broken BIOS. Use 'tsc=unstable'.
[   13.670048] sched_clock: Marking unstable (11633513890, 2036384489)<-(13965149377, -295250974)
[   13.672268] clocksource: Checking clocksource tsc synchronization from CPU 0 to CPUs 1-3,6-7.
[   13.673148] clocksource: Switched to clocksource hpet

The earliest occurrence was this:

[    3.423636] clocksource: timekeeping watchdog on CPU2: hpet read-back delay of 61833ns, attempt 4, marking unstable
[    3.435182] tsc: Marking TSC unstable due to clocksource watchdog
[    3.455228] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    3.459182] hpet0: 8 comparators, 64-bit 24.000000 MHz counter
[    3.471195] clocksource: Switched to clocksource hpet

The HPET clocksource suffers from lock contention when its read() function
is executed on multiple CPUs concurrently. A perf profile from the netperf
test (netperf ran on CPU 1, netserver ran on CPU 0):

Samples: 14K of event 'bus-cycles'
Overhead  Command    Shared Object     Symbol                         CPU
  43.83%  netperf    [kernel.vmlinux]  [k] read_hpet                  001
  40.86%  netserver  [kernel.vmlinux]  [k] read_hpet                  000
   2.27%  netperf    [kernel.vmlinux]  [k] syscall_exit_to_user_mode  001
   2.19%  netserver  [kernel.vmlinux]  [k] syscall_exit_to_user_mode  000
   0.96%  netserver  [kernel.vmlinux]  [k] entry_SYSCALL_64           000
   0.92%  swapper    [kernel.vmlinux]  [k] read_hpet                  000

For timestamping, TCP needs to execute ktime_get() in both the transmit
and receive path. Lock contention caused by HPET on 2 CPUs was enough to
lose 88% of the throughput measured with TSC (1.6 Gbit/s with HPET, 13
Gbit/s with TSC). The lock contention can also be reproduced by switching
to HPET via sysfs.

Tests were carried out to tweak the value of the
clocksource.max_cswd_read_retries parameter. The results indicate that
setting the number of retries to 50 mitigates the issue on the testing
machine, but it does not make it go away entirely:

clocksource.max_cswd_read_retries=3
Reboots: 100  TSC unstable: 10
Reboots: 300  TSC unstable: 32
clocksource.max_cswd_read_retries=5
Reboots: 100  TSC unstable: 5
clocksource.max_cswd_read_retries=10
Reboots: 100  TSC unstable: 6
clocksource.max_cswd_read_retries=50
Reboots: 100  TSC unstable: 0
Reboots: 300  TSC unstable: 1

The testing machine has a Skylake CPU (Intel(R) Xeon(R) CPU E3-1240 v5 @
3.50GHz) with 4 cores (8 CPUs when SMT is on). Perhaps, the number of
retries to mitigate the issue could depend on the number of online CPUs on
the system. Tweaking clocksource.verify_n_cpus had no effect:

clocksource.max_cswd_read_retries=3 clocksource.verify_n_cpus=1
Reboots: 100  TSC unstable: 11

The issue has been observed on both Intel and AMD machines, and it is not
specific to Skylake CPUs. The observed regression varies but, so far, tens
of per cent have been observed.

Signed-off-by: Jiri Wiesner <jwiesner@suse.de>
---
 Documentation/admin-guide/kernel-parameters.txt | 4 ++--
 kernel/time/clocksource.c                       | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 43dc35fe5bc0..b8bebca0f520 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -603,8 +603,8 @@
 	clocksource.max_cswd_read_retries= [KNL]
 			Number of clocksource_watchdog() retries due to
 			external delays before the clock will be marked
-			unstable.  Defaults to three retries, that is,
-			four attempts to read the clock under test.
+			unstable.  Defaults to fifty retries, that is,
+			fiftyone attempts to read the clock under test.
 
 	clocksource.verify_n_cpus= [KNL]
 			Limit the number of CPUs checked for clocksources
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index b8a14d2fb5ba..c15de711617a 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -199,7 +199,7 @@ void clocksource_mark_unstable(struct clocksource *cs)
 	spin_unlock_irqrestore(&watchdog_lock, flags);
 }
 
-ulong max_cswd_read_retries = 3;
+ulong max_cswd_read_retries = 50;
 module_param(max_cswd_read_retries, ulong, 0644);
 EXPORT_SYMBOL_GPL(max_cswd_read_retries);
 static int verify_n_cpus = 8;
-- 
2.26.2

