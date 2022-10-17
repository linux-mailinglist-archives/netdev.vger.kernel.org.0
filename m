Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46435601B55
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 23:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbiJQVdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 17:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbiJQVdG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 17:33:06 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF0217CB66;
        Mon, 17 Oct 2022 14:33:02 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id m6so7546190qkm.4;
        Mon, 17 Oct 2022 14:33:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zsL7sE2NY9nd+Z7C5awnq6ymEQUvmX75a8CLY1tINwQ=;
        b=PgCnWtz/NwW1XoM9JOUmaoo+DPu3mJV9uQIVpqFsx5zmy9L6s67Ik5HkOuUxsgZoT0
         rlKUJL0BOZZcwSgJJfeazFzj/RW3m4PZPexzzEJ0YX8HgeY3nA4bUPMLzvdksdcwY47e
         Ufd7B+9FwBwBJhXXgEziuVeaTkU68XCkb/IsaUht+UCeX7ToStClfZR1yNHaL5oT7s+T
         ITFHNaNs4UXzyFM4urVsFK+S9+9fzWger9iDTFL6KE9up2SBT5rgUoGZZTfRGw72MoZB
         /+ad0nLeC2k2xpdVDTqFF71hgV9gpHcS+JBp/+9HAtGsHS2Jb/kvOrr1zPMoJTMTMihp
         sOew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zsL7sE2NY9nd+Z7C5awnq6ymEQUvmX75a8CLY1tINwQ=;
        b=gprtj8EQmg2wOzeyXX33ZkQz/9sD3QX1MfqnvU+iHlnl1JtKh2jeGPb7U5U8ujMzRR
         ltNYB/eXSFpp3PC2FdO8XI8jJIiM7re1dr1UDnsqQKLMvDIsSkmAPeU9Hkd6JvVaOfXC
         VVEk63EfMBbEjWWlLQXaVPAs/8ZSlC7Miaam3EvanUztScUMJkF/3BKE3uA7w1e+z0So
         USyWxkRUbYVA2wazWr3GWJEKVZ9wJmF/UiPSeXZ/X+rF8RV2tRfT5oFg7EaSPgARYq68
         vf/0TvZhdqCFdiCj8olJCe3+ZLKKesPnwhnjcEE4rfZfWdFdcIed9CY0xf9H/8O4S4UB
         p41g==
X-Gm-Message-State: ACrzQf2wiO8BSxKg1qejvT9raoSnlz0XFDpckWAgKNTvU6DMJkVquDHY
        pFXXPtUI4KzWkQ8C/8Pptg1cMoGorv4=
X-Google-Smtp-Source: AMsMyM5k9qMb3dSiXR8L3wfh/wImObAYAmKPabyfCrxvV6k6rooh+oe/+RzHHtBalHFg8/HJPNf6cQ==
X-Received: by 2002:a05:620a:2b92:b0:6ed:b30a:d564 with SMTP id dz18-20020a05620a2b9200b006edb30ad564mr9368693qkb.234.1666042380839;
        Mon, 17 Oct 2022 14:33:00 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s7-20020a05620a254700b006ec59941acasm786335qko.11.2022.10.17.14.32.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 14:33:00 -0700 (PDT)
From:   Doug Berger <opendmb@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net-next] net: bcmgenet: add RX_CLS_LOC_ANY support
Date:   Mon, 17 Oct 2022 14:32:37 -0700
Message-Id: <20221017213237.814861-1-opendmb@gmail.com>
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
 .../net/ethernet/broadcom/genet/bcmgenet.c    | 32 +++++++++++++++++--
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 25c450606985..9b1e544547f7 100644
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
@@ -1452,6 +1453,7 @@ static int bcmgenet_insert_flow(struct net_device *dev,
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 	struct bcmgenet_rxnfc_rule *loc_rule;
+	__u32 tmp;
 	int err;
 
 	if (priv->hw_params->hfb_filter_size < 128) {
@@ -1470,7 +1472,31 @@ static int bcmgenet_insert_flow(struct net_device *dev,
 	if (err)
 		return err;
 
-	loc_rule = &priv->rxnfc_rules[cmd->fs.location];
+	if (cmd->fs.location == RX_CLS_LOC_ANY) {
+		list_for_each_entry(loc_rule, &priv->rxnfc_list, list) {
+			tmp = loc_rule->fs.location;
+			loc_rule->fs.location = cmd->fs.location;
+			err = memcmp(&loc_rule->fs, &cmd->fs,
+				     sizeof(struct ethtool_rx_flow_spec));
+			loc_rule->fs.location = tmp;
+			if (!err) {
+				/* rule exists so return current location */
+				cmd->fs.location = tmp;
+				return 0;
+			}
+		}
+		for (tmp = 0; tmp < MAX_NUM_OF_FS_RULES; tmp++) {
+			loc_rule = &priv->rxnfc_rules[tmp];
+			if (loc_rule->state == BCMGENET_RXNFC_STATE_UNUSED) {
+				cmd->fs.location = tmp;
+				break;
+			}
+		}
+		if (tmp == MAX_NUM_OF_FS_RULES)
+			return -ENOSPC;
+	} else {
+		loc_rule = &priv->rxnfc_rules[cmd->fs.location];
+	}
 	if (loc_rule->state == BCMGENET_RXNFC_STATE_ENABLED)
 		bcmgenet_hfb_disable_filter(priv, cmd->fs.location);
 	if (loc_rule->state != BCMGENET_RXNFC_STATE_UNUSED) {
@@ -1583,7 +1609,7 @@ static int bcmgenet_get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd,
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

