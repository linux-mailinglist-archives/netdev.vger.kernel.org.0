Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9020528A636
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 09:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729066AbgJKH7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 03:59:12 -0400
Received: from bmailout1.hostsharing.net ([83.223.95.100]:35101 "EHLO
        bmailout1.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbgJKH7M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 03:59:12 -0400
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by bmailout1.hostsharing.net (Postfix) with ESMTPS id C8ACF30000CEB;
        Sun, 11 Oct 2020 09:59:05 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id AF33988EAF; Sun, 11 Oct 2020 09:59:05 +0200 (CEST)
Date:   Sun, 11 Oct 2020 09:59:05 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>, Laura Garcia <nevola@gmail.com>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH nf-next v3 3/3] netfilter: Introduce egress hook
Message-ID: <20201011075905.GA15225@wunner.de>
References: <20200904162154.GA24295@wunner.de>
 <813edf35-6fcf-c569-aab7-4da654546d9d@iogearbox.net>
 <20200905052403.GA10306@wunner.de>
 <e8aecc2b-80cb-8ee5-8efe-7ae5c4eafc70@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8aecc2b-80cb-8ee5-8efe-7ae5c4eafc70@iogearbox.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 08, 2020 at 02:55:36PM +0200, Daniel Borkmann wrote:
> I would strongly prefer something where nf integrates into existing
> tc hook, not only due to the hook reuse which would be better,
> but also to allow for a more flexible interaction between tc/BPF
> use cases
[...]
> one option to move forward [...] overall rework of ingress/egress
> side to be a more flexible pipeline (think of cont/ok actions
> as with tc filters or stackable LSMs to process & delegate).

Interaction between netfilter and tc is facilitated by skb->mark.
Both netfilter and tc are able to set and match by way of the mark.
E.g. a netfilter hook may set the mark and tc may later perform an
action if a matching mark is found.

Because the placement of netfilter and tc hooks in the data path
has been unchanged for decades, we must assume that users depend
on their order for setting and matching the mark.

Thus, reworking the data path in the way you suggest (a flexible
pipeline) must not change the order of the hooks.  It would have
to be a fixed pipeline.  But what's the benefit then compared to
separate netfilter and tc hooks which are patched in at runtime
and become NOPs if not used?  (Which is what the present series is
aiming for.)


> to name one example... consider two different entities in the system
> setting up the two, that is, one adding rules for nf ingress/egress
> on the phys device for host fw and the other one for routing traffic
> into/from containers at the tc layer, then traffic going into host ns
> will hit nf ingress and on egress side the nf egress part; however,
> traffic going to containers via existing tc redirect will not see the
> nf ingress as expected but would on reverse path incorrectly
> hit the nf egress one which is /not/ the case for dev_queue_xmit() today.

Using tc to bounce ingress traffic into a container -- is that actually
a thing or is it a hypothetical example?  I think at least Docker uses
plain vanilla routing and bridging to move packets in and out of
containers.

However you're right that if tc *is* used to redirect ingress packets
to a container veth, then the data path would look like:

host tc -> container tc -> container nft

Whereas the egress data path would look like:

container nft -> container tc -> host nft -> host tc

But I argue that the egress data path is actually correct because the
host must be able to firewall packets coming out of the container
in case the container has been compromised.


> And if you check a typical DHCP client that is present on major
> modern distros like systemd-networkd's DHCP client then they
> already implement filtering of malicious packets via BPF at
> socket layer including checking for cookies in the DHCP header
> that are set by the application itself to prevent spoofing [0].
> 
> [0] https://github.com/systemd/systemd/blob/master/src/libsystemd-network/dhcp-network.c#L28

That's an *ingress* filter so that user space only receives DHCP
packets and nothing else.

We're talking about the ability to filter *egress* DHCP packets
(among others) at the kernel level to guard against unwanted
packets coming from user space.

Thanks,

Lukas
