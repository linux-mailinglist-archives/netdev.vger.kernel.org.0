Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC747526151
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 13:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380005AbiEMLqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 07:46:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiEMLq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 07:46:29 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D55491CB22
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 04:46:25 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id j12so9833055oie.1
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 04:46:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4N1T/RG64MaJ9K2EPr9r4NPNoZ7d/jiFoWOLU7hUaCk=;
        b=mK3Nnsy+szG2jzQB2ofRgVA69xXzHyPm0DWHvJ6cxgma6eixU6APn5VTy2131BbbXJ
         6EO3jsSj/eY9U106SaOCt+JdfrgEHJzjlVGNJyiZ3ul5+MgcUbw+2lhVQlJJEp9jo0AI
         rwkitiSwnpNnt1MGzSsyVJAeeJ6AFCUtnSFmFCNL0F8Sd4RpcbghnzoPlVpfiTUPLXbm
         Zp5E04PjT0M3fQX69R1F45/KrqtFlKqCtm/BzMbW2jwnzg96TL4WigdZn2TRMXzAaj8p
         ZXYJRCXhE8pC5L6G88FfVYbrH/vEQl7D7hOIjHCPTACcRPzsOSKvOPZCC+ToMXiV9jqZ
         8qmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4N1T/RG64MaJ9K2EPr9r4NPNoZ7d/jiFoWOLU7hUaCk=;
        b=DlMz0yfj7IKGbtN04eNwP5gvT7FJEsqX2V+kkFV3VniGyF826s8Nw1G+y9qRVXfvOE
         8LsqN9TsvfxZTNWOkDIiVXK85eH6oZuROl1m6dWZgIy9f+BEFE9g65MyjV0QOaPGIsqv
         cw+g9iemvF+XiUxuClQkHgFPwsrO8dk/xNIxEs/4+qhPoh1Nwe95qgN9Wd6jUp/ki2ep
         AAkq1m7ZJ+Qc9k4HNiYZ1QHfaL5MU2HGKwPQ57gw5Ob59arlDwLQbwa0g9BCe2nEBma2
         22fvE5I0WS/t2V+4E48BGFxYDASO177fV9BtwarjioNDA//RSzrN4gv9MbEg1CjvfeQf
         u0hQ==
X-Gm-Message-State: AOAM5312t1SKpCOTzHDBw5O6I6PZnjtzHir6gSxawQ2EwEdulaVu70G2
        8XuZPxnmKv8EiyskaHJCJJ+pm6te8XuOMw==
X-Google-Smtp-Source: ABdhPJwCD9oxyyklkqXdpIxJl/0d/ctsVYIblkgBfSgjnEBAEj0nfkF62bwsx1Sun0geRRFO8NlTAA==
X-Received: by 2002:a05:6808:1155:b0:326:795e:1e07 with SMTP id u21-20020a056808115500b00326795e1e07mr7474017oiu.296.1652442385217;
        Fri, 13 May 2022 04:46:25 -0700 (PDT)
Received: from localhost.localdomain ([2804:14c:485:4b69:7c3a:c7b:fd8a:c501])
        by smtp.gmail.com with ESMTPSA id b18-20020a9d6b92000000b00606b1f72fcbsm872458otq.31.2022.05.13.04.46.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 04:46:24 -0700 (PDT)
From:   Fabio Estevam <festevam@gmail.com>
To:     kuba@kernel.org
Cc:     davem@davemloft.net, andrew@lunn.ch, netdev@vger.kernel.org,
        Fabio Estevam <festevam@denx.de>
Subject: [PATCH net-next 2/2] net: phy: micrel: Use the kszphy probe/suspend/resume
Date:   Fri, 13 May 2022 08:46:13 -0300
Message-Id: <20220513114613.762810-2-festevam@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220513114613.762810-1-festevam@gmail.com>
References: <20220513114613.762810-1-festevam@gmail.com>
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

From: Fabio Estevam <festevam@denx.de>

Now that it is possible to use .probe without having .driver_data, let
KSZ8061 use the kszphy specific hooks for probe,suspend and resume,
which is preferred.

Switch to using the dedicated kszphy probe/suspend/resume functions.

Signed-off-by: Fabio Estevam <festevam@denx.de>
---
 drivers/net/phy/micrel.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 5e356e23c1b7..22139901f01c 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -3019,11 +3019,12 @@ static struct phy_driver ksphy_driver[] = {
 	.name		= "Micrel KSZ8061",
 	.phy_id_mask	= MICREL_PHY_ID_MASK,
 	/* PHY_BASIC_FEATURES */
+	.probe		= kszphy_probe,
 	.config_init	= ksz8061_config_init,
 	.config_intr	= kszphy_config_intr,
 	.handle_interrupt = kszphy_handle_interrupt,
-	.suspend	= genphy_suspend,
-	.resume		= genphy_resume,
+	.suspend	= kszphy_suspend,
+	.resume		= kszphy_resume,
 }, {
 	.phy_id		= PHY_ID_KSZ9021,
 	.phy_id_mask	= 0x000ffffe,
-- 
2.25.1

