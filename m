Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD2341D473
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 09:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348679AbhI3HXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 03:23:02 -0400
Received: from mail.netfilter.org ([217.70.188.207]:35940 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348577AbhI3HXB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 03:23:01 -0400
Received: from netfilter.org (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id F211763EB3;
        Thu, 30 Sep 2021 09:19:51 +0200 (CEST)
Date:   Thu, 30 Sep 2021 09:21:14 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, kadlec@netfilter.org,
        fw@strlen.de, ast@kernel.org, edumazet@google.com, tgraf@suug.ch,
        nevola@gmail.com, john.fastabend@gmail.com, willemb@google.com
Subject: Re: [PATCH nf-next v5 0/6] Netfilter egress hook
Message-ID: <YVVlamF0tG/awdHX@salvia>
References: <20210928095538.114207-1-pablo@netfilter.org>
 <e4f1700c-c299-7091-1c23-60ec329a5b8d@iogearbox.net>
 <20210930065238.GA28709@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210930065238.GA28709@wunner.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 08:52:38AM +0200, Lukas Wunner wrote:
> On Thu, Sep 30, 2021 at 08:08:53AM +0200, Daniel Borkmann wrote:
> > Hm, so in the case of SRv6 users were running into a similar issue
> > and commit 7a3f5b0de364 ("netfilter: add netfilter hooks to SRv6
> > data plane") [0] added a new hook along with a sysctl which defaults
> > the new hook to off.
> > 
> > The rationale for it was given as "the hooks are enabled via
> > nf_hooks_lwtunnel sysctl to make sure existing netfilter rulesets
> >  do not break." [0,1]
> > 
> > If the suggestion to flag the skb [2] one way or another from the
> > tc forwarding path (e.g. skb bit or per-cpu marker) is not
> > technically feasible, then why not do a sysctl toggle like in the
> > SRv6 case?
> 
> The skb flag *is* technically feasible.  I amended the patches with
> the flag and was going to post them this week, but Pablo beat me to
> the punch and posted his alternative version, which lacks the flag
> but modularizes netfilter ingress/egress processing instead.
> 
> Honestly I think a hodge-podge of config options and sysctl toggles
> is awful and I would prefer the skb flag you suggested.  I kind of
> like your idea of considering tc and netfilter as layers.
> 
> FWIW the finished patches *with* the flag are on this branch:
> https://github.com/l1k/linux/commits/nft_egress_v5
> 
> Below is the "git range-diff" between Pablo's patches and mine
> (just the hunks which pertain to the skb flag, plus excerpts
> from the commit message).
> 
> Would you find the patch set acceptable with this skb flag?

Why do you need a programmatic skb flag?

Are you planning to do:

        skb->skip_nf_egress = random();

from the packet path?

Seriously, Daniel is asking for a global toggle to disable Netfilter.

What is wrong with the Netfilter blacklisting approach?
