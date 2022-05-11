Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 638A7522D39
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 09:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241389AbiEKHZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 03:25:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiEKHZh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 03:25:37 -0400
Received: from m15113.mail.126.com (m15113.mail.126.com [220.181.15.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A64821C94EC;
        Wed, 11 May 2022 00:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=C7Z/r
        x32c/cR9tT2PP2QxCWlQz3jKgGCRgpp9g7dDHM=; b=Ze0dgM1umeB5q9cYf6OHN
        7TL9RN4hFO5KAbE16H0j0NgFECHQV7O/8Cp/E2mrtu+PYBXzy7CGwrbnWDTsxG7b
        Bno/Bw695u+SEASpWMc3QQgyuI74xvXlTy318FuzgRbnRsKF3LXZTyOCkRWLYhyW
        xpQcdjW0McG+cA2TXmIG1o=
Received: from ubuntu.localdomain (unknown [58.213.83.157])
        by smtp3 (Coremail) with SMTP id DcmowAAHA5zaZHti+k_FBQ--.16427S4;
        Wed, 11 May 2022 15:25:15 +0800 (CST)
From:   Bernard Zhao <zhaojunkui2008@126.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bernard Zhao <zhaojunkui2008@126.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Bernard Zhao <bernard@vivo.com>
Subject: [PATCH] ethernet/ti: delete if NULL check befort devm_kfree
Date:   Wed, 11 May 2022 00:25:10 -0700
Message-Id: <20220511072512.666863-1-zhaojunkui2008@126.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DcmowAAHA5zaZHti+k_FBQ--.16427S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7ZFW7JryDWw4DAr1kAryUtrb_yoW8AFW3pa
        93GF1UtFy7Zw4fGanrZF4rX345Wa1Sk3yDCry8CryfAw4Fyw1rtF18uFWDuFy5WrWkAay5
        AF4DAa4xXr1q9F7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pEt8nnUUUUU=
X-Originating-IP: [58.213.83.157]
X-CM-SenderInfo: p2kd0y5xqn3xasqqmqqrswhudrp/1tbiuRz9qlpD857i+QAAsd
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

devm_kfree check the point, there is no need to check before
devm_kfree call.
This change is to cleanup the code a bit.

Signed-off-by: Bernard Zhao <zhaojunkui2008@126.com>
Signed-off-by: Bernard Zhao <bernard@vivo.com>
---
 drivers/net/ethernet/ti/am65-cpsw-qos.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-qos.c b/drivers/net/ethernet/ti/am65-cpsw-qos.c
index ebcc6386cc34..16b8794cb13c 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-qos.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-qos.c
@@ -164,8 +164,7 @@ static void am65_cpsw_admin_to_oper(struct net_device *ndev)
 {
 	struct am65_cpsw_port *port = am65_ndev_to_port(ndev);
 
-	if (port->qos.est_oper)
-		devm_kfree(&ndev->dev, port->qos.est_oper);
+	devm_kfree(&ndev->dev, port->qos.est_oper);
 
 	port->qos.est_oper = port->qos.est_admin;
 	port->qos.est_admin = NULL;
@@ -432,11 +431,8 @@ static void am65_cpsw_purge_est(struct net_device *ndev)
 
 	am65_cpsw_stop_est(ndev);
 
-	if (port->qos.est_admin)
-		devm_kfree(&ndev->dev, port->qos.est_admin);
-
-	if (port->qos.est_oper)
-		devm_kfree(&ndev->dev, port->qos.est_oper);
+	devm_kfree(&ndev->dev, port->qos.est_admin);
+	devm_kfree(&ndev->dev, port->qos.est_oper);
 
 	port->qos.est_oper = NULL;
 	port->qos.est_admin = NULL;
@@ -522,8 +518,7 @@ static int am65_cpsw_set_taprio(struct net_device *ndev, void *type_data)
 	ret = am65_cpsw_configure_taprio(ndev, est_new);
 	if (!ret) {
 		if (taprio->enable) {
-			if (port->qos.est_admin)
-				devm_kfree(&ndev->dev, port->qos.est_admin);
+			devm_kfree(&ndev->dev, port->qos.est_admin);
 
 			port->qos.est_admin = est_new;
 		} else {
-- 
2.33.1

