Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE8FEFC49C
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 11:47:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbfKNKr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 05:47:26 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:52452 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725977AbfKNKr0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Nov 2019 05:47:26 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1iVCeq-0001U6-05; Thu, 14 Nov 2019 11:47:24 +0100
Date:   Thu, 14 Nov 2019 11:47:23 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        Eric Garver <eric@garver.life>
Subject: Re: [nf-next PATCH] net: netfilter: Support iif matches in
 POSTROUTING
Message-ID: <20191114104723.GF11663@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        Eric Garver <eric@garver.life>
References: <20191112161437.19511-1-phil@nwl.cc>
 <20191113230842.blotm5i3ftz24rml@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191113230842.blotm5i3ftz24rml@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 14, 2019 at 12:08:42AM +0100, Pablo Neira Ayuso wrote:
> On Tue, Nov 12, 2019 at 05:14:37PM +0100, Phil Sutter wrote:
> > Instead of generally passing NULL to NF_HOOK_COND() for input device,
> > pass skb->dev which contains input device for routed skbs.
> > 
> > Note that iptables (both legacy and nft) reject rules with input
> > interface match from being added to POSTROUTING chains, but nftables
> > allows this.
> 
> Yes, it allows this but it will not ever match, right? So even if the
> rule is loaded, it will be useless.

This patch changes that. What you're referring to is the NFWS discussion
about nft_meta: In the past, iif* matches would enter error path if
input interface was NULL, thereby aborting rule traversal (NFT_BREAK).
That was changed in commit cb81572e8cb50 ("netfilter: nf_tables: Make
nft_meta expression more robust") to instead just set dreg to something
that usually doesn't match.

> Do you have a usecase in mind that would benefit from this specifically?

I would like to masquerade traffic coming from a local private
interface, like so:

| nft add rule ip filter POSTROUTING iifname 'vnetbr0' masquerade

A typical idiom commonly used to avoid this disallowed match is to
masquerade anything that's not routed to the private interface:

| iptables -t nat -A POSTROUTING ! -o vnetbr0 -j MASQUERADE

But this rule will match more traffic than necessary, also things get a
bit complicated when using multiple private interfaces between which
traffic shouldn't be masqueraded.

Firewalld has a special workaround, it marks packets for later:

| iptables -t nat -A PREROUTING -i vnetbr0 -j MARK --set-mark 0xbeef
| iptables -t nat -A POSTROUTING -m mark --mark 0xbeef -j MASQUERADE

Cheers, Phil
