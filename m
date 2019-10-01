Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 621A1C3D41
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 18:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732776AbfJAQ6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 12:58:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:53178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731100AbfJAQlf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Oct 2019 12:41:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C244421A4C;
        Tue,  1 Oct 2019 16:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569948094;
        bh=K4JtO4D3ApZQ4fgFUps0vrNW1aXpYkqjHX4RDmNYVX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wD/i9c0UgH0h5w+XTdpQxRN9WF1e3D6AGQ04d57RQLw6hdaP20cPW5xczGZESQzh8
         G2zngSYj1J7DCXIPZ1vwcn84/7Zy6/i+KCKNgL0kewOITHggUNnNMBkCLdKcYtt0Xt
         QLIbBOplORGZAGZnejAL9keASTe7ipKCbNjloiDg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lu Shuaibing <shuaibinglu@126.com>,
        Dominique Martinet <dominique.martinet@cea.fr>,
        Sasha Levin <sashal@kernel.org>,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 06/63] 9p: Transport error uninitialized
Date:   Tue,  1 Oct 2019 12:40:28 -0400
Message-Id: <20191001164125.15398-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001164125.15398-1-sashal@kernel.org>
References: <20191001164125.15398-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lu Shuaibing <shuaibinglu@126.com>

[ Upstream commit 0ce772fe79b68f83df40f07f28207b292785c677 ]

The p9_tag_alloc() does not initialize the transport error t_err field.
The struct p9_req_t *req is allocated and stored in a struct p9_client
variable. The field t_err is never initialized before p9_conn_cancel()
checks its value.

KUMSAN(KernelUninitializedMemorySantizer, a new error detection tool)
reports this bug.

==================================================================
BUG: KUMSAN: use of uninitialized memory in p9_conn_cancel+0x2d9/0x3b0
Read of size 4 at addr ffff88805f9b600c by task kworker/1:2/1216

CPU: 1 PID: 1216 Comm: kworker/1:2 Not tainted 5.2.0-rc4+ #28
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Ubuntu-1.8.2-1ubuntu1 04/01/2014
Workqueue: events p9_write_work
Call Trace:
 dump_stack+0x75/0xae
 __kumsan_report+0x17c/0x3e6
 kumsan_report+0xe/0x20
 p9_conn_cancel+0x2d9/0x3b0
 p9_write_work+0x183/0x4a0
 process_one_work+0x4d1/0x8c0
 worker_thread+0x6e/0x780
 kthread+0x1ca/0x1f0
 ret_from_fork+0x35/0x40

Allocated by task 1979:
 save_stack+0x19/0x80
 __kumsan_kmalloc.constprop.3+0xbc/0x120
 kmem_cache_alloc+0xa7/0x170
 p9_client_prepare_req.part.9+0x3b/0x380
 p9_client_rpc+0x15e/0x880
 p9_client_create+0x3d0/0xac0
 v9fs_session_init+0x192/0xc80
 v9fs_mount+0x67/0x470
 legacy_get_tree+0x70/0xd0
 vfs_get_tree+0x4a/0x1c0
 do_mount+0xba9/0xf90
 ksys_mount+0xa8/0x120
 __x64_sys_mount+0x62/0x70
 do_syscall_64+0x6d/0x1e0
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 0:
(stack is not available)

The buggy address belongs to the object at ffff88805f9b6008
 which belongs to the cache p9_req_t of size 144
The buggy address is located 4 bytes inside of
 144-byte region [ffff88805f9b6008, ffff88805f9b6098)
The buggy address belongs to the page:
page:ffffea00017e6d80 refcount:1 mapcount:0 mapping:ffff888068b63740 index:0xffff88805f9b7d90 compound_mapcount: 0
flags: 0x100000000010200(slab|head)
raw: 0100000000010200 ffff888068b66450 ffff888068b66450 ffff888068b63740
raw: ffff88805f9b7d90 0000000000100001 00000001ffffffff 0000000000000000
page dumped because: kumsan: bad access detected
==================================================================

Link: http://lkml.kernel.org/r/20190613070854.10434-1-shuaibinglu@126.com
Signed-off-by: Lu Shuaibing <shuaibinglu@126.com>
[dominique.martinet@cea.fr: grouped the added init with the others]
Signed-off-by: Dominique Martinet <dominique.martinet@cea.fr>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/client.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/9p/client.c b/net/9p/client.c
index 9622f3e469f67..1d48afc7033ca 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -281,6 +281,7 @@ p9_tag_alloc(struct p9_client *c, int8_t type, unsigned int max_size)
 
 	p9pdu_reset(&req->tc);
 	p9pdu_reset(&req->rc);
+	req->t_err = 0;
 	req->status = REQ_STATUS_ALLOC;
 	init_waitqueue_head(&req->wq);
 	INIT_LIST_HEAD(&req->req_list);
-- 
2.20.1

