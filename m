Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E363722512E
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 12:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbgGSKHY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 19 Jul 2020 06:07:24 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:46495 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726012AbgGSKHX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jul 2020 06:07:23 -0400
Received: from sogo10.sd4.0x35.net (sogo10.sd4.0x35.net [10.200.201.60])
        (Authenticated sender: pbl@bestov.io)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPA id 41EF01C0002;
        Sun, 19 Jul 2020 10:07:22 +0000 (UTC)
From:   "Riccardo Paolo Bestetti" <pbl@bestov.io>
In-Reply-To: <6897.1594914646@famine>
Content-Type: text/plain; charset="utf-8"
X-Forward: 127.0.0.1
Date:   Sun, 19 Jul 2020 12:07:21 +0200
Cc:     netdev@vger.kernel.org
To:     "Jay Vosburgh" <jay.vosburgh@canonical.com>
MIME-Version: 1.0
Message-ID: <7a15-5f141b80-6d-5af71280@110401022>
Subject: =?utf-8?q?Re=3A?= Bonding driver unexpected behaviour
User-Agent: SOGoMail 4.3.2
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thursday, July 16, 2020 17:50 CEST, Jay Vosburgh <jay.vosburgh@canonical.com> wrote: 
 
> pbl@bestov.io <pbl@bestov.io> wrote:
> 	[...] I believe the lack of
> fail-back to gretap15 is the expected behavior.  The primary_reselect
> value only matters if some interface has been specified as "primary",
> and your configuration does not do so.  Specifying something like
> 
> ip link set bond-15-16 type bond primary gretap15
> 
> 	would likely result in the fail-back behavior you describe.
You are absolutely right! I had assumed that the first device added to the bond would be the primary device, but this is of course not the documented behaviour and a quick read of the source code seems to confirm this. I have now changed this and gretap15 is the primary interface on both hosts.

> >Fiddling with the cables (e.g. reconnecting intra15 and then
> >disconnecting intra16) and/or bringing the bond interface down and up
> >usually results in the driver ping-ponging a bit between gretap15 and
> >gretap16, before usually settling on gretap16 (but never on gretap15,
> >it seems). Or, sometimes, it results in the driver marking both slaves
> >down and not doing anything ever again until manual intervention
> >(e.g. manually selecting a new active_slave, or down -> up).
> >
> >Trying to ping the gretap15 address of the peer (10.188.15.200) from
> >the host while gretap16 is the active slave results in ARP traffic
> >being temporarily exchanged on gretap15. I'm not sure whether it
> >originates from the bonding driver, as it seems like the generated
> >requests are the cartesian product of all address couples on the
> >network segments of gretap15 and bond-15-16 (e.g. who-has 10.188.15.100
> >tell 10.188.15.100, who-has 10.188.15.100 tell 10.188.15.200, ...,
> >who-hash 10.42.42.200 tell 10.42.42.200).
> 
> 	Do these ARP requests receive appropriate ARP replies?  Do you
> see entries for the addresses in the output of "ip neigh show", and are
> they FAILED or REACHABLE / STALE?
Yes, it seems that the ARP requests always get a proper replies. This morning, I checked the neighbour table and 10.88.15.200 (gretap15's peer on intra15) was marked as STALE. I assumed it was because no ARP probes were sent over gretap15 by the bonding driver, and thus no ARP probes were sent over intra15 to refresh the table for 10.88.15.200 after the entry got STALE'd.
My assumption seems to be confirmed: I tried to ping 10.188.15.200 (peer's address inside gretap15) and while it of course didn't respond - as the interface is slaved to bond-15-16 - it did create egress packets over gretap15, which in turn caused routing to send ARP requests over intra15 to 10.88.15.200 to send out the encapsulating GRE packets.

Also,
# arping -I gretap15 10.42.42.200
gets proper replies and... it causes gretap15 to be immediately reselected. So it does indeed look like the driver is just refusing to send the probes for no proper reason (i.e. if it would do that, it would result in the expected behaviour.)

I'm really not set up to dip my nose in the kernel. I would nonetheless like to attempt to do it, and to prepare a patch, if I shall succeed. Could you or anyone with expertise in netdev point me to the right places to look in the source code?

Riccardo P. Bestetti

