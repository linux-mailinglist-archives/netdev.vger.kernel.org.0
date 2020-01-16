Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DDCD13D811
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 11:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbgAPKic (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 05:38:32 -0500
Received: from mx2.suse.de ([195.135.220.15]:42464 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725800AbgAPKic (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 05:38:32 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 59757AF0D;
        Thu, 16 Jan 2020 10:38:29 +0000 (UTC)
References: <0000000000002b81b70590a83ad7@google.com> <20200114143244.20739-1-rpalethorpe@suse.com> <19d5e4c6-72f4-631f-2ccd-b5df660a5ef6@gmail.com>
User-agent: mu4e 1.2.0; emacs 26.3
From:   Richard Palethorpe <rpalethorpe@suse.de>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Richard Palethorpe <rpalethorpe@suse.com>,
        linux-can@vger.kernel.org,
        syzbot+017e491ae13c0068598a@syzkaller.appspotmail.com,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Tyler Hall <tylerwhall@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller@googlegroups.com
Subject: Re: [PATCH] can, slip: Protect tty->disc_data access with RCU
Reply-To: rpalethorpe@suse.de
In-reply-to: <19d5e4c6-72f4-631f-2ccd-b5df660a5ef6@gmail.com>
Date:   Thu, 16 Jan 2020 11:38:28 +0100
Message-ID: <87v9pbit3v.fsf@our.domain.is.not.set>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Eric Dumazet <eric.dumazet@gmail.com> writes:

> On 1/14/20 6:32 AM, Richard Palethorpe wrote:
>> write_wakeup can happen in parallel with close where tty->disc_data is set
>> to NULL. So we a) need to check if tty->disc_data is NULL and b) ensure it
>> is an atomic operation. Otherwise accessing tty->disc_data could result in
>> a NULL pointer deref or access to some random location.
>>
>> This problem was found by Syzkaller on slcan, but the same issue appears to
>> exist in slip where slcan was copied from.
>>
>> A fix which didn't use RCU was posted by Hillf Danton.
>>
>> Fixes: 661f7fda21b1 ("slip: Fix deadlock in write_wakeup")
>> Fixes: a8e83b17536a ("slcan: Port write_wakeup deadlock fix from slip")
>> Reported-by: syzbot+017e491ae13c0068598a@syzkaller.appspotmail.com
>> Signed-off-by: Richard Palethorpe <rpalethorpe@suse.com>
>> Cc: Wolfgang Grandegger <wg@grandegger.com>
>> Cc: Marc Kleine-Budde <mkl@pengutronix.de>
>> Cc: "David S. Miller" <davem@davemloft.net>
>> Cc: Tyler Hall <tylerwhall@gmail.com>
>> Cc: netdev@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Cc: syzkaller@googlegroups.com
>> ---
>>
>> Note, that mabye RCU should also applied to receive_buf as that also happens
>> in interrupt context. So if the pointer assignment is split by the compiler
>> then sl may point somewhere unexpected?
>>
>>  drivers/net/can/slcan.c | 11 +++++++++--
>>  drivers/net/slip/slip.c | 11 +++++++++--
>>  2 files changed, 18 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
>> index 2e57122f02fb..ee029aae69d4 100644
>> --- a/drivers/net/can/slcan.c
>> +++ b/drivers/net/can/slcan.c
>> @@ -344,7 +344,14 @@ static void slcan_transmit(struct work_struct *work)
>>   */
>>  static void slcan_write_wakeup(struct tty_struct *tty)
>>  {
>> -	struct slcan *sl = tty->disc_data;
>> +	struct slcan *sl;
>> +
>> +	rcu_read_lock();
>> +	sl = rcu_dereference(tty->disc_data);
>> +	rcu_read_unlock();
>
> This rcu_read_lock()/rcu_read_unlock() pair is not protecting anything.
>
> Right after rcu_read_unlock(), sl validity can not be guaranteed.
>
>> +
>> +	if (!sl)
>> +		return;
>>
>>  	schedule_work(&sl->tx_work);
>>  }
>> @@ -644,7 +651,7 @@ static void slcan_close(struct tty_struct *tty)
>>  		return;
>>
>>  	spin_lock_bh(&sl->lock);
>> -	tty->disc_data = NULL;
>> +	rcu_assign_pointer(tty->disc_data, NULL);
>>  	sl->tty = NULL;
>>  	spin_unlock_bh(&sl->lock);
>
>
>
> Where is the rcu grace period before freeing enforced ?
>

Sorry that was dumb.

I have respun the patch so it now schedules the work inside the RCU read
lock and it synchronises before freeing the netdev.

However sparse complains about the address space of the pointer. I guess
if disc_data is to be protected by RCU then it should be marked as
such...

I suppose that at least the access in slip/slcan_receive_buf should also
be protected by RCU? It seems like disc_data could be freed from
underneath it by close.

At any rate below is the updated patch FYI.

-- >8 --

Subject: [PATCH v2] can, slip: Protect tty->disc_data access with RCU

write_wakeup can happen in parallel with close where tty->disc_data is set
to NULL. So we a) need to check if tty->disc_data is NULL and b) ensure it
is an atomic operation. Otherwise accessing tty->disc_data could result in a
NULL pointer deref or access to some random location.

