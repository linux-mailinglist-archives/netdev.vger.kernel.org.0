Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 106652C8E1C
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 20:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728675AbgK3TdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 14:33:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728078AbgK3TdO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 14:33:14 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE066C0613CF
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 11:32:33 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id a16so24070813ejj.5
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 11:32:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wZ0EwEubkDVFPttrfhfB2/0uTawjkjxVVL3pSZbPE+Q=;
        b=tAm2/8tAIem2mEzAssoy4vem/MSVNXrEZRXcXrfbfloVZMO2EWYahIwk3kndv934Ce
         r0qvx27QTBAWBx6lz42MkL3a00PJaIQJM4qZ4qu/YVrVANgdv4zYYTq/0sACgLTt7bSr
         tOzXuiMsHzL9rZY8uk4EP83b1DWNdDtt3DFZ/RC2R6tamwd1IQJJmJRZVNmkvc0CsZWk
         mdUmO486vb9LhJ8snX91FBwx3A4+2cU3qg1lOVIUkUOIHbVxcgo3oOIhI6WW77lnUGf2
         XNqRRUpjSnAU8WzdfLXrA7cAzvfGgx8fjwciV05e9TSoNksSz0o1nZ+oYIf8Yz/MXCZ9
         fMVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wZ0EwEubkDVFPttrfhfB2/0uTawjkjxVVL3pSZbPE+Q=;
        b=EfAHew01eeZrc/UiIXJpppQdN+SR0NGnpGZO1Wc1AtsubmfTv8wh9kDKfAmtiHhqvL
         +0l8ZJ96nj8JTk/hwfsGwqHosWxi09B1/NTNdjagUAAJGNF9iQle66k14x4F75lqSOMV
         /TPWbzzT1ojMzaZsor6UxnFeISF6Eod/5g+jEElEIBM0c0X9xRKBDoGU90USAUW30/Gl
         ePL0v0Z9T19qM4PgZTwD/Bxs9CQtTX5ojc17P2H6lZza8uFZQQG78m+dqrtB/h/xDD45
         jUm77l8JaC9Nq1L9Fp8IzYgG7S35sbjPgw9iZDA3JNOTxPpJWmFOMnCOfCWQWv3KJbvN
         qghA==
X-Gm-Message-State: AOAM5326uTAJxzRb7teJkBT7x59FBtx+pgnkyCjpjSj3m5WtJRZ3Q4ot
        y07LffdrkmD5eS0BPfLtcTE=
X-Google-Smtp-Source: ABdhPJwy4ik5g3wgALSy+KfrPufXxOclXgbF3vkPu/KlfI8xedfQ8J7xm8xkPUJlK+2ySOI8C2958Q==
X-Received: by 2002:a17:906:4104:: with SMTP id j4mr22885794ejk.439.1606764752503;
        Mon, 30 Nov 2020 11:32:32 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id qc19sm3261277ejb.71.2020.11.30.11.32.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 11:32:31 -0800 (PST)
Date:   Mon, 30 Nov 2020 21:32:30 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev <netdev@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jiri Benc <jbenc@redhat.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: Correct usage of dev_base_lock in 2020
Message-ID: <20201130193230.f5aopdmcc5x3ldey@skbuf>
References: <20201129182435.jgqfjbekqmmtaief@skbuf>
 <20201129205817.hti2l4hm2fbp2iwy@skbuf>
 <20201129211230.4d704931@hermes.local>
 <CANn89iKyyCwiKHFvQMqmeAbaR9SzwsCsko49FP+4NBW6+ZXN4w@mail.gmail.com>
 <20201130101405.73901b17@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <20201130184828.x56bwxxiwydsxt3k@skbuf>
 <b8136636-b729-a045-6266-6e93ba4b83f4@gmail.com>
 <20201130190348.ayg7yn5fieyr4ksy@skbuf>
 <CANn89i+DYN4j2+MGK3Sh0=YAqmCyw0arcpm2bGO3qVFkzU_B4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89i+DYN4j2+MGK3Sh0=YAqmCyw0arcpm2bGO3qVFkzU_B4g@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 30, 2020 at 08:22:01PM +0100, Eric Dumazet wrote:
