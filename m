Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55D06278BCB
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 17:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729375AbgIYPBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 11:01:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:34140 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728693AbgIYPBx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 11:01:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 45629AD72;
        Fri, 25 Sep 2020 15:01:51 +0000 (UTC)
From:   Coly Li <colyli@suse.de>
To:     linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, open-iscsi@googlegroups.com,
        linux-scsi@vger.kernel.org, ceph-devel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Coly Li <colyli@suse.de>,
        Cong Wang <amwang@redhat.com>, Christoph Hellwig <hch@lst.de>,
        "David S . Miller" <davem@davemloft.net>,
        Sridhar Samudrala <sri@us.ibm.com>
Subject: [PATCH v8 2/7] net: add WARN_ONCE in kernel_sendpage() for improper zero-copy send
Date:   Fri, 25 Sep 2020 23:01:14 +0800
Message-Id: <20200925150119.112016-3-colyli@suse.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200925150119.112016-1-colyli@suse.de>
References: <20200925150119.112016-1-colyli@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a page sent into kernel_sendpage() is a slab page or it doesn't have
ref_count, this page is improper to send by the zero copy sendpage()
method. Otherwise such page might be unexpected released in network code
path and causes impredictable panic due to kernel memory management data
structure corruption.

This path adds a WARN_ON() on the sending page before sends it into the
concrete zero-copy sendpage() method, if the page is improper for the
zero-copy sendpage() method, a warning message can be observed before
the consequential unpredictable kernel panic.

This patch does not change existing kernel_sendpage() behavior for the
improper page zero-copy send, it just provides hint warning message for
following potential panic due the kernel memory heap corruption.

Signed-off-by: Coly Li <colyli@suse.de>
Cc: Cong Wang <amwang@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Sridhar Samudrala <sri@us.ibm.com>
---
 net/socket.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/socket.c b/net/socket.c
index 0c0144604f81..771456a1d947 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -3638,9 +3638,11 @@ EXPORT_SYMBOL(kernel_getpeername);
 int kernel_sendpage(struct socket *sock, struct page *page, int offset,
 		    size_t size, int flags)
 {
-	if (sock->ops->sendpage)
+	if (sock->ops->sendpage) {
+		/* Warn in case the improper page to zero-copy send */
+		WARN_ONCE(!sendpage_ok(page));
 		return sock->ops->sendpage(sock, page, offset, size, flags);
-
+	}
 	return sock_no_sendpage(sock, page, offset, size, flags);
 }
 EXPORT_SYMBOL(kernel_sendpage);
-- 
2.26.2

