Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9913533297F
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 16:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231691AbhCIPBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 10:01:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbhCIPAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 10:00:40 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5761DC06174A;
        Tue,  9 Mar 2021 07:00:40 -0800 (PST)
Date:   Tue, 9 Mar 2021 16:00:36 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1615302037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=haCuMwx8FBtsuLInyU0TMFS1G8sa0cBWrU6Q5la2tOA=;
        b=vH0moShtrJeVtgZbD1r78tLDx6XyHNucm18W4J8xUPHPmOCt+SaGkcqKZylD1Qa5mH12bh
        A2+mOteZI/nNJsKT9iKJgpJ+aVtKE4tBYkQh5vJpdwdOFoiUE+UJzLs7NJgbXGRKavYn/N
        u2ss3f1E4gTQiTD7bk9wixljV0fV/2I1hOjh9r1OgCgT/hPzvnbP0fusQY4P7UJl9s1I8B
        4YAGxejRc6417ftT5uJHJt6DLO6/1El7SxvgnKwfB3G7RlqGqqIwbuQTcKLw2R/GXvi5eL
        i9WMaaRTrNt1brpUNBx6gw/ITgR/5P7H6v3aOt/pY6etzq1u4bfg6TnivVfjNA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1615302037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=haCuMwx8FBtsuLInyU0TMFS1G8sa0cBWrU6Q5la2tOA=;
        b=M+xMQLgZ+XsqwI3AcUt4aNUAkVhpNvp/fR0QYs1Y07eFdMeH0URMLccm8FWUT+O3EnE0N2
        Yn88FQVAn7gnR4CQ==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Denis Kirjanov <kda@linux-powerpc.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        ath9k-devel@qca.qualcomm.com, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, Chas Williams <3chas3@gmail.com>,
        linux-atm-general@lists.sourceforge.net,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-hyperv@vger.kernel.org, linux-pci@vger.kernel.org,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net
Subject: Re: [patch 07/14] tasklets: Prevent tasklet_unlock_spin_wait()
 deadlock on RT
Message-ID: <20210309150036.5rcecmmz2wbu4ypc@linutronix.de>
References: <20210309084203.995862150@linutronix.de>
 <20210309084241.988908275@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20210309084241.988908275@linutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-03-09 09:42:10 [+0100], Thomas Gleixner wrote:
> tasklet_unlock_spin_wait() spin waits for the TASKLET_STATE_SCHED bit in
> the tasklet state to be cleared. This works on !RT nicely because the
=E2=80=A6

Could you please fold this:

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 07c7329d21aa7..1c14ccd351091 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -663,15 +663,6 @@ static inline int tasklet_trylock(struct tasklet_struc=
t *t)
 void tasklet_unlock(struct tasklet_struct *t);
 void tasklet_unlock_wait(struct tasklet_struct *t);
=20
-/*
- * Do not use in new code. Waiting for tasklets from atomic contexts is
- * error prone and should be avoided.
- */
-static inline void tasklet_unlock_spin_wait(struct tasklet_struct *t)
-{
-	while (test_bit(TASKLET_STATE_RUN, &t->state))
-		cpu_relax();
-}
 #else
 static inline int tasklet_trylock(struct tasklet_struct *t) { return 1; }
 static inline void tasklet_unlock(struct tasklet_struct *t) { }
diff --git a/kernel/softirq.c b/kernel/softirq.c
index f0074f1344402..c9adc5c462485 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -830,8 +830,8 @@ EXPORT_SYMBOL(tasklet_init);
=20
 #if defined(CONFIG_SMP) || defined(CONFIG_PREEMPT_RT)
 /*
- * Do not use in new code. There is no real reason to invoke this from
- * atomic contexts.
+ * Do not use in new code. Waiting for tasklets from atomic contexts is
+ * error prone and should be avoided.
  */
 void tasklet_unlock_spin_wait(struct tasklet_struct *t)
 {
--=20
2.30.1

