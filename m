Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8857E141D3
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 20:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727343AbfEESZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 14:25:34 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53596 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726965AbfEESZe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 14:25:34 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C64A614DA7FCF;
        Sun,  5 May 2019 11:25:33 -0700 (PDT)
Date:   Sun, 05 May 2019 11:25:31 -0700 (PDT)
Message-Id: <20190505.112531.600819597326525048.davem@davemloft.net>
To:     viro@zeniv.linux.org.uk
Cc:     netdev@vger.kernel.org
Subject: Re: [RFC] folding socket->wq into struct socket
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190505175943.GC23075@ZenIV.linux.org.uk>
References: <20190502163223.GW23075@ZenIV.linux.org.uk>
        <20190505.100421.2250762717881638194.davem@davemloft.net>
        <20190505175943.GC23075@ZenIV.linux.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 May 2019 11:25:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>
Date: Sun, 5 May 2019 18:59:43 +0100

> On Sun, May 05, 2019 at 10:04:21AM -0700, David Miller wrote:
>> From: Al Viro <viro@zeniv.linux.org.uk>
>> Date: Thu, 2 May 2019 17:32:23 +0100
>> 
>> > it appears that we might take freeing the socket itself to the
>> > RCU-delayed part, along with socket->wq.  And doing that has
>> > an interesting benefit - the only reason to do two separate
>> > allocation disappears.
>> 
>> I'm pretty sure we looked into RCU freeing the socket in the
>> past but ended up not doing so.
>> 
>> I think it had to do with the latency in releasing sock related
>> objects.
>> 
>> However, I might be confusing "struct socket" with "struct sock"
> 
> Erm...  the only object with changed release time is the memory
> occupied by struct sock_alloc.  Currently:
> final iput of socket
> 	schedule RCU-delayed kfree() of socket->wq
> 	kfree() of socket
> With this change:
> final iput of socket
> 	schedule RCU-delayed kfree() of coallocated socket and socket->wq
> 
> So it would have to be a workload where tons of sockets are created and
> torn down, where RCU-delayed freeing of socket_wq is an inevitable evil,
> but freeing struct socket_alloc itself must be done immediately, to
> reduce the memory pressure.  Or am I misreading you?

I think I was remembering trying to RCU "struct sock" release because
those 'sk' refer to SKBs and stuff like that.

So, what you are proposing looks fine.

