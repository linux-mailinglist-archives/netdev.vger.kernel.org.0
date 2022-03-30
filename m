Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0782F4EC5D3
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 15:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346227AbiC3NnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 09:43:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346174AbiC3Nmu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 09:42:50 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAC442253D;
        Wed, 30 Mar 2022 06:41:03 -0700 (PDT)
Date:   Wed, 30 Mar 2022 15:40:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1648647661;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=URUSnCfet5e8NJSvpD2xln45464mTe5fGEeiA24K6+I=;
        b=CMTqNe0Ft63H1B1W2ZKhVzkk8skP0+B/bwHc/fHamUvnXGPAXecVuz6bp/pIwiJvRGXQfX
        5ovppTkkCG+SxexafagScZsN3Odewj/zkqS/OGxS7FIRnzuryp2Wi+2hnVA+CeuVYCLZZj
        WJAXrmvvNlcc03Jj5NnWJqaR3c/1VDn70EuOxspydTTaKxHJnWNgn2TZIdlOKg1svWpAMn
        IJTK8/FUa0+C2HjqSCdYYkKQ8514GrElYBWW/oRGuNRh2coIxlx+CM7GOSKRkQXSPHCzd3
        V/SbKP9b6qYM6tCo6EibQLGJanYPUWBZ2N3LPtNlWNd65h+JyGY3dBMEtw5PZQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1648647661;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=URUSnCfet5e8NJSvpD2xln45464mTe5fGEeiA24K6+I=;
        b=LCrs2EK7xnDDzGIlyUzmvDbTXueTgY6RJHkf7LeQutVECEzdxpLKK5UJoDfCtrr43NcPrj
        h0uAKrrrChlv0pDg==
From:   Anna-Maria Behnsen <anna-maria@linutronix.de>
To:     Artem Savkov <asavkov@redhat.com>
cc:     netdev@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Josh Poimboeuf <jpoimboe@redhat.com>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] timer: add a function to adjust timeouts to be
 upper bound
In-Reply-To: <20220330082046.3512424-2-asavkov@redhat.com>
Message-ID: <alpine.DEB.2.21.2203301514570.4409@somnus>
References: <87zglcfmcv.ffs@tglx> <20220330082046.3512424-1-asavkov@redhat.com> <20220330082046.3512424-2-asavkov@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Mar 2022, Artem Savkov wrote:

> Current timer wheel implementation is optimized for performance and
> energy usage but lacks in precision. This, normally, is not a problem as
> most timers that use timer wheel are used for timeouts and thus rarely
> expire, instead they often get canceled or modified before expiration.
> Even when they don't, expiring a bit late is not an issue for timeout
> timers.
> 
> TCP keepalive timer is a special case, it's aim is to prevent timeouts,
> so triggering earlier rather than later is desired behavior. In a
> reported case the user had a 3600s keepalive timer for preventing firewall
> disconnects (on a 3650s interval). They observed keepalive timers coming
> in up to four minutes late, causing unexpected disconnects.
> 
> This commit adds upper_bound_timeout() function that takes a relative
> timeout and adjusts it based on timer wheel granularity so that supplied
> value effectively becomes an upper bound for the timer.
> 

I think there is a problem with this approach. Please correct me, if I'm
wrong. The timer wheel index and level calculation depends on
timer_base::clk. The timeout/delta which is used for this calculation is
relative to timer_base::clk (delta = expires - base::clk). timer_base::clk
is not updated in sync with jiffies. It is forwarded before a new timer is
queued. It is possible, that timer_base::clk is behind jiffies after
forwarding because of a not yet expired timer.

When calculating the level/index with a relative timeout, there is no
guarantee that the result is the same when actual enqueueing the timer with
expiry = jiffies + timeout .

Thanks,

	Anna-Maria

