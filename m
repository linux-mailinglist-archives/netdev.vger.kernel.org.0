Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE2281CE99F
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 02:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbgELAYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 20:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725855AbgELAYp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 20:24:45 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF447C061A0C;
        Mon, 11 May 2020 17:24:43 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id 18so5510695pfv.8;
        Mon, 11 May 2020 17:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=eVclBX6+5fCKIGgk1HaUSZXFlkJh8mEaraU9hXmaBPk=;
        b=uMw1Usw/k6sAinab71ozPjX5Pkkzix7+DzgcywQffEWoFaxJu7w8W+aPbZSk7cNXTo
         QiaCoSMme9CIxttN+zXHbqpvEFWvzy41SElxz8/iORwpUU+meTepKE0+vGRg/qRlpI6f
         DCX2Wxj/2ljHlaeTwiY2UeF8t535ZMIM9pCf6NL9DsGS43FcSJ4vPzAfyjLXkEfcKQZk
         Xj2nCEdBre26B0aQ2d3WsvtQIBleKHa+I+PStXuE5L4IjeHKV5IhvXFrQ0yWO1Ht7LKp
         AB7nHKG/26/ACEleM8mpEqkr+VRwjbjNMEsMDxrcYokeMrN3c8eNoGRIBPrB8UieQPKd
         0S4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=eVclBX6+5fCKIGgk1HaUSZXFlkJh8mEaraU9hXmaBPk=;
        b=M/OkAMA75QEx9rYZ1+G+4oPpzXHdFOx//gJ3l6TaFJcFt2QVeZfT8FxhOWdjFgIKTt
         6RMA9dhL18k6LynS5gXQb1jhfwKB9OPqYqyxoi2St2tg+mijNRKuSe1T0ubIY1ZM/5RV
         O2n66N2mglS2Mw8Ug0k/8/1eolZE13PQ0yJQuBTzvUPUGH43Eh9vhfqdDrHxpi5HZhPq
         lxuRQ9rU4GPEL82gnYuQkd6QLj9z/mIjWaL5V2ennFSA0GijFISQxRsl8ELHzAVjRZSX
         kQYmVL98/iQKuVVvtj5yK2WMWv6zV0YGvgRZ52aDKOAQqJGxPLcJ8AtydqqvMneeUf3t
         2LOQ==
X-Gm-Message-State: AGi0PuaX21oa7NsKYptPDeHy9jSmeN6NRvOfMEEFtir3urKUfm877/IH
        XU1fqfa10iOF8YKhP9kFzlc=
X-Google-Smtp-Source: APiQypJE9LAcoziIOBmBgsA/rXH0ftU8YSEfyLcHvzr9+2jiIYG+AJxI6nA9RjMWXAliUBoVsSxFmA==
X-Received: by 2002:a62:3303:: with SMTP id z3mr17354140pfz.88.1589243083347;
        Mon, 11 May 2020 17:24:43 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 23sm9062112pgm.18.2020.05.11.17.24.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 May 2020 17:24:42 -0700 (PDT)
From:   Doug Berger <opendmb@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net-next 1/4] net: ethernet: validate pause autoneg setting
Date:   Mon, 11 May 2020 17:24:07 -0700
Message-Id: <1589243050-18217-2-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1589243050-18217-1-git-send-email-opendmb@gmail.com>
References: <1589243050-18217-1-git-send-email-opendmb@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A comment in uapi/linux/ethtool.h states "Drivers should reject a
non-zero setting of @autoneg when autoneogotiation is disabled (or
not supported) for the link".

That check should be added to phy_validate_pause() to consolidate
the code where possible.

Fixes: 22b7d29926b5 ("net: ethernet: Add helper to determine if pause configuration is supported")
Signed-off-by: Doug Berger <opendmb@gmail.com>
---
 drivers/net/phy/phy_device.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index c3a107cf578e..5a9618ba232e 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2624,6 +2624,9 @@ EXPORT_SYMBOL(phy_set_asym_pause);
 bool phy_validate_pause(struct phy_device *phydev,
 			struct ethtool_pauseparam *pp)
 {
+	if (pp->autoneg && !phydev->autoneg)
+		return false;
+
 	if (!linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT,
 			       phydev->supported) && pp->rx_pause)
 		return false;
-- 
2.7.4

