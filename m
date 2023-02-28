Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A19A66A5D31
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 17:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbjB1QfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 11:35:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbjB1QfH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 11:35:07 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C5930B19
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 08:35:01 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pX2wH-0004Ee-TO; Tue, 28 Feb 2023 17:34:53 +0100
Date:   Tue, 28 Feb 2023 17:34:53 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Alexander Lobakin <aleksander.lobakin@intel.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Florian Westphal <fw@strlen.de>,
        edumazet@google.com, netdev@vger.kernel.org, davem@davemloft.net,
        pabeni@redhat.com, shakeelb@google.com, soheil@google.com
Subject: Re: [PATCH net] net: avoid indirect memory pressure calls
Message-ID: <20230228163453.GA11370@breakpoint.cc>
References: <20230224184606.7101-1-fw@strlen.de>
 <20230227152741.4a53634b@kernel.org>
 <0650079e-2cc1-626b-ac04-2230b41fd842@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0650079e-2cc1-626b-ac04-2230b41fd842@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexander Lobakin <aleksander.lobakin@intel.com> wrote:
> From: Jakub Kicinski <kuba@kernel.org>
> Date: Mon, 27 Feb 2023 15:27:41 -0800
> 
> > On Fri, 24 Feb 2023 19:46:06 +0100 Florian Westphal wrote:
> >> There is a noticeable tcp performance regression (loopback or cross-netns),
> >> seen with iperf3 -Z (sendfile mode) when generic retpolines are needed.
> >>
> >> With SK_RECLAIM_THRESHOLD checks gone number of calls to enter/leave
> >> memory pressure happen much more often. For TCP indirect calls are
> >> used.
> >>
> >> We can't remove the if-set-return short-circuit check in
> >> tcp_enter_memory_pressure because there are callers other than
> >> sk_enter_memory_pressure.  Doing a check in the sk wrapper too
> >> reduces the indirect calls enough to recover some performance.
> >>
> >> Before,
> >> 0.00-60.00  sec   322 GBytes  46.1 Gbits/sec                  receiver
> >>
> >> After:
> >> 0.00-60.04  sec   359 GBytes  51.4 Gbits/sec                  receiver
> >>
> >> "iperf3 -c $peer -t 60 -Z -f g", connected via veth in another netns.
> >>
> >> Fixes: 4890b686f408 ("net: keep sk->sk_forward_alloc as small as possible")
> >> Signed-off-by: Florian Westphal <fw@strlen.de>
> > 
> > Looks acceptable, Eric?
> > 
> I'm no Eric, but I'd only change this:
> 
> +	if (!memory_pressure || READ_ONCE(*memory_pressure) == 0)
> 
> to
> 
> +	if (!memory_pressure || !READ_ONCE(*memory_pressure))

I intentioanlly used '== 0', i found it too easy to miss the '!' before
'R'.  But maybe I just need better glasses.
