Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F023F53B9E6
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 15:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235461AbiFBNgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 09:36:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235449AbiFBNgk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 09:36:40 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82EDDA339A;
        Thu,  2 Jun 2022 06:36:39 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id s12so4596449plp.0;
        Thu, 02 Jun 2022 06:36:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CYqtRMhf3hiwAxmny26ATlj89B2aT7j2j31cLRb7NFo=;
        b=N/QkVfXfuzLFS7CtYfLP5H0xPJvDYgTqu6BaHVbKtDdNTxvzCIdAorS7Q+xvvp3fOy
         CmYZWv1SrO6QwfOzSPUyFaZewIBY7SNNA6HVW7pofMVCQG01qzn20UcL8IL1DlTvxoF5
         TC2S4oMuPJybzNOZP5Bvju3lyoTBd56QgAMhDT8QRzVznHce6L7bRGfnoW4VqNfIic22
         KQ28Wc2oCpqQz9Fv8huAUar1SxmJ+HeWjyY5D3fTU1oQbkC8DXwWvC1SVA0xNB9BN7Sw
         Gi23J276to19NJWnApIQlhxwP0kffnVUfFRgFXoOL4WpWQC8CGSsZunIhy7ilGn22EiN
         qy/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CYqtRMhf3hiwAxmny26ATlj89B2aT7j2j31cLRb7NFo=;
        b=a0Olyl82iPlXvQ/q6egYumwV0a3YoIFf+x2Okes1DSP8hCVXfnfnvDOucbHmsPro4i
         8ZdeBHMrTh3TGOhPQIzu1kPTe2iAChOaNtm96QDEu0JmBitP3tTIH+17yPhLYBPsOT3/
         aacKp+LzV1Z7Rgnl6gTOecBS1ettOBP1RvmPJ0QzLUrS9Dyie1gnZE5k7WZMG3Gl8A96
         GLSg7HT3Ptcmx3eueQD+9ydMYve/KZMR53N50RmWoXG5leGOF+CIfLxRjJ+yWWhyQqPW
         oJ8sQvVgFvPgQ95rXZsT3AG27BxxJTLIwJlIxvVn1sB/NxrWtvWuHAsmeVYa5wDHMofb
         lQBg==
X-Gm-Message-State: AOAM531WeI/oL/MJxKtcWrku8ceRup7KTE/v4BhONQs7odBWMaRw+S6i
        kU3GY/IRg2SrHTun0BeBhjfYGI/WZHRSx457d/A=
X-Google-Smtp-Source: ABdhPJwn+N4ftxqLaaFHmqmB5fFV7zWz2efb3dQmSH5zr9NZ+eYzHHyhJ1tHgcxVwJMf2GkjXdsAsw==
X-Received: by 2002:a17:90a:8909:b0:1e0:bba8:32c3 with SMTP id u9-20020a17090a890900b001e0bba832c3mr40564809pjn.39.1654176999074;
        Thu, 02 Jun 2022 06:36:39 -0700 (PDT)
Received: from localhost.localdomain ([202.120.234.246])
        by smtp.googlemail.com with ESMTPSA id d17-20020a63d651000000b003f24d67d226sm3263566pgj.92.2022.06.02.06.36.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jun 2022 06:36:38 -0700 (PDT)
From:   Miaoqian Lin <linmq006@gmail.com>
To:     =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     linmq006@gmail.com
Subject: [PATCH] net: ethernet: bgmac: Fix refcount leak in bcma_mdio_mii_register
Date:   Thu,  2 Jun 2022 17:36:29 +0400
Message-Id: <20220602133629.35528-1-linmq006@gmail.com>
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
incremented, we should use of_node_put() on it when not need anymore.
Add missing of_node_put() to avoid refcount leak.

Fixes: format:55954f3bfdac ("net: ethernet: bgmac: move BCMA MDIO Phy
code into a separate file")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
---
 drivers/net/ethernet/broadcom/bgmac-bcma-mdio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/bgmac-bcma-mdio.c b/drivers/net/ethernet/broadcom/bgmac-bcma-mdio.c
index 086739e4f40a..9b83d5361699 100644
--- a/drivers/net/ethernet/broadcom/bgmac-bcma-mdio.c
+++ b/drivers/net/ethernet/broadcom/bgmac-bcma-mdio.c
@@ -234,6 +234,7 @@ struct mii_bus *bcma_mdio_mii_register(struct bgmac *bgmac)
 	np = of_get_child_by_name(core->dev.of_node, "mdio");
 
 	err = of_mdiobus_register(mii_bus, np);
+	of_node_put(np);
 	if (err) {
 		dev_err(&core->dev, "Registration of mii bus failed\n");
 		goto err_free_bus;
-- 
2.25.1

