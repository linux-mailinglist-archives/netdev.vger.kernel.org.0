Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30C2AA7152
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 19:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730090AbfICRF7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 13:05:59 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:42914 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727107AbfICRF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 13:05:58 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1i5CFa-0003c1-IC; Tue, 03 Sep 2019 19:05:50 +0200
Date:   Tue, 3 Sep 2019 19:05:50 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Leonardo Bras <leonardo@linux.ibm.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, FlorianWestphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v4 1/2] netfilter: Terminate rule eval if protocol=IPv6
 and ipv6 module is disabled
Message-ID: <20190903170550.GA13660@breakpoint.cc>
References: <20190830181354.26279-1-leonardo@linux.ibm.com>
 <20190830181354.26279-2-leonardo@linux.ibm.com>
 <20190830205802.GS20113@breakpoint.cc>
 <99e3ef9c5ead1c95df697d49ab9cc83a95b0ac7c.camel@linux.ibm.com>
 <20190903164948.kuvtpy7viqhcmp77@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190903164948.kuvtpy7viqhcmp77@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Sep 03, 2019 at 01:46:50PM -0300, Leonardo Bras wrote:
> > On Fri, 2019-08-30 at 22:58 +0200, Florian Westphal wrote:
> > > Leonardo Bras <leonardo@linux.ibm.com> wrote:
> > > > If IPv6 is disabled on boot (ipv6.disable=1), but nft_fib_inet ends up
> > > > dealing with a IPv6 packet, it causes a kernel panic in
> > > > fib6_node_lookup_1(), crashing in bad_page_fault.
> > > > 
> > > > The panic is caused by trying to deference a very low address (0x38
> > > > in ppc64le), due to ipv6.fib6_main_tbl = NULL.
> > > > BUG: Kernel NULL pointer dereference at 0x00000038
> > > > 
> > > > The kernel panic was reproduced in a host that disabled IPv6 on boot and
> > > > have to process guest packets (coming from a bridge) using it's ip6tables.
> > > > 
> > > > Terminate rule evaluation when packet protocol is IPv6 but the ipv6 module
> > > > is not loaded.
> > > > 
> > > > Signed-off-by: Leonardo Bras <leonardo@linux.ibm.com>
> > > 
> > > Acked-by: Florian Westphal <fw@strlen.de>
> > > 
> > 
> > Hello Pablo,
> > 
> > Any trouble with this patch? 
> > I could see the other* one got applied, but not this one.
> > *(The other did not get acked, so i released it alone as v5)
> > 
> > Is there any fix I need to do in this one?
> 
> Hm, I see, so this one:
> 
> https://patchwork.ozlabs.org/patch/1156100/
> 
> is not enough?

No, its not.

> I was expecting we could find a way to handle this from br_netfilter
> alone itself.

We can't because we support ipv6 fib lookups from the netdev family
as well.

Alternative is to auto-accept ipv6 packets from the nf_tables eval loop,
but I think its worse.
