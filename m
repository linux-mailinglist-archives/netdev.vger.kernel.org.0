Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E047575CCB
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 09:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231480AbiGOHwA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 03:52:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231152AbiGOHv7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 03:51:59 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F8797968E;
        Fri, 15 Jul 2022 00:51:58 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id r186so3753933pgr.2;
        Fri, 15 Jul 2022 00:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vbSHf48BhvIJZr2j+0ZNh16mnf1g2t5iGQ0q6TIKadA=;
        b=LIulgRG5+wx0QlFFLVE1qIgtt5bLPhvnyQ0PpipnL2GEFAEU5/2gLdCPgus1QKbWAg
         u5c2BC4K6dn8T1vD/qkeWs/1B/P7BKNZKPB67jg31kGS9fclsqHp4tt+K6g3UkpvMIwl
         Y0cAUmCTzSJLInyrn3Ag8i4BxuZYwihi/DBXr6ZPUELW4qZPa8AdDPkCjD44cXTSAudN
         sDw6iP6l3bK7in6bwjqH7NAk8UvnVLLBKoJUTC0yNy+8Nv9UDAJGPyfIqYLbgJT6OiHo
         aJdPprkthHXh7M3H0akMn070LfKeGU5aCojpN9D4kM1/q2QdbdUL/T8CK+M+Y36DudWJ
         4hMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vbSHf48BhvIJZr2j+0ZNh16mnf1g2t5iGQ0q6TIKadA=;
        b=WN1hDeq5THLYjUi0y6CVzZ2v1VlJ3rM4ZGcxdQjbsxNT0ZfKNq3yXdCI1zFuz9aFJD
         mq0+pWXGghK2DCoC8jZgs4NErkPhBr5pd3i9GWNUtcRqJL+/1zwwFlQ8v250Ddn5Pv01
         le4eTKrmMGBRXic1Q5FB4N/is8CI/BVULiSaeK19F3d27SkKSsvf8+eFzsNRIZcV85H6
         fjJOUfnfBs3dYbYaU4psRs5jjw0uprsSfECcxxLdae9xHlEKD0jN4L/o1BYBl4ZipjTK
         o794Zzv3ti5Pq2Vz/XXvbQh26d3F3jukA8re42Aju75BRds0YOjTOSJu/+f9T+syIV/l
         Cpbw==
X-Gm-Message-State: AJIora+GKlBCDoNoPS7CwIrMplf6OT/75KTw6xmGbiHbISRfQOn58Rsq
        G2qs2BYjORybXrEFNIyXqAoH0V2hF68=
X-Google-Smtp-Source: AGRyM1t5iJZPd+PQC4s912t84T0RzZV47+mgse88grBeiIfBm/oGYJQvLUvQPTiT91BkrB2VFIFzhA==
X-Received: by 2002:a63:f952:0:b0:412:8852:80fe with SMTP id q18-20020a63f952000000b00412885280femr11196836pgk.194.1657871517892;
        Fri, 15 Jul 2022 00:51:57 -0700 (PDT)
Received: from DESKTOP-8REGVGF.localdomain ([211.25.125.254])
        by smtp.gmail.com with ESMTPSA id h10-20020aa79f4a000000b00528d880a32fsm3037147pfr.78.2022.07.15.00.51.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 00:51:57 -0700 (PDT)
From:   Sieng-Piaw Liew <liew.s.piaw@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Sieng-Piaw Liew <liew.s.piaw@gmail.com>
Subject: [PATCH net-next v2] atl1c: use netif_napi_add_tx() for Tx NAPI
Date:   Fri, 15 Jul 2022 15:50:43 +0800
Message-Id: <20220715075043.912-1-liew.s.piaw@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220714213857.45d4bf3e@kernel.org>
References: <20220714213857.45d4bf3e@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use netif_napi_add_tx() for NAPI in Tx direction instead of the regular
netif_napi_add() function.

Signed-off-by: Sieng-Piaw Liew <liew.s.piaw@gmail.com>
---
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 948584761e66..a6d55f452e2f 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -2734,8 +2734,8 @@ static int atl1c_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		netif_napi_add(netdev, &adapter->rrd_ring[i].napi,
 			       atl1c_clean_rx, 64);
 	for (i = 0; i < adapter->tx_queue_count; ++i)
-		netif_napi_add(netdev, &adapter->tpd_ring[i].napi,
-			       atl1c_clean_tx, 64);
+		netif_napi_add_tx(netdev, &adapter->tpd_ring[i].napi,
+				  atl1c_clean_tx);
 	timer_setup(&adapter->phy_config_timer, atl1c_phy_config, 0);
 	/* setup the private structure */
 	err = atl1c_sw_init(adapter);
-- 
2.17.1

