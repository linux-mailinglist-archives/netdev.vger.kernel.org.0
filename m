Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDF18569D40
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 10:26:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235514AbiGGIVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 04:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235344AbiGGIVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 04:21:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0AF114083;
        Thu,  7 Jul 2022 01:19:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 916B4B81F1F;
        Thu,  7 Jul 2022 08:19:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF964C3411E;
        Thu,  7 Jul 2022 08:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657181995;
        bh=dlKZYg79yRfs31l7B5/WgBfVM2TrLooFz8zeZbYFV+4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QduiOdNuFqVXHcTMs4SxGJaq1lG+dELES08mPqbFMLL+6gFYNszYUar1eRo36Xa/P
         zRR2GK4qKXGnMFxhZkB/NvKKJrUZnrWol/+RglB/4VzeLlat9aSaoUOZ91/WgeG51M
         qL144onb9+qe7IM+R2qxO7HIyf46LshybFDDUpbReLkFDsbi3MFWvDDSQNF7m4Qdvw
         Eh2Dx0cYfx0zcJQ6/xhiVwqpNzxFlfO1ySiDnAPz9b24rU89VWau/xxA3npTPYTu4p
         WL0By6eEwEJVzB9y219Cqw5xRtHnMbSpvZkbNWgc6AHxQV4b6sncPD+IuzEOg/x7wL
         zS/NWgN1c7a8Q==
Date:   Thu, 7 Jul 2022 09:19:50 +0100
From:   Will Deacon <will@kernel.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, regressions@lists.linux.dev,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Kajetan Puchalski <kajetan.puchalski@arm.com>
Subject: Re: [PATCH nf v3] netfilter: conntrack: fix crash due to confirmed
 bit load reordering
Message-ID: <20220707081949.GA4057@willie-the-truck>
References: <20220706124007.GB7996@breakpoint.cc>
 <20220706145004.22355-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220706145004.22355-1-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 06, 2022 at 04:50:04PM +0200, Florian Westphal wrote:
> Kajetan Puchalski reports crash on ARM, with backtrace of:
> 
> __nf_ct_delete_from_lists
> nf_ct_delete
> early_drop
> __nf_conntrack_alloc
> 
> Unlike atomic_inc_not_zero, refcount_inc_not_zero is not a full barrier.
> conntrack uses SLAB_TYPESAFE_BY_RCU, i.e. it is possible that a 'newly'
> allocated object is still in use on another CPU:
> 
> CPU1						CPU2
> 						encounter 'ct' during hlist walk
>  delete_from_lists
>  refcount drops to 0
>  kmem_cache_free(ct);
>  __nf_conntrack_alloc() // returns same object
> 						refcount_inc_not_zero(ct); /* might fail */
> 
> 						/* If set, ct is public/in the hash table */
> 						test_bit(IPS_CONFIRMED_BIT, &ct->status);
> 
> In case CPU1 already set refcount back to 1, refcount_inc_not_zero()
> will succeed.
> 
> The expected possibilities for a CPU that obtained the object 'ct'
> (but no reference so far) are:
> 
> 1. refcount_inc_not_zero() fails.  CPU2 ignores the object and moves to
>    the next entry in the list.  This happens for objects that are about
>    to be free'd, that have been free'd, or that have been reallocated
>    by __nf_conntrack_alloc(), but where the refcount has not been
>    increased back to 1 yet.
> 
> 2. refcount_inc_not_zero() succeeds. CPU2 checks the CONFIRMED bit
>    in ct->status.  If set, the object is public/in the table.
> 
>    If not, the object must be skipped; CPU2 calls nf_ct_put() to
>    un-do the refcount increment and moves to the next object.
> 
> Parallel deletion from the hlists is prevented by a
> 'test_and_set_bit(IPS_DYING_BIT, &ct->status);' check, i.e. only one
> cpu will do the unlink, the other one will only drop its reference count.
> 
> Because refcount_inc_not_zero is not a full barrier, CPU2 may try to
> delete an object that is not on any list:
> 
> 1. refcount_inc_not_zero() successful (refcount inited to 1 on other CPU)
> 2. CONFIRMED test also successful (load was reordered or zeroing
>    of ct->status not yet visible)
> 3. delete_from_lists unlinks entry not on the hlist, because
>    IPS_DYING_BIT is 0 (already cleared).
> 
> 2) is already wrong: CPU2 will handle a partially initited object
> that is supposed to be private to CPU1.
> 
> Add needed barriers when refcount_inc_not_zero() is successful.
> 
> It also inserts a smp_wmb() before the refcount is set to 1 during
> allocation.
> 
> Because other CPU might still 'see' the object, refcount_set(1)
> "resurrects" the object, so we need to make sure that other CPUs will
> also observe the right contents.  In particular, the CONFIRMED bit test
> must only pass once the object is fully initialised and either in the
> hash or about to be inserted (with locks held to delay possible unlink from
> early_drop or gc worker).
> 
> I did not change flow_offload_alloc(), as far as I can see it should call
> refcount_inc(), not refcount_inc_not_zero(): the ct object is attached to
> the skb so its refcount should be >= 1 in all cases.
> 
> v2: prefer smp_acquire__after_ctrl_dep to smp_rmb (Will Deacon).
> v3: keep smp_acquire__after_ctrl_dep close to refcount_inc_not_zero call
>     add comment in nf_conntrack_netlink, no control dependency there
>     due to locks.
> 
> Cc: Peter Zijlstra <peterz@infradead.org>
> Reported-by: Kajetan Puchalski <kajetan.puchalski@arm.com>
> Diagnosed-by: Will Deacon <will@kernel.org>
> Fixes: 719774377622 ("netfilter: conntrack: convert to refcount_t api")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/nf_conntrack_core.c       | 22 ++++++++++++++++++++++
>  net/netfilter/nf_conntrack_netlink.c    |  1 +
>  net/netfilter/nf_conntrack_standalone.c |  3 +++
>  3 files changed, 26 insertions(+)

Acked-by: Will Deacon <will@kernel.org>

Will
