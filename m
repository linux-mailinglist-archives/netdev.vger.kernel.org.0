Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9C76DC2C4
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 04:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbjDJCbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Apr 2023 22:31:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjDJCbc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Apr 2023 22:31:32 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 981602707;
        Sun,  9 Apr 2023 19:31:31 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id bp17-20020a17090b0c1100b0023f187954acso3303559pjb.2;
        Sun, 09 Apr 2023 19:31:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681093891; x=1683685891;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mpFF/VqHtE+TuqqNi8LVshwWxgcQnxj8M9eyzVRSZqE=;
        b=BthMhqjaWBZLUX4mWLRo84bs2FhJ32UPwi1xnOrIrGN8M01cTjAcvXTXxiIEsGJ7z8
         eUILreRcTW7bU1h53Sxk37zMzk88voSq6t4WwxyWB3AYcOnRGiUYEfrhBMpCOdEHaQo7
         zQtbhBE/Xgaq/Onxq1VkCbelkaQrzvzwEtxVfQk2tlTF/x6qNj00ICIOulzxE17EfU55
         KJUM5sYZq52wrxJFqWzPm8XgaIa21oxiZrAWYegb25a4HCCXQK19R5sMvsQVwtePNkDM
         ikU8ZmMUf4xHoQX/S77S+d1qDbLTZhvzQ6MRJJjVyDHP6IXP+0d1+pyl57sCHCC8G3oN
         owdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681093891; x=1683685891;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mpFF/VqHtE+TuqqNi8LVshwWxgcQnxj8M9eyzVRSZqE=;
        b=JpMeibwd+SXEs2ePi1tnxBSnGTwrlFkAWWyQcMoFru6WoJCuMUAcXmyUFcgfLJORCe
         iHAM/uYPe7KGCQkMFUxP7ffbgpmsr3lK51CuwD303y0AfnA7L8kNps7U4mL/fibuBUMG
         7Y0ng0kbOaZ4Tuxb4gI3hKKLEwPA1cVeQBqLh0Q4hMSDKzOE878m/qc4n46rFgOmntJa
         v0ym7KF2ea86gmbVf+ebwUUrOtjm8hkbHRVqwtx7u+xfihppuGzyO0ud6WrIsmWB/n9l
         ogqEBpC9wYZ8d1oeOhr+8M/Bjm6rkIsxsP2B4/lgm39+U46CrpZ2wFhqWJMVpWf44SSF
         i6FA==
X-Gm-Message-State: AAQBX9dk+BF1I7NNhl/T8heF7VykboKwNeckink4Q18FWt8XGl3S34OO
        oIVLKKK7Z3yu9097OwHmO8MUD/A/nnw=
X-Google-Smtp-Source: AKy350bbyWkMazdEexbdwR1o3BAgySsKuJ6U2gzkGLbuNNnfdTsjiK4SYdywQujX99asW2Ly/LVaNw==
X-Received: by 2002:a17:902:c613:b0:1a2:85f0:e748 with SMTP id r19-20020a170902c61300b001a285f0e748mr8981476plr.20.1681093890908;
        Sun, 09 Apr 2023 19:31:30 -0700 (PDT)
Received: from KERNELXING-MB0.tencent.com ([103.7.29.31])
        by smtp.gmail.com with ESMTPSA id jo18-20020a170903055200b0019a70a85e8fsm6512789plb.220.2023.04.09.19.31.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Apr 2023 19:31:30 -0700 (PDT)
From:   Jason Xing <kerneljasonxing@gmail.com>
To:     paulmck@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        bigeasy@linutronix.de, frederic@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kerneljasonxing@gmail.com, Jason Xing <kernelxing@tencent.com>
Subject: [PATCH] softirq: let the userside tune the SOFTIRQ_NOW_MASK with sysctl
Date:   Mon, 10 Apr 2023 10:30:41 +0800
Message-Id: <20230410023041.49857-1-kerneljasonxing@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Xing <kernelxing@tencent.com>

