Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8A72509C2
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 22:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726225AbgHXUHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 16:07:19 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:57273 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725904AbgHXUHR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Aug 2020 16:07:17 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 0a22425d;
        Mon, 24 Aug 2020 19:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=cgxmZzC0XHaMZRdZxc5cyPLAX
        fk=; b=jMSgxwwiyuxidlQv9BgVbzRJTnrilwXVqfcl7rq3h0ABHqFrn5b7Q8uWS
        ukzA9iIVTpWmN1xmSdUBxEhe1J/gB8lEnpwCP/TthGucRglvGDIxbHxTio4yhAAI
        xNPTe1lDlOq2+DyofJ4+qp16Fd5iyR8ZtiSTMKutwwb3gfR5nEtvC2uOkUIuAbxA
        r/yjYFsggPDcWd2lTjaHBWDcdLZmiej56hOvUCin4uYER4sTXPfo52/W0y4ATNyF
        fZt+eVMdrhzsd8Qyj2uIIxdlQrlC0pQckRTdmaP1hLZgApLcYQwT+Z5404RoRJAx
        3NGahVR1Y+u5pdGDp6khJS9V/MVUw==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 8021a682 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Mon, 24 Aug 2020 19:40:10 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH net] net: read dev->needs_free_netdev before potentially freeing dev
Date:   Mon, 24 Aug 2020 22:06:50 +0200
Message-Id: <20200824200650.21982-1-Jason@zx2c4.com>
In-Reply-To: <20200824141519.GA223008@mwanda>
References: <20200824141519.GA223008@mwanda>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If dev->needs_free_netdev is true, it means that netdev_run_todo should
call free_netdev(dev) after it calls dev->priv_destructor. If
dev->needs_free_netdev is false, then it means that either
dev->priv_destructor is taking care of calling free_netdev(dev), or
something else, elsewhere, is doing that. In this case, branching on
"if (dev->needs_free_netdev)" after calling dev->priv_destructor is a
potential UaF. This patch fixes the issue by reading
dev->needs_free_netdev before calling dev->priv_destructor.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: cf124db566e6 ("net: Fix inconsistent teardown and release of private netdev state.")
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
I believe that the bug Dan reported would easily be fixed as well by
just setting dev->needs_free_netdev=true and removing the call to
free_netdev(dev) in wg_destruct, in wireguard. If you think that this is
the more proper fix -- and that the problem actually isn't this flow in
dev.c and any code that might hit this UaF is wrong -- let me know and
I'll send in a patch for wireguard instead.

 net/core/dev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 7df6c9617321..abe53c2fae8c 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10073,6 +10073,8 @@ void netdev_run_todo(void)
 	while (!list_empty(&list)) {
 		struct net_device *dev
 			= list_first_entry(&list, struct net_device, todo_list);
+		bool needs_free_netdev = dev->needs_free_netdev;
+
 		list_del(&dev->todo_list);
 
 		if (unlikely(dev->reg_state != NETREG_UNREGISTERING)) {
@@ -10097,7 +10099,7 @@ void netdev_run_todo(void)
 #endif
 		if (dev->priv_destructor)
 			dev->priv_destructor(dev);
-		if (dev->needs_free_netdev)
+		if (needs_free_netdev)
 			free_netdev(dev);
 
 		/* Report a network device has been unregistered */
-- 
2.28.0

