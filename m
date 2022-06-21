Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 290835535B8
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 17:18:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352557AbiFUPRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 11:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352490AbiFUPQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 11:16:59 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE4CB109;
        Tue, 21 Jun 2022 08:16:58 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id g25so28167643ejh.9;
        Tue, 21 Jun 2022 08:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=95mCwgax+ShiY3rZJmD43+ctF9Ln7PyYSbeuv7YrQLM=;
        b=RLtFZb/RqEQHG27L5SUgg8W5LVjagbvR1id0S26CmWB95X9t8+Wu4O4NwoeJ/bYGJL
         AAjNLPcwBvAzUwGFvqcYDgBHnzTwemd95RE96OjZpqAMuhWIghQYgTJlQTH7c6ex0sij
         8uTX12moGDmTkSDuXRZkpnBbIdv/LF3nOgPYzjurAWoLRe+DGMMQ+5DOuhgNrogBoSNQ
         tUtaiTMjBOzmmlANaP+rHr/L8j+3yGbH0tA9+x4PC3dCwr0Z0M+ZV7RV2Mv1Yk3hzaXV
         c54fbPSY1jSHUz7OGL2UcTsI4OOgt04G1YG07GD8epo0eeZxj2aAFYgT228lWmk4MN4+
         i5Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=95mCwgax+ShiY3rZJmD43+ctF9Ln7PyYSbeuv7YrQLM=;
        b=GYcubnEUQMlp0L787TeQW/lY6TT6pg5xXslIq0QLCb0tudX4nKSJROqGsCNQLscZON
         9Dm1g2MOvt2USDbY8NFe4Ym/emPFl2eDeWEMNhOAIUQORwPFOePmGFOp0maOgtvWZ+gC
         JEjUy7UnnK82c/P4TXfgRoUVlsY5Ch4WgzmdddHZWfDrSOK6cFqwR0/7UFlWDZHh97or
         MTVg0qTHujYNkRDhypKGXSrjbBs6kM4p1RPMRn+xFYNlCXaoGAtyHqZav5tFVmBpUPN9
         Lap+zZVKneNDvojMCfbX36roemDoa6J0Mv5F0qExwPrdJ3a6XH4cKUBE5EHPbkWpsHRj
         RITQ==
X-Gm-Message-State: AJIora/uIvribgyLWZA02aXx26Zf9q32Vf0D+RuP0gj6HqiAIwFX2/SI
        m22SAqr74jdNob03RQhMuok=
X-Google-Smtp-Source: AGRyM1vM3Ki/bAk3HQzQ8Q1GJGv4OVHU2SqSqDvpfcbZ7wxpnV419YIS+zqx1+Qwkl93X443JfBicg==
X-Received: by 2002:a17:907:3e86:b0:6f5:917:10cc with SMTP id hs6-20020a1709073e8600b006f5091710ccmr25162220ejc.53.1655824617225;
        Tue, 21 Jun 2022 08:16:57 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id qw21-20020a1709066a1500b0070c4abe4706sm396960ejc.158.2022.06.21.08.16.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 08:16:56 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ansuel Smith <ansuelsmth@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2] net: dsa: qca8k: reduce mgmt ethernet timeout
Date:   Tue, 21 Jun 2022 17:16:33 +0200
Message-Id: <20220621151633.11741-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current mgmt ethernet timeout is set to 100ms. This value is too
big and would slow down any mdio command in case the mgmt ethernet
packet have some problems on the receiving part.
Reduce it to just 5ms to handle case when some operation are done on the
master port that would cause the mgmt ethernet to not work temporarily.

Fixes: 5950c7c0a68c ("net: dsa: qca8k: add support for mgmt read/write in Ethernet packet")
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
v2:
- Split from the original series to prose it as single
  to net-next while the stable mtu patch gets accepted.
- Add fixes tag

 drivers/net/dsa/qca8k.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 04408e11402a..ec58d0e80a70 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -15,7 +15,7 @@
 
 #define QCA8K_ETHERNET_MDIO_PRIORITY			7
 #define QCA8K_ETHERNET_PHY_PRIORITY			6
-#define QCA8K_ETHERNET_TIMEOUT				100
+#define QCA8K_ETHERNET_TIMEOUT				5
 
 #define QCA8K_NUM_PORTS					7
 #define QCA8K_NUM_CPU_PORTS				2
-- 
2.36.1

