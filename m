Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 036D269F0D6
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 10:02:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbjBVJCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 04:02:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbjBVJCM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 04:02:12 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1FBBC36697;
        Wed, 22 Feb 2023 01:02:11 -0800 (PST)
Date:   Wed, 22 Feb 2023 10:02:07 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@openvz.org
Subject: Re: [PATCH] netfilter: fix percpu counter block leak on error path
 when creating new netns
Message-ID: <Y/XaD3Dt0tiO2yuT@salvia>
References: <20230213042505.334898-1-ptikhomirov@virtuozzo.com>
 <Y/VS7okXF1c6rN/I@salvia>
 <4c6e6b8e-1d0c-2893-f4b9-ea40170cacd6@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4c6e6b8e-1d0c-2893-f4b9-ea40170cacd6@virtuozzo.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 22, 2023 at 10:11:03AM +0800, Pavel Tikhomirov wrote:
> On 22.02.2023 07:25, Pablo Neira Ayuso wrote:
> > Hi,
> > 
> > On Mon, Feb 13, 2023 at 12:25:05PM +0800, Pavel Tikhomirov wrote:
> > > Here is the stack where we allocate percpu counter block:
> > > 
> > >    +-< __alloc_percpu
> > >      +-< xt_percpu_counter_alloc
> > >        +-< find_check_entry # {arp,ip,ip6}_tables.c
> > >          +-< translate_table
> > > 
> > > And it can be leaked on this code path:
> > > 
> > >    +-> ip6t_register_table
> > >      +-> translate_table # allocates percpu counter block
> > >      +-> xt_register_table # fails
> > > 
> > > there is no freeing of the counter block on xt_register_table fail.
> > > Note: xt_percpu_counter_free should be called to free it like we do in
> > > do_replace through cleanup_entry helper (or in __ip6t_unregister_table).
> > > 
> > > Probability of hitting this error path is low AFAICS (xt_register_table
> > > can only return ENOMEM here, as it is not replacing anything, as we are
> > > creating new netns, and it is hard to imagine that all previous
> > > allocations succeeded and after that one in xt_register_table failed).
> > > But it's worth fixing even the rare leak.
> > 
> > Any suggestion as Fixes: tag here? This issue seems to be rather old?
> 
> 
> If I'm correct:
> 
> 1) we have this exact percpu leak since commit 71ae0dff02d7
> ("netfilter: xtables: use percpu rule counters") which introduced
> the percpu allocation.
> 
> 2) but we don't call cleanup_entry on this path at least since
> commit 1da177e4c3f4 ("Linux-2.6.12-rc2") which is really old.
> 
> 3) I also see the same thing here https://github.com/mpe/linux-fullhistory/blame/1ab7e5ccf454483fb78998854dddd0bab398c3de/net/ipv4/netfilter/arp_tables.c#L1169
> which is probably the initiall commit which introduced
> net/ipv4/netfilter/arp_tables.c file.
> 
> So I'm not sure about Fixes: tag, probably one of those three commits.

Thanks, I will pick #1 as Fixes: tag.
