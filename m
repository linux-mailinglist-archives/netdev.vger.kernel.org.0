Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5AB41D487
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 09:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348758AbhI3Hac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 03:30:32 -0400
Received: from mail.netfilter.org ([217.70.188.207]:35972 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348739AbhI3Ha1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 03:30:27 -0400
Received: from netfilter.org (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id D442C63EBA;
        Thu, 30 Sep 2021 09:27:17 +0200 (CEST)
Date:   Thu, 30 Sep 2021 09:28:39 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 2/5] netfilter: nf_tables: add position handle in
 event notification
Message-ID: <YVVnJ+Rv36/aF3+u@salvia>
References: <20210929230500.811946-1-pablo@netfilter.org>
 <20210929230500.811946-3-pablo@netfilter.org>
 <20210929191953.00378ec4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210929191953.00378ec4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Wed, Sep 29, 2021 at 07:19:53PM -0700, Jakub Kicinski wrote:
> On Thu, 30 Sep 2021 01:04:57 +0200 Pablo Neira Ayuso wrote:
> > Add position handle to allow to identify the rule location from netlink
> > events. Otherwise, userspace cannot incrementally update a userspace
> > cache through monitoring events.
> > 
> > Skip handle dump if the rule has been either inserted (at the beginning
> > of the ruleset) or appended (at the end of the ruleset), the
> > NLM_F_APPEND netlink flag is sufficient in these two cases.
> > 
> > Handle NLM_F_REPLACE as NLM_F_APPEND since the rule replacement
> > expansion appends it after the specified rule handle.
> > 
> > Fixes: 96518518cc41 ("netfilter: add nftables")
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> Let me defer to Dave on this one. Krzysztof K recently provided us with
> this quote:
> 
> "One thing that does bother [Linus] is developers who send him fixes in the
> -rc2 or -rc3 time frame for things that never worked in the first place.
> If something never worked, then the fact that it doesn't work now is not
> a regression, so the fixes should just wait for the next merge window.
> Those fixes are, after all, essentially development work."
> 
> 	https://lwn.net/Articles/705245/
> 
> Maybe the thinking has evolved since, but this patch strikes me as odd.
> We forgot to put an attribute in netlink 8 years ago, and suddenly it's
> urgent to fill it in?  Something does not connect for me, certainly the
> commit message should have explained things better...

Reasonable, but in this particular case I cannot fix userspace monitor
mode without this patch.

A user reported that 'nft insert rule...' shows as 'nft add rule...'
in 'nft monitor'.

Then if 'nft add rule x y position 10...' is used to add a rule at a
given position, then it does not show the 'position 10' so the user
is just getting a 'add rule x y' which means append it at the end.

Same thing happens with 'create table x', it shows as 'add table x'.

Noone noticed the missing flags in the event notification path so far.

I can place this into net-next, yes, but this is only going to delay
things before I can ask for including this in -stable, meanwhile users
will keep getting misleading event notification for these cases.

Thanks.
