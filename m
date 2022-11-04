Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE4DB619705
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 14:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231700AbiKDNFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 09:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231583AbiKDNFq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 09:05:46 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9197D2E6A3
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 06:05:42 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oqwOD-00081r-0e
        for netdev@vger.kernel.org; Fri, 04 Nov 2022 14:05:41 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 4CEED112F0A
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 13:05:40 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 46DC1112EF0;
        Fri,  4 Nov 2022 13:05:38 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id a40011fb;
        Fri, 4 Nov 2022 13:05:36 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Zhengchao Shao <shaozhengchao@huawei.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 2/5] can: af_can: fix NULL pointer dereference in can_rx_register()
Date:   Fri,  4 Nov 2022 14:05:32 +0100
Message-Id: <20221104130535.732382-3-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221104130535.732382-1-mkl@pengutronix.de>
References: <20221104130535.732382-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhengchao Shao <shaozhengchao@huawei.com>

It causes NULL pointer dereference when testing as following:
(a) use syscall(__NR_socket, 0x10ul, 3ul, 0) to create netlink socket.
(b) use syscall(__NR_sendmsg, ...) to create bond link device and vxcan
    link device, and bind vxcan device to bond device (can also use
    ifenslave command to bind vxcan device to bond device).
(c) use syscall(__NR_socket, 0x1dul, 3ul, 1) to create CAN socket.
(d) use syscall(__NR_bind, ...) to bind the bond device to CAN socket.

The bond device invokes the can-raw protocol registration interface to
receive CAN packets. However, ml_priv is not allocated to the dev,
dev_rcv_lists is assigned to NULL in can_rx_register(). In this case,
it will occur the NULL pointer dereference issue.

The following is the stack information:
BUG: kernel NULL pointer dereference, address: 0000000000000008
PGD 122a4067 P4D 122a4067 PUD 1223c067 PMD 0
Oops: 0000 [#1] PREEMPT SMP
RIP: 0010:can_rx_register+0x12d/0x1e0
Call Trace:
<TASK>
raw_enable_filters+0x8d/0x120
raw_enable_allfilters+0x3b/0x130
raw_bind+0x118/0x4f0
__sys_bind+0x163/0x1a0
__x64_sys_bind+0x1e/0x30
do_syscall_64+0x35/0x80
entry_SYSCALL_64_after_hwframe+0x63/0xcd
</TASK>

Fixes: 4e096a18867a ("net: introduce CAN specific pointer in the struct net_device")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Reviewed-by: Marc Kleine-Budde <mkl@pengutronix.de>
Link: https://lore.kernel.org/all/20221028085650.170470-1-shaozhengchao@huawei.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/af_can.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/can/af_can.c b/net/can/af_can.c
index 5e9e3e1e9825..27dcdcc0b808 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -450,7 +450,7 @@ int can_rx_register(struct net *net, struct net_device *dev, canid_t can_id,
 
 	/* insert new receiver  (dev,canid,mask) -> (func,data) */
 
-	if (dev && dev->type != ARPHRD_CAN)
+	if (dev && (dev->type != ARPHRD_CAN || !can_get_ml_priv(dev)))
 		return -ENODEV;
 
 	if (dev && !net_eq(net, dev_net(dev)))
-- 
2.35.1


