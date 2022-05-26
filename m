Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7BAA534E05
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 13:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236138AbiEZLY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 07:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234891AbiEZLY0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 07:24:26 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 732FF3467E;
        Thu, 26 May 2022 04:24:25 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id n8so1208641plh.1;
        Thu, 26 May 2022 04:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XZovM0LvIQYtnt8Pn2F2x2j985TQm50Hh4lQtxRcbWE=;
        b=RjKLAPMgdPqkNk1DhDNteDMm/DIdXIOkWDJ9xu0eCudj2bb/1Sh1W2IJSYlJC4riOL
         b6XHRi3WwOoCLNqhjEgz27MYwytnX7Wj6PeYkZ82I5Qf/zpCLRi2i3K56o7VdkK0E4/i
         BSBLf+mAnQVvy/pWMx6DsI36md4xht72eFJnOHcAJ66u6HpGLnG8WSTMR4K2D2jyEFRq
         DPJnd7cP5wx7DUc1sFI8xGP5Jc5v01J61MBDX0u9g34PVHWvlYoGEXK6t66bSG5Cfw1Q
         ip+hM4AF5g9uNFQCXIEV5fNRNYCahxV1+QTrwMzkGSnNG+b7dpbpQx1DuZOoV/D6EZnm
         OQGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XZovM0LvIQYtnt8Pn2F2x2j985TQm50Hh4lQtxRcbWE=;
        b=3gg6LIk5oGMYIUV7j04IffOln3tjez2BYsbi1HC+uSEn7zxgUQUDuJT44GAATzTJ9R
         60vHPPHrseO6eY7I4ZmAyEporZbIi8nDXfuVj3poQjBxNn8bXYaMrlrhGXVJ+NBGGGMQ
         u/Z0aOLU11qkOZpbenfogGpw/iZemq892AreAg/uttAbHn1/GuFwZd6+ho7n+12DH6Ux
         7jTBA5I8dCoP1hZvxrrIjaxtomqDVuTnwVZrZo/gv+CC1KcRtJzSyXQm+wZ5mt3OFUtL
         HTdx8La12m7hU02G+7AzYQWh14LX3BZ5Kw+Eoo297PCqYRXZzPjVusY/J+LVcVgPQwc6
         F/LA==
X-Gm-Message-State: AOAM531lvwtlRRUE1gagMqioRwzx5MVOTzTGR0MuZao/wrZLxSxHLhJb
        GTH5fLi40UwSSibfvsvc8CQ=
X-Google-Smtp-Source: ABdhPJz6uqyyAM4XWpm4wBc4d5A+nz7mCK9pwb2iMr1ykxbt+N0rZaVmZ6DcyiJbUyIWCOJkxo/W5Q==
X-Received: by 2002:a17:902:ec8c:b0:161:cff5:1799 with SMTP id x12-20020a170902ec8c00b00161cff51799mr36864096plg.64.1653564264960;
        Thu, 26 May 2022 04:24:24 -0700 (PDT)
Received: from localhost.localdomain ([202.120.234.246])
        by smtp.googlemail.com with ESMTPSA id rt12-20020a17090b508c00b001dd16b86fc0sm3450859pjb.19.2022.05.26.04.24.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 04:24:24 -0700 (PDT)
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
Subject: [PATCH v2] net: dsa: mv88e6xxx: Fix refcount leak in mv88e6xxx_mdios_register
Date:   Thu, 26 May 2022 15:24:15 +0400
Message-Id: <20220526112415.13835-1-linmq006@gmail.com>
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
This function missing of_node_put() in an error path.
Add missing of_node_put() to avoid refcount leak.

Fixes: a3c53be55c95 ("net: dsa: mv88e6xxx: Support multiple MDIO busses")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
---
changes in v2:
- Add Fixes tag.
v1 link: https://lore.kernel.org/r/20220526083748.39816-1-linmq006@gmail.com/
---
 drivers/net/dsa/mv88e6xxx/chip.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 5d2c57a7c708..0726df6aeb1f 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3960,8 +3960,10 @@ static int mv88e6xxx_mdios_register(struct mv88e6xxx_chip *chip,
 	 */
 	child = of_get_child_by_name(np, "mdio");
 	err = mv88e6xxx_mdio_register(chip, child, false);
-	if (err)
+	if (err) {
+		of_node_put(child);
 		return err;
+	}
 
 	/* Walk the device tree, and see if there are any other nodes
 	 * which say they are compatible with the external mdio
-- 
2.25.1

