Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3956C25DFB3
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 18:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgIDQV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 12:21:58 -0400
Received: from bmailout2.hostsharing.net ([83.223.78.240]:42247 "EHLO
        bmailout2.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726184AbgIDQV6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 12:21:58 -0400
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by bmailout2.hostsharing.net (Postfix) with ESMTPS id EE97F28034C24;
        Fri,  4 Sep 2020 18:21:54 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id BC126413C8; Fri,  4 Sep 2020 18:21:54 +0200 (CEST)
Date:   Fri, 4 Sep 2020 18:21:54 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>, Laura Garcia <nevola@gmail.com>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH nf-next v3 3/3] netfilter: Introduce egress hook
Message-ID: <20200904162154.GA24295@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f5261535a32a_1932208c8@john-XPS-13-9370.notmuch>
 <5f5078705304_9154c2084c@john-XPS-13-9370.notmuch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 02, 2020 at 10:00:32PM -0700, John Fastabend wrote:
> Lukas Wunner wrote:
> > * Before:       4730418pps 2270Mb/sec (2270600640bps)
> > * After:        4759206pps 2284Mb/sec (2284418880bps)
> 
> I used a 10Gbps ixgbe nic to measure the performance after the dummy
> device hung on me for some reason. I'll try to investigate what happened
> later. It was unrelated to these patches though.
> 
> But, with 10Gbps NIC and doing a pktgen benchmark with and without
> the patches applied I didn't see any measurable differences. Both
> cases reached 14Mpps.

Hm, I strongly suspect you may have measured performance of the NIC and
that you'd get different before/after numbers with the dummy device.


> > * Before + tc:  4063912pps 1950Mb/sec (1950677760bps)
> > * After  + tc:  4007728pps 1923Mb/sec (1923709440bps)
> 
> Same here before/after aggregate appears to be the same. Even the
> numbers above show a 1.2% degradation. Just curious is the above
> from a single run or averaged over multiple runs or something
> else? Seems like noise to me.

I performed at least 3 runs, but included just a single number in
the commit message for brevity.  That number is intended to show
where the numbers settled:

Before:           2257 2270 2270           Mb/sec
After:            2282 2283 2284 2282      Mb/sec

Before + tc:      1941 1950 1951           Mb/sec
After  + tc:      1923 1923 1919 1920 1919 Mb/sec

After + nft:      1782 1783 1782 1781      Mb/sec
After + nft + tc: 1574 1566 1566           Mb/sec

So there's certainly some noise but still a speedup is clearly
visible if neither tc nor nft is used, and a slight degradation
if tc is used.


> I did see something odd where it appeared fairness between threads
> was slightly worse. I don't have any explanation for this? Did
> you have a chance to run the test with -t >1?

Sorry, no, I only tested with a single thread on an otherwise idle
machine.


> Do you have plans to address the performance degradation? Otherwise
> if I was building some new components its unclear why we would
> choose the slower option over the tc hook. The two suggested
> use cases security policy and DSR sound like new features, any
> reason to not just use existing infrastructure?
> 
> Is the use case primarily legacy things already running in
> nft infrastructure? I guess if you have code running now
> moving it to this hook is faster and even if its 10% slower
> than it could be that may be better than a rewrite?

nft and tc are orthogonal, i.e. filtering/mangling versus queueing.
However tc has gained the ability to filter packets as well, hence
there's some overlap in functionality.  Naturally tc does not allow
the full glory of nft filtering/mangling options as Laura has stated,
hence the need to add nft in the egress path.


> huh? Its stated in the commit message with no reason for why it might
> be the case and I can't reproduce it.

The reason as stated in the commit message is that cache pressure is
apparently reduced with the tc handling moved out of the hotpath,
an effect that Eric Dumazet had previously observed for the ingress path:

https://lore.kernel.org/netdev/1431387038.566.47.camel@edumazet-glaptop2.roam.corp.google.com/

Thanks a lot for taking the time to give these patches a whirl.

Lukas
