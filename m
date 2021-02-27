Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 586E7326AED
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 02:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbhB0BDK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 20:03:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbhB0BDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 20:03:09 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAE46C061574
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 17:02:28 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id p186so10731591ybg.2
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 17:02:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FOMI5GRqMF5dpZEEeV1HvfzAkfAJP8rsNygZ85BawSw=;
        b=b1rS094CvuuK0oolrsz0Dx+wfzsn+OpQklT4shRbv9Vv/54hoxlN7ruSaSNwfBUDBG
         BHg0vcOLowPpHhns8gvEt58ztJ4ciZ81OeDI3Jms6xc/8pfOiv2D5pk5LKFr06khTIuW
         K55P8hnm6O8JAsnJ/jEh89ME4XTN9qObeCphKsANO4JZ1TdrID1w0JtYIdRo7qR2mVvr
         rgx7jb/Fd8mEBZgprSYUyBVDnD3m48IVEIqq/mfcrwE8fJWo4CL2+YhkcX+86ocw3jiW
         4dpqrTMeJvRjxYfxU0LUxyeu2V7YRbRiX8RDoVdlTahiNF1IjmlCymoeZorSgQNWtWhQ
         foJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FOMI5GRqMF5dpZEEeV1HvfzAkfAJP8rsNygZ85BawSw=;
        b=R7cvihjLbSZ7s7MMAlGFp3u+Jqb4HWmYhLy3fVp1YsfZuOvkLpJbc1O5FnbDDEc2ab
         4ngw9U3VAXws4ZefEbRtNFeqz5Necdu2ZOFUqmdhRIpGg1tdRK7RBOPG2L1+V44lZy7t
         wz1GpSza4fQ1XtY6gI6O0/RiD2ZdJswyQSEc7K+E8VrdPlSbLMYcvp27ZVKtNRovZRSO
         sJmHHw+keJpU1bjQ3Da1VOeRVFJR35xtucvw611fbTewkpXlwM1NTpV02A+EGGMzuNkY
         fivEKL8yMFstYrdZf4TYjw48qAbGE2QeAPmSE3heW4NyanKUCM6wi+LirFWb5toyRFk5
         Z47g==
X-Gm-Message-State: AOAM5302qeubqZOA8GbNiHKTbvw0hfY8rfprmDV0MzK4ltBC1VtKWMeN
        uHL5OB0ZBxItWh223wkFt/kiFje16XPuIE8Y03vLrgm4pVLV1g==
X-Google-Smtp-Source: ABdhPJxdwvNphpYKHRtCTwg/61MyvTyVTpwhfJxD6jD4TcpaE2fDr8f1dppMIQEJm8srAs4f4cdfvRnL3KotKMzbL4Y=
X-Received: by 2002:a25:d016:: with SMTP id h22mr8358946ybg.278.1614387747874;
 Fri, 26 Feb 2021 17:02:27 -0800 (PST)
MIME-Version: 1.0
References: <20210227003047.1051347-1-weiwan@google.com> <20210226164803.4413571f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210226164803.4413571f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Wei Wang <weiwan@google.com>
Date:   Fri, 26 Feb 2021 17:02:17 -0800
Message-ID: <CAEA6p_CJx7K1Fab1C0Qkw=1VNnDaV9qwB_UUtikPMoqNUUWJuA@mail.gmail.com>
Subject: Re: [PATCH net v2] net: fix race between napi kthread mode and busy poll
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Martin Zaharinov <micron10@gmail.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 26, 2021 at 4:48 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 26 Feb 2021 16:30:47 -0800 Wei Wang wrote:
> >               thread = READ_ONCE(napi->thread);
> >               if (thread) {
> > +                     set_bit(NAPI_STATE_SCHED_THREADED, &napi->state);
> >                       wake_up_process(thread);
>
> What about the version which checks RUNNING? As long as
> wake_up_process() implies a barrier I _think_ it should
> work as well. Am I missing some case, or did you decide
> to go with the simpler/safer approach?


I assume you are referring to the following proposed patch in your
previous email right?
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4294,6 +4294,8 @@ static inline void ____napi_schedule(struct
softnet_data *sd,
                 */
                thread = READ_ONCE(napi->thread);
                if (thread) {
+                       if (thread->state == TASK_RUNNING)
+                               set_bit(NAPIF_STATE_SCHED_THREAD, &napi->state);
                        wake_up_process(thread);
                        return;
                }
@@ -6486,7 +6488,8 @@ bool napi_complete_done(struct napi_struct *n,
int work_done)
                WARN_ON_ONCE(!(val & NAPIF_STATE_SCHED));

                new = val & ~(NAPIF_STATE_MISSED | NAPIF_STATE_SCHED |
-                             NAPIF_STATE_PREFER_BUSY_POLL);
+                             NAPIF_STATE_PREFER_BUSY_POLL |
+                             NAPIF_STATE_SCHED_THREAD);

                /* If STATE_MISSED was set, leave STATE_SCHED set,
                 * because we will call napi->poll() one more time.
@@ -6968,16 +6971,24 @@ static int napi_poll(struct napi_struct *n,
struct list_head *repoll)

 static int napi_thread_wait(struct napi_struct *napi)
 {
+       bool woken = false;
+
        set_current_state(TASK_INTERRUPTIBLE);

        while (!kthread_should_stop() && !napi_disable_pending(napi)) {
-               if (test_bit(NAPI_STATE_SCHED, &napi->state)) {
+               unsigned long state = READ_ONCE(napi->state);
+
+               if ((state & NAPIF_STATE_SCHED) &&
+                   ((state & NAPIF_STATE_SCHED_THREAD) || woken)) {
                        WARN_ON(!list_empty(&napi->poll_list));
                        __set_current_state(TASK_RUNNING);
                        return 0;
+               } else {
+                       WARN_ON(woken);
                }

                schedule();
+               woken = true;
                set_current_state(TASK_INTERRUPTIBLE);
        }
        __set_current_state(TASK_RUNNING);

I don't think it is sufficient to only set SCHED_THREADED bit when the
thread is in RUNNING state.
In fact, the thread is most likely NOT in RUNNING mode before we call
wake_up_process() in ____napi_schedule(), because it has finished the
previous round of napi->poll() and SCHED bit was cleared, so
napi_thread_wait() sets the state to INTERRUPTIBLE and schedule() call
should already put it in sleep.
