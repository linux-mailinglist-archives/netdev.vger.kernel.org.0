Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98CA1155CE2
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 18:30:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbgBGRaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 12:30:00 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:41651 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726874AbgBGRaA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Feb 2020 12:30:00 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id D544421F7D;
        Fri,  7 Feb 2020 12:29:59 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 07 Feb 2020 12:29:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=hCn1XkvLEawEVawV1
        aSu21AvpDmWpSdlZTOdYU2p+cs=; b=d6859oz0ydQTeR2boxZ67pe3sU3jWViNW
        /PQsh3IonKCV6A2XzaRRRLjVcQqyzQiujVIveKVTz17q0ayUAkUptgP+nbO5osbS
        qttlvLKGBcYvsG2FF4Mz9IyR2f/6bmTADX3vGHPRoScVTfBFJLmrsA94rawslCl0
        7j6ChUnYCxLEOUCcr3ctAs9YqVRJo3enevi1dc4X6XfqfJqGsocwNW4gYW5HAJMl
        5bwhszh+eFEho41m+JBTRl+0/4mpZlTMsy7enFRxXwAdo6NMQmuyT7QHgui5O46q
        Uy2dZbkG9kOGogA6SFTqG4AcuIw0RVm2EiEUgUZZnXivTY5M7PKIw==
X-ME-Sender: <xms:l549XviEyo9aDopHn6nWbZ9kpZzL6MGzupxlqdTlMAXI-L7fCIYf9Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheehgddutdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeejledrudekfedruddtjedruddvtdenucevlhhushhtvghruf
    hiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghh
    rdhorhhg
X-ME-Proxy: <xmx:l549Xr2KiXVYBz-sFLpzOILBQc3WBovrNVzRKjliyv9yTv6R2QOiRg>
    <xmx:l549XhpopPf_KSm3MJbfyh4WcUI5xRx82rSndLt6yj_2pa2Pn9DSMA>
    <xmx:l549Xo0HiBFTmv6RDYCAu4LNhfFvWhv4AfooLN7w2dBkPBHKv9tgxA>
    <xmx:l549Xq3q09xCWjHw90K8e2_bMIjiRNDZPVYSUPQTI9ldhkr_2vhY3Q>
Received: from splinter.mtl.com (bzq-79-183-107-120.red.bezeqint.net [79.183.107.120])
        by mail.messagingengine.com (Postfix) with ESMTPA id DD8603280064;
        Fri,  7 Feb 2020 12:29:57 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, nhorman@tuxdriver.com,
        jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net] drop_monitor: Do not cancel uninitialized work item
Date:   Fri,  7 Feb 2020 19:29:28 +0200
Message-Id: <20200207172928.129123-1-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Drop monitor uses a work item that takes care of constructing and
sending netlink notifications to user space. In case drop monitor never
started to monitor, then the work item is uninitialized and not
associated with a function.

Therefore, a stop command from user space results in canceling an
uninitialized work item which leads to the following warning [1].

Fix this by not processing a stop command if drop monitor is not
currently monitoring.

[1]
[   31.735402] ------------[ cut here ]------------
[   31.736470] WARNING: CPU: 0 PID: 143 at kernel/workqueue.c:3032 __flush_work+0x89f/0x9f0
...
[   31.738120] CPU: 0 PID: 143 Comm: dwdump Not tainted 5.5.0-custom-09491-g16d4077796b8 #727
[   31.741968] RIP: 0010:__flush_work+0x89f/0x9f0
...
[   31.760526] Call Trace:
[   31.771689]  __cancel_work_timer+0x2a6/0x3b0
[   31.776809]  net_dm_cmd_trace+0x300/0xef0
[   31.777549]  genl_rcv_msg+0x5c6/0xd50
[   31.781005]  netlink_rcv_skb+0x13b/0x3a0
[   31.784114]  genl_rcv+0x29/0x40
[   31.784720]  netlink_unicast+0x49f/0x6a0
[   31.787148]  netlink_sendmsg+0x7cf/0xc80
[   31.790426]  ____sys_sendmsg+0x620/0x770
[   31.793458]  ___sys_sendmsg+0xfd/0x170
[   31.802216]  __sys_sendmsg+0xdf/0x1a0
[   31.806195]  do_syscall_64+0xa0/0x540
[   31.806885]  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Fixes: 8e94c3bc922e ("drop_monitor: Allow user to start monitoring hardware drops")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 net/core/drop_monitor.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index ea46fc6aa883..31700e0c3928 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -1000,8 +1000,10 @@ static void net_dm_hw_monitor_stop(struct netlink_ext_ack *extack)
 {
 	int cpu;
 
-	if (!monitor_hw)
+	if (!monitor_hw) {
 		NL_SET_ERR_MSG_MOD(extack, "Hardware monitoring already disabled");
+		return;
+	}
 
 	monitor_hw = false;
 
-- 
2.24.1

