Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46DC1562299
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 21:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236756AbiF3TFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 15:05:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236741AbiF3TFE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 15:05:04 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D4837A06;
        Thu, 30 Jun 2022 12:05:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656615902; x=1688151902;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=YN+jJ2EY32rC9QVIOpQMx3zPRDCVJOurEzUQC3z8dmk=;
  b=cuInw13UrpMt518dgAlQel0blAMa3kIW0S78eRRr50MwDAtjZj2TcVLF
   2srBYnTy3imW4mmUbpTC/kfU4zfrvBGG1+wal+doEoRJoVQ2jypKbhrW0
   1J/l3tV5PxN8J2gruNQTC7EsEu56j2lpQ5SnIpA3G06T4aKnVjGepMfLD
   KYQNzsGJMDtm3tuxX0acf74RiShUF1HylN4SO2TLzQG+ml1FKlOqDpDLY
   uVOyZSyOBNI8fdTDaa8/rXPb7CkqJBHvwMX5TBoqu/9mMNiExATOoll1f
   Hdj5TmfGiG5DhtcjZoK56Kk7yFXIRxo9fOUTfS9vxgkt/3FUyT9KAKzyN
   Q==;
X-IronPort-AV: E=Sophos;i="5.92,235,1650956400"; 
   d="scan'208";a="162828706"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Jun 2022 12:04:53 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 30 Jun 2022 12:04:52 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Thu, 30 Jun 2022 12:04:52 -0700
Date:   Thu, 30 Jun 2022 21:08:46 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
Subject: Re: [PATCH net-next v2 0/7] net: lan966x: Add lag support
Message-ID: <20220630190846.aqagifacrleejrjc@soft-dev3-1.localhost>
References: <20220627201330.45219-1-horatiu.vultur@microchip.com>
 <20220629122630.qd7nsqmkxoshovhc@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20220629122630.qd7nsqmkxoshovhc@skbuf>
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 06/29/2022 12:26, Vladimir Oltean wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> Hi Horatiu,

Hi Vladimir,

Thanks for review this and for detail explanation.

> 
> On Mon, Jun 27, 2022 at 10:13:23PM +0200, Horatiu Vultur wrote:
> > Add lag support for lan966x.
> > First 4 patches don't do any changes to the current behaviour, they
> > just prepare for lag support. While the rest is to add the lag support.
> >
> > v1->v2:
> > - fix the LAG PGIDs when ports go down, in this way is not
> >   needed anymore the last patch of the series.
> >
> > Horatiu Vultur (7):
> >   net: lan966x: Add reqisters used to configure lag interfaces
> >   net: lan966x: Split lan966x_fdb_event_work
> >   net: lan966x: Expose lan966x_switchdev_nb and
> >     lan966x_switchdev_blocking_nb
> >   net: lan966x: Extend lan966x_foreign_bridging_check
> >   net: lan966x: Add lag support for lan966x.
> >   net: lan966x: Extend FDB to support also lag
> >   net: lan966x: Extend MAC to support also lag interfaces.
> >
> >  .../net/ethernet/microchip/lan966x/Makefile   |   2 +-
> >  .../ethernet/microchip/lan966x/lan966x_fdb.c  | 153 ++++++---
> >  .../ethernet/microchip/lan966x/lan966x_lag.c  | 322 ++++++++++++++++++
> >  .../ethernet/microchip/lan966x/lan966x_mac.c  |  66 +++-
> >  .../ethernet/microchip/lan966x/lan966x_main.h |  41 +++
> >  .../ethernet/microchip/lan966x/lan966x_regs.h |  45 +++
> >  .../microchip/lan966x/lan966x_switchdev.c     | 115 +++++--
> >  7 files changed, 654 insertions(+), 90 deletions(-)
> >  create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_lag.c
> >
> > --
> > 2.33.0
> >
> 
> I've downloaded and applied your patches and I have some general feedback.
> Some of it relates to changes which were not made and hence I couldn't
> have commented on the patches themselves, so I'm posting it here.
> 
> 1. switchdev_bridge_port_offload() returns an error code if object
> replay failed, or if it couldn't get the port parent id, or if the user
> tries to join a lan966x port and a port belonging to another switchdev
> driver to the same LAG. It would be good to propagate this error and not
> ignore it.

