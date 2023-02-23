Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D83B06A0E7E
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 18:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbjBWROu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 12:14:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbjBWROq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 12:14:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF40058B5E;
        Thu, 23 Feb 2023 09:14:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1429861730;
        Thu, 23 Feb 2023 17:14:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A92D4C433EF;
        Thu, 23 Feb 2023 17:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677172472;
        bh=x8N8/5LVobu3IXMwbblz267vMr2GCiwLlkT8WTPQP9M=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=RYyi6g4qSl4RhOsjMuzc3djlrnir45c9kHFKHOXCZmmdljNCvUWboi7xdWh+cBcug
         pwnrkkhavx1Jhntb9hT0bB9rK6zwqhjeVROMYJfZRLMO6TFvcWpDt+hV0rMU9DhYbI
         F98/IGijMh2JR0ZqW7GzNv89GVuabulOqvw1zLXcNiaDpXGmdbBmijZ2aV0CYW3Jlf
         rrv5HECGgN7vM/X9dHuzb3R9GLwnC/s8vH8XpXy+fC/Q9SnJqGQwtA2OT6UKbmXbrk
         ze/nJqxO27ukYEAyjX9QJ/Ep7byk3+HxX4oEtlFMkWup9g5XDWls1ItCPSDxLya/5j
         /WY61BpZNq3hw==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 5994C5C0DBB; Thu, 23 Feb 2023 09:14:32 -0800 (PST)
Date:   Thu, 23 Feb 2023 09:14:32 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Julian Anastasov <ja@ssi.bg>
Cc:     "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        "Uladzislau Rezki (Sony)" <urezki@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, RCU <rcu@vger.kernel.org>,
        Oleksiy Avramchenko <oleksiy.avramchenko@sony.com>,
        Jens Axboe <axboe@kernel.dk>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Bryan Tan <bryantan@vmware.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Eric Dumazet <edumazet@google.com>,
        Bob Pearson <rpearsonhpe@gmail.com>,
        Ariel Levkovich <lariel@nvidia.com>,
        Theodore Ts'o <tytso@mit.edu>, pablo@netfilter.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 00/13] Rename k[v]free_rcu() single argument to
 k[v]free_rcu_mightsleep()
Message-ID: <20230223171432.GC2948950@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20230201150815.409582-1-urezki@gmail.com>
 <Y/df4xtTQ14w/2m4@lothringen>
 <IA1PR11MB6171CE257AC58265B8B7CC9889AB9@IA1PR11MB6171.namprd11.prod.outlook.com>
 <20230223155415.GA2948950@paulmck-ThinkPad-P17-Gen-1>
 <44eeb053-addd-263e-90d3-131598cfef6c@ssi.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <44eeb053-addd-263e-90d3-131598cfef6c@ssi.bg>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 23, 2023 at 06:21:46PM +0200, Julian Anastasov wrote:
> 
> 	Hello,
> 
> On Thu, 23 Feb 2023, Paul E. McKenney wrote:
> 
> > > > Not sure if you guys noticed but on latest rcu/dev:
> > > > 
> > > > net/netfilter/ipvs/ip_vs_est.c: In function ‘ip_vs_stop_estimator’:
> > > > net/netfilter/ipvs/ip_vs_est.c:552:15: error: macro "kfree_rcu" requires 2
> > > > arguments, but only 1 given
> > > >    kfree_rcu(td);
> > > >                ^
> > > > net/netfilter/ipvs/ip_vs_est.c:552:3: error: ‘kfree_rcu’ undeclared (first use in
> > > > this function); did you mean ‘kfree_skb’?
> > > >    kfree_rcu(td);
> > > >    ^~~~~~~~~
> > > >    kfree_skb
> > > > net/netfilter/ipvs/ip_vs_est.c:552:3: note: each undeclared identifier is
> > > > reported only once for each function it appears in
> > > 
> > > Hi Frederic Weisbecker,
> > > 
> > > I encountered the same build error as yours. 
> > > Per the discussion link below, the fix for this build error by Uladzislau Rezki will be picked up by some other maintainer's branch?
> > > @Paul E . McKenney, please correct me if my understanding is wrong. 😊
> > > 
> > >     https://lore.kernel.org/rcu/Y9qc+lgR1CgdszKs@salvia/
> > 
> > Pablo and Julian, how are things coming with that patch?
> 
> 	Fix is already in net and net-next tree

Very good, thank you!  Is this going into this merge window or is it
expected to wait for v6.4?

							Thanx, Paul
