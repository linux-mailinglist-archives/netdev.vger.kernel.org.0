Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 748EE535109
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 16:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347720AbiEZOwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 10:52:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347844AbiEZOwW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 10:52:22 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A81272736;
        Thu, 26 May 2022 07:52:19 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id cv10so1950478pjb.4;
        Thu, 26 May 2022 07:52:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Chwf7y1RtksUbq1MRPEZtP7ng/hgzSfVOfHBHdn9xZo=;
        b=L4tFN4lVB/mgJJ4IeFPlN7YEU6qsVmDtRbR1EuSZJYwMQ+Jk/7iWqp35wKDTraSsil
         OXbUWPtHxKgGyZtH9k+7ZViFv/TKqx6HlHQASxHiHbYChunP/JY+fmowHfWoRegpmTMf
         +/mVaCiioxfvHbWlu6Udc8KnPg3RlsU9Jx7BJO8oYgOZ0Pbvb+vKfdoQjTOrM8uMorqo
         msix4UXAqc3U0B2YnxpUVN/TNy/4irtmLPb1/63xBeNQBQFpBxugF1ue0FCG3xxv8jkD
         06pXyv3R/hzpzl1H0k0JOEKq2ciR1A9bZ2be9h+tiKXEwHC5FnSGPbDobZLYCJpaceJM
         4V7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Chwf7y1RtksUbq1MRPEZtP7ng/hgzSfVOfHBHdn9xZo=;
        b=NSWw5LR5fIInkTl8ZkVqXxI+6Id3RHI8x3mbSYLoeK15kGCUtDSQvaJAbeioE3ZAie
         JB/kNyBLkOIx9Umi8sv3aZK9QmkDOoAK8CPQTy4WOMQ0ufYW7zDPqBdBBmQxu3O1Q6/f
         WuC2BegQTljDHBQ//0srlUQLokffwY/t75xQEvg8csZvbFczad9pZ6aKdHVSCocp6bsv
         TrmQPFuAdnKX23Y6f/d06u4GUixZPiG0TmwRYnbQ4koLHfrF5Y4qVHRReuPuaePC4ho3
         41HNNwpstgZZT1qX1SsKKzZG2tofy3aS8viM66hToMN511B1H+Sp4ZGdEyWyh2ug1QqI
         5fmQ==
X-Gm-Message-State: AOAM532s1aNnS30ocjZX+yFrsZA92IhUkPI37EQa8pKMPLjZ2TgcvETu
        3CLmIUXXkGyabpjT1wlhWAQ=
X-Google-Smtp-Source: ABdhPJyQyLvEus3Wy488EJJsivQvh95OSL+k8gz6NEghH+RZoxufUt0R/0ihabXhF5bq7rfw7zFOLg==
X-Received: by 2002:a17:902:ba97:b0:161:524d:5adb with SMTP id k23-20020a170902ba9700b00161524d5adbmr37819511pls.126.1653576738922;
        Thu, 26 May 2022 07:52:18 -0700 (PDT)
Received: from localhost.localdomain ([202.120.234.246])
        by smtp.googlemail.com with ESMTPSA id n1-20020a17090aab8100b001e0d197898dsm1964168pjq.3.2022.05.26.07.52.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 07:52:18 -0700 (PDT)
From:   Miaoqian Lin <linmq006@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     linmq006@gmail.com
Subject: [PATCH v3] net: dsa: mv88e6xxx: Fix refcount leak in mv88e6xxx_mdios_register
Date:   Thu, 26 May 2022 18:52:08 +0400
Message-Id: <20220526145208.25673-1-linmq006@gmail.com>
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

of_get_child_by_name() returns a node pointer with refcount
incremented, we should use of_node_put() on it when done.

mv88e6xxx_mdio_register() pass the device node to of_mdiobus_register().
We don't need the device node after it.

Add missing of_node_put() to avoid refcount leak.

Fixes: a3c53be55c95 ("net: dsa: mv88e6xxx: Support multiple MDIO busses")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
---
changes in v2:
- Add fixes tag.
changes in v3:
- Move of_node_put() statement to cover normal path.
- Update commit message.

I do cross-check to determine we should release the node after
of_mdiobus_register(), refer to functions like lan78xx_mdio_init(),
ave_init() and ag71xx_mdio_probe().

v1 link: https://lore.kernel.org/r/20220526083748.39816-1-linmq006@gmail.com/
v2 link: https://lore.kernel.org/all/20220526112415.13835-1-linmq006@gmail.com/
---
 drivers/net/dsa/mv88e6xxx/chip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 5d2c57a7c708..0b49d243e00b 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3960,6 +3960,7 @@ static int mv88e6xxx_mdios_register(struct mv88e6xxx_chip *chip,
 	 */
 	child = of_get_child_by_name(np, "mdio");
 	err = mv88e6xxx_mdio_register(chip, child, false);
+	of_node_put(child);
 	if (err)
 		return err;
 
-- 
2.25.1

