Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D83A6261D6
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 20:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233436AbiKKT0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 14:26:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231261AbiKKT0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 14:26:10 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 393CF67124
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 11:26:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=ODI3HW9hVTg6WWY3P/YDI2K0Yn0QNu4Hl9r+bSfedjI=; b=uA
        EFJuAnJbbqFts197gy60Saygl9/g66nsiSyxjfatfLO04246zqcdsf321OzGV9Nvlyq1tU+7pxDuP
        I396L/JHm0M41qhgta29+mZX1ocyh8BrKi8TjblMdFC7PUgMX0L7D9tOns8AdgfP2b3cK/YkpWfgl
        MI1h6djvnwM+/zA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1otZeq-00290m-HM; Fri, 11 Nov 2022 20:25:44 +0100
Date:   Fri, 11 Nov 2022 20:25:44 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     John Ousterhout <ouster@cs.stanford.edu>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Subject: Re: Upstream Homa?
Message-ID: <Y26huGkf50zPPCmf@lunn.ch>
References: <CAGXJAmzTGiURc7+Xcr5A09jX3O=VzrnUQMp0K09kkh9GMaDy4A@mail.gmail.com>
 <20221110132540.44c9463c@hermes.local>
 <Y22IDLhefwvjRnGX@lunn.ch>
 <CAGXJAmw=NY17=6TnDh0oV9WTmNkQCe9Q9F3Z=uGjG9x5NKn7TQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGXJAmw=NY17=6TnDh0oV9WTmNkQCe9Q9F3Z=uGjG9x5NKn7TQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 11, 2022 at 10:59:58AM -0800, John Ousterhout wrote:
> The netlink and 32-bit kernel issues are new for me; I've done some digging to
> learn more, but still have some questions.
> 

> * Is the intent that netlink replaces *all* uses of /proc and ioctl? Homa
> currently uses ioctls on sockets for I/O (its APIs aren't sockets-compatible).
> It looks like switching to netlink would double the number of system calls that
> have to be invoked, which would be unfortunate given Homa's goal of getting the
> lowest possible latency. It also looks like netlink might be awkward for
> dumping large volumes of kernel data to user space (potential for buffer
> overflow?).

I've not looked at the actually code, i'm making general comments.

netlink, like ioctl, is meant for the control plain, not the data
plain. Your statistics should be reported via netlink, for
example. netlink is used to configure routes, setup bonding, bridges
etc. netlink can also dump large volumes of data, it has no problems
dumping the full Internet routing table for example.

How you get real packet data between the userspace and kernel space is
a different question. You say it is not BSD socket compatible. But
maybe there is another existing kernel API which will work? Maybe post
what your ideal API looks like and why sockets don't work. Eric
Dumazet could give you some ideas about what the kernel has which
might do what you need. This is the uAPI point that Stephen raised.

> * By "32 bit kernel problems" are you referring to the lack of atomic 64-bit
> operations and using the facilities of u64_stats_sync.h, or is there a more
> general issue with 64-bit operations?

Those helpers do the real work, and should optimise to pretty much
nothing on an 64 bit kernel, but do the right thing on 32 bit kernels.

But you are right, the general point is that they are not atomic, so
you need to be careful with threads, and any access to a 64 bit values
needs to be protected somehow, hopefully in a way that is optimised
out on 64bit systems.

      Andrew
