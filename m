Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 706906C0714
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 01:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbjCTAyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 20:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbjCTAyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 20:54:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59B211E9D9;
        Sun, 19 Mar 2023 17:53:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98C06B80D3F;
        Mon, 20 Mar 2023 00:53:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95958C433EF;
        Mon, 20 Mar 2023 00:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679273603;
        bh=ymHo4xqSlXI+y30Wq1XO9baK0xek3CKTl4Oe3cPo/Ks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d2T/btNrq2Wj3/sywSmTC9zHKsJ+Ki1bl50OYgVREYSv/7OuHmAcr0E1jWfPzoQjK
         WpoLLxtAV53BZsyN+h4L0vvYxsp0TVyn43Q+k8paX+ne43WFoHjfJM2ZBx/1K5krGS
         Gchb8nq69dtgveO7WLqkERFehRssqI4kQPQB3J+ycOn4uo6Zzk7qZQdfPjZPHnzBuJ
         Y7It0yXqGlZ0FIMAsBXNaNj8C0xGKgYafilUHANKLmIgQM/nkj4Ixr/3nNBbjim4Jz
         l20NKLIX8Nqd/uJA8M40oXGuL6gFdS4NiwJs1CiE87EawLjd+xhu1s+8CGZBxgD47C
         gS55hnXJRI2cQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Vernon Yang <vernon2gm@gmail.com>,
        Yury Norov <yury.norov@gmail.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Sasha Levin <sashal@kernel.org>, mpe@ellerman.id.au,
        tytso@mit.edu, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, christophe.leroy@csgroup.eu,
        npiggin@gmail.com, dmitry.osipenko@collabora.com, joel@jms.id.au,
        nathanl@linux.ibm.com, gustavoars@kernel.org,
        naveen.n.rao@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org,
        wireguard@lists.zx2c4.com, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 09/30] cpumask: fix incorrect cpumask scanning result checks
Date:   Sun, 19 Mar 2023 20:52:34 -0400
Message-Id: <20230320005258.1428043-9-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230320005258.1428043-1-sashal@kernel.org>
References: <20230320005258.1428043-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 8ca09d5fa3549d142c2080a72a4c70ce389163cd ]

