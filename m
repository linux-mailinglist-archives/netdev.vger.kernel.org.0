Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 428EC1D9D0F
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 18:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729340AbgESQmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 12:42:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:52802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727904AbgESQmj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 12:42:39 -0400
Received: from linux-8ccs (p57a239f2.dip0.t-ipconnect.de [87.162.57.242])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F07BB207C4;
        Tue, 19 May 2020 16:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589906559;
        bh=NabtR6PZxhQKa2qkObGucsxkJANX46GdH5LkCEebaCI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OCMudTaXQxP3Zac1+LwktFM6xC1F0VVMUASjmGUizWPeMYwhN6BukgaJeVf2gAqtX
         NkkHSBI58kRHBeUKUYLlTYkC1SeOne1I/8NW8OJBY76Herk0pAIvDfxCkfvjsg66um
         lnyy5RAW1x/aJoWyJhiapwGCOjrJ/SW/g+VBIkg4=
Date:   Tue, 19 May 2020 18:42:31 +0200
From:   Jessica Yu <jeyu@kernel.org>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     akpm@linux-foundation.org, arnd@arndb.de, rostedt@goodmis.org,
        mingo@redhat.com, aquini@redhat.com, cai@lca.pw, dyoung@redhat.com,
        bhe@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        gpiccoli@canonical.com, pmladek@suse.com, tiwai@suse.de,
        schlad@suse.de, andriy.shevchenko@linux.intel.com,
        keescook@chromium.org, daniel.vetter@ffwll.ch, will@kernel.org,
        mchehab+samsung@kernel.org, kvalo@codeaurora.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 01/15] taint: add module firmware crash taint support
Message-ID: <20200519164231.GA27392@linux-8ccs>
References: <20200515212846.1347-1-mcgrof@kernel.org>
 <20200515212846.1347-2-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200515212846.1347-2-mcgrof@kernel.org>
X-OS:   Linux linux-8ccs 4.12.14-lp150.12.61-default x86_64
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+++ Luis Chamberlain [15/05/20 21:28 +0000]:
>Device driver firmware can crash, and sometimes, this can leave your
>system in a state which makes the device or subsystem completely
>useless. Detecting this by inspecting /proc/sys/kernel/tainted instead
>of scraping some magical words from the kernel log, which is driver
>specific, is much easier. So instead provide a helper which lets drivers
>annotate this.
>
>Once this happens, scrapers can easily look for modules taint flags
>for a firmware crash. This will taint both the kernel and respective
>calling module.
>
>The new helper module_firmware_crashed() uses LOCKDEP_STILL_OK as this
>fact should in no way shape or form affect lockdep. This taint is device
>driver specific.
>
>Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
>---
> Documentation/admin-guide/tainted-kernels.rst |  6 ++++++
> include/linux/kernel.h                        |  3 ++-
> include/linux/module.h                        | 13 +++++++++++++
> include/trace/events/module.h                 |  3 ++-
> kernel/module.c                               |  5 +++--
> kernel/panic.c                                |  1 +
> tools/debugging/kernel-chktaint               |  7 +++++++
> 7 files changed, 34 insertions(+), 4 deletions(-)
>
>diff --git a/Documentation/admin-guide/tainted-kernels.rst b/Documentation/admin-guide/tainted-kernels.rst
>index 71e9184a9079..92530f1d60ae 100644
>--- a/Documentation/admin-guide/tainted-kernels.rst
>+++ b/Documentation/admin-guide/tainted-kernels.rst
>@@ -100,6 +100,7 @@ Bit  Log  Number  Reason that got the kernel tainted
>  15  _/K   32768  kernel has been live patched
>  16  _/X   65536  auxiliary taint, defined for and used by distros
>  17  _/T  131072  kernel was built with the struct randomization plugin
>+ 18  _/Q  262144  driver firmware crash annotation
> ===  ===  ======  ========================================================
>
> Note: The character ``_`` is representing a blank in this table to make reading
>@@ -162,3 +163,8 @@ More detailed explanation for tainting
>      produce extremely unusual kernel structure layouts (even performance
>      pathological ones), which is important to know when debugging. Set at
>      build time.
>+
>+ 18) ``Q`` used by device drivers to annotate that the device driver's firmware
>+     has crashed and the device's operation has been severely affected. The
>+     device may be left in a crippled state, requiring full driver removal /
>+     addition, system reboot, or it is unclear how long recovery will take.
>diff --git a/include/linux/kernel.h b/include/linux/kernel.h
>index 04a5885cec1b..19e1541c82c7 100644
>--- a/include/linux/kernel.h
>+++ b/include/linux/kernel.h
>@@ -601,7 +601,8 @@ extern enum system_states {
> #define TAINT_LIVEPATCH			15
> #define TAINT_AUX			16
> #define TAINT_RANDSTRUCT		17
>-#define TAINT_FLAGS_COUNT		18
>+#define TAINT_FIRMWARE_CRASH		18
>+#define TAINT_FLAGS_COUNT		19
>
> struct taint_flag {
> 	char c_true;	/* character printed when tainted */
>diff --git a/include/linux/module.h b/include/linux/module.h
>index 2c2e988bcf10..221200078180 100644
>--- a/include/linux/module.h
>+++ b/include/linux/module.h
>@@ -697,6 +697,14 @@ static inline bool is_livepatch_module(struct module *mod)
> bool is_module_sig_enforced(void);
> void set_module_sig_enforced(void);
>
>+void add_taint_module(struct module *mod, unsigned flag,
>+		      enum lockdep_ok lockdep_ok);
>+
>+static inline void module_firmware_crashed(void)
>+{
>+	add_taint_module(THIS_MODULE, TAINT_FIRMWARE_CRASH, LOCKDEP_STILL_OK);
>+}

Just a nit: I think module_firmware_crashed() is a confusing name - it
doesn't really tell me what it's doing, and it's not really related to
the rest of the module_* symbols, which mostly have to do with module
loader/module specifics. Especially since a driver can be built-in, too.
How about taint_firmware_crashed() or something similar?

Also, I think we might crash in add_taint_module() if a driver is
built into the kernel, because THIS_MODULE will be null and there is
no null pointer check in add_taint_module(). We could unify the
CONFIG_MODULES and !CONFIG_MODULES stubs and either add an `if (mod)`
check in add_taint_module() or add an #ifdef MODULE check in the stub
itself to call add_taint() or add_taint_module() as appropriate. Hope
that makes sense.

Thanks!

Jessica
