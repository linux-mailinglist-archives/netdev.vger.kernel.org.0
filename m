Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20223248B70
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 18:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726938AbgHRQYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 12:24:12 -0400
Received: from verein.lst.de ([213.95.11.211]:34171 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726398AbgHRQYI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 12:24:08 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id D0D1368AFE; Tue, 18 Aug 2020 18:24:04 +0200 (CEST)
Date:   Tue, 18 Aug 2020 18:24:04 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Coly Li <colyli@suse.de>
Cc:     linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, open-iscsi@googlegroups.com,
        linux-scsi@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Jan Kara <jack@suse.com>, Jens Axboe <axboe@kernel.dk>,
        Mikhail Skorzhinskii <mskorzhinskiy@solarflare.com>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Vlastimil Babka <vbabka@suse.com>, stable@vger.kernel.org
Subject: Re: [PATCH v7 1/6] net: introduce helper sendpage_ok() in
 include/linux/net.h
Message-ID: <20200818162404.GA27196@lst.de>
References: <20200818131227.37020-1-colyli@suse.de> <20200818131227.37020-2-colyli@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200818131227.37020-2-colyli@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I think we should go for something simple like this instead:

---
From 4867e158ee86ebd801b4c267e8f8a4a762a71343 Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Tue, 18 Aug 2020 18:19:23 +0200
Subject: net: bypass ->sendpage for slab pages

Sending Slab or tail pages into ->sendpage will cause really strange
delayed oops.  Prevent it right in the networking code instead of
requiring drivers to work around the fact.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/socket.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/socket.c b/net/socket.c
index dbbe8ea7d395da..fbc82eb96d18ce 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -3638,7 +3638,12 @@ EXPORT_SYMBOL(kernel_getpeername);
 int kernel_sendpage(struct socket *sock, struct page *page, int offset,
 		    size_t size, int flags)
 {
-	if (sock->ops->sendpage)
+	/*
+	 * sendpage does manipulates the refcount of the passed in page, which
+	 * does not work for Slab pages, or for tails of non-__GFP_COMP
+	 * high order pages.
+	 */
+	if (sock->ops->sendpage && !PageSlab(page) && page_count(page) > 0)
 		return sock->ops->sendpage(sock, page, offset, size, flags);
 
 	return sock_no_sendpage(sock, page, offset, size, flags);
-- 
2.28.0

