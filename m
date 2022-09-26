Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF5F75EA8DC
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 16:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235229AbiIZOpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 10:45:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235219AbiIZOoZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 10:44:25 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84FF140E31;
        Mon, 26 Sep 2022 06:08:15 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1ocnqC-0005Pr-Tl; Mon, 26 Sep 2022 15:08:08 +0200
Date:   Mon, 26 Sep 2022 15:08:08 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Michal Hocko <mhocko@suse.com>
Cc:     Florian Westphal <fw@strlen.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, vbabka@suse.cz,
        akpm@linux-foundation.org, urezki@gmail.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Martin Zaharinov <micron10@gmail.com>
Subject: Re: [PATCH mm] mm: fix BUG with kvzalloc+GFP_ATOMIC
Message-ID: <20220926130808.GD12777@breakpoint.cc>
References: <20220923103858.26729-1-fw@strlen.de>
 <Yy20toVrIktiMSvH@dhcp22.suse.cz>
 <20220923133512.GE22541@breakpoint.cc>
 <YzFZf0Onm6/UH7/I@dhcp22.suse.cz>
 <20220926075639.GA908@breakpoint.cc>
 <YzFplwSxwwsLpzzX@dhcp22.suse.cz>
 <YzFxHlYoncuDl2fM@dhcp22.suse.cz>
 <20220926100800.GB12777@breakpoint.cc>
 <YzGUyWlYd15uLu7G@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YzGUyWlYd15uLu7G@dhcp22.suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Michal Hocko <mhocko@suse.com> wrote:
> On Mon 26-09-22 12:08:00, Florian Westphal wrote:
> > Michal Hocko <mhocko@suse.com> wrote:
> > > +		old_tbl = rht_dereference_rcu(ht->tbl, ht);
> > > +		size = tbl->size;
> > > +
> > > +		data = ERR_PTR(-EBUSY);
> > > +
> > > +		if (rht_grow_above_75(ht, tbl))
> > > +			size *= 2;
> > > +		/* Do not schedule more than one rehash */
> > > +		else if (old_tbl != tbl)
> > > +			return data;
> > > +
> > > +		data = ERR_PTR(-ENOMEM);
> > > +
> > > +		rcu_read_unlock();
> > > +		new_tbl = bucket_table_alloc(ht, size, GFP_KERNEL);
> > > +		rcu_read_lock();
> > 
> > I don't think this is going to work, there can be callers that
> > rely on rcu protected data structures getting free'd.
> 
> The caller of this function drops RCU for each retry, why should be the
> called function any special?

I was unfortunately never able to fully understand rhashtable.
AFAICS the rcu_read_lock/unlock in the caller is pointless,
or at least dubious.

To the best of my knowledge there are users of this interface that
invoke it with rcu read lock held, and since those always nest, the
rcu_read_unlock() won't move us to GFP_KERNEL territory.

I guess you can add a might_sleep() and ask kernel to barf at runtime.
