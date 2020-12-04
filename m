Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 602692CF5CB
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 21:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728197AbgLDUnv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 15:43:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:50517 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbgLDUnu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 15:43:50 -0500
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1klHv1-0004Hw-Lx; Fri, 04 Dec 2020 20:43:08 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id AFD2A5FEE8; Fri,  4 Dec 2020 12:43:05 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id A68849FAB0;
        Fri,  4 Dec 2020 12:43:05 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     "Finer, Howard" <hfiner@rbbn.com>
cc:     "andy@greyhouse.net" <andy@greyhouse.net>,
        "vfalico@gmail.com" <vfalico@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: bonding driver issue when configured for active/backup and using ARP monitoring
In-reply-to: <MN2PR03MB47526B686EF6E0F8D81A9397B7F50@MN2PR03MB4752.namprd03.prod.outlook.com>
References: <MN2PR03MB47526B686EF6E0F8D81A9397B7F50@MN2PR03MB4752.namprd03.prod.outlook.com>
Comments: In-reply-to "Finer, Howard" <hfiner@rbbn.com>
   message dated "Mon, 30 Nov 2020 18:05:23 +0000."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <14768.1607114585.1@famine>
Date:   Fri, 04 Dec 2020 12:43:05 -0800
Message-ID: <14769.1607114585@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Finer, Howard <hfiner@rbbn.com> wrote:

>We use the bonding driver in an active-backup configuration with ARP
>monitoring. We also use the TIPC protocol which we run over the bond
>device. We are consistently seeing an issue in both the 3.16 and 4.19
>kernels whereby when the bond slave is switched TIPC is being notified of
>the change rather than it happening silently. The problem that we see is
>that when the active slave fails, a NETDEV_CHANGE event is being sent to
>the TIPC driver to notify it that the link is down. This causes the TIPC
>driver to reset its bearers and therefore break communication between the
>nodes that are clustered.
>With some additional instrumentation in thee driver, I see this in
>/var/log/syslog:
><6> 1 2020-11-20T18:14:19.159524+01:00 LABNBS5B kernel - - -
>[65818.378287] bond0: link status definitely down for interface eth0,
>disabling it
><6> 1 2020-11-20T18:14:19.159536+01:00 LABNBS5B kernel - - -
>[65818.378296] bond0: now running without any active interface!
><6> 1 2020-11-20T18:14:19.159537+01:00 LABNBS5B kernel - - -
>[65818.378304] bond0: bond_activebackup_arp_mon: notify_rtnl, slave state
>notify/slave link notify
><6> 1 2020-11-20T18:14:19.159538+01:00 LABNBS5B kernel - - -
>[65818.378835] netdev change bearer <eth:bond0>
><6> 1 2020-11-20T18:14:19.263523+01:00 LABNBS5B kernel - - -
>[65818.482384] bond0: link status definitely up for interface eth1
><6> 1 2020-11-20T18:14:19.263534+01:00 LABNBS5B kernel - - -
>[65818.482387] bond0: making interface eth1 the new active one
><6> 1 2020-11-20T18:14:19.263536+01:00 LABNBS5B kernel - - -
>[65818.482633] bond0: first active interface up!
><6> 1 2020-11-20T18:14:19.263537+01:00 LABNBS5B kernel - - -
>[65818.482671] netdev change bearer <eth:bond0>
><6> 1 2020-11-20T18:14:19.367523+01:00 LABNBS5B kernel - - -
>[65818.586228] bond0: bond_activebackup_arp_mon: call_netdevice_notifiers
>NETDEV_NOTIFY_PEERS
>
>There is no issue when using MII monitoring instead of ARP monitoring
>since when the slave is detected as down, it immediately switches to the
>backup as it sees that slave as being up and ready. But when using ARP
>monitoring, only one of the slaves is 'up'. So when the active slave goes
>down, the bonding driver will see no active slaves until it brings up the
>backup slave on the next call to bond_activebackup_arp_mon. Bringing up
>that backup slave has to be attempted prior to notifying any peers of a
>change or else they will see the outage. In this case it seems the
>should_notify_rtnl flag has to be set to false. However, I also question
>if the switch to the backup slave should actually occur immediately like
>it does for MII and that the backup should be immediately 'brought
>up/switched to' without having to wait for the next iteration.

	I see what you're describing; I'm watching "ip monitor" while
doing failovers and comparing the behavior of the miimon vs the ARP
monitor.  The bond device itself goes down during the course of an ARP
failover, which doesn't happen during the miimon failover.

	This does cause some churn of even the IPv4 multicast addresses
and such, so it would be ideal if the backup interfaces could be kept
track of and switched to immediately as you suggest.

	I don't think it's simply a matter of not doing a notification,
however.  I haven't instrumented it completely yet to see the complete
behavior, but the backup interface has to be in a bonding-internal down
state, otherwise the bond_ab_arp_commit call to bond_select_active_slave
would select a new active slave, and the bond itself would not go
NO-CARRIER (which is likely where the NETDEV_CHANGE event comes from,
via linkwatch doing netdev_state_change).

[...]

>As it currently behaves there is no way to run TIPC over an active-backup
>ARP-monitored bond device. I suspect there are other situations/uses that
>would likewise have an issue with the 'erroneous' NETDEV_CHANGE being
>issued. Since TIPC (and others) have no idea what the dev is, it is not
>possible to ignore the event nor should it be ignored. It therefore seems
>the event shouldn't be sent for this situation. Please confirm the
>analysis above and provide a path forward since as currently implemented
>the functionality is broken.

	As I said above, I don't think it's just about notifications.

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
