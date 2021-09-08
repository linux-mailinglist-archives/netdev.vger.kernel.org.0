Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0E9403F71
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 21:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350598AbhIHTH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 15:07:59 -0400
Received: from home.keithp.com ([63.227.221.253]:35594 "EHLO elaine.keithp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350387AbhIHTHa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Sep 2021 15:07:30 -0400
Received: from localhost (localhost [127.0.0.1])
        by elaine.keithp.com (Postfix) with ESMTP id DA45E3F30882;
        Wed,  8 Sep 2021 12:05:49 -0700 (PDT)
X-Virus-Scanned: Debian amavisd-new at keithp.com
Received: from elaine.keithp.com ([127.0.0.1])
        by localhost (elaine.keithp.com [127.0.0.1]) (amavisd-new, port 10024)
        with LMTP id ZJ8V24QNtY-4; Wed,  8 Sep 2021 12:05:49 -0700 (PDT)
Received: from keithp.com (168-103-156-98.tukw.qwest.net [168.103.156.98])
        by elaine.keithp.com (Postfix) with ESMTPSA id 769D03F30883;
        Wed,  8 Sep 2021 12:05:48 -0700 (PDT)
Received: by keithp.com (Postfix, from userid 1000)
        id 593CF1E60132; Wed,  8 Sep 2021 12:06:09 -0700 (PDT)
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
Subject: [PATCH v4 3/7] ARM: Use smp_processor_id() in vfp_pm_suspend instead of ti->cpu
Date:   Wed,  8 Sep 2021 12:06:01 -0700
Message-Id: <20210908190605.419064-4-keithpac@amazon.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210908190605.419064-1-keithpac@amazon.com>
References: <id:20210907220038.91021-1-keithpac@amazon.com>
 <20210908190605.419064-1-keithpac@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are equivalent when thread_info contains the CPU value, but when
THREAD_INFO_IN_TASK is enabled, cpu moves to task_struct. Using the macro
allows either.

Signed-off-by: Keith Packard <keithpac@amazon.com>
---
 arch/arm/vfp/vfpmodule.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/vfp/vfpmodule.c b/arch/arm/vfp/vfpmodule.c
index 2cb355c1b5b7..d7a3818da671 100644
--- a/arch/arm/vfp/vfpmodule.c
+++ b/arch/arm/vfp/vfpmodule.c
@@ -458,16 +458,16 @@ static int vfp_pm_suspend(void)
 
 		/* disable, just in case */
 		fmxr(FPEXC, fmrx(FPEXC) & ~FPEXC_EN);
-	} else if (vfp_current_hw_state[ti->cpu]) {
+	} else if (vfp_current_hw_state[smp_processor_id()]) {
 #ifndef CONFIG_SMP
 		fmxr(FPEXC, fpexc | FPEXC_EN);
-		vfp_save_state(vfp_current_hw_state[ti->cpu], fpexc);
+		vfp_save_state(vfp_current_hw_state[smp_processor_id()], fpexc);
 		fmxr(FPEXC, fpexc);
 #endif
 	}
 
 	/* clear any information we had about last context state */
-	vfp_current_hw_state[ti->cpu] = NULL;
+	vfp_current_hw_state[smp_processor_id()] = NULL;
 
 	return 0;
 }
-- 
2.33.0

