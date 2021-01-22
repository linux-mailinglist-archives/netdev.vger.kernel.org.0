Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABE0E3004B1
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 15:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727517AbhAVOA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 09:00:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727095AbhAVOAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 09:00:22 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8D73C06174A
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 05:59:41 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1l2wyO-0001NW-Ou; Fri, 22 Jan 2021 14:59:36 +0100
Date:   Fri, 22 Jan 2021 14:59:36 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Russell Stuart <russell-lartc@stuart.id.au>
Subject: Re: tc: u32: Wrong sample hash calculation
Message-ID: <20210122135936.GZ3158@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Russell Stuart <russell-lartc@stuart.id.au>
References: <20210118112919.GC3158@orbyte.nwl.cc>
 <8df2e0cc-3de4-7084-6859-df1559921fc7@mojatatu.com>
 <20210120152359.GM3158@orbyte.nwl.cc>
 <7d493e9f-23ee-34cf-fbdd-b13a4d3bb4af@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7d493e9f-23ee-34cf-fbdd-b13a4d3bb4af@mojatatu.com>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jamal,

On Fri, Jan 22, 2021 at 06:25:22AM -0500, Jamal Hadi Salim wrote:
[...]
> My gut feel is user space is the right/easier spot to fix this
> as long as it doesnt break the working setup of 8b.

One last attempt at clarifying the situation:

Back in 2004, your commit 4e54c4816bf ("[NET]: Add tc extensions
infrastructure.")[1] was applied which commented out the old hash
folding and introduced the shift/cutoff we have today:

|  @@ -90,10 +101,12 @@ static struct tc_u_common *u32_list;
|  
|  static __inline__ unsigned u32_hash_fold(u32 key, struct tc_u32_sel *sel)
|  {
| -	unsigned h = key & sel->hmask;
| +	unsigned h = (key & sel->hmask)>>sel->fshift;
|  
| +	/*
|  	h ^= h>>16;
|  	h ^= h>>8;
| +	*/
|  	return h;
|  }

In a later commit, the new code was made compile-time selected via '#ifdef
fix_u32_bug'. In that same commit, I don't see a related #define though.

Do you remember why this was changed? Seems like the old code was
problematic somehow.

Cheers, Phil

[1] https://github.com/laijs/linux-kernel-ancient-history/commit/4e54c4816bfe51c145382d272b19c2ae41e9e36f#
