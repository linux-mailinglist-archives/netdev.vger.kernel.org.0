Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 047BA620D12
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 11:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233905AbiKHKT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 05:19:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233900AbiKHKTR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 05:19:17 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5E6E15A27
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 02:19:16 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1osLhK-0006Px-Ua
        for netdev@vger.kernel.org; Tue, 08 Nov 2022 11:19:14 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id DB91E115C40
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 13:32:25 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 1E950115C27;
        Mon,  7 Nov 2022 13:32:23 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id fa5bdaa3;
        Mon, 7 Nov 2022 13:32:20 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Chen Zhongjin <chenzhongjin@huawei.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net 1/6] can: af_can: can_exit(): add missing dev_remove_pack() of canxl_packet
Date:   Mon,  7 Nov 2022 14:32:12 +0100
Message-Id: <20221107133217.59861-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221107133217.59861-1-mkl@pengutronix.de>
References: <20221107133217.59861-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chen Zhongjin <chenzhongjin@huawei.com>

In can_init(), dev_add_pack(&canxl_packet) is added but not removed in
can_exit(). It breaks the packet handler list and can make kernel
panic when can_init() is called for the second time.

| > modprobe can && rmmod can
| > rmmod xxx && modprobe can
|
| BUG: unable to handle page fault for address: fffffbfff807d7f4
| RIP: 0010:dev_add_pack+0x133/0x1f0
| Call Trace:
|  <TASK>
|  can_init+0xaa/0x1000 [can]
|  do_one_initcall+0xd3/0x4e0
|  ...

Fixes: fb08cba12b52 ("can: canxl: update CAN infrastructure for CAN XL frames")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://lore.kernel.org/all/20221031033053.37849-1-chenzhongjin@huawei.com
[mkl: adjust subject and commit message]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/af_can.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/can/af_can.c b/net/can/af_can.c
index 9503ab10f9b8..5e9e3e1e9825 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -902,6 +902,7 @@ static __init int can_init(void)
 static __exit void can_exit(void)
 {
 	/* protocol unregister */
+	dev_remove_pack(&canxl_packet);
 	dev_remove_pack(&canfd_packet);
 	dev_remove_pack(&can_packet);
 	sock_unregister(PF_CAN);

base-commit: c23fb2c82267638f9d206cb96bb93e1f93ad7828
-- 
2.35.1


