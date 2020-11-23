Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 671312C1305
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 19:33:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728345AbgKWSUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 13:20:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:34638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728171AbgKWSUm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 13:20:42 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21F2320BED;
        Mon, 23 Nov 2020 18:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606155641;
        bh=yyYRToW6/LjShztiWv4iPEXSDeulM/mTOMd4vEMpTxI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=01HEEUdgM0ltStXiG/yJag4REaiwAFhI3Jv8shuAplB5E7FVs6nxrZtavo6T2+kjI
         rwOFQWoOr/ivkxGxe0cQ+hyzLhyAZ2eXfyeQ9t+mhubXo9aFsnOMaNzujftXc6ercY
         yFrF9K/HO9jJIO1GZ9QbKBPMcwNcA39DCkcBzyMg=
Date:   Mon, 23 Nov 2020 10:20:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tariq Toukan <ttoukan.linux@gmail.com>
Cc:     Jarod Wilson <jarod@redhat.com>, Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>
Subject: Re: [PATCH net-next 0/2] TLS TX HW offload for Bond
Message-ID: <20201123102040.338f32c7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <ee42de0e-e657-4108-3fb7-05e252979673@gmail.com>
References: <20201115134251.4272-1-tariqt@nvidia.com>
        <20201118160239.78871842@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <0e4a04f2-2ffa-179d-3b7b-ef08b52c9290@gmail.com>
        <20201119083811.6b68bfa8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <ee42de0e-e657-4108-3fb7-05e252979673@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 22 Nov 2020 14:48:04 +0200 Tariq Toukan wrote:
> On 11/19/2020 6:38 PM, Jakub Kicinski wrote:
> > On Thu, 19 Nov 2020 17:59:38 +0200 Tariq Toukan wrote:  
> >> On 11/19/2020 2:02 AM, Jakub Kicinski wrote:  
> >>> On Sun, 15 Nov 2020 15:42:49 +0200 Tariq Toukan wrote:  
> >>>> This series opens TLS TX HW offload for bond interfaces.
> >>>> This allows bond interfaces to benefit from capable slave devices.
> >>>>
> >>>> The first patch adds real_dev field in TLS context structure, and aligns
> >>>> usages in TLS module and supporting drivers.
> >>>> The second patch opens the offload for bond interfaces.
> >>>>
> >>>> For the configuration above, SW kTLS keeps picking the same slave
> >>>> To keep simple track of the HW and SW TLS contexts, we bind each socket to
> >>>> a specific slave for the socket's whole lifetime. This is logically valid
> >>>> (and similar to the SW kTLS behavior) in the following bond configuration,
> >>>> so we restrict the offload support to it:
> >>>>
> >>>> ((mode == balance-xor) or (mode == 802.3ad))
> >>>> and xmit_hash_policy == layer3+4.  
> >>>
> >>> This does not feel extremely clean, maybe you can convince me otherwise.
> >>>
> >>> Can we extend netdev_get_xmit_slave() and figure out the output dev
> >>> (and if it's "stable") in a more generic way? And just feed that dev
> >>> into TLS handling?  
> >>
> >> I don't see we go through netdev_get_xmit_slave(), but through
> >> .ndo_start_xmit (bond_start_xmit).  
> > 
> > I may be misunderstanding the purpose of netdev_get_xmit_slave(),
> > please correct me if I'm wrong. AFAIU it's supposed to return a
> > lower netdev that the skb should then be xmited on.  
> 
> That's true. It was recently added and used by the RDMA team. Not used 
> or integrated in the Eth networking stack.
> 
> > So what I was thinking was either construct an skb or somehow reshuffle
> > the netdev_get_xmit_slave() code to take a flow dissector output or
> > ${insert other ideas}. Then add a helper in the core that would drill
> > down from the socket netdev to the "egress" netdev. Have TLS call
> > that helper, and talk to the "egress" netdev from the start, rather
> > than the socket's netdev. Then loosen the checks on software devices.  
> 
> As I understand it, best if we can even generalize this to apply to all 
> kinds of traffic: bond driver won't do the xmit itself anymore, it just 
> picks an egress dev and returns it. The core infrastructure will call 
> the xmit function for the egress dev.

I think you went way further than I was intending :) I was only
considering the control path. Leave the datapath unchanged.

AFAIK you're making 3 changes:
 - forwarding tls ops
 - pinning flows
 - handling features

Pinning of the TLS device to a leg of the bond looks like ~15LoC.
I think we can live with that.

It's the 150 LoC of forwarding TLS ops and duplicating dev selection
logic in bond_sk_hash_l34() that I'd rather avoid.

Handling features is probably fine, too, I haven't thought about that
much.

> I like the idea, it can generalize code structures for all kinds of 
> upper-devices and sockets, taking them into a common place in core, 
> which reduces code duplications.
> 
> If we go only half the way, i.e. keep xmit logic in bond for 
> non-TLS-offloaded traffic, then we have to let TLS module (and others in 
> the future) act deferentially for different kinds of devs (upper/lower) 
> which IMHO reduces generality.

How so? I was expecting TLS to just do something like:

	netdev = sk_get_xmit_dev_lowest(sk);

which would recursively call get_xmit_slave(CONST) until it reaches
a device which doesn't resolve further.

BTW is the flow pinning to bond legs actually a must-do? I don't know
much about bonding but wouldn't that mean that if the selected leg goes
down we'd lose connectivity, rather than falling back to SW crypto?

> I'm in favor of the deeper change. It will be on a larger scale, and 
> totally orthogonal to the current TLS offload support in bond.
> 
> If we decide to apply the idea only to TLS sockets (or any subset of 
> sockets) we're actually taking a generic one-flow (the xmit patch of a 
> bond dev) and turning it into two (or potentially more) flows, depending 
> on the socket type. This also reduces generality.

I don't follow this part.

> > I'm probably missing the problem you're trying to explain to me :S
> 
> I kept the patch minimal, and kept the TLS offload logic internal to the 
> bond driver, just like it is internal to the device drivers (mlx5e, and 
> others), with no core infrastructure modification.
> 
> > Side note - Jarod, I'd be happy to take a patch renaming
> > netdev_get_xmit_slave() and the ndo, if you have the cycles to send
> > a patch. It's a recent addition, and in the core we should make more
> > of an effort to avoid sensitive terms.
> >   
> >> Currently I have my check there to
> >> catch all skbs belonging to offloaded TLS sockets.
> >>
> >> The TLS offload get_slave() logic decision is per socket, so the result
> >> cannot be saved in the bond memory. Currently I save the real_dev field
> >> in the TLS context structure.  
> > 
> > Right, but we could just have ctx->netdev be the "egress" netdev
> > always, right? Do we expect somewhere that it's going to be matching
> > the socket's dst?
> 
> So once the offload context is established we totally bypass the bond 
> dev? and lose interaction or reference to it?

Yup, I don't think we need it.

> What if the egress dev is detached form the bond? We must then be 
> notified somehow.

Do we notify TLS when routing changes? I think it's a separate topic. 

If we have the code to "un-offload" a flow we could handle clearing
features better and notify from sk_validate_xmit_skb that the flow
started hitting unexpected dev, hence it should be re-offloaded.

I don't think we need an explicit invalidation from the particular
drivers here.
