Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7EF441D46B
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 09:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348644AbhI3HVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 03:21:12 -0400
Received: from mail.netfilter.org ([217.70.188.207]:35894 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348624AbhI3HVL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 03:21:11 -0400
Received: from netfilter.org (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 251CA63EB3;
        Thu, 30 Sep 2021 09:18:03 +0200 (CEST)
Date:   Thu, 30 Sep 2021 09:19:24 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, lukas@wunner.de,
        kadlec@netfilter.org, fw@strlen.de, ast@kernel.org,
        edumazet@google.com, tgraf@suug.ch, nevola@gmail.com,
        john.fastabend@gmail.com, willemb@google.com
Subject: Re: [PATCH nf-next v5 0/6] Netfilter egress hook
Message-ID: <YVVk/C6mb8O3QMPJ@salvia>
References: <20210928095538.114207-1-pablo@netfilter.org>
 <e4f1700c-c299-7091-1c23-60ec329a5b8d@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e4f1700c-c299-7091-1c23-60ec329a5b8d@iogearbox.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 08:08:53AM +0200, Daniel Borkmann wrote:
> On 9/28/21 11:55 AM, Pablo Neira Ayuso wrote:
> > Hi,
> > 
> > This patchset v5 that re-adds the Netfilter egress:
> > 
> > 1) Rename linux/netfilter_ingress.h to linux/netfilter_netdev.h
> >     from Lukas Wunner.
> > 
> > 2) Generalize ingress hook file to accomodate egress support,
> >     from Lukas Wunner.
> > 
> > 3) Modularize Netfilter ingress hook into nf_tables_netdev: Daniel
> >     Borkmann is requesting for a mechanism to allow to blacklist
> >     Netfilter, this allows users to blacklist this new module that
> >     includes ingress chain and the new egress chain for the netdev
> >     family. There is no other in-tree user of the ingress and egress
> >     hooks than this which might interfer with his matter.
> > 
> > 4) Place the egress hook again before the tc egress hook as requested
> >     by Daniel Borkmann. Patch to add egress hook from Lukas Wunner.
> >     The Netfilter egress hook remains behind the static key, if unused
> >     performance degradation is negligible.
> > 
> > 5) Add netfilter egress handling to af_packet.
> > 
> > Arguably, distributors might decide to compile nf_tables_netdev
> > built-in. Traditionally, distributors have compiled their kernels using
> > the default configuration that Netfilter Kconfig provides (ie. use
> > modules whenever possible). In any case, I consider that distributor
> > policy is out of scope in this discussion, providing a mechanism to
> > allow Daniel to prevent Netfilter ingress and egress chains to be loaded
> > should be sufficient IMHO.
> 
> Hm, so in the case of SRv6 users were running into a similar issue and commit
> 7a3f5b0de364 ("netfilter: add netfilter hooks to SRv6 data plane") [0] added
> a new hook along with a sysctl which defaults the new hook to off.
> 
> The rationale for it was given as "the hooks are enabled via nf_hooks_lwtunnel
> sysctl to make sure existing netfilter rulesets do not break." [0,1]
> 
> If the suggestion to flag the skb [2] one way or another from the tc forwarding
> path (e.g. skb bit or per-cpu marker) is not technically feasible, then why not
> do a sysctl toggle like in the SRv6 case?

I am already providing a global toggle to disable netdev
ingress/egress hooks?

In the SRv6 case that is not possible.

Why do you need you need a sysctl knob when my proposal is already
addressing your needs?
