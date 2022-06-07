Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6980D53F4DC
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 06:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232560AbiFGEL6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 00:11:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbiFGEL4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 00:11:56 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E79D31A0;
        Mon,  6 Jun 2022 21:11:54 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id h1so13765709plf.11;
        Mon, 06 Jun 2022 21:11:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UCfCzCf4NUkx96d2zueeY26SzxUTen5k6udVMo2uDpQ=;
        b=ZYbPJ8exBhc6NWAIOhWBbIsMetPllVr3ZFUHUDgqAGo9jfT8KwXxxYw6+8/mtgyIyi
         bMOxZK9dZfvM5utibhjEkqfYGfsKfoAucszQtVCAXMtV/MFAOFg5Ph0JU7sTraLCQi7f
         aQ3uZDxr9CBOUZl65rVD37v0ycHPIdquQ/OQ/ekLRBmIGYVCFMPER8RCMQuUfAlpLzL3
         i6zg1E4jM01BlnKLiX6PcS5UHKKmvrIYMXqyaWSZl9qvbtq+2FL1u78jipQrZM7vuDJY
         zu7VaBWWrjHhwdoVB2vfqEOvpoEAJ2HPrBl5uTiaNjkZ1Il1gN0V8S3/0Xr2J8PNpvcA
         G3rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UCfCzCf4NUkx96d2zueeY26SzxUTen5k6udVMo2uDpQ=;
        b=O/0xpRAKfp+5vhlysRRHfncOTkgYiO/hxCftfoBlCPqk5+RRbNaYG1Ak9ywFVuKYto
         LZWd3x5anzxAo/Gk3+ihEJfNJ4HKrvwArQQYNdxfpwyALGEYdOasNkagpjUgSLmiTtIG
         XtlU9Z+1K5PRNtev+R8NI4sim8APNMKFDplrN9mCQG11HB4PocUTVjqmSOfUSYzlf+RH
         Mw30TCTl+M1TipVCcbqy6ZNzcB+7gHdzkFTzVHmIJnSNpv2sfWnabF9ryMUkld96O7dB
         wNlKz7k+mCEjaurzdrgmdsGvX6LlmUCbzs75tU7DKUNXlorTDWzCT980b3jIsO/79Om6
         eLYg==
X-Gm-Message-State: AOAM530WvzLKlZDV0AHkGOn1XTHOsLPhr8CQ8q9wQFtxl1McXVK93oSB
        TWKjG0rxQUVtw8BZiFKyggmc60dVy4w03eaY
X-Google-Smtp-Source: ABdhPJxMsP1OhPGaQDyEw4k/HjlKiiGkhQvFWGhvPa7BdA5rZjqiAoNzAtz/ymWS0Nduu20AwKy+Lw==
X-Received: by 2002:a17:902:7b83:b0:162:2486:7837 with SMTP id w3-20020a1709027b8300b0016224867837mr27344229pll.21.1654575113311;
        Mon, 06 Jun 2022 21:11:53 -0700 (PDT)
Received: from localhost.localdomain ([202.120.234.246])
        by smtp.googlemail.com with ESMTPSA id t18-20020a170902e85200b0015e8d4eb1c8sm11336604plg.18.2022.06.06.21.11.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 21:11:52 -0700 (PDT)
From:   Miaoqian Lin <linmq006@gmail.com>
To:     Joyce Ooi <joyce.ooi@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vince Bridgers <vbridgers2013@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     linmq006@gmail.com
Subject: [PATCH] net: altera: Fix refcount leak in altera_tse_mdio_create
Date:   Tue,  7 Jun 2022 08:11:43 +0400
Message-Id: <20220607041144.7553-1-linmq006@gmail.com>
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

Every iteration of for_each_child_of_node() decrements
the reference count of the previous node.
When break from a for_each_child_of_node() loop,
we need to explicitly call of_node_put() on the child node when
not need anymore.
Add missing of_node_put() to avoid refcount leak.

Fixes: bbd2190ce96d ("Altera TSE: Add main and header file for Altera Ethernet Driver")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
---
 drivers/net/ethernet/altera/altera_tse_main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/altera/altera_tse_main.c b/drivers/net/ethernet/altera/altera_tse_main.c
index a3816264c35c..8c5828582c21 100644
--- a/drivers/net/ethernet/altera/altera_tse_main.c
+++ b/drivers/net/ethernet/altera/altera_tse_main.c
@@ -163,7 +163,8 @@ static int altera_tse_mdio_create(struct net_device *dev, unsigned int id)
 	mdio = mdiobus_alloc();
 	if (mdio == NULL) {
 		netdev_err(dev, "Error allocating MDIO bus\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto put_node;
 	}
 
 	mdio->name = ALTERA_TSE_RESOURCE_NAME;
@@ -180,6 +181,7 @@ static int altera_tse_mdio_create(struct net_device *dev, unsigned int id)
 			   mdio->id);
 		goto out_free_mdio;
 	}
+	of_node_put(mdio_node);
 
 	if (netif_msg_drv(priv))
 		netdev_info(dev, "MDIO bus %s: created\n", mdio->id);
@@ -189,6 +191,8 @@ static int altera_tse_mdio_create(struct net_device *dev, unsigned int id)
 out_free_mdio:
 	mdiobus_free(mdio);
 	mdio = NULL;
+put_node:
+	of_node_put(mdio_node);
 	return ret;
 }
 
-- 
2.25.1

