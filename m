Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FECA10CD41
	for <lists+netdev@lfdr.de>; Thu, 28 Nov 2019 17:52:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727326AbfK1QwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Nov 2019 11:52:16 -0500
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:28027 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726582AbfK1QwQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Nov 2019 11:52:16 -0500
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id xASGq5po012646;
        Thu, 28 Nov 2019 17:52:05 +0100
Date:   Thu, 28 Nov 2019 17:52:05 +0100
From:   Willy Tarreau <w@1wt.eu>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     "'Jesper Dangaard Brouer'" <brouer@redhat.com>,
        "'Marek Majkowski'" <marek@cloudflare.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        network dev <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: epoll_wait() performance
Message-ID: <20191128165205.GA12629@1wt.eu>
References: <bc84e68c0980466096b0d2f6aec95747@AcuMS.aculab.com>
 <CAJPywTJYDxGQtDWLferh8ObjGp3JsvOn1om1dCiTOtY6S3qyVg@mail.gmail.com>
 <5f4028c48a1a4673bd3b38728e8ade07@AcuMS.aculab.com>
 <20191127164821.1c41deff@carbon>
 <5eecf41c7e124d7dbc0ab363d94b7d13@AcuMS.aculab.com>
 <20191128121205.65c8dea1@carbon>
 <b71441bb2fa14bc7b583de643a1ccf8b@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b71441bb2fa14bc7b583de643a1ccf8b@AcuMS.aculab.com>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 28, 2019 at 04:37:01PM +0000, David Laight wrote:
> My test system tends to increase its clock rate when busy.
> (The fans speed up immediately, the cpu has a passive heatsink and all the
> case fans are connected (via buffers) to the motherboard 'cpu fan' header.)
> I could probably work out how to lock the frequency, but for some tests I run:
> $ while :; do :; done
> Putting 1 cpu into a userspace infinite loop make them all run flat out
> (until thermally throttled).

It would be way more efficient to only make the CPUs spin in the idle
loop. I wrote a small module a few years ago for this, which allows me
to do the equivalent of "idle=poll" at runtime. It's very convenient
in VMs as it significantly reduces your latency and jitter by preventing
them from sleeping. It's quite efficient as well to stabilize CPUs having
an important difference between their highest and lowest frequencies.

I'm attaching the patch here, it's straightforward, it was made on
3.14 and still worked unmodified on 4.19, I'm sure it still does with
more recent kernels.

Hoping this helps,
Willy

---

From 22d67389c2b28d924260b8ced78111111006ed94 Mon Sep 17 00:00:00 2001
From: Willy Tarreau <w@1wt.eu>
Date: Wed, 27 Jan 2016 17:24:54 +0100
Subject: staging: add a new "idle_poll" module to disable idle loop

Sometimes it's convenient to be able to switch to polled mode for the
idle loop. This module does just that, and reverts back to the original
mode once unloaded.
---
 drivers/staging/Kconfig               |  2 ++
 drivers/staging/Makefile              |  1 +
 drivers/staging/idle_poll/Kconfig     |  8 ++++++++
 drivers/staging/idle_poll/Makefile    |  7 +++++++
 drivers/staging/idle_poll/idle_poll.c | 22 ++++++++++++++++++++++
 kernel/cpu/idle.c                     |  1 +
 6 files changed, 41 insertions(+)
 create mode 100644 drivers/staging/idle_poll/Kconfig
 create mode 100644 drivers/staging/idle_poll/Makefile
 create mode 100644 drivers/staging/idle_poll/idle_poll.c

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index 9594f204d4fc..936a2721b0f7 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -148,4 +148,6 @@ source "drivers/staging/dgnc/Kconfig"
 
 source "drivers/staging/dgap/Kconfig"
 
+source "drivers/staging/idle_poll/Kconfig"
+
 endif # STAGING
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index 6ca1cf3dbcd4..d3d45aff73d2 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -66,3 +66,4 @@ obj-$(CONFIG_XILLYBUS)		+= xillybus/
 obj-$(CONFIG_DGNC)			+= dgnc/
 obj-$(CONFIG_DGAP)			+= dgap/
 obj-$(CONFIG_MTD_SPINAND_MT29F)	+= mt29f_spinand/
+obj-$(CONFIG_IDLE_POLL)		+= idle_poll/
diff --git a/drivers/staging/idle_poll/Kconfig b/drivers/staging/idle_poll/Kconfig
new file mode 100644
index 000000000000..4c96a21f66aa
--- /dev/null
+++ b/drivers/staging/idle_poll/Kconfig
@@ -0,0 +1,8 @@
+config IDLE_POLL
+	tristate "IDLE_POLL enabler"
+	help
+	    This module automatically enables polling-based idle loop.
+	    It is convenient in certain situations to simply load the
+	    module to disable the idle loop, or unload it to re-enable
+	    it.
+
diff --git a/drivers/staging/idle_poll/Makefile b/drivers/staging/idle_poll/Makefile
new file mode 100644
index 000000000000..60ad176f11f6
--- /dev/null
+++ b/drivers/staging/idle_poll/Makefile
@@ -0,0 +1,7 @@
+# This rule extracts the directory part from the location where this Makefile
+# is found, strips last slash and retrieves the last component which is used
+# to make a file name. It is a generic way of building modules which always
+# have the name of the directory they're located in. $(lastword) could have
+# been used instead of $(word $(words)) but it's bogus on some versions.
+
+obj-m += $(notdir $(patsubst %/,%,$(dir $(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))))).o
diff --git a/drivers/staging/idle_poll/idle_poll.c b/drivers/staging/idle_poll/idle_poll.c
new file mode 100644
index 000000000000..6f39f85cc61d
--- /dev/null
+++ b/drivers/staging/idle_poll/idle_poll.c
@@ -0,0 +1,22 @@
+#include <linux/module.h>
+#include <linux/cpu.h>
+
+static int __init modinit(void)
+{
+	cpu_idle_poll_ctrl(true);
+	return 0;
+}
+
+static void __exit modexit(void)
+{
+	cpu_idle_poll_ctrl(false);
+	return;
+}
+
+module_init(modinit);
+module_exit(modexit);
+
+MODULE_DESCRIPTION("idle_poll enabler");
+MODULE_AUTHOR("Willy Tarreau");
+MODULE_VERSION("0.0.1");
+MODULE_LICENSE("GPL");
diff --git a/kernel/cpu/idle.c b/kernel/cpu/idle.c
index 277f494c2a9a..fbf648bc52b2 100644
--- a/kernel/cpu/idle.c
+++ b/kernel/cpu/idle.c
@@ -22,6 +22,7 @@ void cpu_idle_poll_ctrl(bool enable)
 		WARN_ON_ONCE(cpu_idle_force_poll < 0);
 	}
 }
+EXPORT_SYMBOL(cpu_idle_poll_ctrl);
 
 #ifdef CONFIG_GENERIC_IDLE_POLL_SETUP
 static int __init cpu_idle_poll_setup(char *__unused)
-- 
2.20.1

