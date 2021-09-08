Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E125403F60
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 21:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349619AbhIHTHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 15:07:20 -0400
Received: from home.keithp.com ([63.227.221.253]:35386 "EHLO elaine.keithp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347196AbhIHTHU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Sep 2021 15:07:20 -0400
Received: from localhost (localhost [127.0.0.1])
        by elaine.keithp.com (Postfix) with ESMTP id B7B0F3F30886;
        Wed,  8 Sep 2021 12:05:47 -0700 (PDT)
X-Virus-Scanned: Debian amavisd-new at keithp.com
Received: from elaine.keithp.com ([127.0.0.1])
        by localhost (elaine.keithp.com [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id jjqKtPL7fQVo; Wed,  8 Sep 2021 12:05:47 -0700 (PDT)
Received: from keithp.com (168-103-156-98.tukw.qwest.net [168.103.156.98])
        by elaine.keithp.com (Postfix) with ESMTPSA id 4484C3F30881;
        Wed,  8 Sep 2021 12:05:47 -0700 (PDT)
Received: by keithp.com (Postfix, from userid 1000)
        id 4D1691E6011A; Wed,  8 Sep 2021 12:06:09 -0700 (PDT)
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
Subject: [PATCH v4 0/7] ARM: support THREAD_INFO_IN_TASK
Date:   Wed,  8 Sep 2021 12:05:58 -0700
Message-Id: <20210908190605.419064-1-keithpac@amazon.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <id:20210907220038.91021-1-keithpac@amazon.com>
References: <id:20210907220038.91021-1-keithpac@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Placing thread_info in the kernel stack leaves it vulnerable to stack
overflow attacks. This short series addresses that by using the
existing THREAD_INFO_IN_TASK infrastructure.

This is the fourth version of this series, in this version the changes
are restricted to hardware which provides the TPIDRPRW register. This
register is repurposed from holding the per_cpu_offset value to
holding the 'current' value as that allows fetching this value
atomically so that it can be used in a preemptable context.

The series is broken into seven pieces:

 1) Change the secondary_start_kernel API to receive the cpu
    number. This avoids needing to be able to find this value independently in
    future patches.

 2) Change the secondary_start_kernel API to also receive the 'task'
    value. Passing the value to this function also avoids needing to
    be able to discover it independently.

 3) A cleanup which avoids assuming that THREAD_INFO_IN_TASK is not set.

 4) Patches across the kernel which ensure that linux/sched.h has been
    included whenever raw_smp_processor_id() is used.

 5) Disable the optimization storing per_cpu_offset in TPIDRPRW. This
    leaves the register free to hold 'current' instead.

 6) Use TPIDRPRW for 'current'. This is enabled for either CPU_V6K or
    CPU_V7, but not if CPU_V6 is also enabled.

 7) Enable THREAD_INFO_IN_TASK whenever TPIDRPRW is used to hold 'current'.

Signed-off-by: Keith Packard <keithpac@amazon.com>

Keith Packard (7):
  ARM: Pass cpu number to secondary_start_kernel
  ARM: Pass task to secondary_start_kernel
  ARM: Use smp_processor_id() in vfp_pm_suspend instead of ti->cpu
  Make sure task_struct is available for raw_smp_processor_id
  ARM: Stop using TPIDRPRW to hold per_cpu_offset
  ARM: Use TPIDRPRW for current
  ARM: Move thread_info into task_struct (v7 only)

 arch/arm/Kconfig                   |  5 +++
 arch/arm/include/asm/assembler.h   | 12 +++++++
 arch/arm/include/asm/current.h     | 54 ++++++++++++++++++++++++++++++
 arch/arm/include/asm/percpu.h      | 31 -----------------
 arch/arm/include/asm/smp.h         |  8 ++++-
 arch/arm/include/asm/thread_info.h | 12 ++++++-
 arch/arm/kernel/asm-offsets.c      |  4 +++
 arch/arm/kernel/entry-armv.S       |  8 +++++
 arch/arm/kernel/head-nommu.S       |  2 ++
 arch/arm/kernel/head.S             |  2 ++
 arch/arm/kernel/setup.c            | 14 +-------
 arch/arm/kernel/smp.c              | 16 +++++----
 arch/arm/mm/proc-v7-bugs.c         |  1 +
 arch/arm/vfp/vfpmodule.c           | 15 +++++++--
 drivers/vhost/vhost.c              |  1 +
 drivers/vhost/vhost.h              |  1 +
 include/asm-generic/irq_regs.h     |  1 +
 include/linux/of_address.h         |  1 +
 include/linux/random.h             |  1 +
 include/linux/topology.h           |  1 +
 init/calibrate.c                   |  1 +
 kernel/bpf/bpf_lru_list.h          |  1 +
 kernel/bpf/percpu_freelist.h       |  1 +
 kernel/sched/cpuacct.c             |  2 +-
 lib/irq_regs.c                     |  1 +
 25 files changed, 140 insertions(+), 56 deletions(-)
 create mode 100644 arch/arm/include/asm/current.h

-- 
2.33.0

