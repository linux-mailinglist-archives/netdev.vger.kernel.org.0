Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB263A2782
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 10:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbhFJI6U convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 10 Jun 2021 04:58:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbhFJI6U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 04:58:20 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E6B9C061574
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 01:56:24 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1lrGTv-0007uR-Ab; Thu, 10 Jun 2021 10:56:07 +0200
Date:   Thu, 10 Jun 2021 10:56:07 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Toke =?iso-8859-15?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Patrick McHardy <kaber@trash.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Peter Krystad <peter.krystad@linux.intel.com>,
        Young Xiao <92siuyang@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net 1/3] netfilter: synproxy: Fix out of bounds when
 parsing TCP options
Message-ID: <20210610085607.GN20020@breakpoint.cc>
References: <20210609142212.3096691-1-maximmi@nvidia.com>
 <20210609142212.3096691-2-maximmi@nvidia.com>
 <20210609145115.GL20020@breakpoint.cc>
 <4ec99ea3-6ab1-eee4-be60-992cf2f9cd45@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <4ec99ea3-6ab1-eee4-be60-992cf2f9cd45@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
> On 2021-06-09 17:51, Florian Westphal wrote:
> > Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
> > > The TCP option parser in synproxy (synproxy_parse_options) could read
> > > one byte out of bounds. When the length is 1, the execution flow gets
> > > into the loop, reads one byte of the opcode, and if the opcode is
> > > neither TCPOPT_EOL nor TCPOPT_NOP, it reads one more byte, which exceeds
> > > the length of 1.
> > > 
> > > This fix is inspired by commit 9609dad263f8 ("ipv4: tcp_input: fix stack
> > > out of bounds when parsing TCP options.").
> > > 
> > > Cc: Young Xiao <92siuyang@gmail.com>
> > > Fixes: 48b1de4c110a ("netfilter: add SYNPROXY core/target")
> > > Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> > > ---
> > >   net/netfilter/nf_synproxy_core.c | 2 ++
> > >   1 file changed, 2 insertions(+)
> > > 
> > > diff --git a/net/netfilter/nf_synproxy_core.c b/net/netfilter/nf_synproxy_core.c
> > > index b100c04a0e43..621eb5ef9727 100644
> > > --- a/net/netfilter/nf_synproxy_core.c
> > > +++ b/net/netfilter/nf_synproxy_core.c
> > > @@ -47,6 +47,8 @@ synproxy_parse_options(const struct sk_buff *skb, unsigned int doff,
> > >   			length--;
> > >   			continue;
> > >   		default:
> > > +			if (length < 2)
> > > +				return true;
> > 
> > Would you mind a v2 that also rejects bogus th->doff value when
> > computing the length?
> 
> Could you elaborate? The length is a signed int calculated as `(th->doff *
> 4) - sizeof(*th)`. Invalid doff values (0..4) lead to negative length, so we
> never enter the loop. Or are you concerned of passing a negative length to
> skb_header_pointer?

Yes, negative length to skb_header_pointer.  For other usage (mptcp for
example) tcp stack validated th->doff already, but thats not the case for synproxy.
