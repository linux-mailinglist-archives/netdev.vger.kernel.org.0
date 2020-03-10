Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C08917F52F
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 11:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbgCJKk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 06:40:29 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:32432 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725845AbgCJKk3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Mar 2020 06:40:29 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 02AAdS3X018431;
        Tue, 10 Mar 2020 11:39:28 +0100
Date:   Tue, 10 Mar 2020 11:39:28 +0100
From:   Willy Tarreau <w@1wt.eu>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     netdev@vger.kernel.org, Martin Pohlack <mpohlack@amazon.de>
Subject: Re: TCP receive failure
Message-ID: <20200310103928.GB18192@1wt.eu>
References: <3748be15d31f71c6534f344b0c78f48fc4e3db21.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3748be15d31f71c6534f344b0c78f48fc4e3db21.camel@infradead.org>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On Tue, Mar 10, 2020 at 09:40:04AM +0000, David Woodhouse wrote:
> I'm chasing a problem which was reported to me as an OpenConnect packet
> loss, with downloads stalling until curl times out and aborts.
> 
> I can't see a transport problem though; I think I see TCP on the
> receive side misbehaving. This is an Ubuntu 5.3.x client kernel
> (5.3.0-40-generic #32~18.04.1-Ubuntu) which I think is 5.3.18?
> 
> The test is just downloading a large file full of zeroes. The problem
> starts with a bit of packet loss and a 40ms time warp:

So just to clear up a few points, it seems that the trace was taken on
the client, right ?

(...)
> 19:14:03.040870 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735803185, win 24171, options [nop,nop,TS val 2290572281 ecr 653279937,nop,nop,sack 1 {1735831937:1735884649}], length 0
> 
> Looks sane enough so far...
> 
> 19:14:03.041903 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735950539:1735951737, ack 366489597, win 235, options [nop,nop,TS val 653279937 ecr 2290572254], length 1198: HTTP
> 
> WTF? The server has never sent us anything past 1735884649 and now it's
> suddenly sending 1735950539? But OK, despite some confusing future
> packets which apparently get ignored (and make me wonder if I really
> understand what's going on here), the client is making progress because
> the server is *also* sending sensible packets, and the originally
> dropped segments are being recovered...
> 
> 19:14:03.068337 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735803185:1735804383, ack 366489597, win 235, options [nop,nop,TS val 653279944 ecr 2290572281], length 1198: HTTP
> 19:14:03.068363 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735804383, win 24171, options [nop,nop,TS val 2290572309 ecr 653279944,nop,nop,sack 1 {1735831937:1735884649}], length 0
(...)
> 19:14:03.211316 IP 192.168.0.195.53754 > 10.28.82.105.80: Flags [.], ack 1735884649, win 24171, options [nop,nop,TS val 2290572452 ecr 653279980], length 0
> 
> OK, now it's caught up. Client continues to ignore bogus future packets
> from the server, and doesn't even SACK them.

That's what caught my eyes as well.

> 19:14:03.211629 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1735967311:1735968509, ack 366489597, win 235, options [nop,nop,TS val 653279980 ecr 2290572422], length 1198: HTTP
(... no ack here ...)
> 19:14:03.251516 IP 10.28.82.105.80 > 192.168.0.195.53754: Flags [.], seq 1736028409:1736029607, ack 366489597, win 235, options [nop,nop,TS val 653279989 ecr 2290572452], length 1198: HTTP
> 
> Server finally comes to its senses and actually sends the packet that
> the client wants. Repeatedly.

This makes me think that there's very likely nf_conntrack on the client
machine and the TCP packets you're seeing reach tcpdump but not the TCP
layer. For some reason they're very likely considered out of window and
are silently dropped. Since we don't have the SYN we don't know the
window size, but we can try to guess. There was 82662 unacked bytes in
flight at the peak when the server went crazy, for an apparent window of
24171, making me think the window scaling was at least 4, or that the
server wrongly assumed so. But earlier when the client was sending SACKs
I found bytes in flight as high as 137770 for an advertised window of
24567 (5.6 times more), thus the window scaling is at least 8. So this
indicates that the 82kB above are well within the window and the client
should ACK them. But maybe they were dropped as invalid at the conntrack
layer for another obscure reason.

Just my two cents,
Willy
