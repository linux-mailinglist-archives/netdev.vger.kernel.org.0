Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7876760CB75
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 14:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbiJYMB4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 08:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230480AbiJYMBz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 08:01:55 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A709804B7
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 05:01:44 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id r13-20020a056830418d00b0065601df69c0so7531154otu.7
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 05:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=f/kp4w6q08Cw30jFLnKjwZVPT27NC0Hru3r+b7ePzyw=;
        b=OtcW2yK+g+hspATbJKkJThlXk93LSHIrqzQJG5Jz0nlQWf83W/biE4kav9/YQoWjBa
         3lLu2/xzX16W7NI/iph4zGp8MmhG8qEQFr6n/X3pyRNbHkrMAVlKJ1es/InvC5vuLbuE
         xx7xk+FDfaY6ueR7BRj4n7kTyQtOVSSndyXDGVI5tk0EauC3yuSFnjnAzWr5kYhT+ZnX
         XjmSxEbskEtT3TOpyH+9hpByEKZ+T4k84GDg6OZDpAyEIB5ukLimj1ktSOawFm/Stgpc
         BszNuBJxWZHpAZzVifNJsxyqBqEsKuF8UJ5fRyFvuenafnpBabrEIH/QzUYjiI6u/4+a
         4PGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f/kp4w6q08Cw30jFLnKjwZVPT27NC0Hru3r+b7ePzyw=;
        b=esI4tqVt09F6m9CZY57K+yS87Yxb7mgvS4QvxBPdncstNMn0yV+a+vezKSxXGZtlNs
         zFlJldrj8OPQ7phryzTvQttiVui0bLGEvwI4iPVgrEUi/PW4F607YJMLJg4w92diwMU/
         3FjmyLFH5yG+9swLPzTxUMS+JcIqUksHx0HOq9Ptf+FXxN7Uz+JYDR5/BF+1gzQxS/kE
         kFUTxjTohpPWwtVrCf4X6gv9FWpmsYKF09UF10BcVPVGB2we2Po2NBvDfpLGxz6Coezb
         nyIsPHYInzxJkUyBbWdgjyP8UygIv4Qw6F6chs9ty9Ab/Yhlvbr5vYX1bGstNbVWEL0H
         2RxA==
X-Gm-Message-State: ACrzQf0Z1w5MJCtOU6zKwd9SeeoGKUp72pCy8CYQ5WkzAhcW/ZF6hyKA
        itqMIU6BNmPtt5m9ei0fkJ0=
X-Google-Smtp-Source: AMsMyM5lS+TnQnMabZGTOCvyVE1vclru/FugV2UuYD4OY6kCYLQnpV+kyP/NQ3K/YYULZjXIwP9ZlQ==
X-Received: by 2002:a05:6830:6611:b0:662:2725:d309 with SMTP id cp17-20020a056830661100b006622725d309mr10003671otb.293.1666699304272;
        Tue, 25 Oct 2022 05:01:44 -0700 (PDT)
Received: from localhost.localdomain ([2804:14c:485:4b69:4d1d:ed8c:e4e:65cb])
        by smtp.gmail.com with ESMTPSA id c23-20020a056808105700b0035486165f4csm857227oih.37.2022.10.25.05.01.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Oct 2022 05:01:43 -0700 (PDT)
From:   Fabio Estevam <festevam@gmail.com>
To:     kuba@kernel.org
Cc:     andrew@lunn.ch, dmurphy@ti.com, netdev@vger.kernel.org,
        Fabio Estevam <festevam@gmail.com>
Subject: [PATCH net-next] net: dp83822: Print the SOR1 strap status
Date:   Tue, 25 Oct 2022 09:01:09 -0300
Message-Id: <20221025120109.779337-1-festevam@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During the bring-up of the Ethernet PHY, it is very useful to
see the bootstrap status information, as it can help identifying
hardware bootstrap mistakes.

Allow printing the SOR1 register, which contains the strap status
to ease the bring-up.

Signed-off-by: Fabio Estevam <festevam@gmail.com>
---
 drivers/net/phy/dp83822.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/phy/dp83822.c b/drivers/net/phy/dp83822.c
index b60db8b6f477..a6f05e35d91f 100644
--- a/drivers/net/phy/dp83822.c
+++ b/drivers/net/phy/dp83822.c
@@ -524,6 +524,8 @@ static int dp83822_read_straps(struct phy_device *phydev)
 	if (val < 0)
 		return val;
 
+	phydev_dbg(phydev, "SOR1 strap register: 0x%04x\n", val);
+
 	fx_enabled = (val & DP83822_COL_STRAP_MASK) >> DP83822_COL_SHIFT;
 	if (fx_enabled == DP83822_STRAP_MODE2 ||
 	    fx_enabled == DP83822_STRAP_MODE3)
-- 
2.25.1

