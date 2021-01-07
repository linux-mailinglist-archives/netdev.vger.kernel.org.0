Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFF372EE91F
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 23:48:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729249AbhAGWpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 17:45:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:45758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729197AbhAGWpy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 17:45:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08873235FA;
        Thu,  7 Jan 2021 22:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610059513;
        bh=sui130tB6tVURev7G+B6CFzZaNiRnUeeeLg1sOcbXHw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jS3dv0b3F5+n46l0NLXwao1KSlBnxgsj8mGrbsX3RCU200BNsaUs+ZJm08O+tmhVZ
         InV6PQ4sptQBzSnnjM1XHS7EZAvlZT/YXwVnehz1tpz1U0/+aM6e5X0Xffq2Kw5MXX
         QUWJ+1o81Kmb/QCTJAdgQrZfKUHoRFgiWWJSnhO1PIYqwtQjSdOq7jltJxcxtntrX8
         DKRS2ejF5RLOWHrkA7eJDXSGSjNAX4vNSGnr22FxCD2AE6xMZUjloMY7R/BsJAvr/k
         iCc5WZNfDT2+Sn/fvbQf7uPYFTOX3ADBy2InqU/a0eL56VtYcj2wFYhUiU66wtqxFJ
         4qCa/0NcftIhA==
Date:   Thu, 7 Jan 2021 14:45:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, christian.perle@secunet.com,
        steffen.klassert@secunet.com, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net 0/3] net: fix netfilter defrag/ip tunnel pmtu
 blackhole
Message-ID: <20210107144512.2021bd35@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210107221403.GA15712@salvia>
References: <20210105121208.GA11593@cell>
        <20210105231523.622-1-fw@strlen.de>
        <20210107221403.GA15712@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 Jan 2021 23:14:03 +0100 Pablo Neira Ayuso wrote:
> On Wed, Jan 06, 2021 at 12:15:20AM +0100, Florian Westphal wrote:
> > Christian Perle reported a PMTU blackhole due to unexpected interaction
> > between the ip defragmentation that comes with connection tracking and
> > ip tunnels.
> > 
> > Unfortunately setting 'nopmtudisc' on the tunnel breaks the test
> > scenario even without netfilter.
> > 
> > Christinas setup looks like this:
> >      +--------+       +---------+       +--------+
> >      |Router A|-------|Wanrouter|-------|Router B|
> >      |        |.IPIP..|         |..IPIP.|        |
> >      +--------+       +---------+       +--------+
> >           /             mtu 1400           \
> >          /                                  \
> >  +--------+                                  +--------+
> >  |Client A|                                  |Client B|
> >  +--------+                                  +--------+
> > 
> > MTU is 1500 everywhere, except on Router A to Wanrouter and
> > Wanrouter to Router B.
> > 
> > Router A and Router B use IPIP tunnel interfaces to tunnel traffic
> > between Client A and Client B over WAN.
> > 
> > Client A sends a 1400 byte UDP datagram to Client B.
> > This packet gets encapsulated in the IPIP tunnel.
> > 
> > This works, packet is received on client B.
> > 
> > When conntrack (or anything else that forces ip defragmentation) is
> > enabled on Router A, the packet gets dropped on Router A after
> > encapsulation because they exceed the link MTU.
> > 
> > Setting the 'nopmtudisc' flag on the IPIP tunnel makes things worse,
> > no packets pass even in the no-netfilter scenario.
> > 
> > Patch one is a reproducer script for selftest infra.
> > 
> > Patch two is a fix for 'nopmtudisc' behaviour so ip_tunnel will send
> > an icmp error to Client A.  This allows 'nopmtudisc' tunnel to forward
> > the UDP datagrams.
> > 
> > Patch three enables ip refragmentation for all reassembled packets, just
> > like ipv6.  
> 
> Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Applied, thanks!
