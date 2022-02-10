Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4B914B150A
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 19:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245598AbiBJSNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 13:13:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239730AbiBJSNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 13:13:34 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5357B1167;
        Thu, 10 Feb 2022 10:13:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A58B1CE2625;
        Thu, 10 Feb 2022 18:13:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D31FC340EB;
        Thu, 10 Feb 2022 18:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644516811;
        bh=g7jIMKjk4AjtcIO0QzOSIrmNcehM6ru1WwL4Z6HKvOo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YooH2w9Njl6oOOavP1PlxNX22+HMHk21uA9nPlCZJzG+Gq1PhNx4C8B1mFnbHSLuF
         S2ZZsl9g3gC0c8xUJLPjYggjK46wMPOf5z07H2Ol1L2LBPcp1M1sP0P5D0mpMeBGJE
         kBEnbmODhitoAnZrz49xAnDRWG9sWMG1Qq4SjxkjKlCTyb8l+ENc26vYsub2d+Ozyq
         +tAIEUBYs2aTH2BWx2DKwOVGTQT/7Dl2UCtr+Nt5mYjFpCpWL5zafajBG/d69AhXGb
         axabZEwfPtvSR5e28ZFEdDACbKlA2s/8e8w89dLH1fvOz6lEraSsvDuGcR/cBuPqQp
         UCGdcaBbfMk+g==
Date:   Thu, 10 Feb 2022 10:13:30 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNl?= =?UTF-8?B?bg==?= 
        <toke@toke.dk>
Subject: Re: [PATCH net-next v2 2/3] net: dev: Makes sure netif_rx() can be
 invoked in any context.
Message-ID: <20220210101330.47165ae0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YgUDiE4FTsdwdVSH@linutronix.de>
References: <20220204201259.1095226-1-bigeasy@linutronix.de>
        <20220204201259.1095226-3-bigeasy@linutronix.de>
        <20220204201715.44f48f4f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <Yf7ftf+6j52opu5w@linutronix.de>
        <20220207084717.5b7126e7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YgUDiE4FTsdwdVSH@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Feb 2022 13:22:32 +0100 Sebastian Andrzej Siewior wrote:
> On 2022-02-07 08:47:17 [-0800], Jakub Kicinski wrote:
> > On Sat, 5 Feb 2022 21:36:05 +0100 Sebastian Andrzej Siewior wrote:  
> > > Don't we end up in the same situation as netif_rx() vs netix_rx_ni()?  
> > 
> > Sort of. TBH my understanding of the motivation is a bit vague.
> > IIUC you want to reduce the API duplication so drivers know what to
> > do[1]. I believe the quote from Eric you put in the commit message
> > pertains to HW devices, where using netif_rx() is quite anachronistic. 
> > But software devices like loopback, veth or tunnels may want to go via
> > backlog for good reasons. Would it make it better if we called
> > netif_rx() netif_rx_backlog() instead? Or am I missing the point?  
> 
> So we do netif_rx_backlog() with the bh disable+enable and
> __netif_rx_backlog() without it and export both tree wide?

At a risk of confusing people about the API we could also name the
"non-super-optimized" version netif_rx(), like you had in your patch.
Grepping thru the drivers there's ~250 uses so maybe we don't wanna
touch all that code. No strong preference, I just didn't expect to 
see __netif_rx_backlog(), but either way works.

> It would make it more obvious indeed. Could we add
> 	WARN_ON_ONCE(!(hardirq_count() | softirq_count()))
> to the shortcut to catch the "you did it wrong folks"? This costs me
> about 2ns.

Modulo lockdep_..(), so we don't have to run this check on prod kernels?

> TL;DR
> 
> The netix_rx_ni() is problematic on RT and I tried to do something about
> it. I remembered from the in_atomic() cleanup that a few drivers got it
> wrong (one way or another). We added also netif_rx_any_context() which
> is used by some of the drivers (which is yet another entry point) while
> the few other got fixed.
> Then I stumbled over the thread where the entry (netif_rx() vs
> netif_rx_ni()) was wrong and Dave suggested to have one entry point for
> them all. This sounded like a good idea since it would eliminate the
> several API entry points where things can go wrong and my RT trouble
> would vanish in one go.
> The part with deprecated looked promising but I didn't take into account
> that the overhead for legitimate users (like the backlog or the software
> tunnels you mention) is not acceptable.

I see. So IIUC primary motivation is replacing preempt disable with bh
disable but the cleanup seemed like a good idea.
