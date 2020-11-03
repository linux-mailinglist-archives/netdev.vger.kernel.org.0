Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 832B22A5985
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 23:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731323AbgKCWH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 17:07:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730316AbgKCWGm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 17:06:42 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65BCAC0613D1
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 14:06:42 -0800 (PST)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ka4Rs-0006Ui-JZ; Tue, 03 Nov 2020 23:06:40 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net 03/27] can: proc: can_remove_proc(): silence remove_proc_entry warning
Date:   Tue,  3 Nov 2020 23:06:12 +0100
Message-Id: <20201103220636.972106-4-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201103220636.972106-1-mkl@pengutronix.de>
References: <20201103220636.972106-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>

If can_init_proc() fail to create /proc/net/can directory, can_remove_proc()
will trigger a warning:

WARNING: CPU: 6 PID: 7133 at fs/proc/generic.c:672 remove_proc_entry+0x17b0
Kernel panic - not syncing: panic_on_warn set ...

Fix to return early from can_remove_proc() if can proc_dir does not exists.

Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Link: https://lore.kernel.org/r/1594709090-3203-1-git-send-email-zhangchangzhong@huawei.com
Fixes: 8e8cda6d737d ("can: initial support for network namespaces")
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/proc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/can/proc.c b/net/can/proc.c
index 550928b8b8a2..5ea8695f507e 100644
--- a/net/can/proc.c
+++ b/net/can/proc.c
@@ -462,6 +462,9 @@ void can_init_proc(struct net *net)
  */
 void can_remove_proc(struct net *net)
 {
+	if (!net->can.proc_dir)
+		return;
+
 	if (net->can.pde_stats)
 		remove_proc_entry(CAN_PROC_STATS, net->can.proc_dir);
 
@@ -486,6 +489,5 @@ void can_remove_proc(struct net *net)
 	if (net->can.pde_rcvlist_sff)
 		remove_proc_entry(CAN_PROC_RCVLIST_SFF, net->can.proc_dir);
 
-	if (net->can.proc_dir)
-		remove_proc_entry("can", net->proc_net);
+	remove_proc_entry("can", net->proc_net);
 }
-- 
2.28.0

