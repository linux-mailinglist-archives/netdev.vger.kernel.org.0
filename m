Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F16036A0F59
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 19:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbjBWSVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 13:21:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbjBWSVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 13:21:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CA4D3B642;
        Thu, 23 Feb 2023 10:21:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92E1761765;
        Thu, 23 Feb 2023 18:21:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EEAAC433EF;
        Thu, 23 Feb 2023 18:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677176478;
        bh=Z7RRnRbJMC5RM6H9BOJWIyI0wW53Cdr0QPKVWXGAujw=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=HK+Et9seIM7wjQY5lfEsDdtqJqk/j1u0Fmkd9zBoSHOVwERDV4yomv/JKcn/eeP3T
         oJZLWcnQodp0rQE57hmmpHiu+WskY5qlD+MCxDWxtNF2oTYbZFEG9aJWmDYLjsUMsr
         sSHn/T75b9140NNUM46PUbaOaQywN7IpckLaBAnEtzqKB/Qo5C7spWVlcreAAt32p/
         /72SivgU14ZPUgF1U5tpQRVB8pIZ7Hue3tshN3rDswJ5C78lCBxZypgmDtgRsWk+4w
         b2C5s0DBtzGmLfBaDvi5eoRQtW+UK0k9yEpqG911BjMwBQLOyDwaGxp9xRWMowbgYy
         Xs/RjdU+3VPGw==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id A780A5C0DBB; Thu, 23 Feb 2023 10:21:17 -0800 (PST)
Date:   Thu, 23 Feb 2023 10:21:17 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Julian Anastasov <ja@ssi.bg>, "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>,
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
        Theodore Ts'o <tytso@mit.edu>, netdev@vger.kernel.org
Subject: Re: [PATCH 00/13] Rename k[v]free_rcu() single argument to
 k[v]free_rcu_mightsleep()
Message-ID: <20230223182117.GE2948950@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20230201150815.409582-1-urezki@gmail.com>
 <Y/df4xtTQ14w/2m4@lothringen>
 <IA1PR11MB6171CE257AC58265B8B7CC9889AB9@IA1PR11MB6171.namprd11.prod.outlook.com>
 <20230223155415.GA2948950@paulmck-ThinkPad-P17-Gen-1>
 <44eeb053-addd-263e-90d3-131598cfef6c@ssi.bg>
 <20230223171432.GC2948950@paulmck-ThinkPad-P17-Gen-1>
 <Y/ekGgkUWAKeGfbO@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y/ekGgkUWAKeGfbO@salvia>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 23, 2023 at 06:36:26PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Feb 23, 2023 at 09:14:32AM -0800, Paul E. McKenney wrote:
> > On Thu, Feb 23, 2023 at 06:21:46PM +0200, Julian Anastasov wrote:
> > > 
> > > 	Hello,
> > > 
> > > On Thu, 23 Feb 2023, Paul E. McKenney wrote:
> > > 
> > > > > > Not sure if you guys noticed but on latest rcu/dev:
> > > > > > 
> > > > > > net/netfilter/ipvs/ip_vs_est.c: In function ‘ip_vs_stop_estimator’:
> > > > > > net/netfilter/ipvs/ip_vs_est.c:552:15: error: macro "kfree_rcu" requires 2
> > > > > > arguments, but only 1 given
> > > > > >    kfree_rcu(td);
> > > > > >                ^
> > > > > > net/netfilter/ipvs/ip_vs_est.c:552:3: error: ‘kfree_rcu’ undeclared (first use in
> > > > > > this function); did you mean ‘kfree_skb’?
> > > > > >    kfree_rcu(td);
> > > > > >    ^~~~~~~~~
> > > > > >    kfree_skb
> > > > > > net/netfilter/ipvs/ip_vs_est.c:552:3: note: each undeclared identifier is
> > > > > > reported only once for each function it appears in
> > > > > 
> > > > > Hi Frederic Weisbecker,
> > > > > 
> > > > > I encountered the same build error as yours. 
> > > > > Per the discussion link below, the fix for this build error by Uladzislau Rezki will be picked up by some other maintainer's branch?
> > > > > @Paul E . McKenney, please correct me if my understanding is wrong. 😊
> > > > > 
> > > > >     https://lore.kernel.org/rcu/Y9qc+lgR1CgdszKs@salvia/
> > > > 
> > > > Pablo and Julian, how are things coming with that patch?
> > > 
> > > 	Fix is already in net and net-next tree
> > 
> > Very good, thank you!  Is this going into this merge window or is it
> > expected to wait for v6.4?
> 
> this merge window. 							Thanx, Paul

Thank you, and looking forward to it!

								Thanx, Paul
