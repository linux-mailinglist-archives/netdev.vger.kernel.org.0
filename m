Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 371C4534BD7
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 10:38:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237224AbiEZIiC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 04:38:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233597AbiEZIiA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 04:38:00 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A72C8D697;
        Thu, 26 May 2022 01:37:59 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id l20-20020a17090a409400b001dd2a9d555bso1196756pjg.0;
        Thu, 26 May 2022 01:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xf0m+cxj00ml2J9yglsVjh3XZlLBOWXtU5mmNEGwQ3U=;
        b=i642uYY+wNCW0IASrgCRqqUrpcyvz5d7Y5qfZhMhirG9Tm3cfZwhsci4yxhdFfngQS
         iiLYP2kYMX2o8DP7FpRPczN05j8zdJOm6GzMxIRc++95E4XlXesmhSLzVE45TbbXvRtO
         2IA3/6rGlxgRyhXT2zHzL073VKF2HjW5jrH8MCB/IfSaNRTHB8ZrWS7/xyhwEzW4cZ5q
         qhCDS4D+LmZfEruPup0LJjJ1ijKFKsxsCE0dd0zTHO5q9etGVnslIQHQap4RdKqJbwhE
         pbi8NMbo3e4Q22lYdpf1ytGoC23bbj8zimwxRuVIT3cCSptA1tEQRnm4cwqzh6uB6cxz
         WzAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xf0m+cxj00ml2J9yglsVjh3XZlLBOWXtU5mmNEGwQ3U=;
        b=Cv9xWbAY60BNqCiGF+VyJf/Gerr+yRHpPhLVpEZmHua4ubmUjA5myFtjKdA1iAnXiW
         IzOuMPhus89IKCqyC05xjDCdrhuAm6jom8PHi1P9imQ8Gse41JFzF9L56wPj1/5it3AC
         P/o3mz06W8MMQ/51ClfQF7Omza64Yp6kfye4lTCm7bW9AZPWD8WqLz2RBnvLDMfK7W45
         47/AJUf1bllvFpCloZh68PNYuPVIePny0vSrBVGONLLIToI7stjEDMLA6T8aCmeMbTgO
         hnsX0fgA3JB6sms3DUPVApIPyXTc6KVx1JIWVJLCj2lx7YWet5d6GCgcVMlYdG3rgqr3
         grzA==
X-Gm-Message-State: AOAM531xUFtdBHb2G8WiXcxnpc/5T+iR48eoeUTgLw4gOlZ5KdJZApuu
        0Ft2ZejcK/4P2b+qplJQjxw=
X-Google-Smtp-Source: ABdhPJyomcwLo5TPDTRup87oeopH9IDzFzWCv42VuwnRK/LOPPEHKHcBE48P9ZU4tHOxHqOHHKMwJw==
X-Received: by 2002:a17:90a:31cf:b0:1c9:f9b8:68c7 with SMTP id j15-20020a17090a31cf00b001c9f9b868c7mr1510376pjf.34.1653554278500;
        Thu, 26 May 2022 01:37:58 -0700 (PDT)
Received: from localhost.localdomain ([202.120.234.246])
        by smtp.googlemail.com with ESMTPSA id k71-20020a63844a000000b003db7de758besm964332pgd.5.2022.05.26.01.37.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 01:37:58 -0700 (PDT)
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
Subject: [PATCH] net: dsa: mv88e6xxx: Fix refcount leak in mv88e6xxx_mdios_register
Date:   Thu, 26 May 2022 12:37:48 +0400
Message-Id: <20220526083748.39816-1-linmq006@gmail.com>
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

Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
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

