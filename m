Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6789101284
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 05:36:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727590AbfKSEgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 23:36:21 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:27495 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727217AbfKSEgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 23:36:21 -0500
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id xAJ4aBWl022049;
        Mon, 18 Nov 2019 20:36:12 -0800
Date:   Tue, 19 Nov 2019 09:57:56 +0530
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nirranjan@chelsio.com,
        vishal@chelsio.com, dt@chelsio.com
Subject: Re: [PATCH net-next v4 2/3] cxgb4: check rule prio conflicts before
 offload
Message-ID: <20191119042754.GA21175@chelsio.com>
References: <cover.1574089391.git.rahul.lakkireddy@chelsio.com>
 <f93ecd0a1607d3eebdbf3f9738abef7d8166eba0.1574089391.git.rahul.lakkireddy@chelsio.com>
 <20191118153606.27aa9863@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191118153606.27aa9863@cakuba.netronome.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Monday, November 11/18/19, 2019 at 15:36:06 -0800, Jakub Kicinski wrote:
> Hi Rahul!
> 
> Please remember to CC people who have you feedback to make sure we
> don't miss the next version of the set.
> 

Ok, got it.

> On Mon, 18 Nov 2019 22:30:18 +0530, Rahul Lakkireddy wrote:
> > Only offload rule if it satisfies following conditions:
> > 1. The immediate previous rule has priority < current rule's priority.
> > 2. The immediate next rule has priority > current rule's priority.
> 
> Hm, the strict comparison here looks suspicious.
> 
> The most common use case for flower is to insert many non-conflicting
> rules (different keys) at the same priority. From looking at this
> description and the code:
> 

Yes, I had seen this regression in one of my tests and updated the
check below to consider equal priority in the equation. But, looks
like I missed to update the commit and comment. It should be <=
and >=, respectively. Will fix in v5.

> +	if ((prev_fe->valid && prio < prev_fe->fs.tc_prio) ||
> +	    (next_fe->valid && prio > next_fe->fs.tc_prio))
> +		valid = false;
> 
> I get the feeling that either you haven't tested flower well or these
> ->valid flags are unreliable?
> 

I'm guessing the confusion here is because of my commit message. Let me
know if I'm missing something else. Here, the ->valid tells if the rule
is active in hardware. If previous entry's prio is greater than current
entry's prio OR if next entry's prio is less than current entry, then
reject the rule. If current entry's prio is equal, then still consider
accepting the rule.

> > Also rework free entry fetch logic to search from end of TCAM, instead
> > of beginning, because higher indices have lower priority than lower
> > indices. This is similar to how TC auto generates priority values.
> > 
> > Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
> > ---
> > v4:
> > - Patch added in this version.
> 
> FWIW in the networking world we like the version history to be included
> in the commit message, i.e. above the --- lines. It's useful
> information.

Ok, got it.

Thanks,
Rahul
