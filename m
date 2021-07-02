Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 325B23B9CFC
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 09:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbhGBHhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 03:37:22 -0400
Received: from proxmox-new.maurer-it.com ([94.136.29.106]:1568 "EHLO
        proxmox-new.maurer-it.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbhGBHhW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 03:37:22 -0400
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
        by proxmox-new.maurer-it.com (Proxmox) with ESMTP id 841DF404AD;
        Fri,  2 Jul 2021 09:34:49 +0200 (CEST)
Date:   Fri, 2 Jul 2021 09:34:46 +0200
From:   Wolfgang Bumiller <w.bumiller@proxmox.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     Thomas Lamprecht <t.lamprecht@proxmox.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        Vlad Yasevich <vyasevic@redhat.com>
Subject: Re: [PATCH 1/1] net: bridge: sync fdb to new unicast-filtering ports
Message-ID: <20210702073446.xvq3xphk3rkcjdrh@wobu-vie.proxmox.com>
References: <20210701122830.2652-1-w.bumiller@proxmox.com>
 <20210701122830.2652-2-w.bumiller@proxmox.com>
 <39385134-e499-2444-aa0d-48b0315e1002@nvidia.com>
 <131fc6eb-7da2-ccac-2da0-b82c19dfef84@proxmox.com>
 <5a470258-a06b-64d0-fca0-f4eafe7e23e2@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a470258-a06b-64d0-fca0-f4eafe7e23e2@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 01, 2021 at 06:33:20PM +0300, Nikolay Aleksandrov wrote:
> On 01/07/2021 17:51, Thomas Lamprecht wrote:
> > On 01.07.21 15:49, Nikolay Aleksandrov wrote:
> >> On 01/07/2021 15:28, Wolfgang Bumiller wrote:
> >>> Since commit 2796d0c648c9 ("bridge: Automatically manage
> >>> port promiscuous mode.")
> >>> bridges with `vlan_filtering 1` and only 1 auto-port don't
> >>> set IFF_PROMISC for unicast-filtering-capable ports.
> >>>
> >>> Normally on port changes `br_manage_promisc` is called to
> >>> update the promisc flags and unicast filters if necessary,
> >>> but it cannot distinguish between *new* ports and ones
> >>> losing their promisc flag, and new ports end up not
> >>> receiving the MAC address list.
> >>>
> >>> Fix this by calling `br_fdb_sync_static` in `br_add_if`
> >>> after the port promisc flags are updated and the unicast
> >>> filter was supposed to have been filled.
> >>>
> >>> Signed-off-by: Wolfgang Bumiller <w.bumiller@proxmox.com>
> >>> ---
> >>>  net/bridge/br_if.c | 12 ++++++++++++
> >>>  1 file changed, 12 insertions(+)
> >>>
> >>> diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
> >>> index f7d2f472ae24..183e72e7b65e 100644
> >>> --- a/net/bridge/br_if.c
> >>> +++ b/net/bridge/br_if.c
> >>> @@ -652,6 +652,18 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
> >>>  	list_add_rcu(&p->list, &br->port_list);
> >>>  
> >>>  	nbp_update_port_count(br);
> >>> +	if (!br_promisc_port(p) && (p->dev->priv_flags & IFF_UNICAST_FLT)) {
> >>> +		/* When updating the port count we also update all ports'
> >>> +		 * promiscuous mode.
> >>> +		 * A port leaving promiscuous mode normally gets the bridge's
> >>> +		 * fdb synced to the unicast filter (if supported), however,
> >>> +		 * `br_port_clear_promisc` does not distinguish between
> >>> +		 * non-promiscuous ports and *new* ports, so we need to
> >>> +		 * sync explicitly here.
> >>> +		 */
> >>> +		if (br_fdb_sync_static(br, p))
> >>> +			netdev_err(dev, "failed to sync bridge addresses to this port\n");
> >>> +	}
> >>>  
> >>>  	netdev_update_features(br->dev);
> >>>  
> >>>
> >>
> >> Hi,
> > 
> > Hi, commenting as was peripherally involved into this.
> > 
> >> The patch is wrong because br_add_if() can fail after you sync these entries and
> >> then nothing will unsync them. Out of curiousity what's the use case of a bridge with a
> >> single port only ? Because, as you've also noted, this will be an issue only if there is
> >> a single port and sounds like a corner case, maybe there's a better way to handle it.
> > 
> > In practice you're right, it is not often useful, but that does not means that it
> > won't happen. For example, in Proxmox VE, a hypervisor/clustering debian-based distro,
> > we recommend users that they need to migrate all (QEMU) VMs to another cluster-node when
> > doing a (major) upgrade as with that way they get no downtime for the VMs.
> > 
> > Now, if the user had a bridge with a single port this was not an issue as long as VMs
> > where running the TAP device we use for them where bridge ports too.
> > 
> > But on reboot, with all VMs and thus ports still gone, the system comes up with that
> > bridge having a single port.
> > 
> > That itself was seen as a problem until recently because the system set the MAC of the
> > bridge to one of the bridge ports.
> > 
> > But with the next Debian Version (Bullseye) we're pulling in a systemd version which
> > now defaults to MACAddressPolicy=persistent[0] also for virtual devices like bridges,
> > so with that update done and rebooted the bridge has another MAC address, not matching
> > the one of a bridge port anymore, which means the host may, depending on some other
> > side effects like vlan-awareness on (as without that promisc would be enabled anyway),
> > not be ping'able and other issue anymore.
> > Due to some specialty handling of learning/filtering in specific drivers this is not
> > reproducible on every NIC model (IIRC, it was in igb and e1000e ones but not in some
> > realtek ones).
> > 
> > Hope that was not written to confusingly.
> > 
> > [0]: https://www.freedesktop.org/software/systemd/man/systemd.link.html#MACAddressPolicy=
> > 
> 
> I see, thank you for the details. Just to clarify I'm not against fixing it or against this patch,
> the question was out of curiousity only, as for the patch it needs to be fixed so unsync will be
> handled in the error paths after the sync and also I'd suggest changing the error message to contain

Ah sorry, somehow I thought there was already an unsync reachable in
that code path, but I was wrong. Looks like I can just add the unsync
before the list_del in err7 since list_add happens pretty much right
before the sync.
I'll test with a knob to force a failure, I still have my patched qemu
to observe what happens to the mac list on the NIC :-)

> what exactly couldn't be synced:
> "failed to sync bridge static fdb addresses to this port"

Yeah that sounds better! Will change it in v2.

> or something in those lines. Since this fixes actual bug please also add a Fixes: tag with the
> appropriate commit id where it was introduced.

I was a bit hesitant at first about adding this, since I hadn't done any
before/after testing with the particular commit introducing the change,
though I'm fairly confident about that by now (maybe more so since the
`auto_cnt` condition was wrong (fixed up in e0a47d1f7816 ("bridge: Fix
incorrect judgment of promisc"))).

