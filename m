Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09A806ABEDC
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 12:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbjCFL5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 06:57:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbjCFL5Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 06:57:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34DCAAD2E;
        Mon,  6 Mar 2023 03:57:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C484B60E92;
        Mon,  6 Mar 2023 11:57:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DC4BC433D2;
        Mon,  6 Mar 2023 11:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678103834;
        bh=V2f4K+aN43B8ow+BZJ85BfatEj+XJxLSPHVfm11BWPA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RDx1n3E9zeuOud9fAP5CLwnOhWd6/Kkymxdwe36oPp01T/+ZMwaGG6thrO4yEVHWB
         d5TEAgLvs5sSM8eTseIMIOMV/svIEUfguydJ/wodcLfj+XEOHs1RS1Wvw+crWe+338
         cmjdDYb4/5kjogxCxxrzHUNw0e85v0SBC3RgM4dzDPKyq/AdJ4qYihIeKf0JUjPbOm
         8cNFVHJ7TqJ9Yu3u/D2/9xKmbm5DWXngoru03CIjZTs0Z3XLl170HqCIabfiSbtrKH
         3TQvISBSmZ41UqZuy+Qvp0qsFvjUYt+UoV8PLorqh5YwKySOmr/LgiNrRILIL8kKLE
         qdSGSrHvdJfKA==
Date:   Mon, 6 Mar 2023 12:57:11 +0100
From:   Frederic Weisbecker <frederic@kernel.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Jakub Kicinski <kuba@kernel.org>, peterz@infradead.org,
        jstultz@google.com, edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH 2/3] softirq: avoid spurious stalls due to need_resched()
Message-ID: <ZAXVF0tPKLErAkpT@lothringen>
References: <20230303133143.7b35433f@kernel.org>
 <87r0u3hqtw.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r0u3hqtw.ffs@tglx>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 05, 2023 at 09:43:23PM +0100, Thomas Gleixner wrote:
> That said, I have no brilliant solution for that off the top of my head,
> but I'm not comfortable with applying more adhoc solutions which are
> contrary to the efforts of e.g. the audio folks.
> 
> I have some vague ideas how to approach that, but I'm traveling all of
> next week, so I neither will be reading much email, nor will I have time
> to think deeply about softirqs. I'll resume when I'm back.

IIUC: the problem is that some (rare?) softirq vector callbacks rely on the
fact they can not be interrupted by other local vectors and they rely on
that to protect against concurrent per-cpu state access, right?

And there is no automatic way to detect those cases otherwise we would have
fixed them all with spinlocks already.

So I fear the only (in-)sane idea I could think of is to do it the same way
we did with the BKL. Some sort of pushdown: vector callbacks known for having
no such subtle interaction can re-enable softirqs.

For example known safe timers (either because they have no such interactions
or because they handle them correctly via spinlocks) can carry a
TIMER_SOFTIRQ_SAFE flag to tell about that. And RCU callbacks something alike.

Of course this is going to be a tremendous amount of work but it has the
advantage of being iterative and it will pay in the long run. Also I'm confident
that the hottest places will be handled quickly. And most of them are likely to
be in core networking code.

Because I fear no hack will ever fix that otherwise, and we have tried a lot.

Thanks.
