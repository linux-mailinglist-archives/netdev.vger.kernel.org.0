Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51C8857A78A
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 21:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234265AbiGSTyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 15:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230205AbiGSTyg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 15:54:36 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2DC352E7E;
        Tue, 19 Jul 2022 12:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=v6ALRzuY4RIlvqb5/OysD83kMB2n09igJBmCmJkb/mQ=; b=QX2ndssTwYlCGQttlP6yZb1v8t
        5s2Hg+pF+iNzzwWbJ4MQaGSaf6qkeb05PdTsq+Deth55WrA0pCBg5abgJ5rgV7rYQ1in6Q0iGiphA
        Ny8wQRwMi4VTn4nbzPtFheSJmfPAAsWP3wO6T6rwqeMZ6FBPSZbVJscxJAF1he9ZTINlqR7pMavHd
        JUmz54ZCbUg5czNAxrGNtKvvD4CjMf1IUILFMG1Fr7T+NXdQ+h0VrvP3Jd0esGE2WeLQ3wNsRgsoR
        A2H70K6+3TnyaQxqB5nwJ5zwLOp0Bqh1CdPhvwI1Y5O+c66ciesYb/MZNrPpMNAzxEEfLahEMj+q0
        vfS69Cnw==;
Received: from 200-100-212-117.dial-up.telesp.net.br ([200.100.212.117] helo=localhost)
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
        id 1oDtIK-006f8k-U4; Tue, 19 Jul 2022 21:54:15 +0200
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
To:     akpm@linux-foundation.org, bhe@redhat.com, pmladek@suse.com,
        kexec@lists.infradead.org
Cc:     linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org, x86@kernel.org, kernel-dev@igalia.com,
        kernel@gpiccoli.net, halves@canonical.com, fabiomirmar@gmail.com,
        alejandro.j.jimenez@oracle.com, andriy.shevchenko@linux.intel.com,
        arnd@arndb.de, bp@alien8.de, corbet@lwn.net,
        d.hatayama@jp.fujitsu.com, dave.hansen@linux.intel.com,
        dyoung@redhat.com, feng.tang@intel.com, gregkh@linuxfoundation.org,
        mikelley@microsoft.com, hidehiro.kawai.ez@hitachi.com,
        jgross@suse.com, john.ogness@linutronix.de, keescook@chromium.org,
        luto@kernel.org, mhiramat@kernel.org, mingo@redhat.com,
        paulmck@kernel.org, peterz@infradead.org, rostedt@goodmis.org,
        senozhatsky@chromium.org, stern@rowland.harvard.edu,
        tglx@linutronix.de, vgoyal@redhat.com, vkuznets@redhat.com,
        will@kernel.org, "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        bcm-kernel-feedback-list@broadcom.com, linux-alpha@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        linux-efi@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-um@lists.infradead.org
Subject: [PATCH v2 00/13] The panic notifiers refactor strikes back - fixes/clean-ups
Date:   Tue, 19 Jul 2022 16:53:13 -0300
Message-Id: <20220719195325.402745-1-gpiccoli@igalia.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi folks, this the second iteration of the panic notifiers refactor work,
but limited to the fixes/clean-ups in the first moment. The (full) V1 is
available at:
https://lore.kernel.org/lkml/20220427224924.592546-1-gpiccoli@igalia.com/

The idea of splitting the series is that, originally we had a bunch of fixes
followed by the notifiers refactor, but this second part (the effective
refactor) is a bit "polemic", with reviews having antagonistic goals and some
complexities  - it might be hard to achieve consensus.
For the curious, here is a good summary of the conflicting views and some
strategies we might take in the refactor V2:
https://lore.kernel.org/lkml/0d084eed-4781-c815-29c7-ac62c498e216@igalia.com/

So splitting and sending only the simple fixes/clean-ups in a first moment
makes sense, this way we don't prevent them to be discussed/merged/reworked
while the more complex part is subject to scrutiny in a different (future)
email thread.


I've tried to test this series building for all affected architecture/drivers
and also through some boot/runtime tests; below the test "matrix" used:

Build tests (using cross-compilers): alpha, arm, arm64, parisc, um, x86_64.
Boot/Runtime tests: x86_64 (Hyper-V and QEMU guests).

Here is the link with the .config files used:
https://people.igalia.com/gpiccoli/panic_notifiers_configs/5.19-rc7/
(tried my best to build all the affected code).


The series is based on 5.19-rc7; I'd like to ask that, if possible, maintainers
take the patches here in their trees, since there is no need to merge the series
as whole, patches are independent from each other.

Regarding the CC strategy, I've tried to reduce a bit the list of CCed emails,
given that it was huge in the first iteration. Hopefully I didn't forget
anybody interested in the topic (my apologies if so).

As usual, reviews / comments are always welcome, thanks in advance for them!
Cheers,


Guilherme




Guilherme G. Piccoli (13):
  ARM: Disable FIQs (but not IRQs) on CPUs shutdown paths
  notifier: Add panic notifiers info and purge trailing whitespaces
  firmware: google: Test spinlock on panic path to avoid lockups
  soc: bcm: brcmstb: Document panic notifier action and remove useless header
  alpha: Clean-up the panic notifier code
  um: Improve panic notifiers consistency and ordering
  parisc: Replace regular spinlock with spin_trylock on panic path
  tracing: Improve panic/die notifiers
  notifier: Show function names on notifier routines if DEBUG_NOTIFIERS is set
  EDAC/altera: Skip the panic notifier if kdump is loaded
  video/hyperv_fb: Avoid taking busy spinlock on panic path
  drivers/hv/vmbus, video/hyperv_fb: Untangle and refactor Hyper-V panic notifiers
  panic: Fixes the panic_print NMI backtrace setting

 arch/alpha/kernel/setup.c           |  36 ++++-----
 arch/arm/kernel/machine_kexec.c     |   2 +
 arch/arm/kernel/smp.c               |   5 +-
 arch/parisc/include/asm/pdc.h       |   1 +
 arch/parisc/kernel/firmware.c       |  27 ++++++-
 arch/um/drivers/mconsole_kern.c     |   7 +-
 arch/um/kernel/um_arch.c            |   8 +-
 drivers/edac/altera_edac.c          |  16 +++-
 drivers/firmware/google/gsmi.c      |   8 ++
 drivers/hv/ring_buffer.c            |  16 ++++
 drivers/hv/vmbus_drv.c              | 109 +++++++++++++++++-----------
 drivers/parisc/power.c              |  17 +++--
 drivers/soc/bcm/brcmstb/pm/pm-arm.c |  16 +++-
 drivers/video/fbdev/hyperv_fb.c     |  16 +++-
 include/linux/hyperv.h              |   2 +
 include/linux/notifier.h            |   8 +-
 kernel/notifier.c                   |  22 ++++--
 kernel/panic.c                      |  47 +++++++-----
 kernel/trace/trace.c                |  55 +++++++-------
 19 files changed, 268 insertions(+), 150 deletions(-)

-- 
2.37.1