> On Mon, Nov 30, 2020 at 8:03 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> > On Mon, Nov 30, 2020 at 08:00:40PM +0100, Eric Dumazet wrote:
> > > On 11/30/20 7:48 PM, Vladimir Oltean wrote:
> > > > diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> > > > index e0880a3840d7..1d44534e95d2 100644
> > > > --- a/drivers/net/bonding/bond_main.c
> > > > +++ b/drivers/net/bonding/bond_main.c
> > > > @@ -3738,21 +3738,17 @@ static void bond_get_stats(struct net_device *bond_dev,
> > > >                        struct rtnl_link_stats64 *stats)
> > > >  {
> > > >     struct bonding *bond = netdev_priv(bond_dev);
> > > > +   bool rtnl_locked = rtnl_is_locked();
> > > >     struct rtnl_link_stats64 temp;
> > > >     struct list_head *iter;
> > > >     struct slave *slave;
> > > > -   int nest_level = 0;
> > > >
> > > > +   if (!rtnl_locked)
> > > > +           rtnl_lock();
> > >
> > > Gosh, do not do that.
> > >
> > > Convert the bonding ->stats_lock to a mutex instead.
> > >
> > > Adding more reliance to RTNL is not helping cases where
> > > access to stats should not be blocked by other users of RTNL (which can be abused)
> >
> > I can't, Eric. The bond_for_each_slave() macro needs protection against
> > net devices being registered and unregistered.
>
> And ?
>
> A bonding device can absolutely maintain a private list, ready for
> bonding ndo_get_stats() use, regardless
> of register/unregister logic.
>
> bond_for_each_slave() is simply a macro, you can replace it by something else.

Yeah, ok, let's assume I can do that for the particular case of bonding.
What about this one though.

-----------------------------[cut here]-----------------------------
From 0d114e38ee20d93b41f8e29082e9e5e0fa7f6b0e Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Mon, 30 Nov 2020 02:27:28 +0200
Subject: [PATCH] s390/appldata_net_sum: retrieve device statistics under RTNL,
 not RCU

In the effort of making .ndo_get_stats64 be able to sleep, we need to
ensure the callers of dev_get_stats do not use atomic context.

In the case of the appldata driver, an RCU read-side critical section is
used to ensure the integrity of the list of network interfaces, because
the driver iterates through all net devices in the netns to aggregate
statistics. We still need some protection against an interface
registering or deregistering, and the writer-side lock, the RTNL mutex,
is fine for that, because it offers sleepable context.

The ops->callback function is called from under appldata_ops_mutex
protection, so this is proof that the context is sleepable and holding
RTNL is therefore fine.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 arch/s390/appldata/appldata_net_sum.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/s390/appldata/appldata_net_sum.c b/arch/s390/appldata/appldata_net_sum.c
index 59c282ca002f..22da28ab10d8 100644
--- a/arch/s390/appldata/appldata_net_sum.c
+++ b/arch/s390/appldata/appldata_net_sum.c
@@ -78,8 +78,9 @@ static void appldata_get_net_sum_data(void *data)
 	tx_dropped = 0;
 	collisions = 0;

-	rcu_read_lock();
-	for_each_netdev_rcu(&init_net, dev) {
+	rtnl_lock();
+
+	for_each_netdev(&init_net, dev) {
 		const struct rtnl_link_stats64 *stats;
 		struct rtnl_link_stats64 temp;

@@ -95,7 +96,8 @@ static void appldata_get_net_sum_data(void *data)
 		collisions += stats->collisions;
 		i++;
 	}
-	rcu_read_unlock();
+
+	rtnl_unlock();

 	net_data->nr_interfaces = i;
 	net_data->rx_packets = rx_packets;
-----------------------------[cut here]-----------------------------

Or this one.

-----------------------------[cut here]-----------------------------
From 93ffc25f30849aaf89e50e58d32b0b047831f94d Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Mon, 30 Nov 2020 02:49:25 +0200
Subject: [PATCH] parisc/led: retrieve device statistics under RTNL, not RCU

In the effort of making .ndo_get_stats64 be able to sleep, we need to
ensure the callers of dev_get_stats do not use atomic context.

The LED driver for HP-PARISC workstations uses a workqueue to
periodically check for updates in network interface statistics, and
flicker when those have changed (i.e. there has been activity on the
line). Honestly that is a strange idea even when protected by RCU, but
now, the dev_get_stats call can sleep, and iterating through the list of
network interfaces still needs to ensure the integrity of list of
network interfaces. So that leaves us only one locking option given the
current design of the network stack, and that is the RTNL mutex. In the
future we might be able to make this a little bit less expensive by
creating a separate mutex for the list of network interfaces.

Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>
Cc: linux-parisc@vger.kernel.org
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/parisc/led.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/parisc/led.c b/drivers/parisc/led.c
index 36c6613f7a36..09dcffaed85f 100644
--- a/drivers/parisc/led.c
+++ b/drivers/parisc/led.c
@@ -38,7 +38,6 @@
 #include <linux/ctype.h>
 #include <linux/blkdev.h>
 #include <linux/workqueue.h>
-#include <linux/rcupdate.h>
 #include <asm/io.h>
 #include <asm/processor.h>
 #include <asm/hardware.h>
@@ -356,12 +355,13 @@ static __inline__ int led_get_net_activity(void)
 
 	rx_total = tx_total = 0;
 	
-	/* we are running as a workqueue task, so we can use an RCU lookup */
-	rcu_read_lock();
-	for_each_netdev_rcu(&init_net, dev) {
+	/* we are running as a workqueue task, so we can take the RTNL mutex */
+	rtnl_lock();
+
+	for_each_netdev(&init_net, dev) {
 	    const struct rtnl_link_stats64 *stats;
 	    struct rtnl_link_stats64 temp;
-	    struct in_device *in_dev = __in_dev_get_rcu(dev);
+	    struct in_device *in_dev = __in_dev_get_rtnl(dev);
 	    if (!in_dev || !in_dev->ifa_list)
 		continue;
 	    if (ipv4_is_loopback(in_dev->ifa_list->ifa_local))
@@ -370,7 +370,8 @@ static __inline__ int led_get_net_activity(void)
 	    rx_total += stats->rx_packets;
 	    tx_total += stats->tx_packets;
 	}
-	rcu_read_unlock();
+
+	rtnl_unlock();
 
 	retval = 0;
 
-----------------------------[cut here]-----------------------------

Where I'm getting at is that we're going to need a new mutex for
write-side protection of the network interface lists, one that is !=
RTNL mutex.
