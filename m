Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15CDB141AD
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 19:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727295AbfEER7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 13:59:46 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45846 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbfEER7q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 13:59:46 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hNLQN-0004aw-QJ; Sun, 05 May 2019 17:59:43 +0000
Date:   Sun, 5 May 2019 18:59:43 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Subject: Re: [RFC] folding socket->wq into struct socket
Message-ID: <20190505175943.GC23075@ZenIV.linux.org.uk>
References: <20190502163223.GW23075@ZenIV.linux.org.uk>
 <20190505.100421.2250762717881638194.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190505.100421.2250762717881638194.davem@davemloft.net>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 05, 2019 at 10:04:21AM -0700, David Miller wrote:
> From: Al Viro <viro@zeniv.linux.org.uk>
> Date: Thu, 2 May 2019 17:32:23 +0100
> 
> > it appears that we might take freeing the socket itself to the
> > RCU-delayed part, along with socket->wq.  And doing that has
> > an interesting benefit - the only reason to do two separate
> > allocation disappears.
> 
> I'm pretty sure we looked into RCU freeing the socket in the
> past but ended up not doing so.
> 
> I think it had to do with the latency in releasing sock related
> objects.
> 
> However, I might be confusing "struct socket" with "struct sock"

Erm...  the only object with changed release time is the memory
occupied by struct sock_alloc.  Currently:
final iput of socket
	schedule RCU-delayed kfree() of socket->wq
	kfree() of socket
With this change:
final iput of socket
	schedule RCU-delayed kfree() of coallocated socket and socket->wq

So it would have to be a workload where tons of sockets are created and
torn down, where RCU-delayed freeing of socket_wq is an inevitable evil,
but freeing struct socket_alloc itself must be done immediately, to
reduce the memory pressure.  Or am I misreading you?
