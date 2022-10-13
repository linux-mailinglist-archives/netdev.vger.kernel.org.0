Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 877B65FDA65
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 15:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbiJMNTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 09:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiJMNTx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 09:19:53 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCC4D1EC6B
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 06:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=7n7Lfasr/Gsjpvedt/7abRR+55tCsTTHCgaqJ2vWxBs=; b=Ty
        Ck+3lbfoL6XLVNB6XxdsJLZ/MwQDAUcx7dhECE0Kgt3njxAL1BWgwN5N0E+tYogKymBcgSYFwH//P
        xvwJZ539SaaUQE8yPHvNlIIjVwuafLm/4xFpa26YMqAwupd4ddhJqxLffAX6MOb57JefKenf6ALc8
        8r6wCgOMQ3AMPlc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oiy7h-001tDd-HD; Thu, 13 Oct 2022 15:19:41 +0200
Date:   Thu, 13 Oct 2022 15:19:41 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Thorsten Glaser <t.glaser@tarent.de>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Dave Taht <dave.taht@gmail.com>, netdev@vger.kernel.org
Subject: Re: RFH, where did I go wrong?
Message-ID: <Y0gQbdbo5dC7IQkL@lunn.ch>
References: <42776059-242c-cf49-c3ed-31e311b91f1c@tarent.de>
 <CAA93jw5J5XzhKb_L0C5uw1e3yz_4ithUnWO6nAmeeAEn7jyYiQ@mail.gmail.com>
 <1a1214b6-fc29-1e11-ec21-682684188513@tarent.de>
 <CAA93jw6ReJPD=5oQ8mvcDCMNV8px8pB4UBjq=PDJvfE=kwxCRg@mail.gmail.com>
 <d4103bc1-d0bb-5c66-10f5-2dae2cdb653d@tarent.de>
 <8051fcd-4b5-7b32-887e-7df7a779be1b@tarent.de>
 <3660fc5b-5cb3-61ee-a10c-0f541282eba4@gmail.com>
 <c18b3a75-95cc-a35c-7a2c-fb4ec0b18b84@tarent.de>
 <Y0c0Yw1FjmR0m+Cs@lunn.ch>
 <93ce7034-a26f-b68d-f27f-ef90b6b01bf8@tarent.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <93ce7034-a26f-b68d-f27f-ef90b6b01bf8@tarent.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 12, 2022 at 11:56:11PM +0200, Thorsten Glaser wrote:
> On Wed, 12 Oct 2022, Andrew Lunn wrote:
> 
> > > Ooh! Will try! That’s what I get for getting, ahem, inspiration
> > > from other qdiscs.
> > 
> > Are other qdiscs also missing RTNL, or are you just using the
> > inspiration in a different context?
> 
> I think I was probably confused between which of the functions can
> be used when. Eric explained the why. What I was missing was… well,
> basically what I asked for weeks ago — what functions I need to
> provide when writing a qdisc, and which guarantees and expectations
> these have. That rtnl is held for… apparently all but enqueue/dequeue…
> was one of these. I doubt other qdiscs miss it, or their users would
> also run into this crash or so :/

Not all broken code, specially with locks, causes a simple to
reproduce crash. So i was hoping that now you have gained an
understanding of what you did wrong, maybe you can see other places
which make the same error, possibly from where you cut/pasted, which
might not yet of crashed. Thats another way of say, if you have found
a bug, look around and see if the same bug exists somewhere else
nearby.

> The thing I did first was to add ASSERT_RTNL(); directly before the
> rtnl_* call, just like it was in the other place. That, of course,
> crashed immediately. Now *this* could be done systematically.
> 
> In OpenBSD, things like that are often hidden behind #if DIAGNOSTIC
> which is a global option, disabled in “prod” or space-constrained
> (installer) kernels but enabled for the “generic” one for wide testing.
> Something to think about?

The network stack generally falls into two parts. The fast path tries
its best to avoid anything expensive, like mutexes. It uses spinlocks
if it needs any sort of locking. And there is the rest, which is
mostly the control plain, which is the slow path. It is protected by
RTNL. As you said above, "That rtnl is held for… apparently all but
enqueue/dequeue…" enqueue/dequeue are the fast path, so RTNL is not
required, the rest is mostly control plan, so RTNL is probably
required. Also, since it is the slow path, adding ASSERT_RTNL() is
fine, and it does not need to be hidden behind #if DIAGNOSTIC. Linux
does have some debug code hidden behind ifdefs, see the kernel hacking
section of make menuconfig. The sleep in atomic context test is a good
example of this. While doing development work, you want to turn on
most of the checks in this section. That sleep in atomic check will
probably help you find cases where you hold RTNL but should not. The
lock checking will help you find potential deadlocks with RTNL and any
other locks you might use, etc.

	Andrew
