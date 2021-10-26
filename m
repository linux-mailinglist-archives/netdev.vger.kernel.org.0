Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2556443B860
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 19:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237895AbhJZRmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 13:42:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237863AbhJZRmR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 13:42:17 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED790C061745;
        Tue, 26 Oct 2021 10:39:53 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id y15-20020a9d460f000000b0055337e17a55so20868637ote.10;
        Tue, 26 Oct 2021 10:39:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rk9hVs8yl6n5oEZg23jvhLkzNOFKTFUVe0+4+6775yQ=;
        b=olUfx/ut74bEs2HhbrQV3cABsvc6zBlmOl0YHnicweGrgSD+I5RfSLooWT1Ob8L8LX
         OgSN8dYeqG0/Z4FnukGQnGJLifQ1hJakndg+2o3UHe5rSCKSVgypYIPBrReu5UmN/ufO
         A3kWd9ERllLFMP5Nqt0ueWENMZNUoSYjcZFaXMJIryf/vh4M2XajqZgdJwyiEPPzRh38
         gGWCkLsRoOZb5THc0Asl9gon/ZIVdZqpV4EN3qat2IxWtHc6kN3cLPgjfkSpgRjUg1kI
         d5YxDuCYXudUtyllIzP87yydLMkSXxzpt+WXiJMHFBaZW57A+zpJfSs8wX4HiJkplA03
         xjEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=rk9hVs8yl6n5oEZg23jvhLkzNOFKTFUVe0+4+6775yQ=;
        b=CVoFfpD3nbPUZKYpoXg8Xv+IpJ57Okj3hsZksq7bG/jsPIldHx6NifCQBlpjZ4aPaN
         C6+TSEVRFGFhR1jmcN5wYtyoW1Z40o841Qkw6w1C5zqofksyJHPctQODh1nGkDoVS+DN
         0DDgptutAIaxZrLFD3A8EvUSRkCh/vAZ/rDuXZzd+ZPV1KM/XjZg/rsnbe/EZQMSnAeR
         HDpJZhyBlxWIKb2BmE8qrV+LrwTci2vYn+k4HhuAc/OCvCrTkh1hzu+kwqrVLk6zlbY0
         kMeheEF6MRUm2jjv7L40bWOOjkft+3NXSkzgdNn/hYlA/Zt9FeXr8EL0BFKTZQT7RlGG
         tMDg==
X-Gm-Message-State: AOAM533/pNk/uoqb44tjKSPJslU90r01t3/Jz2tNm0D4CbOU3QjVL8iz
        b7EOEMxKPMKHwKBSPZIjH84=
X-Google-Smtp-Source: ABdhPJyPiLohQxnr53jSHBZjzF8KFYzPn54fRxBGTe06lPYzBeYfCz7BSsUtC/sMm1k/y3nKnAqNCQ==
X-Received: by 2002:a9d:d68:: with SMTP id 95mr3424731oti.377.1635269993301;
        Tue, 26 Oct 2021 10:39:53 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 70sm23105otn.74.2021.10.26.10.39.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 10:39:52 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
To:     Nicolas Ferre <nicolas.ferre@microchip.com>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Sean Anderson <sean.anderson@seco.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH] net: macb: Fix mdio child node detection
Date:   Tue, 26 Oct 2021 10:39:50 -0700
Message-Id: <20211026173950.353636-1-linux@roeck-us.net>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 4d98bb0d7ec2 ("net: macb: Use mdio child node for MDIO bus if it
exists") added code to detect if a 'mdio' child node exists to the macb
driver. Ths added code does, however, not actually check if the child node
exists, but if the parent node exists. This results in errors such as

macb 10090000.ethernet eth0: Could not attach PHY (-19)

if there is no 'mdio' child node. Fix the code to actually check for
the child node.

Fixes: 4d98bb0d7ec2 ("net: macb: Use mdio child node for MDIO bus if it exists")
Cc: Sean Anderson <sean.anderson@seco.com>
Cc: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/net/ethernet/cadence/macb_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 309371abfe23..ffce528aa00e 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -901,7 +901,7 @@ static int macb_mdiobus_register(struct macb *bp)
 	 * directly under the MAC node
 	 */
 	child = of_get_child_by_name(np, "mdio");
-	if (np) {
+	if (child) {
 		int ret = of_mdiobus_register(bp->mii_bus, child);
 
 		of_node_put(child);
-- 
2.33.0

