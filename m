Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2F6362FFFC
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 23:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231949AbiKRWX2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 17:23:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231771AbiKRWXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 17:23:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8000B483B;
        Fri, 18 Nov 2022 14:22:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 573EC627AB;
        Fri, 18 Nov 2022 22:22:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A99D0C433D7;
        Fri, 18 Nov 2022 22:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668810154;
        bh=a3Nl+YrArqrTu2MTpdS0izGKQlH4Fq++iKt1qyZa3+Y=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=gp2/kZJpsVukVoT67G8faL/czaxkOfRGsVmGCzE0ikD3icNUwtJER8U7RaZEIQhHN
         2I+caJbL8GbpnMvvwYZI49bu4DdPoW9zj3VsSaSUv7f9ar5OAbBg/uungjiqUSYNpa
         wlkrnW6AxwPZ2mRjtv0ovM/YWM7w4LC67KB7vdifNuArXjR85kbcaWabe5DLz903Jz
         OHYqxkmHJRnxlnB7Vu4+wv6nHorbDGro/580kZF3atWQ3jwsSdwFetkiK+xp0N+hWR
         7T4zNAFoGdvkjeepfvMUwgbOMB654sfGBy0Sy/jVhrzd7o6QZaXlGwevBmMHbO8Mkq
         g876Gu9uKtMeQ==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 4BD435C0F9C; Fri, 18 Nov 2022 14:22:34 -0800 (PST)
Date:   Fri, 18 Nov 2022 14:22:34 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, rcu@vger.kernel.org,
        rostedt@goodmis.org, fweisbec@gmail.com
Subject: Re: [PATCH v2 1/2] net: Use call_rcu_flush() for dst_destroy_rcu
Message-ID: <20221118222234.GP4001@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20221118191909.1756624-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221118191909.1756624-1-joel@joelfernandes.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 18, 2022 at 07:19:08PM +0000, Joel Fernandes (Google) wrote:
> In a networking test on ChromeOS, we find that using the new
> CONFIG_RCU_LAZY causes a networking test to fail in the teardown phase.
> 
> The failure happens during: ip netns del <name>
> 
> Using ftrace, I found the callbacks it was queuing which this series fixes.
> Use call_rcu_flush() to revert to the old behavior. With that, the test
> passes.
> 
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>

Queued and pushed, wordsmithed as shown below, thank you!

							Thanx, Paul

------------------------------------------------------------------------

commit dee2cd7a0d6f3274bdcfe902cf7914b9553355b3
Author: Joel Fernandes (Google) <joel@joelfernandes.org>
Date:   Fri Nov 18 19:19:08 2022 +0000

    net: Use call_rcu_flush() for dst_release()
    
    In a networking test on ChromeOS, kernels built with the new
    CONFIG_RCU_LAZY=y Kconfig option fail a networking test in the teardown
    phase.
    
    This failure may be reproduced as follows: ip netns del <name>
    
    The CONFIG_RCU_LAZY=y Kconfig option was introduced by earlier commits
    in this series for the benefit of certain battery-powered systems.
    This Kconfig option causes call_rcu() to delay its callbacks in order
    to batch them.  This means that a given RCU grace period covers more
    callbacks, thus reducing the number of grace periods, in turn reducing
    the amount of energy consumed, which increases battery lifetime which
    can be a very good thing.  This is not a subtle effect: In some important
    use cases, the battery lifetime is increased by more than 10%.
    
    This CONFIG_RCU_LAZY=y option is available only for CPUs that offload
    callbacks, for example, CPUs mentioned in the rcu_nocbs kernel boot
    parameter passed to kernels built with CONFIG_RCU_NOCB_CPU=y.
    
    Delaying callbacks is normally not a problem because most callbacks do
    nothing but free memory.  If the system is short on memory, a shrinker
    will kick all currently queued lazy callbacks out of their laziness,
    thus freeing their memory in short order.  Similarly, the rcu_barrier()
    function, which blocks until all currently queued callbacks are invoked,
    will also kick lazy callbacks, thus enabling rcu_barrier() to complete
    in a timely manner.
    
    However, there are some cases where laziness is not a good option.
    For example, synchronize_rcu() invokes call_rcu(), and blocks until
    the newly queued callback is invoked.  It would not be a good for
    synchronize_rcu() to block for ten seconds, even on an idle system.
    Therefore, synchronize_rcu() invokes call_rcu_flush() instead of
    call_rcu().  The arrival of a non-lazy call_rcu_flush() callback on a
    given CPU kicks any lazy callbacks that might be already queued on that
    CPU.  After all, if there is going to be a grace period, all callbacks
    might as well get full benefit from it.
    
    Yes, this could be done the other way around by creating a
    call_rcu_lazy(), but earlier experience with this approach and
    feedback at the 2022 Linux Plumbers Conference shifted the approach
    to call_rcu() being lazy with call_rcu_flush() for the few places
    where laziness is inappropriate.
    
    Returning to the test failure, use of ftrace showed that this failure
    cause caused by the aadded delays due to this new lazy behavior of
    call_rcu() in kernels built with CONFIG_RCU_LAZY=y.
    
    Therefore, make dst_release() use call_rcu_flush() in order to revert
    to the old test-failure-free behavior.
    
    Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
    Cc: David Ahern <dsahern@kernel.org>
    Cc: "David S. Miller" <davem@davemloft.net>
    Cc: Eric Dumazet <edumazet@google.com>
    Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
    Cc: Jakub Kicinski <kuba@kernel.org>
    Cc: Paolo Abeni <pabeni@redhat.com>
    Cc: <netdev@vger.kernel.org>
    Signed-off-by: Paul E. McKenney <paulmck@kernel.org>

diff --git a/net/core/dst.c b/net/core/dst.c
index bc9c9be4e0801..15b16322703f4 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -174,7 +174,7 @@ void dst_release(struct dst_entry *dst)
 			net_warn_ratelimited("%s: dst:%p refcnt:%d\n",
 					     __func__, dst, newrefcnt);
 		if (!newrefcnt)
-			call_rcu(&dst->rcu_head, dst_destroy_rcu);
+			call_rcu_flush(&dst->rcu_head, dst_destroy_rcu);
 	}
 }
 EXPORT_SYMBOL(dst_release);