Yes, I will do that.

What about the case when the other port is not a switchdev port. For
example:
ip link set dev eth0 master bond0
ip link set dev dummy master bond0
ip link set dev bond0 master br0

At the last line, I was expecting to get an error.

> 
> Side note: maybe this could help to eliminate the extra logic you need
> to add to lan966x_foreign_bridging_check().
> 
> 2. lan966x_foreign_dev_check() seems wrong/misunderstood. Currently it
> reports that a LAG upper is a foreign interface (unoffloaded). In turn,
> this makes switchdev_lower_dev_find() not find any lan966x interface
> beneath a LAG, and hence, __switchdev_handle_fdb_event_to_device() would
> not recurse to the lan966x "dev" below a LAG when the "orig_dev" of an
> FDB event is the bridge itself. Otherwise said, if you have no direct
> lan966x port under a bridge, but just bridge -> LAG -> lan966x, you will
> miss all local (host-filtered) FDB event notifications that you should
> otherwise learn towards the CPU.

Good observation. I have missed that case.

> 
> 3. The implementation of lan966x_lag_mac_add_entry(), with that first
> call to lan966x_mac_del_entry(), seems a hack. Why do you need to do
> that?

Ah... that is not needed anymore. I forgot to remove it.

> 
> 4. The handling of lan966x->mac_lock seems wrong in general, not just
> particular to this patch set. In particular, it appears to protect too
> little in lan966x_mac_add_entry(), i.e. just the list_add_tail.
> This makes it possible for lan966x_mac_lookup and lan966x_mac_learn to
> be concurrent with lan966x_mac_del_entry(). In turn, this appears bad
> first and foremost for the hardware access interface, since the MAC
> table access is indirect, and if you allow multiple threads to
> concurrently call lan966x_mac_select(), change the command in
> ANA_MACACCESS, and poll for command completion, things will go sideways
> very quickly (one command will inadvertently poll for the completion of
> another, which inadvertently operates on the row/column selected by yet
> a third command, all that due to improper serialization).

Now that you mention it, I can see it. The following functions need to
be updated: lan966x_mac_learn, lan966x_mac_ip_learn, lan966x_mac_forget,
lan966x_mac_add_entry, lan966x_mac_del_entry.
But I think this needs to be in a separate patch for net.

> 
> 5. There is a race between lan966x_fdb_lag_event_work() calling
> lan966x_lag_first_port(), and lan966x_lag_port_leave() changing
> port->bond = NULL. Specifically, when a lan966x port leaves a LAG, there
> might still be deferred FDB events (add or del) which are still pending.
> There exists a dead time during which you will ignore these, because you
> think that the first lan966x LAG port isn't the first lan966x LAG port,
> which will lead to a desynchronization between the bridge FDB and the
> hardware FDB.
> 
> In DSA we solved this by flushing lan966x->fdb_work inside
> lan966x_port_prechangeupper() on leave. This waits for the pending
> events to finish, and the bridge will not emit further events.
> It's important to do this in prechangeupper() rather than in
> changeupper() because switchdev_handle_fdb_event_to_device() needs the
> upper/lower relationship to still exist to function properly, and in
> changeupper() it has already been destroyed.
> 
> Side note: if you flush lan966x->fdb_work, then you have an upper bound
> for how long can lan966x_fdb_event_work be deferred. Specifically, you
> can remove the dev_hold() and dev_put() calls, since it surely can't be
> deferred until after the netdev is unregistered. The bounding event is
> much quicker - the lan966x port leaves the LAG.

Thanks for the observation, it would have been taken a long time to see
this.

> 
> 6. You are missing LAG FDB migration logic in lan966x_lag_port_join().
> Specifically, you assume that the lan966x_lag_first_port() will never
> change, probably because you just make the switch ports join the LAG in
> the order 1, 2, 3. But they can also join in the order 3, 2, 1.

It would work, but there will be problems when the ports start to leave
the LAG.
It would work because all the ports under the LAG will have the same
value in PGID_ID for DST_IDX. So if the MAC entry points to any of
this entries will be OK. The problem is when the port leaves the LAG, if
the MAC entry points to the port that left the LAG then is not working
anymore.
I will fix this in the next series.


-- 
/Horatiu
