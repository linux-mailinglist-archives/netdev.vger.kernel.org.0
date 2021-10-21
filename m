Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD8F9436E97
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 01:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231598AbhJVAAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 20:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbhJVAAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 20:00:40 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C132C061764;
        Thu, 21 Oct 2021 16:58:23 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mdhwx-0003jy-BJ; Fri, 22 Oct 2021 01:58:19 +0200
Date:   Fri, 22 Oct 2021 01:58:19 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Eugene Crosser <crosser@average.org>
Cc:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, dsahern@kernel.org,
        pablo@netfilter.org, lschlesinger@drivenets.com
Subject: Re: [PATCH net-next 2/2] vrf: run conntrack only in context of
 lower/physdev for locally generated packets
Message-ID: <20211021235819.GF7604@breakpoint.cc>
References: <20211021144857.29714-1-fw@strlen.de>
 <20211021144857.29714-3-fw@strlen.de>
 <dbbc274e-cf69-5207-6ddd-00c435d5a689@average.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dbbc274e-cf69-5207-6ddd-00c435d5a689@average.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eugene Crosser <crosser@average.org> wrote:
> > +static void vrf_nf_set_untracked(struct sk_buff *skb)
> > +{
> > +	if (skb_get_nfct(skb) == 0)
> > +		nf_ct_set(skb, 0, IP_CT_UNTRACKED);
> > +}
> > +
> > +static void vrf_nf_reset_ct(struct sk_buff *skb)
> > +{
> > +	if (skb_get_nfct(skb) == IP_CT_UNTRACKED)
> > +		nf_reset_ct(skb);
> > +}
> > +
> 
> Isn't it possible that skb was marked UNTRACKED before entering this path, by a
> rule?

I don't think so, it should be called before any ruleset evaluation has
taken place.

> In  such case 'set_untrackd' will do nothing, but 'reset_ct' will clear
> UNTRACKED status that was set elswhere. It seems wrong, am I missing something?

No, thats the catch.  I can't find a better option.

I can add a patch to disable all of the NF_HOOK() invocations from vrf
which removes the ability to filter on vrf interface names.

The option to add a caller_id to nf_hook_state struct (so conntrack/nat
can detect when they are called from the vrf hooks) either needs
copypastry of entire NF_HOOK* inline functions into vrf (so the 'is-vrf'
flag can be enabled) or yet another argument to NF_HOOK().

It also leaks even more 'is vrf' checks into conntrack.
