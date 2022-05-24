Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29707532E2F
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 18:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239396AbiEXQCS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 12:02:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239376AbiEXQBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 12:01:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37D089CF29;
        Tue, 24 May 2022 09:00:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8A0B6176C;
        Tue, 24 May 2022 16:00:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05D24C34115;
        Tue, 24 May 2022 16:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653408050;
        bh=pQoT+kDWEMU+OriFqW5qRi/QG2woaSt+7HNGfacypW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=geBeMmIcMo7BQRETg7xN6V6hSa+Dnh0VcWY0URfh78rEPhwklzydAV1uKmdwIJijz
         A9woJH0fjINhQXwsgQ6h2ZxCjCKDj1Bmtp6f+5KJmKb8kDIpbvNc+mvUmvD7t44J3L
         BFr/bGeiP3Xj3SHUnjRjXEjWVhr4XD9/1fsYuMetMxu/0SWU4A+eCabpn7mdI1HWzo
         abFKM5x15kPwMFax98k8tsH0bjORbbj+5a0xjM7C3lkTR5jiAtq1sl143icU+BT44b
         Wx58uiOzJ9MWAA8m0w96orIqQsbZrXF29u5yD7dKbOIB6WRaj0cUmarvI/DW4sb+bu
         BbDWQsT1P+OFQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lin Ma <linma@zju.edu.cn>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        krzysztof.kozlowski@linaro.org, rikard.falkeborn@gmail.com,
        cyeaa@connect.ust.hk, dan.carpenter@oracle.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 5/8] nfc: pn533: Fix buggy cleanup order
Date:   Tue, 24 May 2022 12:00:32 -0400
Message-Id: <20220524160035.827109-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220524160035.827109-1-sashal@kernel.org>
References: <20220524160035.827109-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lin Ma <linma@zju.edu.cn>

[ Upstream commit b8cedb7093b2d1394cae9b86494cba4b62d3a30a ]

When removing the pn533 device (i2c or USB), there is a logic error. The
original code first cancels the worker (flush_delayed_work) and then
destroys the workqueue (destroy_workqueue), leaving the timer the last
one to be deleted (del_timer). This result in a possible race condition
in a multi-core preempt-able kernel. That is, if the cleanup
(pn53x_common_clean) is concurrently run with the timer handler
(pn533_listen_mode_timer), the timer can queue the poll_work to the
already destroyed workqueue, causing use-after-free.

This patch reorder the cleanup: it uses the del_timer_sync to make sure
the handler is finished before the routine will destroy the workqueue.
Note that the timer cannot be activated by the worker again.

static void pn533_wq_poll(struct work_struct *work)
...
 rc = pn533_send_poll_frame(dev);
 if (rc)
   return;

 if (cur_mod->len == 0 && dev->poll_mod_count > 1)
   mod_timer(&dev->listen_timer, ...);

That is, the mod_timer can be called only when pn533_send_poll_frame()
returns no error, which is impossible because the device is detaching
and the lower driver should return ENODEV code.

Signed-off-by: Lin Ma <linma@zju.edu.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/pn533/pn533.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/nfc/pn533/pn533.c b/drivers/nfc/pn533/pn533.c
index d2c011615775..8d7e29d953b7 100644
--- a/drivers/nfc/pn533/pn533.c
+++ b/drivers/nfc/pn533/pn533.c
@@ -2844,13 +2844,14 @@ void pn53x_common_clean(struct pn533 *priv)
 {
 	struct pn533_cmd *cmd, *n;
 
+	/* delete the timer before cleanup the worker */
+	del_timer_sync(&priv->listen_timer);
+
 	flush_delayed_work(&priv->poll_work);
 	destroy_workqueue(priv->wq);
 
 	skb_queue_purge(&priv->resp_q);
 
-	del_timer(&priv->listen_timer);
-
 	list_for_each_entry_safe(cmd, n, &priv->cmd_queue, queue) {
 		list_del(&cmd->queue);
 		kfree(cmd);
-- 
2.35.1

