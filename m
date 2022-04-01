Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 901F24EF2E4
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 17:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349340AbiDAOzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 10:55:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348146AbiDAOus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:50:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 281EA2B3D4B;
        Fri,  1 Apr 2022 07:41:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B9A560A3C;
        Fri,  1 Apr 2022 14:41:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A65C5C3410F;
        Fri,  1 Apr 2022 14:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824084;
        bh=W0T1X+R3/oN9jNukhQbY+pp1TFXBcRxZNY5mbhYX01c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cX6p/uThF60bQj/ix1pzW0L1IRITkhPNb+N4aV9tehN20OE2WN5vEOyZHbq2it5Rt
         ZF2IGby8vAtGXd6Nyfwg0uFruXOlGT9DIWe2/4sEMuOBrEgI7dxb8aYwW4Nw/aqWfQ
         zs0zVrw7QPJJQJUlqDfX4ewZrrM9itnEQOdTAGZXk25x8Kxzlqe5i8ejCJL/+kdrqL
         pXkWFRK+hAshMgoFZC37TACVLqDZk2eWR6WguQmw4Ya+eXBBdZIuxQTuLmDmW9Nf43
         Cw5DFKSxzF1Rv9/7vcMdgOXZQ2PV6rVCb6MC4BWF9aqAJNsiIwAi4w6uXIQIlNf7WL
         IvozMLuBhkRzA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>, wg@grandegger.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 80/98] can: etas_es58x: es58x_fd_rx_event_msg(): initialize rx_event_msg before calling es58x_check_msg_len()
Date:   Fri,  1 Apr 2022 10:37:24 -0400
Message-Id: <20220401143742.1952163-80-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401143742.1952163-1-sashal@kernel.org>
References: <20220401143742.1952163-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

[ Upstream commit 7a8cd7c0ee823a1cc893ab3feaa23e4b602bfb9a ]

Function es58x_fd_rx_event() invokes the es58x_check_msg_len() macro:

| 	ret = es58x_check_msg_len(es58x_dev->dev, *rx_event_msg, msg_len);

While doing so, it dereferences an uninitialized
variable: *rx_event_msg.

This is actually harmless because es58x_check_msg_len() only uses
preprocessor macros (sizeof() and __stringify()) on
*rx_event_msg. c.f. [1].

Nonetheless, this pattern is confusing so the lines are reordered to
make sure that rx_event_msg is correctly initialized.

This patch also fixes a false positive warning reported by cppcheck:

| cppcheck possible warnings: (new ones prefixed by >>, may not be real problems)
|
|    In file included from drivers/net/can/usb/etas_es58x/es58x_fd.c:
| >> drivers/net/can/usb/etas_es58x/es58x_fd.c:174:8: warning: Uninitialized variable: rx_event_msg [uninitvar]
|     ret = es58x_check_msg_len(es58x_dev->dev, *rx_event_msg, msg_len);
|           ^

[1] https://elixir.bootlin.com/linux/v5.16/source/drivers/net/can/usb/etas_es58x/es58x_core.h#L467

Link: https://lore.kernel.org/all/20220306101302.708783-1-mailhol.vincent@wanadoo.fr
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/etas_es58x/es58x_fd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/can/usb/etas_es58x/es58x_fd.c b/drivers/net/can/usb/etas_es58x/es58x_fd.c
index af042aa55f59..26bf4775e884 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_fd.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_fd.c
@@ -171,12 +171,11 @@ static int es58x_fd_rx_event_msg(struct net_device *netdev,
 	const struct es58x_fd_rx_event_msg *rx_event_msg;
 	int ret;
 
+	rx_event_msg = &es58x_fd_urb_cmd->rx_event_msg;
 	ret = es58x_check_msg_len(es58x_dev->dev, *rx_event_msg, msg_len);
 	if (ret)
 		return ret;
 
-	rx_event_msg = &es58x_fd_urb_cmd->rx_event_msg;
-
 	return es58x_rx_err_msg(netdev, rx_event_msg->error_code,
 				rx_event_msg->event_code,
 				get_unaligned_le64(&rx_event_msg->timestamp));
-- 
2.34.1

