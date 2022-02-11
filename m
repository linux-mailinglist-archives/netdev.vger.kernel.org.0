Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EE614B1B0D
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 02:16:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346720AbiBKBQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 20:16:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343941AbiBKBQB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 20:16:01 -0500
Received: from codeconstruct.com.au (pi.codeconstruct.com.au [203.29.241.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6CAD262B
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 17:15:59 -0800 (PST)
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id A55E22028E; Fri, 11 Feb 2022 09:15:55 +0800 (AWST)
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] mctp: serial: Cancel pending work from ndo_uninit handler
Date:   Fri, 11 Feb 2022 09:15:52 +0800
Message-Id: <20220211011552.1861886-1-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We cannot do the cancel_work_sync from after the unregister_netdev, as
the dev pointer is no longer valid, causing a uaf on ldisc unregister
(or device close).

Instead, do the cancel_work_sync from the ndo_uninit op, where the dev
still exists, but the queue has stopped.

Fixes: 7bd9890f3d74 ("mctp: serial: cancel tx work on ldisc close")

Reported-by: Luo Likang <luolikang@nsfocus.com>
Tested-by: Luo Likang <luolikang@nsfocus.com>
Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
---
 drivers/net/mctp/mctp-serial.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/mctp/mctp-serial.c b/drivers/net/mctp/mctp-serial.c
index eaa6fb3224bc..62723a7faa2d 100644
--- a/drivers/net/mctp/mctp-serial.c
+++ b/drivers/net/mctp/mctp-serial.c
@@ -403,8 +403,16 @@ static void mctp_serial_tty_receive_buf(struct tty_struct *tty,
 		mctp_serial_push(dev, c[i]);
 }
 
+static void mctp_serial_uninit(struct net_device *ndev)
+{
+	struct mctp_serial *dev = netdev_priv(ndev);
+
+	cancel_work_sync(&dev->tx_work);
+}
+
 static const struct net_device_ops mctp_serial_netdev_ops = {
 	.ndo_start_xmit = mctp_serial_tx,
+	.ndo_uninit = mctp_serial_uninit,
 };
 
 static void mctp_serial_setup(struct net_device *ndev)
@@ -483,7 +491,6 @@ static void mctp_serial_close(struct tty_struct *tty)
 	int idx = dev->idx;
 
 	unregister_netdev(dev->netdev);
-	cancel_work_sync(&dev->tx_work);
 	ida_free(&mctp_serial_ida, idx);
 }
 
-- 
2.34.1

