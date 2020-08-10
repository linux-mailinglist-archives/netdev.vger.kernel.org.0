Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9FBF2411B0
	for <lists+netdev@lfdr.de>; Mon, 10 Aug 2020 22:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbgHJU2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 16:28:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:34538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726115AbgHJU2O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Aug 2020 16:28:14 -0400
Received: from paulmck-ThinkPad-P72.home (unknown [50.45.173.55])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63E5020656;
        Mon, 10 Aug 2020 20:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597091293;
        bh=0qCcDDdqvq7MmBz1rKwxKEcVVJ+fIqo798TVED26pq4=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=PbuCImz/jibJeNVI82Y20VRff8MVtMqK8pGzWWXgC2wpe1ClnmG+Kriq8yuSVf8Pe
         u9AnqXHjqI/gYNoNkt1+KPL4Q6QtEzlf7lojSONg/7NjKQizpc44Q9UByTndMyFT3F
         r5gdfdzy9xj2zpzz5YuJbIOVJnWgcKyJ2Jnkq4m4=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 37D4235228C7; Mon, 10 Aug 2020 13:28:13 -0700 (PDT)
Date:   Mon, 10 Aug 2020 13:28:13 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     Johan =?iso-8859-1?B?S2729nM=?= <jknoos@google.com>,
        Gregory Rose <gvrose8192@gmail.com>, bugs@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Netdev <netdev@vger.kernel.org>,
        "Uladzislau Rezki (Sony)" <urezki@gmail.com>,
        rcu <rcu@vger.kernel.org>
Subject: Re: [ovs-discuss] Double free in recent kernels after memleak fix
Message-ID: <20200810202813.GP4295@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <CA+Sh73MJhqs7PBk6OV2AhzVjYvE1foUQUnwP5DwWR44LHZRZ9w@mail.gmail.com>
 <58be64c5-9ae4-95ff-629e-f55e47ff020b@gmail.com>
 <CA+Sh73NeNr+UNZYDfD1nHUXCY-P8mT1vJdm0cEY4MPwo_0PtzQ@mail.gmail.com>
 <CAEXW_YSSL5+_DjtrYpFp35kGrem782nBF6HuVbgWJ_H3=jeX4A@mail.gmail.com>
 <20200807222015.GZ4295@paulmck-ThinkPad-P72>
 <20200810200859.GF2865655@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200810200859.GF2865655@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 10, 2020 at 04:08:59PM -0400, Joel Fernandes wrote:
> On Fri, Aug 07, 2020 at 03:20:15PM -0700, Paul E. McKenney wrote:
> > On Fri, Aug 07, 2020 at 04:47:56PM -0400, Joel Fernandes wrote:
> > > Hi,
> > > Adding more of us working on RCU as well. Johan from another team at
> > > Google discovered a likely issue in openswitch, details below:
> > > 
> > > On Fri, Aug 7, 2020 at 11:32 AM Johan Knöös <jknoos@google.com> wrote:
> > > > On Tue, Aug 4, 2020 at 8:52 AM Gregory Rose <gvrose8192@gmail.com> wrote:
> > > > > On 8/3/2020 12:01 PM, Johan Knöös via discuss wrote:
> > > > > > Hi Open vSwitch contributors,
> > > > > >
> > > > > > We have found openvswitch is causing double-freeing of memory. The
> > > > > > issue was not present in kernel version 5.5.17 but is present in
> > > > > > 5.6.14 and newer kernels.
> > > > > >
> > > > > > After reverting the RCU commits below for debugging, enabling
> > > > > > slub_debug, lockdep, and KASAN, we see the warnings at the end of this
> > > > > > email in the kernel log (the last one shows the double-free). When I
> > > > > > revert 50b0e61b32ee890a75b4377d5fbe770a86d6a4c1 ("net: openvswitch:
> > > > > > fix possible memleak on destroy flow-table"), the symptoms disappear.
> > > > > > While I have a reliable way to reproduce the issue, I unfortunately
> > > > > > don't yet have a process that's amenable to sharing. Please take a
> > > > > > look.
> > > > > >
> > > > > > 189a6883dcf7 rcu: Remove kfree_call_rcu_nobatch()
> > > > > > 77a40f97030b rcu: Remove kfree_rcu() special casing and lazy-callback handling
> > > > > > e99637becb2e rcu: Add support for debug_objects debugging for kfree_rcu()
> > > > > > 0392bebebf26 rcu: Add multiple in-flight batches of kfree_rcu() work
> > > > > > 569d767087ef rcu: Make kfree_rcu() use a non-atomic ->monitor_todo
> > > > > > a35d16905efc rcu: Add basic support for kfree_rcu() batching
> > > 
> > > Note that these reverts were only for testing the same code, because
> > > he was testing 2 different kernel versions. One of them did not have
> > > this set. So I asked him to revert. There's no known bug in the
> > > reverted code itself. But somehow these patches do make it harder for
> > > him to reproduce the issue.
> > 
> > Perhaps they adjust timing?
> 
> Yes that could be it. In my testing (which is unrelated to OVS), the issue
> happens only with TREE02. I can reproduce the issue in [1] on just boot-up of
> TREE02.
> 
> I could have screwed up something in my segcblist count patch, any hints
> would be great. I'll dig more into it as well.

Has anyone taken a close look at 50b0e61b32ee ("net: openvswitch: fix
possible memleak on destroy flow-table") commit?  Maybe it avoided the
memleak so thoroughly that it did a double free?

							Thanx, Paul

> > > But then again, I have not heard reports of this warning firing. Paul,
> > > has this come to your radar recently?
> > 
> > I have not seen any recent WARNs in rcu_do_batch().  I am guessing that
> > this is one of the last two in that function?
> > 
> > If so, have you tried using CONFIG_DEBUG_OBJECTS_RCU_HEAD=y?  That Kconfig
> > option is designed to help locate double frees via RCU.
> 
> Yes true, kfree_rcu() also has support for this. Jonathan, did you get a
> chance to try this out in your failure scenario?
> 
> thanks,
> 
>  - Joel
> 
> [1] https://lore.kernel.org/lkml/20200720005334.GC19262@shao2-debian/
