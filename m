Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93DFC3EDEA5
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 22:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbhHPU0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 16:26:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:34842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231307AbhHPU0j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 16:26:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 409F960D07;
        Mon, 16 Aug 2021 20:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629145567;
        bh=fgWAjI0DaWa+emARNCzT/HZ9sQ5Rw9p++ET2aIlUCu0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=mSOrpBYvL7C1ML2CNGey8a8e2qwGMV0PYBkywy88rxQ3b2G7upkzccpB2NG3oD6Ta
         /cs9LlyBjqjVO3iMEwVypC+vUYooKDEOgtRIm7tfMNFzoOpuIpBnER78OXvjY9So/T
         X2oimZkNNKVq7czxGWbtqwgNnh5NoO+zk6NZz4y0O/uyjQR027T3vnhaJCmrr/mBzu
         l0jvpxg1Oi8hL4rjmytOkAA+yuX0R2U13BA3ErrvkAGhHuZJ0rcoPyjDf5M+K0D+kZ
         zbR+lBs6t6meqC5owrU+nIb9GI/nkz91UHp1bMYClKPgMz/1RBlpVGetv2upGtg2qI
         9D11ZtyOIXQQg==
Received: by mail-ej1-f47.google.com with SMTP id z20so34066165ejf.5;
        Mon, 16 Aug 2021 13:26:07 -0700 (PDT)
X-Gm-Message-State: AOAM530olZMK1eXpDhP9SY7pho/rWDfcWMs8M2WLxUD/NF/c9x3wSX2A
        16RDpZNJIcXMrqzeHpXEnm6eAIePu0IXsOeGlg==
X-Google-Smtp-Source: ABdhPJwrW/No0ID/B/GwH1N+YFxWM7GR1BPXyyMT2r1NJDL+dw+DfoFcWqQp3yd/VP+S2ErEyfXCtlaZrTexVxMbtDQ=
X-Received: by 2002:a17:906:fa92:: with SMTP id lt18mr239851ejb.359.1629145565779;
 Mon, 16 Aug 2021 13:26:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210814010139.kzryimmp4rizlznt@skbuf> <9accd63a-961c-4dab-e167-9e2654917a94@gmail.com>
 <20210816144622.tgslast6sbblclda@skbuf> <4cad28e0-d6b4-800d-787b-936ffaca7be3@gmail.com>
 <CAL_JsqKYd288Th2cfOp0_HD1C8xtgKjyJfUW4JLpyn0NkGdU5w@mail.gmail.com> <2e98373f-c37c-0d26-5c9a-1f15ade243c1@gmail.com>
In-Reply-To: <2e98373f-c37c-0d26-5c9a-1f15ade243c1@gmail.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Mon, 16 Aug 2021 15:25:53 -0500
X-Gmail-Original-Message-ID: <CAL_JsqK9+Uf526D6535eD=WpThByKmiDcVPzBuyYjb3rWSLDaA@mail.gmail.com>
Message-ID: <CAL_JsqK9+Uf526D6535eD=WpThByKmiDcVPzBuyYjb3rWSLDaA@mail.gmail.com>
Subject: Re: of_node_put() usage is buggy all over drivers/of/base.c?!
To:     Frank Rowand <frowand.list@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 16, 2021 at 2:57 PM Frank Rowand <frowand.list@gmail.com> wrote:
>
> On 8/16/21 2:20 PM, Rob Herring wrote:
> > On Mon, Aug 16, 2021 at 10:14 AM Frank Rowand <frowand.list@gmail.com> wrote:
> >>
> >> On 8/16/21 9:46 AM, Vladimir Oltean wrote:
> >>> Hi Frank,
> >>>
> >>> On Mon, Aug 16, 2021 at 09:33:03AM -0500, Frank Rowand wrote:
> >>>> Hi Vladimir,
> >>>>
> >>>> On 8/13/21 8:01 PM, Vladimir Oltean wrote:
> >>>>> Hi,
> >>>>>
> >>>>> I was debugging an RCU stall which happened during the probing of a
> >>>>> driver. Activating lock debugging, I see:
> >>>>
> >>>> I took a quick look at sja1105_mdiobus_register() in v5.14-rc1 and v5.14-rc6.
> >>>>
> >>>> Looking at the following stack trace, I did not see any calls to
> >>>> of_find_compatible_node() in sja1105_mdiobus_register().  I am
> >>>> guessing that maybe there is an inlined function that calls
> >>>> of_find_compatible_node().  This would likely be either
> >>>> sja1105_mdiobus_base_tx_register() or sja1105_mdioux_base_t1_register().
> >>>
> >>> Yes, it is sja1105_mdiobus_base_t1_register which is inlined.
> >>>
> >>>>>
> >>>>> [  101.710694] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:938
> >>>>> [  101.719119] in_atomic(): 1, irqs_disabled(): 128, non_block: 0, pid: 1534, name: sh
> >>>>> [  101.726763] INFO: lockdep is turned off.
> >>>>> [  101.730674] irq event stamp: 0
> >>>>> [  101.733716] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
> >>>>> [  101.739973] hardirqs last disabled at (0): [<ffffd3ebecb10120>] copy_process+0xa78/0x1a98
> >>>>> [  101.748146] softirqs last  enabled at (0): [<ffffd3ebecb10120>] copy_process+0xa78/0x1a98
> >>>>> [  101.756313] softirqs last disabled at (0): [<0000000000000000>] 0x0
> >>>>> [  101.762569] CPU: 4 PID: 1534 Comm: sh Not tainted 5.14.0-rc5+ #272
> >>>>> [  101.774558] Call trace:
> >>>>> [  101.794734]  __might_sleep+0x50/0x88
> >>>>> [  101.798297]  __mutex_lock+0x60/0x938
> >>>>> [  101.801863]  mutex_lock_nested+0x38/0x50
> >>>>> [  101.805775]  kernfs_remove+0x2c/0x50             <---- this takes mutex_lock(&kernfs_mutex);
> >>>>> [  101.809341]  sysfs_remove_dir+0x54/0x70
> >>>>
> >>>> The __kobject_del() occurs only if the refcount on the node
> >>>> becomes zero.  This should never be true when of_find_compatible_node()
> >>>> calls of_node_put() unless a "from" node is passed to of_find_compatible_node().
> >>>
> >>> I figured that was the assumption, that the of_node_put would never
> >>> trigger a sysfs file / kobject deletion from there.
> >>>
> >>>> In both sja1105_mdiobus_base_tx_register() and sja1105_mdioux_base_t1_register()
> >>>> a from node ("mdio") is passed to of_find_compatible_node() without first doing an
> >>>> of_node_get(mdio).  If you add the of_node_get() calls the problem should be fixed.
> >>>
> >>> The answer seems simple enough, but stupid question, but why does
> >>> of_find_compatible_node call of_node_put on "from" in the first place?
> >>
> >> Actually a good question.
> >>
> >> I do not know why of_find_compatible_node() calls of_node_put() instead of making
> >> the caller of of_find_compatible_node() responsible.  That pattern was created
> >> long before I was involved in devicetree and I have not gone back to read the
> >> review comments of when that code was created.
> >
>
> > Because it is an iterator function and they all drop the ref from the
> > prior iteration.
>
> That is what I was expecting before reading through the code.  But instead
> I found of_find_compatible_node():

