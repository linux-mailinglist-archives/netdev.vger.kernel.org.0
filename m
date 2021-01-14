Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7178A2F6D92
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 22:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730510AbhANVzV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 14 Jan 2021 16:55:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45832 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726755AbhANVzU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 16:55:20 -0500
Received: from 1.general.jvosburgh.us.vpn ([10.172.68.206] helo=famine.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <jay.vosburgh@canonical.com>)
        id 1l0AZd-0006kn-NZ; Thu, 14 Jan 2021 21:54:34 +0000
Received: by famine.localdomain (Postfix, from userid 1000)
        id E2D505FEE8; Thu, 14 Jan 2021 13:54:31 -0800 (PST)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id DC5BFA0411;
        Thu, 14 Jan 2021 13:54:31 -0800 (PST)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jarod Wilson <jarod@redhat.com>
cc:     Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2] bonding: add a vlan+mac tx hashing option
In-reply-to: <20210114211141.GH1171031@redhat.com>
References: <20201218193033.6138-1-jarod@redhat.com> <20210113223548.1171655-1-jarod@redhat.com> <20210113175818.7dce3076@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <20210114211141.GH1171031@redhat.com>
Comments: In-reply-to Jarod Wilson <jarod@redhat.com>
   message dated "Thu, 14 Jan 2021 16:11:41 -0500."
X-Mailer: MH-E 8.6+git; nmh 1.6; GNU Emacs 27.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8506.1610661271.1@famine>
Content-Transfer-Encoding: 8BIT
Date:   Thu, 14 Jan 2021 13:54:31 -0800
Message-ID: <8507.1610661271@famine>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jarod Wilson <jarod@redhat.com> wrote:

>On Wed, Jan 13, 2021 at 05:58:18PM -0800, Jakub Kicinski wrote:
>> On Wed, 13 Jan 2021 17:35:48 -0500 Jarod Wilson wrote:
>> > This comes from an end-user request, where they're running multiple VMs on
>> > hosts with bonded interfaces connected to some interest switch topologies,
>> > where 802.3ad isn't an option. They're currently running a proprietary
>> > solution that effectively achieves load-balancing of VMs and bandwidth
>> > utilization improvements with a similar form of transmission algorithm.
>> > 
>> > Basically, each VM has it's own vlan, so it always sends its traffic out
>> > the same interface, unless that interface fails. Traffic gets split
>> > between the interfaces, maintaining a consistent path, with failover still
>> > available if an interface goes down.
>> > 
>> > This has been rudimetarily tested to provide similar results, suitable for
>> > them to use to move off their current proprietary solution. A patch for
>> > iproute2 is forthcoming as well, to properly support the new mode there as
>> > well.
>> 
>> > Signed-off-by: Jarod Wilson <jarod@redhat.com>
>> > ---
>> > v2: verified netlink interfaces working, added Documentation, changed
>> > tx hash mode name to vlan+mac for consistency and clarity.
>> > 
>> >  Documentation/networking/bonding.rst | 13 +++++++++++++
>> >  drivers/net/bonding/bond_main.c      | 27 +++++++++++++++++++++++++--
>> >  drivers/net/bonding/bond_options.c   |  1 +
>> >  include/linux/netdevice.h            |  1 +
>> >  include/uapi/linux/if_bonding.h      |  1 +
>> >  5 files changed, 41 insertions(+), 2 deletions(-)
>> > 
>> > diff --git a/Documentation/networking/bonding.rst b/Documentation/networking/bonding.rst
>> > index adc314639085..c78ceb7630a0 100644
>> > --- a/Documentation/networking/bonding.rst
>> > +++ b/Documentation/networking/bonding.rst
>> > @@ -951,6 +951,19 @@ xmit_hash_policy
>> >  		packets will be distributed according to the encapsulated
>> >  		flows.
>> >  
>> > +	vlan+mac

	I notice that the code calls it "VLAN_SRCMAC" but the
user-facing nomenclature is "vlan+mac"; I tend to lean towards having
the user visible name also be "vlan+srcmac".  Both for consistency, and
just in case someone someday wants "vlan+dstmac".  And you did ask for
preference on this in a separate email.

