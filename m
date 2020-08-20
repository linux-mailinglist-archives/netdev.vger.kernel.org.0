Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13DD524B68A
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 12:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731125AbgHTKhR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 06:37:17 -0400
Received: from bmailout1.hostsharing.net ([83.223.95.100]:40831 "EHLO
        bmailout1.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731068AbgHTKhJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 06:37:09 -0400
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by bmailout1.hostsharing.net (Postfix) with ESMTPS id AD69730000CD0;
        Thu, 20 Aug 2020 12:37:01 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 694A2132D76; Thu, 20 Aug 2020 12:37:01 +0200 (CEST)
Date:   Thu, 20 Aug 2020 12:37:01 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Laura Garcia <nevola@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>, coreteam@netfilter.org,
        netdev@vger.kernel.org, Martin Mares <mj@ucw.cz>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Thomas Graf <tgraf@suug.ch>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH nf-next 3/3] netfilter: Introduce egress hook
Message-ID: <20200820103701.on5rqxawqqc7kwdw@wunner.de>
References: <cover.1583927267.git.lukas@wunner.de>
 <14ab7e5af20124a34a50426fd570da7d3b0369ce.1583927267.git.lukas@wunner.de>
 <a57687ae-2da6-ca2a-1c84-e4332a5e4556@iogearbox.net>
 <20200313145526.ikovaalfuy7rnkdl@salvia>
 <1bd50836-33c4-da44-5771-654bfb0348cc@iogearbox.net>
 <20200315132836.cj36ape6rpw33iqb@salvia>
 <CAF90-WgoteQXB9WQmeT1eOHA3GpPbwPCEvNzwKkN20WqpdHW-A@mail.gmail.com>
 <20200423160542.d3f6yef4av2gqvur@wunner.de>
 <1a27351b-78a8-febc-45d7-6ee2e8ebda9e@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a27351b-78a8-febc-45d7-6ee2e8ebda9e@iogearbox.net>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 28, 2020 at 10:11:19PM +0200, Daniel Borkmann wrote:
> > https://lore.kernel.org/netdev/bbdee6355234e730ef686f9321bd072bcf4bb232.1584523237.git.daniel@iogearbox.net/
> > 
> > In the ensuing discussion it turned out that the performance argument
> > may be addressed by a rearrangement of sch_handle_egress() and
> > nf_egress() invocations.  I could look into amending the series
> > accordingly and resubmitting, though I'm currently swamped with
> > other work.
> 
> The rework of these hooks is still on my todo list, too swamped with
> other stuff as well right now, but I'll see to have a prototype this
> net-next development cycle.

Daniel, I have it running now the way you want it (I think) and am
benchmarking several variants.  I'm now faced with the following
choice:

* One variant speeds up the default case with neither tc nor nft in use
  (2241 -> 2285 Mb/sec), but tc becomes a little slower (1929 -> 1927
  Mb/sec).

* Another variant still speeds up the default case but not by as much
  (2241 -> 2274 Mb/sec) and speeds up tc as well (1929 -> 1931 Mb/sec).

The difference is that the first variant uses an outer static_key which
patches in a function containing two inner static_keys for nft + tc.
The second variant uses an outer static_key and a single inner static_key
for nft (but no static_key for tc).

nft is slower in the second variant (2231 -> 2225 Mb/sec).

I'm leaning towards the first variant, but because it incurs a small
performance degradation if tc is used, I wanted to give you a heads-up.
If this is totally unacceptable for you, I'll post the second variant
instead.

I need a few more days to update the commit messages, perform further
testing and apply polish, so I plan to dump the patches to the list
next week.  Just thought I'd ask for your opinion, I'm aware this is
difficult to judge without seeing the code.

I'm using static_keys instead of fmodify_return (which you've suggested)
because I would like to avoid a dependency on BPF as it might not be an
option for space-constrained embedded machines and a BPF JIT isn't
available on as many arches as CONFIG_JUMP_LABEL.

Thanks,

Lukas
