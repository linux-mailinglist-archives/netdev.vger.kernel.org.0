Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6677D2F7F15
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 16:11:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731457AbhAOPKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 10:10:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22007 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725946AbhAOPKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 10:10:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610723346;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7rCXn4uKhf7lriUdd89Go0eIimq5b4VbPf7vPd4lZTY=;
        b=Q0IWLW5HXzBpgRW2L5umW2mfL8cA/ItRwNXEQlLxABjPgCzNkMRpUFRGZKhf1AC553phXF
        MfjuVIFFR0VKOeh4aWVq5YTC9kUpYHB9p8NbzOWNDGjoKi1h+KDDd/gYqBW2D5lq1iOMte
        mAbWIv8Xev4Q956Fg82AvgqTNlmWFGE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-R8xIz1GvOn2tHvWZ6FAm1A-1; Fri, 15 Jan 2021 10:09:02 -0500
X-MC-Unique: R8xIz1GvOn2tHvWZ6FAm1A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1D5641009466;
        Fri, 15 Jan 2021 15:09:01 +0000 (UTC)
Received: from redhat.com (dhcp-17-185.bos.redhat.com [10.18.17.185])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B8B8F19C45;
        Fri, 15 Jan 2021 15:08:59 +0000 (UTC)
Date:   Fri, 15 Jan 2021 10:08:57 -0500
From:   Jarod Wilson <jarod@redhat.com>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2] bonding: add a vlan+mac tx hashing option
Message-ID: <20210115150857.GA1176575@redhat.com>
References: <20201218193033.6138-1-jarod@redhat.com>
 <20210113223548.1171655-1-jarod@redhat.com>
 <20210113175818.7dce3076@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210114211141.GH1171031@redhat.com>
 <8507.1610661271@famine>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8507.1610661271@famine>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 01:54:31PM -0800, Jay Vosburgh wrote:
> Jarod Wilson <jarod@redhat.com> wrote:
> 
> >On Wed, Jan 13, 2021 at 05:58:18PM -0800, Jakub Kicinski wrote:
> >> On Wed, 13 Jan 2021 17:35:48 -0500 Jarod Wilson wrote:
> >> > This comes from an end-user request, where they're running multiple VMs on
> >> > hosts with bonded interfaces connected to some interest switch topologies,
> >> > where 802.3ad isn't an option. They're currently running a proprietary
> >> > solution that effectively achieves load-balancing of VMs and bandwidth
> >> > utilization improvements with a similar form of transmission algorithm.
> >> > 
> >> > Basically, each VM has it's own vlan, so it always sends its traffic out
> >> > the same interface, unless that interface fails. Traffic gets split
> >> > between the interfaces, maintaining a consistent path, with failover still
> >> > available if an interface goes down.
> >> > 
> >> > This has been rudimetarily tested to provide similar results, suitable for
> >> > them to use to move off their current proprietary solution. A patch for
> >> > iproute2 is forthcoming as well, to properly support the new mode there as
> >> > well.
> >> 
> >> > Signed-off-by: Jarod Wilson <jarod@redhat.com>
> >> > ---
> >> > v2: verified netlink interfaces working, added Documentation, changed
> >> > tx hash mode name to vlan+mac for consistency and clarity.
> >> > 
> >> >  Documentation/networking/bonding.rst | 13 +++++++++++++
> >> >  drivers/net/bonding/bond_main.c      | 27 +++++++++++++++++++++++++--
> >> >  drivers/net/bonding/bond_options.c   |  1 +
> >> >  include/linux/netdevice.h            |  1 +
> >> >  include/uapi/linux/if_bonding.h      |  1 +
> >> >  5 files changed, 41 insertions(+), 2 deletions(-)
> >> > 
> >> > diff --git a/Documentation/networking/bonding.rst b/Documentation/networking/bonding.rst
> >> > index adc314639085..c78ceb7630a0 100644
> >> > --- a/Documentation/networking/bonding.rst
> >> > +++ b/Documentation/networking/bonding.rst
> >> > @@ -951,6 +951,19 @@ xmit_hash_policy
> >> >  		packets will be distributed according to the encapsulated
> >> >  		flows.
> >> >  
> >> > +	vlan+mac
> 
> 	I notice that the code calls it "VLAN_SRCMAC" but the
> user-facing nomenclature is "vlan+mac"; I tend to lean towards having
> the user visible name also be "vlan+srcmac".  Both for consistency, and
> just in case someone someday wants "vlan+dstmac".  And you did ask for
> preference on this in a separate email.

That's valid. I was trying to keep it short, but it does muddy the waters
a bit by not including src. I'll adjust accordingly and resend the
userspace bit too.

...
> 	Yah, the existing L2 hash is pretty weak.  It might be possible
> to squeeze this into the existing bond_xmit_hash a bit better, if the
> hash is two u32s.  The first being the first 32 bits of the MAC, and the
> second being the last 16 bits of the MAC combined with the 16 bit VLAN
> tag.
> 
> 	There's already logic at the end of bond_xmit_hash to reduce a
> u32 into the final hash that perhaps could be leveraged.  
> 
> 	Thinking about it, though, all the ways to combine that data
> together end up being pretty vile ("*(u32 *)&ethhdr->h_source[0]" sorts
> of things).

Yeah, I'd worry that bond_xmit_hash() is already getting a bit complicated
to follow and understand, and that would make it even more so.

> >Something like this instead maybe:
> >
> >static u32 bond_vlan_srcmac_hash(struct sk_buff *skb)
> >{
> >        struct ethhdr *mac_hdr = (struct ethhdr *)skb_mac_header(skb);
> >        u32 srcmac = 0;
> >        u16 vlan;
> >        int i;
> >
> >        for (i = 0; i < ETH_ALEN; i++)
> >                srcmac = (srcmac << 8) | mac_hdr->h_source[i];
> 
> 	I think this will shift h_source[0] and [1] into oblivion.

Argh, yep, 48 bits don't fit into a u32. Okay, so I'll replace that with a
u32 srcmac_vendor and u32 srcmac_dev, but they'll only have 24 bits of data
in them, then return vlan ^ srcmac_vendor ^ srcmac_dev, I think.

-- 
Jarod Wilson
jarod@redhat.com

