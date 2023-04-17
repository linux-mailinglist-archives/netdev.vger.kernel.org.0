Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC8776E3F66
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 08:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbjDQGIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 02:08:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjDQGIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 02:08:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA4419C;
        Sun, 16 Apr 2023 23:08:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55B3261E24;
        Mon, 17 Apr 2023 06:08:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9D7E3C433D2;
        Mon, 17 Apr 2023 06:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681711715;
        bh=3BSgZVHK62rGPPsuC9IFhZYJMKZHxwvNgfW4XZ4cl9g=;
        h=From:Date:Subject:To:Cc:Reply-To:From;
        b=nb3cGsFy6NTNTrn/1UvhH5T0FKL59gYAVjfRaOhNXxn5llBFaiBAZQY+RXIRHjUEo
         hz6m7S9fyN49oWbKWjMv8qJr7slt2cffWiUld4rdDc2MO6/g38nJH8PyY6SR48BZE9
         3U7a8EVu5rUMUxCrlr51FQQVPcSbYjmqItMvnvJ+vjvUN6WARwvXDRhgg71cxySafy
         hHB2XvTry/GIZBcFJhN/FOhYPcCz5ZHb0ANpUjnkYllMJHzW16QaXPLQLd+atgUHBa
         0hdqbmxd6Uxqpk4poYt+81xCRcMlwXPsjFIbKygmVgxkHPZZcKqX8k+sMTj3JY8G8V
         1hU1iU2VDjT2Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.lore.kernel.org (Postfix) with ESMTP id 8AEE4C77B72;
        Mon, 17 Apr 2023 06:08:35 +0000 (UTC)
From:   Jaime Breva via B4 Relay 
        <devnull+jbreva.nayarsystems.com@kernel.org>
Date:   Mon, 17 Apr 2023 08:07:24 +0200
Subject: [PATCH net-next v2] net: wwan: Expose secondary AT port on DATA1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230414-rpmsg-wwan-secondary-at-port-v2-1-9a92ee5fdce2@nayarsystems.com>
X-B4-Tracking: v=1; b=H4sIABviPGQC/42OQQ6CMBBFr2Jm7RhakEZX3sO4GMooXdCSmQYlh
 rtbOIHLl5f897+gLIEVrocvCM9BQ4oF7PEAfqD4Ygx9YbCVravGNCjTqC98vymisk+xJ1mQMk5
 JMvads9S2nl1DUCY6UsZOKPphGxlJM8smJuFn+OzdO0TOGPmT4VHMEDQnWfZDs9n9f+3ZoMG2d
 3XlztZdjLlFWkh0Kc1RTz6N8FjX9Qfo8LZM8gAAAA==
To:     Stephan Gerhold <stephan@gerhold.net>,
        Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jaime Breva <jbreva@nayarsystems.com>
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1681711714; l=1265;
 i=jbreva@nayarsystems.com; s=20230414; h=from:subject:message-id;
 bh=1WTzpR+mBMBfSqD/OgcIDBuNMJRNY2nmzINPv49QF20=;
 b=zNT/nWm34120glSznHCZgDmFbJYfWmJyWVjiOXjrCqzvH+xvhDcvYQCUZn8HsqmfHacDiLnR6
 nV7LVT1RtsDBAOJc8VXKnnuhXpR0gfKFNwArXZNtwf28H4Y/JZbpgcx
X-Developer-Key: i=jbreva@nayarsystems.com; a=ed25519;
 pk=zDC7l1kB518eXlRUJzDUyrUOKe2m/yx+62R/yqmd/kM=
X-Endpoint-Received: by B4 Relay for jbreva@nayarsystems.com/20230414 with auth_id=42
X-Original-From: Jaime Breva <jbreva@nayarsystems.com>
Reply-To: <jbreva@nayarsystems.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jaime Breva <jbreva@nayarsystems.com>

Our use-case needs two AT ports available:
One for running a ppp daemon, and another one for management

This patch enables a second AT port on DATA1

Signed-off-by: Jaime Breva <jbreva@nayarsystems.com>
---
Changes in v2:
- Modified subject prefix to be netdev list compliant
- Link to v1: https://lore.kernel.org/r/20230414-rpmsg-wwan-secondary-at-port-v1-1-6d7307527911@nayarsystems.com
---
 drivers/net/wwan/rpmsg_wwan_ctrl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wwan/rpmsg_wwan_ctrl.c b/drivers/net/wwan/rpmsg_wwan_ctrl.c
index 31c24420ab2e..e964bdeea2b3 100644
--- a/drivers/net/wwan/rpmsg_wwan_ctrl.c
+++ b/drivers/net/wwan/rpmsg_wwan_ctrl.c
@@ -149,6 +149,7 @@ static const struct rpmsg_device_id rpmsg_wwan_ctrl_id_table[] = {
 	/* RPMSG channels for Qualcomm SoCs with integrated modem */
 	{ .name = "DATA5_CNTL", .driver_data = WWAN_PORT_QMI },
 	{ .name = "DATA4", .driver_data = WWAN_PORT_AT },
+	{ .name = "DATA1", .driver_data = WWAN_PORT_AT },
 	{},
 };
 MODULE_DEVICE_TABLE(rpmsg, rpmsg_wwan_ctrl_id_table);

---
base-commit: c9c3395d5e3dcc6daee66c6908354d47bf98cb0c
change-id: 20230414-rpmsg-wwan-secondary-at-port-db72a66ce74a

Best regards,
-- 
Jaime Breva <jbreva@nayarsystems.com>

