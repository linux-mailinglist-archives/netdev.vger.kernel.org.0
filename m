Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1C946E21CB
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 13:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbjDNLKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 07:10:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbjDNLKJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 07:10:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DDC49EFA;
        Fri, 14 Apr 2023 04:09:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E6BD3646CF;
        Fri, 14 Apr 2023 11:09:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 469B9C433D2;
        Fri, 14 Apr 2023 11:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681470587;
        bh=dCWQvGEBkXfONfpK8qRsz+qQGvbMNYwp8pY9BT7oHlM=;
        h=From:Date:Subject:To:Cc:Reply-To:From;
        b=gojfUNusRFaxsw+K+iU6qmS0wnoIF3H+MO6I41GnkfBqHWvCdBR8gtOlREW9d08Bx
         219Bjq8YmQzuP8eQvxqU6FOasO0WYXmWh8xK58ggcf366u+7RloteUDHW2jZ3isl7Z
         cGMv1M+KR6319Lidsor26t5p/XHa8wp2Z49xM4KXrPt3rOpIMMcsK7ctfaHAKMNxWd
         VDqfhpuQuGid39lmj/wiznEHqQ4GsBUdiyJzVduzhK8JaovNxazIkftMTKEroIUqFD
         28LXg/OiDpO43srB7ejb0EItsRGniB5L5jqUQD1Ku8PkazXE7OEQiIQ8US2niVbqrD
         2l+CdknqWPfMA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.lore.kernel.org (Postfix) with ESMTP id 28B3FC77B72;
        Fri, 14 Apr 2023 11:09:47 +0000 (UTC)
From:   Jaime Breva via B4 Relay 
        <devnull+jbreva.nayarsystems.com@kernel.org>
Date:   Fri, 14 Apr 2023 13:07:40 +0200
Subject: [PATCH] net: wwan: Expose secondary AT port on DATA1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230414-rpmsg-wwan-secondary-at-port-v1-1-6d7307527911@nayarsystems.com>
X-B4-Tracking: v=1; b=H4sIAPwzOWQC/x2NQQqDMBAAvyJ77oKmQaFfKT1skq3mYBJ2Q7WIf
 2/scRiYOUBZIis8ugOEP1FjTg2GWwd+oTQzxtAYTG/uvR0sSll1xm2jhMo+p0DyRapYslQMbjI
 0jp4nS9ASjpTRCSW/XJGVtLJcogi/4/7/Pl/n+QMph2lPhwAAAA==
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1681470586; l=1075;
 i=jbreva@nayarsystems.com; s=20230414; h=from:subject:message-id;
 bh=cSR4ZQap91Ye+xWxHZdF++TRRzXHB58d7aORnQDEYqM=;
 b=UtqPg4Ls/omSuTtTSlV0VkJABHHRNDsCfzzMZBGbx0UTm78zIV39iYILVj5p0bOVV8LWiNvRi
 1InMJSqRsISARwe/xrdCFAgj+PEDNk4JRU+vdLJAYeKPJMiP3rqDHnJ
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

