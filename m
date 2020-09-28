Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98C9327A868
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 09:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726665AbgI1HRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 03:17:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726645AbgI1HRx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 03:17:53 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C129CC0613CF
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 00:17:52 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id z4so11049042wrr.4
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 00:17:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4ycumBqXo4wWAclMIbSxmeXptXhG4gvIgqWgQjMmj2w=;
        b=Q+9qDxWmgJQ34pYpJlhzSlso9xToKNSGq9GjkKj68qS4NxzOeQsRr7EZhKwEQlnDH0
         jrpjrbaQpd+0avTw4XFQOwcSvJOqO5r99tw9w+TTgLqtc4srgJn0xxEk8fcNU1U4nMnx
         AvrH0RkDBlNh7M+9Un6ayWW0r5Tg8wPBK00jrbp2k1lCkFNwHzKTBwYjLWTdBslVCO2T
         2sMvAhVYgByhrzyjEP06NM9NzI9SKex906hgZjRA3Taw7z2xuQMg2HCYwk4g4YvgdLOz
         5awHPGsK59nnefgp5Z3DiOGMfR5JeSazxAC7+DkJ5Q0spQdOLW/IsAdnhnC4dUO5UGxn
         y//A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4ycumBqXo4wWAclMIbSxmeXptXhG4gvIgqWgQjMmj2w=;
        b=q5mUFkq0LM3rUswGe5q9O0xJ8ZiaPaNiBR9onvsebcVAmeNSlegiU/ZyHPwihoYkzE
         JJHGG7XbFiH6Oa5WXUS+MvjU9lGnnLSi8ODxfDI/gtGM/n8rnAPJDzRz57N6dOOoS8VP
         YRyZuEXU0xuqRM5JqlbErW4EPJU/7B5vTnLzw91yhV7Q5Mz2kz/k37yOG7YpGxcDn3LY
         jjLP4fu+4pFL/Y8BerfOPuRR2f1QJ4iPHxISoS5ZyrfXiqFRFeXjFbtO5R+qFij44P6N
         Nod0xzegRrUNl+uMbS5AiM2PwWaijlWJEbTLND92UQgqFLVaunlOyuP6Qjg+mE0g0g3D
         0CNg==
X-Gm-Message-State: AOAM531CF6BwR8pZQgT+YAG0W3Fb1Sy4m80St8Zm/EYHokquBZLYgwPn
        Vut/OejFwBoOu3cl5dMsO76ftA==
X-Google-Smtp-Source: ABdhPJyh8Gb+No1VyK74HU4xDaw3Y5BH21qukKeTT95urlK2ippP/S0WkGxQZWJI1MfOm1E4ZArYgQ==
X-Received: by 2002:adf:edd2:: with SMTP id v18mr47344wro.242.1601277471426;
        Mon, 28 Sep 2020 00:17:51 -0700 (PDT)
Received: from debian-brgl.home (lfbn-nic-1-68-20.w2-15.abo.wanadoo.fr. [2.15.159.20])
        by smtp.gmail.com with ESMTPSA id u66sm798wmg.44.2020.09.28.00.17.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2020 00:17:50 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Yongxin Liu <yongxin.liu@windriver.com>
Subject: [PATCH] net: ethernet: ixgbe: don't propagate -ENODEV from ixgbe_mii_bus_init()
Date:   Mon, 28 Sep 2020 09:17:44 +0200
Message-Id: <20200928071744.18253-1-brgl@bgdev.pl>
X-Mailer: git-send-email 2.26.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

It's a valid use-case for ixgbe_mii_bus_init() to return -ENODEV - we
still want to finalize the registration of the ixgbe device. Check the
error code and don't bail out if err == -ENODEV.

This fixes an issue on C3000 family of SoCs where four ixgbe devices
share a single MDIO bus and ixgbe_mii_bus_init() returns -ENODEV for
three of them but we still want to register them.

Fixes: 09ef193fef7e ("net: ethernet: ixgbe: check the return value of ixgbe_mii_bus_init()")
Reported-by: Yongxin Liu <yongxin.liu@windriver.com>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 2f8a4cfc5fa1..d1623af30125 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -11032,7 +11032,7 @@ static int ixgbe_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			true);
 
 	err = ixgbe_mii_bus_init(hw);
-	if (err)
+	if (err && err != -ENODEV)
 		goto err_netdev;
 
 	return 0;
-- 
2.26.1

