Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B750C1C731A
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 16:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729217AbgEFOly (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 10:41:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:43626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729181AbgEFOlw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 10:41:52 -0400
Received: from paulmck-ThinkPad-P72.home (50-39-105-78.bvtn.or.frontiernet.net [50.39.105.78])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 002D920836;
        Wed,  6 May 2020 14:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588776112;
        bh=O3LspY81ApWe1Iq+AqJ0X2EUV2ZVKqQhPFqaiCs4ILI=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=Ek/Ios8sbnUGAl4FTAV3pJyGZgasnE9YxGPtG+67Q0R7KYyZMJukCv+ENy9bLUZFQ
         bhKpISS+lmAXCIODlGZBWXZSSd4TteVaO/KWFz8KhcVBNNFXO2qv9G5cAtM+zoGdwU
         +y9UJXxGWC2L/q0AUGWLIPzDmmD97n0QjFL1iIJI=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id DCDEA35227D0; Wed,  6 May 2020 07:41:51 -0700 (PDT)
Date:   Wed, 6 May 2020 07:41:51 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     SeongJae Park <sjpark@amazon.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        sj38.park@gmail.com, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        SeongJae Park <sjpark@amazon.de>, snu@amazon.com,
        amit@kernel.org, stable@vger.kernel.org
Subject: Re: Re: Re: Re: Re: [PATCH net v2 0/2] Revert the 'socket_alloc'
 life cycle change
Message-ID: <20200506144151.GZ2869@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20200505184955.GO2869@paulmck-ThinkPad-P72>
 <20200506125926.29844-1-sjpark@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200506125926.29844-1-sjpark@amazon.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 06, 2020 at 02:59:26PM +0200, SeongJae Park wrote:
> TL; DR: It was not kernel's fault, but the benchmark program.
> 
> So, the problem is reproducible using the lebench[1] only.  I carefully read
> it's code again.
> 
> Before running the problem occurred "poll big" sub test, lebench executes
> "context switch" sub test.  For the test, it sets the cpu affinity[2] and
> process priority[3] of itself to '0' and '-20', respectively.  However, it
> doesn't restore the values to original value even after the "context switch" is
> finished.  For the reason, "select big" sub test also run binded on CPU 0 and
> has lowest nice value.  Therefore, it can disturb the RCU callback thread for
> the CPU 0, which processes the deferred deallocations of the sockets, and as a
> result it triggers the OOM.
> 
> We confirmed the problem disappears by offloading the RCU callbacks from the
> CPU 0 using rcu_nocbs=0 boot parameter or simply restoring the affinity and/or
> priority.
> 
> Someone _might_ still argue that this is kernel problem because the problem
> didn't occur on the old kernels prior to the Al's patches.  However, setting
> the affinity and priority was available because the program received the
> permission.  Therefore, it would be reasonable to blame the system
> administrators rather than the kernel.
> 
> So, please ignore this patchset, apology for making confuse.  If you still has
> some doubts or need more tests, please let me know.
> 
> [1] https://github.com/LinuxPerfStudy/LEBench
> [2] https://github.com/LinuxPerfStudy/LEBench/blob/master/TEST_DIR/OS_Eval.c#L820
> [3] https://github.com/LinuxPerfStudy/LEBench/blob/master/TEST_DIR/OS_Eval.c#L822

Thank you for chasing this down!

I have had this sort of thing on my list as a potential issue, but given
that it is now really showing up, it sounds like it is time to bump
up its priority a bit.  Of course there are limits, so if userspace is
running at any of the real-time priorities, making sufficient CPU time
available to RCU's kthreads becomes userspace's responsibility.  But if
everything is running at SCHED_OTHER (which is this case here, correct?),
then it is reasonable for RCU to do some work to avoid this situation.

But still, yes, the immediate job is fixing the benchmark.  ;-)

							Thanx, Paul

PS.  Why not just attack all potential issues on my list?  Because I
     usually learn quite a bit from seeing the problem actually happen.
     And sometimes other changes in RCU eliminate the potential issue
     before it has a chance to happen.
