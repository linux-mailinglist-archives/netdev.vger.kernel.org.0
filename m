Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 945031802A7
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 17:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbgCJQAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 12:00:53 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:32438 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726467AbgCJQAx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Mar 2020 12:00:53 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 02AG0dwt018546;
        Tue, 10 Mar 2020 17:00:39 +0100
Date:   Tue, 10 Mar 2020 17:00:39 +0100
From:   Willy Tarreau <w@1wt.eu>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     David Woodhouse <dwmw2@infradead.org>, netdev@vger.kernel.org,
        Martin Pohlack <mpohlack@amazon.de>
Subject: Re: TCP receive failure
Message-ID: <20200310160039.GA18520@1wt.eu>
References: <3748be15d31f71c6534f344b0c78f48fc4e3db21.camel@infradead.org>
 <20200310103928.GB18192@1wt.eu>
 <dbbd0ba6d602b5106b484f7d9df7126e40c9b5e0.camel@infradead.org>
 <20200310082625.4d9d070a@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200310082625.4d9d070a@hermes.lan>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 10, 2020 at 08:26:25AM -0700, Stephen Hemminger wrote:
> > Yeah, spot on. Thanks. Will stare accusingly at nf_conntrack, and
> > perhaps also at the server side which is sending the later sequence
> > numbers and presumably confusing it.
> > 
> 
> There were cases in the past of busted middle boxes that ignored TCP window scaling.
> 
> These were boxes based on old (buggy) version of FreeBSD firewall code that did
> not remember the window scaling from the handshake and would then see packets as
> out of window.

I've seen quite a bunch of these for a long time, and using various
stacks. And even when this got fixed, many still had issues with PAWS,
and a number of others used to randomize sequence numbers "for your
safety" except that they would do this with random values which could
actually make your ISN go backwards from the previous connection if
they forgot it in the mean time, resulting in failures to establish new
connections from the same port. Bah, I hate products which break end to
end transparency.

> You could try turning TCP window scaling off to see if that changes it.

The thing is that it's different here as the trace was taken on the
receiving side so the packets were dropped between tcpdump and the
TCP stack, hence my suspicion that some packets were considered as
invalid for whatever reason. And apparently David found them in the
local logs, which does fuel the suspicion over conntrack. Note that
it might also be caused by too short a timeout on the client's
conntrack!

Willy
