Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5262324F88
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 15:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728249AbfEUNBF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 09:01:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41853 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727534AbfEUNBE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 May 2019 09:01:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=kiheRmbJwdSSS6MbG97WbRFjTMnk82PDnA5kIng1yE4=; b=PLUVW7rskILZEnwXWJPNl3ACrk
        ZGLf5epz4ySN73QrNYT644tZiNkYMnFdOt8/EEtu46x95PE5p5nN7KB6hDdOWWtg8NidyDILbDcvE
        sy4+8sm3C52pde16SliFP1yWRD9NSMWG9Vm3/ekhEeNhWqYXl0zHS5iu7gvzqDAvBuoI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hT4O5-0002LQ-8r; Tue, 21 May 2019 15:01:01 +0200
Date:   Tue, 21 May 2019 15:01:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-block@vger.kernel.org, John Crispin <john@phrozen.org>,
        Jonas Gorski <jonas.gorski@gmail.com>,
        Jo-Philipp Wich <jo@mein.io>, Felix Fietkau <nbd@nbd.name>
Subject: Re: ARM router NAT performance affected by random/unrelated commits
Message-ID: <20190521130101.GC6577@lunn.ch>
References: <9a9ba4c9-3cb7-eb64-4aac-d43b59224442@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a9ba4c9-3cb7-eb64-4aac-d43b59224442@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I also tried running cachestat but didn't get anything interesting:
> Counting cache functions... Output every 1 seconds.
> TIME         HITS   MISSES  DIRTIES    RATIO   BUFFERS_MB   CACHE_MB
> 10:06:59     1020        5        0    99.5%            0          2
> 10:07:00     1029        0        0   100.0%            0          2
> 10:07:01     1013        0        0   100.0%            0          2
> 10:07:02     1029        0        0   100.0%            0          2
> 10:07:03     1029        0        0   100.0%            0          2
> 10:07:04      997        0        0   100.0%            0          2
> 10:07:05     1013        0        0   100.0%            0          2
> (I started iperf at 10:07:00).

Try looking at the L1 cache performance. For this class of device, the
L1 code cache is probably too small to contain the active parts of the
network stack. The less cache thrashing you have, the faster the stack
will go.

Maybe try compiling with -Os so it optimises for size.

Build a custom kernel with everything you don't need turned off.

Look at the work being done to batch process packets. Rather than
passing one packet at a time through the network stack, it passes a
linked list of packets to each stage in the stack. That should result
in less cache misses per packet. But not all layers in the stack
support this batching. See if you can find out where it is being
unbatched, and why. Can you influence this, disable build options, or
work on the code to pass batches further along the stack.

     Andrew