This problem was found by Syzkaller on slcan, but the same issue appears to
exist in slip where slcan was copied from.

A fix which didn't use RCU was posted by Hillf Danton.

Fixes: 661f7fda21b1 ("slip: Fix deadlock in write_wakeup")
Fixes: a8e83b17536a ("slcan: Port write_wakeup deadlock fix from slip")
Reported-by: syzbot+017e491ae13c0068598a@syzkaller.appspotmail.com
Signed-off-by: Richard Palethorpe <rpalethorpe@suse.com>
Cc: Wolfgang Grandegger <wg@grandegger.com>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Tyler Hall <tylerwhall@gmail.com>
Cc: linux-can@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: syzkaller@googlegroups.com
---
 drivers/net/can/slcan.c | 12 ++++++++++--
 drivers/net/slip/slip.c | 12 ++++++++++--
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
index 2e57122f02fb..2f5c287eac95 100644
--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -344,9 +344,16 @@ static void slcan_transmit(struct work_struct *work)
  */
 static void slcan_write_wakeup(struct tty_struct *tty)
 {
-	struct slcan *sl = tty->disc_data;
+	struct slcan *sl;
+
+	rcu_read_lock();
+	sl = rcu_dereference(tty->disc_data);
+	if (!sl)
+		goto out;

 	schedule_work(&sl->tx_work);
+out:
+	rcu_read_unlock();
 }

 /* Send a can_frame to a TTY queue. */
@@ -644,10 +651,11 @@ static void slcan_close(struct tty_struct *tty)
 		return;

 	spin_lock_bh(&sl->lock);
-	tty->disc_data = NULL;
+	rcu_assign_pointer(tty->disc_data, NULL);
 	sl->tty = NULL;
 	spin_unlock_bh(&sl->lock);

+	synchronize_rcu();
 	flush_work(&sl->tx_work);

 	/* Flush network side */
diff --git a/drivers/net/slip/slip.c b/drivers/net/slip/slip.c
index 2a91c192659f..61d7e0d1d77d 100644
--- a/drivers/net/slip/slip.c
+++ b/drivers/net/slip/slip.c
@@ -452,9 +452,16 @@ static void slip_transmit(struct work_struct *work)
  */
 static void slip_write_wakeup(struct tty_struct *tty)
 {
-	struct slip *sl = tty->disc_data;
+	struct slip *sl;
+
+	rcu_read_lock();
+	sl = rcu_dereference(tty->disc_data);
+	if (!sl)
+		goto out;

 	schedule_work(&sl->tx_work);
+out:
+	rcu_read_unlock();
 }

 static void sl_tx_timeout(struct net_device *dev)
@@ -882,10 +889,11 @@ static void slip_close(struct tty_struct *tty)
 		return;

 	spin_lock_bh(&sl->lock);
-	tty->disc_data = NULL;
+	rcu_assign_pointer(tty->disc_data, NULL);
 	sl->tty = NULL;
 	spin_unlock_bh(&sl->lock);

+	synchronize_rcu();
 	flush_work(&sl->tx_work);

 	/* VSV = very important to remove timers */
--
2.24.0
