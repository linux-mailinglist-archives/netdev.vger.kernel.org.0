Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2F72F6CF3
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 22:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729586AbhANVNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 16:13:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26172 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728045AbhANVNP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 16:13:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610658708;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GSCfvzaG4WiMcrguQP0u8pZSoPVwwncg644eemt1prI=;
        b=TH2q87EojUtIhPXJp01xZAiODM6aBsbGeoqSX8tktMIhaP9JP1FYBQX37h29U0wXIXOZ9o
        fKdPVp6U4h5fIC8S6dPwjLvzCHJ5uJwou5OvcUAA/p37KDYYRDOfGMr05XoycNnRsZmicG
        hdTkdwDHzzy2JeNBL5imfu9zi4M3bQs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-554-A6oLVsTLPxa2lDEKxgFWPw-1; Thu, 14 Jan 2021 16:11:46 -0500
X-MC-Unique: A6oLVsTLPxa2lDEKxgFWPw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1A89D806663;
        Thu, 14 Jan 2021 21:11:45 +0000 (UTC)
Received: from redhat.com (dhcp-17-185.bos.redhat.com [10.18.17.185])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E150A10016F7;
        Thu, 14 Jan 2021 21:11:43 +0000 (UTC)
Date:   Thu, 14 Jan 2021 16:11:41 -0500
From:   Jarod Wilson <jarod@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2] bonding: add a vlan+mac tx hashing option
Message-ID: <20210114211141.GH1171031@redhat.com>
References: <20201218193033.6138-1-jarod@redhat.com>
 <20210113223548.1171655-1-jarod@redhat.com>
 <20210113175818.7dce3076@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210113175818.7dce3076@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 05:58:18PM -0800, Jakub Kicinski wrote:
> On Wed, 13 Jan 2021 17:35:48 -0500 Jarod Wilson wrote:
> > This comes from an end-user request, where they're running multiple VMs on
> > hosts with bonded interfaces connected to some interest switch topologies,
> > where 802.3ad isn't an option. They're currently running a proprietary
> > solution that effectively achieves load-balancing of VMs and bandwidth
> > utilization improvements with a similar form of transmission algorithm.
> > 
> > Basically, each VM has it's own vlan, so it always sends its traffic out
> > the same interface, unless that interface fails. Traffic gets split
> > between the interfaces, maintaining a consistent path, with failover still
> > available if an interface goes down.
> > 
> > This has been rudimetarily tested to provide similar results, suitable for
> > them to use to move off their current proprietary solution. A patch for
> > iproute2 is forthcoming as well, to properly support the new mode there as
> > well.
> 
> > Signed-off-by: Jarod Wilson <jarod@redhat.com>
> > ---
> > v2: verified netlink interfaces working, added Documentation, changed
> > tx hash mode name to vlan+mac for consistency and clarity.
> > 
> >  Documentation/networking/bonding.rst | 13 +++++++++++++
> >  drivers/net/bonding/bond_main.c      | 27 +++++++++++++++++++++++++--
> >  drivers/net/bonding/bond_options.c   |  1 +
> >  include/linux/netdevice.h            |  1 +
> >  include/uapi/linux/if_bonding.h      |  1 +
> >  5 files changed, 41 insertions(+), 2 deletions(-)
> > 
> > diff --git a/Documentation/networking/bonding.rst b/Documentation/networking/bonding.rst
> > index adc314639085..c78ceb7630a0 100644
> > --- a/Documentation/networking/bonding.rst
> > +++ b/Documentation/networking/bonding.rst
> > @@ -951,6 +951,19 @@ xmit_hash_policy
> >  		packets will be distributed according to the encapsulated
> >  		flows.
> >  
> > +	vlan+mac
> > +
> > +		This policy uses a very rudimentary vland ID and source mac
> > +		ID hash to load-balance traffic per-vlan, with failover
> > +		should one leg fail. The intended use case is for a bond
> > +		shared by multiple virtual machines, all configured to
> > +		use their own vlan, to give lacp-like functionality
> > +		without requiring lacp-capable switching hardware.
> > +
> > +		The formula for the hash is simply
> > +
> > +		hash = (vlan ID) XOR (source MAC)
> 
> But in the code it's only using one byte of the MAC, currently.
> 
> I think that's fine for the particular use case but should we call out
> explicitly in the commit message why it's considered sufficient?
> 
> Someone can change it later, if needed, but best if we spell out the
> current motivation.

In truth, this code started out as a copy of bond_eth_hash(), which also
only uses the last byte, though of both source and destination macs. In
the typical use case for the requesting user, the bond is formed from two
onboard NICs, which typically have adjacent mac addresses, i.e.,
AA:BB:CC:DD:EE:01 and AA:BB:CC:DD:EE:02, so only the last byte is really
relevant to hash differently, but in thinking about it, a replacement NIC
because an onboard one died could have the same last byte, and maybe we
ought to just go full source mac right off the go here.

Something like this instead maybe:

static u32 bond_vlan_srcmac_hash(struct sk_buff *skb)
{
        struct ethhdr *mac_hdr = (struct ethhdr *)skb_mac_header(skb);
        u32 srcmac = 0;
        u16 vlan;
        int i;

        for (i = 0; i < ETH_ALEN; i++)
                srcmac = (srcmac << 8) | mac_hdr->h_source[i];

        if (!skb_vlan_tag_present(skb))
                return srcmac;

        vlan = skb_vlan_tag_get(skb);

        return vlan ^ srcmac;
}

Then the documentation is spot-on, and we're future-proof, though
marginally less performant in calculating the hash, which may have been a
consideration when the original function was written, but is probably
basically irrelevant w/modern systems...

> >  	The default value is layer2.  This option was added in bonding
> >  	version 2.6.3.  In earlier versions of bonding, this parameter
> >  	does not exist, and the layer2 policy is the only policy.  The
> 
> > +static inline u32 bond_vlan_srcmac_hash(struct sk_buff *skb)
> 
> Can we drop the inline? It's a static function called once.

Works for me. That was also inherited by copying bond_eth_hash(). :)

> > +{
> > +	struct ethhdr *mac_hdr = (struct ethhdr *)skb_mac_header(skb);
> 
> I don't see anything in the patch making sure the interface actually
> has a L2 header. Should we validate somehow the ifc is Ethernet?

I don't think it's necessary. There doesn't appear to be any explicit
check for BOND_XMIT_POLICY_LAYER2 either. I believe we're guaranteed to
not have anything but an ethernet header here, as the only other type I'm
aware of being supported is Infiniband, but we limit that to active-backup
only, and xmit_hash_policy isn't valid for active-backup.

-- 
Jarod Wilson
jarod@redhat.com