It turns out that commit 596ff4a09b89 ("cpumask: re-introduce
constant-sized cpumask optimizations") exposed a number of cases of
drivers not checking the result of "cpumask_next()" and friends
correctly.

The documented correct check for "no more cpus in the cpumask" is to
check for the result being equal or larger than the number of possible
CPU ids, exactly _because_ we've always done those constant-sized
cpumask scans using a widened type before.  So the return value of a
cpumask scan should be checked with

	if (cpu >= nr_cpu_ids)
		...

because the cpumask scan did not necessarily stop exactly *at* that
maximum CPU id.

But a few cases ended up instead using checks like

	if (cpu == nr_cpumask_bits)
		...

which used that internal "widened" number of bits.  And that used to
work pretty much by accident (ok, in this case "by accident" is simply
because it matched the historical internal implementation of the cpumask
scanning, so it was more of a "intentionally using implementation
details rather than an accident").

But the extended constant-sized optimizations then did that internal
implementation differently, and now that code that did things wrong but
matched the old implementation no longer worked at all.

Which then causes subsequent odd problems due to using what ends up
being an invalid CPU ID.

Most of these cases require either unusual hardware or special uses to
hit, but the random.c one triggers quite easily.

All you really need is to have a sufficiently small CONFIG_NR_CPUS value
for the bit scanning optimization to be triggered, but not enough CPUs
to then actually fill that widened cpumask.  At that point, the cpumask
scanning will return the NR_CPUS constant, which is _not_ the same as
nr_cpumask_bits.

This just does the mindless fix with

   sed -i 's/== nr_cpumask_bits/>= nr_cpu_ids/'

to fix the incorrect uses.

The ones in the SCSI lpfc driver in particular could probably be fixed
more cleanly by just removing that repeated pattern entirely, but I am
not emptionally invested enough in that driver to care.

Reported-and-tested-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/lkml/481b19b5-83a0-4793-b4fd-194ad7b978c3@roeck-us.net/
Reported-and-tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/lkml/CAMuHMdUKo_Sf7TjKzcNDa8Ve+6QrK+P8nSQrSQ=6LTRmcBKNww@mail.gmail.com/
Reported-by: Vernon Yang <vernon2gm@gmail.com>
Link: https://lore.kernel.org/lkml/20230306160651.2016767-1-vernon2gm@gmail.com/
Cc: Yury Norov <yury.norov@gmail.com>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/xmon/xmon.c         |  2 +-
 drivers/char/random.c            |  2 +-
 drivers/net/wireguard/queueing.h |  2 +-
 drivers/scsi/lpfc/lpfc_init.c    | 14 +++++++-------
 4 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/xmon/xmon.c b/arch/powerpc/xmon/xmon.c
index 0da66bc4823d4..3b4e2475fc4ef 100644
--- a/arch/powerpc/xmon/xmon.c
+++ b/arch/powerpc/xmon/xmon.c
@@ -1277,7 +1277,7 @@ static int xmon_batch_next_cpu(void)
 	while (!cpumask_empty(&xmon_batch_cpus)) {
 		cpu = cpumask_next_wrap(smp_processor_id(), &xmon_batch_cpus,
 					xmon_batch_start_cpu, true);
-		if (cpu == nr_cpumask_bits)
+		if (cpu >= nr_cpu_ids)
 			break;
 		if (xmon_batch_start_cpu == -1)
 			xmon_batch_start_cpu = cpu;
diff --git a/drivers/char/random.c b/drivers/char/random.c
index ce3ccd172cc86..253f2ddb89130 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1311,7 +1311,7 @@ static void __cold try_to_generate_entropy(void)
 			/* Basic CPU round-robin, which avoids the current CPU. */
 			do {
 				cpu = cpumask_next(cpu, &timer_cpus);
-				if (cpu == nr_cpumask_bits)
+				if (cpu >= nr_cpu_ids)
 					cpu = cpumask_first(&timer_cpus);
 			} while (cpu == smp_processor_id() && num_cpus > 1);
 
diff --git a/drivers/net/wireguard/queueing.h b/drivers/net/wireguard/queueing.h
index 583adb37ee1e3..125284b346a77 100644
--- a/drivers/net/wireguard/queueing.h
+++ b/drivers/net/wireguard/queueing.h
@@ -106,7 +106,7 @@ static inline int wg_cpumask_choose_online(int *stored_cpu, unsigned int id)
 {
 	unsigned int cpu = *stored_cpu, cpu_index, i;
 
-	if (unlikely(cpu == nr_cpumask_bits ||
+	if (unlikely(cpu >= nr_cpu_ids ||
 		     !cpumask_test_cpu(cpu, cpu_online_mask))) {
 		cpu_index = id % cpumask_weight(cpu_online_mask);
 		cpu = cpumask_first(cpu_online_mask);
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 25ba20e428255..3fbd3bec26fc1 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -12507,7 +12507,7 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba, int vectors)
 					goto found_same;
 				new_cpu = cpumask_next(
 					new_cpu, cpu_present_mask);
-				if (new_cpu == nr_cpumask_bits)
+				if (new_cpu >= nr_cpu_ids)
 					new_cpu = first_cpu;
 			}
 			/* At this point, we leave the CPU as unassigned */
@@ -12521,7 +12521,7 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba, int vectors)
 			 * selecting the same IRQ.
 			 */
 			start_cpu = cpumask_next(new_cpu, cpu_present_mask);
-			if (start_cpu == nr_cpumask_bits)
+			if (start_cpu >= nr_cpu_ids)
 				start_cpu = first_cpu;
 
 			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
@@ -12557,7 +12557,7 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba, int vectors)
 					goto found_any;
 				new_cpu = cpumask_next(
 					new_cpu, cpu_present_mask);
-				if (new_cpu == nr_cpumask_bits)
+				if (new_cpu >= nr_cpu_ids)
 					new_cpu = first_cpu;
 			}
 			/* We should never leave an entry unassigned */
@@ -12575,7 +12575,7 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba, int vectors)
 			 * selecting the same IRQ.
 			 */
 			start_cpu = cpumask_next(new_cpu, cpu_present_mask);
-			if (start_cpu == nr_cpumask_bits)
+			if (start_cpu >= nr_cpu_ids)
 				start_cpu = first_cpu;
 
 			lpfc_printf_log(phba, KERN_INFO, LOG_INIT,
@@ -12648,7 +12648,7 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba, int vectors)
 				goto found_hdwq;
 			}
 			new_cpu = cpumask_next(new_cpu, cpu_present_mask);
-			if (new_cpu == nr_cpumask_bits)
+			if (new_cpu >= nr_cpu_ids)
 				new_cpu = first_cpu;
 		}
 
@@ -12663,7 +12663,7 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba, int vectors)
 				goto found_hdwq;
 
 			new_cpu = cpumask_next(new_cpu, cpu_present_mask);
-			if (new_cpu == nr_cpumask_bits)
+			if (new_cpu >= nr_cpu_ids)
 				new_cpu = first_cpu;
 		}
 
@@ -12674,7 +12674,7 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba, int vectors)
  found_hdwq:
 		/* We found an available entry, copy the IRQ info */
 		start_cpu = cpumask_next(new_cpu, cpu_present_mask);
-		if (start_cpu == nr_cpumask_bits)
+		if (start_cpu >= nr_cpu_ids)
 			start_cpu = first_cpu;
 		cpup->hdwq = new_cpup->hdwq;
  logit:
-- 
2.39.2

