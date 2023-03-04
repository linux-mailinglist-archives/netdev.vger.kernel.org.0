Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCC36AA7C3
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 04:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbjCDDLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 22:11:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbjCDDLN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 22:11:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E82A59D9;
        Fri,  3 Mar 2023 19:11:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A132B819A8;
        Sat,  4 Mar 2023 03:11:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AF0CC433EF;
        Sat,  4 Mar 2023 03:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677899470;
        bh=YQWYe40ws+UBd++ngY7dGcRKP0rAEuBo2x0ZX5gayvE=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=ZxhX5n0CLmjQTArejWRcU5MAhO/CfxHwSRi3AJW1vPS5P0/ofBOtq+f2oujemV1G/
         e6dpR/rJOOlUDOkwBUTpY18pwLsUvn3sUI2xyGOItTeKR8GPX9ELWVOAGuSrTf7zY0
         T28bSizlLizcTA0eoQozUEMcF3Y7ldvMzEvxMAKVZh8taiDqpqjq6D0LK+aHpi8snh
         rq1uweS8Lbg/tPN8y4xqUgmXR5uBGMpYgc9zVBXxa9jkmwqk61aupvhKUEqLYxiw9W
         6+p3DEcETsxFZApkiror7jqE/hR8Oa+hdDZot5NiqpOIje7Jj+iJluTlYSIii80dT7
         auDHnGTt7Os4A==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 93EF05C0278; Fri,  3 Mar 2023 19:11:09 -0800 (PST)
Date:   Fri, 3 Mar 2023 19:11:09 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>, peterz@infradead.org,
        jstultz@google.com, edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] softirq: avoid spurious stalls due to need_resched()
Message-ID: <20230304031109.GG1301832@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20221222221244.1290833-1-kuba@kernel.org>
 <20221222221244.1290833-3-kuba@kernel.org>
 <87r0u6j721.ffs@tglx>
 <20230303133143.7b35433f@kernel.org>
 <20230303223739.GC1301832@paulmck-ThinkPad-P17-Gen-1>
 <20230303233627.GA2136520@paulmck-ThinkPad-P17-Gen-1>
 <20230303154413.1d846ac3@kernel.org>
 <20230304012535.GF1301832@paulmck-ThinkPad-P17-Gen-1>
 <20230303173921.29d9faef@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230303173921.29d9faef@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 03, 2023 at 05:39:21PM -0800, Jakub Kicinski wrote:
> On Fri, 3 Mar 2023 17:25:35 -0800 Paul E. McKenney wrote:
> > > Just to be sure - have you seen Peter's patches?
> > > 
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/peterz/queue.git core/softirq
> > > 
> > > I think it feeds the time limit to the callback from softirq,
> > > so the local 3ms is no more?  
> > 
> > I might or might not have back in September of 2020.  ;-)
> > 
> > But either way, the question remains:  Should RCU_SOFTIRQ do time checking
> > in ksoftirqd context?  Seems like the answer should be "yes", independently
> > of Peter's patches.
> 
> :-o  I didn't notice, I thought that's from Dec 22, LWN was writing
> about Peter's rework at that point. I'm not sure what the story is :(
> And when / if any of these changes are coming downstream.

Not a problem either way, as the compiler would complain bitterly about
the resulting merge conflict and it is easy to fix.  ;-)

							Thanx, Paul
