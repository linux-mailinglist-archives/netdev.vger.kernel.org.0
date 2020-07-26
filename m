Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0112322DC67
	for <lists+netdev@lfdr.de>; Sun, 26 Jul 2020 09:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbgGZHDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jul 2020 03:03:19 -0400
Received: from verein.lst.de ([213.95.11.211]:39756 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725789AbgGZHDS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Jul 2020 03:03:18 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 2AB2768B05; Sun, 26 Jul 2020 09:03:12 +0200 (CEST)
Date:   Sun, 26 Jul 2020 09:03:11 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     David Miller <davem@davemloft.net>
Cc:     hch@lst.de, kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, edumazet@google.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-sctp@vger.kernel.org, linux-hams@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-can@vger.kernel.org, dccp@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net,
        linux-wpan@vger.kernel.org, linux-s390@vger.kernel.org,
        mptcp@lists.01.org, lvs-devel@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-afs@lists.infradead.org,
        tipc-discussion@lists.sourceforge.net, linux-x25@vger.kernel.org
Subject: Re: get rid of the address_space override in setsockopt v2
Message-ID: <20200726070311.GA16687@lst.de>
References: <20200723060908.50081-1-hch@lst.de> <20200724.154342.1433271593505001306.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200724.154342.1433271593505001306.davem@davemloft.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 24, 2020 at 03:43:42PM -0700, David Miller wrote:
> > Changes since v1:
> >  - check that users don't pass in kernel addresses
> >  - more bpfilter cleanups
> >  - cosmetic mptcp tweak
> 
> Series applied to net-next, I'm build testing and will push this out when
> that is done.

The buildbot found one warning with the isdn debug code after a few
days, here is what I think is the best fix:

---
From 6601732f7a54db5f04efba08f7e9224e5b757112 Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Sun, 26 Jul 2020 09:00:09 +0200
Subject: mISDN: remove a debug printk in data_sock_setsockopt

The %p won't work with the new sockptr_t type.  But in the times of
ftrace, bpftrace and co these kinds of debug printks are pretty anyway,
so just remove the whole debug printk.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/isdn/mISDN/socket.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/isdn/mISDN/socket.c b/drivers/isdn/mISDN/socket.c
index 1b2b91479107bc..2c58a6fe6d129e 100644
--- a/drivers/isdn/mISDN/socket.c
+++ b/drivers/isdn/mISDN/socket.c
@@ -406,10 +406,6 @@ static int data_sock_setsockopt(struct socket *sock, int level, int optname,
 	struct sock *sk = sock->sk;
 	int err = 0, opt = 0;
 
-	if (*debug & DEBUG_SOCKET)
-		printk(KERN_DEBUG "%s(%p, %d, %x, %p, %d)\n", __func__, sock,
-		       level, optname, optval, len);
-
 	lock_sock(sk);
 
 	switch (optname) {
-- 
2.27.0

