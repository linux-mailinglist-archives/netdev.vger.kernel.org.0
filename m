Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D35A63C4E0
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 17:13:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236042AbiK2QNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 11:13:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235848AbiK2QNV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 11:13:21 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0633F65E48
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 08:12:51 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id p24so10132844plw.1
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 08:12:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=j/5pIy0y3J44dCNpZqZCoJvBohGy2JDpkFnXTutTPxY=;
        b=aP6bOGR1oh4nzcPditMTGXp7QcJeCUxgLxuPrZaBU05BKMefPLGv+/3VaTEJXLxBhQ
         sBT/F3SN7z3dB6mGxloq3nU0z9ZizXdd7f5+6u4ofilXrngfYRIIZV60r8+vjqTyxCB/
         RAPmfAyGzBEAoPSilxNIpkFmKgetFMGMMRb5BEeX7BmSTAaS9N0nUdEzr3AF9dc3jsYJ
         ZUHLxpWYuPRDg0YcfSACC00Z5wOGZppArEhB/W4KUXBuK/fPl44i6NwsJYFBZ/7g+jBL
         f8HfS8zpvijaKk5M62fFzuRgfAM7SJVbiKM0Sjjum6+ji1Y+Uz1LfpKM+qvTsdvpLMdJ
         SWSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j/5pIy0y3J44dCNpZqZCoJvBohGy2JDpkFnXTutTPxY=;
        b=sq90r2bW+s9TLZqp2G1z4jlTpKMJstMEnE23s86A7sXt9Gnh6pEmHOKUquB1iyUWuR
         0CUXj5le9XIfd4zJuUE/ntZqKzrRf0nDM3PV3VufpwnBOU4W2si/fwC9NO26hwHn2nnG
         rTwvIfGwzLPWwEGdQbE6ZoEeKfp0lhjvD+GVDhOzmJGYnI6XBP0NZWkVcnPwf22muAEn
         htoNwBTJKqU7DAEqtNNMMZOn+LAi8byRzTRIurt5uJQ4brwLyFIie1XVjawVsakNo14D
         /ShjDUwohIzFmygwg8/0SVYWSFqUq0SZ2c2SM/oD/Y5rutetM+7Pgh0oT8A536V9kzXb
         6byQ==
X-Gm-Message-State: ANoB5pmf0u7/WM3yZMhULZmb6kGaApfq/AgukByqZdzKR1JuFbK751lF
        JZsbvsGGJ+vkwBfXgYAdYRKZTbShP8R4Dx7/
X-Google-Smtp-Source: AA0mqf6hAY7oq2VeZtu60Lc9lLIrFYVdXW5jEAryT+wAijCJaZtSKPiZ2vOVTwWm+BwnMpfNYHu9Zg==
X-Received: by 2002:a17:90a:a381:b0:218:6dc3:55b8 with SMTP id x1-20020a17090aa38100b002186dc355b8mr60408623pjp.189.1669738371212;
        Tue, 29 Nov 2022 08:12:51 -0800 (PST)
Received: from kvm.. ([58.76.185.115])
        by smtp.gmail.com with ESMTPSA id x62-20020a623141000000b00572275e68b2sm10078258pfx.116.2022.11.29.08.12.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Nov 2022 08:12:50 -0800 (PST)
From:   Juhee Kang <claudiajkang@gmail.com>
To:     hkallweit1@gmail.com, nic_swsd@realtek.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Cc:     Juhee Kang <claudiajkang@gmail.com>
Subject: [PATCH, net-next] r8169: use tp_to_dev instead of open code
Date:   Wed, 30 Nov 2022 01:12:44 +0900
Message-Id: <20221129161244.5356-1-claudiajkang@gmail.com>
X-Mailer: git-send-email 2.34.1
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

The open code is defined as a helper function(tp_to_dev) on r8169_main.c,
which the open code is &tp->pci_dev->dev. The helper function was added
in commit 1e1205b7d3e9 ("r8169: add helper tp_to_dev"). And then later,
commit f1e911d5d0df ("r8169: add basic phylib support") added
r8169_phylink_handler function but it didn't use the helper function.
Thus, tp_to_dev() replaces the open code. This patch doesn't change logic.

Signed-off-by: Juhee Kang <claudiajkang@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 5bc1181f829b..ec157885da13 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4559,12 +4559,13 @@ static int rtl8169_poll(struct napi_struct *napi, int budget)
 static void r8169_phylink_handler(struct net_device *ndev)
 {
 	struct rtl8169_private *tp = netdev_priv(ndev);
+	struct device *d = tp_to_dev(tp);
 
 	if (netif_carrier_ok(ndev)) {
 		rtl_link_chg_patch(tp);
-		pm_request_resume(&tp->pci_dev->dev);
+		pm_request_resume(d);
 	} else {
-		pm_runtime_idle(&tp->pci_dev->dev);
+		pm_runtime_idle(d);
 	}
 
 	phy_print_status(tp->phydev);
-- 
2.34.1

