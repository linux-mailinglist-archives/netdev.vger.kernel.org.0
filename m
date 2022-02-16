Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30A174B8C68
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 16:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233983AbiBPP3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 10:29:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233781AbiBPP3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 10:29:00 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C00C19DE8D;
        Wed, 16 Feb 2022 07:28:47 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nKMEU-0006RC-5Z; Wed, 16 Feb 2022 16:28:42 +0100
Date:   Wed, 16 Feb 2022 16:28:42 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Gal Pressman <gal@nvidia.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, kevmitch@arista.com
Subject: Re: [PATCH net-next 01/14] netfilter: conntrack: mark UDP zero
 checksum as CHECKSUM_UNNECESSARY
Message-ID: <20220216152842.GA20500@breakpoint.cc>
References: <20220209133616.165104-1-pablo@netfilter.org>
 <20220209133616.165104-2-pablo@netfilter.org>
 <7eed8111-42d7-63e1-d289-346a596fc933@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7eed8111-42d7-63e1-d289-346a596fc933@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Gal Pressman <gal@nvidia.com> wrote:

[ CC patch author ]

> > The udp_error function verifies the checksum of incoming UDP packets if
> > one is set. This has the desirable side effect of setting skb->ip_summed
> > to CHECKSUM_COMPLETE, signalling that this verification need not be
> > repeated further up the stack.
> >
> > Conversely, when the UDP checksum is empty, which is perfectly legal (at least
> > inside IPv4), udp_error previously left no trace that the checksum had been
> > deemed acceptable.
> >
> > This was a problem in particular for nf_reject_ipv4, which verifies the
> > checksum in nf_send_unreach() before sending ICMP_DEST_UNREACH. It makes
> > no accommodation for zero UDP checksums unless they are already marked
> > as CHECKSUM_UNNECESSARY.
> >
> > This commit ensures packets with empty UDP checksum are marked as
> > CHECKSUM_UNNECESSARY, which is explicitly recommended in skbuff.h.
> >
> > Signed-off-by: Kevin Mitchell <kevmitch@arista.com>
> > Acked-by: Florian Westphal <fw@strlen.de>
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> >  net/netfilter/nf_conntrack_proto_udp.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
> > index 3b516cffc779..12f793d8fe0c 100644
> > --- a/net/netfilter/nf_conntrack_proto_udp.c
> > +++ b/net/netfilter/nf_conntrack_proto_udp.c
> > @@ -63,8 +63,10 @@ static bool udp_error(struct sk_buff *skb,
> >  	}
> >  
> >  	/* Packet with no checksum */
> > -	if (!hdr->check)
> > +	if (!hdr->check) {
> > +		skb->ip_summed = CHECKSUM_UNNECESSARY;
> >  		return false;
> > +	}
> >  
> >  	/* Checksum invalid? Ignore.
> >  	 * We skip checking packets on the outgoing path
> 
> Hey,
> 
> I think this patch broke geneve tunnels, or possibly all udp tunnels?
> 
> A simple test that creates two geneve tunnels and runs tcp iperf fails
> and results in checksum errors (TcpInCsumErrors).
> 
> Any idea how to solve that? Maybe 'skb->csum_level' needs some adjustments?

Probably better to revert and patch nf_reject instead to
handle 0 udp csum?
