Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B57352E119
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 02:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343939AbiETAUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 20:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233287AbiETAUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 20:20:47 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 893DE5F95;
        Thu, 19 May 2022 17:20:45 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id r9-20020a1c4409000000b00397345f2c6fso1240831wma.4;
        Thu, 19 May 2022 17:20:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Idwq0MoqTy7Tv0jiF7ayAwzgmYGx9OERGs+EAcpebPw=;
        b=Ov9xVfVWGpqZt51a/l83grmNWtbjtyjGBR2yWEHBITKw0KKc+/hUNALLMnDDgJltCB
         e/+9DXoS430+8FVnoixT4+XTXCWANAvmad9LY8GFrNZ38mmRbtDxJQIBtq5SyB9geEWA
         cJM0pAezAhrwwNm3I7HkBSJGoXrJ6nTA1uBvb8FxUw1al4skiUgVw43t340Ht3BXI0Xk
         dhgEsJ+REiigGjSTh2z984MdBHNzUDHuUVktmZEbfiw4NKZBf2NizEqf6+i5MxzQlvLt
         ePQghLAOsXoKyexRSmJlcU1/VlwrpI0c3rRKwmTcFEQLB0wmScVlcIDCN5FMqBq/udjb
         eCjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Idwq0MoqTy7Tv0jiF7ayAwzgmYGx9OERGs+EAcpebPw=;
        b=zmcOC5Z094ZOPf1Z5IJlTmXz4rvJfA3/t6O6A3jTcb924vqsG/rfipTRg2Dqgw4RMa
         PmeLwhUMnrJSV/UfHs6xfCINU4Zvc5LLSaB+ngCDB6au3LETRJAxKKvfgEaxi4aHln8V
         qOy9An0GASpHOmc+g1TVefZHzXGgLHgPFXllgYs+EGKOTKl8Wi62eV9+wtw02vogYxjW
         yQNtZJxQ7mdHjdgRO0zGnBOvEAVxO/oNbZrGXg/mkXPIPyp29sShbnDKRY+Ehk0rj9uF
         e2zLNBtieovmbykjxCwLcN1efcVJ7lbjCtISAmgIj0CLrEWPxf+rczN56czAClDkRdTG
         E0kA==
X-Gm-Message-State: AOAM532x6w0p5dLyWmD9TscOBzxSokG9dLhY84kfD6knIap9ziNgC9re
        eO/Hf75oAGZeeF4ItcyaY60WI8uJ/nI=
X-Google-Smtp-Source: ABdhPJyFeMsMJNuOGD1dfHQxmPFPDV/myYtzKSlWsWI6oxrQdl0j+X16zMNNeJe2D2n7WrodKT1jqA==
X-Received: by 2002:a05:600c:378f:b0:397:3819:8230 with SMTP id o15-20020a05600c378f00b0039738198230mr806883wmr.10.1653006043871;
        Thu, 19 May 2022 17:20:43 -0700 (PDT)
Received: from localhost.localdomain ([41.232.195.220])
        by smtp.gmail.com with ESMTPSA id i24-20020adfa518000000b0020e5d8dbbb8sm832736wrb.56.2022.05.19.17.20.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 17:20:43 -0700 (PDT)
From:   Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
To:     netdev@vger.kernel.org
Cc:     outreachy@lists.linux.dev, roopa@nvidia.com,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-kernel@vger.kernel.org,
        eng.alaamohamedsoliman.am@gmail.com
Subject: [PATCH net-next] net: mscc: fix the alignment in ocelot_port_fdb_del()
Date:   Fri, 20 May 2022 02:20:40 +0200
Message-Id: <20220520002040.4442-1-eng.alaamohamedsoliman.am@gmail.com>
X-Mailer: git-send-email 2.25.1
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

align the extack argument of the ocelot_port_fdb_del()
function.

Signed-off-by: Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
---
 drivers/net/ethernet/mscc/ocelot_net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index be168a372498..5e6136e80282 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -775,7 +775,7 @@ static int ocelot_port_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
 static int ocelot_port_fdb_del(struct ndmsg *ndm, struct nlattr *tb[],
 			       struct net_device *dev,
 			       const unsigned char *addr, u16 vid,
-				   struct netlink_ext_ack *extack)
+			       struct netlink_ext_ack *extack)
 {
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot_port *ocelot_port = &priv->port;
-- 
2.25.1

