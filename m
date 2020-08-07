Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70F7223F4D3
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 00:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726238AbgHGWUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 18:20:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:52416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726045AbgHGWUQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Aug 2020 18:20:16 -0400
Received: from paulmck-ThinkPad-P72.home (unknown [50.45.173.55])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C31622177B;
        Fri,  7 Aug 2020 22:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596838815;
        bh=Fm5/4RuQm0wDj6D+otx5tHEIW5qEfI5jVQNjzwNCMso=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=YUZZuOLAoeOlhwxJVG96PwhK+uS+rsTVcfzF+TYi8vINVqkBuOJ1VQTBF++3dGeAw
         3e3RH0CyKUQoSd4/Wyi8A6Si+KF9RW+Xdyb6iLTCrxZb014o2I8dKP3gPrfhgwveBq
         wKlfhiBO0WnS3mhkN54yeOIClqirC+CGeHh1dygM=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id A05043522BB6; Fri,  7 Aug 2020 15:20:15 -0700 (PDT)
Date:   Fri, 7 Aug 2020 15:20:15 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     Johan =?iso-8859-1?B?S2729nM=?= <jknoos@google.com>,
        Gregory Rose <gvrose8192@gmail.com>, bugs@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Netdev <netdev@vger.kernel.org>,
        "Uladzislau Rezki (Sony)" <urezki@gmail.com>,
        rcu <rcu@vger.kernel.org>
Subject: Re: [ovs-discuss] Double free in recent kernels after memleak fix
Message-ID: <20200807222015.GZ4295@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <CA+Sh73MJhqs7PBk6OV2AhzVjYvE1foUQUnwP5DwWR44LHZRZ9w@mail.gmail.com>
 <58be64c5-9ae4-95ff-629e-f55e47ff020b@gmail.com>
 <CA+Sh73NeNr+UNZYDfD1nHUXCY-P8mT1vJdm0cEY4MPwo_0PtzQ@mail.gmail.com>
 <CAEXW_YSSL5+_DjtrYpFp35kGrem782nBF6HuVbgWJ_H3=jeX4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEXW_YSSL5+_DjtrYpFp35kGrem782nBF6HuVbgWJ_H3=jeX4A@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 07, 2020 at 04:47:56PM -0400, Joel Fernandes wrote:
> Hi,
> Adding more of us working on RCU as well. Johan from another team at
> Google discovered a likely issue in openswitch, details below:
> 
> On Fri, Aug 7, 2020 at 11:32 AM Johan Knöös <jknoos@google.com> wrote:
> >
> > On Tue, Aug 4, 2020 at 8:52 AM Gregory Rose <gvrose8192@gmail.com> wrote:
> > >
> > >
> > >
> > > On 8/3/2020 12:01 PM, Johan Knöös via discuss wrote:
> > > > Hi Open vSwitch contributors,
> > > >
> > > > We have found openvswitch is causing double-freeing of memory. The
> > > > issue was not present in kernel version 5.5.17 but is present in
> > > > 5.6.14 and newer kernels.
> > > >
> > > > After reverting the RCU commits below for debugging, enabling
> > > > slub_debug, lockdep, and KASAN, we see the warnings at the end of this
> > > > email in the kernel log (the last one shows the double-free). When I
> > > > revert 50b0e61b32ee890a75b4377d5fbe770a86d6a4c1 ("net: openvswitch:
> > > > fix possible memleak on destroy flow-table"), the symptoms disappear.
> > > > While I have a reliable way to reproduce the issue, I unfortunately
> > > > don't yet have a process that's amenable to sharing. Please take a
> > > > look.
> > > >
> > > > 189a6883dcf7 rcu: Remove kfree_call_rcu_nobatch()
> > > > 77a40f97030b rcu: Remove kfree_rcu() special casing and lazy-callback handling
> > > > e99637becb2e rcu: Add support for debug_objects debugging for kfree_rcu()
> > > > 0392bebebf26 rcu: Add multiple in-flight batches of kfree_rcu() work
> > > > 569d767087ef rcu: Make kfree_rcu() use a non-atomic ->monitor_todo
> > > > a35d16905efc rcu: Add basic support for kfree_rcu() batching
> 
> Note that these reverts were only for testing the same code, because
> he was testing 2 different kernel versions. One of them did not have
> this set. So I asked him to revert. There's no known bug in the
> reverted code itself. But somehow these patches do make it harder for
> him to reproduce the issue.

Perhaps they adjust timing?

> > > > Thanks,
> > > > Johan Knöös
> > >
> > > Let's add the author of the patch you reverted and the Linux netdev
> > > mailing list.
> > >
> > > - Greg
> >
> > I found we also sometimes get warnings from
> > https://elixir.bootlin.com/linux/v5.5.17/source/kernel/rcu/tree.c#L2239
> > under similar conditions even on kernel 5.5.17, which I believe may be
> > related. However, it's much rarer and I don't have a reliable way of
> > reproducing it. Perhaps 50b0e61b32ee890a75b4377d5fbe770a86d6a4c1 only
> > increases the frequency of a pre-existing bug.
> 
> This is interesting, because I saw kbuild warn me recently [1] about
> it as well. Though, I was actually intentionally messing with the
> segcblist. I plan to debug it next week, but the warning itself is
> unlikely to be caused by my patch IMHO (since it is slightly
> orthogonal to what I changed).
> 
> [1] https://lore.kernel.org/lkml/20200720005334.GC19262@shao2-debian/
> 
> But then again, I have not heard reports of this warning firing. Paul,
> has this come to your radar recently?

I have not seen any recent WARNs in rcu_do_batch().  I am guessing that
this is one of the last two in that function?

If so, have you tried using CONFIG_DEBUG_OBJECTS_RCU_HEAD=y?  That Kconfig
option is designed to help locate double frees via RCU.

							Thanx, Paul
