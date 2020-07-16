Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 851372227CF
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 17:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729130AbgGPPuv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 16 Jul 2020 11:50:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60435 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728126AbgGPPuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 11:50:50 -0400
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1jw69n-0006Mr-RZ; Thu, 16 Jul 2020 15:50:48 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id 216655FEE7; Thu, 16 Jul 2020 08:50:46 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id 19AED9FB38;
        Thu, 16 Jul 2020 08:50:46 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     =?utf-8?q?pbl=40bestov=2Eio?= <pbl@bestov.io>
cc:     netdev@vger.kernel.org
Subject: Re: Bonding driver unexpected behaviour
In-reply-to: <6a31-5f0efa80-3d-68593a00@242352203>
References: <6a31-5f0efa80-3d-68593a00@242352203>
Comments: In-reply-to =?utf-8?q?pbl=40bestov=2Eio?= <pbl@bestov.io>
   message dated "Wed, 15 Jul 2020 14:46:06 +0200."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6896.1594914646.1@famine>
Content-Transfer-Encoding: 8BIT
Date:   Thu, 16 Jul 2020 08:50:46 -0700
Message-ID: <6897.1594914646@famine>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pbl@bestov.io <pbl@bestov.io> wrote:

>I'm attempting to set up the bonding driver on two gretap interfaces,
>gretap15 and gretap16 but I'm observing unexpected (to me) behaviour.
>The underlying interfaces for those two are respectively intra15 (ipv4:
>10.88.15.100/24) and intra16 (ipv4: 10.88.16.100/24). These two are
>e1000 virtual network cards, connected through virtual cables. As such,
>I would exclude any hardware issues. As a peer, I have another Linux
>system configured similarly (ipv4s: 10.88.15.200 on intra15,
>10.88.16.200 on intra16).
>
>The gretap tunnels work as expected. They have the following ipv4 addresses:
>          host           peer
>gretap15  10.188.15.100  10.188.15.200
>gretap16  10.188.16.100  10.188.16.200
>
>When not enslaved by the bond interface, I'm able to exchange packets
>in the tunnel using the internal ip addresses.
>
>I then set up the bonding driver as follows:
># ip link add bond-15-16 type bond
># ip link set bond-15-16 type bond mode active-backup
># ip link set gretap15 down
># ip link set gretap16 down
># ip link set gretap15 master bond-15-16
># ip link set gretap16 master bond-15-16
># ip link set bond-15-16 mtu 1462
># ip addr add 10.42.42.100/24 dev bond-15-16
># ip link set bond-15-16 type bond arp_interval 100 arp_ip_target 10.42.42.200
># ip link set bond-15-16 up
>
>I do the same on the peer system, inverting the interface and ARP
>target IP addresses.
>
>At this point, IP communication using the addresses on the bond
>interfaces works as expected.
>E.g.
># ping 10.24.24.200
>gets responses from the other peer.
>Using tcpdump on the other peer shows the GRE packets coming into
>intra15, and identical ICMP packets coming through gretap15 and
>bond-15-16.
>
>If I then disconnect the (virtual) network cable of intra15, the
>bonding driver switches to intra16, as the GRE tunnel can no longer
>pass packets. However, despite having primary_reselect=0, when I
>reconnect the network cable of intra15, the driver doesn't switch back
>to gretap15. In fact, it doesn't even attempt sending any probes
>through it.

	Based on your configuration above, I believe the lack of
fail-back to gretap15 is the expected behavior.  The primary_reselect
value only matters if some interface has been specified as "primary",
and your configuration does not do so.  Specifying something like

ip link set bond-15-16 type bond primary gretap15

	would likely result in the fail-back behavior you describe.

>Fiddling with the cables (e.g. reconnecting intra15 and then
>disconnecting intra16) and/or bringing the bond interface down and up
>usually results in the driver ping-ponging a bit between gretap15 and
>gretap16, before usually settling on gretap16 (but never on gretap15,
>it seems). Or, sometimes, it results in the driver marking both slaves
>down and not doing anything ever again until manual intervention
>(e.g. manually selecting a new active_slave, or down -> up).
>
>Trying to ping the gretap15 address of the peer (10.188.15.200) from
>the host while gretap16 is the active slave results in ARP traffic
>being temporarily exchanged on gretap15. I'm not sure whether it
>originates from the bonding driver, as it seems like the generated
>requests are the cartesian product of all address couples on the
>network segments of gretap15 and bond-15-16 (e.g. who-has 10.188.15.100
>tell 10.188.15.100, who-has 10.188.15.100 tell 10.188.15.200, ...,
>who-hash 10.42.42.200 tell 10.42.42.200).

	Do these ARP requests receive appropriate ARP replies?  Do you
see entries for the addresses in the output of "ip neigh show", and are
they FAILED or REACHABLE / STALE?

	I have not tested or have familiarity with users using IP tunnel
interfaces with bonding as you're doing, so it's possible that some
aspect of that is interfering with the function of the ARP monitor.

	-J

>uname -a:
>Linux fo-gw 4.19.0-9-amd64 #1 SMP Debian 4.19.118-2+deb10u1 (2020-06-07) x86_64 GNU/Linux
>(same on peer system)
>
>Am I misunderstanding how the driver works? Have I made any mistakes in
>the configuration?
>
>Best regards,
>Riccardo P. Bestetti
>

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
