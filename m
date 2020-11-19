Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD6B2B9835
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 17:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729087AbgKSQiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 11:38:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:50338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727768AbgKSQiN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 11:38:13 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51C3322202;
        Thu, 19 Nov 2020 16:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605803892;
        bh=tEexf9zYiZGdd5+0cCky5BEDP+RH2TsHc9frvXf4Fng=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qu3VtP4ORfz+9VwkZWf8KJCCvgVmNxOic8/wyyXX0tITt8LsnCD3GvGwvvWNjsSa0
         Y484BiSVrMf83qmJA+TlAZK7WIT+uGsUpjg4QO6Ikdn2eIsXsM7F2FQMoi0dCjue6Y
         RSgfK3ctdsM+rtHqIXouSCoG72Zdn1Bu8zWaCQB0=
Date:   Thu, 19 Nov 2020 08:38:11 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tariq Toukan <ttoukan.linux@gmail.com>,
        Jarod Wilson <jarod@redhat.com>
Cc:     Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: Re: [PATCH net-next 0/2] TLS TX HW offload for Bond
Message-ID: <20201119083811.6b68bfa8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <0e4a04f2-2ffa-179d-3b7b-ef08b52c9290@gmail.com>
References: <20201115134251.4272-1-tariqt@nvidia.com>
        <20201118160239.78871842@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <0e4a04f2-2ffa-179d-3b7b-ef08b52c9290@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Nov 2020 17:59:38 +0200 Tariq Toukan wrote:
> On 11/19/2020 2:02 AM, Jakub Kicinski wrote:
> > On Sun, 15 Nov 2020 15:42:49 +0200 Tariq Toukan wrote:  
> >> This series opens TLS TX HW offload for bond interfaces.
> >> This allows bond interfaces to benefit from capable slave devices.
> >>
> >> The first patch adds real_dev field in TLS context structure, and aligns
> >> usages in TLS module and supporting drivers.
> >> The second patch opens the offload for bond interfaces.
> >>
> >> For the configuration above, SW kTLS keeps picking the same slave
> >> To keep simple track of the HW and SW TLS contexts, we bind each socket to
> >> a specific slave for the socket's whole lifetime. This is logically valid
> >> (and similar to the SW kTLS behavior) in the following bond configuration,
> >> so we restrict the offload support to it:
> >>
> >> ((mode == balance-xor) or (mode == 802.3ad))
> >> and xmit_hash_policy == layer3+4.  
> > 
> > This does not feel extremely clean, maybe you can convince me otherwise.
> > 
> > Can we extend netdev_get_xmit_slave() and figure out the output dev
> > (and if it's "stable") in a more generic way? And just feed that dev
> > into TLS handling?   
> 
> I don't see we go through netdev_get_xmit_slave(), but through 
> .ndo_start_xmit (bond_start_xmit).

I may be misunderstanding the purpose of netdev_get_xmit_slave(),
please correct me if I'm wrong. AFAIU it's supposed to return a
lower netdev that the skb should then be xmited on.

So what I was thinking was either construct an skb or somehow reshuffle
the netdev_get_xmit_slave() code to take a flow dissector output or
${insert other ideas}. Then add a helper in the core that would drill
down from the socket netdev to the "egress" netdev. Have TLS call
that helper, and talk to the "egress" netdev from the start, rather
than the socket's netdev. Then loosen the checks on software devices.

I'm probably missing the problem you're trying to explain to me :S

Side note - Jarod, I'd be happy to take a patch renaming
netdev_get_xmit_slave() and the ndo, if you have the cycles to send 
a patch. It's a recent addition, and in the core we should make more 
of an effort to avoid sensitive terms.

> Currently I have my check there to 
> catch all skbs belonging to offloaded TLS sockets.
> 
> The TLS offload get_slave() logic decision is per socket, so the result 
> cannot be saved in the bond memory. Currently I save the real_dev field 
> in the TLS context structure.

Right, but we could just have ctx->netdev be the "egress" netdev
always, right? Do we expect somewhere that it's going to be matching
the socket's dst?

> One way to make it more generic is to save it on the sock structure. I 
> agree that this replaces the TLS-specific logic, but demands increasing 
> the sock struct, and has larger impact on all other flows...

