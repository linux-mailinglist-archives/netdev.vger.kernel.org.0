Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFF7144498
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730628AbfFMQht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:37:49 -0400
Received: from m15-111.126.com ([220.181.15.111]:58751 "EHLO m15-111.126.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730618AbfFMHKA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 03:10:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=pQt7H
        gkGjDiOkh+wd5Sa+sRL4h8CMsOHEzAP3mBBeC8=; b=VKaOqZrlpaLx1J+5Bg/Cx
        7ltBFnLNLNqG6vgB2T4PCQ7ZgqZbbzpbGeSOQQybU4a3oOJFvdKhWZODRoJPP0n0
        It9lqYyN01oPi0970JeyUDIZniH0eP6Bz4gPgwudRCWlM5P2kw6DfmU4mlMybFU/
        MfqzH8cLakatQT+rv0rdU8=
Received: from localhost.localdomain (unknown [159.226.223.206])
        by smtp1 (Coremail) with SMTP id C8mowADXoDSj9gFdCHxqCg--.49261S2;
        Thu, 13 Jun 2019 15:09:23 +0800 (CST)
From:   Lu Shuaibing <shuaibinglu@126.com>
To:     ericvh@gmail.com
Cc:     lucho@ionkov.net, asmadeus@codewreck.org, davem@davemloft.net,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lu Shuaibing <shuaibinglu@126.com>
Subject: [PATCH] 9p: Transport error uninitialized
Date:   Thu, 13 Jun 2019 15:08:54 +0800
Message-Id: <20190613070854.10434-1-shuaibinglu@126.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: C8mowADXoDSj9gFdCHxqCg--.49261S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxXrWrZr1fJr4UKFW5tw45GFg_yoW5XFW5pr
        nIkrWxCr48tryUZF4Dtay8Ar18JF4DZ3W7XryIyr12yanrGr18Aa4UKrWUWFyUCr15AFy7
        JF1qq3y5tr1UGaUanT9S1TB71UUUUUJqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jJ6pPUUUUU=
X-Originating-IP: [159.226.223.206]
X-CM-SenderInfo: 5vkxtxpelqwzbx6rjloofrz/1tbiFxHSq1pD8kc0nAABs6
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

Signed-off-by: Lu Shuaibing <shuaibinglu@126.com>
---
 net/9p/client.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/9p/client.c b/net/9p/client.c
index 9622f3e469f6..148acdcd0217 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -310,6 +310,7 @@ p9_tag_alloc(struct p9_client *c, int8_t type, unsigned int max_size)
 	 */
 	refcount_set(&req->refcount.refcount, 2);
 
+	req->t_err = 0;
 	return req;
 
 free:
-- 
2.19.1

