Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD9F053DAAF
	for <lists+netdev@lfdr.de>; Sun,  5 Jun 2022 09:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244463AbiFEHXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jun 2022 03:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244436AbiFEHXq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jun 2022 03:23:46 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 856D34D9FC;
        Sun,  5 Jun 2022 00:23:45 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 123so160989pgb.5;
        Sun, 05 Jun 2022 00:23:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lpdFmuNxC9XwLxLn9QnD8h2e+0XogbW/IbiO6HXkdgw=;
        b=ilgAI5/5OaGTYa+UFhLN0e3es1ZeqzsaH7pSke7sIYpVONTV3/Cipvx441Olnx5+lS
         Fop/XvEJxK0VtzGtoRN1litHB/G1murzvI5VsXZUhz3CjLpGrWtpDYedy7p3e12PBkzJ
         9x59id8hMdPmGGJku0cvMrYP+17Vn6yv/UnQkXMBj0++7uBaCOJ7S76e3UDOnS0i0qnG
         vf9DObC5+xC8aZzHUJDjuUgf5/WvHg9FV+/+iWHBvi2PQ4G5PUuJWLG2iKUPPqbBuFLi
         2J5t59mvAdjbR0TdgaZl04DFdIZRwmcplukx3LlO/QrgjM5Nb3a3IYGSCLMkY3hKCtfE
         F0CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lpdFmuNxC9XwLxLn9QnD8h2e+0XogbW/IbiO6HXkdgw=;
        b=tpzFNC0wkEaEn6pgTzHS69Z1OjhbYs0uS588kT2+UQoMxZgT0uyWOY+7vfegU1RlD1
         DsGdUlxYRHht14kwwa0p77yNFMR7PCS5HBTmS8tPGYgajnT56YBlb4eimRYIQgi4qQOq
         LdRJ2VGvqQf2Obw1yiweqEKKq9Mps1s4JOmbngoYNLMBr2irHEjKD5ZmJC3xpJ4suLq7
         ipHv+GZolunEfGk0GC6+Zk1WpJaEVKx2zjfV7b3s4E3OpyzfjQ3kK3wIU3qsEs+Fzlrm
         a3C+YZ/bz1S6XTPuS3webAT+RVlrOK27tWCwbAZZy7maKvUYwnZRUCSfOaY+lRbq9/2A
         mu8A==
X-Gm-Message-State: AOAM530/UeM8T9MWC6/ECtVEDC/Y22oamS8drcot+bx3pq1NEWa1XAWY
        9aoXzI4lOa4vWvfO0fTZHRk=
X-Google-Smtp-Source: ABdhPJze84HnEWxjxKNLknGNkjEfMYxi/mhjbTdPIMRbFp+nPqi7S17CmE50CAdCayWMqAnoZ30mKw==
X-Received: by 2002:a63:9752:0:b0:3c6:5a7a:5bd6 with SMTP id d18-20020a639752000000b003c65a7a5bd6mr16196061pgo.390.1654413825055;
        Sun, 05 Jun 2022 00:23:45 -0700 (PDT)
Received: from localhost.localdomain ([202.120.234.246])
        by smtp.googlemail.com with ESMTPSA id l24-20020a17090ac59800b001e25e3ba05csm12698226pjt.2.2022.06.05.00.23.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jun 2022 00:23:44 -0700 (PDT)
From:   Miaoqian Lin <linmq006@gmail.com>
To:     Hauke Mehrtens <hauke@hauke-m.de>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     linmq006@gmail.com
Subject: [PATCH] net: dsa: lantiq_gswip: Fix refcount leak in gswip_gphy_fw_list
Date:   Sun,  5 Jun 2022 11:23:34 +0400
Message-Id: <20220605072335.11257-1-linmq006@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Every iteration of for_each_available_child_of_node() decrements
the reference count of the previous node.
when breaking early from a for_each_available_child_of_node() loop,
we need to explicitly call of_node_put() on the gphy_fw_np.
Add missing of_node_put() to avoid refcount leak.

Fixes: 14fceff4771e ("net: dsa: Add Lantiq / Intel DSA driver for vrx200")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
---
 drivers/net/dsa/lantiq_gswip.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 8af4def38a98..e531b93f3cb2 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -2070,8 +2070,10 @@ static int gswip_gphy_fw_list(struct gswip_priv *priv,
 	for_each_available_child_of_node(gphy_fw_list_np, gphy_fw_np) {
 		err = gswip_gphy_fw_probe(priv, &priv->gphy_fw[i],
 					  gphy_fw_np, i);
-		if (err)
+		if (err) {
+			of_node_put(gphy_fw_np);
 			goto remove_gphy;
+		}
 		i++;
 	}
 
-- 
2.25.1

