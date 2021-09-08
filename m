Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4600A403F73
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 21:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351998AbhIHTIC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 15:08:02 -0400
Received: from home.keithp.com ([63.227.221.253]:35604 "EHLO elaine.keithp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350390AbhIHTHa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Sep 2021 15:07:30 -0400
Received: from localhost (localhost [127.0.0.1])
        by elaine.keithp.com (Postfix) with ESMTP id 57B233F3088A;
        Wed,  8 Sep 2021 12:05:51 -0700 (PDT)
X-Virus-Scanned: Debian amavisd-new at keithp.com
Received: from elaine.keithp.com ([127.0.0.1])
        by localhost (elaine.keithp.com [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id 0QUbIxJ0odCs; Wed,  8 Sep 2021 12:05:51 -0700 (PDT)
Received: from keithp.com (168-103-156-98.tukw.qwest.net [168.103.156.98])
        by elaine.keithp.com (Postfix) with ESMTPSA id 913AE3F3088B;
        Wed,  8 Sep 2021 12:05:48 -0700 (PDT)
Received: by keithp.com (Postfix, from userid 1000)
        id 5D8FF1E6013A; Wed,  8 Sep 2021 12:06:09 -0700 (PDT)
From:   Keith Packard <keithpac@amazon.com>
To:     linux-kernel@vger.kernel.org
Cc:     Abbott Liu <liuwenliang@huawei.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Ben Segall <bsegall@google.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        bpf@vger.kernel.org, Christoph Lameter <cl@linux.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Dennis Zhou <dennis@kernel.org>, devicetree@vger.kernel.org,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Ingo Molnar <mingo@redhat.com>,
        Jason Wang <jasowang@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Joe Perches <joe@perches.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Keith Packard <keithpac@amazon.com>,
        KP Singh <kpsingh@kernel.org>, kvm@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mm@kvack.org, Manivannan Sadhasivam <mani@kernel.org>,
        Marc Zyngier <maz@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Mel Gorman <mgorman@suse.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Mike Rapoport <rppt@kernel.org>, netdev@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nick Desaulniers <ndesaulniers@gooogle.com>,
        Nicolas Pitre <nico@fluxnic.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Song Liu <songliubraving@fb.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Valentin Schneider <valentin.schneider@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        virtualization@lists.linux-foundation.org,
        "Wolfram Sang (Renesas)" <wsa+renesas@sang-engineering.com>,
        YiFei Zhu <yifeifz2@illinois.edu>, Yonghong Song <yhs@fb.com>
Subject: [PATCH v4 4/7] Make sure task_struct is available for raw_smp_processor_id
Date:   Wed,  8 Sep 2021 12:06:02 -0700
Message-Id: <20210908190605.419064-5-keithpac@amazon.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210908190605.419064-1-keithpac@amazon.com>
References: <id:20210907220038.91021-1-keithpac@amazon.com>
 <20210908190605.419064-1-keithpac@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To allow architectures to use the 'cpu' field in task_struct for cpu
identification, the task_struct must be visible whereever the
raw_smp_processor_id macro is used. It would be simplest to include
linux/sched.h from the relevant asm/smp.h file, but that file is
included from linux/sched.h, and the recursive include ends up with
several declarations in the wrong order.

To avoid this, the PowerPC architecture code has this ugly hack:

	#define raw_smp_processor_id() \
		(*(unsigned int *)((void *)current + _TASK_CPU))

As an alternative, placing includes of linux/sched.h in a few files
that are used along with asm/smp.h means we can use the task_struct
field directly.

Signed-off-by: Keith Packard <keithpac@amazon.com>
---
 arch/arm/mm/proc-v7-bugs.c     | 1 +
 drivers/vhost/vhost.c          | 1 +
 drivers/vhost/vhost.h          | 1 +
 include/asm-generic/irq_regs.h | 1 +
 include/linux/of_address.h     | 1 +
 include/linux/random.h         | 1 +
 include/linux/topology.h       | 1 +
 init/calibrate.c               | 1 +
 kernel/bpf/bpf_lru_list.h      | 1 +
 kernel/bpf/percpu_freelist.h   | 1 +
 kernel/sched/cpuacct.c         | 2 +-
 lib/irq_regs.c                 | 1 +
 12 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mm/proc-v7-bugs.c b/arch/arm/mm/proc-v7-bugs.c
index 114c05ab4dd9..9ea078c619a7 100644
--- a/arch/arm/mm/proc-v7-bugs.c
+++ b/arch/arm/mm/proc-v7-bugs.c
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0
+#include <linux/sched.h>
 #include <linux/arm-smccc.h>
 #include <linux/kernel.h>
 #include <linux/smp.h>
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 5ccb0705beae..e5a073bb5b1e 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -10,6 +10,7 @@
  * Generic code for virtio server in host kernel.
  */
 
+#include <linux/sched.h>
 #include <linux/eventfd.h>
 #include <linux/vhost.h>
 #include <linux/uio.h>
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index b063324c7669..963d08ff2a62 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -2,6 +2,7 @@
 #ifndef _VHOST_H
 #define _VHOST_H
 
+#include <linux/sched.h>
 #include <linux/eventfd.h>
 #include <linux/vhost.h>
 #include <linux/mm.h>
diff --git a/include/asm-generic/irq_regs.h b/include/asm-generic/irq_regs.h
index 2e7c6e89d42e..ab4ca7ab362c 100644
--- a/include/asm-generic/irq_regs.h
+++ b/include/asm-generic/irq_regs.h
@@ -8,6 +8,7 @@
 #ifndef _ASM_GENERIC_IRQ_REGS_H
 #define _ASM_GENERIC_IRQ_REGS_H
 
+#include <linux/sched.h>
 #include <linux/percpu.h>
 
 /*
diff --git a/include/linux/of_address.h b/include/linux/of_address.h
index 88bc943405cd..60c30168d48d 100644
--- a/include/linux/of_address.h
+++ b/include/linux/of_address.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #ifndef __OF_ADDRESS_H
 #define __OF_ADDRESS_H
+#include <linux/sched.h>
 #include <linux/ioport.h>
 #include <linux/errno.h>
 #include <linux/of.h>
diff --git a/include/linux/random.h b/include/linux/random.h
index f45b8be3e3c4..0accd9277e95 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -7,6 +7,7 @@
 #ifndef _LINUX_RANDOM_H
 #define _LINUX_RANDOM_H
 
+#include <linux/sched.h>
 #include <linux/bug.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
diff --git a/include/linux/topology.h b/include/linux/topology.h
index 7634cd737061..4bd993bc9513 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -27,6 +27,7 @@
 #ifndef _LINUX_TOPOLOGY_H
 #define _LINUX_TOPOLOGY_H
 
+#include <linux/sched.h>
 #include <linux/arch_topology.h>
 #include <linux/cpumask.h>
 #include <linux/bitops.h>
diff --git a/init/calibrate.c b/init/calibrate.c
index f3831272f113..45002e27e385 100644
--- a/init/calibrate.c
+++ b/init/calibrate.c
@@ -10,6 +10,7 @@
 #include <linux/init.h>
 #include <linux/timex.h>
 #include <linux/smp.h>
+#include <linux/sched.h>
 #include <linux/percpu.h>
 
 unsigned long lpj_fine;
diff --git a/kernel/bpf/bpf_lru_list.h b/kernel/bpf/bpf_lru_list.h
index 6b12f06ee18c..5aed0c288c76 100644
--- a/kernel/bpf/bpf_lru_list.h
+++ b/kernel/bpf/bpf_lru_list.h
@@ -4,6 +4,7 @@
 #ifndef __BPF_LRU_LIST_H_
 #define __BPF_LRU_LIST_H_
 
+#include <linux/sched.h>
 #include <linux/list.h>
 #include <linux/spinlock_types.h>
 
diff --git a/kernel/bpf/percpu_freelist.h b/kernel/bpf/percpu_freelist.h
index 3c76553cfe57..3bc7a2bbe79b 100644
--- a/kernel/bpf/percpu_freelist.h
+++ b/kernel/bpf/percpu_freelist.h
@@ -3,6 +3,7 @@
  */
 #ifndef __PERCPU_FREELIST_H__
 #define __PERCPU_FREELIST_H__
+#include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/percpu.h>
 
diff --git a/kernel/sched/cpuacct.c b/kernel/sched/cpuacct.c
index 104a1bade14f..fb5f52e889a4 100644
--- a/kernel/sched/cpuacct.c
+++ b/kernel/sched/cpuacct.c
@@ -5,8 +5,8 @@
  * Based on the work by Paul Menage (menage@google.com) and Balbir Singh
  * (balbir@in.ibm.com).
  */
-#include <asm/irq_regs.h>
 #include "sched.h"
+#include <asm/irq_regs.h>
 
 /* Time spent by the tasks of the CPU accounting group executing in ... */
 enum cpuacct_stat_index {
diff --git a/lib/irq_regs.c b/lib/irq_regs.c
index 0d545a93070e..c9d8235f6444 100644
--- a/lib/irq_regs.c
+++ b/lib/irq_regs.c
@@ -5,6 +5,7 @@
  * Written by David Howells (dhowells@redhat.com)
  */
 #include <linux/export.h>
+#include <linux/sched.h>
 #include <linux/percpu.h>
 #include <asm/irq_regs.h>
 
-- 
2.33.0

