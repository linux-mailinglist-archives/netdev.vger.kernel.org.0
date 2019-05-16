Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D132A1FDCA
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 04:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbfEPCvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 22:51:43 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:58900 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725977AbfEPCvn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 May 2019 22:51:43 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 596B0C1EB8C060C667C2;
        Thu, 16 May 2019 10:51:41 +0800 (CST)
Received: from [127.0.0.1] (10.184.191.73) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.439.0; Thu, 16 May 2019
 10:51:32 +0800
To:     <jon.maloy@ericsson.com>, <ying.xue@windriver.com>,
        <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        <tipc-discussion@lists.sourceforge.net>, <mingfangsen@huawei.com>,
        <wangxiaogang3@huawei.com>, <wangwang2@huawei.com>
From:   hujunwei <hujunwei4@huawei.com>
Subject: [PATCH] tipc: switch order of device registration to fix a crash
Message-ID: <6674f2cd-53bc-bb9a-931e-d4dde6ef01e8@huawei.com>
Date:   Thu, 16 May 2019 10:51:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.184.191.73]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Junwei Hu <hujunwei4@huawei.com>

When tipc is loaded while many processes try to create a TIPC socket,
a crash occurs:
 PANIC: Unable to handle kernel paging request at virtual
 address "dfff20000000021d"
 pc : tipc_sk_create+0x374/0x1180 [tipc]
 lr : tipc_sk_create+0x374/0x1180 [tipc]
   Exception class = DABT (current EL), IL = 32 bits
 Call trace:
  tipc_sk_create+0x374/0x1180 [tipc]
  __sock_create+0x1cc/0x408
  __sys_socket+0xec/0x1f0
  __arm64_sys_socket+0x74/0xa8
 ...

This is due to race between sock_create and unfinished
register_pernet_device. tipc_sk_insert tries to do
"net_generic(net, tipc_net_id)".
but tipc_net_id is not initialized yet.

So switch the order of the two to close the race.

This can be reproduced with multiple processes doing socket(AF_TIPC, ...)
and one process doing module removal.

Fixes: a62fbccecd62 ("tipc: make subscriber server support net namespace")
Signed-off-by: Junwei Hu <hujunwei4@huawei.com>
Reported-by: Wang Wang <wangwang2@huawei.com>
Reviewed-by: Xiaogang Wang <wangxiaogang3@huawei.com>
---
 net/tipc/core.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/tipc/core.c b/net/tipc/core.c
index 5b38f5164281..dbfc1e8b2866 100644
--- a/net/tipc/core.c
+++ b/net/tipc/core.c
@@ -129,10 +129,6 @@ static int __init tipc_init(void)
 	if (err)
 		goto out_netlink_compat;

-	err = tipc_socket_init();
-	if (err)
-		goto out_socket;
-
 	err = tipc_register_sysctl();
 	if (err)
 		goto out_sysctl;
@@ -141,6 +137,10 @@ static int __init tipc_init(void)
 	if (err)
 		goto out_pernet;

+	err = tipc_socket_init();
+	if (err)
+		goto out_socket;
+
 	err = tipc_bearer_setup();
 	if (err)
 		goto out_bearer;
@@ -148,12 +148,12 @@ static int __init tipc_init(void)
 	pr_info("Started in single node mode\n");
 	return 0;
 out_bearer:
+	tipc_socket_stop();
+out_socket:
 	unregister_pernet_subsys(&tipc_net_ops);
 out_pernet:
 	tipc_unregister_sysctl();
 out_sysctl:
-	tipc_socket_stop();
-out_socket:
 	tipc_netlink_compat_stop();
 out_netlink_compat:
 	tipc_netlink_stop();
@@ -165,10 +165,10 @@ static int __init tipc_init(void)
 static void __exit tipc_exit(void)
 {
 	tipc_bearer_cleanup();
+	tipc_socket_stop();
 	unregister_pernet_subsys(&tipc_net_ops);
 	tipc_netlink_stop();
 	tipc_netlink_compat_stop();
-	tipc_socket_stop();
 	tipc_unregister_sysctl();

 	pr_info("Deactivated\n");
-- 
2.21.GIT

