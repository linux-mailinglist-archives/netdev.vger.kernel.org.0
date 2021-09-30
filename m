Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D50B41DB7B
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 15:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351479AbhI3Nvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 09:51:36 -0400
Received: from mail.netfilter.org ([217.70.188.207]:37102 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235171AbhI3Nvf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 09:51:35 -0400
Received: from netfilter.org (unknown [37.29.219.236])
        by mail.netfilter.org (Postfix) with ESMTPSA id B68E463EB3;
        Thu, 30 Sep 2021 15:48:24 +0200 (CEST)
Date:   Thu, 30 Sep 2021 15:49:46 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     David Miller <davem@davemloft.net>
Cc:     kuba@kernel.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 2/5] netfilter: nf_tables: add position handle in
 event notification
Message-ID: <YVXAeheN9xpOWXWU@salvia>
References: <20210929230500.811946-1-pablo@netfilter.org>
 <20210929230500.811946-3-pablo@netfilter.org>
 <20210929191953.00378ec4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210930.133522.917842602540469933.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210930.133522.917842602540469933.davem@davemloft.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 01:35:22PM +0100, David Miller wrote:
> From: Jakub Kicinski <kuba@kernel.org>
> Date: Wed, 29 Sep 2021 19:19:53 -0700
> 
> > On Thu, 30 Sep 2021 01:04:57 +0200 Pablo Neira Ayuso wrote:
> >> Add position handle to allow to identify the rule location from netlink
> >> events. Otherwise, userspace cannot incrementally update a userspace
> >> cache through monitoring events.
> >> 
> >> Skip handle dump if the rule has been either inserted (at the beginning
> >> of the ruleset) or appended (at the end of the ruleset), the
> >> NLM_F_APPEND netlink flag is sufficient in these two cases.
> >> 
> >> Handle NLM_F_REPLACE as NLM_F_APPEND since the rule replacement
> >> expansion appends it after the specified rule handle.
> >> 
> >> Fixes: 96518518cc41 ("netfilter: add nftables")
> >> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > 
> > Let me defer to Dave on this one. Krzysztof K recently provided us with
> > this quote:
> > 
> > "One thing that does bother [Linus] is developers who send him fixes in the
> > -rc2 or -rc3 time frame for things that never worked in the first place.
> > If something never worked, then the fact that it doesn't work now is not
> > a regression, so the fixes should just wait for the next merge window.
> > Those fixes are, after all, essentially development work."
> > 
> > 	https://lwn.net/Articles/705245/
> > 
> > Maybe the thinking has evolved since, but this patch strikes me as odd.
> > We forgot to put an attribute in netlink 8 years ago, and suddenly it's
> > urgent to fill it in?  Something does not connect for me, certainly the
> > commit message should have explained things better...
> 
> Agreed.

The aforementioned article says:

"In general, he said, if a fix applies to a feature that is not
currently being used, it should wait for the next development cycle"

This feature is being used by 'nft monitor', which is not
representing:

- insert rule
- add/insert rule with position handle
- create table/chain/set/map

commands in the correct way via netlink notifications.

I can rework the commit message to clarify this and resubmit.
