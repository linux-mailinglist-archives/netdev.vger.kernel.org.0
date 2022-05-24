Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7F8532E24
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 18:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239229AbiEXQBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 12:01:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239372AbiEXQA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 12:00:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 266DE9CF6F;
        Tue, 24 May 2022 09:00:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CBF6EB81A00;
        Tue, 24 May 2022 16:00:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86755C34113;
        Tue, 24 May 2022 16:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653408024;
        bh=jHyM+b8du+a0HmzbYBcvIzJ3XESf7qdxLXW4V9tafjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y2L0Em0hBX6SYFUgz8UEtsvKzQR2hvdq2BpLXj7faG6HWQNFjd4VWltMdWwrbMv5n
         PuGDLi13GNZZDkkPHYmzhaO2JVm9MIWR5zppoFhcai7qg1p6PE3ITMLzo4km1rJUCP
         OH7mI/5gqQkHExkLymM/0QK4qfQyr10sENuWGyBl150mTaQ9/keYvtFIO0EV4TmvrV
         XNgXCcLb5zNTjoiLxZSMy+B2j+RF/h0swyJw8TOjSPP+ja/UKGQdYaivoC1+2HRJsP
         mfs0ok9FjG9YwWJQjcyHuetr1kzFUuL2gdkVwEOs3yvg9Ld47tgXbdW3eUK0PdteoT
         2JwaIBdG8dmAQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lin Ma <linma@zju.edu.cn>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        krzysztof.kozlowski@linaro.org, rikard.falkeborn@gmail.com,
        kuba@kernel.org, cyeaa@connect.ust.hk, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 07/10] nfc: pn533: Fix buggy cleanup order
Date:   Tue, 24 May 2022 12:00:04 -0400
Message-Id: <20220524160009.826957-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220524160009.826957-1-sashal@kernel.org>
References: <20220524160009.826957-1-sashal@kernel.org>
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
index d32aec0c334f..6dc0af63440f 100644
--- a/drivers/nfc/pn533/pn533.c
+++ b/drivers/nfc/pn533/pn533.c
@@ -2789,13 +2789,14 @@ void pn53x_common_clean(struct pn533 *priv)
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

