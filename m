Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07CE52EE82D
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 23:15:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727767AbhAGWOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 17:14:48 -0500
Received: from correo.us.es ([193.147.175.20]:54218 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727265AbhAGWOs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 17:14:48 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9D966E8E8B
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 23:13:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 900ADDA78F
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 23:13:26 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 85904DA78B; Thu,  7 Jan 2021 23:13:26 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 327A4DA730;
        Thu,  7 Jan 2021 23:13:24 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 07 Jan 2021 23:13:24 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 1206A426CC84;
        Thu,  7 Jan 2021 23:13:24 +0100 (CET)
Date:   Thu, 7 Jan 2021 23:14:03 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, christian.perle@secunet.com,
        steffen.klassert@secunet.com, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net 0/3] net: fix netfilter defrag/ip tunnel pmtu
 blackhole
Message-ID: <20210107221403.GA15712@salvia>
References: <20210105121208.GA11593@cell>
 <20210105231523.622-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210105231523.622-1-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 06, 2021 at 12:15:20AM +0100, Florian Westphal wrote:
> Christian Perle reported a PMTU blackhole due to unexpected interaction
> between the ip defragmentation that comes with connection tracking and
> ip tunnels.
> 
> Unfortunately setting 'nopmtudisc' on the tunnel breaks the test
> scenario even without netfilter.
> 
> Christinas setup looks like this:
>      +--------+       +---------+       +--------+
>      |Router A|-------|Wanrouter|-------|Router B|
>      |        |.IPIP..|         |..IPIP.|        |
>      +--------+       +---------+       +--------+
>           /             mtu 1400           \
>          /                                  \
>  +--------+                                  +--------+
>  |Client A|                                  |Client B|
>  +--------+                                  +--------+
> 
> MTU is 1500 everywhere, except on Router A to Wanrouter and
> Wanrouter to Router B.
> 
> Router A and Router B use IPIP tunnel interfaces to tunnel traffic
> between Client A and Client B over WAN.
> 
> Client A sends a 1400 byte UDP datagram to Client B.
> This packet gets encapsulated in the IPIP tunnel.
> 
> This works, packet is received on client B.
> 
> When conntrack (or anything else that forces ip defragmentation) is
> enabled on Router A, the packet gets dropped on Router A after
> encapsulation because they exceed the link MTU.
> 
> Setting the 'nopmtudisc' flag on the IPIP tunnel makes things worse,
> no packets pass even in the no-netfilter scenario.
> 
> Patch one is a reproducer script for selftest infra.
> 
> Patch two is a fix for 'nopmtudisc' behaviour so ip_tunnel will send
> an icmp error to Client A.  This allows 'nopmtudisc' tunnel to forward
> the UDP datagrams.
> 
> Patch three enables ip refragmentation for all reassembled packets, just
> like ipv6.

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks.
