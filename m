Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 129AB3247D4
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 01:21:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236294AbhBYAVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 19:21:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:40498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234294AbhBYAVo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 19:21:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D96364DE9;
        Thu, 25 Feb 2021 00:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614212463;
        bh=yen5wFoLDKRc7yp0gDby53pxZeLmGYHk5t9h+h1e82Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TdPYJlr58DLW8iy8T+vtLVye59m4rF1loK3xNWZ/nO0zubgqPxGe5jYuxT/xjyhym
         yOloLWC4oRN2CpagmB0ESwLYCJQMBIvtjkORLam8JSuX9K4EvJTqr+nOud46m2BXRd
         qIp+knqNHNMrbdNpzG5/kJTRiaVokyHFiEpUu/VKCsZlL7CXdwwj/mg8aANPNRTVB/
         mwwrK2ppujko+6o1wXSjXcgrSbL77fpwiBoYn4oqENuOcWjYXyY8yCNg9zSzrHDDvu
         qAWWErxbEPw9VGSP0TPBcJBNejJNmRgXQxn1FFYf9H2dnlAHdt4It37KgSkemVI9uz
         wrdewj8clYjBw==
Date:   Wed, 24 Feb 2021 16:20:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Duyck <alexanderduyck@fb.com>
Cc:     Eric Dumazet <edumazet@google.com>, Wei Wang <weiwan@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        "Hannes Frederic Sowa" <hannes@stressinduktion.org>,
        Martin Zaharinov <micron10@gmail.com>
Subject: Re: [PATCH net] net: fix race between napi kthread mode and busy
 poll
Message-ID: <20210224162059.7949b4e1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <BN8PR15MB2787694425A1369CA563FCFFBD9E9@BN8PR15MB2787.namprd15.prod.outlook.com>
References: <20210223234130.437831-1-weiwan@google.com>
        <20210224114851.436d0065@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89i+jO-ym4kpLD3NaeCKZL_sUiub=2VP574YgC-aVvVyTMw@mail.gmail.com>
        <20210224133032.4227a60c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89i+xGsMpRfPwZK281jyfum_1fhTNFXq7Z8HOww9H1BHmiw@mail.gmail.com>
        <20210224155237.221dd0c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89iKYLTbQB7K8bFouaGFfeiVo00-TEqsdM10t7Tr94O_tuA@mail.gmail.com>
        <20210224160723.4786a256@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BN8PR15MB2787694425A1369CA563FCFFBD9E9@BN8PR15MB2787.namprd15.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Feb 2021 00:11:34 +0000 Alexander Duyck wrote:
> > > We were trying to not pollute the list (with about 40 different emails
> > > so far)
> > >
> > > (Note this was not something I initiated, I only hit Reply all button)
> > >
> > > OK, I will shut up, since you seem to take over this matter, and it is
> > > 1am here in France.  
> > 
> > Are you okay with adding a SCHED_THREADED bit for threaded NAPI to be
> > set in addition to SCHED? At least that way the bit is associated with it's user.
> > IIUC since the extra clear_bit() in busy poll was okay so should be a new
> > set_bit()?  
> 
> The problem with adding a bit for SCHED_THREADED is that you would
> have to heavily modify napi_schedule_prep so that it would add the
> bit. That is the reason for going with adding the bit to the busy
> poll logic because it added no additional overhead. Adding another
> atomic bit setting operation or heavily modifying the existing one
> would add considerable overhead as it is either adding a complicated
> conditional check to all NAPI calls, or adding an atomic operation to
> the path for the threaded NAPI.

I wasn't thinking of modifying the main schedule logic, just the
threaded parts:


diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index ddf4cfc12615..6953005d06af 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -360,6 +360,7 @@ enum {
        NAPI_STATE_IN_BUSY_POLL,        /* sk_busy_loop() owns this NAPI */
        NAPI_STATE_PREFER_BUSY_POLL,    /* prefer busy-polling over softirq processing*/
        NAPI_STATE_THREADED,            /* The poll is performed inside its own thread*/
+       NAPI_STATE_SCHED_THREAD,        /* Thread owns the NAPI and will poll */
 };
 
 enum {
diff --git a/net/core/dev.c b/net/core/dev.c
index 6c5967e80132..23e53f971478 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4294,6 +4294,7 @@ static inline void ____napi_schedule(struct softnet_data *sd,
                 */
                thread = READ_ONCE(napi->thread);
                if (thread) {
+                       set_bit(NAPI_STATE_SCHED_THREAD, &napi->state);
                        wake_up_process(thread);
                        return;
                }
@@ -6486,7 +6487,8 @@ bool napi_complete_done(struct napi_struct *n, int work_done)
                WARN_ON_ONCE(!(val & NAPIF_STATE_SCHED));
 
                new = val & ~(NAPIF_STATE_MISSED | NAPIF_STATE_SCHED |
-                             NAPIF_STATE_PREFER_BUSY_POLL);
+                             NAPIF_STATE_PREFER_BUSY_POLL |
+                             NAPI_STATE_SCHED_THREAD);
 
                /* If STATE_MISSED was set, leave STATE_SCHED set,
                 * because we will call napi->poll() one more time.
@@ -6971,7 +6973,9 @@ static int napi_thread_wait(struct napi_struct *napi)
        set_current_state(TASK_INTERRUPTIBLE);
 
        while (!kthread_should_stop() && !napi_disable_pending(napi)) {
-               if (test_bit(NAPI_STATE_SCHED, &napi->state)) {
+               if (test_bit(NAPI_STATE_SCHED_THREAD, &napi->state)) {
+                       WARN_ON(!test_bit(test_bit(NAPI_STATE_SCHED,
+                                                  &napi->state)));
                        WARN_ON(!list_empty(&napi->poll_list));
                        __set_current_state(TASK_RUNNING);
                        return 0;
