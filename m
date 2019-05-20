Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE50123271
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 13:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732879AbfETLbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 07:31:21 -0400
Received: from torres.zugschlus.de ([85.214.131.164]:44980 "EHLO
        torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731119AbfETLbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 07:31:21 -0400
Received: from mh by torres.zugschlus.de with local (Exim 4.92)
        (envelope-from <mh+netdev@zugschlus.de>)
        id 1hSgVj-0002sD-PI; Mon, 20 May 2019 13:31:19 +0200
Date:   Mon, 20 May 2019 13:31:19 +0200
From:   Marc Haber <mh+netdev@zugschlus.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Kernel 5.1 breaks UDP checksums for SIP packets
Message-ID: <20190520113119.GB6502@torres.zugschlus.de>
References: <20190520094955.GA6502@torres.zugschlus.de>
 <20190520102802.vv3xyd2p7ei4j65r@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190520102802.vv3xyd2p7ei4j65r@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 20, 2019 at 12:28:02PM +0200, Florian Westphal wrote:
> Marc Haber <mh+netdev@zugschlus.de> wrote:
> > when I update my Firewall from Kernel 5.0 to Kernel 5.1, SIP clients
> > that connect from the internal network to an external, commercial SIP
> > service do not work any more. When I trace beyond the NAT, I see that
> > the outgoing SIP packets have incorrect UDP checksums:
> 
> I'm a moron.  Can you please try this patch?
> 
> diff --git a/net/netfilter/nf_nat_helper.c b/net/netfilter/nf_nat_helper.c
> --- a/net/netfilter/nf_nat_helper.c
> +++ b/net/netfilter/nf_nat_helper.c
> @@ -170,7 +170,7 @@ nf_nat_mangle_udp_packet(struct sk_buff *skb,
>  	if (!udph->check && skb->ip_summed != CHECKSUM_PARTIAL)
>  		return true;
>  
> -	nf_nat_csum_recalc(skb, nf_ct_l3num(ct), IPPROTO_TCP,
> +	nf_nat_csum_recalc(skb, nf_ct_l3num(ct), IPPROTO_UDP,
>  			   udph, &udph->check, datalen, oldlen);
>  
>  	return true;

Thanks for the lightning fast reaction. The patch indeed fixes the issue
for me, everything is online now, incoming and outgoing calls are
possible. Can you funnel that one to Greg please for the next stable
release?

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
