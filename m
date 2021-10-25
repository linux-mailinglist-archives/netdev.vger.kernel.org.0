Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8814396B1
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 14:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233351AbhJYMyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 08:54:41 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:26195 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233071AbhJYMyk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 08:54:40 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HdFDw2P45z8tvH;
        Mon, 25 Oct 2021 20:50:56 +0800 (CST)
Received: from kwepemm600001.china.huawei.com (7.193.23.3) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Mon, 25 Oct 2021 20:52:15 +0800
Received: from huawei.com (10.175.104.82) by kwepemm600001.china.huawei.com
 (7.193.23.3) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.15; Mon, 25 Oct
 2021 20:52:14 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <isdn@linux-pingi.de>, <marcel@holtmann.org>,
        <johan.hedberg@gmail.com>, <luiz.dentz@gmail.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <cascardo@canonical.com>
CC:     <netdev@vger.kernel.org>, <linux-bluetooth@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] Bluetooth: cmtp: fix possible panic when cmtp_init_sockets() fails
Date:   Mon, 25 Oct 2021 21:10:12 +0800
Message-ID: <20211025131012.2771062-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600001.china.huawei.com (7.193.23.3)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I got a kernel BUG report when doing fault injection test:

------------[ cut here ]------------
kernel BUG at lib/list_debug.c:45!
...
RIP: 0010:__list_del_entry_valid.cold+0x12/0x4d
...
Call Trace:
 proto_unregister+0x83/0x220
 cmtp_cleanup_sockets+0x37/0x40 [cmtp]
 cmtp_exit+0xe/0x1f [cmtp]
 do_syscall_64+0x35/0xb0
 entry_SYSCALL_64_after_hwframe+0x44/0xae

If cmtp_init_sockets() in cmtp_init() fails, cmtp_init() still returns
success. This will cause a kernel bug when accessing uncreated ctmp
related data when the module exits.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
v1->v2: remove the temporary variable "err"
 net/bluetooth/cmtp/core.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/bluetooth/cmtp/core.c b/net/bluetooth/cmtp/core.c
index 0a2d78e811cf..83eb84e8e688 100644
--- a/net/bluetooth/cmtp/core.c
+++ b/net/bluetooth/cmtp/core.c
@@ -501,9 +501,7 @@ static int __init cmtp_init(void)
 {
 	BT_INFO("CMTP (CAPI Emulation) ver %s", VERSION);
 
-	cmtp_init_sockets();
-
-	return 0;
+	return cmtp_init_sockets();
 }
 
 static void __exit cmtp_exit(void)
-- 
2.25.1

