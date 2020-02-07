Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAA2D15558A
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 11:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbgBGKWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 05:22:06 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:40672 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726819AbgBGKWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Feb 2020 05:22:06 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 62D9C15A3210B;
        Fri,  7 Feb 2020 02:22:05 -0800 (PST)
Date:   Fri, 07 Feb 2020 11:22:04 +0100 (CET)
Message-Id: <20200207.112204.2167793813968734872.davem@davemloft.net>
To:     dhowells@redhat.com
Cc:     netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] rxrpc: Fix call RCU cleanup using non-bh-safe locks
From:   David Miller <davem@davemloft.net>
In-Reply-To: <158099746025.2198892.1158535190228552910.stgit@warthog.procyon.org.uk>
References: <158099746025.2198892.1158535190228552910.stgit@warthog.procyon.org.uk>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 07 Feb 2020 02:22:06 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Thu, 06 Feb 2020 13:57:40 +0000

> rxrpc_rcu_destroy_call(), which is called as an RCU callback to clean up a
> put call, calls rxrpc_put_connection() which, deep in its bowels, takes a
> number of spinlocks in a non-BH-safe way, including rxrpc_conn_id_lock and
> local->client_conns_lock.  RCU callbacks, however, are normally called from
> softirq context, which can cause lockdep to notice the locking
> inconsistency.
> 
> To get lockdep to detect this, it's necessary to have the connection
> cleaned up on the put at the end of the last of its calls, though normally
> the clean up is deferred.  This can be induced, however, by starting a call
> on an AF_RXRPC socket and then closing the socket without reading the
> reply.
> 
> Fix this by having rxrpc_rcu_destroy_call() punt the destruction to a
> workqueue if in softirq-mode and defer the destruction to process context.
> 
> Note that another way to fix this could be to add a bunch of bh-disable
> annotations to the spinlocks concerned - and there might be more than just
> those two - but that means spending more time with BHs disabled.
> 
> Note also that some of these places were covered by bh-disable spinlocks
> belonging to the rxrpc_transport object, but these got removed without the
> _bh annotation being retained on the next lock in.
> 
> Fixes: 999b69f89241 ("rxrpc: Kill the client connection bundle concept")
> Reported-by: syzbot+d82f3ac8d87e7ccbb2c9@syzkaller.appspotmail.com
> Reported-by: syzbot+3f1fd6b8cbf8702d134e@syzkaller.appspotmail.com
> Signed-off-by: David Howells <dhowells@redhat.com>

Applied and queued up for -stable.
