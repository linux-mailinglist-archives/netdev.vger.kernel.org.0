Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A53B0D5802
	for <lists+netdev@lfdr.de>; Sun, 13 Oct 2019 22:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728329AbfJMURR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Oct 2019 16:17:17 -0400
Received: from shells.gnugeneration.com ([66.240.222.126]:41972 "EHLO
        shells.gnugeneration.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726264AbfJMURR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Oct 2019 16:17:17 -0400
Received: by shells.gnugeneration.com (Postfix, from userid 1000)
        id 0660D1A40559; Sun, 13 Oct 2019 13:17:16 -0700 (PDT)
Date:   Sun, 13 Oct 2019 13:17:16 -0700
From:   Vito Caputo <vcaputo@pengaru.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH] net: core: skbuff: skb_checksum_setup() drop err
Message-ID: <20191013201716.dwxfbr5kbueexomw@shells.gnugeneration.com>
References: <20191013003053.tmdc3hs73ik3asxq@shells.gnugeneration.com>
 <52dfe9f3-cc54-408d-6781-3bc0a86ebae8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52dfe9f3-cc54-408d-6781-3bc0a86ebae8@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 13, 2019 at 12:58:04PM -0700, Eric Dumazet wrote:
> 
> 
> On 10/12/19 5:30 PM, Vito Caputo wrote:
> > Return directly from all switch cases, no point in storing in err.
> > 
> > Signed-off-by: Vito Caputo <vcaputo@pengaru.com>
> > ---
> >  net/core/skbuff.c | 15 +++------------
> >  1 file changed, 3 insertions(+), 12 deletions(-)
> > 
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index f5f904f46893..c59b68a413b5 100644
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -4888,23 +4888,14 @@ static int skb_checksum_setup_ipv6(struct sk_buff *skb, bool recalculate)
> >   */
> >  int skb_checksum_setup(struct sk_buff *skb, bool recalculate)
> >  {
> > -	int err;
> > -
> >  	switch (skb->protocol) {
> >  	case htons(ETH_P_IP):
> > -		err = skb_checksum_setup_ipv4(skb, recalculate);
> > -		break;
> > -
> > +		return skb_checksum_setup_ipv4(skb, recalculate);
> >  	case htons(ETH_P_IPV6):
> > -		err = skb_checksum_setup_ipv6(skb, recalculate);
> > -		break;
> > -
> > +		return skb_checksum_setup_ipv6(skb, recalculate);
> >  	default:
> > -		err = -EPROTO;
> > -		break;
> > +		return -EPROTO;
> >  	}
> > -
> > -	return err;
> >  }
> >  EXPORT_SYMBOL(skb_checksum_setup);
> 
> 
> We prefer having a single return point in a function, if possible.
> 
> The err variable would make easier for debugging support,
> if say a developer needs to trace this function.
> 

Except there are examples under net/core of precisely this pattern, e.g.:

---

__be32 flow_get_u32_src(const struct flow_keys *flow)
{
        switch (flow->control.addr_type) {
        case FLOW_DISSECTOR_KEY_IPV4_ADDRS:
                return flow->addrs.v4addrs.src;
        case FLOW_DISSECTOR_KEY_IPV6_ADDRS:
                return (__force __be32)ipv6_addr_hash(
                        &flow->addrs.v6addrs.src);
        case FLOW_DISSECTOR_KEY_TIPC:
                return flow->addrs.tipckey.key;
        default:
                return 0;
        }
}
EXPORT_SYMBOL(flow_get_u32_src);

__be32 flow_get_u32_dst(const struct flow_keys *flow)
{
        switch (flow->control.addr_type) {
        case FLOW_DISSECTOR_KEY_IPV4_ADDRS:
                return flow->addrs.v4addrs.dst;
        case FLOW_DISSECTOR_KEY_IPV6_ADDRS:
                return (__force __be32)ipv6_addr_hash(
                        &flow->addrs.v6addrs.dst);
        default:
                return 0;
        }
}
EXPORT_SYMBOL(flow_get_u32_dst);

---

This compact form of mapping is found throughout the kernel, is
skb_checksum_setup() special?

Regards,
Vito Caputo