No, I meant of_find_compatible_node() is the iterator for
for_each_compatible_node().

>
>         raw_spin_lock_irqsave(&devtree_lock, flags);
>         for_each_of_allnodes_from(from, np)
>                 if (__of_device_is_compatible(np, compatible, type, NULL) &&
>                     of_node_get(np))
>                         break;
>         of_node_put(from);
>         raw_spin_unlock_irqrestore(&devtree_lock, flags);
>
>
> for_each_of_allnodes_fromir:
>
> #define for_each_of_allnodes_from(from, dn) \
>         for (dn = __of_find_all_nodes(from); dn; dn = __of_find_all_nodes(dn))

This is only used internally, so it can rely on the caller holding the
lock. This should be moved into of_private.h.

> and __of_find_all_nodes() is:
>
> struct device_node *__of_find_all_nodes(struct device_node *prev)
> {
>         struct device_node *np;
>         if (!prev) {
>                 np = of_root;
>         } else if (prev->child) {
>                 np = prev->child;
>         } else {
>                 /* Walk back up looking for a sibling, or the end of the structure */
>                 np = prev;
>                 while (np->parent && !np->sibling)
>                         np = np->parent;
>                 np = np->sibling; /* Might be null at the end of the tree */
>         }
>         return np;
> }
>
>
> So the iterator is not using of_node_get() and of_node_put() for each
> node that is traversed.  The protection against a node disappearing
> during the iteration is provided by holding devtree_lock.

The lock is for traversing the nodes (i.e. a list lock), not keeping
nodes around.

>
> >
> > I would say any open coded call where from is not NULL is an error.
>
> I assume you mean any open coded call of of_find_compatible_node().  There are
> at least a couple of instances of that.  I did only a partial grep while looking
> at Vladimir's issue.
>
> Doing the full grep now, I see 13 instances of architecture and driver code calling
> of_find_compatible_node().
>
> > It's not reliable because the DT search order is not defined and could
> > change. Someone want to write a coccinelle script to check that?
> >
>
> > The above code should be using of_get_compatible_child() instead.
>
> Yes, of_get_compatible_child() should be used here.  Thanks for pointing
> that out.
>
> There are 13 instances of architecture and driver code calling
> of_find_compatible_node().  If possible, it would be good to change all of
> them to of_get_compatible_child().  If we could replace all driver
> usage of of_find_compatible_node() with a from parameter of NULL to
> a new wrapper without a from parameter, where the wrapper calls
> of_find_compatible_node() with the from parameter set to NULL, then
> we could prevent this problem from recurring.

Patches welcome.

I don't know if all 13 are only looking for child nodes. Could be open
coding for_each_compatible_node or looking for grandchild nodes in
addition (for which we don't have helpers).

Rob
