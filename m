Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF26C6A0DC9
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 17:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234119AbjBWQWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 11:22:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233926AbjBWQWF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 11:22:05 -0500
Received: from mg.ssi.bg (mg.ssi.bg [193.238.174.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AD9EB1E1E4;
        Thu, 23 Feb 2023 08:22:02 -0800 (PST)
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.ssi.bg (Proxmox) with ESMTP id 5896F814C2;
        Thu, 23 Feb 2023 18:21:56 +0200 (EET)
Received: from ink.ssi.bg (unknown [193.238.174.40])
        by mg.ssi.bg (Proxmox) with ESMTP id 601678158D;
        Thu, 23 Feb 2023 18:21:54 +0200 (EET)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id 09AB63C0440;
        Thu, 23 Feb 2023 18:21:49 +0200 (EET)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.17.1/8.16.1) with ESMTP id 31NGLkbs097921;
        Thu, 23 Feb 2023 18:21:46 +0200
Date:   Thu, 23 Feb 2023 18:21:46 +0200 (EET)
From:   Julian Anastasov <ja@ssi.bg>
To:     "Paul E. McKenney" <paulmck@kernel.org>
cc:     "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>,
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
        "Theodore Ts'o" <tytso@mit.edu>, pablo@netfilter.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 00/13] Rename k[v]free_rcu() single argument to
 k[v]free_rcu_mightsleep()
In-Reply-To: <20230223155415.GA2948950@paulmck-ThinkPad-P17-Gen-1>
Message-ID: <44eeb053-addd-263e-90d3-131598cfef6c@ssi.bg>
References: <20230201150815.409582-1-urezki@gmail.com> <Y/df4xtTQ14w/2m4@lothringen> <IA1PR11MB6171CE257AC58265B8B7CC9889AB9@IA1PR11MB6171.namprd11.prod.outlook.com> <20230223155415.GA2948950@paulmck-ThinkPad-P17-Gen-1>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="-1463811672-745359525-1677169308=:6653"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811672-745359525-1677169308=:6653
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT


	Hello,

On Thu, 23 Feb 2023, Paul E. McKenney wrote:

> > > Not sure if you guys noticed but on latest rcu/dev:
> > > 
> > > net/netfilter/ipvs/ip_vs_est.c: In function ‘ip_vs_stop_estimator’:
> > > net/netfilter/ipvs/ip_vs_est.c:552:15: error: macro "kfree_rcu" requires 2
> > > arguments, but only 1 given
> > >    kfree_rcu(td);
> > >                ^
> > > net/netfilter/ipvs/ip_vs_est.c:552:3: error: ‘kfree_rcu’ undeclared (first use in
> > > this function); did you mean ‘kfree_skb’?
> > >    kfree_rcu(td);
> > >    ^~~~~~~~~
> > >    kfree_skb
> > > net/netfilter/ipvs/ip_vs_est.c:552:3: note: each undeclared identifier is
> > > reported only once for each function it appears in
> > 
> > Hi Frederic Weisbecker,
> > 
> > I encountered the same build error as yours. 
> > Per the discussion link below, the fix for this build error by Uladzislau Rezki will be picked up by some other maintainer's branch?
> > @Paul E . McKenney, please correct me if my understanding is wrong. 😊
> > 
> >     https://lore.kernel.org/rcu/Y9qc+lgR1CgdszKs@salvia/
> 
> Pablo and Julian, how are things coming with that patch?

	Fix is already in net and net-next tree

Regards

--
Julian Anastasov <ja@ssi.bg>
---1463811672-745359525-1677169308=:6653--

