Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B18D54FCC98
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 04:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238000AbiDLCsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 22:48:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230519AbiDLCsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 22:48:13 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9BF720F74;
        Mon, 11 Apr 2022 19:45:57 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id cw11so166890pfb.1;
        Mon, 11 Apr 2022 19:45:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=yDzV8oILCqZnZHmcWwpZe6R6V8go9wvrc35SpOP7S1U=;
        b=D8ocojwebwAuVJECvGE3HrvkWDauww9u6f7Tl2oYIPQ0gsIgMB9u8uztM/2K0GwILr
         3HKcPawRWq/xTBxzs7fAJWCdQDykBOqi9Qm4rusaEJxnhpe+FH1gcpQeex0PEaOHw1Wi
         Y3tVLouwBnAYqN7TsejC8fHS3fxX/QOLwGWIByepGEU/4W9/cgmv/vI0QQMczSQtjgbS
         8e5RrQG+a04nCTgD6J56U8UyeofccX7OPy0Aw8PTnZtZPKKlEhptmCuugEw0qpKE9q1e
         Y2ee3+S7FMwaGo8KslZCyV56rnc548CqSdwY533xCGo4+K+7bZ6GyE1NROmIeifna0my
         jDbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=yDzV8oILCqZnZHmcWwpZe6R6V8go9wvrc35SpOP7S1U=;
        b=kWabYskaacVYr3+Py3568rqq7W0925kc7rlvml3GU8t0MCJ9wqLv2dY23o7H3RG6Qn
         I3+jsKpgZwmficZ0LxEYexlBg4Md1ywL3jINUdJ5ePbdeFCTT9EA5IKI/RRRiwF5ZF9l
         Crh8az2riTlQc4x/3DvyVwgIkRb6yhoygi+aiKvkzBYCPUs1qZ00xluGOW6I+AeE153R
         45BpKbyzdeekseeZeFt5taI0/K55SA+1hoHRhr/mieuNuYbZJBG0oavd3ac2+3OuUbq4
         NrvRIGrp+madrs0dbyqHRe8/881UzMPjU0no5/vN6megqnr6JgsA8/YkKIVrT7fms5Or
         2yoQ==
X-Gm-Message-State: AOAM531Y6rZY8Ld5kg3p0404Z9yYRKfx6C1lusIgct3SR5s3cIetBkG5
        /9+mP2krnlDfN5UKNK9LhSA=
X-Google-Smtp-Source: ABdhPJwLv2s0hYbECpt+KrTxAUtWfKxURyUPcYqhypTkKJB1l2YLb3wo5HcbuWO7LmtHMRIJHcJ6hA==
X-Received: by 2002:aa7:8094:0:b0:505:b544:d1ca with SMTP id v20-20020aa78094000000b00505b544d1camr10176143pff.26.1649731557334;
        Mon, 11 Apr 2022 19:45:57 -0700 (PDT)
Received: from localhost.localdomain ([159.226.95.43])
        by smtp.googlemail.com with ESMTPSA id f16-20020a056a00239000b004fa7103e13csm38292926pfc.41.2022.04.11.19.45.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 19:45:57 -0700 (PDT)
From:   Miaoqian Lin <linmq006@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ansuel Smith <ansuelsmth@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     linmq006@gmail.com
Subject: [PATCH] net: dsa: Fix return value check of wait_for_completion_timeout
Date:   Tue, 12 Apr 2022 02:45:40 +0000
Message-Id: <20220412024541.17572-1-linmq006@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

wait_for_completion_timeout() returns unsigned long not int.
It returns 0 if timed out, and positive if completed.
The check for <= 0 is ambiguous and should be == 0 here
indicating timeout which is the only error case.

Fixes: 2cd548566384 ("net: dsa: qca8k: add support for phy read/write with mgmt Ethernet")
Fixes: 5950c7c0a68c ("net: dsa: qca8k: add support for mgmt read/write in Ethernet packet")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
---
 drivers/net/dsa/qca8k.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index d3ed0a7f8077..bd8c238955a8 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -300,7 +300,7 @@ static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 	struct qca8k_mgmt_eth_data *mgmt_eth_data = &priv->mgmt_eth_data;
 	struct sk_buff *skb;
 	bool ack;
-	int ret;
+	unsigned long ret;
 
 	skb = qca8k_alloc_mdio_header(MDIO_READ, reg, NULL,
 				      QCA8K_ETHERNET_MDIO_PRIORITY, len);
@@ -338,7 +338,7 @@ static int qca8k_read_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 
 	mutex_unlock(&mgmt_eth_data->mutex);
 
-	if (ret <= 0)
+	if (ret == 0)
 		return -ETIMEDOUT;
 
 	if (!ack)
@@ -352,7 +352,7 @@ static int qca8k_write_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 	struct qca8k_mgmt_eth_data *mgmt_eth_data = &priv->mgmt_eth_data;
 	struct sk_buff *skb;
 	bool ack;
-	int ret;
+	unsigned long ret;
 
 	skb = qca8k_alloc_mdio_header(MDIO_WRITE, reg, val,
 				      QCA8K_ETHERNET_MDIO_PRIORITY, len);
@@ -386,7 +386,7 @@ static int qca8k_write_eth(struct qca8k_priv *priv, u32 reg, u32 *val, int len)
 
 	mutex_unlock(&mgmt_eth_data->mutex);
 
-	if (ret <= 0)
+	if (ret == 0)
 		return -ETIMEDOUT;
 
 	if (!ack)
@@ -956,7 +956,7 @@ qca8k_phy_eth_busy_wait(struct qca8k_mgmt_eth_data *mgmt_eth_data,
 {
 	struct sk_buff *skb = skb_copy(read_skb, GFP_KERNEL);
 	bool ack;
-	int ret;
+	unsigned long ret;
 
 	reinit_completion(&mgmt_eth_data->rw_done);
 
@@ -972,7 +972,7 @@ qca8k_phy_eth_busy_wait(struct qca8k_mgmt_eth_data *mgmt_eth_data,
 
 	ack = mgmt_eth_data->ack;
 
-	if (ret <= 0)
+	if (ret == 0)
 		return -ETIMEDOUT;
 
 	if (!ack)
@@ -993,6 +993,7 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 	struct net_device *mgmt_master;
 	int ret, ret1;
 	bool ack;
+	unsigned long time_left;
 
 	if (regnum >= QCA8K_MDIO_MASTER_MAX_REG)
 		return -EINVAL;
@@ -1059,12 +1060,12 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 
 	dev_queue_xmit(write_skb);
 
-	ret = wait_for_completion_timeout(&mgmt_eth_data->rw_done,
-					  QCA8K_ETHERNET_TIMEOUT);
+	time_left = wait_for_completion_timeout(&mgmt_eth_data->rw_done,
+						QCA8K_ETHERNET_TIMEOUT);
 
 	ack = mgmt_eth_data->ack;
 
-	if (ret <= 0) {
+	if (time_left == 0) {
 		ret = -ETIMEDOUT;
 		kfree_skb(read_skb);
 		goto exit;
@@ -1096,12 +1097,12 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 
 		dev_queue_xmit(read_skb);
 
-		ret = wait_for_completion_timeout(&mgmt_eth_data->rw_done,
-						  QCA8K_ETHERNET_TIMEOUT);
+		time_left = wait_for_completion_timeout(&mgmt_eth_data->rw_done,
+							QCA8K_ETHERNET_TIMEOUT);
 
 		ack = mgmt_eth_data->ack;
 
-		if (ret <= 0) {
+		if (time_left == 0) {
 			ret = -ETIMEDOUT;
 			goto exit;
 		}
-- 
2.17.1

