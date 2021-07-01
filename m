Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D8843B93A9
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 17:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233301AbhGAPDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 11:03:35 -0400
Received: from proxmox-new.maurer-it.com ([94.136.29.106]:64137 "EHLO
        proxmox-new.maurer-it.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232853AbhGAPDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 11:03:34 -0400
X-Greylist: delayed 576 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Jul 2021 11:03:34 EDT
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
        by proxmox-new.maurer-it.com (Proxmox) with ESMTP id A6F69400D5;
        Thu,  1 Jul 2021 16:51:27 +0200 (CEST)
Message-ID: <131fc6eb-7da2-ccac-2da0-b82c19dfef84@proxmox.com>
Date:   Thu, 1 Jul 2021 16:51:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:90.0) Gecko/20100101
 Thunderbird/90.0
Subject: Re: [PATCH 1/1] net: bridge: sync fdb to new unicast-filtering ports
Content-Language: en-US
To:     Nikolay Aleksandrov <nikolay@nvidia.com>,
        Wolfgang Bumiller <w.bumiller@proxmox.com>,
        netdev@vger.kernel.org
Cc:     bridge@lists.linux-foundation.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        Vlad Yasevich <vyasevic@redhat.com>
References: <20210701122830.2652-1-w.bumiller@proxmox.com>
 <20210701122830.2652-2-w.bumiller@proxmox.com>
 <39385134-e499-2444-aa0d-48b0315e1002@nvidia.com>
From:   Thomas Lamprecht <t.lamprecht@proxmox.com>
In-Reply-To: <39385134-e499-2444-aa0d-48b0315e1002@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01.07.21 15:49, Nikolay Aleksandrov wrote:
> On 01/07/2021 15:28, Wolfgang Bumiller wrote:
>> Since commit 2796d0c648c9 ("bridge: Automatically manage
>> port promiscuous mode.")
>> bridges with `vlan_filtering 1` and only 1 auto-port don't
>> set IFF_PROMISC for unicast-filtering-capable ports.
>>
>> Normally on port changes `br_manage_promisc` is called to
>> update the promisc flags and unicast filters if necessary,
>> but it cannot distinguish between *new* ports and ones
>> losing their promisc flag, and new ports end up not
>> receiving the MAC address list.
>>
>> Fix this by calling `br_fdb_sync_static` in `br_add_if`
>> after the port promisc flags are updated and the unicast
>> filter was supposed to have been filled.
>>
>> Signed-off-by: Wolfgang Bumiller <w.bumiller@proxmox.com>
>> ---
>>  net/bridge/br_if.c | 12 ++++++++++++
>>  1 file changed, 12 insertions(+)
>>
>> diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
>> index f7d2f472ae24..183e72e7b65e 100644
>> --- a/net/bridge/br_if.c
>> +++ b/net/bridge/br_if.c
>> @@ -652,6 +652,18 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
>>  	list_add_rcu(&p->list, &br->port_list);
>>  
>>  	nbp_update_port_count(br);
>> +	if (!br_promisc_port(p) && (p->dev->priv_flags & IFF_UNICAST_FLT)) {
>> +		/* When updating the port count we also update all ports'
>> +		 * promiscuous mode.
>> +		 * A port leaving promiscuous mode normally gets the bridge's
>> +		 * fdb synced to the unicast filter (if supported), however,
>> +		 * `br_port_clear_promisc` does not distinguish between
>> +		 * non-promiscuous ports and *new* ports, so we need to
>> +		 * sync explicitly here.
>> +		 */
>> +		if (br_fdb_sync_static(br, p))
>> +			netdev_err(dev, "failed to sync bridge addresses to this port\n");
>> +	}
>>  
>>  	netdev_update_features(br->dev);
>>  
>>
> 
> Hi,

Hi, commenting as was peripherally involved into this.

> The patch is wrong because br_add_if() can fail after you sync these entries and
> then nothing will unsync them. Out of curiousity what's the use case of a bridge with a
> single port only ? Because, as you've also noted, this will be an issue only if there is
> a single port and sounds like a corner case, maybe there's a better way to handle it.

In practice you're right, it is not often useful, but that does not means that it
won't happen. For example, in Proxmox VE, a hypervisor/clustering debian-based distro,
we recommend users that they need to migrate all (QEMU) VMs to another cluster-node when
doing a (major) upgrade as with that way they get no downtime for the VMs.

Now, if the user had a bridge with a single port this was not an issue as long as VMs
where running the TAP device we use for them where bridge ports too.

But on reboot, with all VMs and thus ports still gone, the system comes up with that
bridge having a single port.

That itself was seen as a problem until recently because the system set the MAC of the
bridge to one of the bridge ports.

But with the next Debian Version (Bullseye) we're pulling in a systemd version which
now defaults to MACAddressPolicy=persistent[0] also for virtual devices like bridges,
so with that update done and rebooted the bridge has another MAC address, not matching
the one of a bridge port anymore, which means the host may, depending on some other
side effects like vlan-awareness on (as without that promisc would be enabled anyway),
not be ping'able and other issue anymore.
Due to some specialty handling of learning/filtering in specific drivers this is not
reproducible on every NIC model (IIRC, it was in igb and e1000e ones but not in some
realtek ones).

Hope that was not written to confusingly.

[0]: https://www.freedesktop.org/software/systemd/man/systemd.link.html#MACAddressPolicy=

> 
> To be honest this promisc management has caused us headaches with scale setups with thousands
> of permanent and static entries where we don't need to sync uc lists, we've actually thought
> about flags to disable this altogether.

FWIW, when we got this reported by a beta tester a initial (not really thought out) idea
of mine was to drop the special br_manage_promisc case to disable promisc on the bridge
port for one single auto-port, introduced by commit 2796d0c648c940b4796f84384fbcfb0a2399db84
in 2014, i.e., something like (still not 100% thought out):


----8<----
diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index f7d2f472ae24..520c79c21362 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -147,18 +147,7 @@ void br_manage_promisc(struct net_bridge *br)
 		if (set_all) {
 			br_port_set_promisc(p);
 		} else {
-			/* If the number of auto-ports is <= 1, then all other
-			 * ports will have their output configuration
-			 * statically specified through fdbs.  Since ingress
-			 * on the auto-port becomes forwarding/egress to other
-			 * ports and egress configuration is statically known,
-			 * we can say that ingress configuration of the
-			 * auto-port is also statically known.
-			 * This lets us disable promiscuous mode and write
-			 * this config to hw.
-			 */
-			if (br->auto_cnt == 0 ||
-			    (br->auto_cnt == 1 && br_auto_port(p)))
+			if (br->auto_cnt == 0)
 				br_port_clear_promisc(p);
 			else
 				br_port_set_promisc(p);

