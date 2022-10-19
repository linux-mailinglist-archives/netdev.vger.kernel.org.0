Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ADF560523D
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 23:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbiJSVvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 17:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230260AbiJSVvh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 17:51:37 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5845F18D448;
        Wed, 19 Oct 2022 14:51:36 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id r19so12612470qtx.6;
        Wed, 19 Oct 2022 14:51:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=B9BS0OtCWn0ox+Cz86hvmvKcDCubEqsZ4yAMu9/GWbQ=;
        b=Tagbyb82i5ua5ayPP/I9ftNAJ/fWiDjA6JSRz0b5lqGJa7INDFTZwESIQ4Oxcah9TL
         fH79CdFBvvVMNG/SGRvm6PjRM9jz49KasQKPoctnHA7Qi3sjVzgE44GRxQyX+20X+A/n
         3Y6Wor4W5p8cKvCJNA1YGp5rbSg391L0tvN2HE08AN36V6PefOUyAlpnj+JWoVZcHDkJ
         U0J2+C9c3a7ZTyfww4BWZk2ZoRg2vLwyaJr0quvCdSJXqiSKCUZSaEdM3uZGe9m0SRAT
         SqNVQ8i6uYB7r95qgUa5c4Y7f4GP2pvzDGNeZtkFpkoj89wLVlNT1qSdzZXNUi+suGvk
         buew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B9BS0OtCWn0ox+Cz86hvmvKcDCubEqsZ4yAMu9/GWbQ=;
        b=L4qljsklJkOe2t45WL2fZxZwe8+Gco+giDgzA+d+xIxrJ5fYOzy4lGtPw8kufUbqVh
         kEqj4uB2GLcbvNMkeLRftN7fBJD13dtkL1j1vG1TjVO9zu0nHQ/LvX8A7gTl27QgD+fr
         shAbsFUUX7WXz5g+D60iV8+VRIsDGxGX+N3jcq0K/sgh5wXoy6MvusjVrjjf/4ab+iwM
         hScmXG+p3ETD34A9PI2LPtnpax7Tzt43SHlTjGXMaPny8CXbWS9m6X4XN1SyF2vPHs4x
         iQ1P+bGObTWz34d9b//g1+hjea/5vj5QvioF+Ro8qoJHMU/Y2PMIi/PUkA0HVpJHOg8f
         nmOQ==
X-Gm-Message-State: ACrzQf2Mbm8re9sQqBYXtCHe0La9EIfBgcBfqCwFmSu9+mTOXbjGbpjL
        O4t6rgKhFKduXSyR/rr3QmE=
X-Google-Smtp-Source: AMsMyM7u/qQJdE95fyYzXHYPTT+EQLVO8+IRS48BANSvQTgTBUx7RfOGd307IninPDpResFdB0Icsw==
X-Received: by 2002:a05:622a:1804:b0:39c:c7ba:4ac1 with SMTP id t4-20020a05622a180400b0039cc7ba4ac1mr8248134qtc.457.1666216295441;
        Wed, 19 Oct 2022 14:51:35 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k2-20020a05620a414200b006bba46e5eeasm6225407qko.37.2022.10.19.14.51.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 14:51:34 -0700 (PDT)
From:   Doug Berger <opendmb@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net-next v2] net: bcmgenet: add RX_CLS_LOC_ANY support
Date:   Wed, 19 Oct 2022 14:51:23 -0700
Message-Id: <20221019215123.316997-1-opendmb@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a matching flow spec exists its current location is as good
as ANY. If not add the new flow spec at the first available
location.

Signed-off-by: Doug Berger <opendmb@gmail.com>
---
changes since v1:
 - removed __u32 tmp variable. Thanks Jakub!

 .../net/ethernet/broadcom/genet/bcmgenet.c    | 31 ++++++++++++++++---
 1 file changed, 27 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 25c450606985..a8ce8d0cf9c4 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1387,7 +1387,8 @@ static int bcmgenet_validate_flow(struct net_device *dev,
 	struct ethtool_usrip4_spec *l4_mask;
 	struct ethhdr *eth_mask;
 
-	if (cmd->fs.location >= MAX_NUM_OF_FS_RULES) {
+	if (cmd->fs.location >= MAX_NUM_OF_FS_RULES &&
+	    cmd->fs.location != RX_CLS_LOC_ANY) {
 		netdev_err(dev, "rxnfc: Invalid location (%d)\n",
 			   cmd->fs.location);
 		return -EINVAL;
@@ -1452,7 +1453,7 @@ static int bcmgenet_insert_flow(struct net_device *dev,
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 	struct bcmgenet_rxnfc_rule *loc_rule;
-	int err;
+	int err, i;
 
 	if (priv->hw_params->hfb_filter_size < 128) {
 		netdev_err(dev, "rxnfc: Not supported by this device\n");
@@ -1470,7 +1471,29 @@ static int bcmgenet_insert_flow(struct net_device *dev,
 	if (err)
 		return err;
 
-	loc_rule = &priv->rxnfc_rules[cmd->fs.location];
+	if (cmd->fs.location == RX_CLS_LOC_ANY) {
+		list_for_each_entry(loc_rule, &priv->rxnfc_list, list) {
+			cmd->fs.location = loc_rule->fs.location;
+			err = memcmp(&loc_rule->fs, &cmd->fs,
+				     sizeof(struct ethtool_rx_flow_spec));
+			if (!err)
+				/* rule exists so return current location */
+				return 0;
+		}
+		for (i = 0; i < MAX_NUM_OF_FS_RULES; i++) {
+			loc_rule = &priv->rxnfc_rules[i];
+			if (loc_rule->state == BCMGENET_RXNFC_STATE_UNUSED) {
+				cmd->fs.location = i;
+				break;
+			}
+		}
+		if (i == MAX_NUM_OF_FS_RULES) {
+			cmd->fs.location = RX_CLS_LOC_ANY;
+			return -ENOSPC;
+		}
+	} else {
+		loc_rule = &priv->rxnfc_rules[cmd->fs.location];
+	}
 	if (loc_rule->state == BCMGENET_RXNFC_STATE_ENABLED)
 		bcmgenet_hfb_disable_filter(priv, cmd->fs.location);
 	if (loc_rule->state != BCMGENET_RXNFC_STATE_UNUSED) {
@@ -1583,7 +1606,7 @@ static int bcmgenet_get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd,
 		break;
 	case ETHTOOL_GRXCLSRLCNT:
 		cmd->rule_cnt = bcmgenet_get_num_flows(priv);
-		cmd->data = MAX_NUM_OF_FS_RULES;
+		cmd->data = MAX_NUM_OF_FS_RULES | RX_CLS_LOC_SPECIAL;
 		break;
 	case ETHTOOL_GRXCLSRULE:
 		err = bcmgenet_get_flow(dev, cmd, cmd->fs.location);
-- 
2.25.1