Currently we have two exceptions which could avoid ksoftirqd when
invoking softirqs: HI_SOFTIRQ and TASKLET_SOFTIRQ. They were introduced
in the commit 3c53776e29f8 ("Mark HI and TASKLET softirq synchronous")
which says if we don't mask them, it will cause excessive latencies in
some cases.

It also mentioned that we may take time softirq into consideration:
"We should probably also consider the timer softirqs to be synchronous
and not be delayed to ksoftirqd."

The same reason goes here. In production workload, we found that some
sensitive applications are complaining about the high latency of
tx/rx path in networking, because some packets have to be delayed in
ksoftirqd kthread that can be blocked in the runqueue for some while
(say, 10-70 ms) especially in guestOS. So marking tx/rx softirq
synchronous, for instance, NET_RX_SOFTIRQ, solves such issue.

We tested and observed the high latency above 50ms of the rx path in
the real workload:
without masking: over 100 times hitting the limit per hour
with masking: less than 10 times for a whole day

As we all know the default config is not able to satisify everyone's
requirements. After applied this patch exporting the softirq mask to
the userside, we can serve different cases by tuning with sysctl.

Signed-off-by: Jason Xing <kernelxing@tencent.com>
---
 kernel/softirq.c | 29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index c8a6913c067d..aa6e52ca2c55 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -65,6 +65,8 @@ const char * const softirq_to_name[NR_SOFTIRQS] = {
 	"TASKLET", "SCHED", "HRTIMER", "RCU"
 };
 
+unsigned int sysctl_softirq_mask = 1 << HI_SOFTIRQ | 1 << TASKLET_SOFTIRQ;
+
 /*
  * we cannot loop indefinitely here to avoid userspace starvation,
  * but we also don't want to introduce a worst case 1/HZ latency
@@ -80,17 +82,23 @@ static void wakeup_softirqd(void)
 		wake_up_process(tsk);
 }
 
+static bool softirq_now_mask(unsigned long pending)
+{
+	if (pending & sysctl_softirq_mask)
+		return false;
+	return true;
+}
+
 /*
  * If ksoftirqd is scheduled, we do not want to process pending softirqs
  * right now. Let ksoftirqd handle this at its own rate, to get fairness,
  * unless we're doing some of the synchronous softirqs.
  */
-#define SOFTIRQ_NOW_MASK ((1 << HI_SOFTIRQ) | (1 << TASKLET_SOFTIRQ))
 static bool ksoftirqd_running(unsigned long pending)
 {
 	struct task_struct *tsk = __this_cpu_read(ksoftirqd);
 
-	if (pending & SOFTIRQ_NOW_MASK)
+	if (softirq_now_mask(pending))
 		return false;
 	return tsk && task_is_running(tsk) && !__kthread_should_park(tsk);
 }
@@ -903,6 +911,22 @@ void tasklet_unlock_wait(struct tasklet_struct *t)
 EXPORT_SYMBOL_GPL(tasklet_unlock_wait);
 #endif
 
+static struct ctl_table softirq_sysctls[] = {
+	{
+		.procname	= "softirq_mask",
+		.data		= &sysctl_softirq_mask,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler   = proc_dointvec,
+	},
+	{}
+};
+
+static void __init softirq_mask_sysctl_init(void)
+{
+	register_sysctl_init("kernel", softirq_sysctls);
+}
+
 void __init softirq_init(void)
 {
 	int cpu;
@@ -916,6 +940,7 @@ void __init softirq_init(void)
 
 	open_softirq(TASKLET_SOFTIRQ, tasklet_action);
 	open_softirq(HI_SOFTIRQ, tasklet_hi_action);
+	softirq_mask_sysctl_init();
 }
 
 static int ksoftirqd_should_run(unsigned int cpu)
-- 
2.37.3

