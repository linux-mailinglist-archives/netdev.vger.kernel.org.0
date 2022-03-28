Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59A374E8C93
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 05:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236512AbiC1D0X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Mar 2022 23:26:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232900AbiC1D0W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Mar 2022 23:26:22 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 850D54757F;
        Sun, 27 Mar 2022 20:24:42 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id k14so11240784pga.0;
        Sun, 27 Mar 2022 20:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=StWsfRvIf8NP0BN7pKBIBz96vmouHPlYLHze1UYeSYc=;
        b=CC7aF5L1RaStECNMFPD/eWFADbvMNwuUsWDyscAx6IFh2rlYRzcs8ssb9V8oPEfkpz
         AbTc3eS851kHxcR2sN8SfQ1xhIRhrPs34DDip2JZNmjRZqOJOuJiMRDkzAOGCrZDdAp2
         xOyMhT/7By00c/ZWVePvdQ6EmvE4WYw2ZK/hPiyxXEwawozk+SI1t+7ZlibwRooOe+GV
         N3l4xIVeEPwrb89nho+EMeD2cH4gU421/l3ImDa03nZPLLZdrsmyHpzQohBaLSrOu7cd
         k/mEr1yFABxbiH18zk9yZfNjBrMs27gz79doBw1B8U2OeuOXFXypsMTypRmcGUZzwkkr
         QgRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=StWsfRvIf8NP0BN7pKBIBz96vmouHPlYLHze1UYeSYc=;
        b=vtlyG260/IvA9I8+F5303GUwVIZdXNJwEcvPyBqLkTJu1kG38wvsjOZbeswMEaL3xF
         QnOX5gfSanObXaDxRwo1+AYu0MWvPoDFhqnPKgpeYc7iREzy/8TPhZVZDPUATsMxccKJ
         pRxgDeNTWD/GXxClmEpUiFHNOkRhWFZIV81/pdncqiJt85Dh/urcOcNMfNyfLXT9GHi+
         /SvZR4tgnw87zOk+i0igjw2SBMp9iZGisRclvm9eUzGfMxlODlnSO0lbDvAUyQXaH//n
         zQCWuTxGxkSJ/ZSxLroSm6sdwVRMn2B0MSsHgeUifh4jYNdH29h9sPQQWq0ousBYNt4m
         50IA==
X-Gm-Message-State: AOAM530rdmMhBSAHkSZvIsrfwlKIy2o3oXZkNgxPGMeo7W2BtAFb/gQD
        Vkl26rBIHqNQmCelB0BjvUA=
X-Google-Smtp-Source: ABdhPJwld6WMH1Hvr/UgfeTGgR05knyPDtXUgWcA2pvpoKH1lzmByFdZDqXnQv+wruFxRBkbNgAHyA==
X-Received: by 2002:a65:4cc9:0:b0:381:4472:bbb4 with SMTP id n9-20020a654cc9000000b003814472bbb4mr8670465pgt.10.1648437881937;
        Sun, 27 Mar 2022 20:24:41 -0700 (PDT)
Received: from ubuntu.huawei.com ([119.3.119.18])
        by smtp.googlemail.com with ESMTPSA id r4-20020a638f44000000b0038105776895sm11225763pgn.76.2022.03.27.20.24.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Mar 2022 20:24:41 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     f.fainelli@gmail.com
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>
Subject: [PATCH] net: dsa: bcm_sf2_cfp: fix an incorrect NULL check on list iterator
Date:   Mon, 28 Mar 2022 11:24:31 +0800
Message-Id: <20220328032431.22538-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bug is here:
	return rule;

The list iterator value 'rule' will *always* be set and non-NULL
by list_for_each_entry(), so it is incorrect to assume that the
iterator value will be NULL if the list is empty or no element
is found.

To fix the bug, return 'rule' when found, otherwise return NULL.

Fixes: ae7a5aff783c7 ("net: dsa: bcm_sf2: Keep copy of inserted rules")
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---
 drivers/net/dsa/bcm_sf2_cfp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/bcm_sf2_cfp.c b/drivers/net/dsa/bcm_sf2_cfp.c
index a7e2fcf2df2c..edbe5e7f1cb6 100644
--- a/drivers/net/dsa/bcm_sf2_cfp.c
+++ b/drivers/net/dsa/bcm_sf2_cfp.c
@@ -567,14 +567,14 @@ static void bcm_sf2_cfp_slice_ipv6(struct bcm_sf2_priv *priv,
 static struct cfp_rule *bcm_sf2_cfp_rule_find(struct bcm_sf2_priv *priv,
 					      int port, u32 location)
 {
-	struct cfp_rule *rule = NULL;
+	struct cfp_rule *rule;
 
 	list_for_each_entry(rule, &priv->cfp.rules_list, next) {
 		if (rule->port == port && rule->fs.location == location)
-			break;
+			return rule;
 	}
 
-	return rule;
+	return NULL;
 }
 
 static int bcm_sf2_cfp_rule_cmp(struct bcm_sf2_priv *priv, int port,
-- 
2.17.1

