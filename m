Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99BC74EF24B
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 17:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346164AbiDAOwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 10:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350039AbiDAOrH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:47:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C2DC2A03E7;
        Fri,  1 Apr 2022 07:36:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8FB71B8250B;
        Fri,  1 Apr 2022 14:36:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30CA8C3410F;
        Fri,  1 Apr 2022 14:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823818;
        bh=Ih3fXBC704q44LXi1F9MRfHhMLxY/FZVM3wA3N1yrUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eIfW6b+nSxkQh3VIAfE/tHHPtmcOAT5xySDc7bhabScL+V8rHng1rvox/CAD/kDfT
         k7UC+PnytYv0JCsbSfI9ChOTBcoqC62TQDVNAHPocLv1chrmd0HTnCYTTKUI+z3NJn
         qqwbnksqwk+aXyZzHRsiedXe3qCc7gC2dubT/P3TvTmd0X1idGIIE/kHr6ZmohBczc
         YznB+RDxGPoHx8RK7HYcicJ01I3tvPoz/xx36xfDCEkawt/7B9MyJwArIMYGVbvlNI
         S0AllEBrLfWufypzJ3t+OCp9wLjBIti/Y8T7pU9E9x9I5Spnr308x46kOxJ3FHxXqy
         cI8a7JGb268Gw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>, wg@grandegger.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 090/109] can: etas_es58x: es58x_fd_rx_event_msg(): initialize rx_event_msg before calling es58x_check_msg_len()
Date:   Fri,  1 Apr 2022 10:32:37 -0400
Message-Id: <20220401143256.1950537-90-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401143256.1950537-1-sashal@kernel.org>
References: <20220401143256.1950537-1-sashal@kernel.org>
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
index 4f0cae29f4d8..b71d1530638b 100644
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

