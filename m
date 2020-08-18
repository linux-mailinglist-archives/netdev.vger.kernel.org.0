Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78289248535
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 14:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbgHRMsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 08:48:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:49524 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726476AbgHRMsS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 08:48:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 240E1ADF2;
        Tue, 18 Aug 2020 12:48:42 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, open-iscsi@googlegroups.com,
        linux-scsi@vger.kernel.org, ceph-devel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Coly Li <colyli@suse.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasily Averin <vvs@virtuozzo.com>,
        "David S . Miller" <davem@davemloft.net>, stable@vger.kernel.org
Subject: [PATCH v6 3/6] tcp: use sendpage_ok() to detect misused .sendpage
Date:   Tue, 18 Aug 2020 20:47:33 +0800
Message-Id: <20200818124736.5790-4-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200818124736.5790-1-colyli@suse.de>
References: <20200818124736.5790-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit a10674bf2406 ("tcp: detecting the misuse of .sendpage for Slab
objects") adds the checks for Slab pages, but the pages don't have
page_count are still missing from the check.

Network layer's sendpage method is not designed to send page_count 0
pages neither, therefore both PageSlab() and page_count() should be
both checked for the sending page. This is exactly what sendpage_ok()
does.

This patch uses sendpage_ok() in do_tcp_sendpages() to detect misused
.sendpage, to make the code more robust.

Fixes: a10674bf2406 ("tcp: detecting the misuse of .sendpage for Slab objects")
Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Coly Li <colyli@suse.de>
Cc: Vasily Averin <vvs@virtuozzo.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: stable@vger.kernel.org
---
 net/ipv4/tcp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 31f3b858db81..d96c7549895a 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -970,7 +970,8 @@ ssize_t do_tcp_sendpages(struct sock *sk, struct page *page, int offset,
 	long timeo = sock_sndtimeo(sk, flags & MSG_DONTWAIT);
 
 	if (IS_ENABLED(CONFIG_DEBUG_VM) &&
-	    WARN_ONCE(PageSlab(page), "page must not be a Slab one"))
+	    WARN_ONCE(!sendpage_ok(page)),
+		      "page must not be a Slab one and have page_count > 0")
 		return -EINVAL;
 
 	/* Wait for a connection to finish. One exception is TCP Fast Open
-- 
2.26.2

