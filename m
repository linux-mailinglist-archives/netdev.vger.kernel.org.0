Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 083AC61D7A5
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 07:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbiKEGBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 02:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbiKEGBe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 02:01:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE2FC30F7A;
        Fri,  4 Nov 2022 23:01:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6CD3660A55;
        Sat,  5 Nov 2022 06:01:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47C30C43143;
        Sat,  5 Nov 2022 06:01:30 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.96)
        (envelope-from <rostedt@goodmis.org>)
        id 1orCFi-007OpY-1Y;
        Sat, 05 Nov 2022 02:01:58 -0400
Message-ID: <20221105060158.322031906@goodmis.org>
User-Agent: quilt/0.66
Date:   Sat, 05 Nov 2022 02:00:43 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Anna-Maria Gleixner <anna-maria@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Chengfeng Ye <cyeaa@connect.ust.hk>, Lin Ma <linma@zju.edu.cn>,
        Duoming Zhou <duoming@zju.edu.cn>, netdev@vger.kernel.org
Subject: [PATCH v4a 19/38] timers: nfc: pn533: Use timer_shutdown_sync() before freeing timer
References: <20221105060024.598488967@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Before a timer is freed, timer_shutdown_sync() must be called.

Link: https://lore.kernel.org/all/20221104054053.431922658@goodmis.org/

Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Chengfeng Ye <cyeaa@connect.ust.hk>
Cc: Lin Ma <linma@zju.edu.cn>
Cc: Duoming Zhou <duoming@zju.edu.cn>
Cc: netdev@vger.kernel.org
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 drivers/nfc/pn533/pn533.c | 2 +-
 drivers/nfc/pn533/uart.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/pn533/pn533.c b/drivers/nfc/pn533/pn533.c
index d9f6367b9993..0a1d0b4e3bb8 100644
--- a/drivers/nfc/pn533/pn533.c
+++ b/drivers/nfc/pn533/pn533.c
@@ -2788,7 +2788,7 @@ void pn53x_common_clean(struct pn533 *priv)
 	struct pn533_cmd *cmd, *n;
 
 	/* delete the timer before cleanup the worker */
-	del_timer_sync(&priv->listen_timer);
+	timer_shutdown_sync(&priv->listen_timer);
 
 	flush_delayed_work(&priv->poll_work);
 	destroy_workqueue(priv->wq);
diff --git a/drivers/nfc/pn533/uart.c b/drivers/nfc/pn533/uart.c
index 07596bf5f7d6..a556acdb947b 100644
--- a/drivers/nfc/pn533/uart.c
+++ b/drivers/nfc/pn533/uart.c
@@ -310,7 +310,7 @@ static void pn532_uart_remove(struct serdev_device *serdev)
 	pn53x_unregister_nfc(pn532->priv);
 	serdev_device_close(serdev);
 	pn53x_common_clean(pn532->priv);
-	del_timer_sync(&pn532->cmd_timeout);
+	timer_shutdown_sync(&pn532->cmd_timeout);
 	kfree_skb(pn532->recv_skb);
 	kfree(pn532);
 }
-- 
2.35.1
