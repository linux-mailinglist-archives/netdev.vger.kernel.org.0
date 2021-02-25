Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B69D4324BF0
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 09:22:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235729AbhBYIWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 03:22:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:38314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234951AbhBYIWA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Feb 2021 03:22:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1678064F06;
        Thu, 25 Feb 2021 08:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614241279;
        bh=eOpoNPZ+FhKGRUFN3svd9xheRPzs+eGPoax3O+dYrqo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PWlAVBM8Y2XukkbNyQtnI6FhywwKvI4OTO3VmR84OK6Spqt5Keix0qahekMJvxTn8
         uagzd0SGkTUqyItTs8XzPxTZGVp1gvuZ9qEMkwIQEQmrC+UkU/peukzKCWYNzP++Va
         6cK+Xj9Sri1T18ww0VWvDd2eCX+MHw+3pgVx5V2V0zw7OKtOE8NTbQ410lJdNDforb
         VET3w/wBaBMc6eFx88pHGLa+vasa+NtWH43Ks1bwGSyrRPJO4BlR+lu12BxSD/DTmg
         ZqLg3VBlitvZloHWYaK0mOmeBXV2JfZXW7Zt97GnkmNmIf47QhA4sNqSdq45NtACZG
         7rvCZxBuUJMLQ==
Date:   Thu, 25 Feb 2021 00:21:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wei Wang <weiwan@google.com>
Cc:     Alexander Duyck <alexanderduyck@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Martin Zaharinov <micron10@gmail.com>
Subject: Re: [PATCH net] net: fix race between napi kthread mode and busy
 poll
Message-ID: <20210225002115.5f6215d8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAEA6p_CEz-CaK_rCyGzRA8=WNspu2Uia5UasJ266f=p5uiqYkw@mail.gmail.com>
References: <20210223234130.437831-1-weiwan@google.com>
        <20210224114851.436d0065@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89i+jO-ym4kpLD3NaeCKZL_sUiub=2VP574YgC-aVvVyTMw@mail.gmail.com>
        <20210224133032.4227a60c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89i+xGsMpRfPwZK281jyfum_1fhTNFXq7Z8HOww9H1BHmiw@mail.gmail.com>
        <20210224155237.221dd0c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89iKYLTbQB7K8bFouaGFfeiVo00-TEqsdM10t7Tr94O_tuA@mail.gmail.com>
        <20210224160723.4786a256@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BN8PR15MB2787694425A1369CA563FCFFBD9E9@BN8PR15MB2787.namprd15.prod.outlook.com>
        <20210224162059.7949b4e1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BN8PR15MB27873FF52B109480173366B8BD9E9@BN8PR15MB2787.namprd15.prod.outlook.com>
        <20210224180329.306b2207@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAEA6p_CEz-CaK_rCyGzRA8=WNspu2Uia5UasJ266f=p5uiqYkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Feb 2021 18:31:55 -0800 Wei Wang wrote:
> On Wed, Feb 24, 2021 at 6:03 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Thu, 25 Feb 2021 01:22:08 +0000 Alexander Duyck wrote:  
> > > Yeah, that was the patch Wei had done earlier. Eric complained about the extra set_bit atomic operation in the threaded path. That is when I came up with the idea of just adding a bit to the busy poll logic so that the only extra cost in the threaded path was having to check 2 bits instead of 1.  
> >
> > Maybe we can set the bit only if the thread is running? When thread
> > comes out of schedule() it can be sure that it has an NAPI to service.
> > But when it enters napi_thread_wait() and before it hits schedule()
> > it must be careful to make sure the NAPI is still (or already in the
> > very first run after creation) owned by it.  
> 
> Are you suggesting setting the SCHED_THREAD bit in napi_thread_wait()
> somewhere instead of in ____napi_schedule() as you previously plotted?
> What does it help? I think if we have to do an extra set_bit(), it
> seems cleaner to set it in ____napi_schedule(). This would solve the
> warning issue as well.

I was thinking of something roughly like this:

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index ddf4cfc12615..3bce94e8c110 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -360,6 +360,7 @@ enum {
        NAPI_STATE_IN_BUSY_POLL,        /* sk_busy_loop() owns this NAPI */
        NAPI_STATE_PREFER_BUSY_POLL,    /* prefer busy-polling over softirq processing*/
        NAPI_STATE_THREADED,            /* The poll is performed inside its own thread*/
+       NAPI_STATE_SCHED_THREAD,        /* Thread owns the NAPI and will poll */
 };
 
 enum {
@@ -372,6 +373,7 @@ enum {
        NAPIF_STATE_IN_BUSY_POLL        = BIT(NAPI_STATE_IN_BUSY_POLL),
        NAPIF_STATE_PREFER_BUSY_POLL    = BIT(NAPI_STATE_PREFER_BUSY_POLL),
        NAPIF_STATE_THREADED            = BIT(NAPI_STATE_THREADED),
+       NAPIF_STATE_SCHED_THREAD        = BIT(NAPI_STATE_SCHED_THREAD),
 };
 
 enum gro_result {
diff --git a/net/core/dev.c b/net/core/dev.c
index 6c5967e80132..852b992d0ebb 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4294,6 +4294,8 @@ static inline void ____napi_schedule(struct softnet_data *sd,
                 */
                thread = READ_ONCE(napi->thread);
                if (thread) {
+                       if (thread->state == TASK_RUNNING)
+                               set_bit(NAPIF_STATE_SCHED_THREAD, &napi->state);
                        wake_up_process(thread);
                        return;
                }
@@ -6486,7 +6488,8 @@ bool napi_complete_done(struct napi_struct *n, int work_done)
                WARN_ON_ONCE(!(val & NAPIF_STATE_SCHED));
 
                new = val & ~(NAPIF_STATE_MISSED | NAPIF_STATE_SCHED |
-                             NAPIF_STATE_PREFER_BUSY_POLL);
+                             NAPIF_STATE_PREFER_BUSY_POLL |
+                             NAPIF_STATE_SCHED_THREAD);
 
                /* If STATE_MISSED was set, leave STATE_SCHED set,
                 * because we will call napi->poll() one more time.
@@ -6968,16 +6971,24 @@ static int napi_poll(struct napi_struct *n, struct list_head *repoll)
 
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


Extra set_bit() is only done if napi_schedule() comes early enough to
see the thread still running. When the thread is woken we continue to
assume ownership.

It's just an idea (but it may solve the first run and the disable case).
