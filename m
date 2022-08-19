Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C218B59A846
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 00:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240319AbiHSWTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 18:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbiHSWS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 18:18:59 -0400
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9984EB2851;
        Fri, 19 Aug 2022 15:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=pfV3W5tIDS7uvHHlXIEyDkDagWNi+Z86KWqZSqCzOrI=; b=sY1n8Aq6cKn+8C+zsSeV/uxggm
        nsj/09ZQvFYE+q97bRBlzjnW1zw5RbFDAnFolBKYT6KrCpDrsXE1skijRnZWS19ElGNWcV5X4mpAU
        dPTTKVW8Ybf0lsZ+/2nZtUSKRL8Tsrvh7PeUAO5+1gcci5JuGcxPHddWjR8qmRG7owXlYfJB4r7z2
        gygAEeJyjzZWEZLKLqNxZ2NITsVeZECMoYr2HilmMgOn6hF92BWV6bQedzTrYdl8A4e5mubOIC1f3
        GjHAfCmlUSyzNEzj/212l9Gi3pAbATQtzxezcnnn2wIWy1pePhpNmlSJIReIg6cL3Lz4Qmauejy6k
        jX0jtSbQ==;
Received: from [179.232.144.59] (helo=localhost)
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
        id 1oPAJo-00Carb-O5; Sat, 20 Aug 2022 00:18:22 +0200
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
        will@kernel.org, xuqiang36@huawei.com,
        "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
        bcm-kernel-feedback-list@broadcom.com, linux-alpha@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        linux-efi@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-um@lists.infradead.org
Subject: [PATCH V3 00/11] The panic notifiers refactor - fixes/clean-ups (V3)
Date:   Fri, 19 Aug 2022 19:17:20 -0300
Message-Id: <20220819221731.480795-1-gpiccoli@igalia.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey everybody, this the third iteration of the panic notifiers
fixes/clean-ups;

V2 available at:
https://lore.kernel.org/lkml/20220719195325.402745-1-gpiccoli@igalia.com/

V1 (including the refactor) available at:
https://lore.kernel.org/lkml/20220427224924.592546-1-gpiccoli@igalia.com/


There wasn't much change here compared to V2 (the specifics are in the
patches), but a global change is that I've rebased against 6.0-rc1.
One patch got merged in -next, another one was re-submit in a standalone
format (requested by maintainer), so both of these are not here anymore.


As usual, tested this series building for all affected architecture/drivers
and also through some boot/runtime tests; below the test "matrix" used:

Build tests (using cross-compilers): alpha, arm, arm64, parisc, um, x86_64.
Boot/Runtime tests: x86_64 (QEMU guests and Steam Deck).

Here is the link with the .config files used:
https://people.igalia.com/gpiccoli/panic_notifiers_configs/6.0-rc1/


About the merge strategy: I've noticed there is a difference in maintainers
preferences (and my preference as well), so I see 3 strategies for merge:

(a) Maintainers pick patches that are good from the series and merge in
their trees;

(b) Some maintainer would pick the whole series and merge, at once, given
that everything is fine/ack/reviewed.

(c) I must re-send patches individually once they are reviewed/acked, as
standalone patches to the relevant maintainers, so they can merge it in
their trees.

I'm willing to do what's best for everybody - (a) is my choice when possible,
(b) seems to stall things and potentially cause conflicts, (c) seems to be
the compromise. I'll do that as per preference of the respective maintainers.


As usual, reviews / comments are always welcome, thanks in advance for them!
Cheers,

Guilherme


Guilherme G. Piccoli (11):
  ARM: Disable FIQs (but not IRQs) on CPUs shutdown paths
  notifier: Add panic notifiers info and purge trailing whitespaces
  alpha: Clean-up the panic notifier code
  um: Improve panic notifiers consistency and ordering
  parisc: Replace regular spinlock with spin_trylock on panic path
  tracing: Improve panic/die notifiers
  notifiers: Add tracepoints to the notifiers infrastructure
  EDAC/altera: Skip the panic notifier if kdump is loaded
  video/hyperv_fb: Avoid taking busy spinlock on panic path
  drivers/hv/vmbus, video/hyperv_fb: Untangle and refactor Hyper-V panic notifiers
  panic: Fixes the panic_print NMI backtrace setting

 arch/alpha/kernel/setup.c        |  36 +++++-----
 arch/arm/kernel/machine_kexec.c  |   2 +
 arch/arm/kernel/smp.c            |   5 +-
 arch/parisc/include/asm/pdc.h    |   1 +
 arch/parisc/kernel/firmware.c    |  27 ++++++--
 arch/um/drivers/mconsole_kern.c  |   7 +-
 arch/um/kernel/um_arch.c         |   8 +--
 drivers/edac/altera_edac.c       |  16 +++--
 drivers/hv/ring_buffer.c         |  13 ++++
 drivers/hv/vmbus_drv.c           | 109 +++++++++++++++++++------------
 drivers/parisc/power.c           |  17 +++--
 drivers/video/fbdev/hyperv_fb.c  |  16 ++++-
 include/linux/hyperv.h           |   2 +
 include/linux/notifier.h         |   8 ++-
 include/trace/events/notifiers.h |  69 +++++++++++++++++++
 kernel/notifier.c                |   6 ++
 kernel/panic.c                   |  47 +++++++------
 kernel/trace/trace.c             |  55 ++++++++--------
 18 files changed, 302 insertions(+), 142 deletions(-)
 create mode 100644 include/trace/events/notifiers.h

-- 
2.37.2

