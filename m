Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 632044E861F
	for <lists+netdev@lfdr.de>; Sun, 27 Mar 2022 07:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235292AbiC0F5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Mar 2022 01:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232607AbiC0F5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Mar 2022 01:57:37 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F95DFC3;
        Sat, 26 Mar 2022 22:55:56 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id o13so9751245pgc.12;
        Sat, 26 Mar 2022 22:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=5Nr8/pFlwttFmPB+xe860EnW58mqgkRWkMhigtxDUnM=;
        b=CHuDEGbyFSTBlxpigf52Xr4VP0Y01ep8wZtJfeCG2wMGIzQYPUZVJOb2eh/wxk7mYo
         aFoT8tJ9cIysIYyPnK9/o6+bkxse8dYURTOQ81oLy/XAA20TVGjzUW9M/xN23YxB/tUn
         swhwkKcJfYmVx566ZvFEAaxhMlWbK6J61wPBTfZnSYCnufgzBoEmzqUpSLQcIIieG7d/
         0bV5QWIH7HYCEqXb8Zt5puXeRuU2tQax9mKmyuTihTj0AAxPr/qj4FNM52JsnzN445Di
         BE0b8osWRXyMzCfRxaHND8Y37M8iV/2x8T3VluL5jITtzahvF1vMJF8MJ+Mphwg7w33e
         Yleg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=5Nr8/pFlwttFmPB+xe860EnW58mqgkRWkMhigtxDUnM=;
        b=rsmXC8Lt7DLueofamEBYTfo92k4erQgUzW44akLuZyxOvAhpsP6/BHc4TO554Cvys/
         CIa6ZtdnW/3joxtjwj37Kanm+pN7pc5ER7M6/PoMeV2sDXora7vPSJWBvvqHmeGRdrK/
         jPiZVQZXzMzhaZLa1RKfHlOgE918aMubMu0nSrZ5T3x95O7asiRkWktSy2/syoX+E4Ts
         Pv9rt67wlz62FgDl8sheziEvx2kHD2bvLVzTKDsS7QdTPvpjy5OcvwtFsv2uYpAU2Ehz
         SM29BOrxa6vGiiXQfoS8caKnyK+Gon2qG+R4qdmmnbxNLFyUt6S5HhzoXktEotRum7mk
         wQXQ==
X-Gm-Message-State: AOAM532Ui//jmzcWabrBPyBVZNpy1VJNAR1tPVx+Fi+uXJTwSru512xA
        ZXYhuJBD6R0MOHEr+2AfcMw=
X-Google-Smtp-Source: ABdhPJxoW4OWpcp3oYcZUkU1dQCGaNF4ctfMIbD6xVCpJU4sx4TOejUgmdS4kgOLsVvUnV/W8Gx0og==
X-Received: by 2002:a65:6082:0:b0:382:712b:56c7 with SMTP id t2-20020a656082000000b00382712b56c7mr5854471pgu.563.1648360556366;
        Sat, 26 Mar 2022 22:55:56 -0700 (PDT)
Received: from localhost.localdomain ([115.220.243.108])
        by smtp.googlemail.com with ESMTPSA id k6-20020a056a00134600b004faba67f9d4sm11902165pfu.197.2022.03.26.22.55.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Mar 2022 22:55:55 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     andrew@lunn.ch
Cc:     vivien.didelot@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] dsa: bcm_sf2_cfp: fix an incorrect NULL check on list iterator
Date:   Sun, 27 Mar 2022 13:55:47 +0800
Message-Id: <20220327055547.3938-1-xiam0nd.tong@gmail.com>
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

Cc: stable@vger.kernel.org
Fixes: ae7a5aff783c7 ("net: dsa: bcm_sf2: Keep copy of inserted rules")
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

