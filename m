Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59A8A2EEA21
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 01:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729428AbhAHAFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 19:05:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57790 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728698AbhAHAFN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 19:05:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610064227;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L4HO0Yj29jyCFpzT2x1n0U+73ImIUkhV6HJs7/htSCA=;
        b=Ah566ojRBi2uynVSguGXbia7AzP4l7p5cbHIU9VFYyvEALXZq5JmxcHG2CZkAq6pvyWmL8
        LI6UlKI1+2nr/JuvGKN+mzQoEWWa1cC3j+OvlvklFHWAlAIE6RCwN0t9l3LMr08vZLNnGY
        p9RaaxKHcv1S7D+BaE76xdM7Wy31/u4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-151-uCmgvnO7PvSKOd1nT75pMw-1; Thu, 07 Jan 2021 19:03:45 -0500
X-MC-Unique: uCmgvnO7PvSKOd1nT75pMw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A67FB801817;
        Fri,  8 Jan 2021 00:03:43 +0000 (UTC)
Received: from redhat.com (dhcp-17-185.bos.redhat.com [10.18.17.185])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 893ED19809;
        Fri,  8 Jan 2021 00:03:42 +0000 (UTC)
Date:   Thu, 7 Jan 2021 19:03:40 -0500
From:   Jarod Wilson <jarod@redhat.com>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     linux-kernel@vger.kernel.org, Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: Re: [RFC PATCH net-next] bonding: add a vlan+srcmac tx hashing option
Message-ID: <20210108000340.GC29828@redhat.com>
References: <20201218193033.6138-1-jarod@redhat.com>
 <21784.1608337139@famine>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21784.1608337139@famine>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 18, 2020 at 04:18:59PM -0800, Jay Vosburgh wrote:
> Jarod Wilson <jarod@redhat.com> wrote:
> 
> >This comes from an end-user request, where they're running multiple VMs on
> >hosts with bonded interfaces connected to some interest switch topologies,
> >where 802.3ad isn't an option. They're currently running a proprietary
> >solution that effectively achieves load-balancing of VMs and bandwidth
> >utilization improvements with a similar form of transmission algorithm.
> >
> >Basically, each VM has it's own vlan, so it always sends its traffic out
> >the same interface, unless that interface fails. Traffic gets split
> >between the interfaces, maintaining a consistent path, with failover still
> >available if an interface goes down.
> >
> >This has been rudimetarily tested to provide similar results, suitable for
> >them to use to move off their current proprietary solution.
> >
> >Still on the TODO list, if these even looks sane to begin with, is
> >fleshing out Documentation/networking/bonding.rst.
> 
> 	I'm sure you're aware, but any final submission will also need
> to include netlink and iproute2 support.

I believe everything for netlink support is already included, but I'll
double-check that before submitting something for inclusion consideration.

> >diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> >index 5fe5232cc3f3..151ce8c7a56f 100644
> >--- a/drivers/net/bonding/bond_main.c
> >+++ b/drivers/net/bonding/bond_main.c
> >@@ -164,7 +164,7 @@ module_param(xmit_hash_policy, charp, 0);
> > MODULE_PARM_DESC(xmit_hash_policy, "balance-alb, balance-tlb, balance-xor, 802.3ad hashing method; "
> > 				   "0 for layer 2 (default), 1 for layer 3+4, "
> > 				   "2 for layer 2+3, 3 for encap layer 2+3, "
> >-				   "4 for encap layer 3+4");
> >+				   "4 for encap layer 3+4, 5 for vlan+srcmac");
> > module_param(arp_interval, int, 0);
> > MODULE_PARM_DESC(arp_interval, "arp interval in milliseconds");
> > module_param_array(arp_ip_target, charp, NULL, 0);
> >@@ -1434,6 +1434,8 @@ static enum netdev_lag_hash bond_lag_hash_type(struct bonding *bond,
> > 		return NETDEV_LAG_HASH_E23;
> > 	case BOND_XMIT_POLICY_ENCAP34:
> > 		return NETDEV_LAG_HASH_E34;
> >+	case BOND_XMIT_POLICY_VLAN_SRCMAC:
> >+		return NETDEV_LAG_HASH_VLAN_SRCMAC;
> > 	default:
> > 		return NETDEV_LAG_HASH_UNKNOWN;
> > 	}
> >@@ -3494,6 +3496,20 @@ static bool bond_flow_ip(struct sk_buff *skb, struct flow_keys *fk,
> > 	return true;
> > }
> > 
> >+static inline u32 bond_vlan_srcmac_hash(struct sk_buff *skb)
> >+{
> >+	struct ethhdr *mac_hdr = (struct ethhdr *)skb_mac_header(skb);
> >+	u32 srcmac = mac_hdr->h_source[5];
> >+	u16 vlan;
> >+
> >+	if (!skb_vlan_tag_present(skb))
> >+		return srcmac;
> >+
> >+	vlan = skb_vlan_tag_get(skb);
> >+
> >+	return srcmac ^ vlan;
> 
> 	For the common configuration wherein multiple VLANs are
> configured atop a single interface (and thus by default end up with the
> same MAC address), this seems like a fairly weak hash.  The TCI is 16
> bits (12 of which are the VID), but only 8 are used from the MAC, which
> will be a constant.
> 
> 	Is this algorithm copying the proprietary solution you mention?

I've not actually seen the code in question, so I can't be 100% certain,
but this is exactly how it was described to me, and testing seems to bear
out that it behaves at least similarly enough for the user. They like
simplicity, and the very basic hash suits their needs, which are basically
just getting some load-balancing with failover w/o having to have lacp,
running on some older switches that can't do lacp.

-- 
Jarod Wilson
jarod@redhat.com