>> > +		This policy uses a very rudimentary vland ID and source mac
>> > +		ID hash to load-balance traffic per-vlan, with failover
>> > +		should one leg fail. The intended use case is for a bond
>> > +		shared by multiple virtual machines, all configured to
>> > +		use their own vlan, to give lacp-like functionality
>> > +		without requiring lacp-capable switching hardware.
>> > +
>> > +		The formula for the hash is simply
>> > +
>> > +		hash = (vlan ID) XOR (source MAC)
>> 
>> But in the code it's only using one byte of the MAC, currently.
>> 
>> I think that's fine for the particular use case but should we call out
>> explicitly in the commit message why it's considered sufficient?
>> 
>> Someone can change it later, if needed, but best if we spell out the
>> current motivation.
>
>In truth, this code started out as a copy of bond_eth_hash(), which also
>only uses the last byte, though of both source and destination macs. In
>the typical use case for the requesting user, the bond is formed from two
>onboard NICs, which typically have adjacent mac addresses, i.e.,
>AA:BB:CC:DD:EE:01 and AA:BB:CC:DD:EE:02, so only the last byte is really
>relevant to hash differently, but in thinking about it, a replacement NIC
>because an onboard one died could have the same last byte, and maybe we
>ought to just go full source mac right off the go here.

	Yah, the existing L2 hash is pretty weak.  It might be possible
to squeeze this into the existing bond_xmit_hash a bit better, if the
hash is two u32s.  The first being the first 32 bits of the MAC, and the
second being the last 16 bits of the MAC combined with the 16 bit VLAN
tag.

	There's already logic at the end of bond_xmit_hash to reduce a
u32 into the final hash that perhaps could be leveraged.  

	Thinking about it, though, all the ways to combine that data
together end up being pretty vile ("*(u32 *)&ethhdr->h_source[0]" sorts
of things).

>Something like this instead maybe:
>
>static u32 bond_vlan_srcmac_hash(struct sk_buff *skb)
>{
>        struct ethhdr *mac_hdr = (struct ethhdr *)skb_mac_header(skb);
>        u32 srcmac = 0;
>        u16 vlan;
>        int i;
>
>        for (i = 0; i < ETH_ALEN; i++)
>                srcmac = (srcmac << 8) | mac_hdr->h_source[i];

	I think this will shift h_source[0] and [1] into oblivion.

>        if (!skb_vlan_tag_present(skb))
>                return srcmac;
>
>        vlan = skb_vlan_tag_get(skb);
>
>        return vlan ^ srcmac;
>}
>
>Then the documentation is spot-on, and we're future-proof, though
>marginally less performant in calculating the hash, which may have been a
>consideration when the original function was written, but is probably
>basically irrelevant w/modern systems...
>
>> >  	The default value is layer2.  This option was added in bonding
>> >  	version 2.6.3.  In earlier versions of bonding, this parameter
>> >  	does not exist, and the layer2 policy is the only policy.  The
>> 
>> > +static inline u32 bond_vlan_srcmac_hash(struct sk_buff *skb)
>> 
>> Can we drop the inline? It's a static function called once.
>
>Works for me. That was also inherited by copying bond_eth_hash(). :)
>
>> > +{
>> > +	struct ethhdr *mac_hdr = (struct ethhdr *)skb_mac_header(skb);
>> 
>> I don't see anything in the patch making sure the interface actually
>> has a L2 header. Should we validate somehow the ifc is Ethernet?
>
>I don't think it's necessary. There doesn't appear to be any explicit
>check for BOND_XMIT_POLICY_LAYER2 either. I believe we're guaranteed to
>not have anything but an ethernet header here, as the only other type I'm
>aware of being supported is Infiniband, but we limit that to active-backup
>only, and xmit_hash_policy isn't valid for active-backup.

	This is correct, interfaces in a bond other than active-backup
will all be ARPHRD_ETHER.  I'm unaware of a way to get a packet in there
without at least an Ethernet header.

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
