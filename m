Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B540525E59A
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 07:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbgIEFYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 01:24:06 -0400
Received: from bmailout1.hostsharing.net ([83.223.95.100]:32783 "EHLO
        bmailout1.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbgIEFYG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Sep 2020 01:24:06 -0400
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by bmailout1.hostsharing.net (Postfix) with ESMTPS id DA25F30006A1E;
        Sat,  5 Sep 2020 07:24:03 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id B07D61175FD; Sat,  5 Sep 2020 07:24:03 +0200 (CEST)
Date:   Sat, 5 Sep 2020 07:24:03 +0200
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
Message-ID: <20200905052403.GA10306@wunner.de>
References: <20200904162154.GA24295@wunner.de>
 <813edf35-6fcf-c569-aab7-4da654546d9d@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <813edf35-6fcf-c569-aab7-4da654546d9d@iogearbox.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 04, 2020 at 11:14:37PM +0200, Daniel Borkmann wrote:
> On 9/4/20 6:21 PM, Lukas Wunner wrote:
> > nft and tc are orthogonal, i.e. filtering/mangling versus queueing.
> > However tc has gained the ability to filter packets as well, hence
> > there's some overlap in functionality.  Naturally tc does not allow
> > the full glory of nft filtering/mangling options as Laura has stated,
> > hence the need to add nft in the egress path.
> 
> Heh, really!? It sounds to me that you never looked serious enough into what
> tc/BPF is actually doing.

It wasn't my intention to denigrate or belittle tc's capabilities
with the above statement.

I don't dispute that the original use case for which these patches
were developed might be solved equally well with tc.  As I've stated
before, I chose netfilter over tc because I needed an in-kernel API,
which netfilter provides with nf_register_net_hook():

https://lore.kernel.org/netdev/20191123142305.g2kkaudhhyui22fq@wunner.de/

The motivation for these patches has pivoted away from my original
use case, which is why I no longer mentioned it in the commit message.


> The tc queueing layer which is below is not the tc egress hook; the
> latter is for filtering/mangling/forwarding or helping the lower tc
> queueing layer to classify.

People want to apply netfilter rules on egress, so either we need an
egress hook in the xmit path or we'd have to teach tc to filter and
mangle based on netfilter rules.  The former seemed more straight-forward
to me but I'm happy to pursue other directions.


> Why paying the performance hit going into the nft interpreter for this
> hook for *every* other *unrelated* packet in the fast-path...

As long as neither tc nor nft is used, *no* packet goes through the
nft interpreter and I'm measuring a speedup as a result of moving
the two out of the hotpath.

If nft is used, only those interfaces for which netfilter rules have
been hooked up go through the nft interpreter.


> the case is rather if distros start adding DHCP
> filtering rules by default there as per your main motivation then
> everyone needs to pay this price, which is completely unreasonable
> to perform in __dev_queue_xmit().

So first you're saying that the patches are unnecessary and everything
they do can be achieved with tc... and then you're saying distros are
going to use the nft hook to filter DHCP by default, which will cost
performance.  That seems contradictory.  Why aren't distros using tc
today to filter DHCP?

Thanks,

Lukas
