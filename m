Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24971178DCF
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 10:50:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729093AbgCDJuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 04:50:35 -0500
Received: from bmailout2.hostsharing.net ([83.223.78.240]:51801 "EHLO
        bmailout2.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728953AbgCDJuf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 04:50:35 -0500
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by bmailout2.hostsharing.net (Postfix) with ESMTPS id 016172800B3CC;
        Wed,  4 Mar 2020 10:50:33 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id C3A1F3F493; Wed,  4 Mar 2020 10:50:32 +0100 (CET)
Date:   Wed, 4 Mar 2020 10:50:32 +0100
From:   Lukas Wunner <lukas@wunner.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Martin Mares <mj@ucw.cz>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH nf-next,RFC 0/5] Netfilter egress hook
Message-ID: <20200304095032.s6ypvmo45d75wkr7@wunner.de>
References: <cover.1572528496.git.lukas@wunner.de>
 <20191107225149.5t4sg35b5gwuwawa@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107225149.5t4sg35b5gwuwawa@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 07, 2019 at 11:51:49PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Oct 31, 2019 at 02:41:00PM +0100, Lukas Wunner wrote:
> > Introduce a netfilter egress hook to complement the existing ingress hook.
> > 
> > User space support for nft is submitted in a separate patch.
> > 
> > The need for this arose because I had to filter egress packets which do
> > not match a specific ethertype.  The most common solution appears to be
> > to enslave the interface to a bridge and use ebtables, but that's
> > cumbersome to configure and comes with a (small) performance penalty.
> > An alternative approach is tc, but that doesn't afford equivalent
> > matching options as netfilter.  A bit of googling reveals that more
> > people have expressed a desire for egress filtering in the past:
> > 
> > https://www.spinics.net/lists/netfilter/msg50038.html
> > https://unix.stackexchange.com/questions/512371
> > 
> > I am first performing traffic control with sch_handle_egress() before
> > performing filtering with nf_egress().  That order is identical to
> > ingress processing.  I'm wondering whether an inverse order would be
> > more logical or more beneficial.  Among other things it would allow
> > marking packets with netfilter on egress before performing traffic
> > control based on that mark.  Thoughts?
> 
> Would you provide some numbers on the performance impact for this new
> hook?

Just a gentle ping for this series.  I'd still be very interested to
get it upstream.  When posting the above-quoted RFC, Daniel NAK'ed it
saying that "weak justification" was provided "for something that sits
in critical fastpath".

However I followed up with numbers showing that the series actually
results in a speedup rather than a slowdown if the feature isn't used:

https://lore.kernel.org/netfilter-devel/20191123131108.dlnrbutabh5i55ix@wunner.de/

So what's the consensus?  Shall I post a non-RFC version, rebased on
current nf-next/master?

Thanks!

Lukas
