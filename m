Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF60921E87D
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 08:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgGNGpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 02:45:13 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:51410 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726375AbgGNGpM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 02:45:12 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id A34E061132CB930F3ED4;
        Tue, 14 Jul 2020 14:45:08 +0800 (CST)
Received: from localhost.localdomain (10.175.112.70) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Tue, 14 Jul 2020 14:45:04 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     <socketcan@hartkopp.net>, <mkl@pengutronix.de>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] can: silence remove_proc_entry warning
Date:   Tue, 14 Jul 2020 14:44:50 +0800
Message-ID: <1594709090-3203-1-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If can_init_proc() fail to create /proc/net/can directory,
can_remove_proc() will trigger a warning:

WARNING: CPU: 6 PID: 7133 at fs/proc/generic.c:672 remove_proc_entry+0x17b0
Kernel panic - not syncing: panic_on_warn set ...

Fix to return early from can_remove_proc() if can proc_dir
does not exists.

Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 net/can/proc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/can/proc.c b/net/can/proc.c
index e6881bf..077af42 100644
--- a/net/can/proc.c
+++ b/net/can/proc.c
@@ -471,6 +471,9 @@ void can_init_proc(struct net *net)
  */
 void can_remove_proc(struct net *net)
 {
+	if (!net->can.proc_dir)
+		return;
+
 	if (net->can.pde_version)
 		remove_proc_entry(CAN_PROC_VERSION, net->can.proc_dir);
 
@@ -498,6 +501,5 @@ void can_remove_proc(struct net *net)
 	if (net->can.pde_rcvlist_sff)
 		remove_proc_entry(CAN_PROC_RCVLIST_SFF, net->can.proc_dir);
 
-	if (net->can.proc_dir)
-		remove_proc_entry("can", net->proc_net);
+	remove_proc_entry("can", net->proc_net);
 }
-- 
1.8.3.1

