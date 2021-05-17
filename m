Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5BA4382938
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 12:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236363AbhEQKCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 06:02:09 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:53693 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236252AbhEQKCA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 May 2021 06:02:00 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 14HA0cft013419;
        Mon, 17 May 2021 12:00:38 +0200
Date:   Mon, 17 May 2021 12:00:38 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Troels Arvin <troels@arvin.dk>
Cc:     netdev@vger.kernel.org
Subject: Re: Default value of ipv4.tcp_keepalive_time
Message-ID: <20210517100038.GA13385@1wt.eu>
References: <f62489f3-5f58-4df6-b9c6-b190eb3f8c33@arvin.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f62489f3-5f58-4df6-b9c6-b190eb3f8c33@arvin.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Mon, May 17, 2021 at 10:00:04AM +0200, Troels Arvin wrote:
> Hello,
> 
> At work, we have spent a great deal of work on a situation which ended up
> being resolved by changing the net.ipv4.tcp_keepalive_time sysctl to a value
> much lower than the default (we set it to 300). This was two Linux-based
> systems communicating without any firewalls in-between, where some
> long-running connections would be considered down by one system, while the
> other expected them to still be around.
> 
> The following is the description of the setting:
> "The interval between the last data packet sent (simple ACKs are not
> considered data) and the first keepalive probe; after the connection is
> marked to need keepalive, this counter is not used any further."
> 
> The default value of net.ipv4.tcp_keepalive_time sysctl is 7200 seconds,
> i.e. two hours.
> 
> It seems odd to me to still have such a long period of waiting, before
> keep-alive kicks in. With such a long initial wait, it's questionable how
> much value the keep-alive functionality has, I think.
> 
> Could it be that it's time to change the default? I would suggest a value of
> 10 minutes, i.e. 600 seconds, but I have to admit, that I don't have any
> objective argument for exactly that value.

There is no good value, it's entirely dependent on the application. At
least with a large default value you have little risk to flood your
links when dealing with hundreds of thousands to millions of idle
connections (think WebSocket for example). A 10 minute value would
still be too large for plenty of users but cause excessive traffic
for others.

I strongly suggest that the value must be tunable in the application
instead, that's the only way to get it right for everyone (see
TCP_KEEPCNT, TCP_KEEPINTVL and TCP_KEEPIDLE).

Just my two cents,
Willy
