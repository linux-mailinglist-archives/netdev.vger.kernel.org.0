Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD1E3150EA5
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 18:33:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728547AbgBCRda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 12:33:30 -0500
Received: from mx2.suse.de ([195.135.220.15]:39976 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727620AbgBCRda (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Feb 2020 12:33:30 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id F3108ADD7;
        Mon,  3 Feb 2020 17:33:27 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 03 Feb 2020 18:33:27 +0100
From:   Roman Penyaev <rpenyaev@suse.de>
To:     Max Neunhoeffer <max@arangodb.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Christopher Kohlhoff <chris.kohlhoff@clearpool.io>
Subject: Re: epoll_wait misses edge-triggered eventfd events: bug in Linux 5.3
 and 5.4
In-Reply-To: <20200203151536.caf6n4b2ymvtssmh@tux>
References: <20200131135730.ezwtgxddjpuczpwy@tux>
 <20200201121647.62914697@cakuba.hsd1.ca.comcast.net>
 <20200203151536.caf6n4b2ymvtssmh@tux>
Message-ID: <5a16db1f2983ab105b99121ce0737d11@suse.de>
X-Sender: rpenyaev@suse.de
User-Agent: Roundcube Webmail
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Max and all,

I can reproduce the issue.  My epoll optimization which you referenced
did not consider the case of wakeups on epoll_ctl() path, only the fd
update path.

I will send the fix upstream today/tomorrow (already tested on the
epollbug.c), the exemplary patch at the bottom of the current
email.

Also I would like to  submit the epollbug.c as a test case for
the epoll test suite. Does the author of epollbug have any
objections?

Thanks.

--
Roman

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index c4159bcc05d9..a90f8b8a5def 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -745,7 +745,7 @@ static __poll_t ep_scan_ready_list(struct eventpoll 
*ep,
                  * the ->poll() wait list (delayed after we release the 
lock).
                  */
                 if (waitqueue_active(&ep->wq))
-                       wake_up(&ep->wq);
+                       wake_up_locked(&ep->wq);
                 if (waitqueue_active(&ep->poll_wait))
                         pwake++;
         }
@@ -1200,7 +1200,7 @@ static inline bool chain_epi_lockless(struct 
epitem *epi)
   * Another thing worth to mention is that ep_poll_callback() can be 
called
   * concurrently for the same @epi from different CPUs if poll table was 
inited
   * with several wait queues entries.  Plural wakeup from different CPUs 
of a
- * single wait queue is serialized by wq.lock, but the case when 
multiple wait
+ * single wait queue is serialized by ep->lock, but the case when 
multiple wait
   * queues are used should be detected accordingly.  This is detected 
using
   * cmpxchg() operation.
   */
@@ -1275,6 +1275,13 @@ static int ep_poll_callback(wait_queue_entry_t 
*wait, unsigned mode, int sync, v
                                 break;
                         }
                 }
+               /*
+                * Since here we have the read lock (ep->lock) taken, 
plural
+                * wakeup from different CPUs can occur, thus we call 
wake_up()
+                * variant which implies its own lock on wqueue. All 
other paths
+                * take write lock, thus modifications on ep->wq are 
serialized
+                * by rw lock.
+                */
                 wake_up(&ep->wq);
         }
         if (waitqueue_active(&ep->poll_wait))
@@ -1578,7 +1585,7 @@ static int ep_insert(struct eventpoll *ep, const 
struct epoll_event *event,

                 /* Notify waiting tasks that events are available */
                 if (waitqueue_active(&ep->wq))
-                       wake_up(&ep->wq);
+                       wake_up_locked(&ep->wq);
                 if (waitqueue_active(&ep->poll_wait))
                         pwake++;
         }
@@ -1684,7 +1691,7 @@ static int ep_modify(struct eventpoll *ep, struct 
epitem *epi,

                         /* Notify waiting tasks that events are 
available */
                         if (waitqueue_active(&ep->wq))
-                               wake_up(&ep->wq);
+                               wake_up_locked(&ep->wq);
                         if (waitqueue_active(&ep->poll_wait))
                                 pwake++;
                 }
@@ -1881,9 +1888,9 @@ static int ep_poll(struct eventpoll *ep, struct 
epoll_event __user *events,
                 waiter = true;
                 init_waitqueue_entry(&wait, current);

-               spin_lock_irq(&ep->wq.lock);
+               write_lock_irq(&ep->lock);
                 __add_wait_queue_exclusive(&ep->wq, &wait);
-               spin_unlock_irq(&ep->wq.lock);
+               write_unlock_irq(&ep->lock);
         }

         for (;;) {
@@ -1931,9 +1938,9 @@ static int ep_poll(struct eventpoll *ep, struct 
epoll_event __user *events,
                 goto fetch_events;

         if (waiter) {
-               spin_lock_irq(&ep->wq.lock);
+               write_lock_irq(&ep->lock);
                 __remove_wait_queue(&ep->wq, &wait);
-               spin_unlock_irq(&ep->wq.lock);
+               write_unlock_irq(&ep->lock);
         }

         return res;




On 2020-02-03 16:15, Max Neunhoeffer wrote:
> Dear Jakub and all,
> 
> I have done a git bisect and found that this commit introduced the 
> epoll
> bug:
> 
> https://github.com/torvalds/linux/commit/a218cc4914209ac14476cb32769b31a556355b22
> 
> I Cc the author of the commit.
> 
> This makes sense, since the commit introduces a new rwlock to reduce
> contention in ep_poll_callback. I do not fully understand the details
> but this sounds all very close to this bug.
> 
> I have also verified that the bug is still present in the latest master
> branch in Linus' repository.
> 
> Furthermore, Chris Kohlhoff has provided yet another reproducing 
> program
> which is no longer using edge-triggered but standard level-triggered
> events and epoll_wait. This makes the bug all the more urgent, since
> potentially more programs could run into this problem and could end up
> with sleeping barbers.
> 
> I have added all the details to the bugzilla bugreport:
> 
>   https://bugzilla.kernel.org/show_bug.cgi?id=205933
> 
> Hopefully, we can resolve this now equipped with this amount of 
> information.
> 
> Best regards,
>   Max.
> 
> On 20/02/01 12:16, Jakub Kicinski wrote:
>> On Fri, 31 Jan 2020 14:57:30 +0100, Max Neunhoeffer wrote:
>> > Dear All,
>> >
>> > I believe I have found a bug in Linux 5.3 and 5.4 in epoll_wait/epoll_ctl
>> > when an eventfd together with edge-triggered or the EPOLLONESHOT policy
>> > is used. If an epoll_ctl call to rearm the eventfd happens approximately
>> > at the same time as the epoll_wait goes to sleep, the event can be lost,
>> > even though proper protection through a mutex is employed.
>> >
>> > The details together with two programs showing the problem can be found
>> > here:
>> >
>> >   https://bugzilla.kernel.org/show_bug.cgi?id=205933
>> >
>> > Older kernels seem not to have this problem, although I did not test all
>> > versions. I know that 4.15 and 5.0 do not show the problem.
>> >
>> > Note that this method of using epoll_wait/eventfd is used by
>> > boost::asio to wake up event loops in case a new completion handler
>> > is posted to an io_service, so this is probably relevant for many
>> > applications.
>> >
>> > Any help with this would be appreciated.
>> 
>> Could be networking related but let's CC FS folks just in case.
>> 
>> Would you be able to perform bisection to narrow down the search
>> for a buggy change?

